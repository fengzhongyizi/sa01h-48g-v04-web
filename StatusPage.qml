import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Item {
    id:root
    anchors.fill: parent
    property int lineheight: 38
    property int fontsize: 34
    property alias modeText: mode_text.text
    property alias hpdText: hpd_text.text
    property alias hdmiText: hdmi_text.text
    property alias btText: bt_text.text
    property alias hdcpText: hdcp_text.text
    property alias colordepthText: colordepth_text.text
    property alias colorText: color_text.text
    property alias timingText: timing_text.text
    property alias typeText: type_text.text
    property alias samplerateText: samplerate_text.text
    property alias audiobitText: audiobit_text.text
    property alias sinewaretoneText: sinewaretone_text.text
    property alias audiovolumeText: audiovolume_text.text
    property alias channelsText: channels_text.text


    Label{
        id:status_title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 55
        text: "Video Output"
        font.family: myriadPro.name
        font.pixelSize: 35
        color: "white"
    }
    //line
    Rectangle{
        id:line1
        height: 4
        width: parent.width
        border.width: 2
        border.color: "white"
        anchors.top: status_title.bottom
        anchors.topMargin: 5
    }

//    Label{
//        id:video_title
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: 5
//        text: "Video Output"
//        font.family: myriadPro.name
//        font.pixelSize: 35
//        color: "white"
//    }
    //video output
//    Rectangle{
//        id:video_rect
//        color: "gray"
//        height: 550
//        width: parent.width-4
//        border.width: 1
//        border.color: "white"
//        radius: 5
//        anchors.top: video_title.bottom
//        anchors.topMargin: 0
//        anchors.left: root.left
//        anchors.leftMargin: 2

        //mode
        Label{
            id:model_label
            anchors.top: line1.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 20
            text: "Mode:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:mode_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: model_label.bottom
            anchors.left: model_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: mode_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //hpd
        Label{
            id:hpd_label
            anchors.top: mode_rect.bottom
            anchors.topMargin: 0
            anchors.left: model_label.left
            text: "Hpd:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:hpd_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: hpd_label.bottom
            anchors.left: hpd_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: hpd_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //HDMI/DVI
        Label{
            id:hdmi_label
            anchors.top: hpd_rect.bottom
            anchors.topMargin: 0
            anchors.left: hpd_label.left
            text: "HDMI/DVI:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:hdmi_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: hdmi_label.bottom
            anchors.left: hdmi_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: hdmi_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //bt 2020
        Label{
            id:bt_label
            anchors.top: hdmi_rect.bottom
            anchors.topMargin: 0
            anchors.left: hdmi_label.left
            text: "BT 2020:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:bt_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: bt_label.bottom
            anchors.left: bt_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: bt_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //hdcp
        Label{
            id:hdcp_label
            anchors.top: bt_rect.bottom
            anchors.topMargin: 0
            anchors.left: bt_label.left
            text: "HDCP:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:hdcp_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: hdcp_label.bottom
            anchors.left: hdcp_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: hdcp_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //colordepth
        Label{
            id:colordepth_label
            anchors.top: hdcp_rect.bottom
            anchors.topMargin: 0
            anchors.left: hdcp_label.left
            text: "ColorDepth:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:colordepth_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: colordepth_label.bottom
            anchors.left: colordepth_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: colordepth_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //color
        Label{
            id:color_label
            anchors.top: colordepth_rect.bottom
            anchors.topMargin: 0
            anchors.left: colordepth_label.left
            text: "Color:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:color_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: color_label.bottom
            anchors.left: color_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: color_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //Timing
        Label{
            id:timing_label
            anchors.top: color_rect.bottom
            anchors.topMargin: 0
            anchors.left: color_label.left
            text: "Timing:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:timing_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: timing_label.bottom
            anchors.left: timing_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: timing_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
    //}

    Label{
        id:audio_title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: timing_rect.bottom
        anchors.topMargin: 5
        text: "Audio Output"
        font.family: myriadPro.name
        font.pixelSize: 35
        color: "white"
    }
    //line
    Rectangle{
        id:line2
        height: 4
        width: parent.width
        border.width: 2
        border.color: "white"
        anchors.top: audio_title.bottom
        anchors.topMargin: 5
    }
    //audio output
//    Rectangle{
//        id:audio_rect
//        color: "gray"
//        height: 550
//        width: parent.width-4
//        border.width: 1
//        border.color: "white"
//        radius: 5
//        anchors.top: audio_title.bottom
//        anchors.topMargin: 0
//        anchors.left: root.left
//        anchors.leftMargin: 2

        //Audio Type
        Label{
            id:type_label
            anchors.top: line2.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 20
            text: "Audio Type:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:type_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: type_label.bottom
            anchors.left: type_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: type_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //SampleRate
        Label{
            id:samplerate_label
            anchors.top: type_rect.bottom
            anchors.topMargin: 0
            anchors.left: type_label.left
            text: "SampleRate:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:samplerate_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: samplerate_label.bottom
            anchors.left: samplerate_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: samplerate_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //Audio Bit
        Label{
            id:audiobit_label
            anchors.top: samplerate_rect.bottom
            anchors.topMargin: 0
            anchors.left: samplerate_label.left
            text: "Audio Bit:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:audiobit_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: audiobit_label.bottom
            anchors.left: audiobit_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: audiobit_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //SinewareTone
        Label{
            id:sinewaretone_label
            anchors.top: audiobit_rect.bottom
            anchors.topMargin: 0
            anchors.left: audiobit_label.left
            text: "SinewareTone:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:sinewaretone_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: sinewaretone_label.bottom
            anchors.left: sinewaretone_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: sinewaretone_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //Audio Volume
        Label{
            id:audiovolume_label
            anchors.top: sinewaretone_rect.bottom
            anchors.topMargin: 0
            anchors.left: sinewaretone_label.left
            text: "Audio Volume:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:audiovolume_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: audiovolume_label.bottom
            anchors.left: audiovolume_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: audiovolume_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
        //Channels
        Label{
            id:channels_label
            anchors.top: audiovolume_rect.bottom
            anchors.topMargin: 0
            anchors.left: audiovolume_label.left
            text: "Channels:"
            font.family: myriadPro.name
            font.pixelSize: fontsize
            color: "white"
        }
        Rectangle{
            id:channels_rect
            color: "white"
            width: 150
            height: lineheight
            anchors.top: channels_label.bottom
            anchors.left: channels_label.left
            anchors.right: parent.right
            anchors.rightMargin: 10

            Text {
                id: channels_text
                width: parent.width
                height: parent.height
                font.family: myriadPro.name
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontsize
            }
        }
    //}
}
