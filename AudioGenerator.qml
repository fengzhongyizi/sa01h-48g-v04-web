// AudioGenerator.qml
// 音频生成器组件 - 提供多种音频格式和配置选项的生成界面
// 主要功能区域包括：
// 1. PCM音频生成（采样率、位深度、正弦波音调、音量和声道配置）
// 2. Dolby音频生成（多种Dolby格式，包括Dolby Digital, Dolby Digital Plus, Dolby MAT等）
// 3. 外部模拟L/R输入
// 4. DTS音频生成（包括DTS Digital Surround, DTS-HD, DTS:X等）
// 
// 组件结构采用分页设计，通过pageflag和pageindex控制不同页面的显示和隐藏

// 该文件实现了一个复杂的音频生成器界面，支持多种音频格式和配置选项，包括：
// 1.主要音频类型：
// PCM音频 - 基本的未压缩数字音频
// Dolby音频 - 各种杜比音频格式
// 外部模拟L/R输入 - 外部音频输入
// DTS音频 - 各种DTS音频格式
// 2.音频参数配置：
// 采样率 - 从32kHz到192kHz
// 位深度 - 16位、20位、24位
// 正弦波音调 - 从100Hz到5kHz
// 音量控制 - 从-60dB到0dB
// 声道配置 - 从2.0到7.1.4多种环绕声配置
// 3.特殊测试功能：
// ARM嘴型同步测试 - 不同帧率(23Hz、24Hz、25Hz、29Hz、30Hz)的音画同步测试
// 整个界面使用了多级页面切换机制，通过pageflag和pageindex控制不同页面的显示和隐藏，实现了复杂的层级导航功能。


import QtQuick 2.0                // 导入基本的QtQuick模块
import QtQuick.Controls 2.5       // 导入控件模块，提供Button, Slider等UI元素
import QtQuick.Layouts 1.12       // 导入布局模块，提供GridLayout, RowLayout等布局功能

