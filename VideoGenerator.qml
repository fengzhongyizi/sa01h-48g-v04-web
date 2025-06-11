import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
Rectangle {
    id:root
    anchors.fill: parent

    signal confirmsignal(string str,var num)

    property alias pattern_ire_window_size: pattern_ire_window_size
    property alias pattern_ire_level: pattern_ire_level

    property alias windowEvenPixelRed: windowEvenPixelRed
    property alias windowEvenPixelGreen: windowEvenPixelGreen
    property alias windowEvenPixelBlue: windowEvenPixelBlue

    property alias windowOddPixelRed: windowOddPixelRed
    property alias windowOddPixelGreen: windowOddPixelGreen
    property alias windowOddPixelBlue: windowOddPixelBlue

    property alias backgroundEvenPixelRed: backgroundEvenPixelRed
    property alias backgroundEvenPixelGreen: backgroundEvenPixelGreen
    property alias backgroundEvenPixelBlue: backgroundEvenPixelBlue

    property alias backgroundOddPixelRed: backgroundOddPixelRed
    property alias backgroundOddPixelGreen: backgroundOddPixelGreen
    property alias backgroundOddPixelBlue: backgroundOddPixelBlue

    property alias rgbYuv_window_size: rgbYuv_window_size

    property alias windowRed: windowRed
    property alias windowGreen: windowGreen
    property alias windowBlue: windowBlue

    property alias backgroundRed: backgroundRed
    property alias backgroundGreen: backgroundGreen
    property alias backgroundBlue: backgroundBlue

    property alias rgb_window_size: rgb_window_size

    property alias in_m_PCLOCK: in_m_PCLOCK
    property alias in_m_HACTIVE: in_m_HACTIVE
    property alias in_m_HBLANK: in_m_HBLANK
    property alias in_m_HSYNCWIDTH: in_m_HSYNCWIDTH
    property alias in_m_HSOFFSET: in_m_HSOFFSET
    property alias in_m_VACTIVE: in_m_VACTIVE
    property alias in_m_VBLANK: in_m_VBLANK
    property alias in_m_VSYNCWIDTH: in_m_VSYNCWIDTH
    property alias in_m_VSOFFSET: in_m_VSOFFSET
    property alias in_m_UserdefineTiming: in_m_UserdefineTiming


    property alias timing_8k_model: timing_8k_model
    property alias timing_uhd_model: timing_uhd_model
    property alias timing_4k_model: timing_4k_model
    property alias timing_2k_model: timing_2k_model
    property alias timing_hd_model: timing_hd_model
    property alias timing_sd_model: timing_sd_model
    property alias timing_vesa_model: timing_vesa_model
    property alias timing_3d_model: timing_3d_model
    property alias timing_custom_model: timing_custom_model

    property alias imaxFlag_model: imaxFlag_model



    property alias color_space_model: color_space_model
    property alias color_depth_model: color_depth_model
    property alias hdmi_model: hdmi_model
    property alias hdrFlag_model: hdrFlag_model
    property alias bt2020_model: bt2020_model
//    property alias rgbTriplet_model: rgbTriplet_model
    property alias hdcp_model: hdcp_model




    property int pageindex: 0
    property int pageflag: 0
    property int btnWidth: 300
    property int btnHeight: 120

    property int btnfontsize: 35
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
        anchors.topMargin: 20
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
                }else if(pageindex == 3){
                    pageindex = 2
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

            CustomButton {
                id:timing
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Timing")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing.flag = true
                    }
                    onReleased: {
                        timing.flag = false
                        pageflag = 1
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:pattern
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Pattern")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pattern.flag = true
                    }
                    onReleased: {
                        pattern.flag = false
                        pageflag = 2
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:colorSpace
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Color Space")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        colorSpace.flag = true
                    }
                    onReleased: {
                        colorSpace.flag = false
                        pageflag = 3
                        pageindex = 1
                    }
                }
            }
        }
        RowLayout {
            width: parent.width
            CustomButton{
                id:bt
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("BT 2020")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        bt.flag = true
                    }
                    onReleased: {
                        bt.flag = false
                        pageflag = 4
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:colorDepth
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Color Depth")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        colorDepth.flag = true
                    }
                    onReleased: {
                        colorDepth.flag = false
                        pageflag = 5
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:hdcp
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("HDCP")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        hdcp.flag = true
                    }
                    onReleased: {
                        hdcp.flag = false
                        pageflag = 6
                        pageindex = 1
                    }
                }
            }
        }
        RowLayout {
            width: parent.width
            CustomButton{
                id:hdmi
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("HDMI/DVI")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        hdmi.flag = true
                    }
                    onReleased: {
                        hdmi.flag = false
                        pageflag = 7
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:hdr
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("HDR")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        hdr.flag = true
                    }
                    onReleased: {
                        hdr.flag = false
                        pageflag = 8
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:enhancenment
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("IMAX Enhancenment")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        enhancenment.flag = true
                    }
                    onReleased: {
                        enhancenment.flag = false
                        pageflag = 9
                        pageindex = 1
                    }
                }
            }
        }
        RowLayout {
            width: parent.width
            CustomButton{
                id:rgb
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("RGB Triplet")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        rgb.flag = true
                    }
                    onReleased: {
                        rgb.flag = false
                        pageflag = 10
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:timingDetails
                width:btnWidth
                height:btnHeight
                border.color: "black"
                border.width: 2
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("Timing Details")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timingDetails.flag = true
                    }
                    onReleased: {
                        timingDetails.flag = false
                        pageflag = 11
                        pageindex = 1
                    }
                }
            }
            CustomButton{
                id:empty0
                width:btnWidth
                height:btnHeight
                opacity:0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }


        }
    }

    //timing-----------------------------------------------------------------------
    property alias timing_8k: timing_8k
    property alias timing_uhd: timing_uhd
    property alias timing_4k_DCI: timing_4k_DCI
    property alias timing_2K_DCI: timing_2K_DCI
    property alias timing_hd: timing_hd
    property alias timing_SD: timing_SD
    property alias timing_VESA: timing_VESA
    property alias timing_3D: timing_3D
    property alias timing_CUSTOM: timing_CUSTOM
    property int timingFlag: 1
    property int timingSelect: 1
    property int timingSelectFlag: 1
    property int timing_select_width: 300
    property int timing_select_height: 120
    Column{
        visible: pageindex == 1&&pageflag ==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing:100
        width: root.width
        RowLayout {
            width: parent.width

            CustomButton{
                id:timing_8k
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 1?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("8K")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_8k.flag = true
                        timingSelectFlag = 1
                    }
                    onReleased: {
                        timing_8k.flag = false
                        pageindex = 2
                        timingFlag = 1
                    }
                }
            }
            CustomButton{
                id:timing_uhd
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 2?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("UHD")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_uhd.flag = true
                        timingSelectFlag = 2
                    }
                    onReleased: {
                        timing_uhd.flag = false
                        pageindex = 2
                        timingFlag = 2
                    }
                }
            }
            CustomButton{
                id:timing_4k_DCI
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 3?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("4K-DCI")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_4k_DCI.flag = true
                        timingSelectFlag = 3
                    }
                    onReleased: {
                        timing_4k_DCI.flag = false
                        pageindex = 2
                        timingFlag = 3
                    }
                }
            }
        }
        RowLayout {
            width: parent.width

            CustomButton{
                id:timing_2K_DCI
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 4?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("2K-DCI")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_2K_DCI.flag = true
                        timingSelectFlag = 4
                    }
                    onReleased: {
                        timing_2K_DCI.flag = false
                        pageindex = 2
                        timingFlag = 4
                    }
                }
            }
            CustomButton{
                id:timing_hd
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 5?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("HD")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_hd.flag = true
                        timingSelectFlag = 5
                    }
                    onReleased: {
                        timing_hd.flag = false
                        pageindex = 2
                        timingFlag = 5
                    }
                }
            }
            CustomButton{
                id:timing_SD
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 6?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("SD")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_SD.flag = true
                        timingSelectFlag = 6
                    }
                    onReleased: {
                        timing_SD.flag = false
                        pageindex = 2
                        timingFlag = 6
                    }
                }
            }
        }
        RowLayout {
            width: parent.width

            CustomButton{
                id:timing_VESA
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 7?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("VESA")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_VESA.flag = true
                        timingSelectFlag = 7
                    }
                    onReleased: {
                        timing_VESA.flag = false
                        pageindex = 2
                        timingFlag = 7
                    }
                }
            }
            CustomButton{
                id:timing_3D
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 8?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("3D")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_3D.flag = true
                        timingSelectFlag = 8
                    }
                    onReleased: {
                        timing_3D.flag = false
                        pageindex = 2
                        timingFlag = 8
                    }
                }
            }
            CustomButton{
                id:timing_CUSTOM
                width:btnWidth
                height:btnHeight
                border.color: timingSelectFlag === 9?"orange":"black"
                border.width: 4
                color: flag?'gray':'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag:false
                Text {
                    text: qsTr("CUSTOM")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        timing_CUSTOM.flag = true
                        timingSelectFlag = 9
                    }
                    onReleased: {
                        timing_CUSTOM.flag = false
                        pageindex = 2
                        timingFlag = 9
                    }
                }
            }
        }
        RowLayout {
            width: parent.width
//            CustomButton{
//                id:timing_auto
//                width:btnWidth
//                height:btnHeight
//                border.color: "black"
//                border.width: 2
//                color: flag?'gray':'black'
//                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
//                property bool flag:false
//                Text {
//                    text: qsTr("AUTO")
//                    anchors.centerIn: parent
//                    font.family: myriadPro.name
//                    font.pixelSize: btnfontsize
//                    color: "white"
//                }

//                MouseArea{
//                    anchors.fill: parent
//                    onPressed: {
//                        timing_auto.flag = true
//                    }
//                    onReleased: {
//                        timing_auto.flag = false
//                        pageindex = 2
//                        timingFlag = 10
//                    }
//                }
//            }
            CustomButton{
                id:empty00
                width:btnWidth
                height:btnHeight
                opacity:0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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

    //videoclk,hactive,vactive,htoal,vtoal,hbank,vblank,hfreq,vfreq,hfrontporch,vfrontporch,hsync,vsync,scan,Hsyncpolarity,Vsyncpolarity

    property var timing8k: [
        ["297","4096","2160","4400","2250","304","90","67.5","30","48","3","32","5","0","0","0"],//4096x2160@30Hz
        ["296.703","4096","2160","4400","2250","304","90","67.43","29.97","48","3","32","5","0","0","0"],//4096x2160@29.97Hz
        ["247.5","4096","2160","4400","2250","304","90","56.25","25","48","3","32","5","0","0","0"],//4096x2160@25Hz
        ["237.6","4096","2160","4400","2250","304","90","54","24","48","3","32","5","0","0","0"],//4096x2160@24Hz
        ["237.594","4096","2160","4400","2250","304","90","53.999","23.976","48","3","32","5","0","0","0"],//4096x2160@23.976Hz
        ["594","4096","2160","4400","2250","304","90","135","60","48","3","32","5","0","0","0"],//4096x2160@60Hz
        ["593.407","4096","2160","4400","2250","304","90","134.865","59.94","48","3","32","5","0","0","0"],//4096x2160@59.94Hz
        ["495","4096","2160","4400","2250","304","90","112.5","50","48","3","32","5","0","0","0"],//4096x2160@50Hz
        ["593.407","4096","2160","4400","2250","304","90","134.865","59.94","48","3","32","5","0","0","0"],//4096x2160@48Hz
        ["593.407","4096","2160","4400","2250","304","90","134.865","59.94","48","3","32","5","0","0","0"],//4096x2160@47.95Hz
    ]
    //timing-8k
    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 50
        columns: 3
        ListModel {
            id: timing_8k_model
            ListElement { first: "7680x4320";second:"30Hz"; number: 0x6e;index:0 }
            ListElement { first: "7680x4320";second:"29.97Hz"; number: 0x6f ;index:1}
            ListElement { first: "7680x4320";second:"25Hz"; number: 0x70 ;index:2}
            ListElement { first: "7680x4320";second:"24Hz"; number: 0x71 ;index:3}
            ListElement { first: "7680x4320";second:"23.98Hz"; number: 0x72;index:4 }
            ListElement { first: "7680x4320";second:"60Hz"; number: 0x73 ;index:5}
            ListElement { first: "7680x4320";second:"59.94Hz"; number: 0x74;index:6 }
            ListElement { first: "7680x4320";second:"50Hz"; number: 0x75 ;index:7}
            ListElement { first: "7680x4320";second:"48Hz"; number: 0x76 ;index:8}
            ListElement { first: "7680x4320";second:"47.95Hz"; number: 0x77 ;index:9}
        }
        Repeater{
            model: timing_8k_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
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
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timing8k,index)
//                        deal_timingDetails()
                    }
                }
            }
        }

    }

    property var timinguhd: [
        ["297","3840","2160","4400","2250","560","90","67.5","30","176","8","88","10","0","0","0"],//3840x2160@30Hz
        ["296.7","3840","2160","4400","2250","560","90","67.432","29.97","176","8","88","10","0","0","0"],//3840x2160@29.97Hz
        ["297","3840","2160","5280","2250","1440","90","56.25","25","1056","8","88","10","0","0","0"],//3840x2160@25Hz
        ["297","3840","2160","5500","2250","1660","90","54","24","1276","8","88","10","0","1","1"],//3840x2160@24Hz
        ["296.7","3840","2160","5500","2250","1660","90","53.946","23.976","1276","8","88","10","0","0","0"],//3840x2160@23.976Hz
        ["594","3840","2160","4400","2250","560","90","135","60","176","8","88","10","0","0","0"],//3840x2160@60Hz
        ["593.4","3840","2160","4400","2250","560","90","134.865","59.94","176","8","88","10","0","0","0"],//3840x2160@59.94Hz
        ["594","3840","2160","5280","2250","1440","90","112.5","50","1056","8","88","10","0","0","0"],//3840x2160@50Hz
        ["594","3840","2160","5500","2250","1660","90","108","48","1276","8","88","10","0","1","1"],//3840x2160@48Hz
        ["593.4","3840","2160","5500","2250","1660","90","107.892","47.952","1276","8","88","10","0","0","0"],//3840x2160@47.95Hz
        ["593.4","3840","2160","5500","2250","1660","90","107.892","47.952","1276","8","88","10","0","0","0"],//3840x2160@100Hz


    ]
    //timing-uhd

    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==2?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 50
        columns: 3
        ListModel {
            id: timing_uhd_model
            ListElement { first: "3840x2160";second:"30Hz"; number: 0x1c }
            ListElement { first: "3840x2160";second:"29.97Hz"; number: 0x1d }
            ListElement { first: "3840x2160";second:"25Hz"; number: 0x1e }
            ListElement { first: "3840x2160";second:"24Hz"; number: 0x1f }
            ListElement { first: "3840x2160";second:"23.976Hz"; number: 0x20 }
            ListElement { first: "3840x2160";second:"60Hz"; number: 0x22 }
            ListElement { first: "3840x2160";second:"59.94Hz"; number: 0x23 }
            ListElement { first: "3840x2160";second:"50Hz"; number: 0x24 }
            ListElement { first: "3840x2160";second:"48Hz"; number: 0x67 }
            ListElement { first: "3840x2160";second:"47.95Hz"; number: 0x68 }
            ListElement { first: "3840x2160";second:"100Hz"; number: 0x6b }
            ListElement { first: "3840x2160";second:"120Hz"; number: 0x6c }
            ListElement { first: "3840x2160";second:"119.88Hz"; number: 0x6d }
        }
        Repeater{
            model: timing_uhd_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
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
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timinguhd,index)
//                        deal_timingDetails()
                    }
                }
            }
        }

    }

    property var timing4k: [
        ["297","4096","2160","4400","2250","304","90","67.5","30","48","3","32","5","0","0","0"],//4096x2160@30Hz
        ["296.703","4096","2160","4400","2250","304","90","67.43","29.97","48","3","32","5","0","0","0"],//4096x2160@29.97Hz
        ["247.5","4096","2160","4400","2250","304","90","56.25","25","48","3","32","5","0","0","0"],//4096x2160@25Hz
        ["237.6","4096","2160","4400","2250","304","90","54","24","48","3","32","5","0","0","0"],//4096x2160@24Hz
        ["237.594","4096","2160","4400","2250","304","90","53.999","23.976","48","3","32","5","0","0","0"],//4096x2160@23.976Hz
        ["594","4096","2160","4400","2250","304","90","135","60","48","3","32","5","0","0","0"],//4096x2160@60Hz
        ["593.407","4096","2160","4400","2250","304","90","134.865","59.94","48","3","32","5","0","0","0"],//4096x2160@59.94Hz
        ["495","4096","2160","4400","2250","304","90","112.5","50","48","3","32","5","0","0","0"],//4096x2160@50Hz
        ["475.2","4096","2160","4400","2250","304","90","108","48","48","3","32","5","0","0","0"],//4096x2160@48Hz
        ["474.891","4096","2160","4400","2250","304","90","107.93","47.95","48","3","32","5","0","0","0"],//4096x2160@47.95Hz
    ]

    //timing-4k-dci
    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==3?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 50
        columns: 3
        ListModel {
            id: timing_4k_model
            ListElement { first: "4096x2160";second:"30Hz"; number: 0x35;index:0 }
            ListElement { first: "4096x2160";second:"29.97Hz"; number: 0x36;index:1  }
            ListElement { first: "4096x2160";second:"25Hz"; number: 0x37;index:2  }
            ListElement { first: "4096x2160";second:"24Hz"; number: 0x21;index:3  }
            ListElement { first: "4096x2160";second:"23.976Hz"; number: 0x38;index:4 }
            ListElement { first: "4096x2160";second:"60Hz"; number: 0x39 ;index:5 }
            ListElement { first: "4096x2160";second:"59.94Hz"; number: 0x3a;index:6  }
            ListElement { first: "4096x2160";second:"50Hz"; number: 0x3b;index:7  }
            ListElement { first: "4096x2160";second:"48Hz"; number: 0x69;index:8 }
            ListElement { first: "4096x2160";second:"47.95Hz"; number: 0x6a;index:9 }
        }
        Repeater{
            model: timing_4k_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
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
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timing4k,index)
//                        deal_timingDetails()
                    }
                }
            }
        }

    }

    property var timing2k: [
        ["74.25","2048","1080","2200","1125","152","45","33.75","30","24","2","16","5","0","0","0"],//2048x1080@30Hz
        ["74.1758","2048","1080","2200","1125","152","45","33.716","29.97","24","2","16","5","0","0","0"],//2048x1080@29.97Hz
        ["61.875","2048","1080","2200","1125","152","45","28.125","25","24","2","16","5","0","0","0"],//2048x1080@25Hz
        ["59.4","2048","1080","2200","1125","152","45","27","24","24","2","16","5","0","0","0"],//2048x1080@24Hz
        ["59.355","2048","1080","2200","1125","152","45","26.98","23.976","24","2","16","5","0","0","0"],//2048x1080@23.976Hz
        ["148.5","2048","1080","2200","1125","152","45","67.5","60","24","2","16","5","0","0","0"],//2048x1080@60Hz
        ["148.35","2048","1080","2200","1125","152","45","67.432","59.94","24","2","16","5","0","0","0"],//2048x1080@59.94Hz
        ["123.75","2048","1080","2200","1125","152","45","56.25","50","24","2","16","5","0","0","0"],//2048x1080@50Hz
    ]
    //timing-2k-dci
    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==4?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 50
        columns: 3
        ListModel {
            id: timing_2k_model
            ListElement { first: "2048x1080";second:"30Hz"; number: 0x49;index:0}
            ListElement { first: "2048x1080";second:"29.97Hz"; number: 0x4a;index:1 }
            ListElement { first: "2048x1080";second:"25Hz"; number: 0x4b;index:2 }
            ListElement { first: "2048x1080";second:"24Hz"; number: 0x4c;index:3}
            ListElement { first: "2048x1080";second:"23.976Hz"; number: 0x4d;index:4 }
            ListElement { first: "2048x1080";second:"60Hz"; number: 0x4e;index:5 }
            ListElement { first: "2048x1080";second:"59.94Hz"; number: 0x4f;index:6 }
            ListElement { first: "2048x1080";second:"50Hz"; number: 0x50;index:7 }
        }
        Repeater{
            model: timing_2k_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
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
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timing2k,index)
//                        deal_timingDetails()
                    }
                }
            }
        }

    }

    property var timinghd: [
        ["74.25","1280","720","1650","750","370","30","45","60","110","5","40","5","0","0","0"],//720P@60Hz
        ["74.17","1280","720","1650","750","370","30","44.955","59.94","110","5","40","5","0","0","0"],//720P@59.94Hz
        ["74.25","1920","1080","2200","1125","280","45","67.5","60","88","2","44","5","1","1","1"],//1080i@60Hz
        ["74.17","1920","1080","2200","1125","280","45","33.716","59.94","88","2","44","5","1","1","1"],//1080i@59.94Hz
        ["74.25","1920","1080","2200","1125","280","45","33.75","30","88","4","44","5","0","1","1"],//1080P@30Hz
        ["74.17","1920","1080","2200","1125","280","45","33.716","29.97","88","4","44","5","0","1","1"],//1080P@29.97Hz
        ["74.25","1920","1080","2750","1125","830","45","27","24","638","4","44","5","0","1","1"],//1080P@24Hz
        ["74.17","1920","1080","2750","1125","830","45","26.972","23.976","638","4","44","5","0","1","1"],//1080P@23.976Hz
        ["148.5","1920","1080","2200","1125","280","45","67.5","60","88","4","44","5","0","1","1"],//1080P@60Hz
        ["148.35","1920","1080","2200","1125","280","45","67.43","59.94","88","4","44","5","0","1","1"],//1080P@59.54Hz
        ["74.25","1280","720","1980","750","700","30","37.5","50","440","5","40","5","0","0","0"],//720P@50Hz
        ["74.25","1920","1080","2200","1125","280","45","33.75","60","88","2","44","5","1","1","1"],//1080i@60Hz
        ["74.25","1920","1080","2640","1125","720","45","28.12","25","528","4","44","5","0","0","0"],//1080P@25Hz
        ["148.5","1920","1080","2640","1125","720","45","56.25","50","88","4","44","5","0","0","0"],//1080P@50Hz
        ["297","1920","1080","2640","1125","720","45","112.5","120","88","3","44","5","0","0","0"],//1080P@120Hz
        ["266.33","1920","1080","2640","1125","720","45","100.88","119.88","88","4","44","5","0","0","0"],//1080P@119.88Hz
        ["222.75","1920","1080","2640","1125","720","45","84.375","100","88","4","44","5","0","0","0"],//1080P@100Hz
    ]
    //timing-hd
    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==5?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 30
        columns: 3
        ListModel {
            id: timing_hd_model
            ListElement { first: "720P";second:"60Hz"; number: 0x0c;index:0 }
            ListElement { first: "720P";second:"59.94Hz"; number: 0x0d ;index:1}
            ListElement { first: "1080i";second:"60Hz"; number: 0x0e;index:2 }
            ListElement { first: "1080i";second:"59.94Hz"; number: 0x0f ;index:3}
            ListElement { first: "1080P";second:"30Hz"; number: 0x10 ;index:4}
            ListElement { first: "1080P";second:"29.97Hz"; number: 0x11;index:5 }
            ListElement { first: "1080P";second:"24Hz"; number: 0x12 ;index:6}
            ListElement { first: "1080P";second:"23.976Hz"; number: 0x13;index:7 }
            ListElement { first: "1080P";second:"60Hz"; number: 0x14 ;index:8}
            ListElement { first: "1080P";second:"59.94Hz"; number: 0x15 ;index:9}
            ListElement { first: "720P";second:"50Hz"; number: 0x18;index:10 }
            ListElement { first: "1080i";second:"50Hz"; number: 0x19 ;index:11}
            ListElement { first: "1080P";second:"25Hz"; number: 0x1a ;index:12}
            ListElement { first: "1080P";second:"50Hz"; number: 0x1b ;index:13}
            ListElement { first: "1080P";second:"120Hz"; number: 0x51 ;index:14 }
            ListElement { first: "1080P";second:"119.88Hz"; number: 0x52;index:15 }
            ListElement { first: "1080P";second:"100Hz"; number: 0x66 ;index:16}
        }
        Repeater{
            model: timing_hd_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
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
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timinghd,index)
//                        deal_timingDetails()
                    }
                }
            }
        }

    }

    property var timingsdid_str: [
        ["13.48","720","480","858","525","138","45","15.734","59.94","16","4","62","3","1","1","1"],//480i@59.94Hz
        ["26.97","720","480","858","525","138","45","31.437","59.94","16","9","62","6","0","1","1"],//480P@59.94Hz
        ["13.5","720","576","864","625","144","49","15.625","50","12","5","64","5","1","1","1"],//576i@50Hz
        ["27","720","576","864","625","144","49","31.25","50","12","5","64","5","0","1","1"],//576P@50Hz
    ]
    //timing-sd
    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==6?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 50
        columns: 3
        ListModel {
            id: timing_sd_model
            ListElement { first: "480i";second:"59.94Hz"; number: 0x0a ;index:0}
            ListElement { first: "480P";second:"59.94Hz"; number: 0x0b ;index:1}
            ListElement { first: "576i";second:"50Hz"; number: 0x16 ;index:2}
            ListElement { first: "576P";second:"50Hz"; number: 0x17 ;index:3}
        }
        Repeater{
            model: timing_sd_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
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
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timingsd,index)
//                        deal_timingDetails()
                    }
                }
            }
        }

    }

    property var timingvesa: [
        ["297","4096","2160","4400","2250","304","90","67.5","30","48","3","32","5","0","0","0"],//4096x2160@30Hz
    ]
    //timing-vesa
    RowLayout {
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==7?true:false
        width: parent.width
        anchors.top: root.top
        anchors.topMargin: 150

        Rectangle{
            width: root.width-20
            height: 800
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible: pageflag ==1&&pageindex == 2&&timingFlag ==7?true:false
            ScrollView{
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                clip: true
                GridLayout{
                    width: parent.width
                    columnSpacing:150
                    rowSpacing: 50
                    columns: 4
                    ListModel {
                        id: timing_vesa_model
                        ListElement { first: "VGA";second:"640x480"; number: 0x00 ;index:0}
                        ListElement { first: "SVGA";second:"800x600"; number: 0x01 ;index:1}
                        ListElement { first: "XGA";second:"1024x768"; number: 0x02 ;index:2}
                        ListElement { first: "XGA+";second:"1152x864"; number: 0x48 ;index:3}
                        ListElement { first: "HD";second:"1360x768"; number: 0x04 ;index:4}
                        ListElement { first: "WVGA";second:"1280x768"; number: 0x03 ;index:5}
                        ListElement { first: "SXGA";second:"1280x960"; number: 0x05 ;index:6}
                        ListElement { first: "SXGA+";second:"1400x1050"; number: 0x07 ;index:7}
                        ListElement { first: "WXGA+";second:"1440x900"; number: 0x45 ;index:8}
                        ListElement { first: "HD+";second:"1600x900"; number: 0x46 ;index:9}
                        ListElement { first: "UXGA";second:"1600x1200"; number: 0x08 ;index:10}
                        ListElement { first: "WUXGA";second:"1920x1200"; number: 0x09 ;index:11}
                        ListElement { first: "XGA+";second:"1152x900"; number: 0x53 ;index:12}
                        ListElement { first: "WXGA";second:"1280x800"; number: 0x54 ;index:13}
                        ListElement { first: "SXGA";second:"1280x1050"; number: 0x55 ;index:14}
                        ListElement { first: "UN";second:"1920x1280"; number: 0x56 ;index:15}
                        ListElement { first: "UN";second:"1920x1440"; number: 0x57 ;index:16}
                        ListElement { first: "QWXGA";second:"2048x1152"; number: 0x58;index:17 }
                        ListElement { first: "QXGA";second:"2048x1536"; number: 0x59 ;index:18}
                        ListElement { first: "UN";second:"2160x1440"; number: 0x5a ;index:19}
                        ListElement { first: "UN";second:"2560x1080"; number: 0x5b ;index:20}
                        ListElement { first: "QHD";second:"2560x1440"; number: 0x5c ;index:21}
                        ListElement { first: "WQXGA";second:"2560x1600"; number: 0x5d ;index:22}
                        ListElement { first: "QSXGA";second:"2560x2048"; number: 0x5e ;index:23}
                        ListElement { first: "QWXGA+";second:"2880x1800"; number: 0x5f ;index:24}
                        ListElement { first: "GAL";second:"2960x1440"; number: 0x60 ;index:25}
                        ListElement { first: "SUR";second:"3000x2000"; number: 0x61 ;index:26}
                        ListElement { first: "WQSXGA";second:"3200x2048"; number: 0x62 ;index:27}
                        ListElement { first: "UWQHD";second:"3440x1440"; number: 0x63 ;index:28}
                        ListElement { first: "UW4K";second:"3840x1600"; number: 0x64 ;index:29}
                        ListElement { first: "WQUXGA";second:"3840x2400"; number: 0x65 ;index:30}
                    }
                    Repeater{
                        model: timing_vesa_model
                        CustomButton{
                            width:timing_select_width
                            height:timing_select_height
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            border.color: timingSelect==number?"orange":"black"
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
                                Text {
                                    text: second
                                    font.family: myriadPro.name
                                    font.pixelSize: btnfontsize
                                    color: "white"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    timingSelect=number
                                    confirmsignal("Timing",number)
//                                    settiming(timingvesa,index)
//                                    deal_timingDetails()
                                }
                            }
                        }
                    }

                }
            }
        }
    }

    property var timing3d: [
         ["148.5","1280","720","1650","1500","370","60","45","60","110","5","40","5","0","1","1"],//720P@60Hz
         ["148.35","1280","1440","1650","1500","370","60","89.94","59.94","110","5","40","5","0","1","1"],//720P@59.94Hz
         ["74.17","1920","2160","2750","2250","830","90","26.972","24","110","5","40","5","0","1","1"],//1080P@24Hz
         ["74.17","1920","2160","2750","2250","830","90","26.972","24","110","5","40","5","0","1","1"],//1080P@23.976Hz
         ["74.25","1280","720","1980","1500","700","60","37.5","50","110","5","40","5","0","1","1"],//720P@50Hz

    ]
    //timing-3d
    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==8?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 50
        columns: 3
        ListModel {
            id: timing_3d_model
            ListElement { first: "720P 60Hz";second:"(3D-FP)"; number: 0x25 ;index:0}
            ListElement { first: "720P 59.94Hz";second:"(3D-FP)"; number: 0x26 ;index:1}
            ListElement { first: "1080P 24Hz";second:"(3D-FP)"; number: 0x27 ;index:2}
            ListElement { first: "1080P 23.976Hz";second:"(3D-FP)"; number: 0x28 ;index:3}
            ListElement { first: "720P 50Hz";second:"(3D-FP)"; number: 0x29;index:4 }
        }
        Repeater{
            model: timing_3d_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
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
                    Text {
                        text: second
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timing3d,index)
//                        deal_timingDetails()
                    }
                }
            }
        }

    }

    //timing-custom
    GridLayout{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==9?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing:125
        rowSpacing: 50
        columns: 3
        ListModel {
            id: timing_custom_model
            ListElement { first: "USER-1"; number: 0x2b ;index:0}
            ListElement { first: "USER-2"; number: 0x2c ;index:1}
            ListElement { first: "USER-3"; number: 0x2d ;index:2}
            ListElement { first: "USER-4"; number: 0x2e ;index:3}
            ListElement { first: "USER-5"; number: 0x2f ;index:4}
            ListElement { first: "USER-6"; number: 0x30 ;index:5}
            ListElement { first: "USER-7"; number: 0x31 ;index:6}
            ListElement { first: "USER-8"; number: 0x32 ;index:7}
            ListElement { first: "USER-9"; number: 0x33 ;index:8}
            ListElement { first: "USER-10"; number: 0x34 ;index:9}
        }
        Repeater{
            model: timing_custom_model
            CustomButton{
                width:timing_select_width
                height:timing_select_height
                border.color: timingSelect==number?"orange":"black"
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'

                Text {
                    text: first
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                    anchors.horizontalCenter : parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }


                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        timingSelect=number
                        confirmsignal("Timing",number)
//                        settiming(timing4k,index)
                        in_m_UserdefineTiming.currentIndex =index;
                        var str = deal_timingDetails();
                        confirmsignal("timingdetails",str);
                    }
                }
            }
        }

    }

    //timing-auto
    Column{
        visible: pageflag ==1&&pageindex == 2&&timingFlag ==10?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150

        CustomButton{
            width:700
            height:80
            border.color: timingSelect==0x2a?"orange":"black"
            border.width: 4
            anchors.horizontalCenter: parent.horizontalCenter
            color: 'black'

            Text {
                text: "Auto(Output timing based on EDID of sink device)"
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
                anchors.horizontalCenter : parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    timingSelect=0x2a
                    confirmsignal("Timing",0x2a)
                }
            }
        }

        Text {
            text: qsTr("TIMING")
            width: 700
            horizontalAlignment: Text.AlignLeft
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: myriadPro.name
            font.pixelSize: btnfontsize
            color: "black"
        }
        Rectangle{
            width: 700
            height: 50
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id:host_ip
                text: qsTr("")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }
        }
        Text {
            text: qsTr("SHORT MEDIA DESCRIPTOR")
            width: 700
            horizontalAlignment: Text.AlignLeft
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: myriadPro.name
            font.pixelSize: btnfontsize
            color: "black"
        }
        Rectangle{
            width: 700
            height: 500
            border.width: 1
            border.color:"#585858"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: true
            Flickable {
                anchors.fill: parent

                TextArea.flickable: TextArea {
                    id: short_media_descriptor_text
                    wrapMode: TextArea.Wrap
                    textFormat: TextArea.PlainText
                    selectByMouse: true
                    topPadding: 10
                    leftPadding: 10
                    font.pixelSize: 13
                    font.family: "Roboto"
                    readOnly: true
                }

                ScrollBar.vertical: ScrollBar {
                    policy: short_media_descriptor_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                    interactive: true
                }
            }
        }
    }


    //pattern-------------------------------------------------------
    property int patternFlag: 1
    property int patternIndex: 0x0000
    property int patternWidth: 300
    property int patternHeight: 220
    property alias pattern_fpga_model: pattern_fpga_model
    property alias pattern_isf_model: pattern_isf_model
    property alias pattern_dvs_hdr_model: pattern_dvs_hdr_model
    property alias pattern_dvs_hdr_clipping_color_model: pattern_dvs_hdr_clipping_color_model
    property alias pattern_dvs_hdr_evaluation_model: pattern_dvs_hdr_evaluation_model
    property alias pattern_dvs_hdr_geometry_model: pattern_dvs_hdr_geometry_model
    property alias pattern_dvs_hdr_ramps_model: pattern_dvs_hdr_ramps_model
    property alias pattern_dvs_hdr_resolution_model: pattern_dvs_hdr_resolution_model
    property alias pattern_dvs_dolby_vision_model: pattern_dvs_dolby_vision_model
    property alias pattern_dvs_dolby_vision_clipping_color_model: pattern_dvs_dolby_vision_clipping_color_model
    property alias pattern_dvs_dolby_vision_evaluation_model: pattern_dvs_dolby_vision_evaluation_model
    property alias pattern_dvs_dolby_vision_ramps_model: pattern_dvs_dolby_vision_ramps_model
    property alias pattern_dvs_dolby_vision_resolution_model: pattern_dvs_dolby_vision_resolution_model
    property alias pattern_dvs_hlg_model: pattern_dvs_hlg_model
    property alias pattern_dvs_hlg_clipping_color_model: pattern_dvs_hlg_clipping_color_model
    property alias pattern_dvs_hlg_evaluation_model: pattern_dvs_hlg_evaluation_model
    property alias pattern_dvs_hlg_ramps_model: pattern_dvs_hlg_ramps_model
    property alias pattern_dvs_hlg_resolution_model: pattern_dvs_hlg_resolution_model
    property alias pattern_uhd_sdr_model: pattern_uhd_sdr_model
    property alias pattern_uhd_sdr_clipping_gamma_model: pattern_uhd_sdr_clipping_gamma_model
    property alias pattern_uhd_sdr_color_bars_model: pattern_uhd_sdr_color_bars_model
    property alias pattern_uhd_sdr_color_checker_model: pattern_uhd_sdr_color_checker_model
    property alias pattern_uhd_sdr_geometry_model: pattern_uhd_sdr_geometry_model
    property alias pattern_uhd_sdr_ramps_model: pattern_uhd_sdr_ramps_model
    property alias pattern_dolby_vision_model: pattern_dolby_vision_model
    property alias pattern_hd_model: pattern_hd_model
    property alias pattern_pva_model: pattern_pva_model
    property alias pattern_spe_model: pattern_spe_model
    property alias pattern_spears_model: pattern_spears_model
    property alias pattern_user_model: pattern_user_model
    property alias pattern_user_define_model: pattern_user_define_model
    property alias pattern_user_fhd_model: pattern_user_fhd_model
    property alias pattern_user_uhd_sdr_model: pattern_user_uhd_sdr_model
    property alias pattern_shortcuts_model: pattern_shortcuts_model

    //pattern_type
    GridLayout{
        visible: pageindex == 1&&pageflag ==2?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pattern_type_model
            ListElement { first: "FPGA"; number: 1 }
            ListElement { first: "ISF"; number:2 }
            ListElement { first: "DVS HDR"; number: 3 }
            ListElement { first: "DVS Dolby Vision";number: 4 }
            ListElement { first: "DVS HLG"; number: 5 }
            ListElement { first: "UHD SDR"; number: 6 }
            ListElement { first: "Dolby Vision"; number: 7 }
            ListElement { first: "HD"; number: 8 }
            ListElement { first: "PVA";number: 9 }
            ListElement { first: "SPE";number: 10 }
            ListElement { first: "SPEARS & MUNSIL"; number: 11 }
            ListElement { first: "USER(STILLS)"; number: 12 }
            ListElement { first: "IRE WINDOW"; number: 13 }
            ListElement { first: "SHORTCUTS"; number: 14 }
        }
        Repeater{
            model: pattern_type_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: patternFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        patternFlag=number

                        pageindex = 2
                    }
                }
            }
        }

    }

    //pattern_fpga
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==1?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_fpga_model
                    ListElement { first: "img/FPGA/image01.png";second: "100% Color Bars";number: 0x0000 }
                    ListElement { first: "img/FPGA/image02.png";second: "75% Color Bars";number: 0x0001 }
                    ListElement { first: "img/FPGA/image03.png";second: "8 Step Gray Bars";number: 0x0002 }
                    ListElement { first: "img/FPGA/image04.png";second: "16 Step Gray Bars";number: 0x0003 }
                    ListElement { first: "img/FPGA/image05.png";second: "Red Screen";number: 0x0004 }
                    ListElement { first: "img/FPGA/image06.png";second: "Green Screen";number: 0x0005 }
                    ListElement { first: "img/FPGA/image07.png";second: "Blue Screen";number: 0x0006 }
                    ListElement { first: "img/FPGA/image08.png";second: "Cyan Screen";number: 0x0007 }
                    ListElement { first: "img/FPGA/image09.png";second: "Magenta Screen";number: 0x0008 }
                    ListElement { first: "img/FPGA/image10.png";second: "Yellow Screen";number: 0x0009 }

                    ListElement { first: "img/FPGA/image11.png";second: "Black Screen";number: 0x000a }
                    ListElement { first: "img/FPGA/image12.png";second: "White Screen";number: 0x000b }
                    ListElement { first: "img/FPGA/image13.png";second: "Vertical Split";number: 0x000c }
                    ListElement { first: "img/FPGA/image14.png";second: "Horizontal Split";number: 0x000d }
                    ListElement { first: "img/FPGA/image15.png";second: "Multiburst Ver.";number: 0x000e }
                    ListElement { first: "img/FPGA/image16.png";second: "Multiburst Hor.";number: 0x000f }
                    ListElement { first: "img/FPGA/image17.png";second: "Quarter Block 1";number: 0x0010 }
                    ListElement { first: "img/FPGA/image18.png";second: "Quarter Block 2";number: 0x0011 }
                    ListElement { first: "img/FPGA/image19.png";second: "Alternate W.B.";number: 0x0012 }
                    ListElement { first: "img/FPGA/image20.png";second: "RGB CMY Ramps";number: 0x0013 }

                    ListElement { first: "img/FPGA/image21.png";second: "Black Pluge";number: 0x0014 }
                    ListElement { first: "img/FPGA/image22.png";second: "White Pluge";number: 0x0015 }
                    ListElement { first: "img/FPGA/image23.png";second: "Still Gray Ramp 1";number: 0x0016 }
                    ListElement { first: "img/FPGA/image24.png";second: "Still Gray Ramp 2";number: 0x0017 }
                    ListElement { first: "img/FPGA/image25.png";second: "Smpte Bars";number: 0x0018 }
                    ListElement { first: "img/FPGA/image26.png";second: "Border Lines";number: 0x0019 }
                    ListElement { first: "img/FPGA/image27.png";second: "Window";number: 0x001a }
                    ListElement { first: "img/FPGA/image28.png";second: "3D Boxes";number: 0x001b }
                    ListElement { first: "img/FPGA/image29.png";second: "Line V.Scroll";number: 0x001c }
                    ListElement { first: "img/FPGA/image30.png";second: "Line H.Scroll";number: 0x001d }

                    ListElement { first: "img/FPGA/image31.png";second: "A/V Sync";number: 0x001e }
                    ListElement { first: "img/FPGA/image32.png";second: "Gray Ramp";number: 0x001f }
                    ListElement { first: "img/FPGA/image33.png";second: "Red Ramp";number: 0x0020 }
                    ListElement { first: "img/FPGA/image34.png";second: "Green Ramp";number: 0x0021 }
                    ListElement { first: "img/FPGA/image35.png";second: "Blue Ramp";number: 0x0022 }
                    ListElement { first: "img/FPGA/image36.png";second: "Moving Ball";number: 0x0023 }
                }
                Repeater{
                    model: pattern_fpga_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_isf
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==2?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 700
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_isf_model
                    ListElement { first: "img/ISF/image01.png";second: "White Pluge UHD";number: 0x0024 }
                    ListElement { first: "img/ISF/image02.png";second: "Black Pluge UHD";number: 0x0025 }
                    ListElement { first: "img/ISF/image03.png";second: "Geometry UHD";number: 0x0026 }
                    ListElement { first: "img/ISF/image04.png";second: "White Pluge HD";number: 0x0027 }
                    ListElement { first: "img/ISF/image05.png";second: "Black Pluge HD";number: 0x0028 }
                    ListElement { first: "img/ISF/image06.png";second: "Geometry 178 HD";number: 0x0029 }
                    ListElement { first: "img/ISF/image07.png";second: "Geometry 240 HD";number: 0x002a }
                    ListElement { first: "img/ISF/image08.png";second: "ISF Color Girls";number: 0x002b }
                    ListElement { first: "img/ISF/image09.png";second: "PD Family";number: 0x002c }
                    ListElement { first: "img/ISF/image10.png";second: "Red Blue MTB";number: 0x002d }

                    ListElement { first: "img/ISF/image11.png";second: "Cone Gradiant";number: 0x002e }
                    ListElement { first: "img/ISF/image12.png";second: "ISF Dog";number: 0x002f }
                }
                Repeater{
                    model: pattern_isf_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hdr
    property int patternDvsHdrFlag: 1
    GridLayout{
        visible: pageindex == 2&&pageflag ==2&&patternFlag ==3?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pattern_dvs_hdr_model
            ListElement { first: "CLIPPING & COLOR"; number: 1 }
            ListElement { first: "EVALUATION"; number:2 }
            ListElement { first: "GEOMETRY & CONVERGENCE"; number: 3 }
            ListElement { first: "RAMPS,GRADIENTS,ZONE PLATES";number: 4 }
            ListElement { first: "RESOLUTION,ANSI,PLACEMENT"; number: 5 }
        }
        Repeater{
            model: pattern_dvs_hdr_model
            CustomButton{
                width:btnWidth+80
                height:btnHeight
                border.color: patternDvsHdrFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        patternDvsHdrFlag=number
                        pageindex = 3
                    }
                }
            }
        }

    }

    //pattern_dvs_hdr_clipping_color
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==3&&patternDvsHdrFlag==1?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hdr_clipping_color_model
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image01.png";second: "Black Level 1";number: 0x0030 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image02.png";second: "Black Level 2";number: 0x0031 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image03.png";second: "White Level 1";number: 0x0032 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image04.png";second: "White Level 2";number: 0x0033 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image05.png";second: "White Level 3";number: 0x0034 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image06.png";second: "White 80-100";number: 0x0035 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image07.png";second: "HDR Mix";number: 0x0036 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image08.png";second: "HDR Greyscale";number: 0x0037 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image09.png";second: "HDR Red";number: 0x0038 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image10.png";second: "HDR Green";number: 0x0039 }

                    ListElement { first: "img/DVS/HDR10_CLIPPING/image11.png";second: "HDR Blue";number: 0x003a }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image12.png";second: "HDR Yellow";number: 0x003b }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image13.png";second: "HDR Cyan";number: 0x003c }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image14.png";second: "HDR Magenta";number: 0x003d }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image15.png";second: "Multi-Cube";number: 0x003e }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image16.png";second: "10 Patch Mix";number: 0x003f }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image17.png";second: "Greyscale 1000";number: 0x0040 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image18.png";second: "Greyscale 2000";number: 0x0041 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image19.png";second: "Greyscale 4000";number: 0x0042 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image20.png";second: "Greyscale 10000";number: 0x0043 }

                    ListElement { first: "img/DVS/HDR10_CLIPPING/image21.png";second: "Color High";number: 0x0044 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image22.png";second: "Color Low";number: 0x0045 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image23.png";second: "Decoding 50%";number: 0x0046 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image24.png";second: "Decoding 100%";number: 0x0047 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image25.png";second: "Blue Filter 100%";number: 0x0048 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image26.png";second: "Green Filter 100%";number: 0x0049 }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image27.png";second: "Red Filter 100%";number: 0x004a }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image28.png";second: "Blue Filter 50%";number: 0x004b }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image29.png";second: "Green Filter 50%";number: 0x004c }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image30.png";second: "Red Filter 50%";number: 0x004d }

                    ListElement { first: "img/DVS/HDR10_CLIPPING/image31.png";second: "Color Flashing";number: 0x004e }
                    ListElement { first: "img/DVS/HDR10_CLIPPING/image32.png";second: "Dynamic Contrast";number: 0x004f }
                }
                Repeater{
                    model: pattern_dvs_hdr_clipping_color_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hdr_evaluation
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==3&&patternDvsHdrFlag==2?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hdr_evaluation_model
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image01.png";second: "Landscape";number: 0x0050 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image02.png";second: "Nature";number: 0x0051 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image03.png";second: "Skin Tone";number: 0x0052 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image04.png";second: "City Sunset";number: 0x0053 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image05.png";second: "Oceanside";number: 0x0054 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image06.png";second: "Pantone Skin";number: 0x0055 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image07.png";second: "Restaurant";number: 0x0056 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image08.png";second: "Indian Market";number: 0x0057 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image09.png";second: "Ambient 05 Nit";number: 0x0058 }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image10.png";second: "Ambient 10 Nit";number: 0x0059 }

                    ListElement { first: "img/DVS/HDR10_EVALUATION/image11.png";second: "Ambient 15 Nit";number: 0x005a }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image12.png";second: "Chroma Sub 100";number: 0x005b }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image13.png";second: "Chroma Sub 500";number: 0x005c }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image14.png";second: "Chroma Sub 1000";number: 0x005d }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image15.png";second: "Judder 24 FPS";number: 0x005e }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image16.png";second: "Judder 60 FPS";number: 0x005f }
                    ListElement { first: "img/DVS/HDR10_EVALUATION/image17.png";second: "M Judder 24 FPS";number: 0x0060 }

                }
                Repeater{
                    model: pattern_dvs_hdr_evaluation_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hdr_geometry
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==3&&patternDvsHdrFlag==3?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hdr_geometry_model
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image01.png";second: "Aspect Ratio 1.78";number: 0x0061 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image02.png";second: "Aspect Ratio 1.85";number: 0x0062 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image03.png";second: "Aspect Ratio 2.00";number: 0x0063 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image04.png";second: "Aspect Ratio 2.35";number: 0x0064 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image05.png";second: "Aspect Ratio 2.40";number: 0x0065 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image06.png";second: "Aspect Ratio All";number: 0x0066 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image07.png";second: "Grid White";number: 0x0067 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image08.png";second: "Grid Red";number: 0x0068 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image09.png";second: "Grid Green";number: 0x0069 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image10.png";second: "Grid Blue";number: 0x006a }

                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image11.png";second: "Grid Yellow";number: 0x006b }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image12.png";second: "Grid Cyan";number: 0x006c }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image13.png";second: "Grid Magenta";number: 0x006d }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image14.png";second: "Dot White";number: 0x006e }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image15.png";second: "Dot Red";number: 0x006f }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image16.png";second: "Dot Green";number: 0x0070 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image17.png";second: "Dot Blue";number: 0x0071 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image18.png";second: "Dot Yellow";number: 0x0072 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image19.png";second: "Dot Cyan";number: 0x0073 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image20.png";second: "Dot Magenta";number: 0x0074 }

                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image21.png";second: "Cross White";number: 0x0075 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image22.png";second: "Cross Red";number: 0x0076 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image23.png";second: "Cross Green";number: 0x0077 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image24.png";second: "Cross Blue";number: 0x0078 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image25.png";second: "Cross Yellow";number: 0x0079 }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image26.png";second: "Cross Cyan";number: 0x007a }
                    ListElement { first: "img/DVS/HDR10_GEOMETRY/image27.png";second: "Cross Magenta";number: 0x007b }

                }
                Repeater{
                    model: pattern_dvs_hdr_geometry_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hdr_ramps
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==3&&patternDvsHdrFlag==4?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hdr_ramps_model
                    ListElement { first: "img/DVS/HDR10_RAMPS/image01.png";second: "Greyscale Steps";number: 0x007c }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image02.png";second: "Greyscale Ramp";number: 0x007d }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image03.png";second: "Greyscale Mix";number: 0x007e }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image04.png";second: "Color Steps";number: 0x007f }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image05.png";second: "Color Ramp";number: 0x0080 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image06.png";second: "Color Ramp H&V";number: 0x0081 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image07.png";second: "Color Ramp Mix";number: 0x0082 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image08.png";second: "Color Bar Ramp";number: 0x0083 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image09.png";second: "Ramp Red";number: 0x0084 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image10.png";second: "Ramp Green";number: 0x0085 }

                    ListElement { first: "img/DVS/HDR10_RAMPS/image11.png";second: "Ramp Blue";number: 0x0086 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image12.png";second: "Ramp Yellow";number: 0x0087 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image13.png";second: "Ramp Cyan";number: 0x0088 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image14.png";second: "Ramp Magenta";number: 0x0089 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image15.png";second: "Zone White";number: 0x008a }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image16.png";second: "Zone Red";number: 0x008b }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image17.png";second: "Zone Green";number: 0x008c }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image18.png";second: "Zone Blue";number: 0x008d }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image19.png";second: "Zone Magenta";number: 0x008e }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image20.png";second: "Zone Yellow";number: 0x008f }

                    ListElement { first: "img/DVS/HDR10_RAMPS/image21.png";second: "Zone Cyan";number: 0x0090 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image22.png";second: "Radial Grey";number: 0x0091 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image23.png";second: "Radial Red";number: 0x0092 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image24.png";second: "Radial Green";number: 0x0093 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image25.png";second: "Radial Blue";number: 0x0094 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image26.png";second: "Radial Yellow";number: 0x0095 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image27.png";second: "Radial Cyan";number: 0x0096 }
                    ListElement { first: "img/DVS/HDR10_RAMPS/image28.png";second: "Radial Magenta";number: 0x0097 }

                }
                Repeater{
                    model: pattern_dvs_hdr_ramps_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hdr_resolution
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==3&&patternDvsHdrFlag==5?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hdr_resolution_model
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image01.png";second: "Resolution Mix";number: 0x0098 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image02.png";second: "Checkerboard";number: 0x0099 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image03.png";second: "Horizontal 1px";number: 0x009a }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image04.png";second: "Horizontal 2px";number: 0x009b }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image05.png";second: "Horizontal 3px";number: 0x009c }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image06.png";second: "Vertical 1px";number: 0x009d }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image07.png";second: "Vertical 2px";number: 0x009e }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image08.png";second: "Vertical 3px";number: 0x009f }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image09.png";second: "Black Pixels";number: 0x00a0 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image10.png";second: "ANSI Meter 8x8";number: 0x00a1 }

                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image11.png";second: "ANSI 8x8";number: 0x00a2 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image12.png";second: "ANSI Meter 5x4";number: 0x00a3 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image13.png";second: "ANSI 5x4 Black";number: 0x00a4 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image14.png";second: "ANSI 5x4 White";number: 0x00a5 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image15.png";second: "Meter Placement";number: 0x00a6 }
                    ListElement { first: "img/DVS/HDR10_RESOLUTION/image16.png";second: "Sharp & Scan";number: 0x00a7 }

                }
                Repeater{
                    model: pattern_dvs_hdr_resolution_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_dolby_vision
    property int patternDvsDolbyVisionFlag: 1
    GridLayout{
        visible: pageindex == 2&&pageflag ==2&&patternFlag ==4?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pattern_dvs_dolby_vision_model
            ListElement { first: "CLIPPING & COLOR"; number: 1 }
            ListElement { first: "EVALUATION"; number:2 }
            ListElement { first: "RAMPS,GRADIENTS,ZONE PLATES";number: 3 }
            ListElement { first: "RESOLUTION,ANSI,PLACEMENT"; number: 4 }
        }
        Repeater{
            model: pattern_dvs_dolby_vision_model
            CustomButton{
                width:btnWidth+80
                height:btnHeight
                border.color: patternDvsDolbyVisionFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        patternDvsDolbyVisionFlag=number
                        pageindex = 3
                    }
                }
            }
        }

    }

    //pattern_dvs_dolby_vision_clipping_color
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==4&&patternDvsDolbyVisionFlag==1?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_dolby_vision_clipping_color_model
                    ListElement { first: "img/DVS/DV_CLIPPING/image01.png";second: "Black Level 1";number: 0x01d8 }
                    ListElement { first: "img/DVS/DV_CLIPPING/image02.png";second: "Black Level 2";number: 0x01d9 }
                    ListElement { first: "img/DVS/DV_CLIPPING/image03.png";second: "White Level 1";number: 0x01da }
                    ListElement { first: "img/DVS/DV_CLIPPING/image04.png";second: "White Level 2";number: 0x01db }
                    ListElement { first: "img/DVS/DV_CLIPPING/image05.png";second: "White Level 3";number: 0x01dc }
                    ListElement { first: "img/DVS/DV_CLIPPING/image06.png";second: "White 80-100";number: 0x01dd }
                    ListElement { first: "img/DVS/DV_CLIPPING/image07.png";second: "Blue Filter 50%";number: 0x01de }
                    ListElement { first: "img/DVS/DV_CLIPPING/image08.png";second: "Green Filter 50%";number: 0x01df }
                    ListElement { first: "img/DVS/DV_CLIPPING/image09.png";second: "Red Filter 50%";number: 0x01e0 }
                    ListElement { first: "img/DVS/DV_CLIPPING/image10.png";second: "Color Clipping High";number: 0x01e1 }

                    ListElement { first: "img/DVS/DV_CLIPPING/image11.png";second: "Color Clipping Low";number: 0x01e2 }
                    ListElement { first: "img/DVS/DV_CLIPPING/image12.png";second: "Color Decoding";number: 0x01e3 }
                    ListElement { first: "img/DVS/DV_CLIPPING/image13.png";second: "Color Flashing";number: 0x01e4 }
                }
                Repeater{
                    model: pattern_dvs_dolby_vision_clipping_color_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_dolby_vision_evaluation
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==4&&patternDvsDolbyVisionFlag==2?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_dolby_vision_evaluation_model
                    ListElement { first: "img/DVS/DV_EVALUATION/image01.png";second: "Landscape";number: 0x01e5 }
                    ListElement { first: "img/DVS/DV_EVALUATION/image02.png";second: "Nature";number: 0x01e6 }
                    ListElement { first: "img/DVS/DV_EVALUATION/image03.png";second: "Skin Tone";number: 0x01e7 }
                    ListElement { first: "img/DVS/DV_EVALUATION/image04.png";second: "City Sunset";number: 0x01e8 }
                    ListElement { first: "img/DVS/DV_EVALUATION/image05.png";second: "Oceanside";number: 0x01e9 }
                    ListElement { first: "img/DVS/DV_EVALUATION/image06.png";second: "Pantone Skin";number: 0x01ea }
                    ListElement { first: "img/DVS/DV_EVALUATION/image07.png";second: "Restaurant";number: 0x01eb }
                    ListElement { first: "img/DVS/DV_EVALUATION/image08.png";second: "Indian Market";number: 0x01ec }
                }
                Repeater{
                    model: pattern_dvs_dolby_vision_evaluation_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_dolby_vision_ramps
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==4&&patternDvsDolbyVisionFlag==3?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_dolby_vision_ramps_model
                    ListElement { first: "img/DVS/DV_RAMPS/image01.png";second: "Greyscale Steps";number: 0x01ed }
                    ListElement { first: "img/DVS/DV_RAMPS/image02.png";second: "Greyscale Ramp";number: 0x01ee }
                    ListElement { first: "img/DVS/DV_RAMPS/image03.png";second: "Greyscale Mix";number: 0x01ef }
                    ListElement { first: "img/DVS/DV_RAMPS/image04.png";second: "Color Steps";number: 0x01f0 }
                    ListElement { first: "img/DVS/DV_RAMPS/image05.png";second: "Red Radial Gradient";number: 0x01f1 }
                    ListElement { first: "img/DVS/DV_RAMPS/image06.png";second: "Green Radial Gradient";number: 0x01f2 }
                    ListElement { first: "img/DVS/DV_RAMPS/image07.png";second: "Blue Radial Gradient";number: 0x01f3 }
                    ListElement { first: "img/DVS/DV_RAMPS/image09.png";second: "Cyan Radial Gradient";number: 0x01f4 }
                    ListElement { first: "img/DVS/DV_RAMPS/image10.png";second: "Magenta Radial Gradient";number: 0x01f5 }
                    ListElement { first: "img/DVS/DV_RAMPS/image08.png";second: "Yellow Radial Gradient";number: 0x01f6 }
                }
                Repeater{
                    model: pattern_dvs_dolby_vision_ramps_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_dolby_vision_resolution
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==4&&patternDvsDolbyVisionFlag==4?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_dolby_vision_resolution_model
                    ListElement { first: "img/DVS/DV_RESOLUTION/image01.png";second: "ANSI Meter 8x8";number: 0x01f7 }
                    ListElement { first: "img/DVS/DV_RESOLUTION/image02.png";second: "ANSI 8x8 Black";number: 0x01f8 }
                    ListElement { first: "img/DVS/DV_RESOLUTION/image03.png";second: "ANSI 8x8 White";number: 0x01f9 }
                    ListElement { first: "img/DVS/DV_RESOLUTION/image04.png";second: "ANSI Meter 5x4";number: 0x01fa }
                    ListElement { first: "img/DVS/DV_RESOLUTION/image05.png";second: "ANSI 5x4 Black";number: 0x01fb }
                    ListElement { first: "img/DVS/DV_RESOLUTION/image06.png";second: "ANSI 5x4 White";number: 0x01fc }
                    ListElement { first: "img/DVS/DV_RESOLUTION/image07.png";second: "Meter Placement";number: 0x01fd }
                    ListElement { first: "img/DVS/DV_RESOLUTION/image08.png";second: "Sharp & Scan";number: 0x01fe }
                }
                Repeater{
                    model: pattern_dvs_dolby_vision_resolution_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hlg
    property int patternDvsHlgFlag: 1
    GridLayout{
        visible: pageindex == 2&&pageflag ==2&&patternFlag ==5?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pattern_dvs_hlg_model
            ListElement { first: "CLIPPING & COLOR"; number: 1 }
            ListElement { first: "EVALUATION"; number:2 }
            ListElement { first: "RAMPS,GRADIENTS,ZONE PLATES";number: 3 }
            ListElement { first: "RESOLUTION,ANSI,PLACEMENT"; number: 4 }
        }
        Repeater{
            model: pattern_dvs_hlg_model
            CustomButton{
                width:btnWidth+80
                height:btnHeight
                border.color: patternDvsHlgFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        patternDvsHlgFlag=number
                        pageindex = 3
                    }
                }
            }
        }

    }

    //pattern_dvs_hlg_clipping_color
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==5&&patternDvsHlgFlag==1?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hlg_clipping_color_model
                    ListElement { first: "img/DVS/HLG_CLIPPING/image01.png";second: "Black Level 1";number: 0x01ff }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image02.png";second: "Black Level 2";number: 0x0200 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image03.png";second: "White Level 1";number: 0x0201 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image04.png";second: "White Level 2";number: 0x0202 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image05.png";second: "White Level 3";number: 0x0203 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image06.png";second: "Color Flashing";number: 0x0204 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image07.png";second: "HDR Mix";number: 0x0205 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image08.png";second: "HDR Greyscale";number: 0x0206 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image09.png";second: "HDR Red";number: 0x0207 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image10.png";second: "HDR Green";number: 0x0208 }

                    ListElement { first: "img/DVS/HLG_CLIPPING/image11.png";second: "HDR Blue";number: 0x0209 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image12.png";second: "HDR Yellow";number: 0x020a }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image13.png";second: "HDR Cyan";number: 0x020b }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image14.png";second: "HDR Magenta";number: 0x020c }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image15.png";second: "Multi-Cube";number: 0x020d }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image16.png";second: "10 Patch Mix";number: 0x020e }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image17.png";second: "Color Clipping High";number: 0x020f }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image18.png";second: "Color Clipping Low";number: 0x0210 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image19.png";second: "Blue Filter 100%";number: 0x0211 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image20.png";second: "Green Filter 100%";number: 0x0212 }

                    ListElement { first: "img/DVS/HLG_CLIPPING/image21.png";second: "Red Filter 100%";number: 0x0213 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image22.png";second: "Decoding 50%";number: 0x0214 }
                    ListElement { first: "img/DVS/HLG_CLIPPING/image23.png";second: "Decoding 100%";number: 0x0215 }
                }
                Repeater{
                    model: pattern_dvs_hlg_clipping_color_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hlg_evaluation
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==5&&patternDvsHlgFlag==2?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hlg_evaluation_model
                    ListElement { first: "img/DVS/HLG_EVALUATION/image01.png";second: "Landscape";number: 0x0216 }
                    ListElement { first: "img/DVS/HLG_EVALUATION/image02.png";second: "Nature";number: 0x0217 }
                    ListElement { first: "img/DVS/HLG_EVALUATION/image03.png";second: "Skin Tone";number: 0x0218 }
                    ListElement { first: "img/DVS/HLG_EVALUATION/image04.png";second: "City Sunset";number: 0x0219 }
                    ListElement { first: "img/DVS/HLG_EVALUATION/image05.png";second: "Oceanside";number: 0x021a }
                    ListElement { first: "img/DVS/HLG_EVALUATION/image06.png";second: "Pantone Skin";number: 0x021b }
                    ListElement { first: "img/DVS/HLG_EVALUATION/image07.png";second: "Restaurant";number: 0x021c }
                    ListElement { first: "img/DVS/HLG_EVALUATION/image08.png";second: "Indian Market";number: 0x021d }
                }
                Repeater{
                    model: pattern_dvs_hlg_evaluation_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hlg_ramps
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==5&&patternDvsHlgFlag==3?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hlg_ramps_model
                    ListElement { first: "img/DVS/HLG_RAMPS/image01.png";second: "Greyscale Steps";number: 0x021e }
                    ListElement { first: "img/DVS/HLG_RAMPS/image02.png";second: "Greyscale Ramp";number: 0x021f }
                    ListElement { first: "img/DVS/HLG_RAMPS/image03.png";second: "Greyscale Mix";number: 0x0220 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image04.png";second: "Color Steps";number: 0x0221 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image05.png";second: "Color Ramp";number: 0x0222 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image06.png";second: "Color Ramp H&V";number: 0x0223 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image07.png";second: "Color Ramp Mix";number: 0x0224 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image08.png";second: "Color Bar Ramp";number: 0x0225 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image09.png";second: "Ramp Red";number: 0x0226 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image10.png";second: "Ramp Green";number: 0x0227 }

                    ListElement { first: "img/DVS/HLG_RAMPS/image11.png";second: "Ramp Blue";number: 0x0228 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image12.png";second: "Ramp Yellow";number: 0x0229 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image13.png";second: "Ramp Cyan";number: 0x022a }
                    ListElement { first: "img/DVS/HLG_RAMPS/image14.png";second: "Ramp Magenta";number: 0x022b }
                    ListElement { first: "img/DVS/HLG_RAMPS/image15.png";second: "Zone White";number: 0x022c }
                    ListElement { first: "img/DVS/HLG_RAMPS/image16.png";second: "Zone Red";number: 0x022d }
                    ListElement { first: "img/DVS/HLG_RAMPS/image17.png";second: "Zone Green";number: 0x022e }
                    ListElement { first: "img/DVS/HLG_RAMPS/image18.png";second: "Zone Blue";number: 0x022f }
                    ListElement { first: "img/DVS/HLG_RAMPS/image19.png";second: "Zone Magenta";number: 0x0230 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image20.png";second: "Zone Yellow";number: 0x0231 }

                    ListElement { first: "img/DVS/HLG_RAMPS/image21.png";second: "Zone Cyan";number: 0x0232 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image22.png";second: "Radial Grey";number: 0x0233 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image23.png";second: "Radial Red";number: 0x0234 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image24.png";second: "Radial Green";number: 0x0235 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image25.png";second: "Radial Blue";number: 0x0236 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image26.png";second: "Radial Yellow";number: 0x0237 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image27.png";second: "Radial Cyan";number: 0x0238 }
                    ListElement { first: "img/DVS/HLG_RAMPS/image28.png";second: "Radial Magenta";number: 0x0239 }
                }
                Repeater{
                    model: pattern_dvs_hlg_ramps_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dvs_hlg_resolution
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==5&&patternDvsHlgFlag==4?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dvs_hlg_resolution_model
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image01.png";second: "ANSI Meter 8x8";number: 0x023a }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image02.png";second: "ANSI 8x8 Black";number: 0x023b }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image03.png";second: "ANSI 8x8 White";number: 0x023c }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image04.png";second: "ANSI Meter 5x4";number: 0x023d }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image05.png";second: "ANSI 5x4 Black";number: 0x023e }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image06.png";second: "ANSI 5x4 White";number: 0x023f }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image07.png";second: "Meter Placement";number: 0x0240 }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image08.png";second: "Sharp & Scan";number: 0x0241 }
                    ListElement { first: "img/DVS/HLG_RESOLUTION/image09.png";second: "Resolution Mix";number: 0x0242 }

                }
                Repeater{
                    model: pattern_dvs_hlg_resolution_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_uhd_sdr
    property int patternUhdSdrFlag: 1
    GridLayout{
        visible: pageindex == 2&&pageflag ==2&&patternFlag ==6?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pattern_uhd_sdr_model
            ListElement { first: "CLIPPING & GAMMA"; number: 1 }
            ListElement { first: "COLOR BARS & NOISE"; number:2 }
            ListElement { first: "COLOR CHECKER";number: 3 }
            ListElement { first: "GEOMETRY AND RESOLUTION"; number: 4 }
            ListElement { first: "RAMPS"; number: 5 }
        }
        Repeater{
            model: pattern_uhd_sdr_model
            CustomButton{
                width:btnWidth+80
                height:btnHeight
                border.color: patternUhdSdrFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        patternUhdSdrFlag=number
                        pageindex = 3
                    }
                }
            }
        }

    }

    //pattern_uhd_sdr_clipping_gamma
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==6&&patternUhdSdrFlag==1?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_uhd_sdr_clipping_gamma_model
                    ListElement { first: "img/UHD/CLIPPING/image01.png";second: "Target Limited";number: 0x00a8 }
                    ListElement { first: "img/UHD/CLIPPING/image02.png";second: "Target Full";number: 0x00a9}
                    ListElement { first: "img/UHD/CLIPPING/image03.png";second: "Contrast Check";number: 0x00aa }
                    ListElement { first: "img/UHD/CLIPPING/image04.png";second: "Contrast Lines";number: 0x00ab }
                    ListElement { first: "img/UHD/CLIPPING/image05.png";second: "Gamma Check";number: 0x00ac }
                    ListElement { first: "img/UHD/CLIPPING/image06.png";second: "Gamma Lines";number: 0x00ad }
                    ListElement { first: "img/UHD/CLIPPING/image07.png";second: "High Clipping";number: 0x00ae }
                    ListElement { first: "img/UHD/CLIPPING/image08.png";second: "High Clip Red";number: 0x00af }
                    ListElement { first: "img/UHD/CLIPPING/image09.png";second: "High Clip Green";number: 0x00b0 }
                    ListElement { first: "img/UHD/CLIPPING/image10.png";second: "High Clip Blue";number: 0x00b1 }

                    ListElement { first: "img/UHD/CLIPPING/image11.png";second: "Low Clipping";number: 0x00b2 }
                    ListElement { first: "img/UHD/CLIPPING/image12.png";second: "Low Clip Red";number: 0x00b3 }
                    ListElement { first: "img/UHD/CLIPPING/image13.png";second: "Low Clip Green";number: 0x00b4 }
                    ListElement { first: "img/UHD/CLIPPING/image14.png";second: "Low Clip Blue";number: 0x00b5 }
                    ListElement { first: "img/UHD/CLIPPING/image15.png";second: "Composite Grey";number: 0x00b6}
                    ListElement { first: "img/UHD/CLIPPING/image16.png";second: "Composite Red";number: 0x00b7 }
                    ListElement { first: "img/UHD/CLIPPING/image17.png";second: "Composite Green";number: 0x00b8 }
                    ListElement { first: "img/UHD/CLIPPING/image18.png";second: "Composite Blue";number: 0x00b9 }
                    ListElement { first: "img/UHD/CLIPPING/image19.png";second: "Lin Step Grey";number: 0x00ba }
                    ListElement { first: "img/UHD/CLIPPING/image20.png";second: "Lin Step Red";number: 0x00bb }

                    ListElement { first: "img/UHD/CLIPPING/image21.png";second: "Lin Step Green";number: 0x00bc }
                    ListElement { first: "img/UHD/CLIPPING/image22.png";second: "Lin Step Blue";number: 0x00bd }
                    ListElement { first: "img/UHD/CLIPPING/image23.png";second: "Lin Step Magent";number: 0x00be }
                    ListElement { first: "img/UHD/CLIPPING/image24.png";second: "Lin Step Yellow";number: 0x00bf }
                    ListElement { first: "img/UHD/CLIPPING/image25.png";second: "Lin Step Cyan";number: 0x00c0}
                    ListElement { first: "img/UHD/CLIPPING/image26.png";second: "Log Step Grey";number: 0x00c1 }
                    ListElement { first: "img/UHD/CLIPPING/image27.png";second: "Log Step Red";number: 0x00c2 }
                    ListElement { first: "img/UHD/CLIPPING/image28.png";second: "Log Step Green";number: 0x00c3 }
                    ListElement { first: "img/UHD/CLIPPING/image29.png";second: "Log Step blue";number: 0x00c4 }
                    ListElement { first: "img/UHD/CLIPPING/image30.png";second: "Log Step Magent";number: 0x00c5 }

                    ListElement { first: "img/UHD/CLIPPING/image31.png";second: "Log Step Yellow";number: 0x00c6 }
                    ListElement { first: "img/UHD/CLIPPING/image32.png";second: "Log Step Cyan";number: 0x00c7 }
                    ListElement { first: "img/UHD/CLIPPING/image33.png";second: "Gamma Grey";number: 0x00c8 }
                    ListElement { first: "img/UHD/CLIPPING/image34.png";second: "Gamma Red";number: 0x00c9 }
                    ListElement { first: "img/UHD/CLIPPING/image35.png";second: "Gamma Green";number: 0x00ca}
                    ListElement { first: "img/UHD/CLIPPING/image36.png";second: "Gamma Blue";number: 0x00cb }
                    ListElement { first: "img/UHD/CLIPPING/image37.png";second: "Gamma Lines Grey";number: 0x00cc }
                    ListElement { first: "img/UHD/CLIPPING/image38.png";second: "Gamma Lines Red";number: 0x00cd }
                    ListElement { first: "img/UHD/CLIPPING/image39.png";second: "Gamma Lines Green";number: 0x00ce }
                    ListElement { first: "img/UHD/CLIPPING/image40.png";second: "Gamma Lines Blue";number: 0x00cf }


                }
                Repeater{
                    model: pattern_uhd_sdr_clipping_gamma_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_uhd_sdr_color_bars
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==6&&patternUhdSdrFlag==2?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_uhd_sdr_color_bars_model
                    ListElement { first: "img/UHD/COLOR BARS/image01.png";second: "Color Wipe Full";number: 0x00d0 }
                    ListElement { first: "img/UHD/COLOR BARS/image02.png";second: "Color Wipe Half";number: 0x00d1}
                    ListElement { first: "img/UHD/COLOR BARS/image03.png";second: "Quick Check";number: 0x00d2 }
                    ListElement { first: "img/UHD/COLOR BARS/image04.png";second: "H Bars RGB";number: 0x00d3 }
                    ListElement { first: "img/UHD/COLOR BARS/image05.png";second: "H Bars RGBCMY";number: 0x00d4 }
                    ListElement { first: "img/UHD/COLOR BARS/image06.png";second: "H Bars Layover";number: 0x00d5 }
                    ListElement { first: "img/UHD/COLOR BARS/image07.png";second: "H Bars Shade";number: 0x00d6 }
                    ListElement { first: "img/UHD/COLOR BARS/image08.png";second: "V Bars RGB";number: 0x00d7}
                    ListElement { first: "img/UHD/COLOR BARS/image09.png";second: "V Bars RGBCMY";number: 0x00d8}
                    ListElement { first: "img/UHD/COLOR BARS/image10.png";second: "V Bars Layover";number: 0x00d9 }

                    ListElement { first: "img/UHD/COLOR BARS/image11.png";second: "V Bars Shade";number: 0x00da }
                    ListElement { first: "img/UHD/COLOR BARS/image12.png";second: "Color Noise 01";number: 0x00db }
                    ListElement { first: "img/UHD/COLOR BARS/image13.png";second: "Color Noise 02";number: 0x00dc }
                    ListElement { first: "img/UHD/COLOR BARS/image14.png";second: "Color Noise 04";number: 0x00dd }
                    ListElement { first: "img/UHD/COLOR BARS/image15.png";second: "Color Noise 08";number: 0x00de}
                    ListElement { first: "img/UHD/COLOR BARS/image16.png";second: "Color Noise 16";number: 0x00df }
                    ListElement { first: "img/UHD/COLOR BARS/image17.png";second: "Grey Moise 01";number: 0x00e0 }
                    ListElement { first: "img/UHD/COLOR BARS/image18.png";second: "Grey Moise 02";number: 0x00e1 }
                    ListElement { first: "img/UHD/COLOR BARS/image19.png";second: "Grey Moise 04";number: 0x00e2 }
                    ListElement { first: "img/UHD/COLOR BARS/image20.png";second: "Grey Moise 08";number: 0x00e3 }

                    ListElement { first: "img/UHD/COLOR BARS/image21.png";second: "Grey Moise 16";number: 0x00e4 }

                }
                Repeater{
                    model: pattern_uhd_sdr_color_bars_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_uhd_sdr_color_checker
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==6&&patternUhdSdrFlag==3?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_uhd_sdr_color_checker_model
                    ListElement { first: "img/UHD/COLOR CHECKER/image01.png";second: "HSL BlueMagenta";number: 0x00e5 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image02.png";second: "HSL Blue";number: 0x00e6}
                    ListElement { first: "img/UHD/COLOR CHECKER/image03.png";second: "HSL Cyan Blue";number: 0x00e7 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image04.png";second: "HSL Cyan";number: 0x00e8 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image05.png";second: "HSL Green Cyan";number: 0x00e9 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image06.png";second: "HSL Green";number: 0x00ea }
                    ListElement { first: "img/UHD/COLOR CHECKER/image07.png";second: "HSL Magenta Red";number: 0x00eb }
                    ListElement { first: "img/UHD/COLOR CHECKER/image08.png";second: "HSL Magenta";number: 0x00ec}
                    ListElement { first: "img/UHD/COLOR CHECKER/image09.png";second: "HSL Red";number: 0x00ed}
                    ListElement { first: "img/UHD/COLOR CHECKER/image10.png";second: "HSL Yellow Green";number: 0x00ee }

                    ListElement { first: "img/UHD/COLOR CHECKER/image11.png";second: "HSL Yellow Red";number: 0x00ef }
                    ListElement { first: "img/UHD/COLOR CHECKER/image12.png";second: "HSL Yellow";number: 0x00f0 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image13.png";second: "HSV BlueMagenta";number: 0x00f1 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image14.png";second: "HSV Blue";number: 0x00f2 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image15.png";second: "HSV Cyan Blue";number: 0x00f3}
                    ListElement { first: "img/UHD/COLOR CHECKER/image16.png";second: "HSV Cyan";number: 0x00f4 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image17.png";second: "HSV Green Cyan";number: 0x00f5 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image18.png";second: "HSV Green";number: 0x00f6 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image19.png";second: "HSV Magenta Red";number: 0x00f7 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image20.png";second: "HSV Magenta";number: 0x00f8}

                    ListElement { first: "img/UHD/COLOR CHECKER/image21.png";second: "HSV Red";number: 0x00f9 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image22.png";second: "HSV Yellow Green";number: 0x00fa }
                    ListElement { first: "img/UHD/COLOR CHECKER/image23.png";second: "HSV Yellow Red";number: 0x00fb }
                    ListElement { first: "img/UHD/COLOR CHECKER/image24.png";second: "HSV Yellow";number: 0x00fc }
                    ListElement { first: "img/UHD/COLOR CHECKER/image25.png";second: "RGB Blue 064";number: 0x00fd}
                    ListElement { first: "img/UHD/COLOR CHECKER/image26.png";second: "RGB Blue 127";number: 0x00fe }
                    ListElement { first: "img/UHD/COLOR CHECKER/image27.png";second: "RGB Blue 191";number: 0x00ff }
                    ListElement { first: "img/UHD/COLOR CHECKER/image28.png";second: "RGB Blue 255";number: 0x0100 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image29.png";second: "RGB Green 064";number: 0x0101 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image30.png";second: "RGB Green 127";number: 0x0102 }

                    ListElement { first: "img/UHD/COLOR CHECKER/image31.png";second: "RGB Green 191";number: 0x0103 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image32.png";second: "RGB Green 255";number: 0x0104 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image33.png";second: "RGB Red 064";number: 0x0105 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image34.png";second: "RGB Red 127";number: 0x0106 }
                    ListElement { first: "img/UHD/COLOR CHECKER/image35.png";second: "RGB Red 191";number: 0x0107}
                    ListElement { first: "img/UHD/COLOR CHECKER/image36.png";second: "RGB Red 255";number: 0x0108}

                }
                Repeater{
                    model: pattern_uhd_sdr_color_checker_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_uhd_sdr_geometry
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==6&&patternUhdSdrFlag==4?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_uhd_sdr_geometry_model
                    ListElement { first: "img/UHD/GEOMETRY/image01.png";second: "H Convergence";number: 0x0109 }
                    ListElement { first: "img/UHD/GEOMETRY/image02.png";second: "V Convergence";number: 0x010a}
                    ListElement { first: "img/UHD/GEOMETRY/image03.png";second: "H Length";number: 0x010b }
                    ListElement { first: "img/UHD/GEOMETRY/image04.png";second: "V Length";number: 0x010c }
                    ListElement { first: "img/UHD/GEOMETRY/image05.png";second: "Overscan";number: 0x010d }
                    ListElement { first: "img/UHD/GEOMETRY/image06.png";second: "BW Evaluation";number: 0x010e }
                    ListElement { first: "img/UHD/GEOMETRY/image07.png";second: "BW Evaluation 2";number: 0x010f }
                    ListElement { first: "img/UHD/GEOMETRY/image08.png";second: "H Wedge";number: 0x0110}
                    ListElement { first: "img/UHD/GEOMETRY/image09.png";second: "Star Burst";number: 0x0111}
                    ListElement { first: "img/UHD/GEOMETRY/image10.png";second: "V Wedge";number: 0x0112 }

                    ListElement { first: "img/UHD/GEOMETRY/image11.png";second: "H Multiburst";number: 0x0113 }
                    ListElement { first: "img/UHD/GEOMETRY/image12.png";second: "V Multiburst";number: 0x0114 }
                    ListElement { first: "img/UHD/GEOMETRY/image13.png";second: "Checkers 02";number: 0x0115 }
                    ListElement { first: "img/UHD/GEOMETRY/image14.png";second: "Checkers 04";number: 0x0116 }
                    ListElement { first: "img/UHD/GEOMETRY/image15.png";second: "Checkers 08";number: 0x0117}
                    ListElement { first: "img/UHD/GEOMETRY/image16.png";second: "Checkers 16";number: 0x0118 }
                    ListElement { first: "img/UHD/GEOMETRY/image17.png";second: "Checkers 32";number: 0x0119 }
                    ListElement { first: "img/UHD/GEOMETRY/image18.png";second: "Checkers Log";number: 0x011a }
                    ListElement { first: "img/UHD/GEOMETRY/image19.png";second: "Many Circles";number: 0x011b }
                    ListElement { first: "img/UHD/GEOMETRY/image20.png";second: "Center Circle";number: 0x011c}

                    ListElement { first: "img/UHD/GEOMETRY/image21.png";second: "Many Squares";number: 0x011d }
                    ListElement { first: "img/UHD/GEOMETRY/image22.png";second: "Grid";number: 0x011e }
                    ListElement { first: "img/UHD/GEOMETRY/image23.png";second: "H Lines 02";number: 0x011f }
                    ListElement { first: "img/UHD/GEOMETRY/image24.png";second: "H Lines 04";number: 0x0120 }
                    ListElement { first: "img/UHD/GEOMETRY/image25.png";second: "H Lines 08";number: 0x0121}
                    ListElement { first: "img/UHD/GEOMETRY/image26.png";second: "H Lines Log";number: 0x0122 }
                    ListElement { first: "img/UHD/GEOMETRY/image27.png";second: "V Lines 02";number: 0x0123 }
                    ListElement { first: "img/UHD/GEOMETRY/image28.png";second: "V Lines 04";number: 0x0124 }
                    ListElement { first: "img/UHD/GEOMETRY/image29.png";second: "V Lines 08";number: 0x0125 }
                    ListElement { first: "img/UHD/GEOMETRY/image30.png";second: "V Lines Log";number: 0x0126 }

                    ListElement { first: "img/UHD/GEOMETRY/image31.png";second: "Points 02";number: 0x0127 }
                    ListElement { first: "img/UHD/GEOMETRY/image32.png";second: "Points 04";number: 0x0128 }
                    ListElement { first: "img/UHD/GEOMETRY/image33.png";second: "Points 08";number: 0x0129 }
                    ListElement { first: "img/UHD/GEOMETRY/image34.png";second: "Points 16";number: 0x012a }
                    ListElement { first: "img/UHD/GEOMETRY/image35.png";second: "Points 32";number: 0x012b}
                    ListElement { first: "img/UHD/GEOMETRY/image36.png";second: "Squares 02";number: 0x012c}
                    ListElement { first: "img/UHD/GEOMETRY/image37.png";second: "Squares 04";number: 0x012d }
                    ListElement { first: "img/UHD/GEOMETRY/image38.png";second: "Squares 08";number: 0x012e }
                    ListElement { first: "img/UHD/GEOMETRY/image39.png";second: "Squares 16";number: 0x012f }
                    ListElement { first: "img/UHD/GEOMETRY/image40.png";second: "Squares 32";number: 0x0130 }

                }
                Repeater{
                    model: pattern_uhd_sdr_geometry_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_uhd_sdr_ramps
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==6&&patternUhdSdrFlag==5?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_uhd_sdr_ramps_model
                    ListElement { first: "img/UHD/RAMPS/image01.png";second: "Color Patch";number: 0x0131 }
                    ListElement { first: "img/UHD/RAMPS/image02.png";second: "Triangle";number: 0x0132}
                    ListElement { first: "img/UHD/RAMPS/image03.png";second: "Wireframe";number: 0x0133 }
                    ListElement { first: "img/UHD/RAMPS/image04.png";second: "Full Red";number: 0x0134 }
                    ListElement { first: "img/UHD/RAMPS/image05.png";second: "Full Green";number: 0x0135 }
                    ListElement { first: "img/UHD/RAMPS/image06.png";second: "Full Blue";number: 0x0136 }
                    ListElement { first: "img/UHD/RAMPS/image07.png";second: "Full Magenta";number: 0x0137 }
                    ListElement { first: "img/UHD/RAMPS/image08.png";second: "Full Yellow";number: 0x0138}
                    ListElement { first: "img/UHD/RAMPS/image09.png";second: "Full Cyan";number: 0x0139}
                    ListElement { first: "img/UHD/RAMPS/image10.png";second: "Full Grey";number: 0x013a }

                    ListElement { first: "img/UHD/RAMPS/image11.png";second: "Half Red";number: 0x013b }
                    ListElement { first: "img/UHD/RAMPS/image12.png";second: "Half Green";number: 0x013c}
                    ListElement { first: "img/UHD/RAMPS/image13.png";second: "Half Blue";number: 0x013d }
                    ListElement { first: "img/UHD/RAMPS/image14.png";second: "Half Magenta";number: 0x013e }
                    ListElement { first: "img/UHD/RAMPS/image15.png";second: "Half Yellow";number: 0x013f}
                    ListElement { first: "img/UHD/RAMPS/image16.png";second: "Half Cyan";number: 0x0140 }
                    ListElement { first: "img/UHD/RAMPS/image17.png";second: "HSL Sat 0.00";number: 0x0141 }
                    ListElement { first: "img/UHD/RAMPS/image18.png";second: "HSL Hue 0.00";number: 0x0142 }
                    ListElement { first: "img/UHD/RAMPS/image19.png";second: "HSL Hue 0.33";number: 0x0143 }
                    ListElement { first: "img/UHD/RAMPS/image20.png";second: "HSL Hue 0.66";number: 0x0144}

                    ListElement { first: "img/UHD/RAMPS/image21.png";second: "HSL Lev 0.25";number: 0x0145 }
                    ListElement { first: "img/UHD/RAMPS/image22.png";second: "HSL Lev 0.50";number: 0x0146 }
                    ListElement { first: "img/UHD/RAMPS/image23.png";second: "HSL Lev 0.75";number: 0x0147 }
                    ListElement { first: "img/UHD/RAMPS/image24.png";second: "HSV Sat 0.00";number: 0x0148 }
                    ListElement { first: "img/UHD/RAMPS/image25.png";second: "HSL Sat 0.50";number: 0x0149}
                    ListElement { first: "img/UHD/RAMPS/image26.png";second: "HSL Sat 1.00";number: 0x014a }
                    ListElement { first: "img/UHD/RAMPS/image27.png";second: "HSV Hue 0.00";number: 0x014b}
                    ListElement { first: "img/UHD/RAMPS/image28.png";second: "HSV Hue 0.33";number: 0x014c }
                    ListElement { first: "img/UHD/RAMPS/image29.png";second: "HSV Hue 0.66";number: 0x014d }
                    ListElement { first: "img/UHD/RAMPS/image30.png";second: "HSV Sat 0.50";number: 0x014e }

                    ListElement { first: "img/UHD/RAMPS/image31.png";second: "HSV Sat 1.00";number: 0x014f }
                    ListElement { first: "img/UHD/RAMPS/image32.png";second: "HSV Val 0.00";number: 0x0150 }
                    ListElement { first: "img/UHD/RAMPS/image33.png";second: "HSV Val 0.50";number: 0x0151 }
                    ListElement { first: "img/UHD/RAMPS/image34.png";second: "HSV Val 1.00";number: 0x0152 }
                    ListElement { first: "img/UHD/RAMPS/image35.png";second: "RGB Green 000";number: 0x0153}
                    ListElement { first: "img/UHD/RAMPS/image36.png";second: "RGB Green 127";number: 0x0154}
                    ListElement { first: "img/UHD/RAMPS/image37.png";second: "RGB Green 255";number: 0x0155 }
                    ListElement { first: "img/UHD/RAMPS/image38.png";second: "RGB Blue 000";number: 0x0156 }
                    ListElement { first: "img/UHD/RAMPS/image39.png";second: "RGB Blue 127";number: 0x0157 }
                    ListElement { first: "img/UHD/RAMPS/image40.png";second: "RGB Blue 255";number: 0x0158 }

                    ListElement { first: "img/UHD/RAMPS/image41.png";second: "RGB Red 000";number: 0x0159 }
                    ListElement { first: "img/UHD/RAMPS/image42.png";second: "RGB Red 127";number: 0x015a }
                    ListElement { first: "img/UHD/RAMPS/image43.png";second: "RGB Red 255";number: 0x015b }

                }
                Repeater{
                    model: pattern_uhd_sdr_ramps_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_dolby_vision
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==7?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_dolby_vision_model
                    ListElement { first: "img/Dolby/image01.png";second: "Dolby Vision UHD";number: 0x01a9 }
                    ListElement { first: "img/Dolby/image02.png";second: "CornerBox_UHD";number: 0x01aa }
                    ListElement { first: "img/Dolby/image03.png";second: "Checker_UHD";number: 0x01ab }
                    ListElement { first: "img/Dolby/image04.png";second: "Steps_UHD_L255rm1";number: 0x01ac }
                    ListElement { first: "img/Dolby/image05.png";second: "Steps_UHD_L255rm2";number: 0x01ad }
                    ListElement { first: "img/Dolby/image06.png";second: "Steps_UHD_noL255";number: 0x01ae }
                    ListElement { first: "img/Dolby/image07.png";second: "Ramp_UHD_L255rm1";number: 0x01af }
                    ListElement { first: "img/Dolby/image08.png";second: "Ramp_UHD_L255rm2";number: 0x01b0 }
                    ListElement { first: "img/Dolby/image09.png";second: "Ramp_UHD_noL255";number: 0x01b1 }
                    ListElement { first: "img/Dolby/image10.png";second: "Dolby Vision FHD";number: 0x01b2 }

                    ListElement { first: "img/Dolby/image02.png";second: "CornerBox_FHD";number: 0x01b3}
                    ListElement { first: "img/Dolby/image03.png";second: "Checker_FHD";number: 0x01b4 }
                    ListElement { first: "img/Dolby/image04.png";second: "Steps_FHD_L255rm1";number: 0x01b5 }
                    ListElement { first: "img/Dolby/image05.png";second: "Steps_FHD_L255rm2";number: 0x01b6 }
                    ListElement { first: "img/Dolby/image06.png";second: "Steps_FHD_noL255";number: 0x01b7 }
                    ListElement { first: "img/Dolby/image07.png";second: "Ramp_FHD_L255rm1";number: 0x01b8 }
                    ListElement { first: "img/Dolby/image08.png";second: "Ramp_FHD_L255rm2";number: 0x01b9 }
                    ListElement { first: "img/Dolby/image09.png";second: "Ramp_FHD_noL255";number: 0x01ba }
                }
                Repeater{
                    model: pattern_dolby_vision_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_hd
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==8?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_hd_model
                    ListElement { first: "img/HD/image01.png";second: "High Clipping";number: 0x015e }
                    ListElement { first: "img/HD/image02.png";second: "Low Clipping";number: 0x015f }
                    ListElement { first: "img/HD/image03.png";second: "Color Noise 01";number: 0x0160 }
                    ListElement { first: "img/HD/image04.png";second: "Color Noise 02";number: 0x0161 }
                    ListElement { first: "img/HD/image05.png";second: "Color Noise 04";number: 0x0162 }
                    ListElement { first: "img/HD/image06.png";second: "Color Noise 08";number: 0x0163 }
                    ListElement { first: "img/HD/image07.png";second: "Triangle";number: 0x0164 }
                    ListElement { first: "img/HD/image08.png";second: "Color Wipe Full";number: 0x0165 }
                    ListElement { first: "img/HD/image09.png";second: "Color Wipe Half";number: 0x0166 }
                    ListElement { first: "img/HD/image10.png";second: "Composite";number: 0x0167 }

                    ListElement { first: "img/HD/image11.png";second: "H Multiburst";number: 0x0168 }
                    ListElement { first: "img/HD/image12.png";second: "V Multiburst";number: 0x0169 }
                    ListElement { first: "img/HD/image13.png";second: "Checkers 02";number: 0x016a }
                    ListElement { first: "img/HD/image14.png";second: "Checkers 04";number: 0x016b }
                    ListElement { first: "img/HD/image15.png";second: "Checkers 08";number: 0x016c }
                    ListElement { first: "img/HD/image16.png";second: "Checkers 16";number: 0x016d }
                    ListElement { first: "img/HD/image17.png";second: "Checkers 32";number: 0x016e }
                    ListElement { first: "img/HD/image18.png";second: "Checkers Log";number: 0x016f }
                    ListElement { first: "img/HD/image19.png";second: "Many Circles";number: 0x0170 }
                    ListElement { first: "img/HD/image20.png";second: "Center Circle";number: 0x0171 }

                    ListElement { first: "img/HD/image21.png";second: "Many Squares";number: 0x0172 }
                    ListElement { first: "img/HD/image22.png";second: "Grid";number: 0x0173 }
                    ListElement { first: "img/HD/image23.png";second: "H Lines 02";number: 0x0174 }
                    ListElement { first: "img/HD/image24.png";second: "H Lines 04";number: 0x0175 }
                    ListElement { first: "img/HD/image25.png";second: "H Lines 08";number: 0x0176 }
                    ListElement { first: "img/HD/image26.png";second: "H Lines Log";number: 0x0177 }
                    ListElement { first: "img/HD/image27.png";second: "V Lines 02";number: 0x0178 }
                    ListElement { first: "img/HD/image28.png";second: "V Lines 04";number: 0x0179 }
                    ListElement { first: "img/HD/image29.png";second: "V Lines 08";number: 0x017a }
                    ListElement { first: "img/HD/image30.png";second: "V Lines Log";number: 0x017b }

                    ListElement { first: "img/HD/image31.png";second: "Geometry Points 02";number: 0x017c }
                    ListElement { first: "img/HD/image32.png";second: "Geometry Points 04";number: 0x017d }
                    ListElement { first: "img/HD/image33.png";second: "Geometry Points 08";number: 0x017e }
                    ListElement { first: "img/HD/image34.png";second: "Geometry Points 16";number: 0x017f }
                    ListElement { first: "img/HD/image35.png";second: "Geometry Points 32";number: 0x0180 }
                    ListElement { first: "img/HD/image36.png";second: "Geometry Squares 04";number: 0x0181 }
                    ListElement { first: "img/HD/image37.png";second: "Geometry Squares 08";number: 0x0182 }
                    ListElement { first: "img/HD/image38.png";second: "Geometry Squares 16";number: 0x0183 }
                    ListElement { first: "img/HD/image39.png";second: "Geometry Squares 32";number: 0x0184 }
                    ListElement { first: "img/HD/image40.png";second: "H Length";number: 0x0185 }

                    ListElement { first: "img/HD/image41.png";second: "V Length";number: 0x0186 }
                    ListElement { first: "img/HD/image42.png";second: "Overscan";number: 0x0187 }
                    ListElement { first: "img/HD/image43.png";second: "BW Evaluation 2";number: 0x0188 }
                    ListElement { first: "img/HD/image44.png";second: "BW Evaluation";number: 0x0189 }
                    ListElement { first: "img/HD/image45.png";second: "H Wedge";number: 0x018a }
                    ListElement { first: "img/HD/image46.png";second: "Star Burst";number: 0x018b }
                    ListElement { first: "img/HD/image47.png";second: "V Wedge";number: 0x018c }
                    ListElement { first: "img/HD/image48.png";second: "RGB Text";number: 0x018d }
                }
                Repeater{
                    model: pattern_hd_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_pva
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==9?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_pva_model
                    ListElement { first: "img/PVA/image01.png";second: "(BT709)";third: "White_Clipping";number: 0x01bb }
                    ListElement { first: "img/PVA/image02.png";second: "(BT709)";third: "Black_Clipping";number: 0x01bc }
                    ListElement { first: "img/PVA/image03.png";second: "(BT709)";third: "APL_W_B_Clipping";number: 0x01bd }
                    ListElement { first: "img/PVA/image04.png";second: "(BT709)";third: "Color_Clipping";number: 0x01be }
                    ListElement { first: "img/PVA/image05.png";second: "(BT709)";third: "Sharpness_Overscan";number: 0x01bf }
                    ListElement { first: "img/PVA/image06.png";second: "(BT709)";third: "Alignment";number: 0x01c0 }
                    ListElement { first: "img/PVA/image07.png";second: "(BT709)";third: "Multi_Skin_Tone";number: 0x01c1 }
                    ListElement { first: "img/PVA/image08.png";second: "(BT709)";third: "Restaurant_Scene";number: 0x01c2 }
                    ListElement { first: "img/PVA/image09.png";second: "(BT709)";third: "Skin_Tone";number: 0x01c3 }
                    ListElement { first: "img/PVA/image01.png";second: "(BT2020)";third: "White_Clipping";number: 0x0243 }

                    ListElement { first: "img/PVA/image02.png";second: "(BT2020)";third: "Black_Clipping";number: 0x0244 }
                    ListElement { first: "img/PVA/image03.png";second: "(BT2020)";third: "APL_W_B_Clipping";number: 0x0245 }
                    ListElement { first: "img/PVA/image04.png";second: "(BT2020)";third: "Color_Clipping";number: 0x0246 }
                    ListElement { first: "img/PVA/image05.png";second: "(BT2020)";third: "Sharpness_Overscan";number: 0x0247 }
                    ListElement { first: "img/PVA/image06.png";second: "(BT2020)";third: "Alignment";number: 0x0248 }
                    ListElement { first: "img/PVA/image07.png";second: "(BT2020)";third: "Multi_Skin_Tone";number: 0x0249 }
                    ListElement { first: "img/PVA/image08.png";second: "(BT2020)";third: "Restaurant_Scene";number: 0x024a }
                    ListElement { first: "img/PVA/image09.png";second: "(BT2020)";third: "Skin_Tone";number: 0x024b }

                }
                Repeater{
                    model: pattern_pva_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight+20
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        Column{
                            anchors.centerIn: parent

                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 31
                                font.family: myriadPro.name
                                font.pixelSize: 30
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                            Text {
                                text: third
                                height: 31
                                font.family: myriadPro.name
                                font.pixelSize: 30
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_spe
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==10?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:35
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_spe_model
                    ListElement { first: "img/SPE/image01.png";second: "(4:2:0)";third: "Girl";number: 0x01c4 }
                    ListElement { first: "img/SPE/image02.png";second: "(4:2:0)";third: "Women";number: 0x01c5 }
                    ListElement { first: "img/SPE/image03.png";second: "(4:2:0)";third: "Girl HDR & SDR";number: 0x01c6 }
                    ListElement { first: "img/SPE/image01.png";second: "(4:4:4 Full)";third: "Girl";number: 0x01c7 }
                    ListElement { first: "img/SPE/image02.png";second: "(4:4:4 Full)";third: "Women";number: 0x024c }
                    ListElement { first: "img/SPE/image03.png";second: "(4:4:4 Full)";third: "Girl HDR & SDR";number: 0x024d }
                    ListElement { first: "img/SPE/image01.png";second: "(4:4:4 Limit)";third: "Girl";number: 0x024e }
                    ListElement { first: "img/SPE/image02.png";second: "(4:4:4 Limit)";third: "Women";number: 0x024f }
                    ListElement { first: "img/SPE/image03.png";second: "(4:4:4 Limit)";third: "Girl HDR & SDR";number: 0x0250 }

                }
                Repeater{
                    model: pattern_spe_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight+20
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        Column{
                            anchors.centerIn: parent

                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 31
                                font.family: myriadPro.name
                                font.pixelSize: 30
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                            Text {
                                text: third
                                height: 31
                                font.family: myriadPro.name
                                font.pixelSize: 30
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }

                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_spears
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==11?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:30
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_spears_model
                    ListElement { first: "img/SPEARS/image01.png";second: "Bias_Light_10%";number: 0x01c8 }
                    ListElement { first: "img/SPEARS/image02.png";second: "Bias_Light_15%";number: 0x01c9 }
                    ListElement { first: "img/SPEARS/image03.png";second: "Framing";number: 0x01ca}
                    ListElement { first: "img/SPEARS/image04.png";second: "Hammock_24p";number: 0x01cb }
                    ListElement { first: "img/SPEARS/image05.png";second: "Hammock_30p";number: 0x01cc }
                    ListElement { first: "img/SPEARS/image06.png";second: "Hammock_60i";number: 0x01cd }
                    ListElement { first: "img/SPEARS/image07.png";second: "Mixed_Video_H_60i";number: 0x01ce }
                    ListElement { first: "img/SPEARS/image08.png";second: "Mixed_Video_V_60i";number: 0x01cf }
                    ListElement { first: "img/SPEARS/image09.png";second: "ColorTint_01_Red";number: 0x01d0 }
                    ListElement { first: "img/SPEARS/image10.png";second: "ColorTint_01_Green";number: 0x01d1 }

                    ListElement { first: "img/SPEARS/image11.png";second: "ColorTint_01_Blue";number: 0x01d2 }
                    ListElement { first: "img/SPEARS/image12.png";second: "Jaggies_Full_60i";number: 0x01d3 }
                    ListElement { first: "img/SPEARS/image13.png";second: "Ship1_60i";number: 0x01d4 }
                    ListElement { first: "img/SPEARS/image14.png";second: "Ship2_60i";number: 0x01d5 }
                    ListElement { first: "img/SPEARS/image15.png";second: "Ship3_60i";number: 0x01d6 }

                }
                Repeater{
                    model: pattern_spears_model
                    CustomButton{
                        width:patternWidth
                        height:patternHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        Column{
                            anchors.centerIn: parent

                            Image {
                                source: first
                                height: 170
                                width: 292
                                asynchronous: true
                                cache: true
                            }
                            Text {
                                text: second
                                height: 42
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_user
    property int patternUserFlag: 1
    property int patternBtnWidth: 260
    property int patternBtnHeight: 120
    GridLayout{
        visible: pageindex == 2&&pageflag ==2&&patternFlag ==12?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pattern_user_model
            ListElement { first: "USER DEFNE PATTERNS"; number: 1 }
            ListElement { first: "USER FHD PATTERNS"; number:2 }
            ListElement { first: "USER HDR PATTERNS";number: 3 }
            ListElement { first: "USER UHD SDR PATTERNS"; number: 4 }
        }
        Repeater{
            model: pattern_user_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: patternUserFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        patternUserFlag=number
                        pageindex = 3
                    }
                }
            }
        }

    }

    //pattern_user_define
    GridLayout{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==12&&patternUserFlag==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 200
        width: parent.width
        columnSpacing:150
        rowSpacing: 50
        columns: 4
        ListModel {
            id: pattern_user_define_model
            ListElement { first: "USER PATTERN 1";second: "()";number: 0x018e }
            ListElement { first: "USER PATTERN 2";second: "()";number: 0x018f}
            ListElement { first: "USER PATTERN 3";second: "()";number: 0x0190 }
            ListElement { first: "USER PATTERN 4";second: "()";number: 0x0191 }
            ListElement { first: "USER PATTERN 5";second: "()";number: 0x0192 }
            ListElement { first: "USER PATTERN 6";second: "()";number: 0x0193 }

        }
        Repeater{
            model: pattern_user_define_model
            CustomButton{
                width:patternBtnWidth
                height:patternBtnHeight
                border.color: patternIndex==number?"orange":"black"
                border.width: 4
                color: '#383838'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first
                        height: 30
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                    Text {
                        text: second
                        height: 30
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        patternIndex=number
                        confirmsignal("Pattern",number)
                    }
                }
            }
        }
    }

    //pattern_user_fhd
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==12&&patternUserFlag==2?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:80
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_user_fhd_model
                    ListElement { first: "USER FHD 1";number: 0x0251 }
                    ListElement { first: "USER FHD 2";number: 0x0252 }
                    ListElement { first: "USER FHD 3";number: 0x0253 }
                    ListElement { first: "USER FHD 4";number: 0x0254 }
                    ListElement { first: "USER FHD 5";number: 0x0255 }
                    ListElement { first: "USER FHD 6";number: 0x0256 }
                    ListElement { first: "USER FHD 7";number: 0x0257 }
                    ListElement { first: "USER FHD 8";number: 0x0258 }
                    ListElement { first: "USER FHD 9";number: 0x0259 }
                    ListElement { first: "USER FHD 10";number: 0x025a }

                    ListElement { first: "USER FHD 11";number: 0x025b }
                    ListElement { first: "USER FHD 12";number: 0x025c }
                    ListElement { first: "USER FHD 13";number: 0x025d }
                    ListElement { first: "USER FHD 14";number: 0x025e }
                    ListElement { first: "USER FHD 15";number: 0x025f }
                    ListElement { first: "USER FHD 16";number: 0x0260 }
                    ListElement { first: "USER FHD 17";number: 0x0261 }
                    ListElement { first: "USER FHD 18";number: 0x0262 }
                    ListElement { first: "USER FHD 19";number: 0x0263 }
                    ListElement { first: "USER FHD 20";number: 0x0264 }

                    ListElement { first: "USER FHD 21";number: 0x0265 }
                    ListElement { first: "USER FHD 22";number: 0x0266 }
                    ListElement { first: "USER FHD 23";number: 0x0267 }
                    ListElement { first: "USER FHD 24";number: 0x0268 }
                    ListElement { first: "USER FHD 25";number: 0x0269 }
                    ListElement { first: "USER FHD 26";number: 0x026a }
                    ListElement { first: "USER FHD 27";number: 0x026b }
                    ListElement { first: "USER FHD 28";number: 0x026c }
                    ListElement { first: "USER FHD 29";number: 0x026d }
                    ListElement { first: "USER FHD 30";number: 0x026e }

                    ListElement { first: "USER FHD 31";number: 0x026f }
                    ListElement { first: "USER FHD 32";number: 0x0270 }
                    ListElement { first: "USER FHD 33";number: 0x0271 }
                    ListElement { first: "USER FHD 34";number: 0x0272 }
                    ListElement { first: "USER FHD 35";number: 0x0273 }
                    ListElement { first: "USER FHD 36";number: 0x0274 }
                    ListElement { first: "USER FHD 37";number: 0x0275 }
                    ListElement { first: "USER FHD 38";number: 0x0276 }
                    ListElement { first: "USER FHD 39";number: 0x0277 }
                    ListElement { first: "USER FHD 40";number: 0x0278 }

                    ListElement { first: "USER FHD 41";number: 0x0279 }
                    ListElement { first: "USER FHD 42";number: 0x027a }
                    ListElement { first: "USER FHD 43";number: 0x027b }
                    ListElement { first: "USER FHD 44";number: 0x027c }
                    ListElement { first: "USER FHD 45";number: 0x027d }
                    ListElement { first: "USER FHD 46";number: 0x027e }
                    ListElement { first: "USER FHD 47";number: 0x027f }
                    ListElement { first: "USER FHD 48";number: 0x0280 }
                    ListElement { first: "USER FHD 49";number: 0x0281 }
                    ListElement { first: "USER FHD 50";number: 0x0282 }

                    ListElement { first: "USER FHD 51";number: 0x0283 }
                    ListElement { first: "USER FHD 52";number: 0x0284 }
                    ListElement { first: "USER FHD 53";number: 0x0285 }
                    ListElement { first: "USER FHD 54";number: 0x0286 }

                }
                Repeater{
                    model: pattern_user_fhd_model
                    CustomButton{
                        width:patternBtnWidth
                        height:patternBtnHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                height: 30
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_user_uhd_hdr
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==12&&patternUserFlag==3?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:80
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_user_uhd_hdr_model
                    ListElement { first: "USER UHD HDR 1";number: 0x0287 }
                    ListElement { first: "USER UHD HDR 2";number: 0x0288 }
                    ListElement { first: "USER UHD HDR 3";number: 0x0289 }
                    ListElement { first: "USER UHD HDR 4";number: 0x028a }
                    ListElement { first: "USER UHD HDR 5";number: 0x028b }
                    ListElement { first: "USER UHD HDR 6";number: 0x028c }
                    ListElement { first: "USER UHD HDR 7";number: 0x028d }
                    ListElement { first: "USER UHD HDR 8";number: 0x028e}
                    ListElement { first: "USER UHD HDR 9";number: 0x028f }
                    ListElement { first: "USER UHD HDR 10";number: 0x0290 }

                    ListElement { first: "USER UHD HDR 11";number: 0x0291 }
                    ListElement { first: "USER UHD HDR 12";number: 0x0292 }
                    ListElement { first: "USER UHD HDR 13";number: 0x0293 }
                    ListElement { first: "USER UHD HDR 14";number: 0x0294 }
                    ListElement { first: "USER UHD HDR 15";number: 0x0295 }
                    ListElement { first: "USER UHD HDR 16";number: 0x0296 }
                    ListElement { first: "USER UHD HDR 17";number: 0x0297 }
                    ListElement { first: "USER UHD HDR 18";number: 0x0298 }
                    ListElement { first: "USER UHD HDR 19";number: 0x0299 }
                    ListElement { first: "USER UHD HDR 20";number: 0x029a }

                    ListElement { first: "USER UHD HDR 21";number: 0x029b }
                    ListElement { first: "USER UHD HDR 22";number: 0x029c }
                    ListElement { first: "USER UHD HDR 23";number: 0x029d }
                    ListElement { first: "USER UHD HDR 24";number: 0x029e }
                    ListElement { first: "USER UHD HDR 25";number: 0x029f }
                    ListElement { first: "USER UHD HDR 26";number: 0x02a0 }
                    ListElement { first: "USER UHD HDR 27";number: 0x02a1 }
                    ListElement { first: "USER UHD HDR 28";number: 0x02a2 }
                    ListElement { first: "USER UHD HDR 29";number: 0x02a3 }
                    ListElement { first: "USER UHD HDR 30";number: 0x02a4 }

                    ListElement { first: "USER UHD HDR 31";number: 0x02a5 }
                    ListElement { first: "USER UHD HDR 32";number: 0x02a6 }
                    ListElement { first: "USER UHD HDR 33";number: 0x02a7 }
                    ListElement { first: "USER UHD HDR 34";number: 0x02a8 }
                    ListElement { first: "USER UHD HDR 35";number: 0x02a9 }
                    ListElement { first: "USER UHD HDR 36";number: 0x02aa }
                    ListElement { first: "USER UHD HDR 37";number: 0x02ab }
                    ListElement { first: "USER UHD HDR 38";number: 0x02ac }
                    ListElement { first: "USER UHD HDR 39";number: 0x02ad }
                    ListElement { first: "USER UHD HDR 40";number: 0x02ae }

                    ListElement { first: "USER UHD HDR 41";number: 0x02af }
                    ListElement { first: "USER UHD HDR 42";number: 0x02b0 }
                    ListElement { first: "USER UHD HDR 43";number: 0x02b1 }
                    ListElement { first: "USER UHD HDR 44";number: 0x02b2 }
                    ListElement { first: "USER UHD HDR 45";number: 0x02b3 }
                    ListElement { first: "USER UHD HDR 46";number: 0x02b4 }
                    ListElement { first: "USER UHD HDR 47";number: 0x02b5 }
                    ListElement { first: "USER UHD HDR 48";number: 0x02b6 }
                    ListElement { first: "USER UHD HDR 49";number: 0x02b7 }
                    ListElement { first: "USER UHD HDR 50";number: 0x02b8 }

                    ListElement { first: "USER UHD HDR 51";number: 0x02b9 }
                    ListElement { first: "USER UHD HDR 52";number: 0x02ba }
                    ListElement { first: "USER UHD HDR 53";number: 0x02bb }
                    ListElement { first: "USER UHD HDR 54";number: 0x02bc }

                }
                Repeater{
                    model: pattern_user_uhd_hdr_model
                    CustomButton{
                        width:patternBtnWidth
                        height:patternBtnHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                height: 30
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    //pattern_user_uhd_sdr
    Rectangle{
        visible: pageflag ==2&&pageindex == 3&&patternFlag ==12&&patternUserFlag==4?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 930
        color: "transparent"
        ScrollView{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            clip: true
            GridLayout{
                width: parent.width
                columnSpacing:80
                rowSpacing: 20
                columns: 5
                ListModel {
                    id: pattern_user_uhd_sdr_model
                    ListElement { first: "USER UHD SDR 1";number: 0x02bd }
                    ListElement { first: "USER UHD SDR 2";number: 0x02be }
                    ListElement { first: "USER UHD SDR 3";number: 0x02bf }
                    ListElement { first: "USER UHD SDR 4";number: 0x02c0 }
                    ListElement { first: "USER UHD SDR 5";number: 0x02c1 }
                    ListElement { first: "USER UHD SDR 6";number: 0x02c2}
                    ListElement { first: "USER UHD SDR 7";number: 0x02c3 }
                    ListElement { first: "USER UHD SDR 8";number: 0x02c4}
                    ListElement { first: "USER UHD SDR 9";number: 0x02c5 }
                    ListElement { first: "USER UHD SDR 10";number: 0x02c6 }

                    ListElement { first: "USER UHD SDR 11";number: 0x02c7 }
                    ListElement { first: "USER UHD SDR 12";number: 0x02c8 }
                    ListElement { first: "USER UHD SDR 13";number: 0x02c9 }
                    ListElement { first: "USER UHD SDR 14";number: 0x02ca }
                    ListElement { first: "USER UHD SDR 15";number: 0x02cb }
                    ListElement { first: "USER UHD SDR 16";number: 0x02cc }
                    ListElement { first: "USER UHD SDR 17";number: 0x02cd }
                    ListElement { first: "USER UHD SDR 18";number: 0x02ce }
                    ListElement { first: "USER UHD SDR 19";number: 0x02cf }
                    ListElement { first: "USER UHD SDR 20";number: 0x02d0 }

                    ListElement { first: "USER UHD SDR 21";number: 0x02d1 }
                    ListElement { first: "USER UHD SDR 22";number: 0x02d2 }
                    ListElement { first: "USER UHD SDR 23";number: 0x02d3 }
                    ListElement { first: "USER UHD SDR 24";number: 0x02d4 }
                    ListElement { first: "USER UHD SDR 25";number: 0x02d5 }
                    ListElement { first: "USER UHD SDR 26";number: 0x02d6 }
                    ListElement { first: "USER UHD SDR 27";number: 0x02d7 }
                    ListElement { first: "USER UHD SDR 28";number: 0x02d8 }
                    ListElement { first: "USER UHD SDR 29";number: 0x02d9 }
                    ListElement { first: "USER UHD SDR 30";number: 0x02da }

                    ListElement { first: "USER UHD SDR 31";number: 0x02db }
                    ListElement { first: "USER UHD SDR 32";number: 0x02dc }
                    ListElement { first: "USER UHD SDR 33";number: 0x02dd }
                    ListElement { first: "USER UHD SDR 34";number: 0x02de }
                    ListElement { first: "USER UHD SDR 35";number: 0x02df }
                    ListElement { first: "USER UHD SDR 36";number: 0x02e0 }
                    ListElement { first: "USER UHD SDR 37";number: 0x02e1 }
                    ListElement { first: "USER UHD SDR 38";number: 0x02e2 }
                    ListElement { first: "USER UHD SDR 39";number: 0x02e3 }
                    ListElement { first: "USER UHD SDR 40";number: 0x02e4 }

                    ListElement { first: "USER UHD SDR 41";number: 0x02e5 }
                    ListElement { first: "USER UHD SDR 42";number: 0x02e6 }
                    ListElement { first: "USER UHD SDR 43";number: 0x02e7 }
                    ListElement { first: "USER UHD SDR 44";number: 0x02e8 }
                    ListElement { first: "USER UHD SDR 45";number: 0x02e9 }
                    ListElement { first: "USER UHD SDR 46";number: 0x02ea }
                    ListElement { first: "USER UHD SDR 47";number: 0x02eb }
                    ListElement { first: "USER UHD SDR 48";number: 0x02ec }
                    ListElement { first: "USER UHD SDR 49";number: 0x02ed }
                    ListElement { first: "USER UHD SDR 50";number: 0x02ee }

                    ListElement { first: "USER UHD SDR 51";number: 0x02ef }
                    ListElement { first: "USER UHD SDR 52";number: 0x02f0 }
                    ListElement { first: "USER UHD SDR 53";number: 0x02f1 }
                    ListElement { first: "USER UHD SDR 54";number: 0x02f2 }

                }
                Repeater{
                    model: pattern_user_uhd_sdr_model
                    CustomButton{
                        width:patternBtnWidth
                        height:patternBtnHeight
                        border.color: patternIndex==number?"orange":"black"
                        border.width: 4
                        color: '#383838'
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first
                                height: 30
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter : parent.horizontalCenter
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                patternIndex=number
                                confirmsignal("Pattern",number)
                            }
                        }
                    }
                }
            }
        }
    }

    Timer{
        id:window_size_reduce
        interval: 100
        repeat: true
        onTriggered: {
            var num = Number(pattern_ire_window_size.text)-1
            if(num<0){
                num=0
            }
            pattern_ire_window_size.text = num
        }
    }
    Timer{
        id:window_size_plus
        interval: 100
        repeat: true
        onTriggered: {
            var num = Number(pattern_ire_window_size.text)+1
            if(num>100){
                num=100
            }
            pattern_ire_window_size.text = num
        }
    }

    Timer{
        id:pattern_ire_level_reduce
        interval: 100
        repeat: true
        onTriggered: {
            var num = Number(pattern_ire_level.text)-1
            if(num<0){
                num=0
            }
            pattern_ire_level.text = num
        }
    }
    Timer{
        id:pattern_ire_level_plus
        interval: 100
        repeat: true
        onTriggered: {
            var num = Number(pattern_ire_level.text)+1
            if(num>100){
                num=100
            }
            pattern_ire_level.text = num
        }
    }

    //pattern_ire_window
    Rectangle{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==13?true:false
        anchors.top: root.top
        anchors.topMargin: 150
        width: root.width
        height: 700
        color: "transparent"

        Column{
            width: parent.width

            spacing:50
            Text {
                text: qsTr("ADJUST IRE WINDOW")
                font.family: myriadPro.name
                font.pixelSize: 35
                color: "black"
                anchors.horizontalCenter : parent.horizontalCenter
            }
            Row{
                anchors.horizontalCenter : parent.horizontalCenter
                Rectangle {
                    width: 120
                    height: 40
                    color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "Window Size:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                    }
                }
                Text {
                    text: qsTr("")
                    width: 20
                    font.family: myriadPro.name
                    font.pixelSize: 26
                    color: "black"
                }
                Button{
                    text: "-"
                    width: 180
                    height: 80
                    font.pixelSize: 35
                    onClicked: {
                        var num = Number(pattern_ire_window_size.text)-1
                        if(num<0){
                            num=0
                        }
                        pattern_ire_window_size.text = num
                        confirmsignal("Pattern_ire_window",num)
                    }
                    onPressed: {
                        window_size_reduce.start()
                    }
                    onReleased: {
                        window_size_reduce.stop()
                    }
                }
                Text {
                    text: qsTr("")
                    width: 20
                    font.family: myriadPro.name
                    font.pixelSize: 26
                    color: "black"
                }
                Rectangle{
                    width: 200
                    height: 80
                    radius:5
                    color: "white"
                    Text {
                        id:pattern_ire_window_size
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "black"
                        anchors.centerIn: parent
                    }
                }
                Text {
                    text: qsTr("%")
                    anchors.verticalCenter: parent.verticalCenter
                    width: 30
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "black"
                }
                Button{
                    text: "+"
                    width: 180
                    height: 80
                    font.pixelSize: 35
                    onClicked: {
                        var num = Number(pattern_ire_window_size.text)+1
                        if(num>100){
                            num=100
                        }
                        pattern_ire_window_size.text = num
                        confirmsignal("Pattern_ire_window",num)
                    }
                    onPressed: {
                        window_size_plus.start()
                    }
                    onReleased: {
                        window_size_plus.stop()
                    }
                }
            }
            Row{
                anchors.horizontalCenter : parent.horizontalCenter
                Rectangle {
                    width: 120
                    height: 40
                    color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "IRE Level:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                    }
                }
                Text {
                    text: qsTr("")
                    width: 20
                    font.family: myriadPro.name
                    font.pixelSize: 26
                    color: "black"
                }
                Button{
                    text: "-"
                    width: 180
                    height: 80
                    font.pixelSize: btnfontsize
                    onClicked: {
                        var num = Number(pattern_ire_level.text)-1
                        if(num<0){
                            num=0
                        }
                        pattern_ire_level.text = num
                        confirmsignal("Pattern_ire_level",num)
                    }
                    onPressed: {
                        pattern_ire_level_reduce.start()
                    }
                    onReleased: {
                        pattern_ire_level_reduce.stop()
                    }
                }
                Text {
                    text: qsTr("")
                    width: 20
                    font.family: myriadPro.name
                    font.pixelSize: 26
                    color: "black"
                }
                Rectangle{
                    width: 200
                    height: 80
                    radius:5
                    color: "white"
                    Text {
                        id:pattern_ire_level
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.centerIn: parent
                    }
                }
                Text {
                    text: qsTr("")
                    width: 20
                    font.family: myriadPro.name
                    font.pixelSize: 26
                    color: "black"
                }
                Button{
                    text: "+"
                    width: 180
                    height: 80
                    font.pixelSize: btnfontsize
                    onClicked: {
                        var num = Number(pattern_ire_level.text)+1
                        if(num>255){
                            num=255
                        }
                        pattern_ire_level.text = num
                        confirmsignal("Pattern_ire_level",num)
                    }
                    onPressed: {
                        pattern_ire_level_plus.start()
                    }
                    onReleased: {
                        pattern_ire_level_plus.stop()
                    }
                }
            }
        }
    }

    //pattern_shortcuts
    GridLayout{
        visible: pageflag ==2&&pageindex == 2&&patternFlag ==14?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: pattern_shortcuts_model
            ListElement { first: "SHORTCUTS 1"; number: 0x01d7 }
            ListElement { first: "SHORTCUTS 2"; number:0x01d8 }
            ListElement { first: "SHORTCUTS 3"; number: 0x01d9 }
            ListElement { first: "SHORTCUTS 4";number: 0x01da }
            ListElement { first: "SHORTCUTS 5"; number: 0x01db }
            ListElement { first: "SHORTCUTS 6"; number: 0x01dc }
            ListElement { first: "SHORTCUTS 7"; number: 0x01dd }
            ListElement { first: "SHORTCUTS 8"; number: 0x01de }
            ListElement { first: "SHORTCUTS 9";number: 0x01df }
            ListElement { first: "SHORTCUTS 10";number: 0x01e0 }
            ListElement { first: "SHORTCUTS 11"; number: 0x01e1 }
            ListElement { first: "SHORTCUTS 12"; number: 0x01e2 }
            ListElement { first: "SHORTCUTS 13"; number: 0x01e3 }
            ListElement { first: "SHORTCUTS 14"; number: 0x01e4 }
        }
        Repeater{
            model: pattern_shortcuts_model
            CustomButton{
                width:patternBtnWidth
                height:patternBtnHeight
                border.color: patternIndex==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        patternIndex=number
                        confirmsignal("Pattern",number)
                    }
                }
            }
        }

    }

    //color space--------------------------------------------------------------
    property int colorSpaceFlag: 1
    GridLayout{
        visible: pageindex == 1&&pageflag ==3?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: color_space_model
            ListElement { first: "RGB(0-255)"; number: 0x00 }
            ListElement { first: "RGB(16-235)"; number:0x01 }
            ListElement { first: "YC 4:4:4(16-235)"; number: 0x02 }
            ListElement { first: "YC 4:2:2(16-235)";number: 0x03 }
            ListElement { first: "YC 4:2:0(16-235)"; number: 0x04 }
        }
        Repeater{
            model: color_space_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: colorSpaceFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        colorSpaceFlag=number
                        confirmsignal("ColorSpace",number)
                    }
                }
            }
        }

    }

    //bt2020--------------------------------------------------------------
    property int bt2020Flag: 1
    GridLayout{
        visible: pageindex == 1&&pageflag ==4?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: bt2020_model
            ListElement { first: "ENABLE"; number: 0x01 }
            ListElement { first: "DISABLE"; number:0x00 }
        }
        Repeater{
            model: bt2020_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: bt2020Flag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        bt2020Flag=number
                        confirmsignal("Bt2020",number)
                    }
                }
            }
        }

    }

    //color depth--------------------------------------------------------------
    property int colorDepthFlag: 1
    GridLayout{
        visible: pageindex == 1&&pageflag ==5?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: color_depth_model
            ListElement { first: "8Bit"; number: 0x00 }
            ListElement { first: "10Bit"; number:0x01 }
            ListElement { first: "12Bit"; number: 0x02 }
            ListElement { first: "16Bit";number: 0x03 }
        }
        Repeater{
            model: color_depth_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: colorDepthFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        colorDepthFlag=number
                        confirmsignal("ColorDepth",number)
                    }
                }
            }
        }

    }

    //hdcp--------------------------------------------------------------
    property int hdcpFlag: 1
    GridLayout{
        visible: pageindex == 1&&pageflag ==6?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: hdcp_model
            ListElement { first: "HDCP OFF"; number: 0x00 }
            ListElement { first: "HDCP 1.1"; number:0x01 }
            ListElement { first: "HDCP 2.2"; number: 0x02 }
            ListElement { first: "HDCP AUTO";number: 0x03 }
        }
        Repeater{
            model: hdcp_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: hdcpFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        hdcpFlag=number
                        confirmsignal("HDCP",number)
                    }
                }
            }
        }

    }

    //hdmi--------------------------------------------------------------
    property int hdmiFlag: 1
    GridLayout{
        visible: pageindex == 1&&pageflag ==7?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: hdmi_model
            ListElement { first: "DVI"; number: 0x00 }
            ListElement { first: "HDMI"; number:0x01 }
            ListElement { first: "AUTO"; number: 0x02 }
        }
        Repeater{
            model: hdmi_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: hdmiFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        hdmiFlag=number
                        confirmsignal("HDMI",number)
                    }
                }
            }
        }

    }

    //hdr--------------------------------------------------------------
    property int hdrFlag: 1
    GridLayout{
        visible: pageindex == 1&&pageflag ==8?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: hdrFlag_model
            ListElement { first: "HDR OFF(SDR)"; number: 0x00 }
            ListElement { first: "HDR-10"; number:0x01 }
            ListElement { first: "HLG"; number: 0x02 }
            ListElement { first: "HDR CUSTOM 1"; number: 0x03 }
            ListElement { first: "HDR CUSTOM 2"; number: 0x04 }
            ListElement { first: "HDR CUSTOM 3"; number: 0x05 }
            ListElement { first: "HDR CUSTOM 4"; number: 0x06 }
            ListElement { first: "HDR CUSTOM 5"; number: 0x07 }
            ListElement { first: "HDR CUSTOM 6"; number: 0x08 }
            ListElement { first: "HDR CUSTOM 7"; number: 0x09 }
            ListElement { first: "HDR CUSTOM 8"; number: 0x0a }
        }
        Repeater{
            model: hdrFlag_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: hdrFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        hdrFlag=number
                        confirmsignal("HDR",number)
                    }
                }
            }
        }
    }

    //imax enhancement--------------------------------------------------------------
    property int imaxFlag: 1
    GridLayout{
        visible: pageindex == 1&&pageflag ==9?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: imaxFlag_model
            ListElement { first: "IMAX OFF"; number: 0x00 }
            ListElement { first: "IMAX ON"; number:0x01 }
            ListElement { first: "IMAX AUTO"; number: 0x02 }
        }
        Repeater{
            model: imaxFlag_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: imaxFlag==number?"orange":"black"
                border.width: 4
                color: 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        imaxFlag=number
                        confirmsignal("IMAX",number)
                    }
                }
            }
        }

    }

    //rgb triplet--------------------------------------------------------------
    property int rgbTripletFlag: 1
