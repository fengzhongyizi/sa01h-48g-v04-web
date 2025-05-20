 import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
Rectangle {
    id:root
    anchors.fill: parent
    signal confirmsignal(string str,int num)

//    property alias sink_device_edid_text:sink_device_edid_text
    property alias sink_device_general_text:sink_device_general_text
    property alias sink_device_video_text:sink_device_video_text
    property alias sink_device_audio_text:sink_device_audio_text
    
    property alias arc_audio_text:arc_audio_text
    property alias arc_audio_info_text:arc_audio_info_text
    
    property alias earc_tx_latencyk_text: earc_tx_latencyk_text
    property alias earc_tx_latencyk_ms_text: earc_tx_latencyk_ms_text
    property alias earc_rx_latencyk_text: earc_rx_latencyk_text
    property alias earc_rx_latencyk_ms_text: earc_rx_latencyk_ms_text

    property int pageindex: 0
    property int pageflag: 0
    property int btnWidth: 300
    property int btnHeight: 120
    property int cellwidth: 50
    property int cellheight: 35
    property int edidrows: 32
    property int edidfontsize: 20
    property var columnArray: [
        " ","00", "01", "02", "03", "04", "05", "06", "07",
        "08", "09", "0A", "0B", "0C", "0D", "0E", "0F"
    ]

    property var rowArray: [
        "00", "10", "20", "30", "40", "50", "60", "70",
        "80", "90", "A0", "B0", "C0", "D0", "E0", "F0"
    ]

    property var edidArray: [
        "00","FF","FF","FF","FF","FF","FF","00","4D","D9","05","B9","01","01","01","01",
        "01","1F","01","03","80","7A","44","78","0A","0D","C9","A0","57","47","98","27",
        "12","48","4C","21","08","00","81","80","A9","C0","71","4F","B3","00","01","01",
        "01","01","01","01","01","01","08","E8","00","30","F2","70","5A","80","B0","58",
        "8A","00","C2","AD","42","00","00","1E","02","3A","80","18","71","38","2D","40",
        "58","2C","45","00","C2","AD","42","00","00","1E","00","00","00","FC","00","53",
        "4F","4E","59","20","54","56","20","20","2A","33","30","0A","00","00","00","FD",
        "00","17","79","0E","88","3C","00","0A","20","20","20","20","20","20","01","64",
        "02","03","5B","F0","58","61","60","5D","5E","5F","62","1F","10","14","05","13",
        "04","20","22","3C","3E","12","03","11","02","65","66","3F","40","2F","0D","7F",
        "07","15","07","50","3D","07","BC","57","06","01","67","04","03","83","0F","00",
        "00","E2","00","CB","6E","03","0C","00","30","00","B8","44","20","00","80","01",
        "02","03","04","67","D8","5D","C4","01","78","80","03","E3","05","DF","01","E4",
        "0F","03","00","30","E6","06","0D","01","A2","BE","06","01","1D","00","72","51",
        "D0","1E","20","6E","28","55","00","C2","AD","42","00","00","1E","00","00","00",
        "00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","AF",

    ]

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

    //page
    GridLayout{
        visible: pageflag == 0?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3
        ListModel {
            id: edid_model
            ListElement { first: "SINK DEVICE";second:"EDID INFO"; number: 1 }
            ListElement { first: "eARC/ARC";second:"AUDIO INFO"; number: 2 }
            ListElement { first: "ARC";second:"HPD CTL"; number: 3 }
            ListElement { first: "eARC PHYSICAL";second:"HPD CTL"; number: 4 }
            ListElement { first: "eARC HPD";second:"bit CTL"; number: 5 }
            ListElement { first: "HDMI +5V";second:"POWER CTL"; number: 6 }
            ListElement { first: "eARC TX";second:"LATENCY"; number: 7 }
//            ListElement { first: "eARC RX";second:"LATENCY"; number: 8 }
//            ListElement { first: "Send CEC";second:"Command"; number: 9 }
        }
        Repeater{
            model: edid_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: pageflag==number?"orange":"black"
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
                        anchors.horizontalCenter : parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pageflag=number
                        pageindex = 1
                    }
                }
            }
        }
    }


