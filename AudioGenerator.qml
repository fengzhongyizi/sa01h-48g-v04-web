import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Rectangle {
    id:root
    anchors.fill: parent
    signal confirmsignal(string str,int num)
    property int pageindex: 0
    property int pageflag: 0
    property int btnWidth: 300
    property int btnHeight: 120
    property int btnfontsize: 35

    property alias pcm_channel_model: pcm_channel_model
    property alias pcm_sinewave_tone_model: pcm_sinewave_tone_model
    property alias pcm_sampling_rate_model: pcm_sampling_rate_model
    property alias pcm_bit_depth_model: pcm_bit_depth_model
    property alias pcm_volume_model: pcm_volume_model
    property alias pcmsinewaveModel: pcm_sinewave_tone_model

    property alias dolby_digital_model: dolby_digital_model
    property alias dolby_digital_plus_model: dolby_digital_plus_model
    property alias dolby_mat_model: dolby_mat_model
    property alias dolby_mat_trueHD_model: dolby_mat_trueHD_model
    property alias dolby_my_streams_model: dolby_my_streams_model
    property alias dobly_arm_30_model: dobly_arm_30_model
    property alias dobly_arm_29_model: dobly_arm_29_model
    property alias dobly_arm_25_model: dobly_arm_25_model
    property alias dobly_arm_24_model: dobly_arm_24_model
    property alias dobly_arm_23_model: dobly_arm_23_model





    CustomButton{
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
            font.pixelSize: btnfontsize
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

    property int audioTypeFlag: 1
    property int audioSelectFlag: 1
    //page
    Column{
        visible: pageflag == 0?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing:100
        width: root.width
        RowLayout {
            width: parent.width

            CustomButton{
                id:pcm
                width:btnWidth
                height:btnHeight
                border.color: audioTypeFlag === 1?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("PCM AUDIO")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm.flag = true
                        audioTypeFlag === 1
                    }
                    onReleased: {
                        pcm.flag = false
                        pageflag = 1
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:dobly
                width:btnWidth
                height:btnHeight
                border.color: audioTypeFlag === 2?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DOLBY AUDIO GENERATOR")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly.flag = true
                        audioTypeFlag === 2
                    }
                    onReleased: {
                        dobly.flag = false
                        pageflag = 2
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:ext
                width:btnWidth
                height:btnHeight
                border.color: audioTypeFlag === 3?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("EXT.ANALOG L/R INPUT")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        ext.flag = true
                        audioTypeFlag === 3
                    }
                    onReleased: {
                        ext.flag = false
                        pageflag = 3
                        pageindex = 1
                    }
                }
            }
        }
        RowLayout {
            width: parent.width
            CustomButton{
                id:dts
                width:btnWidth
                height:btnHeight
                border.color: audioTypeFlag === 4?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DTS AUDIO GENERATOR")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts.flag = true
                        audioTypeFlag === 4
                    }
                    onReleased: {
                        dts.flag = false
                        pageflag = 4
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:empty1
                width:btnWidth
                height:btnHeight
                opacity:0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            CustomButton{
                id:empty2
                width:btnWidth
                height:btnHeight
                opacity:0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
    }

    //pcm
    property int pcmFlag: 1
    property int pcm_select_width: 300
    property int pcm_select_height: 120
    Column{
        visible: pageindex == 1&&pageflag ==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing:100
        width: root.width
        RowLayout {
            width: parent.width

            CustomButton{
                id:pcm_sampling_rate
                width:btnWidth
                height:btnHeight
                border.color: audioSelectFlag === 1?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Audio Sampling Rate")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_sampling_rate.flag = true
                    }
                    onReleased: {
                        pcm_sampling_rate.flag = false
                        pageindex = 2
                        pcmFlag = 1
                    }
                }
            }
            CustomButton{
                id:pcm_bit_depth
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Audio Bit Depth")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_bit_depth.flag = true
                    }
                    onReleased: {
                        pcm_bit_depth.flag = false
                        pageindex = 2
                        pcmFlag = 2
                    }
                }
            }
            CustomButton{
                id:pcm_sinewave_tone
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Sinewave Tone")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_sinewave_tone.flag = true
                    }
                    onReleased: {
                        pcm_sinewave_tone.flag = false
                        pageindex = 2
                        pcmFlag = 3
                    }
                }
            }
        }
        RowLayout {
            width: parent.width

            CustomButton{
                id:pcm_volume
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Audio Volume")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_volume.flag = true
                    }
                    onReleased: {
                        pcm_volume.flag = false
                        pageindex = 2
                        pcmFlag = 4
                    }
                }
            }
            CustomButton{
                id:pcm_channel
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Audio Channel Config")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_channel.flag = true
                    }
                    onReleased: {
                        pcm_channel.flag = false
                        pageindex = 2
                        pcmFlag = 5
                    }
                }
            }
            CustomButton{
                id:empty3
                width:btnWidth
                height:btnHeight
                opacity:0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
    }
    //pcm-sampling-rate
    property int pcm_sampling_rate_select: 1
    GridLayout{
        visible: pageflag==1&&pageindex == 2&&pcmFlag ==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:150
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pcm_sampling_rate_model
            ListElement { first: "32K"; number: 0x00 }
            ListElement { first: "44.1K"; number: 0x01 }
            ListElement { first: "48K"; number: 0x02 }
            ListElement { first: "88K"; number: 0x03 }
            ListElement { first: "96K"; number: 0x04 }
            ListElement { first: "176K"; number: 0x05 }
            ListElement { first: "192K"; number: 0x06 }
        }
        Repeater{
            model: pcm_sampling_rate_model
            CustomButton{
                width:pcm_select_width
                height:pcm_select_height
                border.color: pcm_sampling_rate_select==number?"orange":"black"
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pcm_sampling_rate_select=number
                        confirmsignal("AudioSamplingRate",number)
                    }
                }
            }
        }

    }
    //pcm-bit-depth
    property int pcm_bit_depth_select: 1
    GridLayout{
        visible: pageflag==1&&pageindex == 2&&pcmFlag ==2?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:150
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pcm_bit_depth_model
            ListElement { first: "16Bit"; number: 0x00 }
            ListElement { first: "20Bit"; number: 0x01 }
            ListElement { first: "24Bit"; number: 0x02 }
        }
        Repeater{
            model: pcm_bit_depth_model
            CustomButton{
                width:pcm_select_width
                height:pcm_select_height
                border.color: pcm_bit_depth_select==number?"orange":"black"
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pcm_bit_depth_select=number
                        confirmsignal("AudioBitDepth",number)
                    }
                }
            }
        }

    }
    //pcm-sinewave-tone
    property int pcm_sinewave_tone_select: 1
    GridLayout{
        visible: pageflag==1&&pageindex == 2&&pcmFlag ==3?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:150
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pcm_sinewave_tone_model
            ListElement { first: "SINEWAVE TONE(100Hz)"; second: "100Hz"; number: 0x00 }
            ListElement { first: "SINEWAVE TONE(200Hz)"; second: "200Hz"; number: 0x01 }
            ListElement { first: "SINEWAVE TONE(300Hz)"; second: "300Hz";number: 0x02 }
            ListElement { first: "SINEWAVE TONE(400Hz)"; second: "400Hz";number: 0x03 }
            ListElement { first: "SINEWAVE TONE(500Hz)"; second: "500Hz";number: 0x04 }
            ListElement { first: "SINEWAVE TONE(600Hz)"; second: "600Hz";number: 0x05 }
            ListElement { first: "SINEWAVE TONE(700Hz)"; second: "700Hz";number: 0x06 }
            ListElement { first: "SINEWAVE TONE(800Hz)"; second: "800Hz";number: 0x07 }
            ListElement { first: "SINEWAVE TONE(900Hz)"; second: "900Hz";number: 0x08 }
            ListElement { first: "SINEWAVE TONE(1KHz)"; second: "1KHz";number: 0x09 }
            ListElement { first: "SINEWAVE TONE(2KHz)"; second: "2KHz";number: 0x0a }
            ListElement { first: "SINEWAVE TONE(3KHz)"; second: "3KHz";number: 0x0b }
            ListElement { first: "SINEWAVE TONE(4KHz)"; second: "4KHz";number: 0x0c }
            ListElement { first: "SINEWAVE TONE(5KHz)"; second: "5KHz";number: 0x0d }
        }
        Repeater{
            model: pcm_sinewave_tone_model
            CustomButton{
                width:pcm_select_width
                height:pcm_select_height
                border.color: pcm_sinewave_tone_select==number?"orange":"black"
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pcm_sinewave_tone_select=number
                        confirmsignal("SinewaveTone",number)
                    }
                }
            }
        }

    }

    //pcm-volume
    property int pcm_volume_value: 5
    GridLayout{
        visible: pageflag==1&&pageindex == 2&&pcmFlag ==4?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:150
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pcm_volume_model
            ListElement { first: "-60dB"; number: 0x00 }
            ListElement { first: "-54dB"; number: 0x01 }
            ListElement { first: "-48dB"; number: 0x02 }
            ListElement { first: "-42dB"; number: 0x03 }
            ListElement { first: "-36dB"; number: 0x04 }
            ListElement { first: "-30dB"; number: 0x05 }
            ListElement { first: "-24dB"; number: 0x06 }
            ListElement { first: "-18dB"; number: 0x07 }
            ListElement { first: "-12dB"; number: 0x08 }
            ListElement { first: "-6dB"; number: 0x09 }
            ListElement { first: "0dB"; number: 0x0a }
        }
        Repeater{
            model: pcm_volume_model
            CustomButton{
                width:pcm_select_width
                height:pcm_select_height
                border.color: pcm_volume_value==number?"orange":"black"
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pcm_volume_value=number
                        confirmsignal("AudioVolume",number)
                    }
                }
            }
        }

    }
