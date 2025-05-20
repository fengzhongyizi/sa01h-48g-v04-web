import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup {
    id: keypad
    width: 750
    height: 1000
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // 当前输入值
    // 在文件顶部，修改属性声明方式，增加通知
    // 正确的语法：先定义属性，然后添加监听器
    property string inputValue: "0"

    // 属性变更监听器的正确格式是 on[属性名首字母大写]Changed
    onInputValueChanged: {
        // 确保显示始终与值同步
        if (display) display.text = inputValue
    }
    property int maxValue: 100
    property int minValue: 1

    // 提供给外部的信号，用于通知输入完成
    signal valueSubmitted(int value)
    signal cancelled()

    // 修改 setValue 函数，确保引用可用后再设置
    function setValue(val) {
        // 设置初始值时先等待组件准备好
        Qt.callLater(function() {
            inputValue = val.toString()
            if (display) display.text = inputValue
        })
    }

    contentItem: Rectangle {
        color: "#336699"
        border.color: "white"
        border.width: 4
        radius: 16

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 25
            spacing: 20

            // 标题
            Text {
                text: qsTr("Enter Value")
                font.pixelSize: 48
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            // 显示区域
            Rectangle {
                Layout.fillWidth: true
                height: 120
                color: "#e0e0e0"
                radius: 10
                border.color: "#808080"
                border.width: 2

                Text {
                    id: display
                    anchors.fill: parent
                    anchors.margins: 12
                    text: keypad.inputValue
                    font.pixelSize: 56
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    color: "black"
                }
            }

            // 数字按钮网格
            GridLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 20
                columnSpacing: 20

                // 修复值显示问题
                Repeater {
                    model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "C", "0", "⌫"]
                    // 确保 Repeater 中的按钮点击处理保持简单
                    Button {
                        text: modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        font.pixelSize: 50

                        // 特殊处理退格和清除按钮
                        font.bold: modelData === "C" || modelData === "⌫" ? true : false

                        background: Rectangle {
                            color: parent.pressed ? "#A0A0A0" : "#e0e0e0"
                            radius: 10
                            border.color: "#808080"
                            border.width: 1
                        }

                        onClicked: {
                            if (modelData === "⌫") {
                                // 删除最后一位
                                if (keypad.inputValue.length > 1) {
                                    keypad.inputValue = keypad.inputValue.substring(0, keypad.inputValue.length - 1)
                                } else {
                                    keypad.inputValue = "0"
                                }
                            } else if (modelData === "C") {
                                // 清除
                                keypad.inputValue = "0"
                            } else {
                                // 添加数字
                                if (keypad.inputValue === "0") {
                                    keypad.inputValue = modelData
                                } else {
                                    // 检查添加数字后是否超出最大值
                                    var newValue = keypad.inputValue + modelData
                                    if (parseInt(newValue) <= keypad.maxValue) {
                                        keypad.inputValue = newValue
                                    }
                                }
                            }
                            // 不需要这行，因为我们添加了propertyChanged通知
                            // display.text = keypad.inputValue
                        }
                    }
                }
            }

            // 确认和取消按钮
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 120  // 增加固定高度
                spacing: 25

                Button {
                    text: qsTr("Cancel")
                    Layout.fillWidth: true
                    font.pixelSize: 42
                    background: Rectangle {
                        color: parent.pressed ? "#A0A0A0" : "#e0e0e0"
                        radius: 10
                        border.color: "#808080"
                        border.width: 2
                    }
                    onClicked: {
                        keypad.cancelled()
                        keypad.close()
                    }
                }

                Button {
                    text: qsTr("OK")
                    Layout.fillWidth: true
                    font.pixelSize: 42
                    background: Rectangle {
                        color: parent.pressed ? "#A0C0E0" : "#80A0C0"
                        radius: 10
                        border.color: "#606080"
                        border.width: 2
                    }
                    onClicked: {
                        var val = parseInt(keypad.inputValue)
                        // 确保值在允许范围内
                        val = Math.max(keypad.minValue, Math.min(val, keypad.maxValue))
                        keypad.valueSubmitted(val)
                        keypad.close()
                    }
                }
            }
        }
    }
}
