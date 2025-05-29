// SystemSetupPanel.qml
// 系统设置面板，包含IP管理、风扇控制、重置重启、设备状态等功能
// 适配当前应用的蓝色风格主题

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    anchors.fill: parent
    color: "#585858"  // 统一蓝色背景
    border.color: "black"
    border.width: 2
    radius: 4

    // 信号定义，用于与C++后端通信
    signal confirmsignal(string str, var num)

    // 属性定义
    property bool dhcpEnabled: false
    property int fanControlMode: 0
    property int currentSection: 0  // 当前显示的功能区: 0=IP, 1=Fan, 2=Reset, 3=Vitals

    // 主布局
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 标题
        Text {
            text: qsTr("System Setup")
            font.bold: true
            font.pixelSize: 36
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

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
                    font.pixelSize: 18
                    
                    background: Rectangle {
                        color: root.currentSection === modelData.index ? "#ffffff" : "#888888"
                        border.color: "black"
                        border.width: 2
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: root.currentSection === modelData.index ? "black" : "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        root.currentSection = modelData.index
                        // 如果切换到Vitals页面，请求设备状态
                        if (modelData.index === 3) {
                            requestVitalsData()
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
                visible: root.currentSection === 0
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

                    // DHCP/Static 切换按钮
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20
                        
                        Button {
                            text: "DHCP"
                            font.pixelSize: 20
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            
                            background: Rectangle {
                                color: root.dhcpEnabled ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: root.dhcpEnabled ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                root.dhcpEnabled = true
                                root.confirmsignal("DHCP", true)
                            }
                        }
                        
                        Button {
                            text: "Static"
                            font.pixelSize: 20
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            
                            background: Rectangle {
                                color: !root.dhcpEnabled ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: !root.dhcpEnabled ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                root.dhcpEnabled = false
                                root.confirmsignal("DHCP", false)
                            }
                        }
                    }
                }
            }

            // 风扇控制面板
            Rectangle {
                visible: root.currentSection === 1
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
                                color: root.fanControlMode === modelData.value ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: root.fanControlMode === modelData.value ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                root.fanControlMode = modelData.value
                                root.confirmsignal("FanControl", modelData.value)
                            }
                        }
                    }
                }
            }

            // 重置重启面板
            Rectangle {
                visible: root.currentSection === 2
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
                            root.confirmsignal("ResetDefault", true)
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
                            root.confirmsignal("Reboot", true)
                        }
                    }
                }
            }

            // 设备状态面板
            Rectangle {
                visible: root.currentSection === 3
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

    // 请求设备状态信息
    function requestVitalsData() {
        // 发送请求获取各组件状态
        confirmsignal("vitals", 0x00); // KEY MCU
        confirmsignal("vitals", 0x01); // MAIN MCU
        confirmsignal("vitals", 0x02); // TX MCU
        confirmsignal("vitals", 0x10); // MAIN FPGA
        confirmsignal("vitals", 0x11); // AUX FPGA
        confirmsignal("vitals", 0x12); // AUX2 FPGA
        confirmsignal("vitals", 0x20); // LAN MCU
        confirmsignal("vitals", 0x21); // AV MCU
        confirmsignal("vitals", 0x22); // DSP Module
        confirmsignal("vitals", 0x30); // Power Management
        confirmsignal("vitals", 0xff); // all component
    }

    // 添加用于更新版本信息的函数
    function updateVersionInfo(componentId, version) {
        var textComponent = root[componentId + "Text"]
        if (textComponent) {
            textComponent.text = version
        }
    }
    
    // 添加用于更新温度信息的函数
    function updateTemperatureInfo(componentId, temperature) {
        var textComponent = root[componentId + "Text"]
        if (textComponent) {
            textComponent.text = temperature
        }
    }

    // 添加网络信息更新函数
    function updateNetworkDisplay() {
        console.log("Updating SystemSetup network display");
        console.log("- IP from netManager:", netManager.ipAddress);
        console.log("- MAC from netManager:", netManager.macAddress);
        
        // 强制更新显示（如果绑定没有自动更新）
        if (netManager.ipAddress) {
            hostIpField.text = netManager.ipAddress;
        }
        if (netManager.macAddress) {
            macAddressText.text = netManager.macAddress;
        }
        if (netManager.netmask) {
            ipMaskField.text = netManager.netmask;
        }
        if (netManager.routerIpAddress) {
            routerIpField.text = netManager.routerIpAddress;
        }
    }
} 