//    RowLayout {
//        visible: pageflag==1&&pageindex == 2&&pcmFlag ==4?true:false
//        width: parent.width
//        Rectangle{
//            width: root.width
//            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

//            Column{
//                anchors.top: parent.top
//                anchors.topMargin: 400
//                spacing:100
//                width: root.width
//                Slider {
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    width: parent.width-200
//                    snapMode:Slider.SnapAlways
//                    stepSize:6
//                    from: -60
//                    value: pcm_volume_value
//                    to: 0
//                    onValueChanged:{
//                        pcm_volume_value = value

//                        confirmsignal("AudioVolume",Math.abs(value))
//                    }
//                }
//                Label{
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    text: pcm_volume_value+"dB"
//                    font.family: myriadPro.name
//                    font.pixelSize: 35
//                }
//            }
//        }
//    }
    //pcm-channel
    property int pcm_channel_select: 0
    RowLayout {
        visible: pageflag==1&&pageindex == 2&&pcmFlag ==5?true:false
        width: parent.width
        anchors.top: root.top
        anchors.topMargin: 150

        Rectangle{
            visible: pageflag==1&&pageindex == 2&&pcmFlag ==5?true:false
            width: root.width-20
            height: 800
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: "transparent"

            ScrollView{
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                GridLayout{
                    width: parent.width
                    columnSpacing:140
                    rowSpacing: 50
                    columns: 3
                    ListModel {
                        id: pcm_channel_model
                        ListElement { first:"2CH (FR_FL)";second: "2CH"; number:0x00 }
                        ListElement { first:"2.1CH (LFE_FR_FL)"; second: "2.1CH"; number: 0x01 }
                        ListElement { first:"3CH (FC_FR_FL)"; second: "3CH";number: 0x02 }
                        ListElement { first:"3.1CH (FC_LFE_FR_FL)"; second: "3.1CH";number: 0x03 }
                        ListElement { first:"3CH (RC_FR_FL)";second: "3CH"; number: 0x04 }
                        ListElement { first:"3.1CH (RC_LFE_FR_FL)";second: "3.1CH"; number: 0x05 }
                        ListElement { first:"4CH (RC_LFE_FR_FL)"; second: "4CH";number: 0x06 }
                        ListElement { first:"4.1CH (RC_FC_LFE_FR_FL)";second: "4.1CH"; number: 0x07 }
                        ListElement { first:"4CH (RR_RL_FR_FL)"; second: "4CH";number: 0x08 }
                        ListElement { first:"4.1CH (RR_RL_LFE_FR_FL)";second: "4.1CH"; number: 0x09 }
                        ListElement { first:"5CH (RR_RL_FC_FR_FL)"; second: "5CH";number: 0x0a }
                        ListElement { first:"5.1CH (RR_RL_FC_LFE_FR_FL)"; second: "5.1CH";number: 0x0b }
                        ListElement { first:"5CH (RC_RR_RL_FR_FL)"; second: "5CH";number: 0x0c }
                        ListElement { first:"5.1CH (RC_RR_RL_LFE_FR_FL)"; second: "5.1CH";number: 0x0d }
                        ListElement { first:"6CH (RC_RR_RL_FC_FR_FL)"; second: "6CH";number: 0x0e }
                        ListElement { first:"6.1CH (RC_RR_RL_FC_LFE_FR_FL)"; second: "6.1CH";number: 0x0f }
                        ListElement { first:"6CH (RRC_RLC_RR_RL_FR_FL)"; second: "6CH";number: 0x10 }
                        ListElement { first:"6.1CH (RRC_RLC_RR_RL_LFE_FR_FL)"; second: "6.1CH";number: 0x11 }
                        ListElement { first:"7CH (RRC_RLC_RR_RL_FC_FR_FL)"; second: "7CH";number: 0x12 }
                        ListElement { first:"7.1CH (RRC_RLC_RR_RL_FC_LFE_FR_FL)"; second: "7.1CH";number: 0x13 }
                        ListElement { first:"4CH (FRC_FLC_FR_FL)"; second: "4CH";number: 0x14 }
                        ListElement { first:"4.1CH (FRC_FLC_LFE_FR_FL)"; second: "4.1CH";number: 0x15 }
                        ListElement { first:"5CH (FRC_FLC_FC_FR_FL)"; second: "5CH";number: 0x16 }
                        ListElement { first:"5.1CH (FRC_FLC_FC_LFE_FR_FL)"; second: "5.1CH";number: 0x17 }
                        ListElement { first:"5CH (FRC_FLC_RC_FR_FL)"; second: "5CH";number: 0x18 }
                        ListElement { first:"5.1CH (FRC_FLC_RC_FC_FR_FL)"; second: "5.1CH";number: 0x19 }
                        ListElement { first:"6CH (FRC_FLC_RC_FC_FR_FL)"; second: "6CH";number: 0x1a }
                        ListElement { first:"6.1CH (FRC_FLC_RC_FC_LFE_FR_FL)"; second: "6.1CH";number: 0x1b }
                        ListElement { first:"6CH (FRC_FLC_RR_RL_FR_FL)"; second: "6CH";number: 0x1c }
                        ListElement { first:"6.1CH (FRC_FLC_RR_RL_LFE_FR_FL)"; second: "6.1CH";number: 0x1d }
                        ListElement { first:"7CH (FRC_FLC_RR_RL_FC_FR_FL)"; second: "7CH";number: 0x1e }
                        ListElement { first:"7.1CH (FRC_FLC_RR_RL_FC_LFE_FR_FL)";second: "7.1CH"; number: 0x1f }

                    }
                    Repeater{
                        model: pcm_channel_model
                        CustomButton{
                            width:pcm_select_width+160
                            height:pcm_select_height
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            border.color: pcm_channel_select==number?"orange":"black"
                            border.width: 4
                            color: 'black'
                            Column{
                                anchors.centerIn: parent
                                Text {
                                    text: first
                                    font.family: myriadPro.name
                                    font.pixelSize: btnfontsize
                                    color: "white"
                                    anchors.horizontalCenter : parent.horizontalCenter
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    pcm_channel_select=number
                                    confirmsignal("AudioChannelConfig",number)
                                }
                            }
                        }
                    }

                }
            }
        }
    }


    //dobly
    property int dolbyFlag: 1
    property int dolby_select: 1
    property int dolby_select_width: 300
    property int dolby_select_height: 120
    Column{
        visible: pageindex == 1&&pageflag ==2?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing:100
        width: root.width
        RowLayout {
            width: parent.width

            CustomButton{
                id:dolby_digital
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DOLBY Digital")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_digital.flag = true
                    }
                    onReleased: {
                        dolby_digital.flag = false
                        pageindex = 2
                        dolbyFlag = 1
                    }
                }
            }
            CustomButton{
                id:dolby_digital_plus
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DOLBY Digital Plus")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_digital_plus.flag = true
                    }
                    onReleased: {
                        dolby_digital_plus.flag = false
                        pageindex = 2
                        dolbyFlag = 2
                    }
                }
            }
            CustomButton{
                id:dolby_mat
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DOLBY MAT")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_mat.flag = true
                    }
                    onReleased: {
                        dolby_mat.flag = false
                        pageindex = 2
                        dolbyFlag = 3
                    }
                }
            }
        }
        RowLayout {
            width: parent.width

            CustomButton{
                id:dolby_mat_trueHD
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DOLBY MAT(DOLBY TrueHD)")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_mat_trueHD.flag = true
                    }
                    onReleased: {
                        dolby_mat_trueHD.flag = false
                        pageindex = 2
                        dolbyFlag = 4
                    }
                }
            }
            CustomButton{
                id:dobly_my_streams
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("MY Streams")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_my_streams.flag = true
                    }
                    onReleased: {
                        dobly_my_streams.flag = false
                        pageindex = 2
                        dolbyFlag = 5
                    }
                }
            }
            CustomButton{
                id:dobly_arm_30
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("ARM 30HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_30.flag = true
                    }
                    onReleased: {
                        dobly_arm_30.flag = false
                        pageindex = 2
                        dolbyFlag = 6
                    }
                }
            }
        }
        RowLayout {
            width: parent.width

            CustomButton{
                id:dobly_arm_29
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("ARM 29HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_29.flag = true
                    }
                    onReleased: {
                        dobly_arm_29.flag = false
                        pageindex = 2
                        dolbyFlag = 7
                    }
                }
            }
            CustomButton{
                id:dobly_arm_25
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("ARM 25HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_25.flag = true
                    }
                    onReleased: {
                        dobly_arm_25.flag = false
                        pageindex = 2
                        dolbyFlag = 8
                    }
                }
            }
            CustomButton{
                id:dobly_arm_24
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("ARM 24HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_24.flag = true
                    }
                    onReleased: {
                        dobly_arm_24.flag = false
                        pageindex = 2
                        dolbyFlag = 9
                    }
                }
            }
        }
        RowLayout {
            width: parent.width

            CustomButton{
                id:dobly_arm_23
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("ARM 23HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_23.flag = true
                    }
                    onReleased: {
                        dobly_arm_23.flag = false
                        pageindex = 2
                        dolbyFlag = 10
                    }
                }
            }
            CustomButton{
                id:dobly_empty1
                width:btnWidth
                height:btnHeight
                opacity:0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
            }
            CustomButton{
                id:dobly_empty2
                width:btnWidth
                height:btnHeight
                opacity:0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
            }
        }
    }
    //dolby-digital
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==1?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dolby_digital_model
                    ListElement { first: "Dolby Digital-32KHz-2.0Ch"; number: 0x02 }
                    ListElement { first: "Dolby Digital-32KHz-5.1Ch"; number: 0x03 }
                    ListElement { first: "Dolby Digital-44.1KHz-2.0Ch"; number: 0x04 }
                    ListElement { first: "Dolby Digital-44.1KHz-5.1Ch"; number: 0x05 }
                    ListElement { first: "Dolby Digital-48KHz-2.0Ch"; number: 0x06 }
                    ListElement { first: "Dolby Digital-48KHz-5.1Ch"; number: 0x07 }
                }
                Repeater{
                    model: dolby_digital_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dolby-digital-plus
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==2?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dolby_digital_plus_model
                    ListElement { first: "Dolby Digital-Plus-48KHz-2.0Ch"; number: 0x08 }
                    ListElement { first: "Dolby Digital-Plus-48KHz-5.1Ch"; number: 0x09 }
                    ListElement { first: "Dolby Digital-Plus-48KHz-7.1Ch"; number: 0x0a }
                    ListElement { first: "Dolby Digital-Plus-48KHz-Atmos"; number: 0x0b }
                }
                Repeater{
                    model: dolby_digital_plus_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dolby-mat
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==3?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 2
                ListModel {
                    id: dolby_mat_model
                    ListElement { first: "Dolby MAT(PCM)-44.1KHz-2.0Ch"; number: 0x0c }
                    ListElement { first: "Dolby MAT(PCM)-44.1KHz-5.1Ch"; number: 0x0d }
                    ListElement { first: "Dolby MAT(PCM)-44.1KHz-7.1Ch"; number: 0x0e }
                    ListElement { first: "Dolby MAT(PCM)-48KHz-2.0Ch"; number: 0x0f }
                    ListElement { first: "Dolby MAT(PCM)-48KHz-5.1Ch"; number: 0x10 }
                    ListElement { first: "Dolby MAT(PCM)-48KHz-7.1Ch"; number: 0x11 }
                    ListElement { first: "Dolby MAT(PCM object audio)-44.1KHz-Dolby Atmos"; number: 0x12 }
                    ListElement { first: "Dolby MAT(PCM object audio)-48KHz-Dolby Atmos"; number: 0x13 }
                }
                Repeater{
                    model: dolby_mat_model
                    CustomButton{
                        width:dolby_select_width+80
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dolby-mat-trueHD
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==4?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 2
                ListModel {
                    id: dolby_mat_trueHD_model
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-48KHz-2.0Ch"; number: 0x14 }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-48KHz-5.1Ch"; number: 0x15 }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-48KHz-7.1Ch"; number: 0x16 }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-96KHz-2.0Ch"; number: 0x17 }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-96KHz-5.1Ch"; number: 0x18 }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-96KHz-7.1Ch"; number: 0x19 }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-192KHz-2.0Ch"; number: 0x1a }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-192KHz-5.1Ch"; number: 0x1b }
                    ListElement { first: "Dolby MAT(Dolby TrueHD)Object Based 48KHz-Dolby Atmos"; number: 0x1c }
                }
                Repeater{
                    model: dolby_mat_trueHD_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dolby-my-streams
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==5?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dolby_my_streams_model
                    ListElement { first: "MY STREAM1";second:"()"; number: 0x0120 }
                    ListElement { first: "MY STREAM2";second:"()"; number: 0x0134 }
                    ListElement { first: "MY STREAM3";second:"()"; number: 0x0148 }
                    ListElement { first: "MY STREAM4";second:"()"; number: 0x015c }
                    ListElement { first: "MY STREAM5";second:"()"; number: 0x0170 }
                    ListElement { first: "MY STREAM6";second:"()"; number: 0x0184 }
                }
                Repeater{
                    model: dolby_my_streams_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                            Text {
                                text: second
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dobly_arm_30
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==6?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 2
                ListModel {
                    id: dobly_arm_30_model
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_30HZ"; number: 0x1d }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_30HZ"; number: 0x1e }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_30HZ"; number: 0x22 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_30HZ"; number: 0x26 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_30HZ"; number: 0x2a }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_30HZ"; number: 0x2e }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_30HZ"; number: 0x32 }
                }
                Repeater{
                    model: dobly_arm_30_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dobly_arm_29
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==7?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 2
                ListModel {
                    id: dobly_arm_29_model
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_29HZ"; number: 0x36 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_29HZ"; number: 0x37 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_29HZ"; number: 0x3a }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_29HZ"; number: 0x3e }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_29HZ"; number: 0x47 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_29HZ"; number: 0x50 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_29HZ"; number: 0x59 }
                }
                Repeater{
                    model: dobly_arm_29_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dobly_arm_25
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==8?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 2
                ListModel {
                    id: dobly_arm_25_model
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_24HZ"; number: 0xe0 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_24HZ"; number: 0xe9 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_24HZ"; number: 0xf2 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_24HZ"; number: 0xfb }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_24HZ"; number: 0x104 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_24HZ"; number: 0x10d }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_24HZ"; number: 0x116 }
                }
                Repeater{
                    model: dobly_arm_25_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dobly_arm_24
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==9?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 2
                ListModel {
                    id: dobly_arm_24_model
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_24HZ"; number: 0x62 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_24HZ"; number: 0x6b }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_24HZ"; number: 0x74 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_24HZ"; number: 0x7d }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_24HZ"; number: 0x86 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_24HZ"; number: 0x8f }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_24HZ"; number: 0x98 }
                }
                Repeater{
                    model: dobly_arm_24_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dobly_arm_23
    RowLayout {
        visible: pageflag==2&&pageindex == 2&&dolbyFlag ==10?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{

                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 2
                ListModel {
                    id: dobly_arm_23_model
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_23HZ"; number: 0xa1 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_23HZ"; number: 0xaa }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_23HZ"; number: 0xb3 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_23HZ"; number: 0xbc }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_23HZ"; number: 0xc5 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_23HZ"; number: 0xce }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_23HZ"; number: 0xd7 }
                }
                Repeater{
                    model: dobly_arm_23_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DolbyAudioGenerator",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //ext
    RowLayout {
        visible: pageflag==3&&pageindex == 1?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Column{
                anchors.top: parent.top
                anchors.topMargin: 400
                spacing:100
                width: root.width
                CustomButton{
                    width:456
                    height:120
                    border.color: dolby_select==0x00?"orange":"black"
                    border.width: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'black'
                    Column{
                        anchors.centerIn: parent
                        Text {
                            text: "ENABLE"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                            anchors.horizontalCenter : parent.horizontalCenter
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            dolby_select=0x00
                            confirmsignal("EXT",0x00)
                        }
                    }
                }
            }
        }
    }

    //dts
    property int dtsFlag: 1
    Column{
        visible: pageindex == 1&&pageflag ==4?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing:100
        width: root.width
        RowLayout {
            width: parent.width

            CustomButton{
                id:dts_digital_surround
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DTS Digital Surround")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_digital_surround.flag = true
                    }
                    onReleased: {
                        dts_digital_surround.flag = false
                        pageindex = 2
                        dtsFlag = 1
                    }
                }
            }
            CustomButton{
                id:dts_hd_high_resolution
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DTS-HD High Resolution")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_hd_high_resolution.flag = true
                    }
                    onReleased: {
                        dts_hd_high_resolution.flag = false
                        pageindex = 2
                        dtsFlag = 2
                    }
                }
            }
            CustomButton{
                id:dts_hd_master_audio
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DTS-HD Master Audio")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_hd_master_audio.flag = true
                    }
                    onReleased: {
                        dts_hd_master_audio.flag = false
                        pageindex = 2
                        dtsFlag = 3
                    }
                }
            }
        }
        RowLayout {
            width: parent.width

            CustomButton{
                id:dts_x
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DTS:X")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_x.flag = true
                    }
                    onReleased: {
                        dts_x.flag = false
                        pageindex = 2
                        dtsFlag = 4
                    }
                }
            }
            CustomButton{
                id:dts_express
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("DTS Express")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_express.flag = true
                    }
                    onReleased: {
                        dts_express.flag = false
                        pageindex = 2
                        dtsFlag = 5
                    }
                }
            }
            CustomButton{
                id:dts_my_streams
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("MY STREAMS")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_my_streams.flag = true
                    }
                    onReleased: {
                        dts_my_streams.flag = false
                        pageindex = 2
                        dtsFlag = 6
                    }
                }
            }
        }
    }
    //dts-digital-surround
    RowLayout {
        visible: pageflag==4&&pageindex == 2&&dtsFlag ==1?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dts_digital_surround_model
                    ListElement { first: "DTS Digital Surround-48KHz-2.0Ch"; number: 0x0232 }
                    ListElement { first: "DTS Digital Surround-48KHz-5.1Ch"; number: 0x0233 }
                    ListElement { first: "DTS Digital Surround-48.1KHz-6.1Ch"; number: 0x0234 }
                    ListElement { first: "DTS Digital Surround-44.1KHz-5.1Ch"; number: 0x0235 }
                    ListElement { first: "DTS Digital Surround-96KHz-5.1Ch"; number: 0x0236 }
                }
                Repeater{
                    model: dts_digital_surround_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DTX",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dts-hd-high-resolution
    RowLayout {
        visible: pageflag==4&&pageindex == 2&&dtsFlag ==2?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dts_hd_high_resolution_model
                    ListElement { first: "DTS-HD High Resolution-48KHz-5.1Ch"; number: 0x0237 }
                    ListElement { first: "DTS-HD High Resolution-48KHz-7.1Ch"; number: 0x0238 }
                    ListElement { first: "DTS-HD High Resolution-96KHz-7.1Ch"; number: 0x0239 }
                    ListElement { first: "DTS-HD High Resolution-88.2KHz-7.1Ch"; number: 0x023a }
                }
                Repeater{
                    model: dts_hd_high_resolution_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DTX",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dts-hd-master-audio
    RowLayout {
        visible: pageflag==4&&pageindex == 2&&dtsFlag ==3?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dts_hd_master_audio_model
                    ListElement { first: "DTS-HD Master Audio-48KHz-5.1Ch"; number: 0x023b }
                    ListElement { first: "DTS-HD Master Audio-48KHz-7.1Ch"; number: 0x023c }
                    ListElement { first: "DTS-HD Master Audio-192KHz-2.0Ch"; number: 0x023d }
                    ListElement { first: "DTS-HD Master Audio-192KHz-7.1Ch"; number: 0x023e }
                }
                Repeater{
                    model: dts_hd_master_audio_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DTX",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dts-x
    RowLayout {
        visible: pageflag==4&&pageindex == 2&&dtsFlag ==4?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dts_x_model
                    ListElement { first: "DTS:X-48KHz-7.1.4Ch"; number: 0x023f }
                    ListElement { first: "DTS:X-48KHz-5.1.4Ch"; number: 0x0240 }
                    ListElement { first: "DTS:X Master Audio-48KHz-7.1.4Ch"; number: 0x0241 }
                    ListElement { first: "DTS:X Master Audio-96KHz-7.1.4Ch"; number: 0x0242 }
                    ListElement { first: "DTS:X(32 Objects)"; number: 0x0243 }
                }
                Repeater{
                    model: dts_x_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DTX",number)
                            }
                        }
                    }
                }

            }
        }
    }
    //dts-express
    RowLayout {
        visible: pageflag==4&&pageindex == 2&&dtsFlag ==5?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Column{
                anchors.top: parent.top
                anchors.topMargin: 400
                spacing:100
                width: root.width
                CustomButton{
                    width:456
                    height:120
                    border.color: dolby_select==0x0244?"orange":"black"
                    border.width: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'black'
                    Column{
                        anchors.centerIn: parent
                        Text {
                            text: "DTS Low Bit Rate-48KHz-5.1Ch"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                            anchors.horizontalCenter : parent.horizontalCenter
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            dolby_select=0x0244
                            confirmsignal("DTX",0x0244)
                        }
                    }
                }
            }
        }
    }
    //dts-my-streams
    RowLayout {
        visible: pageflag==4&&pageindex == 2&&dtsFlag ==6?true:false
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing:150
                rowSpacing: 50
                columns: 3
                ListModel {
                    id: dts_my_streams_model
                    ListElement { first: "MY STREAM1";second:"()"; number: 0x0245 }
                    ListElement { first: "MY STREAM2";second:"()"; number: 0x0259 }
                    ListElement { first: "MY STREAM3";second:"()"; number: 0x026d }
                    ListElement { first: "MY STREAM4";second:"()"; number: 0x0281 }
                    ListElement { first: "MY STREAM5";second:"()"; number: 0x0295 }
                    ListElement { first: "MY STREAM6";second:"()"; number: 0x02a9 }
                }
                Repeater{
                    model: dts_my_streams_model
                    CustomButton{
                        width:dolby_select_width
                        height:dolby_select_height
                        border.color: dolby_select==number?"orange":"black"
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                            Text {
                                text: second
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select=number
                                confirmsignal("DTX",number)
                            }
                        }
                    }
                }

            }
        }
    }


}
