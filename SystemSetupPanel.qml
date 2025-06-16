// SystemSetupPanel.qml
// 系统设置面板，包含IP管理、风扇控制、重置重启、设备状态等功能
// 适配当前应用的蓝色风格主题

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Rectangle {
    id: systemSetupPanel
    anchors.fill: parent
    color: "#585858"          // 背景色
    border.color: "black"
    border.width: 2
    radius: 4

    // Signal definition for communication with C++ backend
    signal confirmsignal(string str, var num)

    // Add property aliases for backward compatibility
    property alias hostIpText: hostIpField.text
    property alias ipMaskText: ipMaskField.text
    property alias routerIpText: routerIpField.text

    // Or provide more direct text access
    function getHostIp() { return hostIpField.text; }
    function getIpMask() { return ipMaskField.text; }
    function getRouterIp() { return routerIpField.text; }

    // Property definitions - 与SystemSetup.qml保持一致
    property bool ip_management_dhcp_flag: false  // DHCP模式标志
    property int fan_control_flag: 0              // 风扇控制模式
    property int currentSection: 0                // 当前显示区域: 0=IP, 1=Fan, 2=Reset, 3=Vitals
    
    // 版本信息属性 - 与SystemSetup.qml保持一致
    property alias main_mcu: mainMcuText
    property alias key_mcu: keyMcuText  
    property alias lan_mcu: lanMcuText
    property alias main_fpga: mainFpgaText
    property alias dsp_module: dspModuleText
    property alias tx_mcu: txMcuText
    property alias av_mcu: avMcuText
    property alias aux_fpga: auxFpgaText
    property alias aux2_fpga: aux2FpgaText
    
    // 温度信息属性
    property alias chip_main_mcu: mainMcuTempText
    property alias chip_main_fgpa: mainFpgaTempText
    property alias chip_aux_fpga: auxFpgaTempText
    
    // 网络信息属性
    property alias host_ip: hostIpField
    property alias router_ip: routerIpField
    property alias ip_mask: ipMaskField
    property alias mac_address: macAddressText
    property alias tcp_port: tcpPortText

    // 主布局
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 功能导航按钮区
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            spacing: 10

            Repeater {
                model: [
                    { name: "IP Management", index: 0 },
                    { name: "Fan Control", index: 1 },
                    { name: "Reset & Reboot", index: 2 },
                    { name: "Vitals", index: 3 }
                ]
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    text: modelData.name
                    font.pixelSize: 16
                    
                    background: Rectangle {
                        color: currentSection === modelData.index ? "#ffffff" : "#888888"
                        border.color: "black"
                        border.width: 2
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: currentSection === modelData.index ? "black" : "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        currentSection = modelData.index
                        // 如果切换到Vitals页面，请求设备状态 - 与SystemSetup.qml保持一致
                        if (modelData.index === 3) {
                            confirmsignal("vitals", 0x00);  // 请求所有组件状态
                        }
                    }
                }
            }
        }

        // 内容区域
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // IP管理面板
            Rectangle {
                visible: currentSection === 0
                width: parent.parent.width - 40
                height: Math.max(600, ipColumn.implicitHeight + 40)
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                Column {
                    id: ipColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20


                    // IP设置表单
                    Grid {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 15
                        anchors.horizontalCenter: parent.horizontalCenter

                        // HOST IP
                        Text {
                            text: "HOST IP:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "white"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            TextField {
                                id: hostIpField
                                anchors.fill: parent
                                anchors.margins: 2
                                text: netManager.ipAddress || "192.168.1.199"
                                font.pixelSize: 20
                                horizontalAlignment: TextInput.AlignHCenter
                                background: Rectangle { color: "transparent" }
                                
                                onPressed: {
                                    currentInputField = hostIpField;
                                    currentText = hostIpField.text;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }

                        // ROUTER IP
                        Text {
                            text: "ROUTER IP:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "white"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            TextField {
                                id: routerIpField
                                anchors.fill: parent
                                anchors.margins: 2
                                text: netManager.routerIpAddress || "192.168.1.254"
                                font.pixelSize: 20
                                horizontalAlignment: TextInput.AlignHCenter
                                background: Rectangle { color: "transparent" }
                                
                                onPressed: {
                                    currentInputField = routerIpField;
                                    currentText = routerIpField.text;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }

                        // IP MASK
                        Text {
                            text: "IP MASK:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "white"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            TextField {
                                id: ipMaskField
                                anchors.fill: parent
                                anchors.margins: 2
                                text: netManager.netmask || "255.255.255.0"
                                font.pixelSize: 20
                                horizontalAlignment: TextInput.AlignHCenter
                                background: Rectangle { color: "transparent" }
                                
                                onPressed: {
                                    currentInputField = ipMaskField;
                                    currentText = ipMaskField.text;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }

                        // MAC ADDRESS (只读)
                        Text {
                            text: "MAC ADDRESS:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "#eeeeee"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            Text {
                                id: macAddressText
                                anchors.centerIn: parent
                                text: netManager.macAddress || "00:00:00:00:00:00"
                                font.pixelSize: 20
                                color: "#666666"
                            }
                        }

                        // TCP PORT (只读)
                        Text {
                            text: "TCP PORT:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "#eeeeee"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            Text {
                                id: tcpPortText
                                anchors.centerIn: parent
                                text: "8080"
                                font.pixelSize: 20
                                color: "#666666"
                            }
                        }
                    }

                    // DHCP/Static 切换按钮 - 与SystemSetup.qml保持一致
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20
                        
                        Button {
                            text: "DHCP"
                            font.pixelSize: 20
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            
                            background: Rectangle {
                                color: ip_management_dhcp_flag ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: ip_management_dhcp_flag ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                ip_management_dhcp_flag = true
                                confirmsignal("DHCP", true)  // 发送DHCP启用信号
                            }
                        }
                        
                        Button {
                            text: "Static"
                            font.pixelSize: 20
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            
                            background: Rectangle {
                                color: ip_management_dhcp_flag ? "#888888" : "#ffffff"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: ip_management_dhcp_flag ? "white" : "black"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                ip_management_dhcp_flag = false
                                confirmsignal("DHCP", false)  // 发送Static模式信号
                            }
                        }
                    }

                    // 在DHCP/Static按钮下方添加Apply按钮
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20
                        visible: !ip_management_dhcp_flag  // 只在静态IP模式下显示
                        
                        Button {
                            text: "Apply Static IP"
                            font.pixelSize: 18
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 50
                            
                            background: Rectangle {
                                color: "#4CAF50"  // 绿色
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                // 强制刷新输入框的值
                                hostIpField.focus = false;
                                routerIpField.focus = false;
                                ipMaskField.focus = false;
                                
                                // 等待一帧后读取值
                                Qt.callLater(function() {
                                    console.log("Applying static IP configuration");
                                    console.log("- Host IP:", hostIpField.text);
                                    console.log("- Router IP:", routerIpField.text);
                                    console.log("- IP Mask:", ipMaskField.text);
                                    
                                    // 使用实际的文本值而不是属性绑定
                                    var actualHostIp = hostIpField.text;
                                    var actualRouterIp = routerIpField.text;
                                    var actualIpMask = ipMaskField.text;
                                    
                                    console.log("Actual values to apply:");
                                    console.log("- Host IP:", actualHostIp);
                                    console.log("- Router IP:", actualRouterIp);
                                    console.log("- IP Mask:", actualIpMask);
                                    
                                    // 直接调用netManager设置，不依赖confirmsignal
                                    netManager.setIpAddress(actualHostIp, actualIpMask, actualRouterIp, "static");
                                });
                            }
                        }
                    }
                }
            }

            // 风扇控制面板
            Rectangle {
                visible: currentSection === 1
                width: parent.parent.width - 40
                height: 400
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                GridLayout {
                    anchors.centerIn: parent
                    columns: 3
                    rowSpacing: 20
                    columnSpacing: 20

                    Repeater {
                        model: [
                            { name: "OFF", value: 0x00 },
                            { name: "LOW SPEED", value: 0x01 },
                            { name: "MIDDLE SPEED", value: 0x02 },
                            { name: "HIGH SPEED", value: 0x03 },
                            { name: "AUTO", value: 0x04 }
                        ]
                        
                        Button {
                            text: modelData.name
                            font.pixelSize: 18
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 80
                            
                            background: Rectangle {
                                color: fan_control_flag === modelData.value ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: fan_control_flag === modelData.value ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                fan_control_flag = modelData.value
                                confirmsignal("FanControl", modelData.value)
                            }
                        }
                    }
                }
            }

            // 重置重启面板
            Rectangle {
                visible: currentSection === 2
                width: parent.parent.width - 40
                height: 300
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 50
                    
                    Button {
                        text: "Reset Default"
                        font.pixelSize: 20
                        Layout.preferredWidth: 250
                        Layout.preferredHeight: 100
                        
                        background: Rectangle {
                            color: "#ff6666"
                            border.color: "black"
                            border.width: 2
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            confirmsignal("ResetDefault", 0)
                        }
                    }
                    
                    Button {
                        text: "Reboot"
                        font.pixelSize: 20
                        Layout.preferredWidth: 250
                        Layout.preferredHeight: 100
                        
                        background: Rectangle {
                            color: "#ffaa00"
                            border.color: "black"
                            border.width: 2
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            confirmsignal("Reboot", 0)
                        }
                    }
                }
            }

            // 设备状态面板
            Rectangle {
                visible: currentSection === 3
                width: parent.parent.width - 40
                height: Math.max(800, vitalsColumn.implicitHeight + 40)
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                Column {
                    id: vitalsColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 30

                    // 固件版本信息
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: "FIRMWARE VERSION"
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Grid {
                            columns: 2
                            columnSpacing: 20
                            rowSpacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            // Main MCU
                            Text {
                                text: "Main MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // TX MCU
                            Text {
                                text: "TX MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: txMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // Key MCU
                            Text {
                                text: "Key MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: keyMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // LAN MCU
                            Text {
                                text: "LAN MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: lanMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AV MCU
                            Text {
                                text: "AV MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: avMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // Main FPGA
                            Text {
                                text: "Main FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainFpgaText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AUX FPGA
                            Text {
                                text: "AUX FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: auxFpgaText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AUX2 FPGA
                            Text {
                                text: "AUX2 FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: aux2FpgaText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // DSP Module
                            Text {
                                text: "DSP Module:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: dspModuleText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }
                        }
                    }

                    // 芯片温度信息
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: "MAIN CHIP TEMPERATURE"
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Grid {
                            columns: 2
                            columnSpacing: 20
                            rowSpacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            // Main MCU Temperature
                            Text {
                                text: "Main MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainMcuTempText
                                    anchors.centerIn: parent
                                    text: "25°C"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // Main FPGA Temperature
                            Text {
                                text: "Main FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainFpgaTempText
                                    anchors.centerIn: parent
                                    text: "25°C"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AUX FPGA Temperature
                            Text {
                                text: "AUX FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: auxFpgaTempText
                                    anchors.centerIn: parent
                                    text: "25°C"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }
                        }
                    }
                }
            }

        }
    }

    // 虚拟键盘支持
    property var currentInputField: null
    property string currentText: ""
    
    VirtualKeyboard {
        id: virtualKeyboard
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: false
        
        onKeyPressed: {
            if (key === "Backspace") {
                if (currentText.length > 0) {
                    currentText = currentText.slice(0, -1)
                }
            } else if (key === "Close") {
                visible = false
                currentInputField = null
                currentText = ""
            } else {
                currentText += key
            }
            
            if (currentInputField) {
                currentInputField.text = currentText
            }
        }
    }

    // 组件初始化 - 与SystemSetup.qml保持一致
    Component.onCompleted: {
        console.log("SystemSetupPanel initialized");
        // 初始化时清空版本信息显示
        main_mcu.text = ""
        key_mcu.text = ""
        lan_mcu.text = ""  // 将在main.qml中设置为当前软件版本
        main_fpga.text = ""
        dsp_module.text = ""
        tx_mcu.text = ""
        av_mcu.text = ""
        aux_fpga.text = ""
        aux2_fpga.text = ""
        chip_main_mcu.text = ""
        chip_main_fgpa.text = ""
        chip_aux_fpga.text = ""
    }

} 