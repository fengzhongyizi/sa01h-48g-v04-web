import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle {
    id: keyboard
    width: 600
    height: 800
    color: "black"
    z: 50
    visible: false

    property int btnfontsize: 35
    property bool isUpperCase: false
    property bool numberOnly: true

    signal keyPressed(string key)

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: {
            mouse.accepted = false;
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // 0~9
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
                Button {
                    width: (keyboard.width - 20) / 12
                    height: keyboard.height / 6
                    text: modelData
                    font.pixelSize: btnfontsize
                    font.family: myriadPro.name
                    onClicked: keyPressed(text)
                }
            }
            Button {
                width: (keyboard.width - 20) / 12
                height: keyboard.height / 6
                text: "."
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: keyPressed(text)
            }
        }

        // Q-P
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
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

        //A-L
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
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

        // Z-M
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Button {  // Shift
                width: (keyboard.width - 20) / 12 * 1.5
                height: keyboard.height / 6
                text: "Shift"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: isUpperCase = !isUpperCase
            }
            Repeater {
                model: ["z", "x", "c", "v", "b", "n", "m"]
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
            Button {  // Backspace
                width: (keyboard.width - 20) / 12 * 1.5
                height: keyboard.height / 6
                text: "⌫"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: keyPressed("Backspace")
            }
        }

        //
        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Button {  // Tab
                width: (keyboard.width - 20) / 6
                height: keyboard.height / 6
                text: "Tab"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                enabled: !keyboard.numberOnly
                onClicked: keyPressed("\t")
            }
            Button {  // Space
                width: (keyboard.width - 20) / 2
                height: keyboard.height / 6
                text: "Space"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                enabled: !keyboard.numberOnly
                onClicked: keyPressed(" ")
            }
            Button {  // Close
                width: (keyboard.width - 20) / 6
                height: keyboard.height / 6
                text: "Close"
                font.pixelSize: btnfontsize
                font.family: myriadPro.name
                onClicked: keyboard.visible = false
            }
        }
    }
}
