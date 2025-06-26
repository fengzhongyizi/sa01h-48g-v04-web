import QtQuick 2.0
import QtQuick.Controls 2.5
import SerialPort 1.0

Item {
    id: root
    width: 80
    height: 40
    z: 10
    x: 20
    y: 10

    property int batteryLevel: 75
    property int warningThreshold: 15
    property bool isCharging: false
    property alias batteryTimer: batteryTimer
    property alias batteryTimer2: batteryTimer2

    // SerialPortManager instance is now provided from main.cpp via context property
    // SerialPortManager {
    //     id: serialPortManager
    // }

    function getBatteryColor(level) {
        if (level >= 70) {
            return "white";
        } else if (level >= 30) {
            return "yellow";
        } else {
            return "red";
        }
    }

    Timer {
        id: batteryTimer
        interval: 300000 // 300s  检测电量
        running: true
        repeat: true
        onTriggered: {
//            console.log("Current Battery Level: " + batteryLevel + "%");
            serialPortManager.writeDataUart6("AA 01 00 05 00 01 00 98 80",0);
            if (batteryLevel < warningThreshold && !isCharging) {
//                lowBatteryPopup.open();
            }
        }
    }

    Timer {
        id: batteryTimer2
        interval: 300000 // 300s    还有监测电源拔插的功能
        running: true
        repeat: true
        onTriggered: {
//            console.log("Current Battery status: ");
            serialPortManager.writeDataUart6("AA 01 00 05 00 01 00 99 80",0);
            serialPortManager.writeDataUart5("GET NTC 1 VALUE\r\n",1);
            cht8310.readData();
        }
    }

    Popup {
        id: lowBatteryPopup
        width: 200
        height: 100
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "Low Battery!"
                font.pixelSize: 18
                color: "red"
            }

            Button {
                text: "OK"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: lowBatteryPopup.close()
            }
        }
    }

    Rectangle {
        id: batteryIcon
        width: 65
        height: 40
        color: "transparent"
        border.color: "black"
        border.width: 2
        radius: 5

        Rectangle {
            width: 7
            height:12
            color: "white"
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: -8
            }
            radius: 2
        }
        Row {
           anchors {
               left: parent.left
               leftMargin: 2
               top: parent.top
               topMargin: 2
               bottom: parent.bottom
               bottomMargin: 2
           }
           spacing: 0

           Repeater {
               model: 5
               delegate: Rectangle {
                   width: 0.2 * (batteryIcon.width - 5)
                   height: parent.height
                   color: {
                       var levelPerSegment = 20;
                       var currentSegment = index + 1;
                       if (batteryLevel >= currentSegment * levelPerSegment) {
                           return "white";
                       } else if (batteryLevel > (currentSegment - 1) * levelPerSegment) {
                           var fillRatio = (batteryLevel - (currentSegment - 1) * levelPerSegment) / levelPerSegment;
                           return getBatteryColor(fillRatio*100);
                       } else {
                           return "transparent";
                       }
                   }
                   radius: 2
                   border.color: "gray"
                   border.width: 1
               }
           }
       }




//        Rectangle {
//            id: batteryFill
//            width: (batteryLevel / 100) * (batteryIcon.width - 4)
//            height: parent.height - 4
//            color: getBatteryColor(batteryLevel)
//            anchors {
//                left: parent.left
//                leftMargin: 2
//                top: parent.top
//                topMargin: 2
//            }
//            radius: 3

//        }

//        Text {
//            text: batteryLevel + "%"
//            font.pixelSize: 25
//            color: "white"
//            anchors.centerIn: parent
//        }

    }

    Canvas {
        id: chargingIcon
        anchors.left: batteryIcon.right
        anchors.leftMargin: 8
        width: 30
        height: 40
        visible: isCharging

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.fillStyle = "white";

            ctx.strokeStyle = "#FFD700";
            ctx.lineWidth = 1;
            ctx.lineJoin = "miter";

            ctx.beginPath();
            ctx.moveTo(width * 0.5, height * 0.05);
            ctx.lineTo(width * 0.1, height * 0.5);
            ctx.lineTo(width * 0.35, height * 0.5);
            ctx.lineTo(width * 0.2, height * 0.9);
            ctx.lineTo(width * 0.65, height * 0.4);
            ctx.lineTo(width * 0.35, height * 0.4);
            ctx.lineTo(width * 0.5, height * 0.05);
            ctx.fill();
//            ctx.stroke();
        }
    }


}