//    GridLayout{
//        visible: pageindex == 1&&pageflag ==10?true:false
//        anchors.top: parent.top
//        anchors.topMargin: 150
//        width: parent.width
//        rowSpacing: 50
//        columns: 3
//        ListModel {
//            id: rgbTriplet_model
//            ListElement { first: "RGB 8 bit/YUV"; number: 1 }
//            ListElement { first: "RGB 8/10/12 bit"; number:2 }
//        }
//        Repeater{
//            model: rgbTriplet_model
//            CustomButton{
//                width:btnWidth
//                height:btnHeight
//                border.color: "black"
//                border.width: 4
//                color: 'black'
//                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
//                Column{
//                    anchors.centerIn: parent
//                    Text {
//                        text: first
//                        font.family: myriadPro.name
//                        font.pixelSize: btnfontsize
//                        color: "white"
//                        anchors.horizontalCenter : parent.horizontalCenter
//                    }
//                }

//                MouseArea{
//                    anchors.fill: parent
//                    onClicked: {
//                        rgbTripletFlag=number

//                        pageindex = 2
//                    }
//                }
//            }
//        }
//    }
    //rgb 8 bit/yuv
    property bool rgb_yuv_scroll_flag: false
    property bool rgb_yuv_mode_flag: false

    property int rgb_color_space_flag: 0
    property int rgb_color_depth_flag: 0
    RowLayout {
        visible: pageflag==10&&pageindex == 2&&rgbTripletFlag==1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 720
            width: 1400
            Column{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing:10
                //Window color setting
                Text {
                    text: "Window color setting"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row{
                    spacing: 50
                    Column{
                        Text {
                            text: "Even Pixel"
                            font.family: myriadPro.name
                            font.pixelSize: 30
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "red"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowEvenPixelRed.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowEvenPixelRed.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowEvenPixelRed
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowEvenPixelRed;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowEvenPixelRed.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            windowEvenPixelRed.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "green"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowEvenPixelGreen.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowEvenPixelGreen.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowEvenPixelGreen
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowEvenPixelGreen;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowEvenPixelGreen.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            windowEvenPixelGreen.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "blue"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowEvenPixelBlue.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowEvenPixelBlue.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowEvenPixelBlue
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowEvenPixelBlue;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowEvenPixelBlue.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            windowEvenPixelBlue.text = num
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Column{
                        Text {
                            text: "Odd Pixel"
                            font.family: myriadPro.name
                            font.pixelSize: 30
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "red"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowOddPixelRed.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowOddPixelRed.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowOddPixelRed
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowOddPixelRed;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowOddPixelRed.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            windowOddPixelRed.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "green"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowOddPixelGreen.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowOddPixelGreen.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowOddPixelGreen
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowOddPixelGreen;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowOddPixelGreen.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            windowOddPixelGreen.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    width: linewidth
                                    height: 60
                                    color: "blue"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowOddPixelBlue.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowOddPixelBlue.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowOddPixelBlue
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowOddPixelBlue;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowOddPixelBlue.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            windowOddPixelBlue.text = num
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Rectangle{
                    width: parent.width
                    height: 3
                    color: "white"
                }

                //BackGround color setting
                Text {
                    text: "BackGround color setting"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row{
                    spacing: 50
                    Column{
                        Text {
                            text: "Even Pixel"
                            font.family: myriadPro.name
                            font.pixelSize: 30
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "red"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundEvenPixelRed.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundEvenPixelRed.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundEvenPixelRed
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundEvenPixelRed;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundEvenPixelRed.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            backgroundEvenPixelRed.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    width: linewidth
                                    height: 60
                                    color: "green"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundEvenPixelGreen.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundEvenPixelGreen.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundEvenPixelGreen
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundEvenPixelGreen;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundEvenPixelGreen.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            backgroundEvenPixelGreen.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    width: linewidth
                                    height: 60
                                    color: "blue"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundEvenPixelBlue.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundEvenPixelBlue.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundEvenPixelBlue
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundEvenPixelBlue;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundEvenPixelBlue.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            backgroundEvenPixelBlue.text = num
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Column{
                        Text {
                            text: "Odd Pixel"
                            font.family: myriadPro.name
                            font.pixelSize: 30
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "red"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundOddPixelRed.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundOddPixelRed.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundOddPixelRed
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundOddPixelRed;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundOddPixelRed.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            backgroundOddPixelRed.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "green"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundOddPixelGreen.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundOddPixelGreen.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundOddPixelGreen
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundOddPixelGreen;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundOddPixelGreen.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            backgroundOddPixelGreen.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "blue"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundOddPixelBlue.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundOddPixelBlue.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundOddPixelBlue
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: text > 255 ? "red":"black"
                                        width: 60
                                        height: 60
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundOddPixelBlue;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundOddPixelBlue.text)+1
                                            if(num>255){
                                                num=255
                                            }
                                            backgroundOddPixelBlue.text = num
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                CustomButton{
                    width: parent.width
                    height: 3
                    color: "white"
                }

                Row{
                    spacing: 300
                    Column{
                        spacing: 50
                        //Window Size
                        Text {
                            text: "Window Size"
                            font.family: myriadPro.name
                            font.pixelSize: 35
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            anchors.horizontalCenter : parent.horizontalCenter

                            Button{
                                text: "-"
                                width: 100
                                height: 60
                                font.pixelSize: 30
                                onClicked: {
                                    var num = Number(rgbYuv_window_size.text)-1
                                    if(num<0){
                                        num=0
                                    }
                                    rgbYuv_window_size.text = num
                                }
                            }
                            Text {
                                text: qsTr("")
                                width: 20
                                font.family: myriadPro.name
                                font.pixelSize: 26
                                color: "black"
                            }

                            TextField {
                                id:rgbYuv_window_size
                                text: qsTr("0")
                                font.family: myriadPro.name
                                font.pixelSize: 26
                                color: text > 100 ? "red":"black"
                                width: 100
                                height: 60
                                horizontalAlignment: TextInput.AlignHCenter
                                onPressed: {
                                    currentInputField = rgbYuv_window_size;
                                    virtualKeyboard.visible = true
                                }
                            }

                            Text {
                                text: qsTr("%")
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                font.family: myriadPro.name
                                font.pixelSize: 26
                                color: "white"
                            }
                            Button{
                                text: "+"
                                width: 100
                                height: 60
                                font.pixelSize: 30
                                onClicked: {
                                    var num = Number(rgbYuv_window_size.text)+1
                                    if(num>100){
                                        num=100
                                    }
                                    rgbYuv_window_size.text = num
                                }
                            }
                        }
                    }
                    Column{
                        spacing: 10
                        //Scroll
                        Text {
                            text: "Scroll"
                            font.family: myriadPro.name
                            font.pixelSize: 35
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        RadioButton {
                            id:scroll1
                            checked: !rgb_yuv_scroll_flag
                            text: "Disable"
                            onClicked: {
                                rgb_yuv_scroll_flag = false
                            }

                            contentItem: Text
                            {
                                text: scroll1.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll1.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll1.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll1.checked?"blue":"gray"
                                    visible: scroll1.checked
                                }
                            }
                        }
                        RadioButton {
                            id:scroll2
                            checked: rgb_yuv_scroll_flag?true:false
                            text: "Enable"
                            onClicked: {
                                rgb_yuv_scroll_flag = true
                            }

                            contentItem: Text
                            {
                                text: scroll2.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll2.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll2.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll2.checked?"blue":"gray"
                                    visible: scroll2.checked
                                }
                            }
                        }

                    }
                    Column{
                        spacing: 10
                        //Mode
                        Text {
                            text: "Mode"
                            font.family: myriadPro.name
                            font.pixelSize: 30
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        RadioButton {
                            id:scroll3
                            checked: !rgb_yuv_mode_flag
                            text: "Normal"
                            onClicked: {
                                rgb_yuv_mode_flag = false
                            }

                            contentItem: Text
                            {
                                text: scroll3.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll3.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll3.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll3.checked?"blue":"gray"
                                    visible: scroll3.checked
                                }
                            }
                        }
                        RadioButton {
                            id:scroll4
                            checked: rgb_yuv_mode_flag?true:false
                            text: "DV HDR"
                            onClicked: {
                                rgb_yuv_mode_flag = true
                            }

                            contentItem: Text
                            {
                                text: scroll4.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll4.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll4.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll4.checked?"blue":"gray"
                                    visible: scroll4.checked
                                }
                            }
                        }

                    }
                }

                //UPDATE
                Button{
                    text: "UPDATE TO MACHINE"
                    width: 300
                    height: 60
                    font.family: myriadPro.name
                    font.pixelSize: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        var tmp = []
                        tmp.push(windowEvenPixelRed.text)
                        tmp.push(windowEvenPixelGreen.text)
                        tmp.push(windowEvenPixelBlue.text)

                        tmp.push(windowOddPixelRed.text)
                        tmp.push(windowOddPixelGreen.text)
                        tmp.push(windowOddPixelBlue.text)

                        tmp.push(backgroundEvenPixelRed.text)
                        tmp.push(backgroundEvenPixelGreen.text)
                        tmp.push(backgroundEvenPixelBlue.text)

                        tmp.push(backgroundOddPixelRed.text)
                        tmp.push(backgroundOddPixelGreen.text)
                        tmp.push(backgroundOddPixelBlue.text)

                        tmp.push(rgbYuv_window_size.text)

                        tmp.push(rgb_yuv_scroll_flag ? "1":"0")

                        tmp.push(rgb_yuv_mode_flag ? "1":"0")

                        confirmsignal("Rgb_YUV",tmp)
                    }
                }
            }
        }
    }
    //rgb 8/10/12 bit
    RowLayout {
//        visible: pageflag==10&&pageindex == 2&&rgbTripletFlag==2?true:false
        visible: pageflag ==10&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 780
            width: 1400
            Column{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 50
                spacing:20

                Text {
                    text: "Color Depth"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row{
                    spacing: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    //color depth
                    RadioButton {
                        id:scroll7
                        checked: rgb_color_depth_flag == 0 ?true:false
                        text: "8 bit"
                        onClicked: {
                            rgb_color_depth_flag = 0
                        }

                        contentItem: Text
                        {
                            text: scroll7.text
                            font.pixelSize:30
                            font.family: myriadPro.name
                            color: scroll7.checked?"blue":"white"
                            verticalAlignment: Text.AlignVCenter
                            anchors.left: parent.left;
                            anchors.leftMargin: 60;
                            anchors.verticalCenter: parent.verticalCenter;
                        }
                        indicator: Rectangle {
                            anchors.left: parent.left;
                            anchors.verticalCenter: parent.verticalCenter
                            width: 50;
                            height: 50
                            radius: 25
                            border.width: 1
                            border.color: scroll7.checked?"blue":"gray"
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width*0.8
                                height: parent.height*0.8
                                antialiasing: true
                                radius: width/2
                                color: scroll7.checked?"blue":"gray"
                                visible: scroll7.checked
                            }
                        }
                    }
                    RadioButton {
                        id:scroll8
                        checked: rgb_color_depth_flag == 1 ?true:false
                        text: "10 bit"
                        onClicked: {
                            rgb_color_depth_flag = 1
                        }

                        contentItem: Text
                        {
                            text: scroll8.text
                            font.pixelSize:30
                            font.family: myriadPro.name
                            color: scroll8.checked?"blue":"white"
                            verticalAlignment: Text.AlignVCenter
                            anchors.left: parent.left;
                            anchors.leftMargin: 60;
                            anchors.verticalCenter: parent.verticalCenter;
                        }
                        indicator: Rectangle {
                            anchors.left: parent.left;
                            anchors.verticalCenter: parent.verticalCenter
                            width: 50;
                            height: 50
                            radius: 25
                            border.width: 1
                            border.color: scroll8.checked?"blue":"gray"
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width*0.8
                                height: parent.height*0.8
                                antialiasing: true
                                radius: width/2
                                color: scroll8.checked?"blue":"gray"
                                visible: scroll8.checked
                            }
                        }
                    }
                    RadioButton {
                        id:scroll9
                        checked: rgb_color_depth_flag == 2 ?true:false
                        text: "12 bit"
                        onClicked: {
                            rgb_color_depth_flag = 2
                        }

                        contentItem: Text
                        {
                            text: scroll9.text
                            font.pixelSize:30
                            font.family: myriadPro.name
                            color: scroll9.checked?"blue":"white"
                            verticalAlignment: Text.AlignVCenter
                            anchors.left: parent.left;
                            anchors.leftMargin: 60;
                            anchors.verticalCenter: parent.verticalCenter;
                        }
                        indicator: Rectangle {
                            anchors.left: parent.left;
                            anchors.verticalCenter: parent.verticalCenter
                            width: 50;
                            height: 50
                            radius: 25
                            border.width: 1
                            border.color: scroll9.checked?"blue":"gray"
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width*0.8
                                height: parent.height*0.8
                                antialiasing: true
                                radius: width/2
                                color: scroll9.checked?"blue":"gray"
                                visible: scroll9.checked
                            }
                        }
                    }

                }

                Row{
                    spacing: 50
                    Column{
                        Text {
                            text: "Window color setting"
                            font.family: myriadPro.name
                            font.pixelSize: 30
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "red"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowRed.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowRed.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowRed
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        width: 60
                                        height: 60
                                        color: (scroll7.checked && text >255) || (scroll8.checked && text >1023) ||
                                               (scroll9.checked && text >4095) ? "red" : "black"
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowRed;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowRed.text)+1
                                            if(scroll7.checked && num>255){
                                                num=255
                                            }else if (scroll8.checked && num> 1023){
                                                num=1023
                                            }else if (scroll9.checked && num> 4095){
                                                num=4095
                                            }
                                            windowRed.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "green"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowGreen.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowGreen.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowGreen
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        width: 60
                                        height: 60
                                        color: (scroll7.checked && text >255) || (scroll8.checked && text >1023) ||
                                               (scroll9.checked && text >4095) ? "red" : "black"
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowGreen;
                                            virtualKeyboard.visible = true;
                                        }

                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowGreen.text)+1
                                            if(scroll7.checked && num>255){
                                                num=255
                                            }else if (scroll8.checked && num> 1023){
                                                num=1023
                                            }else if (scroll9.checked && num> 4095){
                                                num=4095
                                            }
                                            windowGreen.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "blue"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowBlue.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            windowBlue.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:windowBlue
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        width: 60
                                        height: 60
                                        color: (scroll7.checked && text >255) || (scroll8.checked && text >1023) ||
                                               (scroll9.checked && text >4095) ? "red" : "black"
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = windowBlue;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(windowBlue.text)+1
                                            if(scroll7.checked && num>255){
                                                num=255
                                            }else if (scroll8.checked && num> 1023){
                                                num=1023
                                            }else if (scroll9.checked && num> 4095){
                                                num=4095
                                            }
                                            windowBlue.text = num
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Column{
                        Text {
                            text: "Background color setting"
                            font.family: myriadPro.name
                            font.pixelSize: 30
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "red"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundRed.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundRed.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundRed
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        width: 60
                                        height: 60
                                        color: (scroll7.checked && text >255) || (scroll8.checked && text >1023) ||
                                               (scroll9.checked && text >4095) ? "red" : "black"
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundRed;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundRed.text)+1
                                            if(scroll7.checked && num>255){
                                                num=255
                                            }else if (scroll8.checked && num> 1023){
                                                num=1023
                                            }else if (scroll9.checked && num> 4095){
                                                num=4095
                                            }
                                            backgroundRed.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "green"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundGreen.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundGreen.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundGreen
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        width: 60
                                        height: 60
                                        color: (scroll7.checked && text >255) || (scroll8.checked && text >1023) ||
                                               (scroll9.checked && text >4095) ? "red" : "black"
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundGreen;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundGreen.text)+1
                                            if(scroll7.checked && num>255){
                                                num=255
                                            }else if (scroll8.checked && num> 1023){
                                                num=1023
                                            }else if (scroll9.checked && num> 4095){
                                                num=4095
                                            }

                                            backgroundGreen.text = num
                                        }
                                    }
                                }
                            }
                            Column{
                                Rectangle{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                   width: linewidth
                                    height: 60
                                    color: "blue"
                                }
                                Row{
                                    anchors.horizontalCenter : parent.horizontalCenter
                                    Button{
                                        text: "-"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundBlue.text)-1
                                            if(num<0){
                                                num=0
                                            }
                                            backgroundBlue.text = num
                                        }
                                    }
                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }

                                    TextField {
                                        id:backgroundBlue
                                        text: qsTr("0")
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        width: 60
                                        height: 60
                                        color: (scroll7.checked && text >255) || (scroll8.checked && text >1023) ||
                                               (scroll9.checked && text >4095) ? "red" : "black"
                                        horizontalAlignment: TextInput.AlignHCenter
                                        onPressed: {
                                            currentInputField = backgroundBlue;
                                            virtualKeyboard.visible = true
                                        }
                                    }

                                    Text {
                                        text: qsTr("")
                                        width: 5
                                        font.family: myriadPro.name
                                        font.pixelSize: 26
                                        color: "black"
                                    }
                                    Button{
                                        text: "+"
                                        width: 60
                                        height: 60
                                        font.pixelSize: 30
                                        onClicked: {
                                            var num = Number(backgroundBlue.text)+1
                                            if(scroll7.checked && num>255){
                                                num=255
                                            }else if (scroll8.checked && num> 1023){
                                                num=1023
                                            }else if (scroll9.checked && num> 4095){
                                                num=4095
                                            }
                                            backgroundBlue.text = num
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Rectangle{
                    width: parent.width
                    height: 3
                    color: "white"
                }

                Row{
                    spacing: 300
                    anchors.horizontalCenter: parent.horizontalCenter
                    Column{
                        spacing: 50
                        //Window Size
                        Text {
                            text: "Window Size"
                            font.family: myriadPro.name
                            font.pixelSize: 35
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Row{
                            anchors.horizontalCenter : parent.horizontalCenter

                            Button{
                                text: "-"
                                width: 100
                                height: 60
                                font.pixelSize: 30
                                onClicked: {
                                    var num = Number(rgb_window_size.text)-1
                                    if(num<0){
                                        num=0
                                    }
                                    rgb_window_size.text = num
                                }
                            }
                            Text {
                                text: qsTr("")
                                width: 20
                                font.family: myriadPro.name
                                font.pixelSize: 26
                                color: "black"
                            }

                            TextField {
                                id:rgb_window_size
                                text: qsTr("0")
                                font.family: myriadPro.name
                                font.pixelSize: 26
                                width: 100
                                height: 60
                                color: text > 100 ? "red":"black"
                                horizontalAlignment: TextInput.AlignHCenter
                                onPressed: {
                                    currentInputField = rgb_window_size;
                                    virtualKeyboard.visible = true
                                }
                            }

                            Text {
                                text: qsTr("%")
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                font.family: myriadPro.name
                                font.pixelSize: 26
                                color: "white"
                            }
                            Button{
                                text: "+"
                                width: 100
                                height: 60
                                font.pixelSize: 30
                                onClicked: {
                                    var num = Number(rgb_window_size.text)+1
                                    if(num>100){
                                        num=100
                                    }
                                    rgb_window_size.text = num
                                }
                            }
                        }
                    }
                    Column{
                        spacing: 10
                        //color space
                        Text {
                            text: "Color Space"
                            font.family: myriadPro.name
                            font.pixelSize: 35
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        RadioButton {
                            id:scroll5
                            checked: rgb_color_space_flag == 0 ?true:false
                            text: "RGB Full"
                            onClicked: {
                                rgb_color_space_flag = 0
                            }

                            contentItem: Text
                            {
                                text: scroll5.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll5.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll5.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll5.checked?"blue":"gray"
                                    visible: scroll5.checked
                                }
                            }
                        }
                        RadioButton {
                            id:scroll6
                            checked: rgb_color_space_flag == 1 ?true:false
                            text: "RGB Limited"
                            onClicked: {
                                rgb_color_space_flag = 1
                            }

                            contentItem: Text
                            {
                                text: scroll6.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll6.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll6.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll6.checked?"blue":"gray"
                                    visible: scroll6.checked
                                }
                            }
                        }

                        RadioButton {
                            id:scroll10
                            checked: rgb_color_space_flag == 2 ?true:false
                            text: "YUV444"
                            onClicked: {
                                rgb_color_space_flag = 2
                            }

                            contentItem: Text
                            {
                                text: scroll10.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll10.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll10.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll10.checked?"blue":"gray"
                                    visible: scroll10.checked
                                }
                            }
                        }

                        RadioButton {
                            id:scroll11
                            checked: rgb_color_space_flag == 3 ?true:false
                            text: "YUV422"
                            onClicked: {
                                rgb_color_space_flag = 3
                            }

                            contentItem: Text
                            {
                                text: scroll11.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll11.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll11.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll11.checked?"blue":"gray"
                                    visible: scroll11.checked
                                }
                            }
                        }

                        RadioButton {
                            id:scroll12
                            checked: rgb_color_space_flag == 4 ?true:false
                            text: "YUV420"
                            onClicked: {
                                rgb_color_space_flag = 4
                            }

                            contentItem: Text
                            {
                                text: scroll12.text
                                font.pixelSize:30
                                font.family: myriadPro.name
                                color: scroll12.checked?"blue":"white"
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left;
                                anchors.leftMargin: 60;
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                            indicator: Rectangle {
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50;
                                height: 50
                                radius: 25
                                border.width: 1
                                border.color: scroll12.checked?"blue":"gray"
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width*0.8
                                    height: parent.height*0.8
                                    antialiasing: true
                                    radius: width/2
                                    color: scroll12.checked?"blue":"gray"
                                    visible: scroll12.checked
                                }
                            }
                        }

                    }
                }

                //UPDATE
                Button{
                    text: "UPDATE TO MACHINE"
                    width: 300
                    height: 60
                    font.family: myriadPro.name
                    font.pixelSize: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        var tmp = []
                        var rgbstr1 = formatHex(parseInt(windowRed.text, 10),2*2);
                        var rgbstr2 = formatHex(parseInt(windowGreen.text, 10),2*2);
                        var rgbstr3 = formatHex(parseInt(windowBlue.text, 10),2*2);
                        var rgbstr4 = formatHex(parseInt(backgroundRed.text, 10),2*2);
                        var rgbstr5 = formatHex(parseInt(backgroundGreen.text, 10),2*2);
                        var rgbstr6 = formatHex(parseInt(backgroundBlue.text, 10),2*2);
                        var rgbstr7 = formatHex(parseInt(rgb_window_size.text, 10),2*1);
//                        tmp.push(formatHex(parseInt(windowRed.text, 10),2*2))

//                        tmp.push(windowGreen.text)
//                        tmp.push(formatHex(parseInt(windowGreen.text, 10),2*2))
//                        tmp.push(windowBlue.text)
//                        tmp.push(formatHex(parseInt(windowBlue.text, 10),2*2))

//                        tmp.push(backgroundRed.text)
//                        tmp.push(formatHex(parseInt(backgroundRed.text, 10),2*2))
//                        tmp.push(backgroundGreen.text)
//                        tmp.push(formatHex(parseInt(backgroundGreen.text, 10),2*2))
//                        tmp.push(backgroundBlue.text)
//                        tmp.push(formatHex(parseInt(backgroundBlue.text, 10),2*2))

//                        tmp.push(rgb_window_size.text)
                        var colordepthvalue = scroll7.checked ? "00" : scroll8.checked ? "01" :scroll9.checked ? "02" : "00"
//                        tmp.push(colordepthvalue)




                        var colorspacevalue = scroll6.checked ? "01" : scroll10.checked ? "02" :
                                              scroll11.checked ? "03": scroll12.checked ? "04" : "05"
//                        tmp.push(colorspacevalue)
                        var rgbstr = rgbstr1 +" "+ rgbstr2 +" "+ rgbstr3 + " " + rgbstr4+ " "+ rgbstr5+" " + rgbstr6 +" "+ rgbstr7+" " +colordepthvalue+" " + colorspacevalue;
//                        console.log(("*************"),rgbstr)

                        confirmsignal("Rgb",rgbstr)
                    }
                }
            }
        }
    }

    //timing details
    property int  timDetFlag: 1
    property int textfontsize: 35
    property int lineheight: 45
    property int linewidth: 100
    //videoclk,hactive,vactive,htoal,vtoal,hbank,vblank,hfreq,vfreq,hfrontporch,vfrontporch,hsync,vsync,scan,Hsyncpolarity,Vsyncpolarity
    property var timingdetailsType: [
        ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"],//bull
        ["59.4","1280","720","3300","750","2020","30","18","24","40","5","1760","5","0","0","0"],//1280x720@24Hz
        ["74.25","1280","720","3960","750","2680","30","18.75","25","40","5","2420","5","0","0","0"],//1280x720@25Hz
        ["74.25","1280","720","3300","750","2020","30","22.5","30","40","5","1760","5","0","0","0"],//1280x720@30Hz
        ["90.00","1280","720","2500","750","1220","30","36","48","40","5","960","5","0","0","0"],//1280x720@48Hz
        ["148.5","1920","1080","2750","1125","830","45","54","48","44","5","638","4","0","0","0"],//1920x1080@48Hz
        ["59.4","1680","720","3300","750","1620","30","18","24","40","5","1360","5","0","0","0"],//1680x720@24Hz
        ["59.4","1680","720","3168","750","1488","30","18.75","25","40","5","1228","5","0","0","0"],//1680x720@25Hz
        ["59.4","1680","720","2640","750","960","30","22.5","30","40","5","700","5","0","0","0"],//1680x720@30Hz
        ["99.0","1680","720","2750","750","1070","30","36","48","40","5","8100","5","0","0","0"],//1680x720@48Hz
        ["99.0","2560","1080","3750","1100","1190","20","26.4","24","44","5","998","5","0","0","0"],//2560x1080@24Hz
        ["90.0","2560","1080","3200","1125","640","45","28.125","25","44","5","448","4","0","0","0"],//2560x1080@25Hz
        ["118.8","2560","1080","3520","1125","960","45","33.75","30","44","5","768","4","0","0","0"],//2560x1080@30Hz
        ["198.0","2560","1080","3750","1100","1190","20","52.8","48","44","5","998","4","0","0","0"],//2560x1080@48Hz
        ["82.5","1680","720","2200","750","520","30","37.5","50","40","5","260","5","0","0","0"],//1680x720@50Hz
        ["185.62","2560","1080","3300","1125","740","45","56.25","50","44","5","548","4","0","0","0"],//2560x1080@50Hz
        ["99.0","1680","720","2200","750","520","30","45","60","40","5","260","5","0","0","0"],//1680x720@60Hz
        ["198.0","2560","1080","3300","1100","440","20","66","60","44","5","248","4","0","0","0"],//2560x1080@60Hz
        ["148.5","1920","540","2640","1225","720","22","56.25","100","44","5","528","2","1","0","0"],//1920x1080i@100Hz
        ["148.5","1280","720","1980","750","700","30","75","100","40","5","440","5","0","0","0"],//1280x720@100Hz
        ["54.0","720","576","864","625","144","49","62.5","100","64","5","12","5","0","0","0"],//"720x576_100Hz"
        ["297.0","1920","1080","2640","1125","720","45","112.5","100","40","5","528","4","0","0","0"],//"1920x1080_100Hz"
        ["165.0","1680","720","2000","825","320","105","82.5","100","40","5","60","5","0","0","0"],//"1680x720_100Hz"
        ["148.5","1920","540","2200","1125","280","22","67.5","120","44","5","88","2","1","0","0"],//1920x1080i@120Hz
        ["148.5","1280","720","1650","750","370","30","90","120","40","5","110","5","0","0","0"],//1280x720@120Hz
        ["54.0","720","480","858","525","138","45","62.937","119.88","62","6","16","9","0","0","0"],//720x480@119.88Hz
        ["297.0","1920","1080","2200","1125","280","45","135","120","44","5","88","4","0","0","0"],//1920x1080P@120Hz
        ["198.0","1680","720","2000","825","320","105","99","120","40","5","60","5","0","0","0"],//1680x720@120Hz
        ["108.0","720","576","864","625","144","49","125","200","64","5","12","5","0","0","0"],//720X576@200Hz
        ["108.0","720","480","858","525","138","45","125.874","239.76","62","6","16","9","0","0","0"],//720X480@239.76Hz
    ]


    function formatHex(decimalNumber,digits) {
        var hexString = decimalNumber.toString(16).toUpperCase();

        if (digits && hexString.length < digits) {
            hexString = hexString.padStart(digits, '0');
        }

        if (hexString.length % 2 !== 0) {
            hexString = "0" + hexString;
        }

        var formattedHexString = "";
        for (var i = hexString.length-2; i >=0; i -= 2) {
            formattedHexString += hexString.substr(i, 2) + " ";
        }


        formattedHexString = formattedHexString.trim();

        return formattedHexString;
    }

    function binaryToHex(binaryString) {
        var decimalNumber = parseInt(binaryString, 2);

        var hexString = decimalNumber.toString(16).toUpperCase();

        if (hexString.length < 2) {
            hexString = "0" + hexString;
        }

        return hexString;
    }

    function settiming(arrytiming,str){
        in_m_PCLOCK.text = arrytiming[parseInt(str, 10)][0];
        in_m_HACTIVE.text = arrytiming[parseInt(str, 10)][1];
        in_m_VACTIVE.text = arrytiming[parseInt(str, 10)][2];
        in_m_HTOTAL.text = arrytiming[parseInt(str, 10)][3];
        in_m_VTOTAL.text = arrytiming[parseInt(str, 10)][4];
        in_m_HBLANK.text = arrytiming[parseInt(str, 10)][5];
        in_m_VBLANK.text = arrytiming[parseInt(str, 10)][6];
        in_m_HFREQ.text = arrytiming[parseInt(str, 10)][7];
        in_m_VFREQ.text = arrytiming[parseInt(str, 10)][8];
        in_m_HSYNCWIDTH.text = arrytiming[parseInt(str, 10)][9];
        in_m_VSYNCWIDTH.text = arrytiming[parseInt(str, 10)][10];
        in_m_HSOFFSET.text = arrytiming[parseInt(str, 10)][11];
        in_m_VSOFFSET.text = arrytiming[parseInt(str, 10)][12];
        in_m_SCANP_P.checked = arrytiming[parseInt(str, 10)][13]==="0";
        in_m_SCANP_I.checked = arrytiming[parseInt(str, 10)][13]==="1";
        in_m_HSPOLAR_R.checked = arrytiming[parseInt(str, 10)][14]==="0";
        in_m_HSPOLAR_P.checked = arrytiming[parseInt(str, 10)][14]==="1";
        in_m_VSPOLAR_R.checked = arrytiming[parseInt(str, 10)][15]==="0";
        in_m_VSPOLAR_P.checked = arrytiming[parseInt(str, 10)][15]==="1";
    }

    function deal_timingDetails (){
        var timing_details1 =""
        if(in_m_PCLOCK.text.indexOf(".")!==-1){
            var tmp = in_m_PCLOCK.text.split(".");
            if(tmp[1].length===1){
                timing_details1 = formatHex(parseInt(tmp[0]+tmp[1].slice(0,1)+"0", 10),2*2);
            }else {
                timing_details1 = formatHex(parseInt(tmp[0]+tmp[1].slice(0,2), 10),2*2);
            }
        }else{
            timing_details1 = formatHex(parseInt(in_m_PCLOCK.text, 10),2*2);
        }

//        timing_details1 = formatHex(parseInt(in_m_PCLOCK.text*1000, 10),2*2);

        var binaryString = "00000" +
                            (in_m_VSPOLAR_R.checked ? "0" : "1") +
                            (in_m_HSPOLAR_R.checked ? "0" : "1") +
                            (in_m_SCANP_P.checked ? "0" : "1")

        var timing_details2 = binaryToHex(binaryString);

        if (timing_details2.length % 2 !== 0) {
            timing_details2 = "0" + timing_details2;
        }

        var timing_details3 = formatHex(parseInt(in_m_HACTIVE.text, 10),2*2);


        var timing_details4 = formatHex(parseInt(in_m_HBLANK.text, 10),2*2);

        var timing_details5 = formatHex(parseInt(in_m_HSYNCWIDTH.text, 10),2*2);

        var timing_details6 = formatHex(parseInt(in_m_HSOFFSET.text, 10),2*2);

        var timing_details7 = formatHex(parseInt(in_m_VACTIVE.text, 10),2*2);

        var timing_details8 = formatHex(parseInt(in_m_VBLANK.text, 10),2*2);

        var timing_details9 = formatHex(parseInt(in_m_VSYNCWIDTH.text, 10),2*2);

        var timing_details10 = formatHex(parseInt(in_m_VSOFFSET.text, 10),2*2);

        var tim_details = formatHex(parseInt(in_m_UserdefineTiming.currentIndex, 10),2*1)+ " " + timing_details1 + " " + timing_details2 + " " +
                timing_details3 + " " + timing_details4 + " " + timing_details5 + " " + timing_details6 + " " + timing_details7 + " " +
                timing_details8 + " " + timing_details9 + " " + timing_details10;

//        console.log("timingdetails:",tim_details)
//        confirmsignal("timingdetails",tim_details)

        in_m_HTOTAL.text = parseInt(in_m_HACTIVE.text, 10) + parseInt(in_m_HBLANK.text, 10);
        in_m_VTOTAL.text = parseInt(in_m_VACTIVE.text, 10) + parseInt(in_m_VBLANK.text, 10);
        in_m_HFREQ.text = (parseInt(in_m_PCLOCK.text*1000, 10) / parseInt(in_m_HTOTAL.text, 10)).toFixed(2);
        in_m_VFREQ.text = (parseInt(in_m_PCLOCK.text*1000000, 10) / (parseInt(in_m_VTOTAL.text, 10) * parseInt(in_m_HTOTAL.text, 10))).toFixed(2);
        return tim_details;

    }

    Rectangle{
        visible: pageflag ==11&&pageindex == 1?true:false
        anchors.top: root.top
        anchors.topMargin: 130
        width: root.width
        height: 1000
        color: "gray"
        border.width: 1
        border.color: "#D5DFE5"
        radius: 3

        Row{
            anchors.centerIn: parent
            spacing: 100
            width: 1500
            Column{
                spacing: 13
                width: 1000
                Row{
                    y:15
                    spacing: 120
                    Column{
                        spacing: 20
                        Row{
                            spacing: 5
                            Text{
                                id:in_textWidth
                                anchors.verticalCenter: parent.verticalCenter
                                text:"Video clk:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_PCLOCK
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 300 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_PCLOCK;
                                    virtualKeyboard.visible = true
                                }
                            }
                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                text: "MHz"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"H active:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_HACTIVE
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_HACTIVE;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"V active:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_VACTIVE
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_VACTIVE;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"H total:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_HTOTAL
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                enabled: false
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"V total:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_VTOTAL
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                enabled: false
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"H blank:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_HBLANK
                               width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_HBLANK;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"V blank:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_VBLANK
                               width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_VBLANK;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                    }//column

                    Column{
                        spacing: 10
                        Row{
                            spacing: 5
                            Text{
                                width:in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"H freq:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_HFREQ
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                enabled: false
                            }
                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                text: "KHz"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"V freq:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_VFREQ
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                enabled: false
                            }
                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Hz"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                            }
                        }

                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"HFront Porch:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_HSYNCWIDTH
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_HSYNCWIDTH;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"VFront Porch:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_VSYNCWIDTH
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_VSYNCWIDTH;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"H Sync:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_HSOFFSET
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_HSOFFSET;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            Text{
                                width: in_textWidth.width
                                anchors.verticalCenter: parent.verticalCenter
                                text:"V Sync:"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignRight
                            }
                            TextField{
                                id:in_m_VSOFFSET
                                width: linewidth
                                height: lineheight
                                text: "0"
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                horizontalAlignment: TextInput.AlignHCenter
                                color: text > 65535 ? "red" : "black"
                                onPressed: {
                                    currentInputField = in_m_VSOFFSET;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }
                    }
                    //column

                    Column{
                        width: 170
                        spacing: 10
                        GroupBox{
                            width: 300
                            title: "Scan type"
                            font.pixelSize: textfontsize
                            font.family: myriadPro.name
                            Column{
                                spacing: 10
                                RadioButton{
                                    id:in_m_SCANP_P
                                    text: "Progressive"
                                    font.pixelSize: textfontsize
                                    font.family: myriadPro.name
                                    property int index:0
                                    checked: true
                                }
                                RadioButton{
                                    id:in_m_SCANP_I
                                    text: "Interlace"
                                    font.pixelSize: textfontsize
                                    font.family: myriadPro.name
                                    property int index:1
                                    checked: false
                                }
                            }
                        }
                        GroupBox{
                            width: 300
                            title: "Sync polarity"
                            font.pixelSize: textfontsize
                            font.family: myriadPro.name
                            Column{
                                width: parent.width
                                spacing: 10
                                Item{
                                    width: parent.width
                                    height: 7
                                    Row{
                                        y:-58
                                        spacing: 17
                                        Item{
                                            width:in_textWidth2.width+8
                                            height: 1
                                        }
                                        Image{
                                            width:in_m_HSPOLAR_P.width
                                            height: width
                                            source: "img/TIMD/icon_plu.ico"
                                        }
                                        Image{
                                            width: in_m_HSPOLAR_P.width
                                            height: width
                                            source: "img/TIMD/icon1.ico"
                                        }
                                    }
                                }
                                Row{
                                    spacing: 17
                                    Text{
                                        id:in_textWidth2
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Hsync:"
                                        font.pixelSize: textfontsize
                                        font.family: myriadPro.name
                                    }
                                    Rectangle{
                                        width: children[0].width+36
                                        height: children[0].height+6
                                        border.width: 1
                                        border.color: "#D5DFE5"
                                        radius: 3
                                        color: "#00000000"
                                        Row{
                                            anchors.centerIn: parent
                                            spacing: 10
                                            RadioButton{
                                                id:in_m_HSPOLAR_P
                                                text: "+"
                                                font.pixelSize: textfontsize
                                                font.family: myriadPro.name
                                                checked: true
                                            }
                                            RadioButton{
                                                id:in_m_HSPOLAR_R
                                                text: "-"
                                                font.pixelSize: textfontsize
                                                font.family: myriadPro.name
                                                checked: false
                                            }
                                        }
                                    }
                                }
                                Row{
                                    spacing: 17
                                    Text{
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Vsync:"
                                        font.pixelSize: textfontsize
                                        font.family: myriadPro.name
                                    }
                                    Rectangle{
                                        width: children[0].width+36
                                        height: children[0].height+6
                                        border.width: 1
                                        border.color: "#D5DFE5"
                                        radius: 3
                                        color: "#00000000"
                                        Row{
                                            anchors.centerIn: parent
                                            spacing: 10
                                            RadioButton{
                                                id:in_m_VSPOLAR_P
                                                text: "+"
                                                font.pixelSize: textfontsize
                                                font.family: myriadPro.name
                                                checked: true
                                            }
                                            RadioButton{
                                                id:in_m_VSPOLAR_R
                                                text: "-"
                                                font.pixelSize: textfontsize
                                                font.family: myriadPro.name
                                                checked: false
                                            }
                                        }
                                    }
                                }
                            }//column
                        }
                        Button{
                            width: 300
                            text:"Save to Userdefine Timing"
                            font.pixelSize: textfontsize
                            font.family: myriadPro.name
                            onClicked: {
                                if((in_m_PCLOCK.text!=="")&&(in_m_SCANP_I.checked?(in_m_PCLOCK.text<=148.5):(in_m_PCLOCK.text<=297)))
                                {
//                                    saveToUserdefineTiming()
                                    in_timerSaveToUserdefine.stop()
                                    in_timerSaveToUserdefine.start()
                                }
                            }
                            Timer{
                                id:in_timerSaveToUserdefine
                                interval: 500
                                onTriggered: {
                                    console.log("Save to Userdefine Timing")
                                    var str = deal_timingDetails();
                                    var savename = "timingDetails" + (in_m_UserdefineTiming.currentIndex+1);
                                    fileManager.updateData(savename, str);
                                    fileManager.updateData("timingDetails", (in_m_UserdefineTiming.currentIndex+1));

                                }
                            }
                        }
                        Row{
                            width: 300
                            spacing: 10
                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                text: "No."
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                            }
                            ComboBox{
                                id:in_m_UserdefineTiming
                                width: parent.width-parent.children[0].width-10
                                height: lineheight
                                font.pixelSize: textfontsize
                                font.family: myriadPro.name
                                model: [
                                    "User Define 1"
                                    ,"User Define 2"
                                    ,"User Define 3"
                                    ,"User Define 4"
                                    ,"User Define 5"
                                    ,"User Define 6"
                                    ,"User Define 7"
                                    ,"User Define 8"
                                    ,"User Define 9"
                                    ,"User Define 10"
                                ]
                                delegate: ItemDelegate {
                                    width: in_m_UserdefineTiming.width
                                    contentItem: Text {
                                        text: modelData
                                        color: in_m_UserdefineTiming.highlightedIndex === index?"#5e5e5e":"black"
                                        font.pixelSize: textfontsize
                                        font.family: myriadPro.name
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    highlighted: in_m_UserdefineTiming.highlightedIndex === index
                                    background: Rectangle {
                                        implicitWidth: in_m_UserdefineTiming.width
                                        implicitHeight: 50
                                        opacity: enabled ? 1 : 0.3
                                        color: in_m_UserdefineTiming.highlightedIndex === index ? "#CCCCCC" : "#e0e0e0"
                                    }
                                }
                                onActivated: {
                                    var savename = "timingDetails" + (in_m_UserdefineTiming.currentIndex+1);
                                    var rgb = fileManager.getValue(savename);
                                    var getdata = rgb.split(" ");
                                    in_m_PCLOCK.text = parseInt(getdata[2]+getdata[1],16)/10;
                                    in_m_SCANP_P.checked = parseInt(getdata[3],16)==="0";
                                    in_m_SCANP_I.checked = parseInt(getdata[3],16)==="1";
                                    in_m_HACTIVE.text = parseInt(getdata[5]+getdata[4],16);
                                    in_m_HBLANK.text = parseInt(getdata[7]+getdata[6],16);
                                    in_m_HSYNCWIDTH.text = parseInt(getdata[9]+getdata[8],16);
                                    in_m_HSOFFSET.text = parseInt(getdata[11]+getdata[10],16);
                                    in_m_VACTIVE.text = parseInt(getdata[13]+getdata[12],16);
                                    in_m_VBLANK.text = parseInt(getdata[15]+getdata[14],16);
                                    in_m_VSYNCWIDTH.text = parseInt(getdata[17]+getdata[16],16);
                                    in_m_VSOFFSET.text = parseInt(getdata[19]+getdata[18],16);
                                    deal_timingDetails();

                                }

                            }
                        }
                    }

                }//row

                Button{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:"Update Status"
                    font.pixelSize: textfontsize
                    font.family: myriadPro.name
                    onClicked: {
                        var str = deal_timingDetails();
                        confirmsignal("timingdetails",str);

                    }
                }

                Row{
                    spacing: 50
                    Image{
                        width: 800
                        height: 300
                        source: "img/TIMD/bmp00001.bmp"
                    }

                    Image{
                        width: 650
                        height: 300
                        source: "img/TIMD/bitmap1.bmp"
                    }
                }

            }
            //column

            Column{
                spacing: 10
                Text{
                    text: "Inside Resolution:"
                    font.pixelSize: textfontsize
                    font.family: myriadPro.name
                }
                ComboBox{
                    id:in_mInsideResolution
                    width: 300
                    height: lineheight
                    font.pixelSize: textfontsize
                    font.family: myriadPro.name
                    model: [
                        ""
                        ,"1280x720_24Hz"
                        ,"1280x720_25Hz"
                        ,"1280x720_30Hz"
                        ,"1280x720_48Hz"
                        ,"1920x1080_48Hz"
                        ,"1680x720_24Hz"
                        ,"1680x720_25Hz"
                        ,"1680x720_30Hz"
                        ,"1680x720_48Hz"
                        ,"2560x1080_24Hz"
                        ,"2560x1080_25Hz"
                        ,"2560x1080_30Hz"
                        ,"2560x1080_48Hz"
                        ,"1680x720_50Hz"
                        ,"2560x1080_50Hz"
                        ,"1680x720_60Hz"
                        ,"2560x1080_60Hz"
                        ,"1920x1080i_100Hz"
                        ,"1280x720_100Hz"
                        ,"720x576_100Hz"
                        ,"1920x1080_100Hz"
                        ,"1680x720_100Hz"
                        ,"1920x1080i_120Hz"
                        ,"1280x720_120Hz"
                        ,"720x480_119.88Hz"
                        ,"1920x1080P_120Hz"
                        ,"1680x720_120Hz"
                        ,"720x576_200Hz"
                        ,"720x480_239.76Hz"
                    ]
                    delegate: ItemDelegate {
                        width: in_mInsideResolution.width
                        contentItem: Text {
                            text: modelData
                            color: in_mInsideResolution.highlightedIndex === index?"#5e5e5e":"black"
                            font.pixelSize: textfontsize
                            font.family: myriadPro.name
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: in_mInsideResolution.highlightedIndex === index
                        background: Rectangle {
                            implicitWidth: in_mInsideResolution.width
                            implicitHeight: 50
                            opacity: enabled ? 1 : 0.3
                            color: in_mInsideResolution.highlightedIndex === index ? "#CCCCCC" : "#e0e0e0"
                        }
                    }
                    onActivated: {
                        var str = in_mInsideResolution.currentIndex.toString(16).padStart(2, '0');
                        settiming(timingdetailsType,in_mInsideResolution.currentIndex)
                    }

                }
            }

        }//row



    }


}
