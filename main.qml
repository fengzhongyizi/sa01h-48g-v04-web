import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import SerialPort 1.0
import NetManager 1.0
import TerminalManager 1.0
import FileManager 1.0
import WebSocketServer 1.0
import CHT8310 1.0

Window {
    id: window
    visible: true
    minimumHeight: 1200
    maximumHeight: 1200
    minimumWidth: 1920
    maximumWidth: 1920
    title: qsTr("SG01H-48G-V04")

    flags: Qt.FramelessWindowHint | Qt.Window

    property int typecmd:0
    property string command_header: "AA 00 00 "
    property string command_length: "06 00 "
    property string command_group_address: "00 "
    property string command_device_address: "00 "
    property string strcode: "61 00 "
    property string hexString: "61 00 "
    property alias virtualKeyboard: virtualKeyboard
    property TextField currentInputField: null
    property string syscmd: ""
    property string version: "V0.11"
    property string completeString: ""
    property bool isBlack: false
    property string upgradetype: "rk3568"

    BatteryIndicator {
        id: batteryIndicator
        batteryLevel: 30
        isCharging:true
    }

    MouseArea {
       anchors.fill: parent
       onClicked: {
           if (virtualKeyboard.visible && !virtualKeyboard.contains(Qt.point(mouse.x, mouse.y))) {
               virtualKeyboard.visible = false;
           }
           while(isBlack){
               serialPortManager.writeData("AA 00 00 06 00 00 00 6D 80",typecmd);

           }
           systemSetup.powerbtn_flag = 0;
       }
   }

    Rectangle {
        id: lowBatteryPopup
        width: 2000
        height: 1500
        z:11
        color: isBlack ? "#000000" : "transparent"

    }


    VirtualKeyboard {
        id: virtualKeyboard
        width: window.width-mainline.width
        height: 400
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: false

        onKeyPressed: {
            if (currentInputField) {
                var text = currentInputField.text;
                var cursorPos = currentInputField.cursorPosition;
                if (key === "Backspace") {
                    if (currentInputField.cursorPosition > 0) {
                        currentInputField.text = text.slice(0, cursorPos - 1) + text.slice(cursorPos);
                        currentInputField.cursorPosition = cursorPos - 1;
                    }
                } else {
                    currentInputField.text = text.slice(0, cursorPos) + key + text.slice(cursorPos);
                    currentInputField.cursorPosition = cursorPos + 1;
                }
                currentInputField.forceActiveFocus();
            }
        }
    }

    TerminalManager {
        id: terminalManager
        onCommandOutputChanged:{
//            console.log("fpga process:",output);
            if(output.indexOf("fpga process")!=-1){
                var tmpprocess = output.split(" ");
                webSocketServer.sendMessageToAllClients("PROGRESSVALUE||"+ tmpprocess[2] +"\r\n");
                if(parseInt(tmpprocess[2],10)===100){

                    webSocketServer.sendMessageToAllClients("UPGRADELOG||FPGA upgrade success\r\n");
                }
            }

        }
    }

    FileManager {
        id: fileManager
    }

    CHT8310 {
        id: cht8310
        i2cDevice: "/dev/i2c-3"

        onDataUpdated: {
//            console.log("Updated data - Temp:", temperature, "Hum:", humidity);
            systemSetup.chip_aux_fpga.text = temperature.toFixed(1) +"°C";
            webSocketServer.sendMessageToAllClients("RESPONSE||F859||"+"17," + temperature.toFixed(1) +"\r\n");
        }

        onErrorOccurred: {
            console.log("cht8310 error:",error);
        }
    }

    function upgraderk3568(){
        webSocketServer.sendMessageToAllClients("UPGRADELOG||start upgrade web...\r\n");
        webSocketServer.sendMessageToAllClients("PROGRESSVALUE||10.00\r\n");
        webSocketServer.sendMessageToAllClients("PROGRESSVALUE||40.00\r\n");
        webSocketServer.sendMessageToAllClients("PROGRESSVALUE||60.00\r\n");
        webSocketServer.sendMessageToAllClients("PROGRESSVALUE||80.00\r\n");
        webSocketServer.sendMessageToAllClients("PROGRESSVALUE||100.00\r\n");
        webSocketServer.sendMessageToAllClients("UPGRADELOG||web upgrade success.\r\n");
        webSocketServer.sendMessageToAllClients("UPGRADELOG||wait system root...\r\n");
        terminalManager.executeDetachedCommand("/userdata/update.sh");
    }

    function upgrademcu(){
        webSocketServer.sendMessageToAllClients("UPGRADELOG||start upgrade mcu...\r\n");
        terminalManager.executeCommand("rm -rf /data/FW.fwm");
        terminalManager.executeCommand("unzip -o /tmp/update/mcu.zip -d /data/");
        webSocketServer.connectToTcpServer("127.0.0.1", 35353);
    }

    function upgradec51(){
        batteryIndicator.batteryTimer.running = false;
        batteryIndicator.batteryTimer2.running = false;
        webSocketServer.sendMessageToAllClients("UPGRADELOG||start upgrade c51...\r\n");
        terminalManager.executeCommand("echo 106 > /sys/class/gpio/export");
        terminalManager.executeCommand("echo out > /sys/class/gpio/gpio106/direction");
        terminalManager.executeCommand("echo 0 > /sys/class/gpio/gpio106/value");
        terminalManager.executeCommand("echo 1 > /sys/class/gpio/gpio106/value");
        terminalManager.executeCommand("rm -rf /data/c51.hex");
        terminalManager.executeCommand("unzip -o /tmp/update/c51.zip -d /data/");
        serialPortManager.writeDataUart6("ISP 51 2\r\n",1);

    }

    function upgradefpga(){
        terminalManager.executeCommand("echo 144 > /sys/class/gpio/export");
        terminalManager.executeCommand("echo out > /sys/class/gpio/gpio144/direction");
        terminalManager.executeCommand("echo 1 > /sys/class/gpio/gpio144/value");
        terminalManager.executeCommand("echo 42 > /sys/class/gpio/export");
        terminalManager.executeCommand("echo out > /sys/class/gpio/gpio42/direction");
        terminalManager.executeCommand("rm -rf /data/top.bin");
        terminalManager.executeCommand("unzip -o /tmp/update/fpga.zip -d /data/");
        webSocketServer.sendMessageToAllClients("UPGRADELOG||start upgrade FPGA...\r\n");
//        webSocketServer.sendMessageToAllClients("UPGRADELOG||Erase...\r\n");
        terminalManager.executeCommand("/userdata/spi -w -f /data/top.bin -a 0000");
    }

    WebSocketServer {
        id: webSocketServer
        port: 8081
        Component.onCompleted: {
               webSocketServer.startServer();
        }

        onTcpConnected: {
            console.log("TCP Connected via WebSocketServer");
            if(upgradetype==="mcu"){
                serialPortManager.closePortUart5();
                webSocketServer.sendTcpMessage("\r\nGET FIRMWARELIST\r\n");
                webSocketServer.sendTcpMessage("\r\nUPGRADEMODE||5\r\n");
                webSocketServer.sendTcpMessage("\r\nSETCOMPORT||ttyS5\r\n");
                webSocketServer.sendTcpMessage("\r\nUPGRADE||Main,0,0\r\n");
            }else if(upgradetype==="c51"){
                serialPortManager.closePortUart6();
                webSocketServer.sendTcpMessage("\r\nGET FIRMWARELIST\r\n");
                webSocketServer.sendTcpMessage("\r\nUPGRADEMODE||5\r\n");
                webSocketServer.sendTcpMessage("\r\nSETCOMPORT||ttyS6\r\n");
                webSocketServer.sendTcpMessage("\r\nUPGRADE||Main,0,0\r\n");
            }
        }
        onTcpMessageReceived:{
//            console.log("TCP messages=",message);
            if(message.indexOf("PROGRESSVALUE")!=-1){
                webSocketServer.sendMessageToUploadClients(message+"\r\n");
                if(message.indexOf("100")!=-1){
                    webSocketServer.sendMessageToAllClients("UPGRADELOG||mcu upgrade success\r\n");
                }
            }

            if(message.indexOf("ttyS5 port is disconnected")!=-1){
//                serialPortManager.openPortUart5();
//                upgraderk3568();
            }
        }

        onRunningChanged: console.log("Server running:", isRunning)
        onNewClientConnected: console.log("New client connected")
        onClientDisconnected: console.log("Client disconnected")
        onMessageReceived: {
             console.log("Received message from path:", path, "Data:", message);
            if (path === "/ws/upload") {
                if(message.indexOf("get ip mode")!=-1){
                    webSocketServer.sendMessageToUploadClients("ip mode "+fileManager.getValue("ipmode")+"\r\n");
                }else if(message.indexOf("get mac address")!=-1){
                    webSocketServer.sendMessageToUploadClients("mac address "+systemSetup.mac_address.text+"\r\n");
                }else if(message.indexOf("get host ip")!=-1){
                    webSocketServer.sendMessageToUploadClients("host ip "+systemSetup.host_ip.text+"\r\n");
                }else if(message.indexOf("get ip mask")!=-1){
                    webSocketServer.sendMessageToUploadClients("ip mask "+systemSetup.ip_mask.text+"\r\n");
                }else if(message.indexOf("get route ip")!=-1){
                    webSocketServer.sendMessageToUploadClients("route ip "+systemSetup.router_ip.text+"\r\n");
                }else if(message.indexOf("get tcp port")!=-1){
                    webSocketServer.sendMessageToUploadClients("tcp port "+systemSetup.tcp_port.text+"\r\n");
                }
                if(message.indexOf("upgrade:")!=-1){
//                    terminalManager.executeCommand("/data/upgrademodule > /dev/null 2>&1");
                    if(message.indexOf("mcu")!=-1){
                        upgradetype = "mcu";
                        upgrademcu();
                    }
                    else if(message.indexOf("c51")!=-1){
                        upgradetype = "c51";
                        upgradec51();
                    } else if(message.indexOf("fpga")!=-1){
                        upgradetype = "fpga";
                        upgradefpga();
                    }
                    else if(message.indexOf("rk3568")!=-1){
                        upgradetype = "rk3568";
                        upgraderk3568();
                    }

                }

            } else if (path === "/ws/uart") {
                if(message.indexOf("get ip mode")!=-1){
                    webSocketServer.sendMessageToAllClients("ip mode "+fileManager.getValue("ipmode")+"\r\n");
                }else if(message.indexOf("get mac address")!=-1){
                    webSocketServer.sendMessageToAllClients("mac address "+systemSetup.mac_address.text+"\r\n");
                }else if(message.indexOf("get host ip")!=-1){
                    webSocketServer.sendMessageToAllClients("host ip "+systemSetup.host_ip.text+"\r\n");
                }else if(message.indexOf("get ip mask")!=-1){
                    webSocketServer.sendMessageToAllClients("ip mask "+systemSetup.ip_mask.text+"\r\n");
                }else if(message.indexOf("get route ip")!=-1){
                    webSocketServer.sendMessageToAllClients("route ip "+systemSetup.router_ip.text+"\r\n");
                }else if(message.indexOf("get tcp port")!=-1){
                    webSocketServer.sendMessageToAllClients("tcp port "+systemSetup.tcp_port.text+"\r\n");
                }else if(message.indexOf("get fan speeed")!=-1){
                    webSocketServer.sendMessageToAllClients("fan speed "+systemSetup.fan_control_flag+"\r\n");
                }else if(message.indexOf("READDEFAULT")!=-1){
    //                console.log("**********",videoGenerator.in_m_PCLOCK.text)
    //                var timstr = (videoGenerator.in_m_PCLOCK.text) + "," +
    //                        (videoGenerator.in_m_HACTIVE.text) + "," +
    //                        videoGenerator.in_m_VACTIVE.text + "," +
    //                        videoGenerator.in_m_HTOTAL.text + "," +
    //                        videoGenerator.in_m_VTOTAL.text + "," +
    //                        videoGenerator.in_m_HBLANK.text + "," +
    //                        videoGenerator.in_m_VBLANK.text + "," +
    //                        videoGenerator.in_m_HFREQ.text + "," +
    //                        videoGenerator.in_m_VFREQ.text + "," +
    //                        videoGenerator.in_m_HSYNCWIDTH.text + "," +
    //                        videoGenerator.in_m_VSYNCWIDTH.text + "," +
    //                        videoGenerator.in_m_HSOFFSET.text + "," +
    //                        videoGenerator.in_m_VSOFFSET.text + "," +
    //                        (videoGenerator.in_m_SCANP_P.checked ? "0" : "1") + "," +
    //                        (videoGenerator.in_m_HSPOLAR_R.checked ? "0" : "1") + "," +
    //                        (videoGenerator.in_m_VSPOLAR_R.checked ? "0" : "1") + "," + "1";
    //                webSocketServer.sendMessageToAllClients("RESPONSE||8061||"+ timstr +"\r\n");
                    webSocketServer.sendMessageToUploadClients("ip mode "+fileManager.getValue("ipmode")+"\r\n");
                    webSocketServer.sendMessageToUploadClients("mac address "+systemSetup.mac_address.text+"\r\n");
                    webSocketServer.sendMessageToUploadClients("host ip "+systemSetup.host_ip.text+"\r\n");
                    webSocketServer.sendMessageToUploadClients("tcp port "+systemSetup.tcp_port.text+"\r\n");
                    webSocketServer.sendMessageToUploadClients("ip mask "+systemSetup.ip_mask.text+"\r\n");
                    webSocketServer.sendMessageToUploadClients("route ip "+systemSetup.router_ip.text+"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8061||"+ videoGenerator.timingSelect +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8062||"+ videoGenerator.patternIndex +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8063||"+ videoGenerator.colorSpaceFlag +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8064||"+ videoGenerator.colorDepthFlag +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8065||"+ videoGenerator.hdcpFlag +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8066||"+ videoGenerator.hdmiFlag +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8067||"+ audioGenerator.pcm_sampling_rate_select +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8068||"+ audioGenerator.pcm_bit_depth_select +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8073||"+ audioGenerator.pcm_sinewave_tone_select +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||806D||"+ audioGenerator.pcm_volume_value +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||806B||"+ audioGenerator.pcm_channel_select +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8069||"+ audioGenerator.dolby_select +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||8070||"+ videoGenerator.bt2020Flag +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||80D8||"+ videoGenerator.imaxFlag +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||806F||"+ videoGenerator.hdrFlag +"\r\n");
                    webSocketServer.sendMessageToAllClients("RESPONSE||F803||"+ videoGenerator.hdrFlag +"\r\n");
                    var rgbdata = videoGenerator.windowRed.text + ","+
                            videoGenerator.windowGreen.text + ","+
                            videoGenerator.windowBlue.text + ","+
                            videoGenerator.backgroundRed.text + ","+
                            videoGenerator.backgroundGreen.text + ","+
                            videoGenerator.backgroundBlue.text + ","+
                            videoGenerator.rgb_window_size.text + ","+
                            videoGenerator.rgb_color_depth_flag + ","+
                            videoGenerator.rgb_color_space_flag ;
                    webSocketServer.sendMessageToAllClients("RESPONSE||808C||"+ rgbdata +"\r\n");

                }
                else if(message.indexOf("set ip mode static")!=-1){
                    var linedata = message.split(":");
                    netManager.setIpAddress(linedata[1], linedata[2],linedata[3],"static");
                }else if(message.indexOf("set ip mode dhcp")!=-1){
                    netManager.setIpAddress(systemSetup.host_ip.text, systemSetup.ip_mask.text,systemSetup.router_ip.text,"dhcp");
                }
                else if(message.indexOf("SEND")!=-1){
                    linedata = message.split("||")[1];
                    var tmp = linedata.split(",");
                    var num = parseInt(tmp[1],10);
                    hexString = parseInt(tmp[1],10).toString(16);
                    if(parseInt(tmp[0],10)===97){
                        strcode = "61 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===98){
                        strcode = "62 00 ";
                        command_length = "07 00 "
                        hexString = hexString.padStart(4, '0');
                        var firstTwoDigits = hexString.slice(0,2);
                        var lastTwoDigits = hexString.slice(-2);
                        hexString = lastTwoDigits + " " + firstTwoDigits;
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===99){
                        strcode = "63 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===100){
                        strcode = "64 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===101){
                        strcode = "65 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===102){
                        strcode = "66 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===103){
                        strcode = "67 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===104){
                        strcode = "68 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===105){
                        strcode = "69 00 ";
                        command_length = "07 00 "
                        hexString = hexString.padStart(4, '0');
                        firstTwoDigits = hexString.slice(0,2);
                        lastTwoDigits = hexString.slice(-2);
                        hexString = lastTwoDigits + " " + firstTwoDigits;
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===107){
                        strcode = "6B 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===109){
                        strcode = "6D 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===111){
                        hdrdata(num);
                    }else if(parseInt(tmp[0],10)===112){
                        strcode = "70 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===115){
                        strcode = "73 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===131){
                        serialPortManager.writeDataUart5("SET IN1 EARC"+num+"\r\n",1);
                    }else if(parseInt(tmp[0],10)===140){
                        strcode = "8C 00 ";
                        command_length = "14 00 ";
                        var rgbhex = tmp.slice(1, 16).join(" ");
                        hexString = rgbhex.trim();
                        var getdata = rgbhex.split(" ");
                        videoGenerator.windowRed.text = parseInt(getdata[1]+getdata[0],16)
                        videoGenerator.windowGreen.text =parseInt(getdata[3]+getdata[2],16)
                        videoGenerator.windowBlue.text =parseInt(getdata[5]+getdata[4],16)
                        videoGenerator.backgroundRed.text =parseInt(getdata[7]+getdata[6],16)
                        videoGenerator.backgroundGreen.text =parseInt(getdata[9]+getdata[8],16)
                        videoGenerator.backgroundBlue.text =parseInt(getdata[11]+getdata[10],16)
                        videoGenerator.rgb_window_size.text =parseInt(getdata[12],16)
                        videoGenerator.rgb_color_depth_flag =parseInt(getdata[13],16)
                        videoGenerator.rgb_color_space_flag =parseInt(getdata[14],16)

                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===160){
                        strcode = "A0 00 ";
                        command_length = "19 00 ";
                        var timhex = tmp.slice(1, 21).map(function(x) {return parseInt(x).toString(16).padStart(2, '0').toUpperCase();}).join(" ");
                        hexString = timhex.trim();
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===163){
                        strcode = "A3 00 ";
                        command_length = "24 00 ";
                        for(var t=1;t<tmp.length;t++)
                            hexString = tmp[t]+" ";
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString.trim();
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===177){
                        hexString = hexString.padStart(2, '0');
                        serialPortManager.writeDataUart5("SET EARC HPD CTL "+hexString+"\r\n",1);
    //                    strcode = "B1 00 ";
    //                    command_length = "06 00 "
    //                    hexString = hexString.padStart(2, '0');
    //                    completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
    //                    serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===178){
                        hexString = hexString.padStart(2, '0');
                        serialPortManager.writeDataUart5("SET EARC HPD BIT CTL "+hexString+"\r\n",1);
                    }else if(parseInt(tmp[0],10)===179){
                        hexString = hexString.padStart(2, '0');
                        serialPortManager.writeDataUart5("SET HDMI 5V "+(hexString==="00"? "OFF":"ON")+"\r\n",1);
                    }else if(parseInt(tmp[0],10)===211){
                        hexString = hexString.padStart(2, '0');
                        serialPortManager.writeDataUart5("SET EARC LATENCY "+hexString+"\r\n",1);
                    }else if(parseInt(tmp[0],10)===216){
                        strcode = "D8 00 ";
                        command_length = "06 00 "
                        hexString = hexString.padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===30720){
                        terminalManager.executeCommand("reboot");
                    }else if(parseInt(tmp[0],10)===30722){
                        reset();
    //                    terminalManager.executeCommand("reboot");
                    }else if(parseInt(tmp[0],10)===30723){
                        if(num===4){
                            serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
                        }else{
                            serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
                            serialPortManager.writeDataUart5("SET FAN SPEED "+num+"\r\n", 1);
                        }
                    }else if(parseInt(tmp[0],10)===30971){
                        strcode = "FB 78 ";
                        command_length = "07 00 "
                        hexString = parseInt(tmp[1],10).toString(16).padStart(2, '0')+" "+parseInt(tmp[2],10).toString(16).padStart(2, '0');
                        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                        serialPortManager.writeData(completeString,typecmd);
                    }else if(parseInt(tmp[0],10)===63576){
                        serialPortManager.writeDataUart5("GET VER INF\r\n",1);
                        serialPortManager.writeDataUart6("AA 01 00 05 00 01 00 58 F8",0);
                        serialPortManager.writeData("AA 00 00 06 00 00 00 58 F8 10",0);
                    }else if(parseInt(tmp[0],10)===63577){
                        serialPortManager.writeDataUart5("GET NTC 1 VALUE\r\n",1);
                        serialPortManager.writeDataUart5("GET NTC 1 VALUE\r\n",1);
                        cht8310.readData();
                    }


                }

            }
        }

    }

    NetManager {
       id: netManager
       onIpAddressChanged:{
           systemSetup.host_ip.text = data
       }
       onNetmaskChanged:{
           systemSetup.ip_mask.text = data
       }
       onRouterIpAddressChanged:{
           systemSetup.router_ip.text = data
       }
       onMacAddressChanged:{
           systemSetup.mac_address.text = data
       }
       onTcpPortsChanged:{
           systemSetup.tcp_port.text = data
       }
   }

    SerialPortManager {
        id: serialPortManager
        onIsBlackChanged: {
            window.isBlack = isBlack;
//            console.log("************",isBlack);
        }
        onDataReceived: {
            var str = data.toString();
//            console.log("receive: ",str);
            var getdata = str.split(" ")
            var lengthlow = getdata[3];
            var lengthheight = getdata[4];
            var length = parseInt(getdata[4] + getdata[3],16);
            strcode = getdata[7] + getdata[8];
//            console.log("strcode: ",strcode);
            var num = getdata.slice(9,length+4);
            var id_str = "";
            var i = 0;
            var item = "";
//            webSocketServer.sendMessageToAllClients("RESPONSE||"+getdata[8] + getdata[7]+"||"+ parseInt(num,16) +"\r\n");
            if(strcode == "7380"){
                fileManager.updateData("SinewaveTone", num);
               id_str = audioGenerator.pcm_sinewave_tone_model;
               for (i = 0; i < id_str.count; i++) {
                   item = id_str.get(i);
                   if(item.number === parseInt(num,16)){
                       statuspage.sinewaretoneText = item.second;
                       statuspage.typeText = "PCM";
                       audioGenerator.pcm_sinewave_tone_select = item.number;
                       console.log("//////////sinewaretoneText",num,item.first,statuspage.sinewaretoneText)
                       break;
                   }
               }
            }else if(strcode == "7080"){
                fileManager.updateData("Bt2020", num);
                id_str = videoGenerator.bt2020_model;
                for ( i = 0; i < id_str.count; i++) {
                     item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        videoGenerator.bt2020Flag = item.number;
                        statuspage.btText = item.first;
                    }
                }
            }else if(strcode == "6F80"){
                fileManager.updateData("HDR", num);
                videoGenerator.hdrFlag = parseInt(num,16);
            }else if(strcode == "D880"){
                fileManager.updateData("IMAX", num);
                videoGenerator.imaxFlag = parseInt(num,16);
            }else if(strcode == "6D80"){
                fileManager.updateData("AudioVolume", num);
//                var volume = ["-60db","-54db","-48db","-42db","-36db","-30db","-24db","-18db","-12db","-6db","0db"];
//                statuspage.audiovolumeText = volume[parseInt(num,16)];
//                statuspage.typeText = "PCM";
//                audioGenerator.pcm_volume_value = parseInt(num,16)*6-60;
                id_str = audioGenerator.pcm_volume_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.audiovolumeText = item.first;
                        statuspage.typeText = "PCM";
                        audioGenerator.pcm_volume_value = item.number;
                        console.log("//////////audiovolumeText",num,item.first,statuspage.audiovolumeText)
                        break;
                    }
                }
            }else if(strcode == "6B80"){
                id_str = audioGenerator.pcm_channel_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.channelsText = item.second;
                        statuspage.typeText = "PCM";
                        audioGenerator.pcm_channel_select = item.number;
                        console.log("//////////channelsText",num,item.first,statuspage.channelsText)
                        break;
                    }
                }
            }else if(strcode == "6980"){
//                statuspage.channelsText = "";
//                statuspage.audiobitText = "";
//                statuspage.samplerateText = "";
//                statuspage.audiovolumeText = "";
//                statuspage.sinewaretoneText = "";
                statuspage.typeText = "DOLBY";
            }else if(strcode == "6880"){
                fileManager.updateData("AudioBitDepth", num);
                id_str = audioGenerator.pcm_bit_depth_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.audiobitText = item.first;
                        statuspage.typeText = "PCM";
                        audioGenerator.pcm_bit_depth_select = item.number;
                        console.log("//////////bitdeth",num,item.first,statuspage.audiobitText)
                        break;
                    }
                }
            }else if(strcode == "6780"){
                fileManager.updateData("AudioSamplingRate", num);
                id_str = audioGenerator.pcm_sampling_rate_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.samplerateText = item.first;
                        statuspage.typeText = "PCM";
                        audioGenerator.pcm_sampling_rate_select = item.number;
                        break;
                    }
                }
            }else if(strcode == "6680"){
                fileManager.updateData("HDMI", num);
                id_str = videoGenerator.hdmi_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.hdmiText = item.first;
                        videoGenerator.hdmiFlag = item.number;
                        break;
                    }
                }
            }else if(strcode == "B839"){
                statuspage.hpdText = parseInt(getdata[9],16)===0 ? "Low":"High";
            }else if(strcode == "6580"){
                fileManager.updateData("HDCP", num);
                id_str = videoGenerator.hdcp_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.hdcpText = item.first;
                        videoGenerator.hdcpFlag = item.number;
                        break;
                    }
                }
            }else if(strcode == "6480"){
                fileManager.updateData("ColorDepth", num);
                id_str = videoGenerator.color_depth_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.colordepthText = item.first;
                        videoGenerator.colorDepthFlag = item.number;
                        break;
                    }
                }
            }else if(strcode == "6380"){
                fileManager.updateData("ColorSpace", num);
                id_str = videoGenerator.color_space_model;
                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === parseInt(num,16)){
                        statuspage.colorText = item.first;
                        videoGenerator.colorSpaceFlag = item.number;
                        break;
                    }
                }
            }else if(strcode == "6280"){
                fileManager.updateData("Pattern", num);
                videoGenerator.patternIndex = parseInt(num,16);
            }else if(strcode == "6180"){
                fileManager.updateData("Timing", num);
                videoGenerator.timingSelect = parseInt(num,16);
                num = parseInt(num,16);
                if(num>=110&&num<=119){
                    id_str = videoGenerator.timing_8k_model;
                    videoGenerator.timingSelectFlag = 1;
                }else if((num>=28&&num<=32) || (num>=34&&num<=36)|| (num>=103&&num<=104)|| (num>=107&&num<=109)){
                    id_str = videoGenerator.timing_uhd_model;
                    videoGenerator.timingSelectFlag = 2;
                }else if(num ===32 || (num>=53&&num<=59)|| (num>=105&&num<=106)){
                    id_str = videoGenerator.timing_4k_model;
                    videoGenerator.timingSelectFlag = 3;
                }else if(num >=73 && num<=80){
                    id_str = videoGenerator.timing_2k_model;
                    videoGenerator.timingSelectFlag = 4;
                }else if(num >=12 && num<=27 || num ===81 || num ===82 || num === 102){
                    id_str = videoGenerator.timing_hd_model;
                    videoGenerator.timingSelectFlag = 5;
                }else if(num ===11|| num ===10 || num ===22 || num === 23){
                    id_str = videoGenerator.timing_sd_model;
                    videoGenerator.timingSelectFlag = 6;
                }else if(num >=0 && num<=9|| num >=69 && num<=72 || num >=83 && num<=101){
                    id_str = videoGenerator.timing_vesa_model;
                    videoGenerator.timingSelectFlag = 7;
                }else if(num >=37 && num<=41){
                    id_str = videoGenerator.timing_3d_model;
                    videoGenerator.timingSelectFlag = 8;
                }else if(num >=43 && num<=52){
                    id_str = videoGenerator.timing_custom_model;
                    videoGenerator.timingSelectFlag = 9;
                }

                for (i = 0; i < id_str.count; i++) {
                    item = id_str.get(i);
                    if(item.number === num){
                        videoGenerator.timingSelect = num;
                        statuspage.timingText = item.first+"@"+item.second;
                    }
                }
                console.log("*************",videoGenerator.timingSelectFlag,statuspage.timingText)
            }else if(strcode == "3EB8"){
                var tempArray = [];
                for(var e =0 ; e<parseInt(getdata[3],16);e++){
                    tempArray.push(getdata[e+4])
                }
                edid.edidArray = tempArray;

            }else if(strcode == "9880"){
                var value = parseInt(getdata[10]+getdata[9],16);
                batteryIndicator.batteryLevel = (value-175)*2;
//                console.log("battery = ",value);
            }else if(strcode == "9980"){
                var batteryconnet = parseInt(getdata[9],16);
                var batterystatus = parseInt(getdata[10],16);
                if(batteryconnet===1){
                    batteryIndicator.isCharging = true ;
//                    console.log("batterystatus = ",batteryIndicator.isCharging);
                }else{
                    batteryIndicator.isCharging = (batterystatus === 1) ? true : false;
                }

            }else if(strcode == "58F8"){
                 systemSetup.key_mcu.text = "V"+parseInt(getdata[10],16)+"."+getdata[11];
                 webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+ "0,V" + parseInt(getdata[10],16)+"."+getdata[11] +"\r\n");
            }else if(strcode == "FFFF" && getdata[9]+getdata[10]=== "58F8"){
                systemSetup.main_fpga.text = "V"+parseInt(getdata[11],16)+".0";
                webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+ "16,V" + parseInt(getdata[11],16)+"."+"0" +"\r\n");

           }

        }

        onDataReceivedASCALL:{
            if(data.indexOf("EDID")!=-1 && data.indexOf("DATA")!=-1){
//                data = data.replace("EDID","");
                var linedata = data.split(" ");
                var tempArray = [];
                for(var e =0 ; e<linedata.length-4;e++){
                    tempArray.push(linedata[e+4])
                }
                edid.edidArray = tempArray;
                edid.manufacturerName_text = (binaryToASCLL(hexToBinary(tempArray[8] + tempArray[9])).toUpperCase());
                edid.vsdb_3D_text = ((parseInt(tempArray[0x14], 16) & 0x40) ? "YES" : "NO");
                edid.vsdb_3D_text = ((parseInt(tempArray[0x14], 16) & 0x40) ? "YES" : "NO");
                edid.generalinfo();
            }else if(data.indexOf("FAN SPEED")!=-1){
                linedata = data.split(" ");
                systemSetup.fan_control_flag = parseInt(linedata[2]);
                webSocketServer.sendMessageToAllClients("RESPONSE||F803||"+ systemSetup.fan_control_flag +"\r\n");
                fileManager.updateData("FanControl", parseInt(linedata[2]).toString(16).padStart(2, '0'));
            }else if(data.indexOf("IN1 EDID")!=-1){
                linedata = data.split(" ");
                serialPortManager.writeDataUart5("GET IN1 EDID"+linedata[2]+" DATA\r\n",1);
            }else if(data.indexOf("FAN MODE")!=-1){
                linedata = data.split(" ");
                if(linedata[2]=== 0){
                    fileManager.updateData("FanControl", "04");
                    systemSetup.fan_control_flag = 4;
                    webSocketServer.sendMessageToAllClients("RESPONSE||F803||"+ systemSetup.fan_control_flag +"\r\n");
                }
            }else if(data.indexOf("HDMI 5V")!=-1){
                linedata = data.split(" ");
                fileManager.updateData("HDMI_5V_POWER_CTL", linedata[2]==="ON"?"01":"00");
                webSocketServer.sendMessageToAllClients("RESPONSE||F803||"+ (linedata[2]==="ON"?"1":"0") +"\r\n");
            }else if(data.indexOf("NTC1 VALUE")!=-1){
                linedata = data.split(" ");
                systemSetup.chip_main_mcu.text = linedata[2].replace("\r\n","")+"°C";
                webSocketServer.sendMessageToAllClients("RESPONSE||F859||"+ "1," + linedata[2].replace("\r\n","") +"\r\n");
            }else if(data.indexOf("MAIN MCU")!=-1){
                linedata = data.split(" ");
                systemSetup.main_mcu.text = linedata[2].replace("\r\n","");
                webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+"1," + linedata[2].replace("\r\n","") +"\r\n");
            }else if(data.indexOf("VER DSP")!=-1){
                linedata = data.split(" ");
                systemSetup.dsp_module.text = linedata[2].replace("\r\n","");
                webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+"34," + linedata[2].replace("\r\n","") +"\r\n");
                webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+"32," + version +"\r\n");
            }else if(data.indexOf("Ready to receive...")!=-1){
                var totalSize = fileManager.getFileSize("/data/c51.hex");
                var bufdata = fileManager.readBinaryFile("/data/c51.hex");
                console.log("c51 filesize:",totalSize);
                var chunkSize = 256;
                var chunks = Math.ceil(totalSize / chunkSize);
                var currentPosition = 0;
                while(currentPosition < totalSize){
                    var endPos = Math.min(currentPosition + chunkSize, totalSize);
                    var chunk = bufdata.slice(currentPosition, endPos);
                    serialPortManager.writeDataUart6(chunk, 1);
                    currentPosition = endPos;
                    var progress = Math.round((currentPosition / totalSize) * 100);
                    webSocketServer.sendMessageToAllClients("PROGRESSVALUE||" + progress + "\r\n");
                    if(progress===100){
                        webSocketServer.sendMessageToAllClients("UPGRADELOG||c51 upgrade success.\r\n");
                    }
                }
            }
        }

    }

    function hdrdata(num){
        videoGenerator.hdrFlag = num;
        var hdrhexString = ""
        command_length = "24 00 "
        if(num===1){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A A4 02 00 C2 33 C4 86 4C 1D B8 0B D0 84 80 3E 13 3D 42 40 10 27 01 00 10 27 FA 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===2){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A 5B 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===3){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A A4 02 00 C2 33 C4 86 4C 1D B8 0B D0 84 80 3E 13 3D 42 40 10 27 01 00 10 27 FA 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===4){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A 5B 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===5){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A D6 02 00 C2 33 C4 86 4C 1D B8 0B D0 84 80 3E 13 3D 42 40 1C 02 01 00 1C 02 FA 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===6){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A B4 02 00 C2 33 C4 86 4C 1D B8 0B D0 84 80 3E 13 3D 42 40 A0 0F 01 00 A0 0F FA 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===7){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A A4 02 00 C2 33 C4 86 4C 1D B8 0B D0 84 80 3E 13 3D 42 40 10 27 01 00 10 27 FA 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===8){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A 1E 02 00 C2 33 C4 86 4C 1D B8 0B D0 84 80 3E 13 3D 42 40 FA 00 01 00 FA 00 FA 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===9){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A 1E 02 00 C2 33 C4 86 4C 1D B8 0B D0 84 80 3E 13 3D 42 40 E8 03 01 00 E8 03 FA 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(num===10){
            strcode = "A3 00 ";
            hdrhexString = "87 01 1A 7B 02 00 34 21 AA 9B 96 19 FC 08 48 8A 08 39 13 3D 42 40 A0 0F 00 00 00 00 00 00 00";
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hdrhexString;
            serialPortManager.writeData(completeString, typecmd);

        }
        hexString = num.toString(16).padStart(2, '0');
        strcode = "6F 00 ";
        command_length = "06 00 "
        fileManager.updateData("HDR", hexString);
        var command = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
        serialPortManager.writeData(command, typecmd);
    }

    function reset(){
        var data = {
            "FanControl": "02",
            "audiotype":"PCM",
            "Timing":"6e",
            "Pattern":"00",
            "ColorSpace":"01",
            "Bt2020":"00",
            "ColorDepth":"00",
            "HDCP":"00",
            "HDMI":"00",
            "HDR":"00",
            "IMAX":"00",
            "Rgb_YUV":"00",
            "Rgb":"00",
            "Pattern_ire_window":"00",
            "Pattern_ire_level":"00",

            "ARC/eARC_OUT":"00",
            "ARC_HPD_CTL":"00",
            "eARC_Physical_HPD_CTL":"00",
            "eARC_HPD_bit_CTL":"00",
            "HDMI_5V_POWER_CTL":"00",
            "eARCTX_Latency_REQ":"00",
            "eARCTX_Latency":"00",
            "eARCRX_Latency_REQ":"00",
            "eARCRX_Latency":"00",

            "timingdetails":"00",
            "timingDetails1":"00",
            "timingDetails2":"00",
            "timingDetails3":"00",
            "timingDetails4":"00",
            "timingDetails5":"00",
            "timingDetails6":"00",
            "timingDetails7":"00",
            "timingDetails8":"00",
            "timingDetails9":"00",
            "timingDetails10":"00",
            "AudioSamplingRate":"00",
            "AudioBitDepth":"00",
            "SinewaveTone":"00",
            "AudioVolume":"03",
            "AudioChannelConfig":"00",
            "DTS":"00 00",
            "Ext-Stereo":"00 00",
            "DOLBY":"00 00",

            "LinkTrain":"00 00",
            "LinkTrainForce":"00 00",
            "AudioInfoframeRead":"00 00",

            "ipmode":"static",
            "iphost":"192.168.1.239",
            "ipmask":"255.255.255.0",
            "iprouter":"192.168.1.1",
            "EDIDData1":"
                        00	FF	FF	FF	FF	FF	FF	00	4D	D9	05	B9	01	01	01	01
                        01	1F	01	03	80	7A	44	78	0A	0D	C9	A0	57	47	98	27
                        12	48	4C	21	08	00	81	80	A9	C0	71	4F	B3	00	01	01
                        01	01	01	01	01	01	08	E8	00	30	F2	70	5A	80	B0	58
                        8A	00	C2	AD	42	00	00	1E	02	3A	80	18	71	38	2D	40
                        58	2C	45	00	C2	AD	42	00	00	1E	00	00	00	FC	00	53
                        4F	4E	59	20	54	56	20	20	2A	33	30	0A	00	00	00	FD
                        00	17	79	0E	88	3C	00	0A	20	20	20	20	20	20	01	64
                        02	03	5B	F0	58	61	60	5D	5E	5F	62	1F	10	14	05	13
                        04	20	22	3C	3E	12	03	11	02	65	66	3F	40	2F	0D	7F
                        07	15	07	50	3D	07	BC	57	06	01	67	04	03	83	0F	00
                        00	E2	00	CB	6E	03	0C	00	30	00	B8	44	20	00	80	01
                        02	03	04	67	D8	5D	C4	01	78	80	03	E3	05	DF	01	E4
                        0F	03	00	30	E6	06	0D	01	A2	BE	06	01	1D	00	72	51
                        D0	1E	20	6E	28	55	00	C2	AD	42	00	00	1E	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	AF
            ",

            "EDIDData2":"
                        00	FF	FF	FF	FF	FF	FF	00	3E	10	01	00	01	01	01	01
                        27	1E	01	03	80	90	52	78	0A	0D	C9	A0	57	47	98	27
                        12	48	4C	21	08	00	81	80	A9	C0	71	4F	B3	00	01	01
                        01	01	01	01	01	01	08	E8	00	30	F2	70	5A	80	B0	58
                        8A	00	A0	34	53	00	00	1E	02	3A	80	18	71	38	2D	40
                        58	2C	45	00	A0	34	53	00	00	1E	00	00	00	FC	00	4F
                        50	50	4F	20	54	56	0A	20	20	20	20	20	00	00	00	FD
                        00	30	3E	0E	46	3C	00	0A	20	20	20	20	20	20	02	5F
                        02	03	5B	F1	5A	20	21	22	1F	10	40	3F	5D	5E	5F	60
                        61	75	76	62	63	64	65	66	DA	DB	C2	C3	C4	C6	C7	32
                        09	7F	07	15	07	50	3D	07	C0	57	04	01	67	04	03	5F
                        7E	01	83	0F	00	00	E2	00	FF	6E	03	0C	00	20	00	F8
                        3C	20	00	80	01	02	03	04	6D	D8	5D	C4	01	78	84	07
                        E3	05	FF	01	E1	0F	00	E3	06	0D	01	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	FF
                        02	03	19	F1	50	01	02	03	06	07	15	16	11	12	3C	3D
                        3E	13	04	14	05	E3	06	0D	01	00	00	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00
                        00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	62
            ",
            "EDIDData3":"",
            "EDIDData4":"",
            "EDIDData5":"",


        };
        fileManager.saveData(data);
        syscmd = "reboot";
        terminalManager.executeCommand(syscmd)
    }

    FontLoader {
        id:fontNimbusSanL
        source: "qrc:/fonts/BebasKai-Regular.otf"
    }
    FontLoader {
        id:myriadPro
        source: "qrc:/fonts/MyriadPro-Cond.ttf"
    }
    Item {
//        visible: false
        id: mainline
        anchors.left: window.left
        height: window.height
        width: 250

        Rectangle{
            id:mainline_rect
            anchors.fill: parent
            color: "#585858" //#585858
        }

        StatusPage{
            id:statuspage
        }
    }


    //init
    Component.onCompleted: {
        cht8310.initialize();
        //videoGenerator
        var hextiming = fileManager.getValue("Timing");
        var num = parseInt(hextiming,16);

        var id_str = "";
        var completeString = ""
        var strcode = ""
        var hexString = ""
        if(num>=110&&num<=119){
            id_str = videoGenerator.timing_8k_model;
            videoGenerator.timingSelectFlag = 1;
        }else if((num>=28&&num<=32) || (num>=34&&num<=36)|| (num>=103&&num<=104)|| (num>=107&&num<=109)){
            id_str = videoGenerator.timing_uhd_model;
            videoGenerator.timingSelectFlag = 2;
        }else if(num ===32 || (num>=53&&num<=59)|| (num>=105&&num<=106)){
            id_str = videoGenerator.timing_4k_model;
            videoGenerator.timingSelectFlag = 3;
        }else if(num >=73 && num<=80){
            id_str = videoGenerator.timing_2k_model;
            videoGenerator.timingSelectFlag = 4;
        }else if(num >=12 && num<=27 || num ===81 || num ===82 || num === 102){
            id_str = videoGenerator.timing_hd_model;
            videoGenerator.timingSelectFlag = 5;
        }else if(num ===11|| num ===10 || num ===22 || num === 23){
            id_str = videoGenerator.timing_sd_model;
            videoGenerator.timingSelectFlag = 6;
        }else if(num >=0 && num<=9|| num >=69 && num<=72 || num >=83 && num<=101){
            id_str = videoGenerator.timing_vesa_model;
            videoGenerator.timingSelectFlag = 7;
        }else if(num >=37 && num<=41){
            id_str = videoGenerator.timing_3d_model;
            videoGenerator.timingSelectFlag = 8;
        }else if(num >=43 && num<=52){
            id_str = videoGenerator.timing_custom_model;
            videoGenerator.timingSelectFlag = 9;
        }

        for (var i = 0; i < id_str.count; i++) {
            var item = id_str.get(i);
            if(item.number === num){
                videoGenerator.timingSelect = num;
                statuspage.timingText = item.first+"@"+item.second;
                hexString = hextiming;
                strcode = "61 00 ";
                command_length = "06 00 "
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }
        }

        var pattern = fileManager.getValue("Pattern");
        num = parseInt(pattern,16);
        videoGenerator.patternIndex = num;
        strcode = "62 00 ";
        command_length = "06 00 "
        completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
        serialPortManager.writeData(completeString, typecmd);


        var colorspace = fileManager.getValue("ColorSpace");
        num = parseInt(colorspace,16);
        id_str = videoGenerator.color_space_model;
        for ( i = 0; i < id_str.count; i++) {
             item = id_str.get(i);
            if(item.number === num){
                videoGenerator.colorSpaceFlag = num;
                statuspage.colorText = item.first;
                hexString = colorspace;
                strcode = "63 00 ";
                command_length = "06 00 "
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }
        }

        var colordepth = fileManager.getValue("ColorDepth");
        num = parseInt(colordepth,16);
        id_str = videoGenerator.color_depth_model;
        for ( i = 0; i < id_str.count; i++) {
             item = id_str.get(i);
            if(item.number === num){
                videoGenerator.colorDepthFlag = 0;
                statuspage.colordepthText = item.first;
                hexString = colordepth;
                strcode = "64 00 ";
                command_length = "06 00 "
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }
        }

        var hdcp = fileManager.getValue("HDCP");
        num = parseInt(hdcp,16);
        id_str = videoGenerator.hdcp_model;
        for ( i = 0; i < id_str.count; i++) {
             item = id_str.get(i);
            if(item.number === num){
                videoGenerator.hdcpFlag = num;
                statuspage.hdcpText = item.first;
                hexString = hdcp;
                strcode = "65 00 ";
                command_length = "06 00 "
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }
        }

        var bt2020 = fileManager.getValue("Bt2020");
        num = parseInt(bt2020,16);
        id_str = videoGenerator.bt2020_model;
        for ( i = 0; i < id_str.count; i++) {
             item = id_str.get(i);
            if(item.number === num){
                videoGenerator.bt2020Flag = num;
                statuspage.btText = item.first;
                hexString = bt2020;
                strcode = "70 00 ";
                command_length = "06 00 "
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }
        }

        var hexhdmitype = fileManager.getValue("HDMI");
        num = parseInt(hexhdmitype,16);
        id_str = videoGenerator.hdmi_model;
        for ( i = 0; i < id_str.count; i++) {
             item = id_str.get(i);
            if(item.number === num){
                videoGenerator.hdmiFlag = num;
                statuspage.hdmiText = item.first;
                hexString = hexhdmitype;
                strcode = "66 00 ";
                command_length = "06 00 "
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }
        }

//        var hpd = fileManager.getValue("hpd");
//        num = parseInt(hpd,16);
//        for ( i = 0; i < id_str.count; i++) {
//            item = id_str.get(i);
//            if(item.number === num){
//                videoGenerator.pcm_sampling_rate_select = num;
//                statuspage.modeText = item.first;
//                hexString = audiorate;
//                strcode = "67 00 ";
//                command_length = "06 00 "
//                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
//                serialPortManager.writeData(completeString, typecmd);
//            }
//        }




        var imax = fileManager.getValue("IMAX");
        num = parseInt(imax,16);
        id_str = videoGenerator.imaxFlag_model;
        for ( i = 0; i < id_str.count; i++) {
             item = id_str.get(i);
            if(item.number === num){
                videoGenerator.imaxFlag = num;
                statuspage.modeText = item.first;
            }
        }

        var rgb = fileManager.getValue("Rgb");
        var getdata = rgb.split(" ");
        videoGenerator.windowRed.text = parseInt(getdata[1]+getdata[0],16);
        videoGenerator.windowGreen.text =parseInt(getdata[3]+getdata[2],16);
        videoGenerator.windowBlue.text =parseInt(getdata[5]+getdata[4],16);
        videoGenerator.backgroundRed.text =parseInt(getdata[7]+getdata[6],16);
        videoGenerator.backgroundGreen.text =parseInt(getdata[9]+getdata[8],16);
        videoGenerator.backgroundBlue.text =parseInt(getdata[11]+getdata[10],16);
        videoGenerator.rgb_window_size.text =parseInt(getdata[12],16);
        videoGenerator.rgb_color_depth_flag =parseInt(getdata[13],16);
        videoGenerator.rgb_color_space_flag =parseInt(getdata[14],16);

        videoGenerator.pattern_ire_window_size.text = parseInt(fileManager.getValue("pattern_ire_window_size"),16);
        videoGenerator.pattern_ire_level.text = parseInt(fileManager.getValue("Pattern_ire_level"),16);
        videoGenerator.hdrFlag = 0

        var selecttim = fileManager.getValue("timingdetails");
        videoGenerator.in_m_UserdefineTiming.currentIndex = parseInt(selecttim,10)-1;
        var timingdetails = fileManager.getValue("timingdetails"+selecttim);
        getdata = timingdetails.split(" ");
        videoGenerator.in_m_PCLOCK.text = parseInt(getdata[2]+getdata[1],16)/100;
//        videoGenerator.in_m_SCANP_P.checked = parseInt(getdata[3],16)===0 ? true: false;
//        videoGenerator.in_m_SCANP_I.checked = parseInt(getdata[3],16)===1 ? true: false;
        videoGenerator.in_m_HACTIVE.text = parseInt(getdata[5]+getdata[4],16);
        videoGenerator.in_m_HBLANK.text = parseInt(getdata[7]+getdata[6],16);
        videoGenerator.in_m_HSYNCWIDTH.text = parseInt(getdata[9]+getdata[8],16);
        videoGenerator.in_m_HSOFFSET.text = parseInt(getdata[11]+getdata[10],16);
        videoGenerator.in_m_VACTIVE.text = parseInt(getdata[13]+getdata[12],16);
        videoGenerator.in_m_VBLANK.text = parseInt(getdata[15]+getdata[14],16);
        videoGenerator.in_m_VSYNCWIDTH.text = parseInt(getdata[17]+getdata[16],16);
        videoGenerator.in_m_VSOFFSET.text = parseInt(getdata[19]+getdata[18],16);

        //VideoTest
        //videoTest.videoTestSelect = 0

        //AudioGenerator
//        audioGenerator.pcmFlag = 0
//        audioGenerator.dtsFlag = 0

        statuspage.typeText = fileManager.getValue("audiotype");
        if(statuspage.typeText==="PCM"){
            audioGenerator.audioTypeFlag = 1;
            serialPortManager.writeData("AA 00 00 07 00 00 00 69 00 00 01", typecmd);
            var audiorate = fileManager.getValue("AudioSamplingRate");
            num = parseInt(audiorate,16);
            id_str = audioGenerator.pcm_sampling_rate_model;
            for ( i = 0; i < id_str.count; i++) {
                 item = id_str.get(i);
                if(item.number === num){
                    audioGenerator.pcm_sampling_rate_select = num;
                    statuspage.samplerateText = item.first;
                    hexString = audiorate;
                    strcode = "67 00 ";
                    command_length = "06 00 "
                    completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                    serialPortManager.writeData(completeString, typecmd);
                }
            }

            var audiodepth = fileManager.getValue("AudioBitDepth");
            num = parseInt(audiodepth,16);
            id_str = audioGenerator.pcm_bit_depth_model;
            for ( i = 0; i < id_str.count; i++) {
                 item = id_str.get(i);
                if(item.number === num){
                    audioGenerator.pcm_bit_depth_select = num;
                    statuspage.audiobitText = item.first;
                    hexString = audiodepth;
                    strcode = "68 00 ";
                    command_length = "06 00 "
                    completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                    serialPortManager.writeData(completeString, typecmd);
                }
            }

            var audiosineware = fileManager.getValue("SinewaveTone");
            num = parseInt(audiosineware,16);
            id_str = audioGenerator.pcmsinewaveModel;
            for ( i = 0; i < id_str.count; i++) {
                 item = id_str.get(i);
                if(item.number === num){
                    audioGenerator.pcm_sinewave_tone_select = num;
                    statuspage.sinewaretoneText = item.second;
                    hexString = audiosineware;
                    strcode = "73 00 ";
                    command_length = "06 00 "
                    completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                    serialPortManager.writeData(completeString, typecmd);
                }
            }

            var audiovolume = fileManager.getValue("AudioVolume");
            num = parseInt(audiovolume,16);
            id_str = audioGenerator.pcm_volume_model;
            for ( i = 0; i < id_str.count; i++) {
                 item = id_str.get(i);
                if(item.number === num){
                    audioGenerator.pcm_volume_value = num;
                    statuspage.audiovolumeText = item.first;
                    hexString = audiovolume;
                    strcode = "6D 00 ";
                    command_length = "06 00 "
                    completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                    serialPortManager.writeData(completeString, typecmd);
                }
            }

            var audiochannel = fileManager.getValue("AudioChannelConfig");
            num = parseInt(audiochannel,16);
            id_str = audioGenerator.pcm_channel_model;
            for ( i = 0; i < id_str.count; i++) {
                 item = id_str.get(i);
                if(item.number === num){
                    audioGenerator.pcm_channel_select = num;
                    statuspage.channelsText = item.first;
                    hexString = audiochannel;
                    strcode = "6B 00 ";
                    command_length = "06 00 "
                    completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                    serialPortManager.writeData(completeString, typecmd);
                }
            }

        }else if(statuspage.typeText==="DOLBY"){
            audioGenerator.audioTypeFlag = 2;
            serialPortManager.writeData("AA 00 00 07 00 00 00 69 00 00 01", typecmd);
            var dolbyaudio = fileManager.getValue("DolbyAudioGenerator");
            num = parseInt(dolbyaudio,16);
            audioGenerator.dolby_select = num;
            hexString = dolbyaudio;
            strcode = "69 00 ";
            command_length = "07 00 "
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
            serialPortManager.writeData(completeString, typecmd);

        }else if(statuspage.typeText==="Ext-Stereo"){
            audioGenerator.audioTypeFlag = 3;
            serialPortManager.writeData("AA 00 00 07 00 00 00 69 00 00 00", typecmd);
            audioGenerator.dolby_select = 0x00;
        }else if(statuspage.typeText==="DTS"){
            audioGenerator.audioTypeFlag = 4;
            var dts = fileManager.getValue("DTS");
            num = parseInt(dts,16);
            audioGenerator.dolby_select = num;
            hexString = dts;
            strcode = "69 00 ";
            command_length = "07 00 "
            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
            serialPortManager.writeData(completeString, typecmd);

        }

        //Edid_eARC_CDS
//        edid.sink_device_edid_text.text = ""
//        edid.sink_device_general_text.text = ""
//        edid.sink_device_video_text.text = ""
//        edid.sink_device_audio_text.text = ""

//        edid.arc_audio_text.text = ""
//        edid.arc_audio_info_text.text = ""

        edid.arc_hpd_ctl_flag = parseInt(fileManager.getValue("ARC_HPD_CTL"),16);
        if(edid.arc_hpd_ctl_flag===1) serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 B1 00 01", typecmd);
        else serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 B1 00 02", typecmd);

        edid.physical_hpd_ctl_flag = parseInt(fileManager.getValue("eARC_Physical_HPD_CTL"),16);
        if(edid.physical_hpd_ctl_flag===1) serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 B1 00 01", typecmd);
        else serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 B1 00 02", typecmd);

        edid.earc_hpd_bit_ctl_flag = parseInt(fileManager.getValue("eARC_HPD_bit_CTL"),16);
        if(edid.earc_hpd_bit_ctl_flag===1) serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 B2 00 01", typecmd);
        else serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 B2 00 00", typecmd);

        edid.hdmi_5v_power_ctl_flag = parseInt(fileManager.getValue("HDMI_5V_POWER_CTL"),16);
        serialPortManager.writeDataUart5("SET HDMI 5V "+(edid.hdmi_5v_power_ctl_flag===0? "OFF":"ON")+"\r\n",1);

        edid.earc_tx_latencyk_text.text = parseInt(fileManager.getValue("eARCTX_Latency_REQ"),16);
        serialPortManager.writeDataUart5("SET TXLAT "+parseInt(fileManager.getValue("eARCTX_Latency_REQ"),16), 1);

        edid.earc_tx_latencyk_ms_text.text = parseInt(fileManager.getValue("eARCTX_Latency"),16);
        serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 7A 00 "+fileManager.getValue("eARCTX_Latency"), typecmd);
//        edid.earc_rx_latencyk_text.text = 0
//        edid.earc_rx_latencyk_ms_text.text = 0

        //SystemSetup
        var ip_mode = fileManager.getValue("ipmode");
        systemSetup.ip_management_dhcp_flag = ip_mode ==="static" ? false : true
        systemSetup.host_ip.text = netManager.ipAddress
        systemSetup.router_ip.text = netManager.routerIpAddress
        systemSetup.ip_mask.text = netManager.netmask
        systemSetup.mac_address.text = netManager.macAddress
        systemSetup.tcp_port.text = netManager.tcpPorts

        systemSetup.out_setup_flag = parseInt(fileManager.getValue("ARC/eARC_OUT"),16);
//        serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 83 00 "+fileManager.getValue("ARC/eARC_OUT"), typecmd);
        serialPortManager.writeDataUart5("SET IN1 EARC "+fileManager.getValue("ARC/eARC_OUT")+"\r\n", 1);

        systemSetup.main_mcu.text =""
//        systemSetup.tx_mcu.text =""
        systemSetup.key_mcu.text =""
        systemSetup.lan_mcu.text =version
//        systemSetup.av_mcu.text =""
        systemSetup.main_fpga.text =""
//        systemSetup.aux_fpga.text =""
//        systemSetup.aux2_fpga.text =""
        systemSetup.dsp_module.text =""
        systemSetup.chip_main_mcu.text =""
        systemSetup.chip_main_fgpa.text =""
        systemSetup.chip_aux_fpga.text =""

        systemSetup.fan_control_flag =parseInt(fileManager.getValue("FanControl"),16);
//        serialPortManager.writeDataUart5("AA 00 00 06 00 00 00 03 78 "+fileManager.getValue("FanControl"), typecmd);
        if(systemSetup.fan_control_flag==4){
            serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
        }else{
            serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
            serialPortManager.writeDataUart5("SET FAN SPEED "+parseInt(fileManager.getValue("FanControl"),16), 1);
        }

    }

    //send commend
    //VideoGenerator
    Connections{
        target: videoGenerator
        function onConfirmsignal(str, num){
            console.log(str,num)
            hexString = num.toString(16);
            if (hexString.length % 2 !== 0) {
                hexString = "0" + hexString;
            }
            var formattedHexString = "";
            for (var i = 0; i < hexString.length; i += 2) {
                formattedHexString += hexString.substr(i, 2) + " ";
            }
            hexString = formattedHexString.trim();

            strcode = "61 00 ";
            command_length = "06 00 "
            var completeString = ""
            if(str === "Timing"){
                strcode = "61 00 ";
                fileManager.updateData("Timing", hexString);
                var id_str = videoGenerator.timing_8k_model;
                for (var i = 0; i < id_str.count; i++) {
                    var item = id_str.get(i);
                    if(item.number === parseInt(hexString,16)){
                        statuspage.timingText = item.first+"@"+item.second;
                        break;
                    }
                }

                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;

                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "Pattern"){
                strcode = "62 00 ";
                command_length = "07 00 "
                while(hexString.length<4){
                    hexString = "0"+hexString;
                }
                var firstTwoDigits = hexString.slice(0,2);
                var lastTwoDigits = hexString.slice(-2);
                hexString = lastTwoDigits + " " + firstTwoDigits;
                fileManager.updateData("Pattern", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "Pattern_ire_window"){
                strcode = "FB 78 ";
                command_length = "07 00 "
                fileManager.updateData("Pattern_ire_window", hexString);
                hexString = num + " "+parseInt(videoGenerator.pattern_ire_level.text,10).toString(16).padStart(2, '0');
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "Pattern_ire_level"){
                strcode = "FB 78 ";
                command_length = "07 00 "
                fileManager.updateData("Pattern_ire_level", hexString);
                hexString = parseInt(videoGenerator.pattern_ire_window_size.text,10).toString(16).padStart(2, '0')+" "+num;
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "ColorSpace"){
                strcode = "63 00 ";
                fileManager.updateData("ColorSpace", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "Bt2020"){
                strcode = "70 00 ";
                fileManager.updateData("Bt2020", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "ColorDepth"){
                strcode = "64 00 ";
                fileManager.updateData("ColorDepth", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "HDCP"){
                strcode = "65 00 ";
                fileManager.updateData("HDCP", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "HDMI"){
                strcode = "66 00 ";
                fileManager.updateData("HDMI", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);

            }else if(str === "HDR"){
                hdrdata(num);
            }else if(str === "IMAX"){
                strcode = "D8 00 ";
                fileManager.updateData("IMAX", hexString);

                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }else if(str === "Rgb_YUV"){
                strcode = "7C 00 ";
                command_length = "14 00 ";
                var String="";
                for(var k=0;k<num.length;k++){
                    var value = parseInt(num[k], 10).toString(16).padStart(2, '0');
                    if(k==num.length-1){
                        String = String +value;
                    }else{
                        String = String +value+ " ";
                    }
                }
                hexString = String;
                fileManager.updateData("Rgb_YUV", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }else if(str === "Rgb"){
                strcode = "8C 00 ";
                command_length = "14 00 ";
                hexString = num;
                fileManager.updateData("Rgb", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
                var rgbdata = videoGenerator.windowRed.text + ","+
                        videoGenerator.windowGreen.text + ","+
                        videoGenerator.windowBlue.text + ","+
                        videoGenerator.backgroundRed.text + ","+
                        videoGenerator.backgroundGreen.text + ","+
                        videoGenerator.backgroundBlue.text + ","+
                        videoGenerator.rgb_window_size.text + ","+
                        videoGenerator.rgb_color_depth_flag + ","+
                        videoGenerator.rgb_color_space_flag ;
                webSocketServer.sendMessageToAllClients("RESPONSE||808C||"+ rgbdata +"\r\n");
            }else if(str === "timingdetails"){
                strcode = "A0 00 ";
                command_length = "19 00 ";
                hexString = num;
                fileManager.updateData("timingdetails", hexString);
                completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
                serialPortManager.writeData(completeString, typecmd);
            }

//            completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
//            serialPortManager.writeData(completeString, typecmd);
        }
    }
    //VideoTest
//    Connections{
//        target: videoTest

//        onConfirmsignal:{
//            console.log(str,num)
//            if(str == "VideoTest"){

//            }
//        }
//    }
    //AudioGenerator
    Connections{
        target: audioGenerator
       function onConfirmsignal(str, num){
            console.log(str,num)
            hexString = num.toString(16);
           if (hexString.length % 2 !== 0) {
               hexString = "0" + hexString;
           }
           var formattedHexString = "";
           for (var i = 0; i < hexString.length; i += 2) {
               formattedHexString += hexString.substr(i, 2) + " ";
           }
           hexString = formattedHexString.trim();

            strcode = "69 00 ";
            command_length = "06 00 "

            if(str === "AudioSamplingRate"){
                strcode = "67 00 ";
                fileManager.updateData("AudioSamplingRate", hexString);
                fileManager.updateData("audiotype", "PCM");
            }else if(str === "AudioBitDepth"){
                strcode = "68 00 ";
                fileManager.updateData("AudioBitDepth", hexString);
                fileManager.updateData("audiotype", "PCM");
            }else if(str === "SinewaveTone"){
                strcode = "73 00 ";
                fileManager.updateData("SinewaveTone", hexString);
                fileManager.updateData("audiotype", "PCM");

            }else if(str === "AudioVolume"){
                strcode = "6D 00 ";
//                hexString = (10-(num/6)).toString(16);
                if (hexString.length % 2 !== 0) {
                    hexString = "0" + hexString;
                }
                fileManager.updateData("AudioVolume", hexString);
                fileManager.updateData("audiotype", "PCM");

            }else if(str === "AudioChannelConfig"){
                strcode = "6B 00 ";
                fileManager.updateData("AudioChannelConfig", hexString);
                fileManager.updateData("audiotype", "PCM");

            }else if(str === "DolbyAudioGenerator"){
                fileManager.updateData("audiotype", "DOLBY");
//                statuspage.channelsText = "";
//                statuspage.audiobitText = "";
//                statuspage.samplerateText = "";
//                statuspage.audiovolumeText = "";
//                statuspage.sinewaretoneText = "";
                statuspage.typeText = "DOLBY";
                serialPortManager.writeData("AA 00 00 07 00 00 00 69 00 00 01", typecmd);
                strcode = "69 00 ";
                command_length = "07 00 "
//                var srt = command_header +command_length + command_group_address + command_device_address + strcode + "01 00";
//                serialPortManager.writeData(str, typecmd);
                while(hexString.length<4){
                    hexString = "0"+hexString;
                }
                var firstTwoDigits = hexString.slice(0,2);
                var lastTwoDigits = hexString.slice(-2);
                hexString = lastTwoDigits + " " + firstTwoDigits;
                fileManager.updateData("DOLBY", hexString);
            }else if(str === "EXT"){
                fileManager.updateData("audiotype", "Ext-Stereo");
//                statuspage.channelsText = "";
//                statuspage.audiobitText = "";
//                statuspage.samplerateText = "";
//                statuspage.audiovolumeText = "";
//                statuspage.sinewaretoneText = "";
                statuspage.typeText = "Ext-Stereo";
                strcode = "69 00 ";
                command_length = "07 00 "
                hexString = "00 00"
                fileManager.updateData("Ext-Stereo", hexString);
            }else if(str === "DTX"){
                serialPortManager.writeData("AA 00 00 07 00 00 00 69 00 00 01", typecmd);
                fileManager.updateData("audiotype", "DTS");
//                statuspage.channelsText = "";
//                statuspage.audiobitText = "";
//                statuspage.samplerateText = "";
//                statuspage.audiovolumeText = "";
//                statuspage.sinewaretoneText = "";
                statuspage.typeText = "DTS";
                strcode = "69 00 ";
                command_length = "07 00 ";
                while(hexString.length<4){
                    hexString = "0"+hexString;
                }
                firstTwoDigits = hexString.slice(0,2);
                astTwoDigits = hexString.slice(-2);
                hexString = lastTwoDigits + " " + firstTwoDigits;
                fileManager.updateData("DTS", hexString);
            }
            var completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
            serialPortManager.writeData(completeString, typecmd);
        }
    }
    //Edid_eARC_CDS
    Connections{
        target: edid
        function onConfirmsignal(str, num){
            console.log(str,num)
            hexString = num.toString(16);
            if (hexString.length % 2 !== 0) {
                hexString = "0" + hexString;
            }
            var formattedHexString = "";
            for (var i = 0; i < hexString.length; i += 2) {
                formattedHexString += hexString.substr(i, 2) + " ";
            }
            hexString = formattedHexString.trim();
            strcode = "61 00 ";
            command_length = "06 00 ";
            var isfpga = true;
            if(str === "ARC_HPD_CTL"){
                strcode = "B1 00 ";
                isfpga = false;
                fileManager.updateData("ARC_HPD_CTL", hexString);
            }else if(str === "eARC_Physical_HPD_CTL"){
                strcode = "B1 00 ";
                isfpga = false;
                fileManager.updateData("eARC_Physical_HPD_CTL", hexString);
            }else if(str === "eARC_HPD_bit_CTL"){
                strcode = "B2 00 ";
                isfpga = false;
                fileManager.updateData("eARC_HPD_bit_CTL", hexString);

            }else if(str === "HDMI_5V_POWER_CTL"){
                strcode = "B3 00 ";
//                fileManager.updateData("HDMI_5V_POWER_CTL", hexString);
                serialPortManager.writeDataUart5("SET HDMI 5V "+(hexString==="00"? "OFF":"ON")+"\r\n",1);
            }else if(str === "eARCTX_Latency_REQ"){
                strcode = "79 00 ";
                isfpga = false;
                fileManager.updateData("eARCTX_Latency_REQ", hexString);
                serialPortManager.writeDataUart5("SET TXLAT "+num+"\r\n",1);
            }else if(str === "eARCTX_Latency"){
                strcode = "7A 00 ";
                isfpga = false;
                fileManager.updateData("eARCTX_Latency", hexString);
            }else if(str === "eARCRX_Latency"){
                isfpga = false;
            }else if (str === "readEDID"){
//                strcode = "3E B8 ";
//                command_length = "06 00 ";
                strcode = "38 B8 ";
                command_length = "05 00 ";
//                hexString = "";
                serialPortManager.writeDataUart5("GET IN1 EDID1 DATA\r\n",1);
            }

            var completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
            if(isfpga){
                serialPortManager.writeData(completeString, typecmd);
            }else{
                serialPortManager.writeDataUart5(completeString,typecmd);
            }


        }
    }
    //SystemSetup
    Connections{
        target: systemSetup

        function onConfirmsignal(str, num){
            console.log(str,num)
            hexString = num.toString(16);
            if (hexString.length % 2 !== 0) {
                hexString = "0" + hexString;
            }
            var formattedHexString = "";
            for (var i = 0; i < hexString.length; i += 2) {
                formattedHexString += hexString.substr(i, 2) + " ";
            }
            hexString = formattedHexString.trim();

            strcode = "61 00 ";
            command_length = "06 00 "
            if(str === "DHCP"){
                if(num===1){
                    netManager.setIpAddress("192.168.1.223", "255.255.0.0","192.168.1.2","dhcp");
//                    serialPortManager.writeData("AA 00 00 06 00 00 00 F7 78 01", typecmd);
                    fileManager.updateData("ipmode", "dhcp");
                }else{
                    netManager.setIpAddress(systemSetup.host_ip.text, systemSetup.ip_mask.text,systemSetup.router_ip.text,"static");
                    fileManager.updateData("ipmode", "static");
                    fileManager.updateData("iphost", systemSetup.host_ip.text);
                    fileManager.updateData("ipmask", systemSetup.ip_mask.text);
                    fileManager.updateData("iprouter", systemSetup.router_ip.text);
//                    serialPortManager.writeData("AA 00 00 06 00 00 00 F7 78 00", typecmd);
//                    var hex_ip ="";
//                    var hex_mask ="";
//                    var hex_router ="";
//                    var ip_parts = systemSetup.host_ip.text.split(".");
//                    var mask_parts = systemSetup.ip_mask.text.split(".");
//                    var route_parts = systemSetup.router_ip.text.split(".");
//                    for(var k=0;k<4;k++){
//                        hex_ip += " "+parseInt(ip_parts[k], 10).toString(16).padStart(2, '0');
//                        hex_mask += " "+parseInt(mask_parts[k], 10).toString(16).padStart(2, '0');
//                        hex_router += " "+parseInt(route_parts[k], 10).toString(16).padStart(2, '0');
//                    }
//                    serialPortManager.writeData("AA 00 00 06 00 00 00 F2 78"+hex_ip, typecmd);
//                    serialPortManager.writeData("AA 00 00 06 00 00 00 F3 78"+hex_mask, typecmd);
//                    serialPortManager.writeData("AA 00 00 06 00 00 00 F4 78"+hex_router, typecmd);
//                    return
                }
            }else if(str === "ARC/eARC_OUT"){
                strcode = "83 00 ";
                command_length = "06 00 ";
                fileManager.updateData("ARC/eARC_OUT", hexString);
                serialPortManager.writeDataUart5("SET IN1 EARC"+num+"\r\n",1);
            }else if(str === "FanControl"){
//                strcode = "03 78 ";
//                command_length = "06 00 ";
//                fileManager.updateData("FanControl", hexString);
                if(num === 4){
                    serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
                }else{
                    serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
                    serialPortManager.writeDataUart5("SET FAN SPEED "+num+"\r\n", 1);
                }
                return
            }else if(str === "ResetDefault"){
                reset();
            }else if(str === "Reboot"){
                syscmd = "reboot";
                terminalManager.executeCommand(syscmd)
            }else if(str === "PowerOut"){
                strcode = "AB 00 ";
                command_length = "06 00 ";
                terminalManager.executeCommand("echo 105 > /sys/class/gpio/export");
                terminalManager.executeCommand("echo out > /sys/class/gpio/gpio105/direction");
                if(num===0){
                    isBlack = false;
                    terminalManager.executeCommand("echo 0 > /sys/class/gpio/gpio105/value");
                }else{
                    terminalManager.executeCommand("echo 1 > /sys/class/gpio/gpio105/value");
                    isBlack = true;
                }
            }else if(str === "vitals"){
                strcode = "58 F8 ";
                command_length = "06 00 ";
                hexString = "10"
                cht8310.readData();
                serialPortManager.writeDataUart5("GET NTC 1 VALUE\r\n",1);
                serialPortManager.writeDataUart5("GET NTC 1 VALUE\r\n",1);
                serialPortManager.writeDataUart5("GET VER INF\r\n",1);
                serialPortManager.writeDataUart6("AA 01 00 05 00 01 00 58 F8",0);
//                terminalManager.executeCommand("/userdata/spi -r -a 0000");
            }else if(str === "LinkTrainForce"){
                strcode = "C0 00 ";
                command_length = "07 00 "
                if(num===0){
                    hexString = "00 00"
                }
            }else if(str === "LinkTrain"){
                strcode = "C1 00 ";
                command_length = "07 00 "
            }else if(str === "AudioInfoframeRead"){
                strcode = "01 FE ";
                command_length = "05 00 "
            }else if(str === "AudioInfoframeWrite"){
                strcode = "01 7E ";
                command_length = "07 00 "
            }

            var completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
            serialPortManager.writeData(completeString, typecmd);
        }
    }

    Rectangle{
//        visible: false
        id:mianpage
        width: window.width-mainline.width
        height:parent.height
        anchors.left: mainline.right
        color: "lightgray"


        TabBar {
            id:bar
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width
            contentHeight:120
            TabButton {
                text: "Monitor"
                font.family: myriadPro.name
                font.pixelSize: 30
            }
            TabButton {
                text: "Signal Info"
                font.family: myriadPro.name
                font.pixelSize: 30
            }
            TabButton {
                text: "EDID"
                font.family: myriadPro.name
                font.pixelSize: 30
            }
            TabButton {
                text: "Error Rate"
                font.family: myriadPro.name
                font.pixelSize: 30
            }
            TabButton {
                text: "System Setup"
                font.family: myriadPro.name
                font.pixelSize: 30
            }
            TabButton {
                text: "SG System"
                font.family: myriadPro.name
                font.pixelSize: 30
            }
        }

        StackLayout {
            width: parent.width
            height: parent.height-bar.height
            anchors.top: bar.bottom
            anchors.left: bar.left
            currentIndex: bar.currentIndex
            
            // SA01H页面
            Item {
                id: signalAnalyzer_page
                SignalAnalyzer{
                    id: signalAnalyzer
                    color: "lightgray"
                    pageFlag: 0  // Monitor
                }
            }
            
            Item {
                id: signalInfo_page
                SignalAnalyzer{
                    color: "lightgray"
                    pageFlag: 1  // Signal Info
                }
            }
            
            Item {
                id: edidSA_page
                SignalAnalyzer{
                    color: "lightgray"
                    pageFlag: 2  // EDID
                }
            }
            
            Item {
                id: errorRate_page
                SignalAnalyzer{
                    color: "lightgray"
                    pageFlag: 3  // Error Rate
                }
            }
            
            Item {
                id: saSystemSetup_page
                SystemSetupPanel{
                    id: saSystemSetup
                    color: "lightgray"
                }
            }
            
            // SG01H原有页面
            Item {
                id: system_page
                SystemSetup{
                    id:systemSetup
                    color: "lightgray"
                }
            }
        }
    }
}
