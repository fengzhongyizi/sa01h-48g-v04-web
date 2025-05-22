// 导入必要的 Qt 模块
import QtQuick 2.0                  // 提供 QML 基础组件
import QtQuick.Controls.Material 2.3 // 提供 Material 设计风格的控件
import QtQuick.Window 2.10          // 提供窗口相关功能
import QtQuick.Controls 2.3         // 提供 UI 控件如 Button, Label 等
import QtQuick.Layouts 1.3          // 提供 RowLayout, ColumnLayout 等布局管理器

// 状态页面组件 - 显示视频和音频信号的各种参数
Item {
    id: root
    anchors.fill: parent             // 填充父容器
    
    // 全局属性定义
    property int lineheight: 38      // 行高统一设置
    property int fontsize: 34        // 字体大小统一设置
    
    // 属性别名定义 - 便于外部组件访问和设置文本内容
    // 视频参数文本属性
    property alias modeText: mode_text.text           // 模式文本
    property alias hpdText: hpd_text.text             // HPD(Hot Plug Detect)状态
    property alias hdmiText: hdmi_text.text           // HDMI/DVI模式
    property alias btText: bt_text.text               // BT.2020色彩支持状态
    property alias hdcpText: hdcp_text.text           // HDCP(内容保护)版本
    property alias colordepthText: colordepth_text.text // 色彩深度
    property alias colorText: color_text.text         // 色彩空间
    property alias timingText: timing_text.text       // 时序信息
    
    // 音频参数文本属性
    property alias typeText: type_text.text           // 音频类型
    property alias samplerateText: samplerate_text.text // 采样率
    property alias audiobitText: audiobit_text.text   // 位深度
    property alias sinewaretoneText: sinewaretone_text.text // 正弦波音调
    property alias audiovolumeText: audiovolume_text.text   // 音量
    property alias channelsText: channels_text.text         // 声道信息

    // 视频输出标题
    Label {
        id: status_title
        anchors.horizontalCenter: parent.horizontalCenter // 水平居中
        anchors.top: parent.top
        anchors.topMargin: 55       // 顶部留白
        text: "Video Output"        // 显示文本
        font.family: myriadPro.name // 使用MyriadPro字体(在其他地方定义)
        font.pixelSize: 35
        color: "white"              // 文字颜色
    }
    
    // 标题下的分隔线
    Rectangle {
        id: line1
        height: 4
        width: parent.width
        border.width: 2
        border.color: "white"
        anchors.top: status_title.bottom
        anchors.topMargin: 5
    }

    // 注释掉的替代标题和容器设计
    // Label{
    //     id:video_title
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     anchors.top: parent.top
    //     anchors.topMargin: 5
    //     text: "Video Output"
    //     font.family: myriadPro.name
    //     font.pixelSize: 35
    //     color: "white"
    // }
    
    // 注释掉的视频输出容器
    // Rectangle{
    //     id:video_rect
    //     color: "gray"
    //     height: 550
    //     width: parent.width-4
    //     border.width: 1
    //     border.color: "white"
    //     radius: 5
    //     anchors.top: video_title.bottom
    //     anchors.topMargin: 0
    //     anchors.left: root.left
    //     anchors.leftMargin: 2

    // -------- 视频参数部分 --------
    // 模式标签
    Label {
        id: model_label
        anchors.top: line1.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: "Mode:"              // 显示文本
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 模式值显示区域
    Rectangle {
        id: mode_rect
        color: "white"               // 白色背景
        width: 150
        height: lineheight           // 使用预定义行高
        anchors.top: model_label.bottom
        anchors.left: model_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 模式文本
        Text {
            id: mode_text
            width: parent.width
            height: parent.height
            font.family: myriadPro.name
            anchors.centerIn: parent     // 在父矩形中居中
            verticalAlignment: Text.AlignVCenter      // 垂直居中
            horizontalAlignment: Text.AlignHCenter    // 水平居中
            font.pixelSize: fontsize
        }
    }
    
    // HPD标签
    Label {
        id: hpd_label
        anchors.top: mode_rect.bottom
        anchors.topMargin: 0
        anchors.left: model_label.left
        text: "Hpd:"               // 热插拔检测状态
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // HPD值显示区域
    Rectangle {
        id: hpd_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: hpd_label.bottom
        anchors.left: hpd_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // HPD文本
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
    
    // HDMI/DVI标签
    Label {
        id: hdmi_label
        anchors.top: hpd_rect.bottom
        anchors.topMargin: 0
        anchors.left: hpd_label.left
        text: "HDMI/DVI:"          // 接口类型
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // HDMI/DVI值显示区域
    Rectangle {
        id: hdmi_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: hdmi_label.bottom
        anchors.left: hdmi_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // HDMI/DVI文本
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
    
    // BT 2020标签
    Label {
        id: bt_label
        anchors.top: hdmi_rect.bottom
        anchors.topMargin: 0
        anchors.left: hdmi_label.left
        text: "BT 2020:"           // BT.2020色彩标准支持状态
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // BT 2020值显示区域
    Rectangle {
        id: bt_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: bt_label.bottom
        anchors.left: bt_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // BT 2020文本
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
    
    // HDCP标签
    Label {
        id: hdcp_label
        anchors.top: bt_rect.bottom
        anchors.topMargin: 0
        anchors.left: bt_label.left
        text: "HDCP:"             // 高带宽数字内容保护
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // HDCP值显示区域
    Rectangle {
        id: hdcp_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: hdcp_label.bottom
        anchors.left: hdcp_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // HDCP文本
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
    
    // 色彩深度标签
    Label {
        id: colordepth_label
        anchors.top: hdcp_rect.bottom
        anchors.topMargin: 0
        anchors.left: hdcp_label.left
        text: "ColorDepth:"       // 色彩位深
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 色彩深度值显示区域
    Rectangle {
        id: colordepth_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: colordepth_label.bottom
        anchors.left: colordepth_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 色彩深度文本
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
    
    // 色彩空间标签
    Label {
        id: color_label
        anchors.top: colordepth_rect.bottom
        anchors.topMargin: 0
        anchors.left: colordepth_label.left
        text: "Color:"            // 色彩空间
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 色彩空间值显示区域
    Rectangle {
        id: color_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: color_label.bottom
        anchors.left: color_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 色彩空间文本
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
    
    // 时序标签
    Label {
        id: timing_label
        anchors.top: color_rect.bottom
        anchors.topMargin: 0
        anchors.left: color_label.left
        text: "Timing:"           // 视频时序
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 时序值显示区域
    Rectangle {
        id: timing_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: timing_label.bottom
        anchors.left: timing_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 时序文本
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
    // 注释掉的视频矩形结束
    // }

    // -------- 音频参数部分 --------
    // 音频输出标题
    Label {
        id: audio_title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: timing_rect.bottom
        anchors.topMargin: 5
        text: "Audio Output"
        font.family: myriadPro.name
        font.pixelSize: 35
        color: "white"
    }
    
    // 标题下的分隔线
    Rectangle {
        id: line2
        height: 4
        width: parent.width
        border.width: 2
        border.color: "white"
        anchors.top: audio_title.bottom
        anchors.topMargin: 5
    }
    
    // 注释掉的音频输出容器
    // Rectangle{
    //     id:audio_rect
    //     color: "gray"
    //     height: 550
    //     width: parent.width-4
    //     border.width: 1
    //     border.color: "white"
    //     radius: 5
    //     anchors.top: audio_title.bottom
    //     anchors.topMargin: 0
    //     anchors.left: root.left
    //     anchors.leftMargin: 2

    // 音频类型标签
    Label {
        id: type_label
        anchors.top: line2.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: "Audio Type:"        // 音频类型(如PCM, AC3等)
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 音频类型值显示区域
    Rectangle {
        id: type_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: type_label.bottom
        anchors.left: type_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 音频类型文本
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
    
    // 采样率标签
    Label {
        id: samplerate_label
        anchors.top: type_rect.bottom
        anchors.topMargin: 0
        anchors.left: type_label.left
        text: "SampleRate:"        // 采样率(如44.1kHz, 48kHz等)
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 采样率值显示区域
    Rectangle {
        id: samplerate_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: samplerate_label.bottom
        anchors.left: samplerate_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 采样率文本
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
    
    // 音频位深标签
    Label {
        id: audiobit_label
        anchors.top: samplerate_rect.bottom
        anchors.topMargin: 0
        anchors.left: samplerate_label.left
        text: "Audio Bit:"         // 音频位深(如16bit, 24bit等)
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 音频位深值显示区域
    Rectangle {
        id: audiobit_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: audiobit_label.bottom
        anchors.left: audiobit_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 音频位深文本
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
    
    // 正弦波音调标签
    Label {
        id: sinewaretone_label
        anchors.top: audiobit_rect.bottom
        anchors.topMargin: 0
        anchors.left: audiobit_label.left
        text: "SinewareTone:"      // 正弦波音调频率
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 正弦波音调值显示区域
    Rectangle {
        id: sinewaretone_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: sinewaretone_label.bottom
        anchors.left: sinewaretone_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 正弦波音调文本
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
    
    // 音频音量标签
    Label {
        id: audiovolume_label
        anchors.top: sinewaretone_rect.bottom
        anchors.topMargin: 0
        anchors.left: sinewaretone_label.left
        text: "Audio Volume:"      // 音频音量
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 音频音量值显示区域
    Rectangle {
        id: audiovolume_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: audiovolume_label.bottom
        anchors.left: audiovolume_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 音频音量文本
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
    
    // 声道标签
    Label {
        id: channels_label
        anchors.top: audiovolume_rect.bottom
        anchors.topMargin: 0
        anchors.left: audiovolume_label.left
        text: "Channels:"          // 声道数(如2.0, 5.1等)
        font.family: myriadPro.name
        font.pixelSize: fontsize
        color: "white"
    }
    
    // 声道值显示区域
    Rectangle {
        id: channels_rect
        color: "white"
        width: 150
        height: lineheight
        anchors.top: channels_label.bottom
        anchors.left: channels_label.left
        anchors.right: parent.right
        anchors.rightMargin: 10

        // 声道文本
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
    // 注释掉的音频矩形结束
    // }
}