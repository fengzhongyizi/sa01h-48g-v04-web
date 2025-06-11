import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Rectangle {
    id:root
    anchors.fill: parent
    property int pageindex: 0
    property int pageflag: 0
    property int btnWidth: 250
    property int btnHeight: 100

    Rectangle{
        id:back
        visible: pageflag == 0?false:true
        width:150
        height:80
        border.color: "black"
        border.width: 2
        color: flag?'gray':'black'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        property bool flag:false
        Text {
            text: qsTr("Back")
            anchors.centerIn: parent
            font.family: myriadPro.name
            font.pixelSize: 25
            color: "white"
        }
        MouseArea{
            anchors.fill: parent
            onPressed: {
                back.flag = true
            }
            onReleased: {
                back.flag = false
                if(pageindex == 1){
                    pageflag = 0
                    pageindex = 0
                }else if(pageindex == 2){
                    pageindex = 1
                }
            }
        }
    }

    //page
    Column{
        visible: pageflag == 0?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing:100
        width: root.width
        RowLayout {
            width: parent.width

            Rectangle{
                id:source_speaker_test
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("SOURCE-SPEAKER TEST")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        source_speaker_test.flag = true
                    }
                    onReleased: {
                        source_speaker_test.flag = false
                        pageflag = 1
                        pageindex = 1
                    }
                }
            }
            Rectangle{
                id:sync_latency_test
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("SYNC&LATENCY TEST")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        sync_latency_test.flag = true
                    }
                    onReleased: {
                        sync_latency_test.flag = false
                        pageflag = 2
                        pageindex = 1
                    }
                }
            }
        }
    }

    //source-speaker test
    property int source_speaker_flag: 1
    Column{
        id:source_speaker_rect
        visible: pageindex == 1&&pageflag ==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing:100
        width: root.width

        RowLayout {
            width: parent.width

            Rectangle{
                id:speaker_allocation
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("SPEAKER ALLOCATION")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        speaker_allocation.flag = true
                    }
                    onReleased: {
                        speaker_allocation.flag = false
                        source_speaker_flag = 1
                    }
                }
            }
            Rectangle{
                id:white_noise
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("WHITE NOISE")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        white_noise.flag = true
                    }
                    onReleased: {
                        white_noise.flag = false
                        source_speaker_flag = 2
                    }
                }
            }
            Rectangle{
                id:sweep_audio
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("SWEEP AUDIO")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        sweep_audio.flag = true
                    }
                    onReleased: {
                        sweep_audio.flag = false
                        source_speaker_flag = 3
                    }
                }
            }
        }
    }
    property int btnW: 120
    property int btnH: 80
    Column{
        visible:pageindex == 1&&pageflag ==1&&source_speaker_flag !=1?true:false
        anchors.top: source_speaker_rect.bottom
        anchors.topMargin: 70
        spacing:100
        width: root.width

        RowLayout {
            width: parent.width
            Rectangle{
                width:700
                height: 540
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: "transparent"
                Image {
                    id:img
                    width: parent.width
                    height: parent.height
                    source: "icons/bg.png"
                }
                //fl
                Rectangle{
                    id:fl_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.left: img.left
                    anchors.leftMargin: -fl_rect.width/2
                    anchors.top: img.top
                    anchors.topMargin: -fl_rect.height/2

                    property bool flag:false
                    Text {
                        id:fl_title
                        text: qsTr("FL")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH0)")
                        anchors.top: fl_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            fl_rect.flag = !fl_rect.flag
                        }
                    }
                }
                //fc
                Rectangle{
                    id:fc_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.left: img.left
                    anchors.leftMargin: -fc_rect.width/2+350
                    anchors.top: img.top
                    anchors.topMargin: -fc_rect.height/2

                    property bool flag:false
                    Text {
                        id:fc_title
                        text: qsTr("FC")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH3)")
                        anchors.top: fc_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            fc_rect.flag = !fc_rect.flag
                        }
                    }
                }
                //fr
                Rectangle{
                    id:fr_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.right: img.right
                    anchors.rightMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2

                    property bool flag:false
                    Text {
                        id:fr_title
                        text: qsTr("FR")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH1)")
                        anchors.top: fr_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            fr_rect.flag = !fr_rect.flag
                        }
                    }
                }

                //sl
                Rectangle{
                    id:sl_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.left: img.left
                    anchors.leftMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+270

                    property bool flag:false
                    Text {
                        id:sl_title
                        text: qsTr("SL")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH4)")
                        anchors.top: sl_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            sl_rect.flag = !sl_rect.flag
                        }
                    }
                }
                //sr
                Rectangle{
                    id:sr_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.right: img.right
                    anchors.rightMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+270

                    property bool flag:false
                    Text {
                        id:sr_title
                        text: qsTr("SR")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH5)")
                        anchors.top: sr_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            sr_rect.flag = !sr_rect.flag
                        }
                    }
                }

                //bl
                Rectangle{
                    id:bl_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.left: img.left
                    anchors.leftMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+540

                    property bool flag:false
                    Text {
                        id:bl_title
                        text: qsTr("BL")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH6)")
                        anchors.top: bl_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            bl_rect.flag = !bl_rect.flag
                        }
                    }
                }
                //br
                Rectangle{
                    id:br_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.right: img.right
                    anchors.rightMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+540

                    property bool flag:false
                    Text {
                        id:br_title
                        text: qsTr("BR")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH7)")
                        anchors.top: br_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            br_rect.flag = !br_rect.flag
                        }
                    }
                }

                //lfe
                Rectangle{
                    id:lfe_rect
                    width:btnW
                    height:btnH
                    color: "black"
                    border.width: 4
                    border.color: flag?'orange':'black'
                    anchors.left: br_rect.right
                    anchors.leftMargin: 100
                    anchors.top: br_rect.top

                    property bool flag:false
                    Text {
                        id:lfe_title
                        text: qsTr("LFE")
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH2)")
                        anchors.top: lfe_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            lfe_rect.flag = !lfe_rect.flag
                        }
                    }
                }

            }
        }
    }
}