Rectangle {
    id: root
    anchors.fill: parent           // 填充父容器
    signal confirmsignal(string str, int num)  // 定义信号，当选择音频选项时发送
    
    // 页面控制属性
    property int pageindex: 0      // 控制二级页面索引
    property int pageflag: 0       // 控制一级页面索引
    
    // 按钮尺寸属性
    property int btnWidth: 300     // 按钮宽度
    property int btnHeight: 120    // 按钮高度
    property int btnfontsize: 35   // 按钮文字大小
    
    // 数据模型别名，便于外部访问
    property alias pcm_channel_model: pcm_channel_model                  // PCM声道配置模型
    property alias pcm_sinewave_tone_model: pcm_sinewave_tone_model      // PCM正弦波音调模型
    property alias pcm_sampling_rate_model: pcm_sampling_rate_model      // PCM采样率模型
    property alias pcm_bit_depth_model: pcm_bit_depth_model              // PCM位深度模型
    property alias pcmsinewaveModel: pcm_sinewave_tone_model             // PCM正弦波模型别名
    
    // Dolby音频相关数据模型
    property alias dolby_digital_model: dolby_digital_model              // Dolby Digital模型
    property alias dolby_digital_plus_model: dolby_digital_plus_model    // Dolby Digital Plus模型
    property alias dolby_mat_model: dolby_mat_model                      // Dolby MAT模型
    property alias dolby_mat_trueHD_model: dolby_mat_trueHD_model        // Dolby MAT TrueHD模型
    property alias dolby_my_streams_model: dolby_my_streams_model        // Dolby自定义流模型
    
    // Dolby ARM测试模型（不同帧率）
    property alias dobly_arm_30_model: dobly_arm_30_model                // 30Hz测试模型
    property alias dobly_arm_29_model: dobly_arm_29_model                // 29Hz测试模型
    property alias dobly_arm_25_model: dobly_arm_25_model                // 25Hz测试模型
    property alias dobly_arm_24_model: dobly_arm_24_model                // 24Hz测试模型
    property alias dobly_arm_23_model: dobly_arm_23_model                // 23Hz测试模型

    // 后退按钮 - 仅在子页面(pageflag > 0)显示
    CustomButton{
        id: back
        visible: pageflag == 0 ? false : true
        width: 150
        height: 80
        border.color: "black"
        border.width: 2
        color: flag ? 'gray' : 'black'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        property bool flag: false
        
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

    // 全局控制属性
    property int audioTypeFlag: 1      // 控制音频类型选择
    property int audioSelectFlag: 1    // 控制音频子选项选择
    
    // 主菜单页面 - 显示四种主要音频类型选项
    Column{
        visible: pageflag == 0 ? true : false  // 仅在主页面(pageflag=0)显示
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing: 100
        width: root.width
        
        // 第一行按钮 - PCM, Dolby, 外部输入
        RowLayout {
            width: parent.width

            // PCM音频按钮
            CustomButton{
                id: pcm
                width: btnWidth
                height: btnHeight
                border.color: audioTypeFlag === 1 ? "orange" : "black"  // 当前选择项高亮显示
                border.width: 4
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("PCM AUDIO")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入PCM音频页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm.flag = true
                        audioTypeFlag === 1
                    }
                    onReleased: {
                        pcm.flag = false
                        pageflag = 1    // 设置为PCM页面
                        pageindex = 1   // 进入子页面
                    }
                }
            }
            
            // Dolby音频按钮
            CustomButton{
                id: dobly
                width: btnWidth
                height: btnHeight
                border.color: audioTypeFlag === 2 ? "orange" : "black"
                border.width: 4
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DOLBY AUDIO GENERATOR")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入Dolby音频页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly.flag = true
                        audioTypeFlag === 2
                    }
                    onReleased: {
                        dobly.flag = false
                        pageflag = 2    // 设置为Dolby页面
                        pageindex = 1   // 进入子页面
                    }
                }
            }
            
            // 外部模拟输入按钮
            CustomButton{
                id: ext
                width: btnWidth
                height: btnHeight
                border.color: audioTypeFlag === 3 ? "orange" : "black"
                border.width: 4
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("EXT.ANALOG L/R INPUT")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入外部输入页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        ext.flag = true
                        audioTypeFlag === 3
                    }
                    onReleased: {
                        ext.flag = false
                        pageflag = 3    // 设置为外部输入页面
                        pageindex = 1   // 进入子页面
                    }
                }
            }
        }
        
        // 第二行按钮 - DTS和空白占位
        RowLayout {
            width: parent.width
            
            // DTS音频按钮
            CustomButton{
                id: dts
                width: btnWidth
                height: btnHeight
                border.color: audioTypeFlag === 4 ? "orange" : "black"
                border.width: 4
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DTS AUDIO GENERATOR")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入DTS音频页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts.flag = true
                        audioTypeFlag === 4
                    }
                    onReleased: {
                        dts.flag = false
                        pageflag = 4    // 设置为DTS页面
                        pageindex = 1   // 进入子页面
                    }
                }
            }
            
            // 空白占位按钮1
            CustomButton{
                id: empty1
                width: btnWidth
                height: btnHeight
                opacity: 0    // 不可见，仅作为布局占位
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            
            // 空白占位按钮2
            CustomButton{
                id: empty2
                width: btnWidth
                height: btnHeight
                opacity: 0    // 不可见，仅作为布局占位
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
    }

    // PCM音频页面设置
    property int pcmFlag: 1                  // PCM子选项控制
    property int pcm_select_width: 300       // PCM选择按钮宽度
    property int pcm_select_height: 120      // PCM选择按钮高度
    
    // PCM音频选项页面 - 显示PCM音频的五个配置选项
    Column{
        visible: pageindex == 1 && pageflag == 1 ? true : false  // 仅在PCM页面一级显示
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing: 100
        width: root.width
        
        // 第一行PCM选项按钮
        RowLayout {
            width: parent.width

            // PCM采样率按钮
            CustomButton{
                id: pcm_sampling_rate
                width: btnWidth
                height: btnHeight
                border.color: audioSelectFlag === 1 ? "orange" : "black"
                border.width: 4
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("Audio Sampling Rate")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入采样率设置页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_sampling_rate.flag = true
                    }
                    onReleased: {
                        pcm_sampling_rate.flag = false
                        pageindex = 2   // 进入二级页面
                        pcmFlag = 1     // 设置为采样率页面
                    }
                }
            }
            
            // PCM位深度按钮
            CustomButton{
                id: pcm_bit_depth
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("Audio Bit Depth")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入位深度设置页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_bit_depth.flag = true
                    }
                    onReleased: {
                        pcm_bit_depth.flag = false
                        pageindex = 2   // 进入二级页面
                        pcmFlag = 2     // 设置为位深度页面
                    }
                }
            }
            
            // PCM正弦波音调按钮
            CustomButton{
                id: pcm_sinewave_tone
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("Sinewave Tone")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入正弦波音调设置页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_sinewave_tone.flag = true
                    }
                    onReleased: {
                        pcm_sinewave_tone.flag = false
                        pageindex = 2   // 进入二级页面
                        pcmFlag = 3     // 设置为正弦波音调页面
                    }
                }
            }
        }
        // 第二行PCM选项按钮
        RowLayout {
            width: parent.width

            // PCM音量控制按钮
            CustomButton{
                id: pcm_volume
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("Audio Volume")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入音量控制页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_volume.flag = true
                    }
                    onReleased: {
                        pcm_volume.flag = false
                        pageindex = 2   // 进入二级页面
                        pcmFlag = 4     // 设置为音量控制页面
                    }
                }
            }
            
            // PCM声道配置按钮
            CustomButton{
                id: pcm_channel
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("Audio Channel Config")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入声道配置页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        pcm_channel.flag = true
                    }
                    onReleased: {
                        pcm_channel.flag = false
                        pageindex = 2   // 进入二级页面
                        pcmFlag = 5     // 设置为声道配置页面
                    }
                }
            }
            
            // 空白占位按钮
            CustomButton{
                id: empty3
                width: btnWidth
                height: btnHeight
                opacity: 0    // 不可见，仅作为布局占位
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
    }
    
    // PCM采样率选择页面
    property int pcm_sampling_rate_select: 1  // 保存当前选择的采样率
    GridLayout{
        visible: pageflag == 1 && pageindex == 2 && pcmFlag == 1 ? true : false  // 仅在PCM采样率页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing: 150
        rowSpacing: 50
        columns: 3  // 3列布局
        
        // 采样率数据模型 - 定义可选择的PCM采样率选项
        ListModel {
            id: pcm_sampling_rate_model
            ListElement { first: "32K"; number: 0x00 }    // 32kHz采样率
            ListElement { first: "44.1K"; number: 0x01 }  // 44.1kHz采样率(CD音质)
            ListElement { first: "48K"; number: 0x02 }    // 48kHz采样率(标准DVD音质)
            ListElement { first: "88K"; number: 0x03 }    // 88kHz采样率
            ListElement { first: "96K"; number: 0x04 }    // 96kHz采样率(高质量DVD音频)
            ListElement { first: "176K"; number: 0x05 }   // 176kHz采样率
            ListElement { first: "192K"; number: 0x06 }   // 192kHz采样率(高解析度音频)
        }
        
        // 采样率选择按钮生成
        Repeater{
            model: pcm_sampling_rate_model    // 使用上面定义的数据模型
            CustomButton{
                width: pcm_select_width
                height: pcm_select_height
                border.color: pcm_sampling_rate_select == number ? "orange" : "black"  // 当前选择项高亮
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first   // 显示采样率值
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 选择采样率并发送信号
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pcm_sampling_rate_select = number  // 更新选中状态
                        confirmsignal("AudioSamplingRate", number)  // 发送确认信号给后端处理
                    }
                }
            }
        }
    }
    
    // PCM位深度选择页面
    property int pcm_bit_depth_select: 1  // 保存当前选择的位深度
    GridLayout{
        visible: pageflag == 1 && pageindex == 2 && pcmFlag == 2 ? true : false  // 仅在PCM位深度页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing: 150
        rowSpacing: 50
        columns: 3  // 3列布局
        
        // 位深度数据模型 - 定义可选择的PCM位深度选项
        ListModel {
            id: pcm_bit_depth_model
            ListElement { first: "16Bit"; number: 0x00 }  // 16位(CD音质)
            ListElement { first: "20Bit"; number: 0x01 }  // 20位
            ListElement { first: "24Bit"; number: 0x02 }  // 24位(高解析度音频)
        }
        
        // 位深度选择按钮生成
        Repeater{
            model: pcm_bit_depth_model    // 使用上面定义的数据模型
            CustomButton{
                width: pcm_select_width
                height: pcm_select_height
                border.color: pcm_bit_depth_select == number ? "orange" : "black"  // 当前选择项高亮
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first   // 显示位深度值
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 选择位深度并发送信号
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pcm_bit_depth_select = number  // 更新选中状态
                        confirmsignal("AudioBitDepth", number)  // 发送确认信号给后端处理
                    }
                }
            }
        }
    }
    
    // PCM正弦波音调选择页面
    property int pcm_sinewave_tone_select: 1  // 保存当前选择的正弦波音调
    GridLayout{
        visible: pageflag == 1 && pageindex == 2 && pcmFlag == 3 ? true : false  // 仅在PCM正弦波音调页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        columnSpacing: 150
        rowSpacing: 50
        columns: 3  // 3列布局
        
        // 正弦波音调数据模型 - 定义可选择的频率选项
        ListModel {
            id: pcm_sinewave_tone_model
            ListElement { first: "SINEWAVE TONE(100Hz)"; second: "100Hz"; number: 0x00 }
            ListElement { first: "SINEWAVE TONE(200Hz)"; second: "200Hz"; number: 0x01 }
            ListElement { first: "SINEWAVE TONE(300Hz)"; second: "300Hz"; number: 0x02 }
            ListElement { first: "SINEWAVE TONE(400Hz)"; second: "400Hz"; number: 0x03 }
            ListElement { first: "SINEWAVE TONE(500Hz)"; second: "500Hz"; number: 0x04 }
            ListElement { first: "SINEWAVE TONE(600Hz)"; second: "600Hz"; number: 0x05 }
            ListElement { first: "SINEWAVE TONE(700Hz)"; second: "700Hz"; number: 0x06 }
            ListElement { first: "SINEWAVE TONE(800Hz)"; second: "800Hz"; number: 0x07 }
            ListElement { first: "SINEWAVE TONE(900Hz)"; second: "900Hz"; number: 0x08 }
            ListElement { first: "SINEWAVE TONE(1KHz)"; second: "1KHz"; number: 0x09 }
            ListElement { first: "SINEWAVE TONE(2KHz)"; second: "2KHz"; number: 0x0a }
            ListElement { first: "SINEWAVE TONE(3KHz)"; second: "3KHz"; number: 0x0b }
            ListElement { first: "SINEWAVE TONE(4KHz)"; second: "4KHz"; number: 0x0c }
            ListElement { first: "SINEWAVE TONE(5KHz)"; second: "5KHz"; number: 0x0d }
        }

        // 正弦波音调选择按钮生成
        Repeater{
            model: pcm_sinewave_tone_model    // 使用上面定义的音调数据模型
            CustomButton{
                width: pcm_select_width
                height: pcm_select_height
                border.color: pcm_sinewave_tone_select == number ? "orange" : "black"  // 当前选择项高亮
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first   // 显示音调名称
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理 - 选择音调并发送信号
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pcm_sinewave_tone_select = number  // 更新选中状态
                        confirmsignal("SinewaveTone", number)  // 发送确认信号给后端处理
                    }
                }
            }
        }
    }
    
    // PCM音量控制页面
    property int pcm_volume_value: -30  // 初始音量值，单位dB
    RowLayout {
        visible: pageflag == 1 && pageindex == 2 && pcmFlag == 4 ? true : false  // 仅在PCM音量控制页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Column{
                anchors.top: parent.top
                anchors.topMargin: 400
                spacing: 100
                width: root.width
                
                // 音量滑动条
                Slider {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-200
                    snapMode: Slider.SnapAlways     // 滑动时自动捕捉到最近的刻度值
                    stepSize: 6                     // 每步6dB
                    from: -60                       // 最小值-60dB
                    value: pcm_volume_value         // 当前值
                    to: 0                           // 最大值0dB
                    
                    // 值变化处理 - 更新音量并发送信号
                    onValueChanged:{
                        pcm_volume_value = value    // 更新音量值
                        confirmsignal("AudioVolume", Math.abs(value))  // 发送音量值给后端
                    }
                }
                
                // 音量显示标签
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: pcm_volume_value + "dB"   // 显示当前音量
                    font.family: myriadPro.name
                    font.pixelSize: 35
                }
            }
        }
    }
    
    // PCM声道配置选择页面
    property int pcm_channel_select: 0  // 当前选择的声道配置
    RowLayout {
        visible: pageflag == 1 && pageindex == 2 && pcmFlag == 5 ? true : false  // 仅在PCM声道配置页面显示
        width: parent.width
        anchors.top: root.top
        anchors.topMargin: 150

        Rectangle{
            visible: pageflag == 1 && pageindex == 2 && pcmFlag == 5 ? true : false
            width: root.width-20
            height: 800
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: "transparent"

            // 滚动视图 - 用于显示较多的声道配置选项
            ScrollView{
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn  // 始终显示垂直滚动条
                
                // 声道配置按钮网格布局
                GridLayout{
                    width: parent.width
                    columnSpacing: 140
                    rowSpacing: 50
                    columns: 3  // 3列布局
                    
                    // 声道配置数据模型 - 定义可选择的声道配置选项
                    ListModel {
                        id: pcm_channel_model
                        // 声道配置格式说明:
                        // FR=前右声道, FL=前左声道, FC=中置声道, LFE=低频效果声道
                        // RR=后右声道, RL=后左声道, RC=后中声道
                        // FRC=前右中声道, FLC=前左中声道, RRC=后右中声道, RLC=后左中声道
                        ListElement { first:"2CH (FR_FL)"; number:0x00 }                       // 2.0声道
                        ListElement { first:"2.1CH (LFE_FR_FL)"; number: 0x01 }                // 2.1声道
                        ListElement { first:"3CH (FC_FR_FL)"; number: 0x02 }                   // 3.0声道
                        ListElement { first:"3.1CH (FC_LFE_FR_FL)"; number: 0x03 }             // 3.1声道
                        ListElement { first:"3CH (RC_FR_FL)"; number: 0x04 }                   // 3.0声道(后置)
                        ListElement { first:"3.1CH (RC_LFE_FR_FL)"; number: 0x05 }             // 3.1声道(后置)
                        ListElement { first:"4CH (RC_LFE_FR_FL)"; number: 0x06 }               // 4.0声道
                        ListElement { first:"4.1CH (RC_FC_LFE_FR_FL)"; number: 0x07 }          // 4.1声道
                        ListElement { first:"4CH (RR_RL_FR_FL)"; number: 0x08 }                // 4.0声道(环绕)
                        ListElement { first:"4.1CH (RR_RL_LFE_FR_FL)"; number: 0x09 }          // 4.1声道(环绕)
                        ListElement { first:"5CH (RR_RL_FC_FR_FL)"; number: 0x0a }             // 5.0声道
                        ListElement { first:"5.1CH (RR_RL_FC_LFE_FR_FL)"; number: 0x0b }       // 5.1声道(标准家庭影院)
                        ListElement { first:"5CH (RC_RR_RL_FR_FL)"; number: 0x0c }             // 5.0声道(后置)
                        ListElement { first:"5.1CH (RC_RR_RL_LFE_FR_FL)"; number: 0x0d }       // 5.1声道(后置)
                        ListElement { first:"6CH (RC_RR_RL_FC_FR_FL)"; number: 0x0e }          // 6.0声道
                        ListElement { first:"6.1CH (RC_RR_RL_FC_LFE_FR_FL)"; number: 0x0f }    // 6.1声道
                        ListElement { first:"6CH (RRC_RLC_RR_RL_FR_FL)"; number: 0x10 }        // 6.0声道(后置环绕)
                        ListElement { first:"6.1CH (RRC_RLC_RR_RL_LFE_FR_FL)"; number: 0x11 }  // 6.1声道(后置环绕)
                        ListElement { first:"7CH (RRC_RLC_RR_RL_FC_FR_FL)"; number: 0x12 }     // 7.0声道
                        ListElement { first:"7.1CH (RRC_RLC_RR_RL_FC_LFE_FR_FL)"; number: 0x13 } // 7.1声道(标准高级家庭影院)
                        ListElement { first:"4CH (FRC_FLC_FR_FL)"; number: 0x14 }              // 4.0声道(前置环绕)
                        ListElement { first:"4.1CH (FRC_FLC_LFE_FR_FL)"; number: 0x15 }        // 4.1声道(前置环绕)
                        ListElement { first:"5CH (FRC_FLC_FC_FR_FL)"; number: 0x16 }           // 5.0声道(前置环绕)
                        ListElement { first:"5.1CH (FRC_FLC_FC_LFE_FR_FL)"; number: 0x17 }     // 5.1声道(前置环绕)
                        ListElement { first:"5CH (FRC_FLC_RC_FR_FL)"; number: 0x18 }           // 5.0声道(混合环绕)
                        ListElement { first:"5.1CH (FRC_FLC_RC_FC_FR_FL)"; number: 0x19 }      // 5.1声道(混合环绕)
                        ListElement { first:"6CH (FRC_FLC_RC_FC_FR_FL)"; number: 0x1a }        // 6.0声道(混合环绕)
                        ListElement { first:"6.1CH (FRC_FLC_RC_FC_LFE_FR_FL)"; number: 0x1b }  // 6.1声道(混合环绕)
                        ListElement { first:"6CH (FRC_FLC_RR_RL_FR_FL)"; number: 0x1c }        // 6.0声道(全环绕)
                        ListElement { first:"6.1CH (FRC_FLC_RR_RL_LFE_FR_FL)"; number: 0x1d }  // 6.1声道(全环绕)
                        ListElement { first:"7CH (FRC_FLC_RR_RL_FC_FR_FL)"; number: 0x1e }     // 7.0声道(全环绕)
                        ListElement { first:"7.1CH (FRC_FLC_RR_RL_FC_LFE_FR_FL)"; number: 0x1f } // 7.1声道(全环绕)
                    }
                    
                    // 声道配置选择按钮生成
                    Repeater{
                        model: pcm_channel_model    // 使用上面定义的声道模型
                        CustomButton{
                            width: pcm_select_width+160  // 声道名称较长，按钮宽度增加
                            height: pcm_select_height
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            border.color: pcm_channel_select == number ? "orange" : "black"  // 当前选择项高亮
                            border.width: 4
                            color: 'black'
                            
                            Column{
                                anchors.centerIn: parent
                                Text {
                                    text: first   // 显示声道配置名称
                                    font.family: myriadPro.name
                                    font.pixelSize: btnfontsize
                                    color: "white"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            // 点击处理 - 选择声道配置并发送信号
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    pcm_channel_select = number  // 更新选中状态
                                    confirmsignal("AudioChannelConfig", number)  // 发送确认信号给后端处理
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Dolby音频相关设置
    property int dolbyFlag: 1               // Dolby子选项控制
    property int dolby_select: 1            // 当前选择的Dolby选项
    property int dolby_select_width: 300    // Dolby选择按钮宽度
    property int dolby_select_height: 120   // Dolby选择按钮高度
    
    // Dolby音频选项页面 - 显示多种Dolby音频格式选项
    Column{
        visible: pageindex == 1 && pageflag == 2 ? true : false  // 仅在Dolby页面一级显示
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing: 100
        width: root.width
        
        // 第一行Dolby选项按钮
        RowLayout {
            width: parent.width

            // Dolby Digital按钮
            CustomButton{
                id: dolby_digital
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DOLBY Digital")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入Dolby Digital页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_digital.flag = true
                    }
                    onReleased: {
                        dolby_digital.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 1   // 设置为Dolby Digital页面
                    }
                }
            }
            
            // Dolby Digital Plus按钮
            CustomButton{
                id: dolby_digital_plus
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DOLBY Digital Plus")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入Dolby Digital Plus页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_digital_plus.flag = true
                    }
                    onReleased: {
                        dolby_digital_plus.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 2   // 设置为Dolby Digital Plus页面
                    }
                }
            }
            
            // Dolby MAT按钮
            CustomButton{
                id: dolby_mat
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DOLBY MAT")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入Dolby MAT页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_mat.flag = true
                    }
                    onReleased: {
                        dolby_mat.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 3   // 设置为Dolby MAT页面
                    }
                }
            }
        }

        // 第二行Dolby选项按钮
        RowLayout {
            width: parent.width

            // Dolby MAT (TrueHD)按钮
            CustomButton{
                id: dolby_mat_trueHD
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DOLBY MAT(DOLBY TrueHD)")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入Dolby MAT TrueHD页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dolby_mat_trueHD.flag = true
                    }
                    onReleased: {
                        dolby_mat_trueHD.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 4   // 设置为Dolby MAT TrueHD页面
                    }
                }
            }
            
            // My Streams按钮 - 自定义Dolby流
            CustomButton{
                id: dobly_my_streams
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("MY Streams")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入自定义流页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_my_streams.flag = true
                    }
                    onReleased: {
                        dobly_my_streams.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 5   // 设置为My Streams页面
                    }
                }
            }
            
            // ARM 30HZ按钮 - 30Hz嘴型同步测试
            CustomButton{
                id: dobly_arm_30
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("ARM 30HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入ARM 30HZ页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_30.flag = true
                    }
                    onReleased: {
                        dobly_arm_30.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 6   // 设置为ARM 30HZ页面
                    }
                }
            }
        }
        
        // 第三行Dolby选项按钮
        RowLayout {
            width: parent.width

            // ARM 29HZ按钮 - 29Hz嘴型同步测试
            CustomButton{
                id: dobly_arm_29
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("ARM 29HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入ARM 29HZ页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_29.flag = true
                    }
                    onReleased: {
                        dobly_arm_29.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 7   // 设置为ARM 29HZ页面
                    }
                }
            }
            
            // ARM 25HZ按钮 - 25Hz嘴型同步测试
            CustomButton{
                id: dobly_arm_25
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("ARM 25HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入ARM 25HZ页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_25.flag = true
                    }
                    onReleased: {
                        dobly_arm_25.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 8   // 设置为ARM 25HZ页面
                    }
                }
            }
            
            // ARM 24HZ按钮 - 24Hz嘴型同步测试
            CustomButton{
                id: dobly_arm_24
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("ARM 24HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入ARM 24HZ页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_24.flag = true
                    }
                    onReleased: {
                        dobly_arm_24.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 9   // 设置为ARM 24HZ页面
                    }
                }
            }
        }
        
        // 第四行Dolby选项按钮
        RowLayout {
            width: parent.width

            // ARM 23HZ按钮 - 23Hz嘴型同步测试
            CustomButton{
                id: dobly_arm_23
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("ARM 23HZ")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入ARM 23HZ页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dobly_arm_23.flag = true
                    }
                    onReleased: {
                        dobly_arm_23.flag = false
                        pageindex = 2   // 进入二级页面
                        dolbyFlag = 10  // 设置为ARM 23HZ页面
                    }
                }
            }
            
            // 空白占位按钮1
            CustomButton{
                id: dobly_empty1
                width: btnWidth
                height: btnHeight
                opacity: 0    // 不可见，仅作为布局占位
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
            }
            
            // 空白占位按钮2
            CustomButton{
                id: dobly_empty2
                width: btnWidth
                height: btnHeight
                opacity: 0    // 不可见，仅作为布局占位
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
            }
        }
    }
    
    // Dolby Digital格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 1 ? true : false  // 仅在Dolby Digital页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // Dolby Digital格式数据模型 - 定义可选择的格式选项
                ListModel {
                    id: dolby_digital_model
                    ListElement { first: "Dolby Digital-32KHz-2.0Ch"; number: 0x02 }    // 32kHz采样率2.0声道
                    ListElement { first: "Dolby Digital-32KHz-5.1Ch"; number: 0x03 }    // 32kHz采样率5.1声道
                    ListElement { first: "Dolby Digital-44.1KHz-2.0Ch"; number: 0x04 }  // 44.1kHz采样率2.0声道
                    ListElement { first: "Dolby Digital-44.1KHz-5.1Ch"; number: 0x05 }  // 44.1kHz采样率5.1声道
                    ListElement { first: "Dolby Digital-48KHz-2.0Ch"; number: 0x06 }    // 48kHz采样率2.0声道(标准格式)
                    ListElement { first: "Dolby Digital-48KHz-5.1Ch"; number: 0x07 }    // 48kHz采样率5.1声道(标准格式)
                }
                
                // Dolby Digital格式选择按钮生成
                Repeater{
                    model: dolby_digital_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Dolby Digital Plus格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 2 ? true : false  // 仅在Dolby Digital Plus页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // Dolby Digital Plus格式数据模型 - 定义可选择的格式选项
                ListModel {
                    id: dolby_digital_plus_model
                    ListElement { first: "Dolby Digital-Plus-48KHz-2.0Ch"; number: 0x08 }    // 48kHz采样率2.0声道
                    ListElement { first: "Dolby Digital-Plus-48KHz-5.1Ch"; number: 0x09 }    // 48kHz采样率5.1声道
                    ListElement { first: "Dolby Digital-Plus-48KHz-7.1Ch"; number: 0x0a }    // 48kHz采样率7.1声道
                    ListElement { first: "Dolby Digital-Plus-48KHz-Atmos"; number: 0x0b }    // 48kHz采样率Atmos格式
                }
                
                // Dolby Digital Plus格式选择按钮生成
                Repeater{
                    model: dolby_digital_plus_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }

    // Dolby MAT格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 3 ? true : false  // 仅在Dolby MAT页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 2  // 2列布局，因为名称较长
                
                // Dolby MAT格式数据模型 - 定义可选择的格式选项
                ListModel {
                    id: dolby_mat_model
                    // MAT = Metadata-enhanced Audio Transmission，支持对象音频传输
                    ListElement { first: "Dolby MAT(PCM)-44.1KHz-2.0Ch"; number: 0x0c }       // 44.1kHz采样率2.0声道
                    ListElement { first: "Dolby MAT(PCM)-44.1KHz-5.1Ch"; number: 0x0d }       // 44.1kHz采样率5.1声道
                    ListElement { first: "Dolby MAT(PCM)-44.1KHz-7.1Ch"; number: 0x0e }       // 44.1kHz采样率7.1声道
                    ListElement { first: "Dolby MAT(PCM)-48KHz-2.0Ch"; number: 0x0f }         // 48kHz采样率2.0声道
                    ListElement { first: "Dolby MAT(PCM)-48KHz-5.1Ch"; number: 0x10 }         // 48kHz采样率5.1声道
                    ListElement { first: "Dolby MAT(PCM)-48KHz-7.1Ch"; number: 0x11 }         // 48kHz采样率7.1声道
                    ListElement { first: "Dolby MAT(PCM object audio)-44.1KHz-Dolby Atmos"; number: 0x12 }  // 44.1kHz采样率Atmos对象音频
                    ListElement { first: "Dolby MAT(PCM object audio)-48KHz-Dolby Atmos"; number: 0x13 }    // 48kHz采样率Atmos对象音频
                }
                
                // Dolby MAT格式选择按钮生成
                Repeater{
                    model: dolby_mat_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width+80  // 名称较长，增加宽度
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Dolby MAT TrueHD格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 4 ? true : false  // 仅在Dolby MAT TrueHD页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 2  // 2列布局，因为名称较长
                
                // Dolby MAT TrueHD格式数据模型 - 定义可选择的格式选项
                ListModel {
                    id: dolby_mat_trueHD_model
                    // TrueHD是Dolby的无损音频编码格式，通过MAT传输可以保持无损质量
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-48KHz-2.0Ch"; number: 0x14 }      // 48kHz采样率2.0声道
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-48KHz-5.1Ch"; number: 0x15 }      // 48kHz采样率5.1声道
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-48KHz-7.1Ch"; number: 0x16 }      // 48kHz采样率7.1声道
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-96KHz-2.0Ch"; number: 0x17 }      // 96kHz采样率2.0声道(高分辨率)
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-96KHz-5.1Ch"; number: 0x18 }      // 96kHz采样率5.1声道(高分辨率)
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-96KHz-7.1Ch"; number: 0x19 }      // 96kHz采样率7.1声道(高分辨率)
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-192KHz-2.0Ch"; number: 0x1a }     // 192kHz采样率2.0声道(超高分辨率)
                    ListElement { first: "Dolby MAT(Dolby TrueHD)-192KHz-5.1Ch"; number: 0x1b }     // 192kHz采样率5.1声道(超高分辨率)
                    ListElement { first: "Dolby MAT(Dolby TrueHD)Object Based 48KHz-Dolby Atmos"; number: 0x1c }  // 48kHz Atmos对象音频
                }
                
                // Dolby MAT TrueHD格式选择按钮生成
                Repeater{
                    model: dolby_mat_trueHD_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Dolby MY Streams格式选择页面 - 自定义Dolby流
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 5 ? true : false  // 仅在Dolby MY Streams页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // Dolby MY Streams数据模型 - 用户自定义的Dolby流
                ListModel {
                    id: dolby_my_streams_model
                    // 自定义流允许用户加载自己的Dolby编码内容
                    ListElement { first: "MY STREAM1"; second:"()"; number: 0x0120 }  // 自定义流1
                    ListElement { first: "MY STREAM2"; second:"()"; number: 0x0134 }  // 自定义流2
                    ListElement { first: "MY STREAM3"; second:"()"; number: 0x0148 }  // 自定义流3
                    ListElement { first: "MY STREAM4"; second:"()"; number: 0x015c }  // 自定义流4
                    ListElement { first: "MY STREAM5"; second:"()"; number: 0x0170 }  // 自定义流5
                    ListElement { first: "MY STREAM6"; second:"()"; number: 0x0184 }  // 自定义流6
                }
                
                // Dolby MY Streams选择按钮生成
                Repeater{
                    model: dolby_my_streams_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示流名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: second  // 显示流描述(当前为空)
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择流并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Dolby ARM 30Hz测试格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 6 ? true : false  // 仅在Dolby ARM 30Hz页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 2  // 2列布局，因为名称较长
                
                // Dolby ARM 30Hz测试数据模型 - 嘴型同步测试30Hz
                ListModel {
                    id: dobly_arm_30_model
                    // ARM = Audio Reference Media，用于音频参考测试，尤其是嘴型同步测试
                    // 30Hz表示视频帧率为30Hz时的测试
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_30HZ"; number: 0x1d }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_30HZ"; number: 0x1e }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_30HZ"; number: 0x22 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_30HZ"; number: 0x26 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_30HZ"; number: 0x2a }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_30HZ"; number: 0x2e }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_30HZ"; number: 0x32 }
                }
                
                // Dolby ARM 30Hz选择按钮生成
                Repeater{
                    model: dobly_arm_30_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示测试名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择测试并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }

    // Dolby ARM 29Hz测试格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 7 ? true : false  // 仅在Dolby ARM 29Hz页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 2  // 2列布局，因为名称较长
                
                // Dolby ARM 29Hz测试数据模型 - 嘴型同步测试29Hz
                ListModel {
                    id: dobly_arm_29_model
                    // ARM嘴型同步测试 - 29.97Hz帧率(NTSC电视标准)
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_29HZ"; number: 0x36 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_29HZ"; number: 0x37 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_29HZ"; number: 0x3a }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_29HZ"; number: 0x3e }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_29HZ"; number: 0x47 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_29HZ"; number: 0x50 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_29HZ"; number: 0x59 }
                }
                
                // Dolby ARM 29Hz选择按钮生成
                Repeater{
                    model: dobly_arm_29_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示测试名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择测试并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Dolby ARM 25Hz测试格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 8 ? true : false  // 仅在Dolby ARM 25Hz页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 2  // 2列布局，因为名称较长
                
                // Dolby ARM 25Hz测试数据模型 - 嘴型同步测试25Hz
                ListModel {
                    id: dobly_arm_25_model
                    // ARM嘴型同步测试 - 25Hz帧率(PAL电视标准)
                    // 注意：数据模型名称显示24Hz，但实际使用的25Hz数据，可能是标签错误
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_24HZ"; number: 0xe0 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_24HZ"; number: 0xe9 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_24HZ"; number: 0xf2 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_24HZ"; number: 0xfb }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_24HZ"; number: 0x104 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_24HZ"; number: 0x10d }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_24HZ"; number: 0x116 }
                }
                
                // Dolby ARM 25Hz选择按钮生成
                Repeater{
                    model: dobly_arm_25_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示测试名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择测试并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Dolby ARM 24Hz测试格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 9 ? true : false  // 仅在Dolby ARM 24Hz页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 2  // 2列布局，因为名称较长
                
                // Dolby ARM 24Hz测试数据模型 - 嘴型同步测试24Hz
                ListModel {
                    id: dobly_arm_24_model
                    // ARM嘴型同步测试 - 24Hz帧率(电影标准)
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_24HZ"; number: 0x62 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_24HZ"; number: 0x6b }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_24HZ"; number: 0x74 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_24HZ"; number: 0x7d }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_24HZ"; number: 0x86 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_24HZ"; number: 0x8f }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_24HZ"; number: 0x98 }
                }
                
                // Dolby ARM 24Hz选择按钮生成
                Repeater{
                    model: dobly_arm_24_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示测试名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择测试并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Dolby ARM 23Hz测试格式选择页面
    RowLayout {
        visible: pageflag == 2 && pageindex == 2 && dolbyFlag == 10 ? true : false  // 仅在Dolby ARM 23Hz页面显示
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 150
        Rectangle{
            width: root.width-20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 2  // 2列布局，因为名称较长
                
                // Dolby ARM 23Hz测试数据模型 - 嘴型同步测试23Hz
                ListModel {
                    id: dobly_arm_23_model
                    // ARM嘴型同步测试 - 23.976Hz帧率(胶片转换为数字视频标准)
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital_48K_2CH_23HZ"; number: 0xa1 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby Digital-Plus_48K_2CH_23HZ"; number: 0xaa }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(PCM)_48K_2CH_23HZ"; number: 0xb3 }
                    ListElement { first: "ARM_LIP_SYNC_Dolby MAT(Dolby TrueHD)_48K_2CH_23HZ"; number: 0xbc }
                    ListElement { first: "ARM_LIP_SYNC_ATM_Dolby Digital_48K_23HZ"; number: 0xc5 }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(PCM)_48K_23HZ"; number: 0xce }
                    ListElement { first: "ARM_LIP_SYNC_ATM_MAT(Dolby TrueHD)_48K_23HZ"; number: 0xd7 }
                }
                
                // Dolby ARM 23Hz选择按钮生成
                Repeater{
                    model: dobly_arm_23_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示测试名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择测试并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DolbyAudioGenerator", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 外部模拟L/R输入页面
    RowLayout {
        visible: pageflag == 3 && pageindex == 1 ? true : false  // 仅在外部输入页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Column{
                anchors.top: parent.top
                anchors.topMargin: 400
                spacing: 100
                width: root.width
                
                // 启用外部输入按钮
                CustomButton{
                    width: 456
                    height: 120
                    border.color: dolby_select == 0x00 ? "orange" : "black"
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
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // 点击处理 - 启用外部模拟输入
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            dolby_select = 0x00  // 更新选中状态
                            confirmsignal("EXT", 0x00)  // 发送启用外部输入的信号
                        }
                    }
                }
            }
        }
    }

    // DTS音频相关设置
    property int dtsFlag: 1  // DTS子选项控制
    
    // DTS音频选项页面 - 显示多种DTS音频格式选项
    Column{
        visible: pageindex == 1 && pageflag == 4 ? true : false  // 仅在DTS页面一级显示
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing: 100
        width: root.width
        
        // 第一行DTS选项按钮
        RowLayout {
            width: parent.width

            // DTS Digital Surround按钮
            CustomButton{
                id: dts_digital_surround
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DTS Digital Surround")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入DTS Digital Surround页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_digital_surround.flag = true
                    }
                    onReleased: {
                        dts_digital_surround.flag = false
                        pageindex = 2   // 进入二级页面
                        dtsFlag = 1     // 设置为DTS Digital Surround页面
                    }
                }
            }
            
            // DTS-HD High Resolution按钮
            CustomButton{
                id: dts_hd_high_resolution
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DTS-HD High Resolution")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入DTS-HD High Resolution页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_hd_high_resolution.flag = true
                    }
                    onReleased: {
                        dts_hd_high_resolution.flag = false
                        pageindex = 2   // 进入二级页面
                        dtsFlag = 2     // 设置为DTS-HD High Resolution页面
                    }
                }
            }
            
            // DTS-HD Master Audio按钮
            CustomButton{
                id: dts_hd_master_audio
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DTS-HD Master Audio")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入DTS-HD Master Audio页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_hd_master_audio.flag = true
                    }
                    onReleased: {
                        dts_hd_master_audio.flag = false
                        pageindex = 2   // 进入二级页面
                        dtsFlag = 3     // 设置为DTS-HD Master Audio页面
                    }
                }
            }
        }

        // 第二行DTS选项按钮
        RowLayout {
            width: parent.width

            // DTS:X按钮
            CustomButton{
                id: dts_x
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DTS:X")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入DTS:X页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_x.flag = true
                    }
                    onReleased: {
                        dts_x.flag = false
                        pageindex = 2   // 进入二级页面
                        dtsFlag = 4     // 设置为DTS:X页面
                    }
                }
            }
            
            // DTS Express按钮
            CustomButton{
                id: dts_express
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("DTS Express")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入DTS Express页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_express.flag = true
                    }
                    onReleased: {
                        dts_express.flag = false
                        pageindex = 2   // 进入二级页面
                        dtsFlag = 5     // 设置为DTS Express页面
                    }
                }
            }
            
            // DTS MY STREAMS按钮 - 自定义DTS流
            CustomButton{
                id: dts_my_streams
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("MY STREAMS")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                // 点击处理 - 进入DTS MY STREAMS页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        dts_my_streams.flag = true
                    }
                    onReleased: {
                        dts_my_streams.flag = false
                        pageindex = 2   // 进入二级页面
                        dtsFlag = 6     // 设置为DTS My Streams页面
                    }
                }
            }
        }
    }
    
    // DTS Digital Surround格式选择页面
    RowLayout {
        visible: pageflag == 4 && pageindex == 2 && dtsFlag == 1 ? true : false  // 仅在DTS Digital Surround页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // DTS Digital Surround格式数据模型
                ListModel {
                    id: dts_digital_surround_model
                    // DTS Digital Surround是基础的DTS多声道格式
                    ListElement { first: "DTS Digital Surround-48KHz-2.0Ch"; number: 0x0232 }   // 48kHz采样率2.0声道
                    ListElement { first: "DTS Digital Surround-48KHz-5.1Ch"; number: 0x0233 }   // 48kHz采样率5.1声道
                    ListElement { first: "DTS Digital Surround-48.1KHz-6.1Ch"; number: 0x0234 } // 48.1kHz采样率6.1声道
                    ListElement { first: "DTS Digital Surround-44.1KHz-5.1Ch"; number: 0x0235 } // 44.1kHz采样率5.1声道
                    ListElement { first: "DTS Digital Surround-96KHz-5.1Ch"; number: 0x0236 }   // 96kHz采样率5.1声道
                }
                
                // DTS Digital Surround格式选择按钮生成
                Repeater{
                    model: dts_digital_surround_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DTX", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // DTS-HD High Resolution格式选择页面
    RowLayout {
        visible: pageflag == 4 && pageindex == 2 && dtsFlag == 2 ? true : false  // 仅在DTS-HD High Resolution页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // DTS-HD High Resolution格式数据模型
                ListModel {
                    id: dts_hd_high_resolution_model
                    // DTS-HD High Resolution是DTS的高解析度有损格式
                    ListElement { first: "DTS-HD High Resolution-48KHz-5.1Ch"; number: 0x0237 }  // 48kHz采样率5.1声道
                    ListElement { first: "DTS-HD High Resolution-48KHz-7.1Ch"; number: 0x0238 }  // 48kHz采样率7.1声道
                    ListElement { first: "DTS-HD High Resolution-96KHz-7.1Ch"; number: 0x0239 }  // 96kHz采样率7.1声道
                    ListElement { first: "DTS-HD High Resolution-88.2KHz-7.1Ch"; number: 0x023a } // 88.2kHz采样率7.1声道
                }
                
                // DTS-HD High Resolution格式选择按钮生成
                Repeater{
                    model: dts_hd_high_resolution_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DTX", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // DTS-HD Master Audio格式选择页面
    RowLayout {
        visible: pageflag == 4 && pageindex == 2 && dtsFlag == 3 ? true : false  // 仅在DTS-HD Master Audio页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // DTS-HD Master Audio格式数据模型
                ListModel {
                    id: dts_hd_master_audio_model
                    // DTS-HD Master Audio是DTS的无损音频编码格式
                    ListElement { first: "DTS-HD Master Audio-48KHz-5.1Ch"; number: 0x023b }   // 48kHz采样率5.1声道
                    ListElement { first: "DTS-HD Master Audio-48KHz-7.1Ch"; number: 0x023c }   // 48kHz采样率7.1声道
                    ListElement { first: "DTS-HD Master Audio-192KHz-2.0Ch"; number: 0x023d }  // 192kHz采样率2.0声道
                    ListElement { first: "DTS-HD Master Audio-192KHz-7.1Ch"; number: 0x023e }  // 192kHz采样率7.1声道
                }
                
                // DTS-HD Master Audio格式选择按钮生成
                Repeater{
                    model: dts_hd_master_audio_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DTX", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // DTS:X格式选择页面
    RowLayout {
        visible: pageflag == 4 && pageindex == 2 && dtsFlag == 4 ? true : false  // 仅在DTS:X页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // DTS:X格式数据模型
                ListModel {
                    id: dts_x_model
                    // DTS:X是DTS的对象音频格式，类似于Dolby Atmos
                    ListElement { first: "DTS:X-48KHz-7.1.4Ch"; number: 0x023f }               // 48kHz采样率7.1.4声道(带高度通道)
                    ListElement { first: "DTS:X-48KHz-5.1.4Ch"; number: 0x0240 }               // 48kHz采样率5.1.4声道(带高度通道)
                    ListElement { first: "DTS:X Master Audio-48KHz-7.1.4Ch"; number: 0x0241 }  // 48kHz采样率7.1.4声道无损
                    ListElement { first: "DTS:X Master Audio-96KHz-7.1.4Ch"; number: 0x0242 }  // 96kHz采样率7.1.4声道无损(高分辨率)
                    ListElement { first: "DTS:X(32 Objects)"; number: 0x0243 }                 // 32个音频对象的DTS:X
                }
                
                // DTS:X格式选择按钮生成
                Repeater{
                    model: dts_x_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示格式名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择格式并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DTX", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
    
    // DTS Express格式选择页面
    RowLayout {
        visible: pageflag == 4 && pageindex == 2 && dtsFlag == 5 ? true : false  // 仅在DTS Express页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Column{
                anchors.top: parent.top
                anchors.topMargin: 400
                spacing: 100
                width: root.width
                
                // DTS Low Bit Rate按钮 - 这是DTS Express的低比特率版本
                CustomButton{
                    width: 456
                    height: 120
                    border.color: dolby_select == 0x0244 ? "orange" : "black"
                    border.width: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'black'
                    
                    Column{
                        anchors.centerIn: parent
                        Text {
                            text: "DTS Low Bit Rate-48KHz-5.1Ch"  // 低比特率DTS，48kHz采样率5.1声道
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // 点击处理 - 选择格式并发送信号
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            dolby_select = 0x0244  // 更新选中状态
                            confirmsignal("DTX", 0x0244)  // 发送确认信号给后端处理
                        }
                    }
                }
            }
        }
    }
    
    // DTS MY STREAMS选择页面 - 自定义DTS流
    RowLayout {
        visible: pageflag == 4 && pageindex == 2 && dtsFlag == 6 ? true : false  // 仅在DTS MY STREAMS页面显示
        width: parent.width
        Rectangle{
            width: root.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            GridLayout{
                anchors.top: parent.top
                anchors.topMargin: 150
                width: parent.width
                columnSpacing: 150
                rowSpacing: 50
                columns: 3  // 3列布局
                
                // DTS MY STREAMS数据模型
                ListModel {
                    id: dts_my_streams_model
                    // 用户自定义的DTS流
                    ListElement { first: "MY STREAM1"; second:"()"; number: 0x0245 }  // 自定义流1
                    ListElement { first: "MY STREAM2"; second:"()"; number: 0x0259 }  // 自定义流2
                    ListElement { first: "MY STREAM3"; second:"()"; number: 0x026d }  // 自定义流3
                    ListElement { first: "MY STREAM4"; second:"()"; number: 0x0281 }  // 自定义流4
                    ListElement { first: "MY STREAM5"; second:"()"; number: 0x0295 }  // 自定义流5
                    ListElement { first: "MY STREAM6"; second:"()"; number: 0x02a9 }  // 自定义流6
                }
                
                // DTS MY STREAMS选择按钮生成
                Repeater{
                    model: dts_my_streams_model  // 使用上面定义的数据模型
                    CustomButton{
                        width: dolby_select_width
                        height: dolby_select_height
                        border.color: dolby_select == number ? "orange" : "black"  // 当前选择项高亮
                        border.width: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: 'black'
                        
                        Column{
                            anchors.centerIn: parent
                            Text {
                                text: first   // 显示流名称
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: second   // 显示流描述(当前为空)
                                font.family: myriadPro.name
                                font.pixelSize: btnfontsize
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // 点击处理 - 选择流并发送信号
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                dolby_select = number  // 更新选中状态
                                confirmsignal("DTX", number)  // 发送确认信号给后端处理
                            }
                        }
                    }
                }
            }
        }
    }
}
