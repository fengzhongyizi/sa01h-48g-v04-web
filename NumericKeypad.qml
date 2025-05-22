// NumericKeypad.qml
// 数字键盘组件，用于提供触摸友好的数字输入界面
// 主要用于SignalAnalyzer的Error Rate页面中，让用户输入时间槽数值
// 范围限制：通过minValue和maxValue属性限制输入的数值范围
// 辅助功能：提供清除(C)和退格(←)按钮进行输入修改
// 提供OK和Cancel按钮确认或取消输入

import QtQuick 2.12             // 提供基本QML元素，如Item, Rectangle等
import QtQuick.Controls 2.5     // 提供UI控件，如Button
import QtQuick.Layouts 1.12     // 提供布局管理器，如GridLayout

// 弹出式对话框组件
Popup {
    id: numericKeypad
    
    // 组件可见属性，控制键盘是否显示
    visible: false
    
    // 弹出窗口模态属性，设为true表示显示时阻止其他UI交互
    modal: true
    
    // 居中显示
    anchors.centerIn: parent
    
    // 键盘宽高设置
    width: 300
    height: 400
    
    // 定义组件的自定义属性
    property int currentValue: 0     // 当前输入的数值
    property int minValue: 1         // 最小允许值
    property int maxValue: 100       // 最大允许值
    property string displayText: ""  // 显示文本
    
    // 定义组件的自定义信号
    // 当用户提交数值时触发此信号，参数是提交的数值
    signal valueSubmitted(int value)
    
    // 组件显示时触发
    onOpened: {
        // 初始显示当前值
        displayText = currentValue.toString()
    }
    
    // 初始化组件的方法，设置初始值
    function setValue(value) {
        currentValue = value
        displayText = currentValue.toString()
    }
    
    // 添加数字到当前输入
    function appendDigit(digit) {
        // 如果当前显示是0，则替换；否则添加
        if (displayText === "0" || displayText === "") {
            displayText = digit
        } else {
            displayText += digit
        }
        
        // 转换为数字并检查范围
        var numValue = parseInt(displayText)
        if (numValue > maxValue) {
            displayText = maxValue.toString()
        }
    }
    
    // 移除最后一个数字
    function removeLastDigit() {
        if (displayText.length > 0) {
            displayText = displayText.slice(0, -1)
            if (displayText === "") {
                displayText = "0"
            }
        }
    }
    
    // 清除输入
    function clearInput() {
        displayText = "0"
    }
    
    // 提交输入值
    function submitValue() {
        var numValue = parseInt(displayText)
        // 确保值在有效范围内
        if (numValue < minValue) {
            numValue = minValue
        } else if (numValue > maxValue) {
            numValue = maxValue
        }
        
        // 发送值提交信号
        valueSubmitted(numValue)
        // 关闭键盘
        close()
    }
    
    // 主布局容器
    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"         // 背景色
        border.color: "#a0a0a0"   // 边框色
        border.width: 1
        radius: 8                // 圆角
        
        // 垂直布局
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            
            // 输入显示区域
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "white"
                border.color: "#808080"
                border.width: 1
                radius: 4
                
                // 显示当前输入的文本
                Text {
                    anchors.fill: parent
                    anchors.margins: 5
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: displayText
                    font.pixelSize: 24
                    elide: Text.ElideRight  // 文本过长时省略
                    color: "black"
                }
            }
            
            // 数字按钮网格布局
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3        // 3列布局
                rowSpacing: 5
                columnSpacing: 5
                
                // 数字按钮1-9
                Repeater {
                    model: 9      // 9个按钮
                    // 生成数字1-9的按钮
                    Button {
                        text: (index + 1).toString()  // 显示对应数字
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        font.pixelSize: 20
                        
                        // 点击事件处理
                        onClicked: {
                            appendDigit(text)
                        }
                        
                        // 按钮样式
                        background: Rectangle {
                            color: parent.pressed ? "#d0d0d0" : "#e0e0e0"
                            radius: 4
                            border.color: "#a0a0a0"
                            border.width: 1
                        }
                    }
                }
                
                // 清除按钮
                Button {
                    text: "C"     // 清除
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font.pixelSize: 20
                    
                    onClicked: {
                        clearInput()
                    }
                    
                    background: Rectangle {
                        color: parent.pressed ? "#ffd0d0" : "#ffe0e0"  // 红色调
                        radius: 4
                        border.color: "#a0a0a0"
                        border.width: 1
                    }
                }
                
                // 数字0按钮
                Button {
                    text: "0"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font.pixelSize: 20
                    
                    onClicked: {
                        appendDigit("0")
                    }
                    
                    background: Rectangle {
                        color: parent.pressed ? "#d0d0d0" : "#e0e0e0"
                        radius: 4
                        border.color: "#a0a0a0"
                        border.width: 1
                    }
                }
                
                // 退格按钮
                Button {
                    text: "←"    // 退格符号
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font.pixelSize: 20
                    
                    onClicked: {
                        removeLastDigit()
                    }
                    
                    background: Rectangle {
                        color: parent.pressed ? "#d0d0ff" : "#e0e0ff"  // 蓝色调
                        radius: 4
                        border.color: "#a0a0a0"
                        border.width: 1
                    }
                }
            }
            
            // 底部按钮区域
            RowLayout {
                Layout.fillWidth: true
                height: 50
                spacing: 10
                
                // 取消按钮
                Button {
                    text: qsTr("Cancel")
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    font.pixelSize: 18
                    
                    // 点击取消关闭键盘
                    onClicked: {
                        numericKeypad.close()
                    }
                    
                    background: Rectangle {
                        color: parent.pressed ? "#ffd0d0" : "#ffe0e0"
                        radius: 4
                        border.color: "#c08080"
                        border.width: 1
                    }
                }
                
                // 确认按钮
                Button {
                    text: qsTr("OK")
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    font.pixelSize: 18
                    
                    // 点击确认提交数值
                    onClicked: {
                        submitValue()
                    }
                    
                    background: Rectangle {
                        color: parent.pressed ? "#d0ffd0" : "#e0ffe0"  // 绿色调
                        radius: 4
                        border.color: "#80c080"
                        border.width: 1
                    }
                }
            }
        }
    }
}