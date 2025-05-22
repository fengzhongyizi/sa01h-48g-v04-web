import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
Rectangle {
    id:root
    anchors.fill: parent
    signal confirmsignal(string str,int num)
    property int videoTestSelect: 1

    GridLayout{
        anchors.top: parent.top
        anchors.topMargin: 100
        width: parent.width
        rowSpacing: 50
        columns: 4
        ListModel {
            id: video_test_model
            ListElement { first: "Spicey Pixels";second:"Chongqing Day"; number: 0x0194 }
            ListElement { first: "Spicey Pixels";second:"Chongqing Night"; number: 0x0195 }
            ListElement { first: "Spicey Pixels";second:"Chongqing Lights"; number: 0x0196 }
            ListElement { first: "Spicey Pixels";second:"Chongqing Cars"; number: 0x0197 }
            ListElement { first: "Spicey Pixels";second:"Chongqing Cars2"; number: 0x0198 }
            ListElement { first: "Spicey Pixels";second:"London Yogurt"; number: 0x019B }
            ListElement { first: "Spicey Pixels";second:"London River"; number: 0x019C }
            ListElement { first: "Spicey Pixels";second:"London Sidewalk"; number: 0x019D }
            ListElement { first: "Spicey Pixels";second:"London Busses"; number: 0x019E }
            ListElement { first: "Spicey Pixels";second:"London Cafe"; number: 0x019F }
            ListElement { first: "Spicey Pixels";second:"Mukilteo Street"; number: 0x01A0 }
            ListElement { first: "Spicey Pixels";second:"Mukilteo Loading"; number: 0x01A1 }
            ListElement { first: "Spicey Pixels";second:"Carnival Wheel"; number: 0x01A2 }
            ListElement { first: "Spicey Pixels";second:"Carnival Ride"; number: 0x01A3 }
            ListElement { first: "Spicey Pixels";second:"Carnival Night"; number: 0x01A4 }
            ListElement { first: "Spicey Pixels";second:"Carnival Baloon Pop"; number: 0x01A5 }
            ListElement { first: "Spicey Pixels";second:"Tiger Mountain 120"; number: 0x01A6 }
            ListElement { first: "Spicey Pixels";second:"Biker 120"; number: 0x01A7 }
            ListElement { first: "SPE";second:"Test Video"; number: 0x01A8 }
            ListElement { first: "User";second:"Video Clip 1"; number: 0x0199 }
            ListElement { first: "User";second:"Video Clip 2"; number: 0x019A }
            ListElement { first: "Automation";second:"Testing Clip"; number: 0x01D7 }
        }
        Repeater{
            model: video_test_model
            Rectangle{
                width:200
                height:80
                border.color: videoTestSelect==number?"orange":"black"
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        videoTestSelect=number
                        confirmsignal("VideoTest",number)
                    }
                }
            }
        }

    }
}
