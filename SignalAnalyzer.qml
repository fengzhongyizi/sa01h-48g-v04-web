// SignalAnalyzer.qml
// 信号分析器组件 - 用于分析和显示HDMI/视频信号信息
// 支持多种显示模式：Monitor、Signal Info、EDID和Error Rate

import QtQuick 2.12             // 提供QML基本元素
import QtQuick.Controls 2.5     // 提供UI控件如Button
import QtQuick.Layouts 1.12     // 提供布局管理器
//import SignalAnalyzer 1.0     // C++单例注册模块(当前未使用)
import QtCharts 2.2             // 提供图表功能

// 主容器
Rectangle {
    id: root
    anchors.fill: parent        // 填充父容器
    color: "lightgray"          // 背景色

    // 页面标识: 0=主菜单, 1=Monitor, 2=Signal Info, 3=EDID, 4=Error Rate
    property int pageFlag: 0

    // 数据和状态属性
    property string signalStatus: "No Signal"  // 信号状态
    property string frameUrl: ""               // 帧图像URL
    property string resolution: "3840x2160@60Hz" // 分辨率
    
    // Signal Info页面属性
    property string videoFormat: "3840x2160@60Hz" // 视频格式
    property string colorSpace: "RGB"          // 色彩空间
    property string colorDepth: "8-bit"        // 色彩深度
    property string hdrFormat: "HDR10"         // HDR格式
    property string hdmiDvi: "HDMI 2.1"        // HDMI/DVI版本
    property string frlRate: "FRL4 (12 Gbps)"  // FRL速率
    property string dscMode: "Disabled"        // DSC模式
    property string hdcpType: "HDCP 2.3"       // HDCP类型
    
    // 音频信息属性
    property string samplingFreq: "48 kHz"     // 采样频率
    property string samplingSize: "24-bit"     // 采样大小
    property string channelCount: "2.0 (Stereo)" // 声道数
    property string channelNumber: "FL/FR"     // 声道编号
    property string levelShift: "0 dB"         // 电平偏移
    property string cBitSamplingFreq: "Level 1" // C-bit/采样频率
    property string cBitDataType: "PCM"        // C-bit/数据类型
    
    // EDID页面属性
    property var edidList: [
        { name: "EDID Block 0", selected: true },
        { name: "EDID Block 1", selected: false },
        { name: "HDMI Forum VSDB", selected: false },
        { name: "HDR Static Metadata", selected: false },
        { name: "HDR Dynamic Metadata", selected: false },
        { name: "Audio Data Block", selected: false },
        { name: "Speaker Allocation", selected: false },
        { name: "Vendor Specific Block", selected: false }
    ]
    
    // Error Rate页面属性
    property string monitorStartTime: "00:00:00" // 监控开始时间
    property int timeSlotInterval: 5           // 时间槽间隔
    property bool timeSlotInSeconds: true      // 时间槽单位是秒
    property int triggerMode: 0                // 触发模式
    property var monitorData: []               // 监控数据
    
    // 处理二进制数据函数
    function processReceiveData(strcode, getdata) {
        console.log("SignalAnalyzer received data code:", strcode)
        // 根据状态码处理不同数据
        if(strcode == "61 80") {
            // 处理分辨率信息
            videoFormat = resolution
        } else if(strcode == "63 80") {
            // 处理色彩空间信息
            // 根据数据更新colorSpace
        } else if(strcode == "64 80") {
            // 处理色彩深度信息
            // 根据数据更新colorDepth
        }
        // 可添加更多状态码处理
    }
    
    // 处理ASCII数据函数
    function processReceiveAsciiData(data) {
        console.log("SignalAnalyzer received ASCII data:", data)
        // 处理ASCII格式数据
        if(data.indexOf("EDID") !== -1 && data.indexOf("DATA") !== -1) {
            // 处理EDID数据
            var linedata = data.split(" ");
            // 根据需要更新UI元素
            // 解析EDID数据格式并传递给C++处理层
            signalAnalyzerManager.updateEdidList(parseEdidData(data));
        }
    }
    
    // 启动FPGA视频获取
    function startFpgaVideo() {
        console.log("Start FPGA video")
        signalStatus = "Active"
        // 发送命令到FPGA (通过UART3)
        var cmd = "AA 00 00 06 00 00 00 B1 00 01"
        serialPortManager.writeData(cmd, 0)
    }
    
    // EDID选择函数
    function selectSingleEdid(index) {
        console.log("Select EDID at index:", index)
        // 更新选择状态
        for(var i = 0; i < edidList.length; i++) {
            edidList[i].selected = (i === index)
        }
        // 触发edidList变化信号
        edidListChanged()
    }
    
    // 应用EDID设置
    function applyEdid() {
        console.log("Apply EDID settings")
        // 获取选中的EDID索引
        var selectedIndex = -1
        for(var i = 0; i < edidList.length; i++) {
            if(edidList[i].selected) {
                selectedIndex = i
                break
            }
        }
        
        if(selectedIndex >= 0) {
            // 发送应用EDID命令到MCU (通过UART5)
            var cmd = "SET IN1 EDID" + (selectedIndex + 1) + "\r\n"
            serialPortManager.writeDataUart5(cmd, 1)
        }
    }
    
    // 开始错误率监控
    function startMonitor() {
        console.log("Start error rate monitor")
        monitorStartTime = new Date().toTimeString().split(' ')[0]
        // 清空历史数据
        monitorData = []
        // 可添加开始监控命令
    }
    
    // 设置时间槽间隔
    function setTimeSlotInterval(value) {
        timeSlotInterval = value
    }
    
    // 设置时间槽单位
    function setTimeSlotUnit(isSeconds) {
        timeSlotInSeconds = isSeconds
    }
    
    // 设置触发模式
    function setTriggerMode(mode) {
        triggerMode = mode
    }

    // ----------------------------------------
    // 1: Monitor 页面实现
    // ----------------------------------------
    Item {
        anchors.fill: parent
        visible: pageFlag === 1  // 仅在Monitor模式显示

        // 背景
        Rectangle {
            anchors.fill: parent
            color: "#336699"     // 蓝色背景
            border.color: "black"
            border.width: 2
            radius: 4
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            // 视频显示区域
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "black"
                border.color: "white"
                border.width: 2
                radius: 4

                // "No Signal" 文本 - 无信号时显示
                Text {
                    anchors.centerIn: parent
                    text: qsTr("No Signal")
                    color: "white"
                    font.pixelSize: 24
                    visible: !signalAnalyzerManager.signalStatus || signalAnalyzerManager.signalStatus === "No Signal"
                }

                // 视频图像 - 有信号时显示
                Image {
                    id: videoImage
                    anchors.fill: parent
                    anchors.margins: 4
                    fillMode: Image.PreserveAspectFit
                    source: signalAnalyzerManager.frameUrl || ""
                    asynchronous: true
                    cache: false
                    visible: signalAnalyzerManager.signalStatus && signalAnalyzerManager.signalStatus !== "No Signal" && status === Image.Ready

                    // 图像加载状态处理
                    onStatusChanged: {
                        if (status === Image.Error || status === Image.Null) {
                            visible = false
                        } else if (status === Image.Ready) {
                            visible = true
                        }
                    }
                }

                // 彩条显示 - 备选显示
                Rectangle {
                    visible: !videoImage.visible && signalAnalyzerManager.signalStatus && signalAnalyzerManager.signalStatus !== "No Signal"
                    anchors.fill: parent
                    anchors.margins: 4

                    // 七色彩条
                    Row {
                        anchors.fill: parent

                        Repeater {
                            model: ["#C0C000", "#00C0C0", "#00C000", "#C000C0", "#C00000", "#0000C0", "#000000"]
                            Rectangle {
                                width: parent.width / 7
                                height: parent.height
                                color: modelData
                            }
                        }
                    }
                }

                // 信号信息显示区
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: infoText.implicitHeight + 10
                    color: Qt.rgba(0, 0, 0, 0.7)
                    visible: signalAnalyzerManager.signalStatus && signalAnalyzerManager.signalStatus !== "No Signal"

                    // 信号信息文本
                    Text {
                        id: infoText
                        anchors.fill: parent
                        anchors.margins: 5
                        color: "white"
                        font.pixelSize: 14
                        text: {
                            if (!signalAnalyzerManager.signalStatus)
                                return qsTr("No Signal")

                            return qsTr("<No Signal> ") +
                                    qsTr("G<MODE: TMDS DSC OFF  RES: %1  TYPE: HDMI  HDCP: V2.3  CS: RGB(0-255)  CD: 8Bit  BT2020: Disable>")
                            .arg(signalAnalyzerManager.resolution || "3840x2160@60Hz")
                        }
                    }
                }
            }

            // 控制按钮区
            RowLayout {
                Layout.fillWidth: true
                height: 50
                spacing: 20

                // 刷新按钮
                Button {
                    text: qsTr("Refresh")
                    onClicked: signalAnalyzerManager.startFpgaVideo()
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 40

                    // 按钮样式
                    background: Rectangle {
                        color: parent.pressed ? "#C0C0C0" : "#E0E0E0"
                        border.color: "#808080"
                        border.width: 1
                        radius: 4
                    }
                }

                Item { Layout.fillWidth: true } // 弹性空白填充
            }
        }
    }

    // ----------------------------------------
    // 2: Signal Info 页面实现
    // ----------------------------------------
    Item {
        anchors.fill: parent
        visible: pageFlag === 2  // 仅在Signal Info模式显示

        // 添加蓝色背景
        Rectangle {
            anchors.fill: parent
            color: "#336699"     // 统一蓝色背景
            border.color: "black"
            border.width: 2
            radius: 4
        }

        // 可滚动区域
        Flickable {
            id: flick
            anchors.fill: parent
            anchors.margins: 20  // 添加边距
            contentWidth: parent.width - 40
            contentHeight: infoColumn.implicitHeight
            clip: true

            // 信息列表 - 居中显示
            Column {
                id: infoColumn
                width: Math.min(800, parent.width - 40)  // 限制最大宽度为800px
                anchors.horizontalCenter: parent.horizontalCenter  // 水平居中
                spacing: 20
                padding: 20

                // 信号信息区域
                Rectangle {
                    color: "transparent"  // 改为透明
                    border.color: "white"  // 白色边框
                    border.width: 1;
                    radius: 4
                    width: parent.width - parent.padding * 2
                    height: receivedInfoColumn.implicitHeight + 24

                    // 视频信息内容
                    Column {
                        id: receivedInfoColumn
                        anchors.fill: parent; anchors.margins: 12; spacing: 12
                        
                        // 标题
                        Text {
                            text: qsTr("Received Signal Info")
                            font.pixelSize: 22;
                            font.bold: true;
                            color: "white"  // 改为白色
                        }
                        
                        // 信号参数列表
                        Repeater {
                            model: [
                                { label:"Video Format:", value: signalAnalyzerManager.videoFormat },
                                { label:"Color Space:",  value: signalAnalyzerManager.colorSpace  },
                                { label:"Color Depth:",  value: signalAnalyzerManager.colorDepth  },
                                { label:"HDR Format:",   value: signalAnalyzerManager.hdrFormat   },
                                { label:"HDMI/DVI:",     value: signalAnalyzerManager.hdmiDvi     },
                                { label:"FRL Rate:",     value: signalAnalyzerManager.frlRate     },
                                { label:"DSC Mode:",     value: signalAnalyzerManager.dscMode     },
                                { label:"HDCP Type:",    value: signalAnalyzerManager.hdcpType    }
                            ]
                            
                            // 每行参数的布局
                            delegate: Item {
                                width: parent.width
                                height: 32  // 固定行高

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 10
                                    
                                    // 参数标签
                                    Text {
                                        text: modelData.label
                                        font.pixelSize: 16
                                        color: "white"  // 改为白色
                                        Layout.preferredWidth: 150
                                    }
                                    
                                    // 参数值
                                    Text {
                                        text: modelData.value
                                        font.pixelSize: 16
                                        color: "white"  // 改为白色
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }

                // 刷新按钮区域
                Rectangle {
                    color: "transparent"
                    width: parent.width - parent.padding * 2
                    height: 60

                    Button {
                        text: qsTr("Refresh Signal Info")
                        anchors.centerIn: parent
                        width: 200
                        height: 40

                        onClicked: signalAnalyzerManager.refreshSignalInfo()

                        background: Rectangle {
                            color: parent.pressed ? "#C0C0C0" : "#E0E0E0"
                            border.color: "#808080"
                            border.width: 1
                            radius: 4
                        }
                    }
                }

                // 音频信息区域
                Rectangle {
                    color: "transparent"  // 改为透明
                    border.color: "white"  // 白色边框
                    border.width: 1;
                    radius: 4
                    width: parent.width - parent.padding * 2
                    height: audioInfoColumn.implicitHeight + 24

                    // 音频信息内容
                    Column {
                        id: audioInfoColumn
                        anchors.fill: parent; anchors.margins: 12; spacing: 12
                        
                        // 标题
                        Text {
                            text: qsTr("Audio")
                            font.pixelSize: 22;
                            font.bold: true;
                            color: "white"  // 改为白色
                        }
                        
                        // 音频参数列表
                        Repeater {
                            model: [
                                { label:"Sampling Freq:",      value: signalAnalyzerManager.samplingFreq     },
                                { label:"Sampling Size:",      value: signalAnalyzerManager.samplingSize     },
                                { label:"Channel Count:",      value: signalAnalyzerManager.channelCount     },
                                { label:"Channel Number:",     value: signalAnalyzerManager.channelNumber    },
                                { label:"Level Shift:",        value: signalAnalyzerManager.levelShift       },
                                { label:"CBit/Sampling Freq:", value: signalAnalyzerManager.cBitSamplingFreq},
                                { label:"CBit/Data Type:",     value: signalAnalyzerManager.cBitDataType    }
                            ]
                            
                            // 每行参数的布局
                            delegate: Item {
                                width: parent.width
                                height: 32  // 固定行高

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 10
                                    
                                    // 参数标签
                                    Text {
                                        text: modelData.label
                                        font.pixelSize: 16
                                        color: "white"  // 改为白色
                                        Layout.preferredWidth: 150
                                    }
                                    
                                    // 参数值
                                    Text {
                                        text: modelData.value
                                        font.pixelSize: 16
                                        color: "white"  // 改为白色
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ----------------------------------------
    // 3: EDID 页面实现
    // ----------------------------------------
    Item {
        anchors.fill: parent
        visible: pageFlag === 3  // 仅在EDID模式显示

        // 添加蓝色背景
        Rectangle {
            anchors.fill: parent
            color: "#336699"     // 统一蓝色背景
            border.color: "black"
            border.width: 2
            radius: 4
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            // 标题
            Text {
                text: qsTr("EDID Selection")
                font.bold: true
                font.pixelSize: 28
                color: "white"  // 改为白色
            }

            // EDID选项列表区域
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true


                // 网格布局
                GridLayout {
                    columns: 2
                    rowSpacing: 20
                    columnSpacing: 60
                    width: parent.width

                    // EDID选项列表
                    Repeater {
                        model: signalAnalyzerManager.edidList

                        // 每个EDID选项
                        delegate: RowLayout {
                            spacing: 12
                            Layout.fillWidth: true

                            // 自定义方形单选框
                            Item {
                                width: 32
                                height: 32
                                Layout.alignment: Qt.AlignVCenter

                                // 外框
                                Rectangle {
                                    width: 28
                                    height: 28
                                    anchors.centerIn: parent
                                    radius: 2    // 轻微圆角方形
                                    border.color: "white"
                                    border.width: 2
                                    color: "transparent"

                                    // 内部选中标记
                                    Rectangle {
                                        width: 18
                                        height: 18
                                        anchors.centerIn: parent
                                        radius: 1
                                        color: modelData.selected ? "white" : "transparent"
                                    }
                                }

                                // 点击区域
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        signalAnalyzerManager.selectSingleEdid(index)
                                    }
                                }
                            }

                            // EDID名称
                            Text {
                                text: modelData.name
                                font.pixelSize: 22
                                color: "white"  // 改为白色
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }

            // 应用按钮
            Button {
                text: qsTr("Apply")
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 120
                Layout.preferredHeight: 50
                font.pixelSize: 20
                onClicked: signalAnalyzerManager.applyEdid()


            }
        }
    }

    // ----------------------------------------
    // 4: Error Rate 页面实现
    // ----------------------------------------
    Item {
        anchors.fill: parent
        visible: pageFlag === 4  // 仅在Error Rate模式显示

        // 背景
        Rectangle {
            anchors.fill: parent
            color: "#336699"
            border.color: "black"; border.width: 2; radius: 4
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // 顶部控制区域
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 200

                // 外部边框
                Rectangle {
                    id: outerFrame
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "white"
                    border.width: 2
                    radius: 4
                    anchors.topMargin: 10 // 为标题留空间
                }

                // 标题区域
                Rectangle {
                    id: monitorTitle
                    x: 20
                    y: 0
                    height: 24
                    color: "#336699"
                    radius: 4
                    width: errorRateTitleText.width + 20

                    // 标题文本
                    Text {
                        id: errorRateTitleText
                        anchors.centerIn: parent
                        text: qsTr("Signal Monitor (Total time slot number is 2040, every time slot is 1-255 seconds or minutes)")
                        font.pixelSize: 16
                        font.bold: true
                        color: "white"
                    }
                }

                // 控制区内部布局
                RowLayout {
                    id: topperL
                    spacing: 16
                    anchors.fill: parent
                    anchors.margins: 10
                    anchors.topMargin: 15

                    // 启动按钮区域
                    Rectangle {
                        color: "transparent"
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 150

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            // "New Start" 按钮
                            Button {
                                id: newStartButton
                                text: qsTr("New Start")
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredHeight: 50
                                Layout.preferredWidth: 150
                                font.pixelSize: 16
                                font.bold: true

                                // 点击动画属性
                                property bool isPressed: false
                                
                                // 橙色按钮样式，带点击动画效果
                                background: Rectangle {
                                    color: newStartButton.isPressed ? "#CC7A20" : "#E69138"  // 按下时颜色加深
                                    radius: 4
                                    border.color: newStartButton.isPressed ? "#663300" : "#804000"
                                    border.width: newStartButton.isPressed ? 2 : 1

                                    // 按下时添加阴影效果
                                    Behavior on color { ColorAnimation { duration: 100 } }

                                    // 缩放动画
                                    scale: newStartButton.isPressed ? 0.95 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 100 } }
                                }

                                // 按钮文本
                                contentItem: Text {
                                    text: newStartButton.text
                                    font: newStartButton.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter

                                    // 文本也随按钮缩放
                                    scale: newStartButton.isPressed ? 0.95 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 100 } }
                                }
                                
                                // 鼠标事件处理
                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: { newStartButton.isPressed = true }
                                    onReleased: { newStartButton.isPressed = false }
                                    onClicked: { signalAnalyzerManager.startMonitor() }
                                    onCanceled: { newStartButton.isPressed = false }
                                }
                            }

                            // 显示开始时间
                            Label {
                                text: qsTr("start time: %1")
                                .arg(signalAnalyzerManager.monitorStartTime || "00:00:00")
                                font.pixelSize: 18
                                color: "white"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    // 时间槽设置区域
                    Item {
                        Layout.preferredWidth: 500
                        Layout.preferredHeight: 150

                        // 边框
                        Rectangle {
                            id: slotSettingRect
                            anchors.fill: parent
                            anchors.topMargin: 10
                            color: "transparent"
                            border.color: "white"
                            border.width: 2
                            radius: 4

                            // 内容区域
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                anchors.topMargin: 15
                                spacing: 8

                                // 时间槽设置控件
                                RowLayout {
                                    spacing: 20
                                    Layout.fillWidth: true

                                    // 标签
                                    Label {
                                        text: qsTr("Every time slot")
                                        color: "white"
                                        font.pixelSize: 16
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    // 自定义数值选择框
                                    SpinBox {
                                        id: customSpinBox
                                        from: 1
                                        to: 255
                                        value: signalAnalyzerManager.timeSlotInterval
                                        onValueChanged: signalAnalyzerManager.setTimeSlotInterval(value)

                                        // 隐藏默认按钮
                                        up.indicator: Item { }
                                        down.indicator: Item { }

                                        // 连续增减定时器
                                        Timer {
                                            id: repeatTimer
                                            interval: 150
                                            repeat: true
                                            property bool isIncrement: true
                                            onTriggered: {
                                                if (isIncrement)
                                                    customSpinBox.increase()
                                                else
                                                    customSpinBox.decrease()
                                            }
                                        }

                                        // 自定义背景样式
                                        background: Rectangle {
                                            color: "#e0e0e0"
                                            radius: 4
                                            border.color: "#808080"
                                            border.width: 1
                                            
                                            // 凹陷效果
                                            gradient: Gradient {
                                                GradientStop { position: 0.0; color: "#c0c0c0" }
                                                GradientStop { position: 1.0; color: "#f0f0f0" }
                                            }

                                            // 自定义上下按钮区域
                                            Rectangle {
                                                anchors.right: parent.right
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                width: 30
                                                color: "transparent"

                                                // 上箭头按钮
                                                Rectangle {
                                                    id: upButton
                                                    anchors.right: parent.right
                                                    anchors.top: parent.top
                                                    anchors.rightMargin: 4
                                                    anchors.topMargin: 2
                                                    width: 22
                                                    height: parent.height / 2 - 2
                                                    color: upMouseArea.pressed ? "#A0A0A0" : "transparent"
                                                    radius: 2

                                                    // 绘制上箭头
                                                    Canvas {
                                                        anchors.centerIn: parent
                                                        width: 12
                                                        height: 6
                                                        onPaint: {
                                                            var ctx = getContext("2d");
                                                            ctx.fillStyle = "#404040";
                                                            ctx.beginPath();
                                                            ctx.moveTo(0, 6);
                                                            ctx.lineTo(6, 0);
                                                            ctx.lineTo(12, 6);
                                                            ctx.fill();
                                                        }
                                                    }

                                                    // 上箭头点击区域
                                                    MouseArea {
                                                        id: upMouseArea
                                                        anchors.fill: parent
                                                        property bool isLongPress: false
                                                        preventStealing: true

                                                        onPressed: {
                                                            mouse.accepted = true
                                                            isLongPress = false
                                                            delayTimer.callback = function(){
                                                                isLongPress = true;
                                                                repeatTimer.isIncrement = true
                                                                repeatTimer.start()
                                                            }
                                                            delayTimer.start();
                                                        }
                                                        
                                                        onReleased: {
                                                            delayTimer.stop();
                                                            repeatTimer.stop();
                                                            if (!isLongPress) {
                                                                customSpinBox.increase();
                                                            }
                                                        }

                                                        onCanceled: {
                                                            delayTimer.stop();
                                                            repeatTimer.stop();
                                                        }
                                                    }
                                                }

                                                // 下箭头按钮
                                                Rectangle {
                                                    id: downButton
                                                    anchors.right: parent.right
                                                    anchors.bottom: parent.bottom
                                                    anchors.rightMargin: 4
                                                    anchors.bottomMargin: 2
                                                    width: 22
                                                    height: parent.height / 2 - 2
                                                    color: downMouseArea.pressed ? "#A0A0A0" : "transparent"
                                                    radius: 2

                                                    // 绘制下箭头
                                                    Canvas {
                                                        anchors.centerIn: parent
                                                        width: 12
                                                        height: 6
                                                        onPaint: {
                                                            var ctx = getContext("2d");
                                                            ctx.fillStyle = "#404040";
                                                            ctx.beginPath();
                                                            ctx.moveTo(0, 0);
                                                            ctx.lineTo(12, 0);
                                                            ctx.lineTo(6, 6);
                                                            ctx.fill();
                                                        }
                                                    }

                                                    // 下箭头点击区域
                                                    MouseArea {
                                                        id: downMouseArea
                                                        anchors.fill: parent
                                                        property bool isLongPress: false
                                                        preventStealing: true

                                                        onPressed: {
                                                            mouse.accepted = true
                                                            isLongPress = false
                                                            delayTimer.callback = function() {
                                                                isLongPress = true;
                                                                repeatTimer.isIncrement = false;
                                                                repeatTimer.start();
                                                            }
                                                            delayTimer.start();
                                                        }
                                                        
                                                        onReleased: {
                                                            delayTimer.stop();
                                                            repeatTimer.stop();
                                                            if (!isLongPress) {
                                                                customSpinBox.decrease();
                                                            }
                                                        }

                                                        onCanceled: {
                                                            delayTimer.stop();
                                                            repeatTimer.stop();
                                                        }
                                                    }
                                                    
                                                    // 长按检测定时器
                                                    Timer {
                                                        id: delayTimer
                                                        interval: 300
                                                        repeat: false
                                                        property var callback: function() {}
                                                        onTriggered: callback()
                                                    }
                                                }
                                            }
                                        }

                                        // 自定义文本区域
                                        contentItem: Item {
                                            Text {
                                                anchors.fill: parent
                                                text: customSpinBox.value
                                                color: "black"
                                                font.pixelSize: 18
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                leftPadding: 5
                                                rightPadding: 35
                                            }

                                            // 触发数字键盘的鼠标区域，显示键盘
                                            MouseArea {
                                                anchors.left: parent.left
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                width: parent.width - 35
                                                onClicked: {
                                                    numericKeypad.setValue(customSpinBox.value)   // 设置初始值
                                                    numericKeypad.maxValue = customSpinBox.to     // 设置最大值
                                                    numericKeypad.minValue = customSpinBox.from   // 设置最小值
                                                    numericKeypad.open()                          // 打开键盘
                                                }
                                            }
                                        }

                                        // 尺寸设置
                                        Layout.preferredWidth: 90
                                        Layout.preferredHeight: 70
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    // 数字键盘组件，创建组件实例
                                    NumericKeypad {
                                        id: numericKeypad
                                        x: (parent.width - width) / 2
                                        y: (parent.height - height) / 2

                                        // 连接valueSubmitted信号
                                        onValueSubmitted: function(value) {
                                            customSpinBox.value = value   // 将输入的值应用到SpinBox
                                        }
                                    }

                                    // 时间单位选择区域
                                    Column {
                                        spacing: 5
                                        Layout.alignment: Qt.AlignVCenter

                                        // "秒"单选按钮
                                        RadioButton {
                                            text: qsTr("Seconds")
                                            checked: signalAnalyzerManager.timeSlotInSeconds
                                            onCheckedChanged: if (checked) signalAnalyzerManager.setTimeSlotUnit(true)

                                            // 自定义单选框样式
                                            indicator: Rectangle {
                                                implicitWidth: 16
                                                implicitHeight: 16
                                                x: 2
                                                y: parent.height / 2 - height / 2
                                                radius: 8
                                                border.color: "white"
                                                border.width: 1
                                                color: "transparent"

                                                Rectangle {
                                                    width: 8
                                                    height: 8
                                                    x: 4
                                                    y: 4
                                                    radius: 4
                                                    color: parent.parent.checked ? "white" : "transparent"
                                                }
                                            }

                                            // 自定义文本样式
                                            contentItem: Text {
                                                text: parent.text
                                                font.pixelSize: 16
                                                color: "white"
                                                verticalAlignment: Text.AlignVCenter
                                                leftPadding: parent.indicator.width + 8
                                            }
                                        }

                                        // "分钟"单选按钮
                                        RadioButton {
                                            text: qsTr("Minutes")
                                            checked: !signalAnalyzerManager.timeSlotInSeconds
                                            onCheckedChanged: if (checked) signalAnalyzerManager.setTimeSlotUnit(false)

                                            // 自定义单选框样式
                                            indicator: Rectangle {
                                                implicitWidth: 16
                                                implicitHeight: 16
                                                x: 2
                                                y: parent.height / 2 - height / 2
                                                radius: 8
                                                border.color: "white"
                                                border.width: 1
                                                color: "transparent"

                                                Rectangle {
                                                    width: 8
                                                    height: 8
                                                    x: 4
                                                    y: 4
                                                    radius: 4
                                                    color: parent.parent.checked ? "white" : "transparent"
                                                }
                                            }

                                            // 自定义文本样式
                                            contentItem: Text {
                                                text: parent.text
                                                font.pixelSize: 16
                                                color: "white"
                                                verticalAlignment: Text.AlignVCenter
                                                leftPadding: parent.indicator.width + 8
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // 时间槽设置标题
                        Rectangle {
                            id: slotSettingTitle
                            x: 15
                            y: 0
                            height: 20
                            color: "#336699"
                            radius: 4
                            width: slotSettingText.width + 20

                            Text {
                                id: slotSettingText
                                anchors.centerIn: parent
                                text: qsTr("Time Slot Setting")
                                font.pixelSize: 16
                                font.bold: true
                                color: "white"
                            }
                        }
                    }

                    // 触发模式设置区域
                    Item {
                        Layout.preferredWidth: 500
                        Layout.preferredHeight: 150

                        // 边框
                        Rectangle {
                            id: triggerModeRect
                            anchors.fill: parent
                            anchors.topMargin: 10
                            color: "transparent"
                            border.color: "white"
                            border.width: 2
                            radius: 4

                            // 内容布局
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                anchors.topMargin: 15
                                spacing: 10

                                // 触发模式选项
                                ColumnLayout {
                                    spacing: 12

                                    // 触发模式选项1
                                    RadioButton {
                                        text: qsTr("By frame image difference and loss of signal")
                                        checked: signalAnalyzerManager.triggerMode === 0
                                        onCheckedChanged: if (checked) signalAnalyzerManager.setTriggerMode(0)

                                        // 自定义样式
                                        indicator: Rectangle {
                                            implicitWidth: 16
                                            implicitHeight: 16
                                            x: 2
                                            y: parent.height / 2 - height / 2
                                            radius: 8
                                            border.color: "white"
                                            border.width: 1
                                            color: "transparent"

                                            Rectangle {
                                                width: 8
                                                height: 8
                                                x: 4
                                                y: 4
                                                radius: 4
                                                color: parent.parent.checked ? "white" : "transparent"
                                            }
                                        }

                                        // 自定义文本
                                        contentItem: Text {
                                            text: parent.text
                                            font.pixelSize: 18
                                            color: "white"
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + 8
                                            wrapMode: Text.WordWrap
                                            width: parent.width - parent.indicator.width - 10
                                        }
                                    }

                                    // 触发模式选项2
                                    RadioButton {
                                        text: qsTr("Loss of signal only")
                                        checked: signalAnalyzerManager.triggerMode === 1
                                        onCheckedChanged: if (checked) signalAnalyzerManager.setTriggerMode(1)

                                        // 自定义单选框样式
                                        indicator: Rectangle {
                                            implicitWidth: 16
                                            implicitHeight: 16
                                            x: 2
                                            y: parent.height / 2 - height / 2
                                            radius: 8
                                            border.color: "white"
                                            border.width: 1
                                            color: "transparent"

                                            Rectangle {
                                                width: 8
                                                height: 8
                                                x: 4
                                                y: 4
                                                radius: 4
                                                color: parent.parent.checked ? "white" : "transparent"
                                            }
                                        }

                                        // 自定义文本样式
                                        contentItem: Text {
                                            text: parent.text
                                            font.pixelSize: 18
                                            color: "white"
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + 8
                                        }
                                    }
                                }
                            }
                        }

                        // 触发模式标题
                        Rectangle {
                            id: triggerModeTitle
                            x: 15
                            y: 0
                            height: 20
                            color: "#336699"
                            radius: 4
                            width: triggerModeText.width + 20

                            Text {
                                id: triggerModeText
                                anchors.centerIn: parent
                                text: qsTr("Trigger Mode")
                                font.pixelSize: 16
                                font.bold: true
                                color: "white"
                            }
                        }
                    }

                    // 右侧控制按钮区域
                    Rectangle {
                        color: "transparent"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150

                        ColumnLayout {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 10
                            width: 160

                            // "Stop" 按钮
                            Button {
                                id: stopButton
                                text: qsTr("Stop")
                                Layout.preferredHeight: 50
                                Layout.preferredWidth: 150
                                font.pixelSize: 16
                                font.bold: true
                                
                                // 点击动画属性
                                property bool isPressed: false
                                
                                // 红色按钮样式
                                background: Rectangle {
                                    color: stopButton.isPressed ? "#B73C2D" : "#D75A4A"  // 按下时颜色加深
                                    radius: 4
                                    border.color: stopButton.isPressed ? "#6B1600" : "#8B2500"
                                    border.width: stopButton.isPressed ? 2 : 1
                                    
                                    // 动画效果
                                    Behavior on color { ColorAnimation { duration: 100 } }
                                    scale: stopButton.isPressed ? 0.95 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 100 } }
                                }
                                
                                // 按钮文本
                                contentItem: Text {
                                    text: stopButton.text
                                    font: stopButton.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    
                                    scale: stopButton.isPressed ? 0.95 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 100 } }
                                }
                                
                                // 鼠标事件处理
                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: { stopButton.isPressed = true }
                                    onReleased: { stopButton.isPressed = false }
                                    onClicked: {
                                        signalAnalyzerManager.stopMonitor();
                                        console.log("Stop monitoring requested");
                                    }
                                    onCanceled: { stopButton.isPressed = false }
                                }
                            }
                            
                            // "Clear Data" 按钮
                            Button {
                                id: clearDataButton
                                text: qsTr("Clear Data")
                                Layout.preferredHeight: 50
                                Layout.preferredWidth: 150
                                font.pixelSize: 16
                                font.bold: true
                                
                                // 点击动画属性
                                property bool isPressed: false
                                
                                // 蓝色按钮样式
                                background: Rectangle {
                                    color: clearDataButton.isPressed ? "#4A7FB0" : "#5B9BD5"  // 按下时颜色加深
                                    radius: 4
                                    border.color: clearDataButton.isPressed ? "#20416F" : "#2F528F"
                                    border.width: clearDataButton.isPressed ? 2 : 1
                                    
                                    // 动画效果
                                    Behavior on color { ColorAnimation { duration: 100 } }
                                    scale: clearDataButton.isPressed ? 0.95 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 100 } }
                                }
                                
                                // 按钮文本
                                contentItem: Text {
                                    text: clearDataButton.text
                                    font: clearDataButton.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    
                                    scale: clearDataButton.isPressed ? 0.95 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 100 } }
                                }
                                
                                // 鼠标事件处理
                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: { clearDataButton.isPressed = true }
                                    onReleased: { clearDataButton.isPressed = false }
                                    onClicked: {
                                        signalAnalyzerManager.clearMonitorData();
                                        console.log("Clear data requested");
                                    }
                                    onCanceled: { clearDataButton.isPressed = false }
                                }
                            }
                        }
                    }
                }
            }

            // 数据可视化区域 - 网格显示
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"
                border.color: "black"
                border.width: 1
                radius: 4

                // 背景渐变效果
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FFFFFF" }
                    GradientStop { position: 1.0; color: "#EEEEEE" }
                }

                // 添加滚动视图
                Flickable {
                    id: gridScrollView
                    anchors.fill: parent
                    anchors.margins: 10

                    // 固定宽度，但高度根据内容动态变化
                    contentWidth: dataGrid.width + rowLabels.width
                    contentHeight: headerRow.height + dataGrid.height
                    
                    clip: true
                    
                    // 启用滚动条
                    ScrollBar.vertical: ScrollBar {
                        id: verticalScrollBar
                        active: true
                        policy: ScrollBar.AsNeeded
                        visible: gridScrollView.contentHeight > gridScrollView.height
                    }
                    
                    ScrollBar.horizontal: ScrollBar {
                        id: horizontalScrollBar
                        active: true
                        policy: ScrollBar.AsNeeded
                        visible: gridScrollView.contentWidth > gridScrollView.width
                    }
                    
                    // 头部刻度行（固定在顶部）
                    Row {
                        id: headerRow
                        anchors.top: parent.top
                        anchors.left: rowLabels.right
                        height: 40
                        width: dataGrid.width
                        spacing: 0

                        // 刻度标记
                        Repeater {
                            model: 10
                            delegate: Rectangle {
                                width: dataGrid.cellWidth * 10
                                height: parent.height
                                color: "transparent"

                                // 刻度文本
                                Text {
                                    anchors.centerIn: parent
                                    text: (index + 1) * 10  // 10, 20, 30...
                                    font.pixelSize: 16
                                    color: "#404040"
                                }

                                // 刻度线
                                Rectangle {
                                    width: 1
                                    height: 8
                                    color: "#808080"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                }
                            }
                        }
                    }

                    // 左侧行标签区域
                    Column {
                        id: rowLabels
                        anchors.top: headerRow.bottom
                        anchors.left: parent.left
                        width: 70
                        height: dataGrid.height
                        
                        // 批次号标签格式 - 显示完整的批次号列表
                        Repeater {
                            model: 20  // 固定20行
                            delegate: Rectangle {
                                width: rowLabels.width
                                height: 35  // 固定行高
                                color: index % 2 === 0 ? "#F8F8F8" : "#EFEFEF"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    // 显示批次号序列
                                    text: {
                                        // 使用固定的批次号列表，每一行显示一个批次号
                                        var batchLabels = [
                                                    "0001", "0101", "0201", "0301", "0401", "0501",
                                                    "0601", "0701", "0801", "0901", "1001", "1101",
                                                    "1201", "1301", "1401", "1501", "1601", "1701",
                                                    "1801", "1901"
                                                ];

                                        // 返回对应行的批次号
                                        return index < batchLabels.length ? batchLabels[index] : "";
                                    }
                                    font.pixelSize: 16
                                    font.family: "Courier"  // 等宽字体
                                    color: "#404040"
                                }
                            }
                        }
                    }

                    // 数据网格区域
                    Rectangle {
                        id: dataGrid
                        anchors.top: headerRow.bottom
                        anchors.left: rowLabels.right
                        height: 35 * 20  // 支持显示20行
                        width: cellWidth * 100
                        color: "#FAFAFA"
                        border.color: "#D0D0D0"
                        border.width: 1

                        // 单元格宽度
                        property real cellWidth: 20
                        
                        // 绘制网格线
                        Canvas {
                            id: gridLines
                            anchors.fill: parent

                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.strokeStyle = "#E0E0E0";
                                ctx.lineWidth = 1;
                                
                                // 垂直网格线 - 每10个槽位一条主线，每槽位一条细线
                                var totalCols = 100;
                                var cellWidth = parent.cellWidth;
                                
                                // 主网格线 (每10个槽位)
                                for (var i = 10; i < totalCols; i += 10) {
                                    ctx.beginPath();
                                    ctx.lineWidth = 1;
                                    ctx.moveTo(i * cellWidth, 0);
                                    ctx.lineTo(i * cellWidth, height);
                                    ctx.stroke();
                                }
                                
                                // 次网格线 (每个槽位)
                                ctx.strokeStyle = "#F0F0F0";
                                ctx.lineWidth = 0.5;
                                for (var i = 1; i < totalCols; i++) {
                                    if (i % 10 !== 0) {  // 跳过已经绘制的主网格线
                                        ctx.beginPath();
                                        ctx.moveTo(i * cellWidth, 0);
                                        ctx.lineTo(i * cellWidth, height);
                                        ctx.stroke();
                                    }
                                }
                                
                                // 水平网格线
                                ctx.strokeStyle = "#E0E0E0";
                                ctx.lineWidth = 1;
                                var rowHeight = 35;  // 固定行高
                                var totalRows = Math.ceil(height / rowHeight);
                                for (var j = 1; j < totalRows; j++) {
                                    ctx.beginPath();
                                    ctx.moveTo(0, j * rowHeight);
                                    ctx.lineTo(width, j * rowHeight);
                                    ctx.stroke();
                                }
                            }
                        }
                        
                        // 数据显示
                        Canvas {
                            id: dataCanvas
                            anchors.fill: parent
                            property var signalData: signalAnalyzerManager.monitorData || []
                            
                            // 最大槽位数
                            property int maxTotalSlots: 2040

                            onPaint: {
                                var ctx = getContext("2d");
                                var totalCols = 100;
                                var cellWidth = parent.cellWidth;
                                var rowHeight = 35;  // 固定行高
                                
                                // 确保至少有一些数据可显示
                                if (!signalData || signalData.length === 0) {
                                    // 生成示例数据 - 采用批次号组织形式，确保数据正确跨行显示
                                    signalData = [];
                                    
                                    // 第一批次数据 (0001) - 前150个槽位，确保跨越两行
                                    // 索引0-149，其中0-99显示在第一行，100-149显示在第二行
                                    for (var i = 0; i < 101; i++) {
                                        if(i>70 && i<80)
                                            signalData.push(i);
                                    }
                                    
                                    // 第二批次数据 (0101) - 接下来80个槽位，从第三行开始
                                    // 索引200-279，对应第三行的0-79
                                    for (var j = 0; j < 80; j++) {
                                        signalData.push(200 + j);
                                    }
                                    
                                    // 第三批次数据 (0201) - 接下来120个槽位，从第四行开始
                                    // 索引300-419，对应第四行的0-99和第五行的0-19
                                    for (var k = 0; k < 120; k++) {
                                        signalData.push(300 + k);
                                    }
                                    
                                    // 第四批次数据 (0301) - 接下来50个槽位，从第六行开始
                                    // 索引500-549，对应第六行的0-49
                                    for (var l = 0; l < 50; l++) {
                                        signalData.push(500 + l);
                                    }
                                    
                                    // 第五批次数据 (0401) - 接下来30个槽位，从第七行开始
                                    // 索引600-629，对应第七行的0-29
                                    for (var m = 0; m < 30; m++) {
                                        signalData.push(600 + m);
                                    }
                                }
                                
                                // 计算需要的行数
                                var lastIndex = signalData.length > 0 ? signalData[signalData.length - 1] : 0;
                                
                                // 检查是否超过最大槽位数
                                if (lastIndex >= maxTotalSlots) {
                                    showMaxSlotsWarning();
                                }
                                
                                var neededRows = Math.max(20, Math.ceil((lastIndex + 1) / totalCols));
                                
                                // 如果需要更多行，调整网格高度
                                if (neededRows > 20) {
                                    var newHeight = neededRows * rowHeight;
                                    if (dataGrid.height !== newHeight) {
                                        dataGrid.height = newHeight;
                                        // 重新设置滚动视图内容高度
                                        gridScrollView.contentHeight = headerRow.height + newHeight;
                                        // 请求重绘网格线
                                        gridLines.requestPaint();
                                    }
                                }
                                
                                // 绘制所有数据点，并确保批次与行对齐正确
                                ctx.clearRect(0, 0, width, height);
                                for (var i = 0; i < signalData.length; i++) {
                                    var index = signalData[i];
                                    
                                    // 如果超出最大槽位，跳过
                                    if (index >= maxTotalSlots) continue;
                                    
                                    var col = index % totalCols;
                                    var row = Math.floor(index / totalCols);
                                    
                                    // 只绘制数字"1"
                                    ctx.fillStyle = "black";
                                    ctx.font = "12px sans-serif";
                                    ctx.textAlign = "center";
                                    ctx.textBaseline = "middle";
                                    ctx.fillText("1",
                                                 col * cellWidth + cellWidth/2,
                                                 row * rowHeight + rowHeight/2);
                                }
                            }
                            
                            // 显示最大槽位警告
                            function showMaxSlotsWarning() {
                                var component = Qt.createComponent("qrc:/WarningDialog.qml");
                                if (component.status === Component.Ready) {
                                    var dialog = component.createObject(root, {
                                                                            "title": "最大槽位数已达到",
                                                                            "message": "您已达到最大时间槽位数 (2040)。请在继续前保存或清除您的数据。"
                                                                        });
                                    dialog.open();
                                } else {
                                    console.warn("已达到最大时间槽位数 (2040)!");
                                }
                            }
                            
                            // 数据变化时重绘
                            onSignalDataChanged: requestPaint();
                            
                            // 大小变化时重绘
                            onWidthChanged: requestPaint();
                            onHeightChanged: requestPaint();
                            
                            // 组件完成后请求绘制
                            Component.onCompleted: requestPaint();
                        }
                    }
                }
            }
        }
    }
}
