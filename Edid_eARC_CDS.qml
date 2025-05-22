// Edid_eARC_CDS.qml
// EDID、eARC和CDS(连接检测状态)管理界面
// 提供EDID查看/修改、ARC/eARC音频管理和各种HPD/延迟控制功能

import QtQuick 2.0                // 导入基本的QtQuick模块
import QtQuick.Controls 2.5       // 导入控件模块，提供按钮、文本框等UI元素
import QtQuick.Layouts 1.12       // 导入布局模块，提供GridLayout等布局功能
import QtQuick.Dialogs 1.3        // 导入对话框模块，提供文件选择等功能

Rectangle {
    id: root
    anchors.fill: parent           // 填充父容器
    
    // 定义信号，用于与C++后端通信
    signal confirmsignal(string str, int num)  // 发送命令和参数到后端

    // 接收设备EDID相关文本属性别名，允许外部访问和修改
    //    property alias sink_device_edid_text: sink_device_edid_text  // 已注释掉
    property alias sink_device_general_text: sink_device_general_text  // EDID基本信息文本
    property alias sink_device_video_text: sink_device_video_text      // EDID视频能力文本
    property alias sink_device_audio_text: sink_device_audio_text      // EDID音频能力文本
    
    // ARC音频相关文本属性别名
    property alias arc_audio_text: arc_audio_text                      // ARC音频EDID文本
    property alias arc_audio_info_text: arc_audio_info_text            // ARC音频信息文本
    
    // eARC延迟相关文本属性别名
    property alias earc_tx_latencyk_text: earc_tx_latencyk_text        // eARC TX延迟请求值
    property alias earc_tx_latencyk_ms_text: earc_tx_latencyk_ms_text  // eARC TX延迟实际值(ms)
    property alias earc_rx_latencyk_text: earc_rx_latencyk_text        // eARC RX延迟请求值
    property alias earc_rx_latencyk_ms_text: earc_rx_latencyk_ms_text  // eARC RX延迟实际值(ms)

    // 页面控制属性
    property int pageindex: 0      // 控制二级页面索引
    property int pageflag: 0       // 控制一级页面索引
    
    // UI尺寸属性
    property int btnWidth: 300     // 按钮宽度
    property int btnHeight: 120    // 按钮高度
    property int cellwidth: 50     // EDID单元格宽度
    property int cellheight: 35    // EDID单元格高度
    property int edidrows: 32      // EDID显示行数
    property int edidfontsize: 20  // EDID文本字体大小
    property int btnfontsize: 35   // 按钮文本字体大小
    
    // EDID视频数据 - 包含HDMI/DisplayPort标准支持的各种视频分辨率和刷新率
    property var videoList: [
            "#001, 640x480p 59.94Hz/60Hz 4:3","#002, 720x480p 59.94Hz/60Hz 4:3","#003, 720x480p 59.94Hz/60Hz 16:9",
            "#004, 1280x720p 59.94Hz/60Hz 16:9","#005, 1920x1080i 59.94Hz/60Hz 16:9","#006, 720(1440)x480i 59.94Hz/60Hz 4:3",
            "#007, 720(1440)x480i 59.94Hz/60Hz 16:9","#008, 720(1440)x240p 59.94Hz/60Hz 4:3","#009, 720(1440)x240p 59.94Hz/60Hz 16:9",
            "#010, 2880x480i 59.94Hz/60Hz 4:3","#011, 2880x480i 59.94Hz/60Hz 16:9","#012, 2880x240p 59.94Hz/60Hz 4:3",
            "#013, 2880x240p 59.94Hz/60Hz 16:9","#014, 1440x480p 59.94Hz/60Hz 4:3","#015, 1440x480p 59.94Hz/60Hz 16:9",
            "#016, 1920x1080p 59.94Hz/60Hz 16:9","#017, 720x576p 50Hz 4:3","#018, 720x576p 50Hz 16:9",
            "#019, 1280x720p 50Hz 16:9","#020, 1920x1080i 50Hz 16:9","#021, 720(1440)x576i 50Hz 4:3",
            "#022, 720(1440)x576i 50Hz 16:9","#023, 720(1440)x288p 50Hz 4:3","#024, 720(1440)x288p 50Hz 16:9",
            "#025, 2880x576i 50Hz 4:3","#026, 2880x576i 50Hz 16:9","#027, 2880x288p 50Hz 4:3",
            "#028, 2880x288p 50Hz 16:9","#029, 1440x576p 50Hz 4:3","#030, 1440x576p 50Hz 16:9",
            "#031, 1920x1080p 50Hz 16:9","#032, 1920x1080p 23.97Hz/24Hz 16:9","#033, 1920x1080p 25Hz 16:9",
            "#034, 1920x1080p 29.97Hz/30Hz 16:9","#035, 2880x480p 59.94Hz/60Hz 4:3","#036, 2880x480p 59.94Hz/60Hz 16:9",
            "#037, 2880x576p 50Hz 4:3","#038, 2880x576p 50Hz 4:3","#039, 1920x1080i(1250 total) 50Hz 16:9",
            "#040, 920x1080i 100Hz 16:9","#041, 1280x720p 100Hz 16:9","#042, 720x576p 100Hz 4:3",
            "#043, 720x576p 100Hz 16:9","#044, 720(1440)x576i 100Hz 4:3","#045, 720(1440)x576i 100Hz 16:9",
            "#046, 1920x1080i 119.88Hz/120Hz 16:9","#047, 1280x720p 119.88Hz/120Hz 16:9","#048, 720x576p 119.88Hz/120Hz 4:3",
            "#049, 720x480p 119.88Hz/120Hz 16:9","#050, 720(1440)x480i 119.88Hz/120Hz 4:3","#051, 720(1440)x480i 119.88Hz/120Hz 16:9",
            "#052, 720x576p 200Hz 4:3","#053, 720(1440)x576i 200Hz 16:9","#054, 720(1440)x576i 200Hz 4:3",
            "#055, 720(1440)x576i 100Hz 16:9","#056, 720x480p 239.76Hz/240Hz 4:3","#057, 720x480p 239.76Hz/240Hz 16:9",
            "#058, 720(1440)x480i 239.76Hz/240Hz 4:3","#059, 720(1440)x480i 239.76Hz/240Hz 16:9","#060, 1280x720p 23.97Hz/24Hz 16:9",
            "#061, 1280x720p 25Hz 16:9","#062, 1280x720p 29.97Hz/30Hz 16:9","#063, 1920x1080p 119.88/120Hz 16:9",
            "#064, 1920x1080p 100Hz 16:9","#065, 1280x720p 23.98Hz/24Hz 64:27","#066, 1280x720p 25Hz 64:27",
            "#067, 1280x720p 29.97Hz/30Hz 64:27","#068, 1280x720p 50Hz 64:27","#069, 1280x720p 59.94Hz/60Hz 64:27",
            "#070, 1280x720p 100Hz 64:27","#071, 1280x720p 119.88/120Hz 64:27","#072, 1920x1080p 23.98Hz/24Hz 64:27",
            "#073, 1920x1080p 25Hz 64:27","#074, 1920x1080p 29.97Hz/30Hz 64:27","#075, 1920x1080p 50Hz 64:27",
            "#076, 1920x1080p 59.94Hz/60Hz 64:27","#077, 1920x1080p 100Hz 64:27","#078, 1920x1080p 119.88/120Hz 64:27",
            "#079, 1680x720p 23.98Hz/24Hz 64:27","#080, 1680x720p 25Hz 64:27","#081, 1680x720p 29.97Hz/30Hz 64:27",
            "#082, 1680x720p 50Hz 64:27","#083, 1680x720p 59.94Hz/60Hz 64:27","#084, 1680x720p 100Hz 64:27",
            "#085, 1680x720p 119.88/120Hz 64:27","#086, 2560x1080p 23.98Hz/24Hz 64:27","#087, 2560x1080p 25Hz 64:27",
            "#088, 2560x1080p 29.97Hz/30Hz 64:27","#089, 2560x1080p 50Hz 64:27","#090, 2560x1080p 59.94Hz/60Hz 64:27",
            "#091, 2560x1080p 100Hz 64:27","#092, 2560x1080p 119.88/120Hz 64:27","#093, 3840x2160p 23.98Hz/24Hz 16:9 ",
            "#094, 3840x2160p 25Hz 16:9","#095, 3840x2160p 29.97Hz/30Hz 16:9","#096, 3840x2160p 50Hz 16:9",
            "#097, 3840x2160p 59.94Hz/60Hz 16:9","#098, 4096x2160p 23.98Hz/24Hz 256:135","#099, 4096x2160p 25Hz 256:135",
            "#100, 4096x2160p 29.97Hz/30Hz 256:135","#101, 4096x2160p 50Hz 256:135","#102, 4096x2160p 59.94Hz/60Hz 256:135",
            "#103, 3840x2160p 23.98Hz/24Hz 64:27","#104, 3840x2160p 25Hz 64:27","#105, 3840x2160p 29.97Hz/30Hz 64:27",
            "#106, 3840x2160p 50Hz 64:27","#107, 3840x2160p 59.94Hz/60Hz 64:27","#108, 1280x720p 47.95Hz/48Hz 16:9",
            "#109, 1280x720p 47.95Hz/48Hz 64:27","#110, 1680x720p 47.95Hz/48Hz 64:27","#111, 1920x1080p 47.95Hz/48Hz 16:9",
            "#112, 1920x1080p 47.95Hz/48Hz 64:27","#113, 2560x1080p 47.95Hz/48Hz 64:27","#114, 3840x2160p 47.95Hz/48Hz 16:9",
            "#115, 4096x2160p 47.95Hz/48Hz 256:135","#116, 3840x2160p 47.95Hz/48Hz 64:27","#117, 3840x2160p 100Hz 16:9",
            "#118, 3840x2160p 119.88/120Hz 16:9","#119, 3840x2160p 100Hz 64:27","#120, 3840x2160p 119.88/120Hz 64:27",
            "#121, 5120x2160p 23.98Hz/24Hz 64:27","#122, 5120x2160p 25Hz 64:27","#123, 5120x2160p 29.97Hz/30Hz 64:27",
            "#124, 5120x2160p 47.95Hz/48Hz 64:27","#125, 5120x2160p 50Hz 64:27","#126, 5120x2160p 59.94Hz/60Hz 64:27",
            "#127, 5120x2160p 100Hz 64:27","#193, 5120x2160p 119.88/120Hz 64:27","#194, 7680x4320p 23.98Hz/24Hz 16:9",
            "#195, 7680x4320p 25Hz 16:9","#196, 7680x4320p 29.97Hz/30Hz 16:9","#197, 7680x4320p 47.95Hz/48Hz 16:9",
            "#198, 7680x4320p 50Hz  16:9","#199, 7680x4320p 59.94Hz/60Hz 16:9","#200, 7680x4320p 100Hz 16:9",
            "#201, 7680x4320p 119.88/120Hz 16:9","#202, 7680x4320p 23.98Hz/24Hz 64:27","#203, 7680x4320p 25Hz 64:27",
            "#204, 7680x4320p 29.97Hz/30Hz 64:27","#205, 7680x4320p 47.95Hz/48Hz 64:27","#206, 7680x4320p 50Hz 64:27",
            "#207, 7680x4320p 59.94Hz/60Hz 64:27","#208, 7680x4320p 100Hz 64:27","#209, 7680x4320p 119.88/120Hz 64:27",
            "#210, 10240x4320p 23.98Hz/24Hz 64:27","#211, 10240x4320p 25Hz 64:27","#212, 10240x4320p 29.97Hz/30Hz 64:27",
            "#213, 10240x4320p 47.95Hz/48Hz 64:27","#214, 10240x4320p 50Hz 64:27","#215, 10240x4320p 259.94Hz/60Hz 64:27",
            "#216, 10240x4320p 100Hz 64:27","#217, 10240x4320p 119.88/120Hz 64:27","#218, 4096x2160p 100Hz 256:135",
            "#219, 4096x2160p 119.88/120Hz 256:135",
        ]
    
    // EDID表格列标题 - 十六进制表示
    property var columnArray: [
        " ","00", "01", "02", "03", "04", "05", "06", "07",
        "08", "09", "0A", "0B", "0C", "0D", "0E", "0F"
    ]

    // EDID表格行标题 - 十六进制表示
    property var rowArray: [
        "00", "10", "20", "30", "40", "50", "60", "70",
        "80", "90", "A0", "B0", "C0", "D0", "E0", "F0"
    ]

    // EDID数据样本 - 存储256字节标准EDID数据
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

    // 返回按钮 - 仅在子页面(pageflag > 0)显示
    CustomButton{
        id: back
        visible: pageflag == 0 ? false : true   // 仅在子页面显示
        width: 150
        height: 80
        border.color: "black"
        border.width: 2
        color: flag ? 'gray' : 'black'          // 按下时变灰色
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        property bool flag: false                // 用于跟踪按钮按下状态
        
        Text {
            text: qsTr("Back")
            anchors.centerIn: parent
            font.family: myriadPro.name
            font.pixelSize: btnfontsize
            color: "white"
        }
        
        // 返回按钮点击处理 - 根据当前页面返回上一级
        MouseArea{
            anchors.fill: parent
            onPressed: {
                back.flag = true                 // 设置按下状态
            }
            onReleased: {
                back.flag = false                // 重置按下状态
                if(pageindex == 1){
                    pageflag = 0                 // 从一级子页面返回主页面
                    pageindex = 0
                }else if(pageindex == 2){
                    pageindex = 1                // 从二级子页面返回一级子页面
                }
            }
        }
    }

    // 主菜单页面 - 显示各种功能选项
    GridLayout{
        visible: pageflag == 0 ? true : false    // 仅在主页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3                               // 3列布局
        
        // 主菜单选项数据模型
        ListModel {
            id: edid_model
            ListElement { first: "SINK DEVICE"; second:"EDID INFO"; number: 1 }     // 接收设备EDID信息
            ListElement { first: "eARC/ARC"; second:"AUDIO INFO"; number: 2 }       // eARC/ARC音频信息
            ListElement { first: "ARC"; second:"HPD CTL"; number: 3 }               // ARC热插拔控制
            ListElement { first: "eARC PHYSICAL"; second:"HPD CTL"; number: 4 }     // eARC物理热插拔控制
            ListElement { first: "eARC HPD"; second:"bit CTL"; number: 5 }          // eARC热插拔位控制
            ListElement { first: "HDMI +5V"; second:"POWER CTL"; number: 6 }        // HDMI +5V电源控制
            ListElement { first: "eARC TX"; second:"LATENCY"; number: 7 }           // eARC TX延迟控制
            //            ListElement { first: "eARC RX"; second:"LATENCY"; number: 8 }         // eARC RX延迟控制(已注释)
            //            ListElement { first: "Send CEC"; second:"Command"; number: 9 }         // 发送CEC命令(已注释)
        }
        
        // 生成主菜单按钮
        Repeater{
            model: edid_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: pageflag == number ? "orange" : "black"   // 当前选择项高亮橙色边框
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first                               // 主标题
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        text: second                              // 副标题
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 进入对应子页面
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pageflag = number                         // 设置页面标志
                        pageindex = 1                             // 进入子页面
                    }
                }
            }
        }
    }

    // 文件读取功能(已注释掉，保留以备将来使用)
    //    function readFile(fileUrl) {
    //        var xhr = new XMLHttpRequest();
    //        xhr.open("GET", fileUrl, true);
    //        xhr.responseType = "arraybuffer";
    //
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

    // 文件选择对话框(已注释掉，保留以备将来使用)
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

    // 实用函数：将十六进制字符串转换为二进制字符串
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

    // 实用函数：将二进制字符串转换为ASCII字符
    // 主要用于EDID字符数据解码，比如制造商ID
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

    // 实用函数：将十六进制字符串转换为ASCII字符
    function hexToASCLL(hexString) {
        var asciiString = "";
        for (var i = 0; i < hexString.length; i += 2) {
            var hexByte = hexString.substr(i, 2);
            var decimalValue = parseInt(hexByte, 16);
            asciiString += String.fromCharCode(decimalValue);
        }
        return asciiString;
    }

    // 实用函数：将ASCII字符串转换为十六进制字符串
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

    // HDMI音频格式列表 - 定义支持的音频格式
    property var hdmiaudioList: ["Header","PCM","AC-3","MPEG1","MP3","MPEG2","AAC","DTS","ATRAC","One Bit","Dolby","DTS","MAT","DST","WMA","Reserved"]
    
    // HDMI音频采样率列表 - 定义支持的音频采样率
    property var hdmiaudioRateList: ["32K","44k","48K","88K","96K","176K","192K"]
    
    // HDMI音频位深度列表 - 定义支持的音频位深度
    property var hdmiaudioSizeList: ["16b","20b","24b"]
    
    // EDID信息解析属性 - 从EDID数据中提取各种设备信息
    // 制造商名称 - 从EDID的8-9字节解析
    property string manufacturerName_text: (binaryToASCLL(hexToBinary(edidArray[8] + edidArray[9])).toUpperCase())
    
    // 显示器名称
    property string monitorName_text: ""
    
    // 首选定时 - 从EDID的0x14字节解析
    property string preferredTiming_text: (parseInt(edidArray[0x14], 16))
    
    // 简短视频描述符 - 默认使用第一项
    property string shortVideo_text: videoList[0]
    
    // 简短音频描述符 - 从EDID的第0字节解析
    property string shortAudio_text: hdmiaudioList[parseInt(hexToBinary(edidArray[0]).substr(1,4),2)]+"/"+hdmiaudioRateList[parseInt(edidArray[0],16)]
                                     +"/"+hdmiaudioSizeList[parseInt(edidArray[0],16)]
    
    // 原生定时
    property string nativeTiming_text: ""
    
    // VSDB(厂商特定数据块)信息
    property string vsdb_Deepcolor_text: "YES"         // 深色支持
    property string vsdb_AI_text: "YES"                // 音频信息支持
    property string vsdb_3D_text: ((parseInt(edidArray[0x14], 16) & 0x40) ? "YES" : "NO")  // 3D支持
    property string vsdb_Latency_text: "not present"   // 延迟信息
    property string vsdb_ILatency_text: "not present"  // I-延迟信息
    
    // HF-VSDB(高频厂商特定数据块)信息
    property string hfvsdb_340mcss_text: "YES"         // 340MCSS支持
    property string hfvsdb_scdc_text: "YES"            // SCDC支持
    property string hfvsdb_420DS_text: "YES"           // 420DS支持
    property string hfvsdb_FRL_text: "not support"     // FRL支持

    // 生成音频支持列表函数
    function audiolist(){
        var str = ""
        for(var a=0; a<parseInt(edidArray[0],16); a++){
            str += hdmiaudioList[parseInt(hexToBinary(edidArray[0]).substr(1,4),2)]+
                    "/"+hdmiaudioRateList[parseInt(edidArray[0],16)]+"CH"+
                    "/"+hdmiaudioRateList[parseInt(edidArray[0],16)]+
                    "/"+hdmiaudioSizeList[parseInt(edidArray[0],16)]+
                    "\r\n"
        }
        return str
    }

    // 生成通用信息函数 - 将EDID数据解析为人类可读的格式
    function generalinfo() {
        // 构建显示字符串，格式化包含EDID中各个信息字段
        var str_general =
                "Manufacturer Name:" + manufacturerName_text + "\r\n" +
                "Monitor Name:" + monitorName_text + "\r\n" +
                "Preferred Timing:"+preferredTiming_text+"\r\n" +
                "Native Timing:"+ nativeTiming_text +"\r\n" +
                "Short Video Descriptor:\r\n"+shortVideo_text+"\r\n" +
                "Short Audio Descriptor:\r\n"+shortAudio_text+"\r\n" +
                "VSDB:\r\n" +
                "Deepcolor->"+vsdb_Deepcolor_text+"  "+ "AI->"+vsdb_AI_text+"  "+"3D->"+vsdb_3D_text+ " " + "\r\n" +
                "Latency->"+ vsdb_Latency_text + "\r\n" +
                "I_Latency->"+ vsdb_ILatency_text + "\r\n" +
                "HF-VSDB:\r\n" +
                "340MCSS->"+hfvsdb_340mcss_text+ "  "+"SCDC->"+hfvsdb_scdc_text+ "  "+ "Y420.DC->"+hfvsdb_420DS_text+ "  "+ "FRL->"+hfvsdb_FRL_text+ " ";

        // 以下是原始代码的替代版本(已注释掉)
        //      "Manufacturer Name: " + ManufacturerName_text +(binaryToASCLL(hexToBinary(edidArray[8] + edidArray[9])).toUpperCase()) + "\r\n" +
        //      "Monitor Name: " + (edidArray[0x0B]+ edidArray[0x0A])+ "\r\n" +
        //      // ... 更多注释掉的代码

        console.log(str_general);  // 在控制台输出解析结果
        sink_device_general_text.text = str_general;  // 更新UI显示
    }

    // 生成视频信息函数
    function videoinfo(){
        var str_video = "Preferred Timing:"+(parseInt(edidArray[0x14], 16))+"\r\n";
        sink_device_video_text.text = str_video;  // 更新UI显示
    }

    // 生成音频信息函数
    function audioinfo(){
        var str_audio = ""  // 当前为空字符串
        sink_device_audio_text.text = str_audio;  // 更新UI显示
    }

    // EDID信息显示界面 - 用于显示和编辑EDID数据
    Column{
        visible: pageflag == 1 && pageindex == 1 ? true : false  // 仅在EDID信息页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 100

        RowLayout{
            width: parent.width
            x: 30
            spacing: 50
            
            // 左侧EDID编辑区域
            Column{
                width: cellwidth * 18
                
                // EDID标题
                Text {
                    text: "EDID Info:"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.left: parent.left
                }

                // EDID表格列标题
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
                                text: columnArray[index]  // 显示列标题(十六进制)
                                anchors.centerIn: parent
                                font.pointSize: edidfontsize
                                font.family: myriadPro.name
                                font.bold: true
                            }
                        }
                    }
                }

                // EDID数据表格，带有滚动视图
                ScrollView {
                    id: scrollView
                    width: cellwidth * 17 + 10
                    height: cellheight * 16
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    RowLayout{
                        spacing: 0
                        
                        // 行标题列
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
                                        text: index.toString(16).toUpperCase().padStart(2, '0')+"0"  // 显示行标题(十六进制+0)
                                        anchors.centerIn: parent
                                        font.pointSize: edidfontsize
                                        font.family: myriadPro.name
                                        font.bold: true
                                    }
                                }
                            }
                        }

                        // EDID数据单元格
                        Grid {
                            columns: 16
                            rows: edidrows

                            Repeater {
                                model: 16 * edidrows
                                Rectangle {
                                    width: cellwidth
                                    height: cellheight
                                    border.width: 1
                                    border.color: "#B5B7AC"

                                    // 可编辑的EDID数据字段
                                    TextField{
                                        id: edid_arry
                                        width: cellwidth
                                        height: cellheight
                                        text: index <= edidArray.length - 1 ? edidArray[index] : " "  // 显示EDID数据
                                        font.pixelSize: edidfontsize + 7
                                        font.family: myriadPro.name
                                        horizontalAlignment: TextInput.AlignHCenter
                                        color: parseInt(text, 16) > 255 ? "red" : "black"  // 无效值显示为红色
                                        topPadding: 2
                                        bottomPadding: 2
                                        
                                        // 验证器：仅允许输入有效的十六进制字符
                                        validator: RegExpValidator {
                                            regExp: /^[0-9A-Fa-f]{0,2}$/
                                        }
                                        
                                        // 文本编辑处理
                                        onTextEdited: {
                                            text = text.toUpperCase();  // 转换为大写
                                            edidArray[index] = text;    // 更新数据数组
                                        }
                                        
                                        // 编辑完成处理
                                        onEditingFinished: {
                                            text = text.toUpperCase();
                                            // 确保数据以两位十六进制格式存储
                                            if(text.length === 1){
                                                edidArray[index] = "0" + text;
                                            } else if(text.length === 2){
                                                edidArray[index] = text;
                                            }
                                        }
                                        
                                        // 虚拟键盘处理
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

                // 间隔元素
                Item {
                    width: parent.width
                    height: 50
                }

                // EDID操作按钮区域
                RowLayout{
                    spacing: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    // 读取EDID按钮
                    CustomButton{
                        id: read_edid
                        width: 150
                        height: 80
                        border.color: "black"
                        border.width: 2
                        color: flag ? 'gray' : 'black'
                        property bool flag: false
                        
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
                                confirmsignal("readEDID", 1)  // 发送读取EDID命令
                            }
                            onReleased: {
                                read_edid.flag = false
                            }
                        }
                    }

                    // 保存EDID区域
                    Row{
                        width: 300
                        spacing: 10

                        // 用户EDID选择下拉框
                        ComboBox{
                            id: combobox1
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

                            // 下拉框项自定义样式
                            delegate: ItemDelegate {
                                width: combobox1.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox1.highlightedIndex === index ? "#5e5e5e" : "black"
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

                        // 保存按钮
                        CustomButton{
                            id: save_edid
                            width: 100
                            height: 80
                            border.color: "black"
                            border.width: 4
                            color: flag ? 'gray' : 'black'
                            property bool flag: false
                            
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
                                    // 构建EDID数据字符串
                                    var useredid = "";
                                    for(var d = 0; d < edidArray.length; d++){
                                        useredid += edidArray[d] + " ";
                                    }
                                    
                                    // 发送SET EDID命令到串口
                                    serialPortManager.writeDataUart5("SET IN1 EDID U" + (combobox1.currentIndex + 1) + " DATA " + useredid.trim() + "\r\n", 1);
                                }
                                onReleased: {
                                    save_edid.flag = false
                                    // 更新保存的EDID数据
                                    var str = "EDIDData" + combobox1.currentIndex;
                                    fileManager.updateData(str, edidArray);
                                }
                            }
                        }
                    }

                    // 打开EDID区域
                    Row{
                        width: 300
                        spacing: 10

                        // 打开EDID选择下拉框
                        ComboBox{
                            id: combobox2
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

                            // 下拉框项自定义样式
                            delegate: ItemDelegate {
                                width: combobox2.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox2.highlightedIndex === index ? "#5e5e5e" : "black"
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

                        // 打开按钮
                        CustomButton{
                            id: open_edid
                            width: 100
                            height: 80
                            border.color: "black"
                            border.width: 4
                            color: flag ? 'gray' : 'black'
                            property bool flag: false
                            
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
                                    // 发送SET EDID命令到串口
                                    serialPortManager.writeDataUart5("SET IN1 EDID" + (combobox2.currentIndex + 1) + "\r\n", 1);
                                    
                                    // 以下代码已被注释，原用于从文件读取EDID数据
                                    // var str = "EDIDData"+combobox2.currentIndex;
                                    // var edid= fileManager.getValue(str).split(",");
                                    // var tempArray = [];
                                    // for(var e = 0; e < edid.length; e++){
                                    //     tempArray.push(edid[e])
                                    // }
                                    // edidArray = tempArray;
                                    
                                    // 更新通用信息显示
                                    generalinfo();
                                    // videoinfo();
                                    // audioinfo();
                                }
                            }
                        }
                    }
                }
            }

            // 右侧EDID信息显示区域
            Column{
                width: parent.width
                spacing: 10
                
                // 通用信息显示区域
                Column{
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    
                    // 通用信息标题
                    Text {
                        text: "General Info:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.left: parent.left
                    }
                    
                    // 通用信息文本区域
                    Rectangle{
                        width: 650
                        height: 750
                        border.width: 1
                        border.color: "#585858"
                        visible: true
                        
                        // 可滚动文本区域
                        Flickable {
                            anchors.fill: parent

                            TextArea.flickable: TextArea {
                                id: sink_device_general_text
                                text: ""
                                wrapMode: TextArea.Wrap
                                textFormat: TextArea.PlainText
                                selectByMouse: true
                                topPadding: 10
                                leftPadding: 10
                                font.pixelSize: btnfontsize - 5
                                font.family: myriadPro.name
                                readOnly: true
                            }

                            // 垂直滚动条
                            ScrollBar.vertical: ScrollBar {
                                policy: sink_device_general_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                                interactive: true
                            }
                        }
                    }
                }

                // 视频信息显示区域 - 当前设置为不可见
                Column{
                    visible: false
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    
                    // 视频信息标题
                    Text {
                        text: "Video Information:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.left: parent.left
                    }
                    
                    // 视频信息文本区域
                    Rectangle{
                        width: 680
                        height: 250
                        border.width: 1
                        border.color: "#585858"
                        visible: true
                        
                        // 可滚动文本区域
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

                            // 垂直滚动条
                            ScrollBar.vertical: ScrollBar {
                                policy: sink_device_video_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                                interactive: true
                            }
                        }
                    }
                }

                // 音频信息显示区域 - 当前设置为不可见
                Column{
                    visible: false
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    
                    // 音频信息标题
                    Text {
                        text: "Audio Information:"
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "black"
                        anchors.left: parent.left
                    }
                    
                    // 音频信息文本区域
                    Rectangle{
                        width: 680
                        height: 250
                        border.width: 1
                        border.color: "#585858"
                        visible: true
                        
                        // 可滚动文本区域
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

                            // 垂直滚动条
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

    // ARC音频信息页面
    Column{
        visible: pageflag == 2 && pageindex == 1 ? true : false  // 仅在ARC音频信息页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        
        RowLayout{
            width: parent.width
            
            // EDID信息显示区域
            Column{
                width: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                
                // EDID信息标题
                Text {
                    text: "EDID Info:"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.left: parent.left
                }
                
                // EDID信息文本区域
                Rectangle{
                    width: 600
                    height: 300
                    border.width: 1
                    border.color: "#585858"
                    visible: true
                    
                    // 可滚动文本区域
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

                        // 垂直滚动条
                        ScrollBar.vertical: ScrollBar {
                            policy: arc_audio_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                            interactive: true
                        }
                    }
                }
            }
            
            // 音频信息显示区域
            Column{
                width: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                
                // 音频信息标题
                Text {
                    text: "Audio Info:"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.left: parent.left
                }
                
                // 音频信息文本区域
                Rectangle{
                    width: 600
                    height: 300
                    border.width: 1
                    border.color: "#585858"
                    visible: true
                    
                    // 可滚动文本区域
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

                        // 垂直滚动条
                        ScrollBar.vertical: ScrollBar {
                            policy: arc_audio_info_text.contentHeight > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                            interactive: true
                        }
                    }
                }
            }
        }
    }

    // ARC HPD控制页面
    property int arc_hpd_ctl_flag: 0  // 当前选择的ARC HPD控制模式
    
    // ARC HPD控制按钮网格
    GridLayout{
        visible: pageflag == 3 && pageindex == 1 ? true : false  // 仅在ARC HPD控制页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4  // 4列布局
        
        // ARC HPD控制选项模型
        ListModel {
            id: arc_hpd_ctl_model
            ListElement { first: "ASSERT HPD(HIGH)"; number: 1 }       // 断言HPD(高电平)
            ListElement { first: "DEASSERT HPD(LOW)"; number: 2 }      // 取消断言HPD(低电平)
        }
        
        // 生成ARC HPD控制按钮
        Repeater{
            model: arc_hpd_ctl_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: arc_hpd_ctl_flag == number ? "orange" : "black"  // 当前选择项高亮
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
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 设置ARC HPD控制
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        arc_hpd_ctl_flag = number
                        confirmsignal("ARC_HPD_CTL", number)  // 发送ARC HPD控制命令
                    }
                }
            }
        }
    }

    // eARC物理HPD控制页面
    property int physical_hpd_ctl_flag: 0  // 当前选择的eARC物理HPD控制模式
    
    // eARC物理HPD控制按钮网格
    GridLayout{
        visible: pageflag == 4 && pageindex == 1 ? true : false  // 仅在eARC物理HPD控制页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4  // 4列布局
        
        // eARC物理HPD控制选项模型
        ListModel {
            id: physical_hpd_ctl_model
            ListElement { first: "ASSERT HPD(HIGH)"; number: 1 }       // 断言物理HPD(高电平)
            ListElement { first: "DEASSERT HPD(LOW)"; number: 2 }      // 取消断言物理HPD(低电平)
        }
        
        // 生成eARC物理HPD控制按钮
        Repeater{
            model: physical_hpd_ctl_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: physical_hpd_ctl_flag == number ? "orange" : "black"  // 当前选择项高亮
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
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 设置eARC物理HPD控制
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        physical_hpd_ctl_flag = number
                        confirmsignal("eARC_Physical_HPD_CTL", number)  // 发送eARC物理HPD控制命令
                    }
                }
            }
        }
    }

    // eARC HPD位控制页面
    property int earc_hpd_bit_ctl_flag: 0  // 当前选择的eARC HPD位控制模式
    
    // eARC HPD位控制按钮网格
    GridLayout{
        visible: pageflag == 5 && pageindex == 1 ? true : false  // 仅在eARC HPD位控制页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4  // 4列布局
        
        // eARC HPD位控制选项模型
        ListModel {
            id: earc_hpd_bit_ctl_model
            ListElement { first: "SET HDMI_HPD bit(=1)"; number: 1 }    // 设置HDMI_HPD位(=1)
            ListElement { first: "CLEAR HDMI_HPD bit(=0)"; number: 0 }  // 清除HDMI_HPD位(=0)
        }
        
        // 生成eARC HPD位控制按钮
        Repeater{
            model: earc_hpd_bit_ctl_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: earc_hpd_bit_ctl_flag == number ? "orange" : "black"  // 当前选择项高亮
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
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 设置eARC HPD位控制
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        earc_hpd_bit_ctl_flag = number
                        confirmsignal("eARC_HPD_bit_CTL", number)  // 发送eARC HPD位控制命令
                    }
                }
            }
        }
    }

    // HDMI +5V电源控制页面
    property int hdmi_5v_power_ctl_flag: 0  // 当前选择的HDMI +5V电源控制模式
    
    // HDMI +5V电源控制按钮网格
    GridLayout{
        visible: pageflag == 6 && pageindex == 1 ? true : false  // 仅在HDMI +5V电源控制页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4  // 4列布局
        
        // HDMI +5V电源控制选项模型
        ListModel {
            id: hdmi_5v_power_ctl_model
            ListElement { first: "SET HDMI TX +5V ON"; number: 1 }   // 打开HDMI TX +5V电源
            ListElement { first: "SET HDMI TX +5V OFF"; number: 0 }  // 关闭HDMI TX +5V电源
        }
        
        // 生成HDMI +5V电源控制按钮
        Repeater{
            model: hdmi_5v_power_ctl_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: hdmi_5v_power_ctl_flag == number ? "orange" : "black"  // 当前选择项高亮
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
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 设置HDMI +5V电源控制
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        hdmi_5v_power_ctl_flag = number
                        confirmsignal("HDMI_5V_POWER_CTL", number)  // 发送HDMI +5V电源控制命令
                    }
                }
            }
        }
    }

    // eARC TX延迟页面
    RowLayout {
        visible: pageflag == 7 && pageindex == 1 ? true : false  // 仅在eARC TX延迟页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        
        // eARC TX延迟设置区域
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
                spacing: 30
                
                // eARC TX延迟请求标题
                Text {
                    text: "ERX_LATENCY_REQ(To eARC RX)"  // 发送到eARC接收器的延迟请求
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                // eARC TX延迟请求控制区域
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10
                    
                    // 延迟减少按钮
                    Button{
                        text: "-"
                        width: 150
                        height: 60
                        font.pixelSize: btnfontsize
                        
                        // 减少延迟值
                        onClicked: {
                            var num = Number(earc_tx_latencyk_text.text) - 1
                            if(num < 0){
                                num = 0  // 确保不低于0
                            }
                            earc_tx_latencyk_text.text = num
                            confirmsignal("eARCTX_Latency_REQ", num)  // 发送新的延迟请求
                        }
                    }
                    
                    Text{
                        width: 20  // 间隔元素
                    }

                    // 延迟值输入框
                    TextField {
                        id: earc_tx_latencyk_text
                        width: 200
                        height: 60
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "black"
                        horizontalAlignment: TextInput.AlignHCenter
                        
                        // 虚拟键盘处理
                        onPressed: {
                            currentInputField = earc_tx_latencyk_text;
                            virtualKeyboard.visible = true;
                        }
                        
                        // 文本变化处理
                        onTextChanged: {
                            if(earc_tx_latencyk_text.text !== ""){
                                confirmsignal("eARCTX_Latency", Number(earc_tx_latencyk_text.text))  // 发送新的延迟值
                            }
                        }
                    }

                    // 毫秒单位标签
                    Text {
                        text: qsTr("ms")
                        width: 40
                        anchors.verticalCenter: earc_tx_latencyk_text.verticalCenter
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                    }
                    
                    // 延迟增加按钮
                    Button{
                        width: 150
                        height: 60
                        text: "+"
                        font.pixelSize: btnfontsize
                        
                        // 增加延迟值
                        onClicked: {
                            var num = Number(earc_tx_latencyk_text.text) + 1
                            if(num > 255){
                                num = 255  // 确保不超过255
                            }
                            earc_tx_latencyk_text.text = num
                            confirmsignal("eARCTX_Latency", num)  // 发送新的延迟值
                        }
                    }
                    
                    // 请求值标签
                    Text {
                        text: qsTr("REQUESTED VALUE")
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                    }
                }
                
                // 说明文本
                Text {
                    text: "(eg:Sink Device - TV,with eARC TX)"  // 示例：接收设备-电视，带eARC发送器
                    font.family: myriadPro.name
                    font.pixelSize: 30
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                // eARC RX延迟标题
                Text {
                    text: "ERX_LATENCY(From eARC RX)"  // 来自eARC接收器的延迟信息
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                // eARC RX延迟显示区域
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter

                    // 延迟值显示框
                    TextField {
                        id: earc_tx_latencyk_ms_text
                        width: 200
                        height: 60
                        text: qsTr("0")
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "black"
                        horizontalAlignment: TextInput.AlignHCenter
                        
                        // 虚拟键盘处理
                        onPressed: {
                            currentInputField = earc_tx_latencyk_ms_text;
                            virtualKeyboard.visible = true
                        }
                        
                        // 文本变化处理
                        onTextChanged: {
                            if(earc_rx_latencyk_ms_text.text !== ""){
                                confirmsignal("eARCTX_Latency", Number(earc_rx_latencyk_ms_text.text))  // 发送新的延迟值
                            }
                        }
                    }

                    // 毫秒单位标签
                    Text {
                        text: qsTr("ms")
                        Layout.alignment: Qt.AlignVCenter
                        font.family: myriadPro.name
                        font.pixelSize: 35
                        color: "white"
                    }
                }
                
                // 说明文本
                Text {
                    text: "(Feedback from eARC RX - eg.:AVR)"  // 来自eARC接收器的反馈-示例：音频/视频接收器
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // eARC HPD位控制界面 - 用于设置/清除HDMI_HPD位
    property int earc_hpd_bit_ctl_flag: 0   // 当前选择的HPD位控制模式 (0=清除，1=设置)
    GridLayout{
        visible: pageflag==5&&pageindex == 1?true:false  // 仅在pageflag=5时显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4
        
        // HPD位控制选项数据模型
        ListModel {
            id: earc_hpd_bit_ctl_model
            ListElement { first: "SET HDMI_HPD bit(=1)"; number: 1 }    // 设置HPD位为1选项
            ListElement { first: "CLEAR HDMI_HPD bit(=0)"; number: 0 }  // 清除HPD位为0选项
        }
        
        // 生成HPD位控制按钮
        Repeater{
            model: earc_hpd_bit_ctl_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: earc_hpd_bit_ctl_flag==number?"orange":"black"  // 选中状态高亮边框
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                
                // 按钮文字显示
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

                // 按钮点击处理
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        earc_hpd_bit_ctl_flag=number   // 更新选择标志
                        confirmsignal("eARC_HPD_bit_CTL",number)  // 发送控制信号给C++
                    }
                }
            }
        }
    }

    // HDMI +5V电源控制界面
    property int hdmi_5v_power_ctl_flag: 0   // 当前选择的电源控制模式 (0=关闭电源，1=开启电源)
    GridLayout{
        visible: pageflag==6&&pageindex == 1?true:false  // 仅在pageflag=6时显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 4
        
        // HDMI电源控制选项数据模型
        ListModel {
            id: hdmi_5v_power_ctl_model
            ListElement { first: "SET HDMI TX +5V ON"; number: 1 }   // 开启+5V电源选项
            ListElement { first: "SET HDMI TX +5V OFF"; number: 0 }  // 关闭+5V电源选项
        }
        
        // 生成电源控制按钮
        Repeater{
            model: hdmi_5v_power_ctl_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: hdmi_5v_power_ctl_flag==number?"orange":"black"  // 选中状态高亮边框
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                
                // 按钮文字显示
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

                // 按钮点击处理
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        hdmi_5v_power_ctl_flag=number   // 更新选择标志
                        confirmsignal("HDMI_5V_POWER_CTL",number)  // 发送电源控制信号给C++
                    }
                }
            }
        }
    }
}
