// AudioTests.qml
// 音频测试组件 - 用于执行各种音频测试，包括扬声器测试和同步测试
// 提供扬声器配置、白噪声测试和音频扫描功能

// 这个文件实现了一个音频测试工具界面，主要功能包括：
// 1.主页面：提供两种测试选项 - 源扬声器测试和同步延迟测试
// 2.源扬声器测试：包含三种测试模式 
//   扬声器分配：可能用于配置扬声器设置
//   白噪声测试：使用白噪声信号测试各个声道
//   扫频音频测试：使用扫频信号测试各个声道的频率响应
// 3.交互式扬声器布局：
//   显示7.1声道环绕声系统的扬声器布局
//   包含8个可单独点击选择的扬声器按钮（FL, FC, FR, SL, SR, BL, BR, LFE）
//   每个按钮显示其声道名称和对应通道号
//   点击按钮可以切换该声道的测试状态
// 整个界面使用了多级页面切换机制，通过pageflag和pageindex控制不同页面的显示和隐藏，实现了层级导航功能。

import QtQuick 2.0                // 导入基本的QtQuick模块
import QtQuick.Controls 2.5       // 导入控件模块，提供按钮等UI元素
import QtQuick.Layouts 1.12       // 导入布局模块，提供RowLayout等布局功能

