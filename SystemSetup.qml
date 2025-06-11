import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Rectangle {
    id:root
    anchors.fill: parent
    signal confirmsignal(string str,int num)

    property alias host_ip: host_ip
    property alias router_ip: router_ip
    property alias ip_mask: ip_mask
    property alias mac_address: mac_address
    property alias tcp_port: tcp_port

    property alias main_mcu: main_mcu
//    property alias tx_mcu: tx_mcu
    property alias key_mcu: key_mcu
    property alias lan_mcu: lan_mcu
//    property alias av_mcu: av_mcu
    property alias main_fpga: main_fpga
//    property alias aux_fpga: aux_fpga
//    property alias aux2_fpga: aux2_fpga
    property alias dsp_module: dsp_module

    property alias chip_main_mcu: chip_main_mcu
    property alias chip_main_fgpa: chip_main_fgpa
    property alias chip_aux_fpga: chip_aux_fpga

    property int pageindex: 0
    property int pageflag: 0
    property int btnWidth: 300
    property int btnHeight: 120
    property int btnfontsize: 35


    CustomButton{
        id:back
        visible: pageflag == 0?false:true
        width:150
        height:80
        border.color: "black"
        border.width: 2
        color: flag?'gray':'black'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        property bool flag:false
        Text {
            text: qsTr("Back")
            anchors.centerIn: parent
            font.family: myriadPro.name
            font.pixelSize: btnfontsize
            color: "white"
        }
        MouseArea{
            anchors.fill: parent
            onPressed: {
                back.flag = true
            }
            onReleased: {
                back.flag = false
                if(pageindex == 1){
                    pageflag = 0
                    pageindex = 0
                }else if(pageindex == 2){
                    pageindex = 1
                }
            }
        }
    }

    //page
    GridLayout{
        visible: pageflag == 0?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: edid_model
            ListElement { first: "IP Management"; number: 1 }
            ListElement { first: "Fan Control"; number: 2 }
            ListElement { first: "Reset & Reboot"; number: 3 }
            ListElement { first: "Vitals"; number: 4 }
        }
        Repeater{
            model: edid_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: pageflag==number?"orange":"black"
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pageflag=number
                        pageindex = 1
                        if(pageflag==2){
                            // Fan Control - 不需要预加载数据
                        }else if(pageflag==3){
                            // Reset & Reboot - 不需要预加载数据
                        }else if(pageflag==4){
                            // Vitals - 获取系统状态信息
                            confirmsignal("vitals",0x00);
                        }
                    }
                }
            }
        }

    }



    //ip management
    property bool ip_management_dhcp_flag: false
    RowLayout {
        visible: pageflag==1&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 600
            width: 800
            Column{
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 50
                spacing:20
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "HOST IP:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius:5
                        color: "white"
                        TextField {
                            id:host_ip
                            width: 250
                            height: 50
                            text: qsTr("192.168.1.199")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "transparent"
                                border.width: 0
                            }
                            onPressed: {
                                currentInputField = host_ip;
                                virtualKeyboard.visible = true
                            }
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "ROUTER IP:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius:5
                        color: "white"
                        TextField {
                            id:router_ip
                            width: 250
                            height: 50
                            text: qsTr("192.168.1.254")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "transparent"
                                border.width: 0
                            }
                            onPressed: {
                                currentInputField = router_ip;
                                virtualKeyboard.visible = true
                            }
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "IP MASK:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius:5
                        color: "white"
                        TextField {
                            id:ip_mask
                            width: 250
                            height: 50
                            text: qsTr("255.255.255")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "transparent"
                                border.width: 0
                            }
                            onPressed: {
                                currentInputField = ip_mask;
                                virtualKeyboard.visible = true
                            }
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    enabled: false
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "MAC ADDRESS:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius:5
                        color: "white"
                        TextField{
                            id:mac_address
                            width: 250
                            height: 50
                            text: "0"
                            font.pixelSize: btnfontsize
                            font.family: myriadPro.name
                            horizontalAlignment: TextInput.AlignHCenter
                            color: "black"
                            enabled: false
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter

                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "TCP PORT:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius:5
                        color: "white"
                        TextField{
                            id:tcp_port
                            width: 250
                            height: 50
                            text: "0"
                            font.pixelSize: btnfontsize
                            font.family: myriadPro.name
                            horizontalAlignment: TextInput.AlignHCenter
                            color: "black"
                            enabled: false
                        }
                    }
                }

                Rectangle{
                    height: 20
                    width: 100
                    color: "transparent"
                }

                RowLayout {
                    width: parent.width
                    CustomButton{
                        id:dhcp_on
                        width:200
                        height:60
                        border.color: !ip_management_dhcp_flag ? "black" : "orange"
                        border.width: 4
                        color: !ip_management_dhcp_flag?'gray':'black'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Text {
                            text: qsTr("DHCP")
                            anchors.centerIn: parent
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                ip_management_dhcp_flag = true

                                confirmsignal("DHCP",true)
                            }
                        }
                    }
                    CustomButton{
                        width:200
                        height:60
                        border.color: ip_management_dhcp_flag ? "black" : "orange"
                        border.width: 4
                        color: ip_management_dhcp_flag?'gray':'black'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Text {
                            text: qsTr("Static")
                            anchors.centerIn: parent
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                ip_management_dhcp_flag = false

                                confirmsignal("DHCP",false)
                            }
                        }
                    }

                }
            }

        }
    }

    //fan control
    property int fan_control_flag: 0
    GridLayout{
        visible: pageflag==2&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 2
        ListModel {
            id: fan_control_model
            ListElement { first: "Auto"; number: 4 }
            ListElement { first: "Speed 1"; number: 1 }
            ListElement { first: "Speed 2"; number: 2 }
            ListElement { first: "Speed 3"; number: 3 }
        }
        Repeater{
            model: fan_control_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: fan_control_flag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        fan_control_flag=number
                        confirmsignal("FanControl",number)
                    }
                }
            }
        }
    }

    //reset & reboot
    GridLayout{
        visible: pageflag==3&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 2
        ListModel {
            id: reset_reboot_model
            ListElement { first: "Factory Reset"; action: "ResetDefault" }
            ListElement { first: "Reboot System"; action: "Reboot" }
        }
        Repeater{
            model: reset_reboot_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        confirmsignal(action, 0)
                    }
                }
            }
        }
    }

    //vitals
    RowLayout {
        visible: pageflag==4&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 750
            width: 700
            Column{
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing:10
                Text {
                    text: "FIRMWARE VERSION"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:main_mcu
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
//                RowLayout{
//                    anchors.horizontalCenter : parent.horizontalCenter
//                    Rectangle {
//                        width: 150
//                        height: 40
//                        color: "transparent"

//                        Text {
//                            text: "TX MCU:"
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.left: parent.left
//                            anchors.verticalCenter: parent.verticalCenter
//                            horizontalAlignment: Text.AlignLeft
//                        }
//                    }
//                    Rectangle{
//                        width: 200
//                        height: 40
//                        radius:5
//                        color: "white"
//                        Text {
//                            id:tx_mcu
//                            text: qsTr("")
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.centerIn: parent
//                        }
//                    }
//                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "C51 MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:key_mcu
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main FPGA:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:main_fpga
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Control Module:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:lan_mcu
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
//                RowLayout{
//                    anchors.horizontalCenter : parent.horizontalCenter
//                    Rectangle {
//                        width: 150
//                        height: 40
//                        color: "transparent"

//                        Text {
//                            text: "AV MCU:"
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.left: parent.left
//                            anchors.verticalCenter: parent.verticalCenter
//                            horizontalAlignment: Text.AlignLeft
//                        }
//                    }
//                    Rectangle{
//                        width: 200
//                        height: 40
//                        radius:5
//                        color: "white"
//                        Text {
//                            id:av_mcu
//                            text: qsTr("")
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.centerIn: parent
//                        }
//                    }
//                }


//                RowLayout{
//                    anchors.horizontalCenter : parent.horizontalCenter
//                    Rectangle {
//                        width: 150
//                        height: 40
//                        color: "transparent"

//                        Text {
//                            text: "AUX FPGA:"
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.left: parent.left
//                            anchors.verticalCenter: parent.verticalCenter
//                            horizontalAlignment: Text.AlignLeft
//                        }
//                    }
//                    Rectangle{
//                        width: 200
//                        height: 40
//                        radius:5
//                        color: "white"
//                        Text {
//                            id:aux_fpga
//                            text: qsTr("")
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.centerIn: parent
//                        }
//                    }
//                }
//                RowLayout{
//                    anchors.horizontalCenter : parent.horizontalCenter
//                    Rectangle {
//                        width: 150
//                        height: 40
//                        color: "transparent"

//                        Text {
//                            text: "AUX2 FPGA:"
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.left: parent.left
//                            anchors.verticalCenter: parent.verticalCenter
//                            horizontalAlignment: Text.AlignLeft
//                        }
//                    }
//                    Rectangle{
//                        width: 200
//                        height: 40
//                        radius:5
//                        color: "white"
//                        Text {
//                            id:aux2_fpga
//                            text: qsTr("")
//                            font.family: myriadPro.name
//                            font.pixelSize: btnfontsize
//                            color: "black"
//                            anchors.centerIn: parent
//                        }
//                    }
//                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "DSP Module:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:dsp_module
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }

                Text {
                    text: "MAIN CHIP TEMPERATURE"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:chip_main_mcu
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main FPGA:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:chip_main_fgpa
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter
                    Rectangle {
                        width: 170
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Control Module:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius:5
                        color: "white"
                        Text {
                            id:chip_aux_fpga
                            text: qsTr("")
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }

            }

        }
    }



    //reset & reboot (old implementation - should be removed)
    RowLayout {
        visible: false
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        CustomButton{
            id:reset_btn
            width:btnWidth
            height:btnHeight
            border.color: "black"
            border.width: 2
            color: flag?'gray':'black'
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag:false
            Text {
                text: qsTr("Reset Default")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    reset_btn.flag = true
                }
                onReleased: {
                    reset_btn.flag = false
                    confirmsignal("ResetDefault",true)
                }
            }
        }

        CustomButton{
            id:reboot_btn
            width:btnWidth
            height:btnHeight
            border.color: "black"
            border.width: 2
            color: flag?'gray':'black'
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag:false
            Text {
                text: qsTr("Reboot")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    reboot_btn.flag = true
                }
                onReleased: {
                    reboot_btn.flag = false
                    confirmsignal("Reboot",true)
                }
            }
        }
    }

    //Tools (disabled)
    property int tool_flag: 0
    RowLayout {
        visible: false
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        CustomButton{
            id:audio_info
            width:btnWidth
            height:btnHeight
            border.color: "black"
            border.width: 2
            color: flag?'gray':'black'
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag:false
            Text {
                text: qsTr("Audio Infoframe")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    audio_info.flag = true
                }
                onReleased: {
                    audio_info.flag = false
                    pageindex = 2
                    tool_flag = 1
                }
            }
        }
        CustomButton{
            id:link_train
            width:btnWidth
            height:btnHeight
            border.color: "black"
            border.width: 2
            color: flag?'gray':'black'
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag:false
            Text {
                text: qsTr("Link Train")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    link_train.flag = true
                }
                onReleased: {
                    link_train.flag = false
                    pageindex = 2
                    tool_flag = 2
                }
            }
        }
    }
    function writeinfoframe(){
        var data = ["84", "01", "0A"];
        //1
        var byte1 =
        this.combobox1.currentText.substring(0, 4) + "0" + this.combobox2.currentText.substring(0, 3);
        if (parseInt(byte1, 2).toString(16).length === 1) {
            byte1 = "0" + parseInt(byte1, 2).toString(16).toUpperCase();
        } else {
            byte1 = parseInt(byte1, 2).toString(16).toUpperCase();
        }
        data.push(byte1);
        //2
        var byte2 =
            "000" + this.combobox3.currentText.substring(0, 3) + this.combobox4.currentText.substring(0, 2);
        if (parseInt(byte2, 2).toString(16).length === 1) {
            byte2 = "0" + parseInt(byte2, 2).toString(16).toUpperCase();
        } else {
            byte2 = parseInt(byte2, 2).toString(16).toUpperCase();
        }
        data.push(byte2);
        //3
        var byte3 = this.combobox5.currentText.substring(2, 4);
        data.push(byte3);
        //4
        var byte4 = this.combobox6.currentText.substring(2, 4);
        data.push(byte4);
        //5
        var byte5 =
            this.combobox7.currentText.substring(0, 1) +
            this.combobox8.currentText.substring(0, 4) +
            "0" +
            this.combobox9.currentText.substring(0, 2);
        if (parseInt(byte5, 2).toString(16).length === 1) {
            byte5 = "0" + parseInt(byte5, 2).toString(16).toUpperCase();
        } else {
            byte5 = parseInt(byte5, 2).toString(16).toUpperCase();
        }
        data.push(byte5);
        if (this.combobox6.currentText === "0xFE") {
            //6
            var byte6 =
              this.combobox6_1.currentText +
              this.combobox6_2.currentText +
              this.combobox6_3.currentText +
              this.combobox6_4.currentText +
              this.combobox6_5.currentText +
              this.combobox6_6.currentText +
              this.combobox6_7.currentText +
              this.combobox6_8.currentText;
            if (parseInt(byte6, 2).toString(16).length === 1) {
              byte6 = "0" + parseInt(byte6, 2).toString(16).toUpperCase();
            } else {
              byte6 = parseInt(byte6, 2).toString(16).toUpperCase();
            }
            data.push(byte6);
            //7
            var byte7 =
              this.combobox7_1.currentText +
              this.combobox7_2.currentText +
              this.combobox7_3.currentText +
              this.combobox7_4.currentText +
              this.combobox7_5.currentText +
              this.combobox7_6.currentText +
              this.combobox7_7.currentText +
              this.combobox7_8.currentText;
            if (parseInt(byte7, 2).toString(16).length === 1) {
              byte7 = "0" + parseInt(byte7, 2).toString(16).toUpperCase();
            } else {
              byte7 = parseInt(byte7, 2).toString(16).toUpperCase();
            }
            data.push(byte7);
            //8
            var byte8 =
              "0000" +
              this.combobox8_5.currentText +
              this.combobox8_6.currentText +
              this.combobox8_7.currentText +
              this.combobox8_8.currentText;
            if (parseInt(byte8, 2).toString(16).length === 1) {
              byte8 = "0" + parseInt(byte8, 2).toString(16).toUpperCase();
            } else {
              byte8 = parseInt(byte8, 2).toString(16).toUpperCase();
            }
            data.push(byte8);
            data.push("00");
            data.push("00");
          } else if (this.combobox6.currentText === "0xFF") {
            //6
            byte6 =
              this.combobox6_1.currentText +
              this.combobox6_2.currentText +
              this.combobox6_3.currentText +
              this.combobox6_4.currentText +
              this.combobox6_5.currentText +
              this.combobox6_6.currentText +
              this.combobox6_7.currentText +
              this.combobox6_8.currentText;
            if (parseInt(byte6, 2).toString(16).length === 1) {
              byte6 = "0" + parseInt(byte6, 2).toString(16).toUpperCase();
            } else {
              byte6 = parseInt(byte6, 2).toString(16).toUpperCase();
            }
            data.push(byte6);
            //7
            byte7 =
              this.combobox7_1.currentText +
              this.combobox7_2.currentText +
              this.combobox7_3.currentText +
              this.combobox7_4.currentText +
              this.combobox7_5.currentText +
              this.combobox7_6.currentText +
              this.combobox7_7.currentText +
              this.combobox7_8.currentText;
            if (parseInt(byte7, 2).toString(16).length === 1) {
              byte7 = "0" + parseInt(byte7, 2).toString(16).toUpperCase();
            } else {
              byte7 = parseInt(byte7, 2).toString(16).toUpperCase();
            }
            data.push(byte7);
            //8
            byte8 =
              this.combobox8_1.currentText +
              this.combobox8_1.currentText +
              this.combobox8_1.currentText +
              this.combobox8_1.currentText +
              this.combobox8_1.currentText +
              this.combobox8_1.currentText +
              this.combobox8_1.currentText +
              this.combobox8_1.currentText;
            if (parseInt(byte8, 2).toString(16).length === 1) {
              byte8 = "0" + parseInt(byte8, 2).toString(16).toUpperCase();
            } else {
              byte8 = parseInt(byte8, 2).toString(16).toUpperCase();
            }
            data.push(byte8);
            //9
            var byte9 =
              this.combobox9_1.currentText +
              this.combobox9_2.currentText +
              this.combobox9_3.currentText +
              this.combobox9_4.currentText +
              this.combobox9_5.currentText +
              this.combobox9_6.currentText +
              this.combobox9_7.currentText +
              this.combobox9_8.currentText;
            if (parseInt(byte9, 2).toString(16).length === 1) {
              byte9 = "0" + parseInt(byte9, 2).toString(16).toUpperCase();
            } else {
              byte9 = parseInt(byte9, 2).toString(16).toUpperCase();
            }
            data.push(byte9);
            data.push("00");
          } else {
            for (var a = 0; a < 5; a++) {
              data.push("00");
            }
          }
        console.log("data=",data);
        confirmsignal("AudioInfoframeWrite",data);
    }

    //Tools-audio-infoframe
    RowLayout {
        visible: pageflag==6&&pageindex == 2&&tool_flag==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 110
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 900
            width: 1600

            //read
            CustomButton{
                id:audio_info_read
                width:200
                height:80
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                property bool flag:false
                Text {
                    text: qsTr("Read")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        audio_info_read.flag = true
                        confirmsignal("AudioInfoframeRead",0xfe01);
                    }
                    onReleased: {
                        audio_info_read.flag = false
                    }
                }
            }
            //write
            CustomButton{
                id:audio_info_write
                anchors.top: audio_info_read.top
                anchors.left: audio_info_read.right
                anchors.leftMargin: 10
                width:200
                height:80
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                property bool flag:false
                Text {
                    text: qsTr("Write")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        audio_info_write.flag = true
//                        confirmsignal("AudioInfoframeWrite",0x7e01);
                        writeinfoframe();
                    }
                    onReleased: {
                        audio_info_write.flag = false
                    }
                }
            }

            //data byte 1
            Text {
                id:label1
                text: qsTr("Data Byte 1:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label2.top
                anchors.bottomMargin: 30
            }
            Text {
                id:ct
                text: qsTr("CT:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: label1.right
                anchors.leftMargin: 10
                anchors.verticalCenter: label1.verticalCenter
            }
            ComboBox{
                id:combobox1
                width: 900
                height: 60
                anchors.left: ct.right
                anchors.leftMargin: 10
                anchors.verticalCenter: label1.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0000(Refer to Stream Header)",
                    "0001(L-PCM)",
                    "0010(AC-3)",
                    "0011(MPEG-1)",
                    "0100(MP3)",
                    "0101(MPEG2)",
                    "0110(AAC LC)",
                    "0111(DTS)",
                    "1000(ATRAC)",
                    "1001(One Bit Audio)",
                    "1010(Enhanced Ac-3)",
                    "1011(DTS-HD)",
                    "1100(MAT)",
                    "1101(DST)",
                    "1110(WMA Pro)",
                    "1111(Reter to Audio Coding Exension Type(CXT) field in Data Byte 3)"
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f13
                text: qsTr("F13=0       CC:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox1.right
                anchors.leftMargin: 10
                anchors.verticalCenter: combobox1.verticalCenter
            }
            ComboBox{
                id:combobox2
                width: 358
                height: 60
                anchors.left: f13.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f13.verticalCenter
                font.family: myriadPro.name
                model: [
                    "000(Refer to Stream Header)",
                    "001(2 channels)",
                    "010(3 channels)",
                    "011(4 channels)",
                    "100(5 channels)",
                    "101(6 channels)",
                    "110(7 channels)",
                    "111(8 channels)",

                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 2
            Text {
                id:label2
                text: qsTr("Data Byte 2:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label3.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f27
                text: qsTr("F27=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label2.verticalCenter
            }
            Text {
                id:f26
                text: qsTr("F26=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label2.verticalCenter
            }
            Text {
                id:f25
                text: qsTr("F25=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label2.verticalCenter
            }
            Text {
                id:sf
                text: qsTr("SF:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label2.verticalCenter
            }
            ComboBox{
                id:combobox3
                width: 370
                height: 60
                anchors.left: sf.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f25.verticalCenter
                font.family: myriadPro.name
                model: [
                    "000(Refer to Stream Header)",
                    "001(32 kHz)",
                    "010(44.1 kHz (CD))",
                    "011(48kHz)",
                    "100(88.2 kHz)",
                    "101(96 kHz)",
                    "110(176.4 kHz)",
                    "111(192 kHz)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:ss
                text: qsTr("SS:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox3.right
                anchors.leftMargin: 20
                anchors.verticalCenter: combobox3.verticalCenter
            }
            ComboBox{
                id:combobox4
                width: 367
                height: 60
                anchors.left: ss.right
                anchors.leftMargin: 10
                anchors.verticalCenter: ss.verticalCenter
                font.family: myriadPro.name
                model: [
                    "00(Refer to Stream Header)",
                    "01(16 bit)",
                    "10(20 bit)",
                    "11(24 bit)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }


            //data byte 3
            Text {
                id:label3
                text: qsTr("Data Byte 3:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label4.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f37
                text: qsTr("F37=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label3.verticalCenter
            }
            Text {
                id:f36
                text: qsTr("F36=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label3.verticalCenter
            }
            Text {
                id:f35
                text: qsTr("F35=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label3.verticalCenter
            }
            Text {
                id:cxt
                text: qsTr("CXT:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label3.verticalCenter
            }
            ComboBox{
                id:combobox5
                width: 784
                height: 60
                anchors.left: cxt.right
                anchors.leftMargin: 10
                anchors.verticalCenter: cxt.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0x00(Refer to Audio Coding Type (CT) field in Data Byte 1)",
                    "0x01(Not in use)",
                    "0x02(Not in use)",
                    "0x03(Not in use)",
                    "0x04(MPEG-4 HE AAC)",
                    "0x05(MPEG-4 HE AAC V2)",
                    "0x06(MPEG-4 AAC LC)",
                    "0x07(DRA)",
                    "0x08(MPEG-4 HE AAC + MPEG Surround)",
                    "0x09(Reserved)",
                    "0x0A(MPEG-4 AAC LC + MPEG Surround)",
                    "0x0B(MPEG-H 3D Audio)",
                    "0x0C(AC-4)",
                    "0x0D(L-PCM 3D Audio)",
                    "0x0E(Reserved)",
                    "0x0F(Reserved)",
                    "0x10(Reserved)",
                    "0x11(Reserved)",
                    "0x12(Reserved)",
                    "0x13(Reserved)",
                    "0x14(Reserved)",
                    "0x15(Reserved)",
                    "0x16(Reserved)",
                    "0x17(Reserved)",
                    "0x18(Reserved)",
                    "0x19(Reserved)",
                    "0x1A(Reserved)",
                    "0x1B(Reserved)",
                    "0x1C(Reserved)",
                    "0x1D(Reserved)",
                    "0x1E(Reserved)",
                    "0x1F(Reserved)",

                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            //data byte 4
            Text {
                id:label4
                text: qsTr("Data Byte 4:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label5.top
                anchors.bottomMargin: 40
            }
            Text {
                id:ca
                text: qsTr("CA:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label4.verticalCenter
            }
            ComboBox{
                id:combobox6
                width: 1375
                height: 60
                anchors.left: ca.right
                anchors.leftMargin: 10
                anchors.verticalCenter: ca.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0x00(- - ---- FR FL)",
                    "0x01(- - --- LFE1 FR FL)",
                    "0x02(- - -- FC- FR FL)",
                    "0x03(- - -- FC LFE1 FR FL)",
                    "0x04(- - - BC-- FR FL)",
                    "0x05(- - - BC- LFE1 FR FL)",
                    "0x06(- - - BC FC- FR FL)",
                    "0x07(- - - BC FC LFE1 FR FL)",
                    "0x08(- - RS LS-- FR FL)",
                    "0x09(- - RS LS- LFE1 FR FL)",
                    "0x0A(- - RS LS FC- FR FL)",
                    "0x0B(- - RS LS FC LFE1 FR FL)",
                    "0x0C(- BC  RS LS-- FR FL)",
                    "0x0D(- BC  RS LS- LFE1 FR FL)",
                    "0x0E(- BC  RS LS FC- FR FL)",
                    "0x0F(- BC  RS LS FC LFE1 FR FL)",
                    "0x10(RRC RLC RS LS-- FR FL)",
                    "0x11(RRC RLC RS LS- LFE1 FR FL)",
                    "0x12(RRC RLC RS LS FC- FR FL)",
                    "0x13(RRC RLC RS LS FC LFE1 FR FL)",
                    "0x14(FRC FLC ---- FR FL)",
                    "0x15(FRC FLC ---LFE1 FR FL)",
                    "0x16(FRC FLC -- FC- FR FL)",
                    "0x17(FRC FLC -- FC LFE1 FR FL)",
                    "0x18(FRC FLC -BC-- FR FL)",
                    "0x19(FRC FLC -BC- LFE1 FR FL)",
                    "0x1A(FRC FLC -BC FC- FR FL)",
                    "0x1B(FRC FLC -BC FC LFE1 FR FL)",
                    "0x1C(FRC FLC RS LS-- FR FL)",
                    "0x1D(FRC FLC RS LS- LFE1 FR FL)",
                    "0x1E(FRC FLC RS LS FC- FR FL)",
                    "0x1F(FRC FLC RS LS FC LFE1 FR FL)",
                    "0x20(- TpFC RS LS FC- FR FL)",
                    "0x21(- TpFC RS LS FC LFE1 FR FL)",
                    "0x22(TpC - RS LS FC- FR FL)",
                    "0x23(TpC - RS LS FC LFE1 FR FL)",
                    "0x24(TpFR TpFL RS LS-- FR FL)",
                    "0x25(TpFR TpFL RS LS- LFE1 FR FL)",
                    "0x26(FRW FLW RS LS-- FR FL)",
                    "0x27(FRW FLW RS LS- LFE1 FR FL)",
                    "0x28(TpC BC RS LS FC- FR FL)",
                    "0x29(TpC BC RS LS FC LFE1 FR FL)",
                    "0x2A(TpFC BC RS LS FC- FR FL)",
                    "0x2B(TpFC BC RS LS FC LFE1 FR FL)",
                    "0x2C(TpC TpFC RS LS FC- FR FL)",
                    "0x2D(TpC TpFC RS LS FC LFE1 FR FL)",
                    "0x2E(TpFR TpFL RS LS FC- FR FL)",
                    "0x2F(TpFR TpFL RS LS FC- LFE1 FR FL)",
                    "0x30(FRW FLW RS LS FC- FR FL)",
                    "0x31(FRW FLW RS LS FC LFE1 FR FL)",
                    "0xFE",
                    "0xFF",

                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
                onActivated: {
                    var savename = "timingDetails" + (combobox6.currentIndex+1);

                }
            }
            //data byte 5
            Text {
                id:label5
                text: qsTr("Data Byte 5:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label6.top
                anchors.bottomMargin: 40
            }
            Text {
                id:dm_inh
                text: qsTr("DM_INH:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label5.verticalCenter
            }
            ComboBox{
                id:combobox7
                width: 420
                height: 60
                anchors.left: dm_inh.right
                anchors.leftMargin: 10
                anchors.verticalCenter: dm_inh.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0(Permitted or no information", "1(Prohibited)"
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:lsv
                text: qsTr("LSV:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox7.right
                anchors.leftMargin: 10
                anchors.verticalCenter: label5.verticalCenter
            }
            ComboBox{
                id:combobox8
                width: 220
                height: 60
                anchors.left: lsv.right
                anchors.leftMargin: 10
                anchors.verticalCenter: lsv.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0000(0dB)",
                    "0001(1dB)",
                    "0010(2dB)",
                    "0011(3dB)",
                    "0100(4dB)",
                    "0101(5dB)",
                    "0110(6dB)",
                    "0111(7dB)",
                    "1000(8dB)",
                    "1001(9dB)",
                    "1010(10dB)",
                    "1011(11dB)",
                    "1100(12dB)",
                    "1101(13dB)",
                    "1110(14dB)",
                    "1111(15dB)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f52
                text: qsTr("F52=0 LEFPBL:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox8.right
                anchors.leftMargin: 20
                anchors.verticalCenter: label5.verticalCenter
            }
            ComboBox{
                id:combobox9
                width: 450
                height: 60
                anchors.left: f52.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f52.verticalCenter
                font.family: myriadPro.name
                model: [
                    "00(Unknown or refer to other information)",
                    "01(0 dB playback)",
                    "10(+ 10 dB playback)",
                    "11(Reserved)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            //data byte 6
            Text {
                id:label6
                text: qsTr("Data Byte 6:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label7.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f67
                text: qsTr((combobox6.currentText === "0xEF") ? "FLW/FRW:" :(combobox6.currentText === "0xFF")?"CID07": "F67=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_1
                width: 70
                height: 60
                anchors.left: f67.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f67.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f66
                text: qsTr((combobox6.currentText === "0xEF") ? "FLC/FRC:" : (combobox6.currentText === "0xFF")?"CID06": "F66=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_2
                width: 70
                height: 60
                anchors.left: f66.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f66.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f65
                text: qsTr((combobox6.currentText === "0xEF") ? "FLC/FRC:" :(combobox6.currentText === "0xFF")?"CID05": "F65=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_3
                width: 70
                height: 60
                anchors.left: f65.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f65.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f64
                text: qsTr((combobox6.currentText === "0xEF") ? "BC:" : (combobox6.currentText === "0xFF")?"CID04":"F64=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_4
                width: 70
                height: 60
                anchors.left: f64.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f64.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f63
                text: qsTr((combobox6.currentText === "0xEF") ? "BL/BR:" : (combobox6.currentText === "0xFF")?"CID03":"F63=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_5
                width: 70
                height: 60
                anchors.left: f63.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f63.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f62
                text: qsTr((combobox6.currentText === "0xEF") ? "FC:" : (combobox6.currentText === "0xFF")?"CID02":"F62=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_6
                width: 70
                height: 60
                anchors.left: f62.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f62.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f61
                text: qsTr((combobox6.currentText === "0xEF") ? "LFE1:" : (combobox6.currentText === "0xFF")?"CID01":"F61=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_7
                width: 70
                height: 60
                anchors.left: f61.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f61.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f60
                text: qsTr((combobox6.currentText === "0xEF") ? "FL/FR:" : (combobox6.currentText === "0xFF")?"CID00":"F60=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_8
                width: 70
                height: 60
                anchors.left: f60.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f60.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 7
            Text {
                id:label7
                text: qsTr("Data Byte 7:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label8.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f77
                text: qsTr((combobox6.currentText === "0xEF") ? "FTpSiL/TpSiR:" : (combobox6.currentText === "0xFF")?"CID15":"F77=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_1
                width: 70
                height: 60
                anchors.left: f77.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f77.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f76
               text: qsTr((combobox6.currentText === "0xEF") ? "SiL/SiR:" : (combobox6.currentText === "0xFF")?"CID14":"F76=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_2
                width: 70
                height: 60
                anchors.left: f76.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f76.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f75
                text: qsTr((combobox6.currentText === "0xEF") ? "TpBC:" : (combobox6.currentText === "0xFF")?"CID13":"F75=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_3
                width: 70
                height: 60
                anchors.left: f75.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f75.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f74
                text: qsTr((combobox6.currentText === "0xEF") ? "LFE2:" :(combobox6.currentText === "0xFF")?"CID12": "F74=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_4
                width: 70
                height: 60
                anchors.left: f74.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f74.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f73
                text: qsTr((combobox6.currentText === "0xEF") ? "LS/RS:" : (combobox6.currentText === "0xFF")?"CID11":"F73=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_5
                width: 70
                height: 60
                anchors.left: f73.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f73.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f72
                text: qsTr((combobox6.currentText === "0xEF") ? "TpFC:" :(combobox6.currentText === "0xFF")?"CID10": "F72=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_6
                width: 70
                height: 60
                anchors.left: f72.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f72.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f71
                text: qsTr((combobox6.currentText === "0xEF") ? "TpC:" : (combobox6.currentText === "0xFF")?"CID09":"F71=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_7
                width: 70
                height: 60
                anchors.left: f71.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f71.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f70
                text: qsTr((combobox6.currentText === "0xEF") ? "TpFL/TpFR:" :(combobox6.currentText === "0xFF")?"CID08": "F70=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_8
                width: 70
                height: 60
                anchors.left: f70.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f70.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 8
            Text {
                id:label8
                text: qsTr("Data Byte 8:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label9.top
                anchors.bottomMargin: 40
            }


            Text {
                id:f87
                text: qsTr((combobox6.currentText === "0xFF")?"CID23": "F87=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_1
                width: 70
                height: 60
                anchors.left: f87.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f87.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f86
                text: qsTr((combobox6.currentText === "0xFF")?"CID22": "F86=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_2
                width: 70
                height: 60
                anchors.left: f86.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f86.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f85
                text: qsTr((combobox6.currentText === "0xFF")?"CID21": "F85=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_3
                width: 70
                height: 60
                anchors.left: f85.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f85.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f84
                text: qsTr((combobox6.currentText === "0xFF")?"CID20": "F84=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_4
                width: 70
                height: 60
                anchors.left: f84.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f84.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f83
                text: qsTr((combobox6.currentText === "0xEF") ? "TpLS/TpRS:" :(combobox6.currentText === "0xFF")?"CID19": "F83=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_5
                width: 70
                height: 60
                anchors.left: f83.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f83.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f82
                text: qsTr((combobox6.currentText === "0xEF") ? "BtFL/bTFR:" :(combobox6.currentText === "0xFF")?"CID18": "F82=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_6
                width: 70
                height: 60
                anchors.left: f82.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f82.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f81
                text: qsTr((combobox6.currentText === "0xEF") ? "BtFC:" :(combobox6.currentText === "0xFF")?"CID17": "F81=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_7
                width: 70
                height: 60
                anchors.left: f81.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f81.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f80
                text: qsTr((combobox6.currentText === "0xEF") ? "TpBL/TpBR:" :(combobox6.currentText === "0xFF")?"CID16": "F80=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_8
                width: 70
                height: 60
                anchors.left: f80.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f80.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 9
            Text {
                id:label9
                text: qsTr("Data Byte 9:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label10.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f97
                text: qsTr((combobox6.currentText === "0xFF")?"CID31": "F97=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_1
                width: 70
                height: 60
                anchors.left: f97.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f97.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f96
                text: qsTr((combobox6.currentText === "0xFF")?"CID30": "F96=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_2
                width: 70
                height: 60
                anchors.left: f96.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f96.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f95
                text: qsTr((combobox6.currentText === "0xFF")?"CID29": "F95=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_3
                width: 70
                height: 60
                anchors.left: f95.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f95.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f94
                text: qsTr((combobox6.currentText === "0xFF")?"CID28": "F94=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_4
                width: 70
                height: 60
                anchors.left: f94.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f94.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f93
                text: qsTr((combobox6.currentText === "0xFF")?"CID27": "F93=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_5
                width: 70
                height: 60
                anchors.left: f93.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f93.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f92
                text: qsTr((combobox6.currentText === "0xFF")?"CID26": "F92=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_6
                width: 70
                height: 60
                anchors.left: f92.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f92.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f91
                text: qsTr((combobox6.currentText === "0xFF")?"CID25": "F91=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_7
                width: 70
                height: 60
                anchors.left: f91.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f91.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f90
                text: qsTr((combobox6.currentText === "0xFF")?"CID24": "F90=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_8
                width: 70
                height: 60
                anchors.left: f90.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f90.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 10
            Text {
                id:label10
                text: qsTr("Data Byte 10:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
            }
            Text {
                id:f107
                text: qsTr("F107=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: label10.right
                anchors.leftMargin: 20
                anchors.verticalCenter: label10.verticalCenter
            }
            Text {
                id:f106
                text: qsTr("F106=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f107.verticalCenter
            }
            Text {
                id:f105
                text: qsTr("F105=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f106.verticalCenter
            }
            Text {
                id:f104
                text: qsTr("F104=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f105.verticalCenter
            }
            Text {
                id:f103
                text: qsTr("F103=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f104.verticalCenter
            }
            Text {
                id:f102
                text: qsTr("F102=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f103.verticalCenter
            }
            Text {
                id:f101
                text: qsTr("F101=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f102.verticalCenter
            }
            Text {
                id:f100
                text: qsTr("F100=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.right
                anchors.leftMargin: 100
                anchors.verticalCenter: f101.verticalCenter
            }
        }
    }
    //Link Train
    property int link_train_flag: 0
    RowLayout {
        visible: pageflag==6&&pageindex == 2&&tool_flag==2?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 750
            width: 1120
            RowLayout{
               width: parent.width
               spacing: 50
                GridLayout{
                    Layout.topMargin: 30
                    Layout.leftMargin: 50
                    width: parent.width
                    rowSpacing: 20
                    columns: 1
                    ListModel {
                        id: link_train_model
                        ListElement { first: "FRL Off"; number: 0x0000 }
                        ListElement { first: "Force 3 Lanes / 3 Gbps"; number: 0x0101 }
                        ListElement { first: "Force 3 Lanes / 6 Gbps"; number: 0x0102 }
                        ListElement { first: "Force 4 Lanes / 6 Gbps"; number: 0x0103 }
                        ListElement { first: "Force 4 Lanes / 8 Gbps"; number: 0x0104 }
                        ListElement { first: "Force 4 Lanes / 10 Gbps"; number: 0x0105 }
                        ListElement { first: "Force 4 Lanes / 12 Gbps"; number: 0x0106 }

                    }
                    Repeater{
                        model: link_train_model
                        CustomButton{
                            width:300
                            height:80
                            border.color: link_train_flag==number?"orange":"black"
                            border.width: 4
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            color: 'black'
                            Column{
                                anchors.centerIn: parent
                                Text {
                                    text: first
                                    font.family: myriadPro.name
                                    font.pixelSize: btnfontsize
                                    color: "white"
                                    anchors.horizontalCenter : parent.horizontalCenter
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    link_train_flag=number
                                    confirmsignal("LinkTrainForce",number)
                                }
                            }
                        }
                    }

                }

                RowLayout{
                    width: parent.width
                    spacing: 50
                    Column{
                        Text {
                            text: "Force Link Train at Lane / Rate"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                        }

//                        Rectangle{
//                            width: 300
//                            height: 60
//                            color: "white"
//                            Text {
//                                id:force_link_train_text
//                                text: qsTr("")
//                                font.family: myriadPro.name
//                                font.pixelSize: btnfontsize
//                                color: "black"
//                                anchors.centerIn: parent
//                            }
//                        }
                        ComboBox{
                            id:combobox10
                            width: 300
                            height: 60
//                            anchors.left: ct.right
                            anchors.leftMargin: 10
//                            anchors.verticalCenter: label1.verticalCenter
                            font.family: myriadPro.name
                            model: [
                                "FRL Off",
                                "3Lanes/3Gbps",
                                "3Lanes/6Gbps",
                                "4Lanes/6Gbps",
                                "4Lanes/8Gbps",
                                "4Lanes/10Gbps",
                            ]
                            font.pixelSize: 30

                            delegate: ItemDelegate {
                                width: combobox10.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox10.highlightedIndex == index?"#5e5e5e":"black"
                                    font.pixelSize: 26
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: myriadPro.name
                                }
                                highlighted: combobox10.highlightedIndex == index
                                background: Rectangle {
                                    implicitWidth: combobox10.width
                                    implicitHeight: 50
                                    opacity: enabled ? 1 : 0.3
                                    color: combobox10.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                                }
                            }
                            onActivated: {
                                var str = combobox10.currentIndex.toString(16).padStart(2, '0') + combobox11.currentIndex.toString(16).padStart(2, '0');
                                confirmsignal("LinkTrain",parseInt(str, 16))
                            }
                        }
                    }
                    Column{
                        Text {
                            text: "Force Training Status"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                        }

//                        Rectangle{
//                            width: 300
//                            height: 60
//                            color: "white"
//                            Text {
//                                id:force_training_text
//                                text: qsTr("")
//                                font.family: myriadPro.name
//                                font.pixelSize: btnfontsize
//                                color: "black"
//                                anchors.centerIn: parent
//                            }
//                        }
                        ComboBox{
                            id:combobox11
                            width: 300
                            height: 60
//                            anchors.left: ct.right
                            anchors.leftMargin: 10
//                            anchors.verticalCenter: label1.verticalCenter
                            font.family: myriadPro.name
                            model: [
                                "FRL_LT_STOP",
                                "FRL_LT_PROGRESS",
                                "FRL_LT_PASS",
                                "FRL_LT_TMDS",
                            ]
                            font.pixelSize: 30

                            delegate: ItemDelegate {
                                width: combobox11.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox11.highlightedIndex == index?"#5e5e5e":"black"
                                    font.pixelSize: 26
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: myriadPro.name
                                }
                                highlighted: combobox11.highlightedIndex == index
                                background: Rectangle {
                                    implicitWidth: combobox11.width
                                    implicitHeight: 50
                                    opacity: enabled ? 1 : 0.3
                                    color: combobox11.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                                }

                            }
                            onActivated: {
                                var str = combobox10.currentIndex.toString(16).padStart(2, '0') + combobox11.currentIndex.toString(16).padStart(2, '0');
                                confirmsignal("LinkTrain",parseInt(str, 16))
                            }
                        }
                    }
                }
            }
        }
    }

    property int powerbtn_flag: 0
    //power out (disabled)
    RowLayout {
        visible: false
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        CustomButton{
            id:poweron_btn
            width:btnWidth
            height:btnHeight
            border.color: powerbtn_flag==0?"orange":"black"
            border.width: 4
            color: flag?'gray':'black'
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag:false
            Text {
                text: qsTr("Normal")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    poweron_btn.flag = true
                }
                onReleased: {
                    poweron_btn.flag = false
                    powerbtn_flag =0;
                    confirmsignal("PowerOut","0")
                }
            }
        }

        CustomButton{
            id:poweroff_btn
            width:btnWidth
            height:btnHeight
            border.color: powerbtn_flag==1?"orange":"black"
            border.width: 4
            color: flag?'gray':'black'
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag:false
            Text {
                text: qsTr("Standby")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    poweroff_btn.flag = true
                }
                onReleased: {
                    poweroff_btn.flag = false
                    powerbtn_flag =1;
                    confirmsignal("PowerOut","1")
                }
            }
        }
    }



}