//    function readFile(fileUrl) {
//        var xhr = new XMLHttpRequest();
//        xhr.open("GET", fileUrl, true);
//        xhr.responseType = "arraybuffer";

//        xhr.onreadystatechange = function() {
//            if (xhr.readyState === XMLHttpRequest.DONE) {
//                if (xhr.status === 200) {
//                    if (xhr.responseType === "arraybuffer") {
//                        var buffer = xhr.response;
//                        var bytes = new Uint8Array(buffer);
//                        console.log("Binary data length:", bytes.length);
//                        // var content = new TextDecoder("utf-8").decode(bytes);
//                        // console.log("File content:", content);
//                    } else {
//                        console.log("File content:", xhr.responseText);
//                    }
//                } else {
//                    console.log("Error:", xhr.status);
//                }
//            }
//        };
//        xhr.send();
//    }

//    FileDialog {
//        id: fileDialog
//        title: "Please select a file"
//        onAccepted: {
//            var filePath = fileDialog.fileUrl.toString();
//            if (filePath.startsWith("file://")) {
////                readFile(filePath);
////                fileManager.updateData
//                console.log("filepath=",filePath)
//            } else {
////                readFile("file://" + filePath);
//            }
//        }
//    }


    function hexToBinary(hexString) {
        if (hexString === undefined || hexString === null) {
            return "";
        }
        var binaryString = "";
        for (var i = 0; i < hexString.length; i++) {
            var binaryValue = parseInt(hexString[i], 16).toString(2).padStart(4, '0');
            binaryString += binaryValue;
        }
        return binaryString;
    }

    function binaryToASCLL(binary){
        var str = "";
        var binaryString = binary.substring(1);
        for (var i = 0; i < binaryString.length; i=i+5) {
            var binaryValue = binaryString.substr(i, 5);
            var decimalValue = parseInt(binaryValue, 2);
            var asciiChar = String.fromCharCode('A'.charCodeAt(0) + decimalValue - 1);
            str += asciiChar;
        }
        return str;
    }

    function hexToASCLL(hexString) {
            var asciiString = "";
            for (var i = 0; i < hexString.length; i += 2) {
                var hexByte = hexString.substr(i, 2);
                var decimalValue = parseInt(hexByte, 16);
                asciiString += String.fromCharCode(decimalValue);
            }
            return asciiString;
        }

    function asciiToHex(asciiString) {
        var hexString = "";
        for (var i = 0; i < asciiString.length; i++) {
            var decimalValue = asciiString.charCodeAt(i);
            var hexByte = decimalValue.toString(16).toUpperCase();
            if (hexByte.length === 1) {
                hexByte = "0" + hexByte;
            }
            hexString += hexByte;
        }
        return hexString;
    }

    function generalinfo() {
        var str_general = "Manufacture's Name: " +  (binaryToASCLL(hexToBinary(edidArray[8] + edidArray[9])).toUpperCase()) + "\r\n" +
                "Product Code: " + (edidArray[0x0B]+ edidArray[0x0A])+ "\r\n" +
                "Video Signal Interface: " + ((parseInt(edidArray[0x14], 16) & 0x80) ? "Digital" : "Analog") + "\r\n" +
                "Color Bit Depth: " + ((parseInt(edidArray[0x14], 16) >> 4) & 0x07) + "-bit\r\n" +
//                "3D video: " + ((parseInt(edidArray[0x14], 16) & 0x40) ? "support" : "not support") + "\r\n" +
                "HDR: " + ((parseInt(edidArray[0x14], 16) & 0x20) ? "support" : "not support") + "\r\n";

        console.log(str_general);
        sink_device_general_text.text = str_general;
    }

    function videoinfo(){
        var str_video = "Preferred Timing:"+(parseInt(edidArray[0x14], 16))+"\r\n";
        sink_device_video_text.text =str_video;
    }

    function audioinfo(){
        var str_audio = ""
        sink_device_audio_text.text =str_audio;
    }


    //sink_device_edid_info
    Column{
        visible: pageflag==1&&pageindex == 1?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 100

        RowLayout{
            width: parent.width
            x:30
            spacing: 50
            Column{
                width: cellwidth *18
//                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Text {
                    text: "EDID Info:"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.left: parent.left
                }

                Grid {
                    columns: 17
                    rows: 1

                    Repeater {
                        model: 17
                        Rectangle {
                            width: cellwidth
                            height: cellheight
                            border.width: 1
                            border.color: "#010101"

                            Text {
                                text: columnArray[index]
                                anchors.centerIn: parent
                                font.pointSize: edidfontsize
                                font.family: myriadPro.name
                                font.bold: true
                            }
                        }
                    }
                }

                ScrollView {
                    id: scrollView
                    width: cellwidth *17+10
                    height: cellheight *16
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    RowLayout{
                        spacing: 0
                        Grid {
                            columns: 1
                            rows: edidrows

                            Repeater {
                                model: edidrows
                                Rectangle {
                                    width: cellwidth
                                    height: cellheight
                                    border.width: 1
                                    border.color: "#010101"

                                    Text {
                                        text: index.toString(16).toUpperCase().padStart(2, '0')+"0"
                                        anchors.centerIn: parent
                                        font.pointSize: edidfontsize
                                        font.family: myriadPro.name
                                        font.bold: true
                                    }
                                }
                            }
                        }

                        Grid {
                            columns: 16
                            rows: edidrows

                            Repeater {
                                model: 16*edidrows
                                Rectangle {
                                    width: cellwidth
                                    height: cellheight
                                    border.width: 1
                                    border.color: "#B5B7AC"

                                    TextField{
                                        id:edid_arry
                                        width: cellwidth
                                        height: cellheight
                                        text: index <= edidArray.length -1 ? edidArray[index]:" "
                                        font.pixelSize: edidfontsize+7
                                        font.family: myriadPro.name
                                        horizontalAlignment: TextInput.AlignHCenter
                                        color: parseInt(text,16) > 255 ? "red" : "black"
                                        topPadding: 2
                                        bottomPadding: 2
                                        validator: RegExpValidator {
                                                regExp: /^[0-9A-Fa-f]{0,2}$/
                                            }
                                        onTextEdited: {
                                            text = text.toUpperCase();
                                            edidArray[index] = text;
                                        }
                                        onEditingFinished: {
                                            text = text.toUpperCase();
                                            if(text.length===1){
                                                edidArray[index] = "0"+text;
                                            }else if(text.length===2){
                                                edidArray[index] = text;
                                            }
                                        }
                                        onPressed: {
                                            currentInputField = edid_arry;
                                            virtualKeyboard.visible = true;
                                            virtualKeyboard.numberOnly = false;

                                        }
                                    }
                                }
                            }
                        }

                    }
                }

                Item {
                    width: parent.width
                    height: 50
                }

                RowLayout{
                    spacing: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    CustomButton{
                        id:read_edid
                        width:150
                        height:80
                        border.color: "black"
                        border.width: 2
                        color: flag?'gray':'black'
                        property bool flag:false
                        Text {
                            text: qsTr("Read EDID")
                            anchors.centerIn: parent
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                read_edid.flag = true
                                confirmsignal("readEDID",1)
                            }
                            onReleased: {
                                read_edid.flag = false

                            }
                        }
                    }

                    Row{
                        width: 300
                        spacing: 10

                        ComboBox{
                            id:combobox1
                            width: 180
                            height: 80
                            font.family: myriadPro.name
                            model: [
                                "USER EDID1",
                                "USER EDID2",
                                "USER EDID3",
                                "USER EDID4",
                                "USER EDID5",
                            ]
                            font.pixelSize: btnfontsize

                            delegate: ItemDelegate {
                                width: combobox1.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox1.highlightedIndex === index?"#5e5e5e":"black"
                                    font.pixelSize: 26
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: myriadPro.name
                                }
                                highlighted: combobox1.highlightedIndex === index
                                background: Rectangle {
                                    implicitWidth: combobox1.width
                                    implicitHeight: 50
                                    opacity: enabled ? 1 : 0.3
                                    color: combobox1.highlightedIndex === index ? "#CCCCCC" : "#e0e0e0"
                                }
                            }
                        }

                        CustomButton{
                            id:save_edid
                            width:100
                            height:80
                            border.color: "black"
                            border.width: 4
                            color: flag?'gray':'black'
                            property bool flag:false
                            Text {
                                text: qsTr("Save")
                                anchors.centerIn: parent
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                            }

                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    save_edid.flag = true
                                    var useredid = "";
                                    for(var d=0;d<edidArray.length;d++){
                                        useredid+=edidArray[d]+" ";
                                    }

                                    serialPortManager.writeDataUart5("SET IN1 EDID U"+(combobox1.currentIndex+1)+" DATA "+ useredid.trim() +"\r\n",1);
                                }
                                onReleased: {
                                    save_edid.flag = false
                                    var str = "EDIDData"+combobox1.currentIndex;
                                    fileManager.updateData(str,edidArray);
                                }
                            }
                        }

                    }

                    Row{
                        width: 300
                        spacing: 10

                        ComboBox{
                            id:combobox2
                            width: 180
                            height: 80
                            font.family: myriadPro.name
                            model: [
                                "Open EDID1",
                                "Open EDID2",
                                "Open EDID3",
                                "Open EDID4",
                                "Open EDID5",
                            ]
                            font.pixelSize: btnfontsize

                            delegate: ItemDelegate {
                                width: combobox2.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox2.highlightedIndex === index?"#5e5e5e":"black"
                                    font.pixelSize: 26
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: myriadPro.name
                                }
                                highlighted: combobox2.highlightedIndex === index
                                background: Rectangle {
                                    implicitWidth: combobox2.width
                                    implicitHeight: 50
                                    opacity: enabled ? 1 : 0.3
                                    color: combobox2.highlightedIndex === index ? "#CCCCCC" : "#e0e0e0"
                                }
                            }

                        }

                        CustomButton{
                            id:open_edid
                            width:100
                            height:80
                            border.color: "black"
                            border.width: 4
                            color: flag?'gray':'black'
                            property bool flag:false
                            Text {
                                text: qsTr("Open")
                                anchors.centerIn: parent
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                            }

                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    open_edid.flag = true
                                }
                                onReleased: {
                                    open_edid.flag = false
                                    serialPortManager.writeDataUart5("SET IN1 EDID"+ (combobox2.currentIndex+1) +"\r\n",1);
//                                    var str = "EDIDData"+combobox2.currentIndex;
//                                    var edid= fileManager.getValue(str).split(",");
//                                    var tempArray = [];
//                                    for(var e =0 ; e<edid.length;e++){
//                                        tempArray.push(edid[e])
//                                    }
//                                    edidArray = tempArray;
//                                    generalinfo();
//                                    videoinfo();
//                                    audioinfo();
                                }
                            }
                        }

                    }
                }

            }

            Column{
                width: parent.width
                spacing: 10
                Column{
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Text {
                        text: "General Info:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.left: parent.left
                    }
                    Rectangle{
                        width: 680
                        height: 250
                        border.width: 1
                        border.color:"#585858"
                        visible: true
                        Flickable {
                            anchors.fill: parent

                            TextArea.flickable: TextArea {
                                id: sink_device_general_text
                                text:""
                                wrapMode: TextArea.Wrap
                                textFormat: TextArea.PlainText
                                selectByMouse: true
                                topPadding: 10
                                leftPadding: 10
                                font.pixelSize: btnfontsize
                                font.family: myriadPro.name
                                readOnly: true
                            }

                            ScrollBar.vertical: ScrollBar {
                                policy: sink_device_general_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                                interactive: true
                            }
                        }
                    }
                }

                Column{
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Text {
                        text: "Video Information:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.left: parent.left
                    }
                    Rectangle{
                        width: 680
                        height: 250
                        border.width: 1
                        border.color:"#585858"
                        visible: true
                        Flickable {
                            anchors.fill: parent

                            TextArea.flickable: TextArea {
                                id: sink_device_video_text
                                wrapMode: TextArea.Wrap
                                textFormat: TextArea.PlainText
                                selectByMouse: true
                                topPadding: 10
                                leftPadding: 10
                                font.pixelSize: btnfontsize
                                font.family: "Roboto"
                                readOnly: true
                            }

                            ScrollBar.vertical: ScrollBar {
                                policy: sink_device_video_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                                interactive: true
                            }
                        }
                    }
                }

                Column{
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Text {
                        text: "Audio Information:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.left: parent.left
                    }
                    Rectangle{
                        width: 680
                        height: 250
                        border.width: 1
                        border.color:"#585858"
                        visible: true
                        Flickable {
                            anchors.fill: parent

                            TextArea.flickable: TextArea {
                                id: sink_device_audio_text
                                wrapMode: TextArea.Wrap
                                textFormat: TextArea.PlainText
                                selectByMouse: true
                                topPadding: 10
                                leftPadding: 10
                                font.pixelSize: btnfontsize
                                font.family: "Roboto"
                                readOnly: true
                            }

                            ScrollBar.vertical: ScrollBar {
                                policy: sink_device_audio_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                                interactive: true
                            }
                        }
                    }
                }

            }


        }


    }

    //arc_audio_info
    Column{
        visible: pageflag==2&&pageindex == 1?true:false
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        RowLayout{
            width: parent.width
            Column{
                width: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Text {
                    text: "EDID Info:"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.left: parent.left
                }
                Rectangle{
                    width: 600
                    height: 300
                    border.width: 1
                    border.color:"#585858"
                    visible: true
                    Flickable {
                        anchors.fill: parent

                        TextArea.flickable: TextArea {
                            id: arc_audio_text
                            wrapMode: TextArea.Wrap
                            textFormat: TextArea.PlainText
                            selectByMouse: true
                            topPadding: 10
                            leftPadding: 10
                            font.pixelSize: btnfontsize
                            font.family: "Roboto"
                            readOnly: true
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: arc_audio_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                            interactive: true
                        }
                    }
                }
            }
            Column{
                width: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Text {
                    text: "Audio Info:"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.left: parent.left
                }
                Rectangle{
                    width: 600
                    height: 300
                    border.width: 1
                    border.color:"#585858"
                    visible: true
                    Flickable {
                        anchors.fill: parent

                        TextArea.flickable: TextArea {
                            id: arc_audio_info_text
                            wrapMode: TextArea.Wrap
                            textFormat: TextArea.PlainText
                            selectByMouse: true
                            topPadding: 10
                            leftPadding: 10
                            font.pixelSize: btnfontsize
                            font.family: "Roboto"
                            readOnly: true
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: arc_audio_info_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                            interactive: true
                        }
                    }
                }
            }
        }
    }

    //arc_hpd_ctl
    property int arc_hpd_ctl_flag: 0
    GridLayout{
        visible: pageflag==3&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4
        ListModel {
            id: arc_hpd_ctl_model
            ListElement { first: "ASSERT HPD(HIGH)"; number: 1 }
            ListElement { first: "DEASSERT HPD(LOW)"; number: 2 }
        }
        Repeater{
            model: arc_hpd_ctl_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: arc_hpd_ctl_flag==number?"orange":"black"
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
                        arc_hpd_ctl_flag=number
                        confirmsignal("ARC_HPD_CTL",number)
                    }
                }
            }
        }

    }

    //physical_hpd_ctl
    property int physical_hpd_ctl_flag: 0
    GridLayout{
        visible: pageflag==4&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4
        ListModel {
            id: physical_hpd_ctl_model
            ListElement { first: "ASSERT HPD(HIGH)"; number: 1 }
            ListElement { first: "DEASSERT HPD(LOW)"; number: 2 }
        }
        Repeater{
            model: physical_hpd_ctl_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: physical_hpd_ctl_flag==number?"orange":"black"
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
                        physical_hpd_ctl_flag=number
                        confirmsignal("eARC_Physical_HPD_CTL",number)
                    }
                }
            }
        }

    }

    //earc_hpd_bit_ctl
    property int earc_hpd_bit_ctl_flag: 0
    GridLayout{
        visible: pageflag==5&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4
        ListModel {
            id: earc_hpd_bit_ctl_model
            ListElement { first: "SET HDMI_HPD bit(=1)"; number: 1 }
            ListElement { first: "CLEAR HDMI_HPD bit(=0)"; number: 0 }
        }
        Repeater{
            model: earc_hpd_bit_ctl_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: earc_hpd_bit_ctl_flag==number?"orange":"black"
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
                        earc_hpd_bit_ctl_flag=number
                        confirmsignal("eARC_HPD_bit_CTL",number)
                    }
                }
            }
        }

    }

    //hdmi_5v_power_ctl
    property int hdmi_5v_power_ctl_flag: 0
    GridLayout{
        visible: pageflag==6&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4
        ListModel {
            id: hdmi_5v_power_ctl_model
            ListElement { first: "SET HDMI TX +5V ON"; number: 1 }
            ListElement { first: "SET HDMI TX +5V OFF"; number: 0 }
        }
        Repeater{
            model: hdmi_5v_power_ctl_model
            CustomButton{
                width:btnWidth
                height:btnHeight
                border.color: hdmi_5v_power_ctl_flag==number?"orange":"black"
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
                        hdmi_5v_power_ctl_flag=number
                        confirmsignal("HDMI_5V_POWER_CTL",number)
                    }
                }
            }
        }

    }

    //earc_tx_latency
    RowLayout {
        visible: pageflag==7&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 500
            width: 900

            Column{
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing:30
                Text {
                    text: "ERX_LATENCY_REQ(To eARC RX)"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row{
                    anchors.horizontalCenter : parent.horizontalCenter
                    spacing: 10
                    Button{
                        text: "-"
                        width: 150
                        height: 60
                        font.pixelSize: btnfontsize
                        onClicked: {
                            var num = Number(earc_tx_latencyk_text.text)-1
                            if(num<0){
                                num=0
                            }
                            earc_tx_latencyk_text.text = num
                            confirmsignal("eARCTX_Latency_REQ",num)
                        }
                    }
                    Text{
                        width: 20
                    }

                    TextField {
                        id:earc_tx_latencyk_text
                        width: 200
                        height: 60
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "black"
                        horizontalAlignment: TextInput.AlignHCenter
                        onPressed: {
                            currentInputField = earc_tx_latencyk_text;
                            virtualKeyboard.visible = true;
                        }
                        onTextChanged: {
                            if(earc_tx_latencyk_text.text!==""){
                                confirmsignal("eARCTX_Latency",Number(earc_tx_latencyk_text.text))
                            }
                        }
                    }

                    Text {
                        text: qsTr("ms")
                        width: 40
                        anchors.verticalCenter: earc_tx_latencyk_text.verticalCenter
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                    }
                    Button{
                        width: 150
                        height: 60
                        text: "+"
                        font.pixelSize: btnfontsize
                        onClicked: {
                            var num = Number(earc_tx_latencyk_text.text)+1
                            if(num>255){
                                num=255
                            }
                            earc_tx_latencyk_text.text = num
                            confirmsignal("eARCTX_Latency",num)
                        }
                    }
                    Text {
                        text: qsTr("REQUESTED VALUE")
//                        anchors.verticalCenter: earc_tx_latencyk_text_rect.verticalCenter
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                    }
                }
                Text {
                    text: "(eg:Sink Device - TV,with eARC TX)"
                    font.family: myriadPro.name
                    font.pixelSize: 30
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "ERX_LATENCY(From eARC RX)"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter

                    TextField {
                        id:earc_tx_latencyk_ms_text
                        width: 200
                        height: 60
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "black"

                        horizontalAlignment: TextInput.AlignHCenter
                        onPressed: {
                            currentInputField = earc_tx_latencyk_ms_text;
                            virtualKeyboard.visible = true
                        }
                        onTextChanged: {
                            if(earc_rx_latencyk_ms_text.text!==""){
                                confirmsignal("eARCTX_Latency",Number(earc_rx_latencyk_ms_text.text))
                            }
                        }
                    }

                    Text {
                        text: qsTr("ms")
                        Layout.alignment: Qt.AlignVCenter
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "white"
                    }
                }
                Text {
                    text: "(Feedback from eARC RX - eg.:AVR)"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    //earc_rx_latency
    RowLayout {
        visible: pageflag==8&&pageindex == 1?true:false
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 500
            width: 900

            Column{
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing:30
                Text {
                    text: "ERX_LATENCY_REQ(To eARC TX)"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row{
                    anchors.horizontalCenter : parent.horizontalCenter
                    spacing: 10
                    Button{
                        text: "-"
                        width: 150
                        height: 60
                        font.pixelSize: btnfontsize
                        onClicked: {
                            var num = Number(earc_rx_latencyk_text.text)-1
                            if(num<0){
                                num=0
                            }
                            earc_rx_latencyk_text.text = num
                            confirmsignal("eARCRX_Latency_REQ",num)
                        }
                    }
                    Text{
                        width: 20
                    }
                    TextField {
                        id:earc_rx_latencyk_text
                        width: 200
                        height: 60
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "black"
                        horizontalAlignment: TextInput.AlignHCenter
                        onPressed: {
                            currentInputField = earc_rx_latencyk_text;
                            virtualKeyboard.visible = true
                        }
                        onTextChanged: {
                            if(earc_rx_latencyk_text.text!==""){
                                confirmsignal("eARCRX_Latency",Number(earc_rx_latencyk_text.text))
                            }
                        }
                    }

                    Text {
                        text: qsTr("ms")
                        anchors.verticalCenter: earc_rx_latencyk_text.verticalCenter
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                    }
                    Button{
                        width: 150
                        height: 60
                        text: "+"
                        font.pixelSize: btnfontsize
                        onClicked: {
                            var num = Number(earc_rx_latencyk_text.text)+1
                            if(num>255){
                                num=255
                            }
                            earc_rx_latencyk_text.text = num
                            confirmsignal("eARCRX_Latency",num)
                        }

                    }
                    Text {
                        text: qsTr("REQUESTED VALUE")
                        anchors.verticalCenter: earc_rx_latencyk_text.verticalCenter
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                    }
                }
                Text {
                    text: "(eg:Sink Device - TV,with eARC RX)"
                    font.family: myriadPro.name
                    font.pixelSize: 30
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "ERX_LATENCY(From eARC TX)"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                RowLayout{
                    anchors.horizontalCenter : parent.horizontalCenter

                    TextField {
                        id:earc_rx_latencyk_ms_text
                        width: 200
                        height: 60
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "black"
                        horizontalAlignment: TextInput.AlignHCenter
                        onPressed: {
                            currentInputField = earc_rx_latencyk_ms_text;
                            virtualKeyboard.visible = true
                        }
                        onTextChanged: {
                            if(earc_rx_latencyk_ms_text.text!==""){
                                confirmsignal("eARCRX_Latency",Number(earc_rx_latencyk_ms_text.text))
                            }
                        }
                    }

                    Text {
                        text: qsTr("ms")
                        width: 20
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "white"
                    }
                }
                Text {
                    text: "(Feedback from eARC TX - eg.:TV)"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

}