Rectangle {
    id: root
    anchors.fill: parent           // 填充父容器
    
    // 页面控制属性
    property int pageindex: 0      // 控制二级页面索引
    property int pageflag: 0       // 控制一级页面索引
    
    // 按钮尺寸属性
    property int btnWidth: 250     // 主按钮宽度
    property int btnHeight: 100    // 主按钮高度

    // 返回按钮 - 仅在子页面(pageflag > 0)显示
    Rectangle{
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
            font.pixelSize: 25
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
                    pageflag = 0    // 从一级子页面返回主页面
                    pageindex = 0
                }else if(pageindex == 2){
                    pageindex = 1   // 从二级子页面返回一级子页面
                }
            }
        }
    }

    // 主菜单页面 - 显示主要测试选项
    Column{
        visible: pageflag == 0 ? true : false  // 仅在主页面(pageflag=0)显示
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing: 100
        width: root.width
        
        RowLayout {
            width: parent.width

            // 源-扬声器测试按钮
            Rectangle{
                id: source_speaker_test
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("SOURCE-SPEAKER TEST")  // 源-扬声器测试
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                // 点击处理 - 进入源-扬声器测试页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        source_speaker_test.flag = true
                    }
                    onReleased: {
                        source_speaker_test.flag = false
                        pageflag = 1    // 设置为源-扬声器测试页面
                        pageindex = 1   // 进入子页面
                    }
                }
            }
            
            // 同步和延迟测试按钮
            Rectangle{
                id: sync_latency_test
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("SYNC&LATENCY TEST")  // 同步和延迟测试
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                // 点击处理 - 进入同步和延迟测试页面
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        sync_latency_test.flag = true
                    }
                    onReleased: {
                        sync_latency_test.flag = false
                        pageflag = 2    // 设置为同步和延迟测试页面
                        pageindex = 1   // 进入子页面
                    }
                }
            }
        }
    }

    // 源-扬声器测试设置
    property int source_speaker_flag: 1  // 控制源-扬声器测试子选项
    
    // 源-扬声器测试选项页面
    Column{
        id: source_speaker_rect
        visible: pageindex == 1 && pageflag == 1 ? true : false  // 仅在源-扬声器测试页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing: 100
        width: root.width

        RowLayout {
            width: parent.width

            // 扬声器分配按钮
            Rectangle{
                id: speaker_allocation
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("SPEAKER ALLOCATION")  // 扬声器分配
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                // 点击处理 - 切换到扬声器分配模式
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        speaker_allocation.flag = true
                    }
                    onReleased: {
                        speaker_allocation.flag = false
                        source_speaker_flag = 1  // 设置为扬声器分配模式
                    }
                }
            }
            
            // 白噪声测试按钮
            Rectangle{
                id: white_noise
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("WHITE NOISE")  // 白噪声测试
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                // 点击处理 - 切换到白噪声测试模式
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        white_noise.flag = true
                    }
                    onReleased: {
                        white_noise.flag = false
                        source_speaker_flag = 2  // 设置为白噪声测试模式
                    }
                }
            }
            
            // 扫频音频测试按钮
            Rectangle{
                id: sweep_audio
                width: btnWidth
                height: btnHeight
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                property bool flag: false
                
                Text {
                    text: qsTr("SWEEP AUDIO")  // 扫频音频测试
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: 25
                    color: "white"
                }

                // 点击处理 - 切换到扫频音频测试模式
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        sweep_audio.flag = true
                    }
                    onReleased: {
                        sweep_audio.flag = false
                        source_speaker_flag = 3  // 设置为扫频音频测试模式
                    }
                }
            }
        }
    }
    
    // 扬声器控制按钮尺寸
    property int btnW: 120  // 扬声器按钮宽度
    property int btnH: 80   // 扬声器按钮高度
    
    // 源-扬声器测试交互界面 - 显示7.1声道扬声器布局和控制按钮
    Column{
        visible: pageindex == 1 && pageflag == 1 && source_speaker_flag != 1 ? true : false  // 仅在白噪声或扫频测试模式下显示
        anchors.top: source_speaker_rect.bottom
        anchors.topMargin: 70
        spacing: 100
        width: root.width

        RowLayout {
            width: parent.width
            Rectangle{
                width: 700
                height: 540
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: "transparent"
                
                // 背景图片 - 房间布局示意图
                Image {
                    id: img
                    width: parent.width
                    height: parent.height
                    source: "icons/bg.png"  // 房间布局背景图
                }
                
                // 左前声道按钮(Front Left)
                Rectangle{
                    id: fl_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.left: img.left
                    anchors.leftMargin: -fl_rect.width/2
                    anchors.top: img.top
                    anchors.topMargin: -fl_rect.height/2

                    property bool flag: false
                    
                    Text {
                        id: fl_title
                        text: qsTr("FL")  // 左前(Front Left)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH0)")  // 通道0
                        anchors.top: fl_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            fl_rect.flag = !fl_rect.flag  // 切换选中状态
                        }
                    }
                }
                
                // 中置声道按钮(Front Center)
                Rectangle{
                    id: fc_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.left: img.left
                    anchors.leftMargin: -fc_rect.width/2+350
                    anchors.top: img.top
                    anchors.topMargin: -fc_rect.height/2

                    property bool flag: false
                    
                    Text {
                        id: fc_title
                        text: qsTr("FC")  // 中置(Front Center)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH3)")  // 通道3
                        anchors.top: fc_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            fc_rect.flag = !fc_rect.flag  // 切换选中状态
                        }
                    }
                }
                
                // 右前声道按钮(Front Right)
                Rectangle{
                    id: fr_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.right: img.right
                    anchors.rightMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2

                    property bool flag: false
                    
                    Text {
                        id: fr_title
                        text: qsTr("FR")  // 右前(Front Right)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH1)")  // 通道1
                        anchors.top: fr_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            fr_rect.flag = !fr_rect.flag  // 切换选中状态
                        }
                    }
                }

                // 左环绕声道按钮(Surround Left)
                Rectangle{
                    id: sl_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.left: img.left
                    anchors.leftMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+270

                    property bool flag: false
                    
                    Text {
                        id: sl_title
                        text: qsTr("SL")  // 左环绕(Surround Left)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH4)")  // 通道4
                        anchors.top: sl_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            sl_rect.flag = !sl_rect.flag  // 切换选中状态
                        }
                    }
                }
                
                // 右环绕声道按钮(Surround Right)
                Rectangle{
                    id: sr_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.right: img.right
                    anchors.rightMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+270

                    property bool flag: false
                    
                    Text {
                        id: sr_title
                        text: qsTr("SR")  // 右环绕(Surround Right)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH5)")  // 通道5
                        anchors.top: sr_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            sr_rect.flag = !sr_rect.flag  // 切换选中状态
                        }
                    }
                }

                // 左后声道按钮(Back Left)
                Rectangle{
                    id: bl_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.left: img.left
                    anchors.leftMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+540

                    property bool flag: false
                    
                    Text {
                        id: bl_title
                        text: qsTr("BL")  // 左后(Back Left)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH6)")  // 通道6
                        anchors.top: bl_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            bl_rect.flag = !bl_rect.flag  // 切换选中状态
                        }
                    }
                }
                
                // 右后声道按钮(Back Right)
                Rectangle{
                    id: br_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.right: img.right
                    anchors.rightMargin: -btnW/2
                    anchors.top: img.top
                    anchors.topMargin: -btnH/2+540

                    property bool flag: false
                    
                    Text {
                        id: br_title
                        text: qsTr("BR")  // 右后(Back Right)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH7)")  // 通道7
                        anchors.top: br_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            br_rect.flag = !br_rect.flag  // 切换选中状态
                        }
                    }
                }

                // 低频效果声道按钮(Low-Frequency Effects)
                Rectangle{
                    id: lfe_rect
                    width: btnW
                    height: btnH
                    color: "black"
                    border.width: 4
                    border.color: flag ? 'orange' : 'black'  // 选中时边框变为橙色
                    anchors.left: br_rect.right
                    anchors.leftMargin: 100
                    anchors.top: br_rect.top

                    property bool flag: false
                    
                    Text {
                        id: lfe_title
                        text: qsTr("LFE")  // 低频效果声道(LFE)
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 25
                        color: "white"
                    }
                    Text {
                        text: qsTr("(CH2)")  // 通道2
                        anchors.top: lfe_title.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: myriadPro.name
                        font.pixelSize: 20
                        color: "white"
                    }

                    // 点击处理 - 切换该声道测试状态
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            lfe_rect.flag = !lfe_rect.flag  // 切换选中状态
                        }
                    }
                }
            }
        }
    }
}