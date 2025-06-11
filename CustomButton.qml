import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    width: 300
    height: 120
    radius: 8
    border.width: 2
    border.color: "#333333"


    gradient: Gradient {
        GradientStop { position: 0; color: mouseArea.pressed ? "#e0e0e0" : "#4a4a4a" }
        GradientStop { position: 1; color: mouseArea.pressed ? "#d0d0d0" : "#3a3a3a" }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        radius: 4
        samples: 8
        color: "#40000000"
    }

    Text {
//        text: "Button"
        anchors.centerIn: parent
        font {
            family: "Arial"
            pixelSize: 35
            bold: true
        }
        color: mouseArea.pressed ? "#333333" : "white"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
//            parent.border.color = "#666666";
//            parent.opacity = 0.9;
        }
        onExited: {
//            parent.border.color = "#333333";
//            parent.opacity = 1;
        }
    }
}
