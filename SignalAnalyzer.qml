// SignalAnalyzer.qml
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
//import SignalAnalyzer 1.0    // C++ 单例注册模块
import QtCharts 2.2


Rectangle {
    id: root
    anchors.fill: parent
    color: "lightgray"

    // 0 = 主菜单, 1 = Monitor, 2 = Signal Info, 3 = EDID, 4 = Error Rate
    property int pageFlag: 0

    // 添加数据处理和状态属性
    property string signalStatus: "No Signal" // 信号状态
    property string frameUrl: ""  // 帧图像URL
    property string resolution: "3840x2160@60Hz" // 分辨率
    
    // Signal Info页面需要的属性
    property string videoFormat: "3840x2160@60Hz" // 视频格式
    property string colorSpace: "RGB" // 色彩空间
    property string colorDepth: "8-bit" // 色彩深度
    property string hdrFormat: "HDR10" // HDR格式
    property string hdmiDvi: "HDMI 2.1" // HDMI/DVI
    property string frlRate: "FRL4 (12 Gbps)" // FRL速率
    property string dscMode: "Disabled" // DSC模式
    property string hdcpType: "HDCP 2.3" // HDCP类型
    
    // 音频信息
    property string samplingFreq: "48 kHz" // 采样频率
    property string samplingSize: "24-bit" // 采样大小
    property string channelCount: "2.0 (Stereo)" // 声道数
    property string channelNumber: "FL/FR" // 声道编号
    property string levelShift: "0 dB" // 电平偏移
    property string cBitSamplingFreq: "Level 1" // C-bit/采样频率
    property string cBitDataType: "PCM" // C-bit/数据类型
    
    // EDID页面需要的属性
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
    
    // Error Rate页面需要的属性
    property string monitorStartTime: "00:00:00" // 监控开始时间
    property int timeSlotInterval: 5 // 时间槽间隔
    property bool timeSlotInSeconds: true // 时间槽单位是秒
    property int triggerMode: 0 // 触发模式
    property var monitorData: [] // 监控数据
    
    // 处理二进制数据
    function processReceiveData(strcode, getdata) {
        console.log("SignalAnalyzer received data code:", strcode)
        // 这里处理接收到的数据，根据strcode分别处理
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
        // ...其他代码处理
    }
    
    // 处理ASCII数据
    function processReceiveAsciiData(data) {
        console.log("SignalAnalyzer received ASCII data:", data)
        // 处理ASCII格式的数据
        if(data.indexOf("EDID") !== -1 && data.indexOf("DATA") !== -1) {
            // 处理EDID数据
            var linedata = data.split(" ");
            // 根据需要更新相应的UI元素
        }
    }
    
    // 启动FPGA视频获取
    function startFpgaVideo() {
        console.log("Start FPGA video")
        signalStatus = "Active"
        // 发送命令到SerialPortManager
        var cmd = "AA 00 00 06 00 00 00 B1 00 01"
        serialPortManager.writeDataUart5(cmd, 0)
    }
    
    // EDID 选择单个EDID块
    function selectSingleEdid(index) {
        console.log("Select EDID at index:", index)
        // 更新选择状态
        for(var i = 0; i < edidList.length; i++) {
            edidList[i].selected = (i === index)
        }
        // 发出edidListChanged信号
        edidListChanged()
    }
    
    // 应用EDID设置
    function applyEdid() {
        console.log("Apply EDID settings")
        // 获取选中的EDID
        var selectedIndex = -1
        for(var i = 0; i < edidList.length; i++) {
            if(edidList[i].selected) {
                selectedIndex = i
                break
            }
        }
        
        if(selectedIndex >= 0) {
            // 发送命令应用EDID
            var cmd = "AA 00 00 06 00 00 00 B2 00 0" + selectedIndex
            serialPortManager.writeDataUart5(cmd, 0)
        }
    }
    
    // 开始错误率监控
    function startMonitor() {
        console.log("Start error rate monitor")
        monitorStartTime = new Date().toTimeString().split(' ')[0]
        // 清空历史数据
        monitorData = []
        // 发送开始监控命令
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

    // ——— 内容区，Index 对应 pageFlag ——
    StackLayout {
        id: contentStack
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.topMargin: 10  // 所有页面都使用相同的topMargin
        currentIndex: pageFlag

        // 0: 空白项（为了与之前的索引保持一致）
        Item {}

        // 1: Monitor 页面实现 - 参考 require01.jpg
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: pageFlag === 1

            // 背景
            Rectangle {
                anchors.fill: parent
                color: "#336699"  // 蓝色背景，与其他页面保持一致
                border.color: "black"
                border.width: 2
                radius: 4
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                // 色带图形区域（占据大部分空间）
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "black"
                    border.color: "white"
                    border.width: 2
                    radius: 4

                    // 当没有信号时显示"No Signal"
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("No Signal")
                        color: "white"
                        font.pixelSize: 24
                        visible: !signalAnalyzerManager.signalStatus || signalAnalyzerManager.signalStatus === "No Signal"
                    }

                    // 使用Image组件显示彩条或实际视频图像
                    Image {
                        id: videoImage
                        anchors.fill: parent
                        anchors.margins: 4
                        fillMode: Image.PreserveAspectFit
                        source: signalAnalyzerManager.frameUrl || ""
                        asynchronous: true
                        cache: false
                        visible: signalAnalyzerManager.signalStatus && signalAnalyzerManager.signalStatus !== "No Signal" && status === Image.Ready

                        // 加载出错时不再显示默认图片
                        onStatusChanged: {
                            if (status === Image.Error || status === Image.Null) {
                                visible = false
                            } else if (status === Image.Ready) {
                                visible = true
                            }
                        }
                    }

                    // 彩条区域 - 始终作为备选显示
                    Rectangle {
                        visible: !videoImage.visible && signalAnalyzerManager.signalStatus && signalAnalyzerManager.signalStatus !== "No Signal"
                        anchors.fill: parent
                        anchors.margins: 4
                        
                        // 彩条图案
                        Row {
                            anchors.fill: parent
                            
                            // 七色彩条
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

                    // 信号信息显示在底部
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: infoText.implicitHeight + 10
                        color: Qt.rgba(0, 0, 0, 0.7)
                        visible: signalAnalyzerManager.signalStatus && signalAnalyzerManager.signalStatus !== "No Signal"

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
                        
                        background: Rectangle {
                            color: parent.pressed ? "#C0C0C0" : "#E0E0E0"
                            border.color: "#808080"
                            border.width: 1
                            radius: 4
                        }
                    }

                    Item { Layout.fillWidth: true } // 弹性空间
                }
            }
        }

        // 2: Signal Info 页面（参考 require02.jpg）
        // ─── SignalAnalyzer.qml 中 StackLayout { … } 的第 2 项 ───
        // 2: Signal Info 页面
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: infoColumn.implicitHeight
                clip: true

                Column {
                    id: infoColumn
                    width: parent.width
                    spacing: 20
                    padding: 20

                    /*—— Received Signal Info ——*/
                    Rectangle {
                        color: "#E0E0E0"; border.color: "black"; border.width: 1; radius: 4
                        width: parent.width - parent.padding * 2
                        height: receivedInfoColumn.implicitHeight + 24  // 自动调整高度

                        Column {
                            id: receivedInfoColumn
                            anchors.fill: parent; anchors.margins: 12; spacing: 12
                            Text {
                                text: qsTr("Received Signal Info")
                                font.pixelSize: 22; font.bold: true; color: "black"
                            }
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
                                delegate: Item {
                                    width: parent.width
                                    height: 32  // 固定每行高度

                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 10
                                        Text {
                                            text: modelData.label
                                            font.pixelSize: 16
                                            color: "black"
                                            Layout.preferredWidth: 150
                                        }
                                        Text {
                                            text: modelData.value
                                            font.pixelSize: 16
                                            color: "black"
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                    }

                    /*—— Audio Info ——*/
                    Rectangle {
                        color: "#E0E0E0"; border.color: "black"; border.width: 1; radius: 4
                        width: parent.width - parent.padding * 2
                        height: audioInfoColumn.implicitHeight + 24  // 自动调整高度

                        Column {
                            id: audioInfoColumn
                            anchors.fill: parent; anchors.margins: 12; spacing: 12
                            Text {
                                text: qsTr("Audio")
                                font.pixelSize: 22; font.bold: true; color: "black"
                            }
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
                                delegate: Item {
                                    width: parent.width
                                    height: 32  // 固定每行高度

                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 10
                                        Text {
                                            text: modelData.label
                                            font.pixelSize: 16
                                            color: "black"
                                            Layout.preferredWidth: 150
                                        }
                                        Text {
                                            text: modelData.value
                                            font.pixelSize: 16
                                            color: "black"
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

        // 3: EDID 页面（参考 require03.jpg）
        // … 前面 Monitor/Signal Info 已有项 …
        // … inside your StackLayout (index 3) …

        // 3: EDID 页面

        Item {
            // Only visible when the EDID button is selected
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: pageFlag === 3

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                // Header
                Text {
                    text: qsTr("EDID Selection")
                    font.bold: true
                    font.pixelSize: 28  // 从22增大到28
                    color: "black"
                }

                // Scrollable area for the check-box list
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    GridLayout {
                        // Two columns, auto-wrapped
                        columns: 2
                        rowSpacing: 20       // 从8增大到20
                        columnSpacing: 60    // 从40增大到60
                        width: parent.width

                        Repeater {
                            // Assume edidList is an array of { name: string, selected: bool }
                            model: signalAnalyzerManager.edidList

                            delegate: RowLayout {
                                spacing: 12   // 从8增大到12
                                Layout.fillWidth: true

                                // 自定义方形单选框
                                Item {
                                    width: 32     // 增大选择框尺寸
                                    height: 32
                                    Layout.alignment: Qt.AlignVCenter

                                    // 外框 - 现在是方形
                                    Rectangle {
                                        width: 28
                                        height: 28
                                        anchors.centerIn: parent
                                        radius: 2        // 从8改为2，使其成为方形但有轻微圆角
                                        border.color: "black"
                                        border.width: 2
                                        color: "transparent"

                                        // 内部选中标记 - 现在是方形
                                        Rectangle {
                                            width: 18
                                            height: 18
                                            anchors.centerIn: parent
                                            radius: 1     // 从4改为1
                                            color: modelData.selected ? "black" : "transparent"
                                        }
                                    }

                                    // 点击区域
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            // 直接调用选择方法，无需等待RadioButton的状态变化
                                            signalAnalyzerManager.selectSingleEdid(index)
                                        }
                                    }
                                }

                                Text {
                                    text: modelData.name
                                    font.pixelSize: 22   // 从18增大到22
                                    color: "black"
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }

                // Apply button
                Button {
                    text: qsTr("Apply")
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 120  // 增大按钮宽度
                    Layout.preferredHeight: 50  // 增大按钮高度
                    font.pixelSize: 20          // 增大字体大小
                    onClicked: signalAnalyzerManager.applyEdid()
                }
            }
        }


        // 4: Error Rate 页面（参考 require04.jpg）
        Item {
            Layout.fillWidth: true; Layout.fillHeight: true

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

                // 整个顶部区域的容器
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200

                    // 外部白色方框
                    Rectangle {
                        id: outerFrame
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "white"
                        border.width: 2
                        radius: 4
                        anchors.topMargin: 10 // 为标题留出空间
                    }

                    // 顶部切口标题
                    Rectangle {
                        id: monitorTitle
                        x: 20
                        y: 0
                        height: 24
                        color: "#336699"
                        //border.color: "white"
                        //border.width: 2
                        radius: 4
                        width: errorRateTitleText.width + 20

                        Text {
                            id: errorRateTitleText
                            anchors.centerIn: parent
                            text: qsTr("Signal Monitor (Total time slot number is 2040, every time slot is 1-255 seconds or minutes)")
                            font.pixelSize: 16
                            font.bold: true
                            color: "white"
                        }
                    }

                    // 内部控件布局
                    RowLayout {
                        id: topperL
                        spacing: 16
                        anchors.fill: parent
                        anchors.margins: 10
                        anchors.topMargin: 15 // 让内容远离标题

                        // New Start按钮区域
                        Rectangle {
                            color: "transparent"
                            //border.color: "white"; border.width: 2; radius: 4
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 150

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 8

                                Button {
                                    text: qsTr("New Start")
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: 50
                                    Layout.preferredWidth: 150
                                    font.pixelSize: 16
                                    font.bold: true
                                    background: Rectangle {
                                        color: "#E69138";
                                        radius: 4
                                        border.color: "#804000";
                                        border.width: 1
                                    }
                                    onClicked: signalAnalyzerManager.startMonitor()
                                }

                                Label {
                                    text: qsTr("start time: %1")
                                    .arg(signalAnalyzerManager.monitorStartTime || "00:00:00")
                                    font.pixelSize: 18
                                    color: "white"
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }

                        // 时间槽设置框
                        Item {
                            Layout.preferredWidth: 500
                            Layout.preferredHeight: 150

                            // 主矩形框
                            Rectangle {
                                id: slotSettingRect
                                anchors.fill: parent
                                anchors.topMargin: 10 // 为标题留出空间
                                color: "transparent"
                                border.color: "white"
                                border.width: 2
                                radius: 4

                                // 时间槽设置框 - 内容区域
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    anchors.topMargin: 15 // 为标题让位
                                    spacing: 8

                                    // 修改为一行布局
                                    RowLayout {
                                        spacing: 20 // 增加间距
                                        Layout.fillWidth: true

                                        // "Every time slot" 文字部分
                                        Label {
                                            text: qsTr("Every time slot")
                                            color: "white"
                                            font.pixelSize: 16
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        // SpinBox部分 - 凹陷效果和三角形按钮
                                        SpinBox {
                                            id: customSpinBox
                                            from: 1
                                            to: 100 // 设置最大值为100
                                            value: signalAnalyzerManager.timeSlotInterval
                                            onValueChanged: signalAnalyzerManager.setTimeSlotInterval(value)

                                            // 设置按钮的可见性为false，我们将创建自己的按钮
                                            up.indicator: Item { }
                                            down.indicator: Item { }

                                            // 添加连续增减的定时器
                                            Timer {
                                                id: repeatTimer
                                                interval: 150  // 调整速度 - 数值越小增减越快
                                                repeat: true
                                                property bool isIncrement: true
                                                onTriggered: {
                                                    if (isIncrement)
                                                        customSpinBox.increase()
                                                    else
                                                        customSpinBox.decrease()
                                                }
                                            }

                                            // 背景样式 - 创建凹陷效果
                                            background: Rectangle {
                                                color: "#e0e0e0"
                                                radius: 4
                                                border.color: "#808080"
                                                border.width: 1
                                                // 添加渐变创造凹陷效果
                                                gradient: Gradient {
                                                    GradientStop { position: 0.0; color: "#c0c0c0" }
                                                    GradientStop { position: 1.0; color: "#f0f0f0" }
                                                }

                                                // 右侧上下三角形按钮区域
                                                Rectangle {
                                                    anchors.right: parent.right
                                                    anchors.top: parent.top
                                                    anchors.bottom: parent.bottom
                                                    width: 30
                                                    color: "transparent"

                                                    // 上三角按钮
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

                                                        MouseArea {
                                                            id: upMouseArea
                                                            anchors.fill: parent
                                                            property bool isLongPress: false // 添加标志位区分点击和长按
                                                            //onClicked: customSpinBox.increase()

                                                            // 添加这一行防止事件传播，误触数字输入框
                                                            preventStealing: true

                                                            // 添加按住功能
                                                            onPressed: {
                                                                // 阻止事件继续传播,误触数字输入框
                                                                mouse.accepted = true

                                                                isLongPress = false // 初始设为短按
                                                                // 使用一个短延时，区分点击和长按
                                                                delayTimer.callback = function(){
                                                                    isLongPress = true;   // 如果延时后仍处于按下状态，标记为长按
                                                                    repeatTimer.isIncrement = true
                                                                    repeatTimer.start()
                                                                }
                                                                delayTimer.start();
                                                                
                                                            }
                                                            onReleased: {
                                                                delayTimer.stop();
                                                                repeatTimer.stop();
                                                                if (!isLongPress) {
                                                                    customSpinBox.increase();  // 短按时手动调用一次
                                                                }
                                                            }

                                                            onCanceled: {
                                                                delayTimer.stop();
                                                                repeatTimer.stop();
                                                            }
                                                        }
                                                    }

                                                    // 下三角按钮
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

                                                        MouseArea {
                                                            id: downMouseArea
                                                            anchors.fill: parent
                                                            property bool isLongPress: false
                                                            //onClicked: customSpinBox.decrease()

                                                            // 添加这一行防止事件传播，误触数字输入框
                                                            preventStealing: true

                                                            // 添加按住功能
                                                            onPressed: {
                                                                // 阻止事件继续传播
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
                                                                    customSpinBox.decrease();  // 短按时手动调用一次
                                                                }
                                                            }

                                                            onCanceled: {
                                                                delayTimer.stop();
                                                                repeatTimer.stop();
                                                            }
                                                        }
                                                        // 添加延时定时器，用于区分点击和长按
                                                        Timer {
                                                            id: delayTimer
                                                            interval: 300  // 300毫秒用于区分点击和长按
                                                            repeat: false
                                                            property var callback: function() {}
                                                            onTriggered: callback()
                                                        }
                                                    }
                                                }
                                            }

                                            // SpinBox部分中的内容文本样式修改
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

                                                // 添加鼠标区域来触发数字键盘
                                                MouseArea {
                                                    //anchors.fill: parent
                                                    anchors.left: parent.left
                                                    anchors.top: parent.top
                                                    anchors.bottom: parent.bottom
                                                    // 为右侧按钮留出空间
                                                    width: parent.width - 35
                                                    onClicked: {
                                                        numericKeypad.setValue(customSpinBox.value)
                                                        numericKeypad.maxValue = customSpinBox.to
                                                        numericKeypad.minValue = customSpinBox.from
                                                        numericKeypad.open()
                                                    }
                                                }
                                            }

                                            // 调整尺寸
                                            Layout.preferredWidth: 90    // 从120减少到90
                                            Layout.preferredHeight: 70   // 增加高度以匹配单选框组高度
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        // 在 SpinBox 外部添加 NumericKeypad 组件  自动组件查找机制
                                        NumericKeypad {
                                            id: numericKeypad
                                            x: (parent.width - width) / 2
                                            y: (parent.height - height) / 2

                                            onValueSubmitted: function(value) {
                                                customSpinBox.value = value
                                            }
                                        }

                                        // 单选按钮组 - 垂直排列
                                        Column {
                                            spacing: 5
                                            Layout.alignment: Qt.AlignVCenter

                                            RadioButton {
                                                text: qsTr("Seconds")
                                                checked: signalAnalyzerManager.timeSlotInSeconds
                                                onCheckedChanged: if (checked) signalAnalyzerManager.setTimeSlotUnit(true)

                                                // 自定义单选框指示器（使其变小）
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
                                                    font.pixelSize: 16
                                                    color: "white"
                                                    verticalAlignment: Text.AlignVCenter
                                                    leftPadding: parent.indicator.width + 8
                                                }
                                            }

                                            RadioButton {
                                                text: qsTr("Minutes")
                                                checked: !signalAnalyzerManager.timeSlotInSeconds
                                                onCheckedChanged: if (checked) signalAnalyzerManager.setTimeSlotUnit(false)

                                                // 自定义单选框指示器（与上面相同）
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

                            // 切口标题
                            Rectangle {
                                id: slotSettingTitle
                                x: 15
                                y: 0
                                height: 20
                                color: "#336699"
                                //border.color: "white"
                                //border.width: 2
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

                        // 触发模式框
                        Item {
                            Layout.preferredWidth: 700
                            Layout.preferredHeight:150

                            // 主矩形框
                            Rectangle {
                                id: triggerModeRect
                                anchors.fill: parent
                                anchors.topMargin: 10 // 为标题留出空间
                                color: "transparent"
                                border.color: "white"
                                border.width: 2
                                radius: 4

                                // 触发模式框内容区域
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    anchors.topMargin: 15 // 为标题让位
                                    spacing: 10  // 增大间距，让按钮更美观

                                    // 将 RowLayout 改为 ColumnLayout 使单选框垂直排列
                                    ColumnLayout {
                                        spacing: 12  // 设置两个单选框之间的垂直间距

                                        RadioButton {
                                            text: qsTr("By frame image difference and loss of signal")
                                            checked: signalAnalyzerManager.triggerMode === 0
                                            onCheckedChanged: if (checked) signalAnalyzerManager.setTriggerMode(0)

                                            // 自定义单选框指示器（使其变小）
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

                                            // 自定义文本项（增大字体）
                                            contentItem: Text {
                                                text: parent.text
                                                font.pixelSize: 18
                                                color: "white"
                                                verticalAlignment: Text.AlignVCenter
                                                leftPadding: parent.indicator.width + 8
                                                wrapMode: Text.WordWrap
                                                width: parent.width - parent.indicator.width - 10
                                            }

                                            // 移除不需要的palette设置
                                            // palette.windowText: "white"
                                        }

                                        RadioButton {
                                            text: qsTr("Loss of signal only")
                                            checked: signalAnalyzerManager.triggerMode === 1
                                            onCheckedChanged: if (checked) signalAnalyzerManager.setTriggerMode(1)

                                            // 自定义单选框指示器（与上面相同）
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

                                            // 自定义文本项（与上面相同）
                                            contentItem: Text {
                                                text: parent.text
                                                font.pixelSize: 18
                                                color: "white"
                                                verticalAlignment: Text.AlignVCenter
                                                leftPadding: parent.indicator.width + 8
                                            }

                                            // 移除不需要的palette设置
                                            // palette.windowText: "white"
                                        }
                                    }
                                }
                            }

                            // 切口标题
                            Rectangle {
                                id: triggerModeTitle
                                x: 15
                                y: 0
                                height: 20
                                color: "#336699"
                                //border.color: "white"
                                //border.width: 2
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
                    }
                }

                

                

                // 修改曲线图区域为数据网格
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    border.color: "black"
                    border.width: 1
                    radius: 4

                    // 创建背景渐变
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#FFFFFF" }
                        GradientStop { position: 1.0; color: "#EEEEEE" }
                    }

                    // 替换ChartView为自定义网格视图
                    Item {
                        id: signalGrid
                        anchors.fill: parent
                        anchors.margins: 10

                        // 顶部刻度区域
                        Row {
                            id: headerRow
                            anchors.top: parent.top
                            anchors.left: rowLabels.right
                            anchors.right: parent.right
                            height: 40
                            spacing: 0

                            // 显示刻度值
                            Repeater {
                                model: 10
                                delegate: Rectangle {
                                    width: (parent.width) / 10
                                    height: parent.height
                                    color: "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: (index + 1) * 10
                                        font.pixelSize: 16
                                        color: "#404040"
                                    }

                                    // 添加刻度线
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
                            anchors.bottom: parent.bottom
                            width: 70
                            spacing: 0

                            // 显示行标签 - 使用Flickable确保所有项可见
                            Flickable {
                                anchors.fill: parent
                                contentHeight: labelColumn.height
                                clip: true

                                Column {
                                    id: labelColumn
                                    width: parent.width
                                    spacing: 0

                                    // 显示行标签
                                    Repeater {
                                        model: ["0001", "0101", "0201", "0301", "0401", "0501",
                                            "0601", "0701", "0801", "0901", "1001", "1101"]
                                        delegate: Rectangle {
                                            width: parent.width
                                            // 固定高度而不是相对高度
                                            height: 35 // 调整这个值以改变行间距
                                            color: "transparent"

                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.right: parent.right
                                                anchors.rightMargin: 10
                                                text: modelData
                                                font.pixelSize: 16 // 减小字体大小
                                                font.family: "Courier" // 等宽字体
                                                color: "#404040"
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // 中间数据网格区域
                        Rectangle {
                            id: dataGrid
                            anchors.top: headerRow.bottom
                            anchors.left: rowLabels.right
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            color: "#FAFAFA"
                            border.color: "#D0D0D0"
                            border.width: 1

                            // 添加网格线 - 调整行高
                            Canvas {
                                id: gridLines
                                anchors.fill: parent

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.strokeStyle = "#E0E0E0"
                                    ctx.lineWidth = 1

                                    // 垂直网格线
                                    var cellWidth = width / 10
                                    for (var i = 1; i < 10; i++) {
                                        ctx.beginPath()
                                        ctx.moveTo(i * cellWidth, 0)
                                        ctx.lineTo(i * cellWidth, height)
                                        ctx.stroke()
                                    }

                                    // 水平网格线 - 使用固定行高
                                    var rowHeight = 35 // 与标签行高保持一致
                                    var rows = 12
                                    for (var j = 1; j < rows; j++) {
                                        ctx.beginPath()
                                        ctx.moveTo(0, j * rowHeight)
                                        ctx.lineTo(width, j * rowHeight)
                                        ctx.stroke()
                                    }
                                }
                            }

                            // 显示数据 - 调整行高
                            Canvas {
                                id: dataCanvas
                                anchors.fill: parent

                                // 信号数据
                                property var signalData: signalAnalyzerManager.monitorData || []

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.fillStyle = "#336699"
                                    var cellWidth = width / 100 // 100个时间点
                                    var rowHeight = 35 // 使用固定行高

                                    // 添加真实数据绘制逻辑
                                    if (signalData && signalData.length > 0) {
                                        for (var i = 0; i < signalData.length; i++) {
                                            var point = signalData[i];
                                            ctx.fillRect(point.x * cellWidth, point.y * rowHeight, cellWidth, rowHeight)
                                        }
                                    } else {
                                        // 没有数据时显示示例数据 - 第一行有31个"1"
                                        for (var i = 0; i < 31; i++) {
                                            ctx.fillRect(i * cellWidth, 0, cellWidth, rowHeight)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent; anchors.margins: 20; spacing: 20
                // TODO: 启动/停止按钮、时隙设置、结果展示
            }
        }
    }
}
