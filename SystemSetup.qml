// 导入必要的Qt模块
import QtQuick 2.0                  // 提供QML基本元素和类型
import QtQuick.Controls 2.5         // 提供UI控件如按钮、文本输入等
import QtQuick.Layouts 1.12         // 提供布局管理功能

// 系统设置主界面根容器
Rectangle {
    id: root
    anchors.fill: parent            // 填充父容器
    signal confirmsignal(string str, int num)  // 定义信号用于向C++后端发送命令

    // 通过别名导出内部组件，使其可从外部访问
    property alias host_ip: host_ip             // 主机IP输入框
    property alias router_ip: router_ip         // 路由器IP输入框
    property alias ip_mask: ip_mask             // IP掩码输入框
    property alias mac_address: mac_address     // MAC地址显示框
    property alias tcp_port: tcp_port           // TCP端口显示框

    // 固件版本信息显示字段
    property alias main_mcu: main_mcu           // 主MCU版本
    property alias tx_mcu: tx_mcu               // 发送MCU版本
    property alias key_mcu: key_mcu             // 按键MCU版本
    property alias lan_mcu: lan_mcu             // 网络MCU版本
    property alias av_mcu: av_mcu               // 音视频MCU版本
    property alias main_fpga: main_fpga         // 主FPGA版本
    property alias aux_fpga: aux_fpga           // 辅助FPGA版本
    property alias aux2_fpga: aux2_fpga         // 辅助2 FPGA版本
    property alias dsp_module: dsp_module       // DSP模块版本

    // 芯片温度信息显示字段
    property alias chip_main_mcu: chip_main_mcu       // 主MCU温度
    property alias chip_main_fgpa: chip_main_fgpa     // 主FPGA温度
    property alias chip_aux_fpga: chip_aux_fpga       // 辅助FPGA温度

    // 页面状态控制属性
    property int pageindex: 0       // 子页面索引
    property int pageflag: 0        // 页面标志，用于指示当前所在主页面
    property int btnWidth: 300      // 按钮标准宽度
    property int btnHeight: 120     // 按钮标准高度
    property int btnfontsize: 35    // 按钮文字大小

    // 返回按钮，在子页面时显示
    CustomButton{
        id: back
        visible: pageflag == 0 ? false : true  // 仅在子页面显示
        width: 150
        height: 80
        border.color: "black"
        border.width: 2
        color: flag ? 'gray' : 'black'  // 按下状态改变颜色
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        property bool flag: false    // 按下状态标志
        
        Text {
            text: qsTr("Back")
            anchors.centerIn: parent
            font.family: myriadPro.name
            font.pixelSize: btnfontsize
            color: "white"
        }
        
        // 点击处理：返回上级菜单
        MouseArea{
            anchors.fill: parent
            onPressed: {
                back.flag = true     // 按下状态
            }
            onReleased: {
                back.flag = false    // 释放状态
                // 根据当前页面层级返回
                if(pageindex == 1){  // 从一级子页面返回主菜单
                    pageflag = 0
                    pageindex = 0
                }else if(pageindex == 2){ // 从二级子页面返回一级子页面
                    pageindex = 1
                }
            }
        }
    }

    // 主菜单页面 - 显示主要功能选项
    GridLayout{
        visible: pageflag == 0 ? true : false  // 仅在主菜单时显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3                   // 每行显示3个按钮
        
        // 主菜单数据模型 - 定义所有可用功能
        ListModel {
            id: edid_model
            ListElement { first: "IP MANAGEMENT"; number: 1 }          // IP管理
            ListElement { first: "ARC/eARC OUT SETUP"; number: 2 }     // ARC/eARC输出设置
            ListElement { first: "VITALS"; number: 3 }                 // 设备状态信息
            ListElement { first: "FAN CONTROL"; number: 4 }            // 风扇控制
            ListElement { first: "RESET & REBOOT"; number: 5 }         // 重置和重启
            ListElement { first: "Tools"; number: 6 }                  // 工具
            ListElement { first: "POWER OUT "; number: 7 }             // 电源输出控制
        }
        
        // 创建主菜单按钮 - 根据模型数据生成
        Repeater{
            model: edid_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: pageflag == number ? "orange" : "black"  // 当前选中项高亮
                border.width: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: 'black'
                
                Column{
                    anchors.centerIn: parent
                    Text {
                        text: first   // 从模型中获取显示文本
                        font.family: myriadPro.name
                        font.pixelSize: btnfontsize
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // 点击处理：切换到对应功能页面
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pageflag = number  // 设置页面标志
                        pageindex = 1      // 进入一级子页面
                        
                        // VITALS页面特殊处理：请求所有组件状态
                        if(pageflag == 3){
                            // 向后端发送请求各组件状态的信号
                            confirmsignal("vitals", 0x00); // KEY MCU
                            confirmsignal("vitals", 0x01); // MAIN MCU
                            confirmsignal("vitals", 0x02); // TX MCU
                            confirmsignal("vitals", 0x10); // MAIN FPGA
                            confirmsignal("vitals", 0x11); // AUX FPGA
                            confirmsignal("vitals", 0x12); // AUX2 FPGA
                            confirmsignal("vitals", 0x20); // LAN MCU
                            confirmsignal("vitals", 0x21); // AV MCU
                            confirmsignal("vitals", 0x22); // DSP Module
                            confirmsignal("vitals", 0x30); // Power Management
                            confirmsignal("vitals", 0xff); // all component
                        }
                        // 风扇控制页面初始化（已注释）
                        //else if(pageflag == 4){
                        //    confirmsignal("FanControl", 0x00);
                        //}
                    }
                }
            }
        }
    }

    // IP 管理页面属性
    property bool ip_management_dhcp_flag: false  // DHCP启用状态标志
    
    // IP管理页面布局
    RowLayout {
        visible: pageflag == 1 && pageindex == 1 ? true : false  // 仅在IP管理页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        
        // IP设置面板容器
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 600
            width: 800
            
            Column{
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 50
                spacing: 20
                
                // 主机IP设置行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "HOST IP:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius: 5
                        color: "white"
                        TextField {
                            id: host_ip
                            width: 250
                            height: 50
                            text: qsTr("192.168.1.199")  // 默认IP
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "transparent"
                                border.width: 0
                            }
                            // 点击时显示虚拟键盘
                            onPressed: {
                                currentInputField = host_ip;
                                virtualKeyboard.visible = true
                            }
                        }
                    }
                }
                
                // 路由器IP设置行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "ROUTER IP:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius: 5
                        color: "white"
                        TextField {
                            id: router_ip
                            width: 250
                            height: 50
                            text: qsTr("192.168.1.254")  // 默认网关IP
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "transparent"
                                border.width: 0
                            }
                            // 点击时显示虚拟键盘
                            onPressed: {
                                currentInputField = router_ip;
                                virtualKeyboard.visible = true
                            }
                        }
                    }
                }
                
                // IP掩码设置行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "IP MASK:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius: 5
                        color: "white"
                        TextField {
                            id: ip_mask
                            width: 250
                            height: 50
                            text: qsTr("255.255.255")  // 默认子网掩码
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            horizontalAlignment: TextInput.AlignHCenter
                            background: Rectangle {
                                color: "transparent"
                                border.width: 0
                            }
                            // 点击时显示虚拟键盘
                            onPressed: {
                                currentInputField = ip_mask;
                                virtualKeyboard.visible = true
                            }
                        }
                    }
                }
                
                // MAC地址显示行（只读）
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: false
                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "MAC ADDRESS:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius: 5
                        color: "white"
                        TextField{
                            id: mac_address
                            width: 250
                            height: 50
                            text: "0"  // 默认为0，实际值由后端填充
                            font.pixelSize: btnfontsize
                            font.family: myriadPro.name
                            horizontalAlignment: TextInput.AlignHCenter
                            color: "black"
                            enabled: false  // 禁用编辑
                        }
                    }
                }
                
                // TCP端口显示行（只读）
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 160
                        height: 40
                        color: "transparent"

                        Text {
                            text: "TCP PORT:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 250
                        height: 50
                        radius: 5
                        color: "white"
                        TextField{
                            id: tcp_port
                            width: 250
                            height: 50
                            text: "0"  // 默认为0，实际值由后端填充
                            font.pixelSize: btnfontsize
                            font.family: myriadPro.name
                            horizontalAlignment: TextInput.AlignHCenter
                            color: "black"
                            enabled: false  // 禁用编辑
                        }
                    }
                }

                // 间距占位
                Rectangle{
                    height: 20
                    width: 100
                    color: "transparent"
                }

                // DHCP设置切换按钮组
                RowLayout {
                    width: parent.width
                    
                    // DHCP开启按钮
                    CustomButton{
                        id: dhcp_on
                        width: 200
                        height: 60
                        border.color: !ip_management_dhcp_flag ? "black" : "orange"  // 选中状态高亮
                        border.width: 4
                        color: !ip_management_dhcp_flag ? 'gray' : 'black'  // 根据状态更改颜色
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Text {
                            text: qsTr("DHCP")
                            anchors.centerIn: parent
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                ip_management_dhcp_flag = true  // 设置为DHCP模式
                                confirmsignal("DHCP", true)     // 发送信号到后端
                            }
                        }
                    }
                    
                    // 静态IP按钮
                    CustomButton{
                        width: 200
                        height: 60
                        border.color: ip_management_dhcp_flag ? "black" : "orange"  // 选中状态高亮
                        border.width: 4
                        color: ip_management_dhcp_flag ? 'gray' : 'black'  // 根据状态更改颜色
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Text {
                            text: qsTr("Static")
                            anchors.centerIn: parent
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "white"
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                ip_management_dhcp_flag = false  // 设置为静态IP模式
                                confirmsignal("DHCP", false)     // 发送信号到后端
                            }
                        }
                    }
                }
            }
        }
    }

    // ARC/eARC输出设置页面属性
    property int out_setup_flag: 0  // 当前选择的输出模式
    
    // ARC/eARC输出设置页面布局
    GridLayout{
        visible: pageflag == 2 && pageindex == 1 ? true : false  // 仅在ARC/eARC设置页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3  // 每行3个按钮
        
        // ARC/eARC选项数据模型
        ListModel {
            id: out_setup_model
            ListElement { first: "DISABLE ARC/eARC"; number: 0x00 }  // 禁用ARC/eARC
            ListElement { first: "ENABLE eARC"; number: 0x01 }       // 启用eARC
            ListElement { first: "ENABLE ARC"; number: 0x02 }        // 启用ARC
        }
        
        // 创建ARC/eARC选项按钮
        Repeater{
            model: out_setup_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: out_setup_flag == number ? "orange" : "black"  // 当前选中项高亮
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
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        out_setup_flag = number  // 更新当前选中状态
                        confirmsignal("ARC/eARC_OUT", number)  // 发送信号到后端
                    }
                }
            }
        }
    }

    // 设备状态信息页面布局
    RowLayout {
        visible: pageflag == 3 && pageindex == 1 ? true : false  // 仅在设备状态页面显示
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        
        // 设备状态信息面板容器
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 750
            width: 700
            
            Column{
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing: 10
                
                // 固件版本标题
                Text {
                    text: "FIRMWARE VERSION"
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                // 主MCU版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: main_mcu
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // TX MCU版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "TX MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: tx_mcu
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 按键MCU版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Key MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: key_mcu
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 网络MCU版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "LAN MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: lan_mcu
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 音视频MCU版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "AV MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: av_mcu
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 主FPGA版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main FPGA:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: main_fpga
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 辅助FPGA版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "AUX FPGA:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: aux_fpga
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 辅助2 FPGA版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "AUX2 FPGA:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: aux2_fpga
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // DSP模块版本行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "DSP Module:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: dsp_module
                            text: qsTr("")  // 由后端填充实际版本号
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }

                // 主芯片温度标题
                Text {
                    text: "MAIN CHIP TEMPERATURE"
                    font.family: myriadPro.name
                    font.pixelSize: 35
                    color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                // 主MCU温度行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main MCU:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: chip_main_mcu
                            text: qsTr("")  // 由后端填充实际温度
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 主FPGA温度行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "Main FPGA:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: chip_main_fgpa
                            text: qsTr("")  // 由后端填充实际温度
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
                
                // 辅助FPGA温度行
                RowLayout{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: 150
                        height: 40
                        color: "transparent"

                        Text {
                            text: "AUX FPGA:"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                    Rectangle{
                        width: 200
                        height: 40
                        radius: 5
                        color: "white"
                        Text {
                            id: chip_aux_fpga
                            text: qsTr("")  // 由后端填充实际温度
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }


    // 风扇控制页面属性
    property int fan_control_flag: 0  // 当前选择的风扇模式
    
    // 风扇控制页面布局
    GridLayout{
        visible: pageflag == 4 && pageindex == 1 ? true : false  // 仅在风扇控制页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        rowSpacing: 50
        columns: 3  // 每行3个按钮
        
        // 风扇模式数据模型
        ListModel {
            id: fan_control_model
            ListElement { first: "OFF"; number: 0x00 }               // 关闭风扇
            ListElement { first: "LOW SPEED"; number: 0x01 }         // 低速运行
            ListElement { first: "MIDDLE SPEED"; number: 0x02 }      // 中速运行
            ListElement { first: "HIGH SPEED"; number: 0x03 }        // 高速运行
            ListElement { first: "AUTO"; number: 0x04 }              // 自动调节
        }
        
        // 创建风扇控制模式按钮
        Repeater{
            model: fan_control_model
            CustomButton{
                width: btnWidth
                height: btnHeight
                border.color: fan_control_flag == number ? "orange" : "black"  // 当前选中项高亮
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
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        fan_control_flag = number  // 更新当前选中状态
                        confirmsignal("FanControl", number)  // 发送信号到后端控制风扇
                    }
                }
            }
        }
    }

    // 重置和重启页面布局
    RowLayout {
        visible: pageflag == 5 && pageindex == 1 ? true : false  // 仅在重置/重启页面显示
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        
        // 恢复默认设置按钮
        CustomButton{
            id: reset_btn
            width: btnWidth
            height: btnHeight
            border.color: "black"
            border.width: 2
            color: flag ? 'gray' : 'black'  // 按下状态改变颜色
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag: false  // 按下状态标志
            Text {
                text: qsTr("Reset Default")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    reset_btn.flag = true  // 设置按下状态
                }
                onReleased: {
                    reset_btn.flag = false  // 恢复正常状态
                    confirmsignal("ResetDefault", true)  // 发送重置信号到后端
                }
            }
        }

        // 重启设备按钮
        CustomButton{
            id: reboot_btn
            width: btnWidth
            height: btnHeight
            border.color: "black"
            border.width: 2
            color: flag ? 'gray' : 'black'  // 按下状态改变颜色
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag: false  // 按下状态标志
            Text {
                text: qsTr("Reboot")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    reboot_btn.flag = true  // 设置按下状态
                }
                onReleased: {
                    reboot_btn.flag = false  // 恢复正常状态
                    confirmsignal("Reboot", true)  // 发送重启信号到后端
                }
            }
        }
    }

    // 工具页面属性
    property int tool_flag: 0  // 当前选择的工具
    
    // 工具选择页面布局
    RowLayout {
        visible: pageflag == 6 && pageindex == 1 ? true : false  // 仅在工具选择页面显示
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        
        // 音频信息帧工具按钮
        CustomButton{
            id: audio_info
            width: btnWidth
            height: btnHeight
            border.color: "black"
            border.width: 2
            color: flag ? 'gray' : 'black'  // 按下状态改变颜色
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag: false  // 按下状态标志
            Text {
                text: qsTr("Audio Infoframe")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    audio_info.flag = true  // 设置按下状态
                }
                onReleased: {
                    audio_info.flag = false  // 恢复正常状态
                    pageindex = 2  // 进入二级子页面
                    tool_flag = 1  // 设置工具标志为音频信息帧
                }
            }
        }
        
        // 链路训练工具按钮
        CustomButton{
            id: link_train
            width: btnWidth
            height: btnHeight
            border.color: "black"
            border.width: 2
            color: flag ? 'gray' : 'black'  // 按下状态改变颜色
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag: false  // 按下状态标志
            Text {
                text: qsTr("Link Train")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    link_train.flag = true  // 设置按下状态
                }
                onReleased: {
                    link_train.flag = false  // 恢复正常状态
                    pageindex = 2  // 进入二级子页面
                    tool_flag = 2  // 设置工具标志为链路训练
                }
            }
        }
    }

    // 音频信息帧写入处理函数
    function writeinfoframe(){
        var data = ["84", "01", "0A"];  // 初始化数据数组，包含帧头信息
        
        // 第1个数据字节处理
        var byte1 =
                this.combobox1.currentText.substring(0, 4) + "0" + this.combobox2.currentText.substring(0, 3);
        if (parseInt(byte1, 2).toString(16).length === 1) {
            byte1 = "0" + parseInt(byte1, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
        } else {
            byte1 = parseInt(byte1, 2).toString(16).toUpperCase();
        }
        data.push(byte1);  // 添加到数据数组
        
        // 第2个数据字节处理
        var byte2 =
                "000" + this.combobox3.currentText.substring(0, 3) + this.combobox4.currentText.substring(0, 2);
        if (parseInt(byte2, 2).toString(16).length === 1) {
            byte2 = "0" + parseInt(byte2, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
        } else {
            byte2 = parseInt(byte2, 2).toString(16).toUpperCase();
        }
        data.push(byte2);  // 添加到数据数组
        
        // 第3个数据字节处理
        var byte3 = this.combobox5.currentText.substring(2, 4);
        data.push(byte3);  // 添加到数据数组
        
        // 第4个数据字节处理
        var byte4 = this.combobox6.currentText.substring(2, 4);
        data.push(byte4);  // 添加到数据数组
        
        // 第5个数据字节处理
        var byte5 =
                this.combobox7.currentText.substring(0, 1) +
                this.combobox8.currentText.substring(0, 4) +
                "0" +
                this.combobox9.currentText.substring(0, 2);
        if (parseInt(byte5, 2).toString(16).length === 1) {
            byte5 = "0" + parseInt(byte5, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
        } else {
            byte5 = parseInt(byte5, 2).toString(16).toUpperCase();
        }
        data.push(byte5);  // 添加到数据数组
        
        // 根据不同的音频格式处理后续字节
        if (this.combobox6.currentText === "0xFE") {
            // 特殊格式0xFE下的第6个字节处理
            var byte6 =
                    this.combobox6_1.currentText +
                    this.combobox6_2.currentText +
                    this.combobox6_3.currentText +
                    this.combobox6_4.currentText +
                    this.combobox6_5.currentText +
                    this.combobox6_6.currentText +
                    this.combobox6_7.currentText +
                    this.combobox6_8.currentText;
            if (parseInt(byte6, 2).toString(16).length === 1) {
                byte6 = "0" + parseInt(byte6, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
            } else {
                byte6 = parseInt(byte6, 2).toString(16).toUpperCase();
            }
            data.push(byte6);
            
            // 特殊格式0xFE下的第7个字节处理
            var byte7 =
                    this.combobox7_1.currentText +
                    this.combobox7_2.currentText +
                    this.combobox7_3.currentText +
                    this.combobox7_4.currentText +
                    this.combobox7_5.currentText +
                    this.combobox7_6.currentText +
                    this.combobox7_7.currentText +
                    this.combobox7_8.currentText;
            if (parseInt(byte7, 2).toString(16).length === 1) {
                byte7 = "0" + parseInt(byte7, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
            } else {
                byte7 = parseInt(byte7, 2).toString(16).toUpperCase();
            }
            data.push(byte7);
            
            // 特殊格式0xFE下的第8个字节处理
            var byte8 =
                    "0000" +
                    this.combobox8_5.currentText +
                    this.combobox8_6.currentText +
                    this.combobox8_7.currentText +
                    this.combobox8_8.currentText;
            if (parseInt(byte8, 2).toString(16).length === 1) {
                byte8 = "0" + parseInt(byte8, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
            } else {
                byte8 = parseInt(byte8, 2).toString(16).toUpperCase();
            }
            data.push(byte8);
            data.push("00");  // 第9个字节置0
            data.push("00");  // 第10个字节置0
        } else if (this.combobox6.currentText === "0xFF") {
            // 特殊格式0xFF下的第6个字节处理
            byte6 =
                    this.combobox6_1.currentText +
                    this.combobox6_2.currentText +
                    this.combobox6_3.currentText +
                    this.combobox6_4.currentText +
                    this.combobox6_5.currentText +
                    this.combobox6_6.currentText +
                    this.combobox6_7.currentText +
                    this.combobox6_8.currentText;
            if (parseInt(byte6, 2).toString(16).length === 1) {
                byte6 = "0" + parseInt(byte6, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
            } else {
                byte6 = parseInt(byte6, 2).toString(16).toUpperCase();
            }
            data.push(byte6);
            
            // 特殊格式0xFF下的第7个字节处理
            byte7 =
                    this.combobox7_1.currentText +
                    this.combobox7_2.currentText +
                    this.combobox7_3.currentText +
                    this.combobox7_4.currentText +
                    this.combobox7_5.currentText +
                    this.combobox7_6.currentText +
                    this.combobox7_7.currentText +
                    this.combobox7_8.currentText;
            if (parseInt(byte7, 2).toString(16).length === 1) {
                byte7 = "0" + parseInt(byte7, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
            } else {
                byte7 = parseInt(byte7, 2).toString(16).toUpperCase();
            }
            data.push(byte7);
            
            // 特殊格式0xFF下的第8个字节处理
            byte8 =
                    this.combobox8_1.currentText +
                    this.combobox8_1.currentText +
                    this.combobox8_1.currentText +
                    this.combobox8_1.currentText +
                    this.combobox8_1.currentText +
                    this.combobox8_1.currentText +
                    this.combobox8_1.currentText +
                    this.combobox8_1.currentText;
            if (parseInt(byte8, 2).toString(16).length === 1) {
                byte8 = "0" + parseInt(byte8, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
            } else {
                byte8 = parseInt(byte8, 2).toString(16).toUpperCase();
            }
            data.push(byte8);
            
            // 特殊格式0xFF下的第9个字节处理
            var byte9 =
                    this.combobox9_1.currentText +
                    this.combobox9_2.currentText +
                    this.combobox9_3.currentText +
                    this.combobox9_4.currentText +
                    this.combobox9_5.currentText +
                    this.combobox9_6.currentText +
                    this.combobox9_7.currentText +
                    this.combobox9_8.currentText;
            if (parseInt(byte9, 2).toString(16).length === 1) {
                byte9 = "0" + parseInt(byte9, 2).toString(16).toUpperCase();  // 补0确保两位十六进制
            } else {
                byte9 = parseInt(byte9, 2).toString(16).toUpperCase();
            }
            data.push(byte9);
            data.push("00");  // 第10个字节置0
        } else {
            // 普通格式下后续字节全部置0
            for (var a = 0; a < 5; a++) {
                data.push("00");
            }
        }
        console.log("data=", data);  // 调试输出
        confirmsignal("AudioInfoframeWrite", data);  // 发送数据到后端
    }

    // 音频信息帧工具页面布局
    RowLayout {
        visible: pageflag == 6 && pageindex == 2 && tool_flag == 1 ? true : false  // 仅在音频信息帧工具页面显示
        anchors.top: parent.top
        anchors.topMargin: 110
        width: parent.width
        
        // 音频信息帧面板容器
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 900
            width: 1600

            // 读取按钮
            CustomButton{
                id: audio_info_read
                width: 200
                height: 80
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'  // 按下状态改变颜色
                property bool flag: false  // 按下状态标志
                Text {
                    text: qsTr("Read")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        audio_info_read.flag = true  // 设置按下状态
                        confirmsignal("AudioInfoframeRead", 0xfe01);  // 发送读取信号到后端
                    }
                    onReleased: {
                        audio_info_read.flag = false  // 恢复正常状态
                    }
                }
            }
            
            // 写入按钮
            CustomButton{
                id: audio_info_write
                anchors.top: audio_info_read.top
                anchors.left: audio_info_read.right
                anchors.leftMargin: 10
                width: 200
                height: 80
                border.color: "black"
                border.width: 2
                color: flag ? 'gray' : 'black'  // 按下状态改变颜色
                property bool flag: false  // 按下状态标志
                Text {
                    text: qsTr("Write")
                    anchors.centerIn: parent
                    font.family: myriadPro.name
                    font.pixelSize: btnfontsize
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        audio_info_write.flag = true  // 设置按下状态
                        // 调用写入信息帧函数
                        writeinfoframe();
                    }
                    onReleased: {
                        audio_info_write.flag = false  // 恢复正常状态
                    }
                }
            }

            // 数据字节1标签和控件
            Text {
                id: label1
                text: qsTr("Data Byte 1:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label2.top
                anchors.bottomMargin: 30
            }
            
            // 音频编码类型
            Text {
                id: ct
                text: qsTr("CT:")  // 编码类型标签
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: label1.right
                anchors.leftMargin: 10
                anchors.verticalCenter: label1.verticalCenter
            }
            
            // 音频编码类型下拉框
            ComboBox{
                id: combobox1
                width: 900
                height: 60
                anchors.left: ct.right
                anchors.leftMargin: 10
                anchors.verticalCenter: label1.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0000(Refer to Stream Header)",
                    "0001(L-PCM)",
                    "0010(AC-3)",
                    "0011(MPEG-1)",
                    "0100(MP3)",
                    "0101(MPEG2)",
                    "0110(AAC LC)",
                    "0111(DTS)",
                    "1000(ATRAC)",
                    "1001(One Bit Audio)",
                    "1010(Enhanced Ac-3)",
                    "1011(DTS-HD)",
                    "1100(MAT)",
                    "1101(DST)",
                    "1110(WMA Pro)",
                    "1111(Reter to Audio Coding Exension Type(CXT) field in Data Byte 3)"
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox1.highlightedIndex == index ? "#5e5e5e" : "black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            
            // 声道数
            Text {
                id: f13
                text: qsTr("F13=0       CC:")  // 声道数标签
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox1.right
                anchors.leftMargin: 10
                anchors.verticalCenter: combobox1.verticalCenter
            }
            
            // 声道数下拉框
            ComboBox{
                id: combobox2
                width: 358
                height: 60
                anchors.left: f13.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f13.verticalCenter
                font.family: myriadPro.name
                model: [
                    "000(Refer to Stream Header)",
                    "001(2 channels)",
                    "010(3 channels)",
                    "011(4 channels)",
                    "100(5 channels)",
                    "101(6 channels)",
                    "110(7 channels)",
                    "111(8 channels)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox2.highlightedIndex == index ? "#5e5e5e" : "black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 2
            Text {
                id:label2
                text: qsTr("Data Byte 2:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label3.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f27
                text: qsTr("F27=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label2.verticalCenter
            }
            Text {
                id:f26
                text: qsTr("F26=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label2.verticalCenter
            }
            Text {
                id:f25
                text: qsTr("F25=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label2.verticalCenter
            }
            Text {
                id:sf
                text: qsTr("SF:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label2.verticalCenter
            }
            ComboBox{
                id:combobox3
                width: 370
                height: 60
                anchors.left: sf.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f25.verticalCenter
                font.family: myriadPro.name
                model: [
                    "000(Refer to Stream Header)",
                    "001(32 kHz)",
                    "010(44.1 kHz (CD))",
                    "011(48kHz)",
                    "100(88.2 kHz)",
                    "101(96 kHz)",
                    "110(176.4 kHz)",
                    "111(192 kHz)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:ss
                text: qsTr("SS:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox3.right
                anchors.leftMargin: 20
                anchors.verticalCenter: combobox3.verticalCenter
            }
            ComboBox{
                id:combobox4
                width: 367
                height: 60
                anchors.left: ss.right
                anchors.leftMargin: 10
                anchors.verticalCenter: ss.verticalCenter
                font.family: myriadPro.name
                model: [
                    "00(Refer to Stream Header)",
                    "01(16 bit)",
                    "10(20 bit)",
                    "11(24 bit)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }


            //data byte 3
            Text {
                id:label3
                text: qsTr("Data Byte 3:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label4.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f37
                text: qsTr("F37=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label3.verticalCenter
            }
            Text {
                id:f36
                text: qsTr("F36=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label3.verticalCenter
            }
            Text {
                id:f35
                text: qsTr("F35=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label3.verticalCenter
            }
            Text {
                id:cxt
                text: qsTr("CXT:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label3.verticalCenter
            }
            ComboBox{
                id:combobox5
                width: 784
                height: 60
                anchors.left: cxt.right
                anchors.leftMargin: 10
                anchors.verticalCenter: cxt.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0x00(Refer to Audio Coding Type (CT) field in Data Byte 1)",
                    "0x01(Not in use)",
                    "0x02(Not in use)",
                    "0x03(Not in use)",
                    "0x04(MPEG-4 HE AAC)",
                    "0x05(MPEG-4 HE AAC V2)",
                    "0x06(MPEG-4 AAC LC)",
                    "0x07(DRA)",
                    "0x08(MPEG-4 HE AAC + MPEG Surround)",
                    "0x09(Reserved)",
                    "0x0A(MPEG-4 AAC LC + MPEG Surround)",
                    "0x0B(MPEG-H 3D Audio)",
                    "0x0C(AC-4)",
                    "0x0D(L-PCM 3D Audio)",
                    "0x0E(Reserved)",
                    "0x0F(Reserved)",
                    "0x10(Reserved)",
                    "0x11(Reserved)",
                    "0x12(Reserved)",
                    "0x13(Reserved)",
                    "0x14(Reserved)",
                    "0x15(Reserved)",
                    "0x16(Reserved)",
                    "0x17(Reserved)",
                    "0x18(Reserved)",
                    "0x19(Reserved)",
                    "0x1A(Reserved)",
                    "0x1B(Reserved)",
                    "0x1C(Reserved)",
                    "0x1D(Reserved)",
                    "0x1E(Reserved)",
                    "0x1F(Reserved)",

                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            //data byte 4
            Text {
                id:label4
                text: qsTr("Data Byte 4:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label5.top
                anchors.bottomMargin: 40
            }
            Text {
                id:ca
                text: qsTr("CA:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label4.verticalCenter
            }
            ComboBox{
                id:combobox6
                width: 1375
                height: 60
                anchors.left: ca.right
                anchors.leftMargin: 10
                anchors.verticalCenter: ca.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0x00(- - ---- FR FL)",
                    "0x01(- - --- LFE1 FR FL)",
                    "0x02(- - -- FC- FR FL)",
                    "0x03(- - -- FC LFE1 FR FL)",
                    "0x04(- - - BC-- FR FL)",
                    "0x05(- - - BC- LFE1 FR FL)",
                    "0x06(- - - BC FC- FR FL)",
                    "0x07(- - - BC FC LFE1 FR FL)",
                    "0x08(- - RS LS-- FR FL)",
                    "0x09(- - RS LS- LFE1 FR FL)",
                    "0x0A(- - RS LS FC- FR FL)",
                    "0x0B(- - RS LS FC LFE1 FR FL)",
                    "0x0C(- BC  RS LS-- FR FL)",
                    "0x0D(- BC  RS LS- LFE1 FR FL)",
                    "0x0E(- BC  RS LS FC- FR FL)",
                    "0x0F(- BC  RS LS FC LFE1 FR FL)",
                    "0x10(RRC RLC RS LS-- FR FL)",
                    "0x11(RRC RLC RS LS- LFE1 FR FL)",
                    "0x12(RRC RLC RS LS FC- FR FL)",
                    "0x13(RRC RLC RS LS FC LFE1 FR FL)",
                    "0x14(FRC FLC ---- FR FL)",
                    "0x15(FRC FLC ---LFE1 FR FL)",
                    "0x16(FRC FLC -- FC- FR FL)",
                    "0x17(FRC FLC -- FC LFE1 FR FL)",
                    "0x18(FRC FLC -BC-- FR FL)",
                    "0x19(FRC FLC -BC- LFE1 FR FL)",
                    "0x1A(FRC FLC -BC FC- FR FL)",
                    "0x1B(FRC FLC -BC FC LFE1 FR FL)",
                    "0x1C(FRC FLC RS LS-- FR FL)",
                    "0x1D(FRC FLC RS LS- LFE1 FR FL)",
                    "0x1E(FRC FLC RS LS FC- FR FL)",
                    "0x1F(FRC FLC RS LS FC LFE1 FR FL)",
                    "0x20(- TpFC RS LS FC- FR FL)",
                    "0x21(- TpFC RS LS FC LFE1 FR FL)",
                    "0x22(TpC - RS LS FC- FR FL)",
                    "0x23(TpC - RS LS FC LFE1 FR FL)",
                    "0x24(TpFR TpFL RS LS-- FR FL)",
                    "0x25(TpFR TpFL RS LS- LFE1 FR FL)",
                    "0x26(FRW FLW RS LS-- FR FL)",
                    "0x27(FRW FLW RS LS- LFE1 FR FL)",
                    "0x28(TpC BC RS LS FC- FR FL)",
                    "0x29(TpC BC RS LS FC LFE1 FR FL)",
                    "0x2A(TpFC BC RS LS FC- FR FL)",
                    "0x2B(TpFC BC RS LS FC LFE1 FR FL)",
                    "0x2C(TpC TpFC RS LS FC- FR FL)",
                    "0x2D(TpC TpFC RS LS FC LFE1 FR FL)",
                    "0x2E(TpFR TpFL RS LS FC- FR FL)",
                    "0x2F(TpFR TpFL RS LS FC- LFE1 FR FL)",
                    "0x30(FRW FLW RS LS FC- FR FL)",
                    "0x31(FRW FLW RS LS FC LFE1 FR FL)",
                    "0xFE",
                    "0xFF",

                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
                onActivated: {
                    var savename = "timingDetails" + (combobox6.currentIndex+1);

                }
            }
            //data byte 5
            Text {
                id:label5
                text: qsTr("Data Byte 5:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label6.top
                anchors.bottomMargin: 40
            }
            Text {
                id:dm_inh
                text: qsTr("DM_INH:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label5.verticalCenter
            }
            ComboBox{
                id:combobox7
                width: 420
                height: 60
                anchors.left: dm_inh.right
                anchors.leftMargin: 10
                anchors.verticalCenter: dm_inh.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0(Permitted or no information", "1(Prohibited)"
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:lsv
                text: qsTr("LSV:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox7.right
                anchors.leftMargin: 10
                anchors.verticalCenter: label5.verticalCenter
            }
            ComboBox{
                id:combobox8
                width: 220
                height: 60
                anchors.left: lsv.right
                anchors.leftMargin: 10
                anchors.verticalCenter: lsv.verticalCenter
                font.family: myriadPro.name
                model: [
                    "0000(0dB)",
                    "0001(1dB)",
                    "0010(2dB)",
                    "0011(3dB)",
                    "0100(4dB)",
                    "0101(5dB)",
                    "0110(6dB)",
                    "0111(7dB)",
                    "1000(8dB)",
                    "1001(9dB)",
                    "1010(10dB)",
                    "1011(11dB)",
                    "1100(12dB)",
                    "1101(13dB)",
                    "1110(14dB)",
                    "1111(15dB)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f52
                text: qsTr("F52=0 LEFPBL:")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: combobox8.right
                anchors.leftMargin: 20
                anchors.verticalCenter: label5.verticalCenter
            }
            ComboBox{
                id:combobox9
                width: 450
                height: 60
                anchors.left: f52.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f52.verticalCenter
                font.family: myriadPro.name
                model: [
                    "00(Unknown or refer to other information)",
                    "01(0 dB playback)",
                    "10(+ 10 dB playback)",
                    "11(Reserved)",
                ]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            //data byte 6
            Text {
                id:label6
                text: qsTr("Data Byte 6:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label7.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f67
                text: qsTr((combobox6.currentText === "0xEF") ? "FLW/FRW:" :(combobox6.currentText === "0xFF")?"CID07": "F67=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_1
                width: 70
                height: 60
                anchors.left: f67.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f67.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f66
                text: qsTr((combobox6.currentText === "0xEF") ? "FLC/FRC:" : (combobox6.currentText === "0xFF")?"CID06": "F66=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_2
                width: 70
                height: 60
                anchors.left: f66.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f66.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f65
                text: qsTr((combobox6.currentText === "0xEF") ? "FLC/FRC:" :(combobox6.currentText === "0xFF")?"CID05": "F65=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_3
                width: 70
                height: 60
                anchors.left: f65.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f65.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f64
                text: qsTr((combobox6.currentText === "0xEF") ? "BC:" : (combobox6.currentText === "0xFF")?"CID04":"F64=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_4
                width: 70
                height: 60
                anchors.left: f64.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f64.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f63
                text: qsTr((combobox6.currentText === "0xEF") ? "BL/BR:" : (combobox6.currentText === "0xFF")?"CID03":"F63=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_5
                width: 70
                height: 60
                anchors.left: f63.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f63.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f62
                text: qsTr((combobox6.currentText === "0xEF") ? "FC:" : (combobox6.currentText === "0xFF")?"CID02":"F62=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_6
                width: 70
                height: 60
                anchors.left: f62.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f62.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f61
                text: qsTr((combobox6.currentText === "0xEF") ? "LFE1:" : (combobox6.currentText === "0xFF")?"CID01":"F61=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_7
                width: 70
                height: 60
                anchors.left: f61.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f61.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f60
                text: qsTr((combobox6.currentText === "0xEF") ? "FL/FR:" : (combobox6.currentText === "0xFF")?"CID00":"F60=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label6.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox6_8
                width: 70
                height: 60
                anchors.left: f60.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f60.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox6_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox6_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox6_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox6_8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox6_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 7
            Text {
                id:label7
                text: qsTr("Data Byte 7:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label8.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f77
                text: qsTr((combobox6.currentText === "0xEF") ? "FTpSiL/TpSiR:" : (combobox6.currentText === "0xFF")?"CID15":"F77=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_1
                width: 70
                height: 60
                anchors.left: f77.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f77.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f76
                text: qsTr((combobox6.currentText === "0xEF") ? "SiL/SiR:" : (combobox6.currentText === "0xFF")?"CID14":"F76=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_2
                width: 70
                height: 60
                anchors.left: f76.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f76.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f75
                text: qsTr((combobox6.currentText === "0xEF") ? "TpBC:" : (combobox6.currentText === "0xFF")?"CID13":"F75=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_3
                width: 70
                height: 60
                anchors.left: f75.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f75.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f74
                text: qsTr((combobox6.currentText === "0xEF") ? "LFE2:" :(combobox6.currentText === "0xFF")?"CID12": "F74=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_4
                width: 70
                height: 60
                anchors.left: f74.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f74.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f73
                text: qsTr((combobox6.currentText === "0xEF") ? "LS/RS:" : (combobox6.currentText === "0xFF")?"CID11":"F73=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_5
                width: 70
                height: 60
                anchors.left: f73.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f73.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f72
                text: qsTr((combobox6.currentText === "0xEF") ? "TpFC:" :(combobox6.currentText === "0xFF")?"CID10": "F72=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_6
                width: 70
                height: 60
                anchors.left: f72.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f72.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f71
                text: qsTr((combobox6.currentText === "0xEF") ? "TpC:" : (combobox6.currentText === "0xFF")?"CID09":"F71=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_7
                width: 70
                height: 60
                anchors.left: f71.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f71.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f70
                text: qsTr((combobox6.currentText === "0xEF") ? "TpFL/TpFR:" :(combobox6.currentText === "0xFF")?"CID08": "F70=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label7.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xEF" || combobox6.currentText === "0xFF") ? true : false
                id:combobox7_8
                width: 70
                height: 60
                anchors.left: f70.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f70.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox7_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox7_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox7_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox7_8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox7_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 8
            Text {
                id:label8
                text: qsTr("Data Byte 8:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label9.top
                anchors.bottomMargin: 40
            }


            Text {
                id:f87
                text: qsTr((combobox6.currentText === "0xFF")?"CID23": "F87=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_1
                width: 70
                height: 60
                anchors.left: f87.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f87.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f86
                text: qsTr((combobox6.currentText === "0xFF")?"CID22": "F86=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_2
                width: 70
                height: 60
                anchors.left: f86.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f86.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f85
                text: qsTr((combobox6.currentText === "0xFF")?"CID21": "F85=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_3
                width: 70
                height: 60
                anchors.left: f85.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f85.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f84
                text: qsTr((combobox6.currentText === "0xFF")?"CID20": "F84=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox8_4
                width: 70
                height: 60
                anchors.left: f84.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f84.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_4.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f83
                text: qsTr((combobox6.currentText === "0xEF") ? "TpLS/TpRS:" :(combobox6.currentText === "0xFF")?"CID19": "F83=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_5
                width: 70
                height: 60
                anchors.left: f83.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f83.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f82
                text: qsTr((combobox6.currentText === "0xEF") ? "BtFL/bTFR:" :(combobox6.currentText === "0xFF")?"CID18": "F82=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_6
                width: 70
                height: 60
                anchors.left: f82.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f82.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f81
                text: qsTr((combobox6.currentText === "0xEF") ? "BtFC:" :(combobox6.currentText === "0xFF")?"CID17": "F81=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_7
                width: 70
                height: 60
                anchors.left: f81.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f81.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f80
                text: qsTr((combobox6.currentText === "0xEF") ? "TpBL/TpBR:" :(combobox6.currentText === "0xFF")?"CID16": "F80=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label8.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF" || combobox6.currentText === "0xEF") ? true : false
                id:combobox8_8
                width: 70
                height: 60
                anchors.left: f80.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f80.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox8_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox8_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox8_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox8_8.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox8_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 9
            Text {
                id:label9
                text: qsTr("Data Byte 9:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: label10.top
                anchors.bottomMargin: 40
            }
            Text {
                id:f97
                text: qsTr((combobox6.currentText === "0xFF")?"CID31": "F97=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_1
                width: 70
                height: 60
                anchors.left: f97.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f97.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_1.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_1.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_1.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_1.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f96
                text: qsTr((combobox6.currentText === "0xFF")?"CID30": "F96=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_2
                width: 70
                height: 60
                anchors.left: f96.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f96.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_2.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_2.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_2.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_2.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_2.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f95
                text: qsTr((combobox6.currentText === "0xFF")?"CID29": "F95=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_3
                width: 70
                height: 60
                anchors.left: f95.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f95.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_3.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_3.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_3.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_3.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_3.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f94
                text: qsTr((combobox6.currentText === "0xFF")?"CID28": "F94=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_4
                width: 70
                height: 60
                anchors.left: f94.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f94.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_4.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_4.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_4.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_4.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f93
                text: qsTr((combobox6.currentText === "0xFF")?"CID27": "F93=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_5
                width: 70
                height: 60
                anchors.left: f93.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f93.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_5.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_5.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_5.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_5.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_5.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f92
                text: qsTr((combobox6.currentText === "0xFF")?"CID26": "F92=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_6
                width: 70
                height: 60
                anchors.left: f92.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f92.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_6.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_6.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_6.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_6.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_6.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f91
                text: qsTr((combobox6.currentText === "0xFF")?"CID25": "F91=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_7
                width: 70
                height: 60
                anchors.left: f91.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f91.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_7.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_7.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_7.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_7.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_7.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }
            Text {
                id:f90
                text: qsTr((combobox6.currentText === "0xFF")?"CID24": "F90=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f100.left
                anchors.verticalCenter: label9.verticalCenter
            }
            ComboBox{
                visible: (combobox6.currentText === "0xFF") ? true : false
                id:combobox9_8
                width: 70
                height: 60
                anchors.left: f90.right
                anchors.leftMargin: 10
                anchors.verticalCenter: f90.verticalCenter
                font.family: myriadPro.name
                model: ["0", "1"]
                font.pixelSize: 30

                delegate: ItemDelegate {
                    width: combobox9_8.width
                    contentItem: Text {
                        text: modelData
                        color: combobox9_8.highlightedIndex == index?"#5e5e5e":"black"
                        font.pixelSize: 26
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: myriadPro.name
                    }
                    highlighted: combobox9_8.highlightedIndex == index
                    background: Rectangle {
                        implicitWidth: combobox9_1.width
                        implicitHeight: 50
                        opacity: enabled ? 1 : 0.3
                        color: combobox9_8.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                    }
                }
            }

            //data byte 10
            Text {
                id:label10
                text: qsTr("Data Byte 10:")
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
            }
            Text {
                id:f107
                text: qsTr("F107=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: label10.right
                anchors.leftMargin: 20
                anchors.verticalCenter: label10.verticalCenter
            }
            Text {
                id:f106
                text: qsTr("F106=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f107.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f107.verticalCenter
            }
            Text {
                id:f105
                text: qsTr("F105=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f106.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f106.verticalCenter
            }
            Text {
                id:f104
                text: qsTr("F104=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f105.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f105.verticalCenter
            }
            Text {
                id:f103
                text: qsTr("F103=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f104.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f104.verticalCenter
            }
            Text {
                id:f102
                text: qsTr("F102=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f103.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f103.verticalCenter
            }
            Text {
                id:f101
                text: qsTr("F101=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f102.right
                anchors.leftMargin: 120
                anchors.verticalCenter: f102.verticalCenter
            }
            Text {
                id:f100
                text: qsTr("F100=0")
                font.family: myriadPro.name
                font.pixelSize: 30
                color: "black"
                anchors.left: f101.right
                anchors.leftMargin: 100
                anchors.verticalCenter: f101.verticalCenter
            }
        }
    }

    // 链路训练工具页面属性
    property int link_train_flag: 0  // 当前选择的链路训练模式
    
    // 链路训练工具页面布局
    RowLayout {
        visible: pageflag == 6 && pageindex == 2 && tool_flag == 2 ? true : false  // 仅在链路训练工具页面显示
        anchors.top: parent.top
        anchors.topMargin: 150
        width: parent.width
        
        // 链路训练面板容器
        Rectangle{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            border.width: 1
            border.color: "white"
            radius: 5
            color: "gray"
            height: 750
            width: 1120
            
            RowLayout{
                width: parent.width
                spacing: 50

                // 链路训练模式选择区域
                GridLayout{
                    Layout.topMargin: 30
                    Layout.leftMargin: 50
                    width: parent.width
                    rowSpacing: 20
                    columns: 1
                    
                    // 链路训练模式数据模型
                    ListModel {
                        id: link_train_model
                        ListElement { first: "FRL Off"; number: 0x0000 }                  // 关闭FRL模式
                        ListElement { first: "Force 3 Lanes / 3 Gbps"; number: 0x0101 }   // 强制3车道/3Gbps模式
                        ListElement { first: "Force 3 Lanes / 6 Gbps"; number: 0x0102 }   // 强制3车道/6Gbps模式
                        ListElement { first: "Force 4 Lanes / 6 Gbps"; number: 0x0103 }   // 强制4车道/6Gbps模式
                        ListElement { first: "Force 4 Lanes / 8 Gbps"; number: 0x0104 }   // 强制4车道/8Gbps模式
                        ListElement { first: "Force 4 Lanes / 10 Gbps"; number: 0x0105 }  // 强制4车道/10Gbps模式
                        ListElement { first: "Force 4 Lanes / 12 Gbps"; number: 0x0106 }  // 强制4车道/12Gbps模式
                    }
                    
                    // 创建链路训练模式按钮
                    Repeater{
                        model: link_train_model
                        CustomButton{
                            width: 300
                            height: 80
                            border.color: link_train_flag == number ? "orange" : "black"  // 当前选中项高亮
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

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    link_train_flag = number  // 更新当前选中状态
                                    confirmsignal("LinkTrainForce", number)  // 发送信号到后端
                                }
                            }
                        }
                    }
                }

                // 链路训练控制区域
                RowLayout{
                    width: parent.width
                    spacing: 50
                    
                    // 车道/速率强制训练控制
                    Column{
                        Text {
                            text: "Force Link Train at Lane / Rate"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                        }

                        // 链路训练模式下拉框
                        ComboBox{
                            id: combobox10
                            width: 300
                            height: 60
                            anchors.leftMargin: 10
                            font.family: myriadPro.name
                            model: [
                                "FRL Off",
                                "3Lanes/3Gbps",
                                "3Lanes/6Gbps",
                                "4Lanes/6Gbps",
                                "4Lanes/8Gbps",
                                "4Lanes/10Gbps",
                            ]
                            font.pixelSize: 30

                            delegate: ItemDelegate {
                                width: combobox10.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox10.highlightedIndex == index ? "#5e5e5e" : "black"
                                    font.pixelSize: 26
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: myriadPro.name
                                }
                                highlighted: combobox10.highlightedIndex == index
                                background: Rectangle {
                                    implicitWidth: combobox10.width
                                    implicitHeight: 50
                                    opacity: enabled ? 1 : 0.3
                                    color: combobox10.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                                }
                            }
                            // 选择改变时发送命令
                            onActivated: {
                                // 生成十六进制命令字符串并发送
                                var str = combobox10.currentIndex.toString(16).padStart(2, '0') + combobox11.currentIndex.toString(16).padStart(2, '0');
                                confirmsignal("LinkTrain", parseInt(str, 16))
                            }
                        }
                    }
                    
                    // 训练状态强制控制
                    Column{
                        Text {
                            text: "Force Training Status"
                            font.family: myriadPro.name
                            font.pixelSize: btnfontsize
                            color: "black"
                        }

                        // 训练状态下拉框
                        ComboBox{
                            id: combobox11
                            width: 300
                            height: 60
                            anchors.leftMargin: 10
                            font.family: myriadPro.name
                            model: [
                                "FRL_LT_STOP",      // 停止训练
                                "FRL_LT_PROGRESS",  // 训练进行中
                                "FRL_LT_PASS",      // 训练通过
                                "FRL_LT_TMDS",      // TMDS模式
                            ]
                            font.pixelSize: 30

                            delegate: ItemDelegate {
                                width: combobox11.width
                                contentItem: Text {
                                    text: modelData
                                    color: combobox11.highlightedIndex == index ? "#5e5e5e" : "black"
                                    font.pixelSize: 26
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: myriadPro.name
                                }
                                highlighted: combobox11.highlightedIndex == index
                                background: Rectangle {
                                    implicitWidth: combobox11.width
                                    implicitHeight: 50
                                    opacity: enabled ? 1 : 0.3
                                    color: combobox11.highlightedIndex == index ? "#CCCCCC" : "#e0e0e0"
                                }
                            }
                            // 选择改变时发送命令
                            onActivated: {
                                // 生成十六进制命令字符串并发送
                                var str = combobox10.currentIndex.toString(16).padStart(2, '0') + combobox11.currentIndex.toString(16).padStart(2, '0');
                                confirmsignal("LinkTrain", parseInt(str, 16))
                            }
                        }
                    }
                }
            }
        }
    }
    // 电源输出控制页面布局
    RowLayout {
        visible: pageflag == 7 && pageindex == 1 ? true : false  // 仅在电源输出控制页面显示
        anchors.top: parent.top
        anchors.topMargin: 120
        width: parent.width
        
        // 正常电源模式按钮
        CustomButton{
            id: poweron_btn
            width: btnWidth
            height: btnHeight
            border.color: "black"
            border.width: 2
            color: flag ? 'gray' : 'black'  // 按下状态改变颜色
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag: false  // 按下状态标志
            Text {
                text: qsTr("Normal")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    poweron_btn.flag = true  // 设置按下状态
                }
                onReleased: {
                    poweron_btn.flag = false  // 恢复正常状态
                    confirmsignal("PowerOut", "0")  // 发送正常电源模式信号
                }
            }
        }

        // 待机电源模式按钮
        CustomButton{
            id: poweroff_btn
            width: btnWidth
            height: btnHeight
            border.color: "black"
            border.width: 2
            color: flag ? 'gray' : 'black'  // 按下状态改变颜色
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            property bool flag: false  // 按下状态标志
            Text {
                text: qsTr("Standby")
                anchors.centerIn: parent
                font.family: myriadPro.name
                font.pixelSize: btnfontsize
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    poweroff_btn.flag = true  // 设置按下状态
                }
                onReleased: {
                    poweroff_btn.flag = false  // 恢复正常状态
                    confirmsignal("PowerOut", "1")  // 发送待机电源模式信号
                }
            }
        }
    }
}
