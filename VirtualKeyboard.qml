/**
 * @file VirtualKeyboard.qml
 * @brief 自定义虚拟键盘组件
 * 
 * 提供可配置的屏幕虚拟键盘，支持数字和全键盘模式，
 * 包括数字、字母以及常用功能键。
 */
import QtQuick 2.0                // 提供QML基本元素
import QtQuick.Controls 2.5       // 提供按钮等UI控件

/**
 * @brief 虚拟键盘主容器
 * 
 * 实现一个可配置的屏幕虚拟键盘，默认隐藏状态
 */
Rectangle {
    id: keyboard
    width: 600                    // 键盘宽度
    height: 800                   // 键盘高度
    color: "black"                // 键盘背景色
    z: 50                         // 确保键盘显示在其他元素上方
    visible: false                // 默认不可见，需要时显示

    // 配置属性
    property int btnfontsize: 35  // 按键字体大小
    property bool isUpperCase: false  // 大小写状态标志
    property bool numberOnly: true    // 仅数字模式标志

    // 按键按下信号，携带按键文本
    signal keyPressed(string key)

    /**
     * @brief 键盘区域鼠标事件捕获
     * 
     * 允许点击事件穿透到键盘按钮，同时阻止点击事件传播到键盘下方的元素
     */
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: {
            mouse.accepted = false;  // 允许点击事件继续传播到键盘按钮
        }
    }

    /**
     * @brief 键盘布局容器
     * 
     * 使用Column布局垂直排列各行按键
     */
    Column {
        anchors.fill: parent
        anchors.margins: 10       // 边距
        spacing: 8                // 行间距

        /**
         * @brief 第一行：数字键 (1-0) 和小数点
         */
        Row {
            spacing: 6            // 按键间距
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]  // 数字模型
                Button {
                    width: (keyboard.width - 20) / 12     // 按键宽度
                    height: keyboard.height / 6           // 按键高度
                    text: modelData                       // 按键文本
                    font.pixelSize: btnfontsize           // 字体大小
                    font.family: myriadPro.name           // 字体
                    onClicked: keyPressed(text)           // 按下时发送按键信号
                }
            }
            Button {
                width: (keyboard.width - 20) / 12
                height: keyboard.height / 6
                text: "."                                 // 小数点按键
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: keyPressed(text)
            }
        }

        /**
         * @brief 第二行：字母键 (Q-P)
         */
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]  // 第一行字母
                Button {
                    width: (keyboard.width - 20) / 12
                    height: keyboard.height / 6
                    text: isUpperCase ? modelData.toUpperCase() : modelData  // 根据大小写状态显示
                    font.pixelSize: btnfontsize
                    font.family: myriadPro.name
                    enabled: !keyboard.numberOnly                            // 仅数字模式时禁用
                    onClicked: keyPressed(text)
                }
            }
        }

        /**
         * @brief 第三行：字母键 (A-L)
         */
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ["a", "s", "d", "f", "g", "h", "j", "k", "l"]  // 第二行字母
                Button {
                    width: (keyboard.width - 20) / 12
                    height: keyboard.height / 6
                    text: isUpperCase ? modelData.toUpperCase() : modelData
                    font.pixelSize: btnfontsize
                    font.family: myriadPro.name
                    enabled: !keyboard.numberOnly
                    onClicked: keyPressed(text)
                }
            }
        }

        /**
         * @brief 第四行：Shift键、字母键 (Z-M) 和退格键
         */
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Button {  // Shift键 - 切换大小写
                width: (keyboard.width - 20) / 12 * 1.5   // 宽度是普通按键的1.5倍
                height: keyboard.height / 6
                text: "Shift"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: isUpperCase = !isUpperCase     // 切换大小写状态
            }
            Repeater {
                model: ["z", "x", "c", "v", "b", "n", "m"]  // 第三行字母
                Button {
                    width: (keyboard.width - 20) / 12
                    height: keyboard.height / 6
                    text: isUpperCase ? modelData.toUpperCase() : modelData
                    font.pixelSize: btnfontsize
                    font.family: myriadPro.name
                    enabled: !keyboard.numberOnly
                    onClicked: keyPressed(text)
                }
            }
            Button {  // 退格键
                width: (keyboard.width - 20) / 12 * 1.5   // 宽度是普通按键的1.5倍
                height: keyboard.height / 6
                text: "⌫"                                 // 退格符号
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: keyPressed("Backspace")        // 发送"Backspace"信号
            }
        }

        /**
         * @brief 第五行：Tab键、空格键和关闭键
         */
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Button {  // Tab键
                width: (keyboard.width - 20) / 6          // 宽度是普通按键的2倍
                height: keyboard.height / 6
                text: "Tab"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                enabled: !keyboard.numberOnly             // 仅数字模式时禁用
                onClicked: keyPressed("\t")               // 发送制表符信号
            }
            Button {  // 空格键
                width: (keyboard.width - 20) / 2          // 宽度是普通按键的6倍
                height: keyboard.height / 6
                text: "Space"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                enabled: !keyboard.numberOnly
                onClicked: keyPressed(" ")                // 发送空格信号
            }
            Button {  // 关闭键
                width: (keyboard.width - 20) / 6          // 宽度是普通按键的2倍
                height: keyboard.height / 6
                text: "Close"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: keyboard.visible = false       // 隐藏键盘
            }
        }
    }
}