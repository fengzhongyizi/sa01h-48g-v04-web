# sa01h-48g-v04 SG System 页面功能详细分析

## 1. 系统架构概览

SG System页面包含四个主要功能模块：
- **IP Management**: 网络配置管理
- **Fan Control**: 风扇控制
- **Reset & Reboot**: 重置和重启
- **Vitals**: 设备状态监控

```
SystemSetup.qml (主界面)
    ↓
main.qml (信号处理和后端通信)
    ↓
C++后端组件 (NetManager, SerialPortManager, TerminalManager等)
```

## 2. IP Management 功能详解

### 2.1 界面结构

```qml
// SystemSetup.qml - IP管理界面
property bool ip_management_dhcp_flag: false  // DHCP模式标志

RowLayout {
    visible: pageflag==1&&pageindex == 1?true:false
    Rectangle{
        border.width: 1
        border.color: "white"
        radius: 5
        color: "gray"
        height: 600
        width: 800
        
        Column{
            // HOST IP输入框
            TextField {
                id:host_ip
                text: qsTr("192.168.1.199")
                onPressed: {
                    currentInputField = host_ip;
                    virtualKeyboard.visible = true  // 显示虚拟键盘
                }
            }
            
            // ROUTER IP输入框
            TextField {
                id:router_ip
                text: qsTr("192.168.1.1")
            }
            
            // IP MASK输入框
            TextField {
                id:ip_mask
                text: qsTr("255.255.255.0")
            }
            
            // MAC ADDRESS显示框（只读）
            TextField {
                id:mac_address
                text: qsTr("")
                readOnly: true
            }
            
            // TCP PORT显示框（只读）
            TextField {
                id:tcp_port
                text: qsTr("")
                readOnly: true
            }
        }
    }
}
```

### 2.2 DHCP/Static切换机制

```qml
// DHCP按钮
CustomButton{
    border.color: ip_management_dhcp_flag ? "orange" : "black"
    color: ip_management_dhcp_flag?'black':'gray'
    Text { text: qsTr("DHCP") }
    
    MouseArea{
        onClicked: {
            ip_management_dhcp_flag = true
            confirmsignal("DHCP", true)  // 发送DHCP启用信号
        }
    }
}

// Static按钮
CustomButton{
    border.color: ip_management_dhcp_flag ? "black" : "orange"
    color: ip_management_dhcp_flag?'gray':'black'
    Text { text: qsTr("Static") }
    
    MouseArea{
        onClicked: {
            ip_management_dhcp_flag = false
            confirmsignal("DHCP", false)  // 发送Static模式信号
        }
    }
}
```

### 2.3 后端网络配置处理

```cpp
// main.qml - Connections信号处理
Connections{
    target: systemSetup
    
    function onConfirmsignal(str, num){
        if(str === "DHCP"){
            if(num===1){  // 启用DHCP
                netManager.setIpAddress("192.168.1.223", "255.255.0.0","192.168.1.2","dhcp");
                fileManager.updateData("ipmode", "dhcp");
            }else{  // 使用Static IP
                netManager.setIpAddress(
                    systemSetup.host_ip.text, 
                    systemSetup.ip_mask.text,
                    systemSetup.router_ip.text,
                    "static"
                );
                fileManager.updateData("ipmode", "static");
                fileManager.updateData("iphost", systemSetup.host_ip.text);
                fileManager.updateData("ipmask", systemSetup.ip_mask.text);
                fileManager.updateData("iprouter", systemSetup.router_ip.text);
            }
        }
    }
}
```

### 2.4 NetManager网络管理器

```cpp
// netmanager.cpp - 核心网络配置函数
void NetManager::setIpAddress(const QString& ipAddress, const QString& netmask,
                              const QString& gateway, const QString& mode) {
    if(mode == "dhcp"){
        QProcess dhcpprocess;
        // 启用DHCP模式
        QString dhcpCommand = QString("ifconfig eth0 0.0.0.0 up && dhcpcd --waitip=4 --persistent");
        dhcpprocess.start("sh", QStringList() << "-c" << dhcpCommand);
        dhcpprocess.waitForFinished();
        
        if (dhcpprocess.exitStatus() == QProcess::NormalExit && dhcpprocess.exitCode() == 0) {
           qDebug() << "set dhcp successfully.";
           // 2秒后更新网络信息
           QTimer::singleShot(2000, [this]() {
                  updateNetworkInfo();
              });
        }
    }else {
        // 设置静态IP
        QString command = QString("ifconfig eth0 %1 netmask %2 up").arg(ipAddress).arg(netmask);
        QProcess process;
        process.start("sh", QStringList() << "-c" << command);
        process.waitForFinished();
        
        // 设置默认网关
        QString routeCommand = QString("route add default gw %1 eth0").arg(gateway);
        QProcess routeProcess;
        routeProcess.start("sh", QStringList() << "-c" << routeCommand);
        routeProcess.waitForFinished();
        
        updateNetworkInfo();  // 立即更新网络信息
    }
}

// 获取当前网络信息
void NetManager::updateNetworkInfo() {
    // 获取eth0接口信息
    foreach (const QNetworkInterface& networkInterface, QNetworkInterface::allInterfaces()) {
        if (networkInterface.name() == "eth0") {
            m_macAddress = networkInterface.hardwareAddress();  // MAC地址
            emit macAddressChanged(m_macAddress);

            foreach (const QNetworkAddressEntry& addressEntry, networkInterface.addressEntries()) {
                if (addressEntry.ip().protocol() == QAbstractSocket::IPv4Protocol) {
                    m_ipAddress = addressEntry.ip().toString();      // IP地址
                    m_netmask = addressEntry.netmask().toString();   // 子网掩码
                    emit ipAddressChanged(m_ipAddress);
                    emit netmaskChanged(m_netmask);
                }
            }
        }
    }

    // 获取默认网关
    QProcess process;
    process.start("sh", QStringList() << "-c" << "ip route | grep default");
    process.waitForFinished();
    QString output = process.readAllStandardOutput();
    QStringList outputList = output.split(" ");
    if (outputList.size()>=2) {
        m_routerIpAddress = outputList[2];
    }
    emit routerIpAddressChanged(m_routerIpAddress);

    // 获取TCP端口信息
    process.start("sh", QStringList() << "-c" << "netstat -tln | grep LISTEN");
    process.waitForFinished();
    output = process.readAllStandardOutput();
    // 解析端口信息...
}
```

### 2.5 WebSocket通信支持

```javascript
// main.qml - WebSocket消息处理
if(message.indexOf("get ip mode")!=-1){
    webSocketServer.sendMessageToAllClients("ip mode "+fileManager.getValue("ipmode")+"\r\n");
}else if(message.indexOf("get mac address")!=-1){
    webSocketServer.sendMessageToAllClients("mac address "+systemSetup.mac_address.text+"\r\n");
}else if(message.indexOf("get host ip")!=-1){
    webSocketServer.sendMessageToAllClients("host ip "+systemSetup.host_ip.text+"\r\n");
}else if(message.indexOf("get ip mask")!=-1){
    webSocketServer.sendMessageToAllClients("ip mask "+systemSetup.ip_mask.text+"\r\n");
}else if(message.indexOf("get route ip")!=-1){
    webSocketServer.sendMessageToAllClients("route ip "+systemSetup.router_ip.text+"\r\n");
}else if(message.indexOf("get tcp port")!=-1){
    webSocketServer.sendMessageToAllClients("tcp port "+systemSetup.tcp_port.text+"\r\n");
}
```

## 3. Fan Control 功能详解

### 3.1 界面结构

```qml
// SystemSetup.qml - 风扇控制界面
property int fan_control_flag: 0  // 当前风扇模式

GridLayout{
    visible: pageflag==2&&pageindex == 1?true:false
    rowSpacing: 50
    columns: 2
    
    ListModel {
        id: fan_control_model
        ListElement { first: "Auto"; number: 4 }    // 自动模式
        ListElement { first: "Speed 1"; number: 1 } // 速度1
        ListElement { first: "Speed 2"; number: 2 } // 速度2  
        ListElement { first: "Speed 3"; number: 3 } // 速度3
    }
    
    Repeater{
        model: fan_control_model
        CustomButton{
            border.color: fan_control_flag==number?"orange":"black"
            color: 'black'
            Text { text: first }
            
            MouseArea{
                onClicked: {
                    fan_control_flag=number
                    confirmsignal("FanControl",number)  // 发送风扇控制信号
                }
            }
        }
    }
}
```

### 3.2 风扇控制后端处理

```javascript
// main.qml - 风扇控制信号处理
function onConfirmsignal(str, num){
    if(str === "FanControl"){
        if(num === 4){  // 自动模式
            serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
        }else{  // 手动模式
            serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
            serialPortManager.writeDataUart5("SET FAN SPEED "+num+"\r\n", 1);
        }
        return  // 风扇控制不需要发送FPGA命令
    }
}
```

### 3.3 风扇状态反馈处理

```javascript
// main.qml - 串口数据接收处理
onDataReceivedASCALL:{
    if(data.indexOf("FAN SPEED")!=-1){
        linedata = data.split(" ");
        systemSetup.fan_control_flag = parseInt(linedata[2]);
        // 发送WebSocket响应
        webSocketServer.sendMessageToAllClients("RESPONSE||F803||"+ systemSetup.fan_control_flag +"\r\n");
        // 保存到配置文件
        fileManager.updateData("FanControl", parseInt(linedata[2]).toString(16).padStart(2, '0'));
    }else if(data.indexOf("FAN MODE")!=-1){
        linedata = data.split(" ");
        if(linedata[2]=== "0"){  // 自动模式
            fileManager.updateData("FanControl", "04");
            systemSetup.fan_control_flag = 4;
            webSocketServer.sendMessageToAllClients("RESPONSE||F803||"+ systemSetup.fan_control_flag +"\r\n");
        }
    }
}
```

### 3.4 系统初始化时的风扇设置

```javascript
// main.qml - Component.onCompleted初始化
Component.onCompleted: {
    // 从配置文件读取风扇设置
    systemSetup.fan_control_flag = parseInt(fileManager.getValue("FanControl"),16);
    
    if(systemSetup.fan_control_flag==4){
        // 设置为自动模式
        serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
    }else{
        // 设置为手动模式
        serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
        serialPortManager.writeDataUart5("SET FAN SPEED "+parseInt(fileManager.getValue("FanControl"),16), 1);
    }
}
```

## 4. Reset & Reboot 功能详解

### 4.1 界面结构

```qml
// SystemSetup.qml - 重置重启界面
GridLayout{
    visible: pageflag==3&&pageindex == 1?true:false
    rowSpacing: 50
    columns: 2
    
    ListModel {
        id: reset_reboot_model
        ListElement { first: "Factory Reset"; action: "ResetDefault" }
        ListElement { first: "Reboot System"; action: "Reboot" }
    }
    
    Repeater{
        model: reset_reboot_model
        CustomButton{
            border.color: "black"
            color: 'black'
            Text { text: first }
            
            MouseArea{
                onClicked: {
                    confirmsignal(action, 0)  // 发送重置或重启信号
                }
            }
        }
    }
}
```

### 4.2 重置和重启后端处理

```javascript
// main.qml - 重置重启信号处理
function onConfirmsignal(str, num){
    if(str === "ResetDefault"){
        reset();  // 调用重置函数
    }else if(str === "Reboot"){
        syscmd = "reboot";
        terminalManager.executeCommand(syscmd)  // 执行重启命令
    }
}

// 重置函数实现
function reset(){
    // 重置所有配置到默认值
    fileManager.updateData("ipmode", "dhcp");
    fileManager.updateData("FanControl", "04");  // 风扇自动模式
    fileManager.updateData("ARC/eARC_OUT", "00");
    
    // 重置网络配置
    netManager.setIpAddress("192.168.1.223", "255.255.0.0","192.168.1.2","dhcp");
    
    // 重置风扇为自动模式
    serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
    
    // 重置其他硬件设置...
    
    // 重新加载配置
    Component.onCompleted();
}
```

### 4.3 系统重启命令

```cpp
// terminalmanager.cpp - 执行系统命令
void TerminalManager::executeCommand(const QString &command) {
    QProcess process;
    process.start("sh", QStringList() << "-c" << command);
    process.waitForFinished();
    
    if (process.exitStatus() == QProcess::NormalExit) {
        qDebug() << "Command executed successfully:" << command;
    } else {
        qWarning() << "Command failed:" << command;
    }
}
```

## 5. Vitals 功能详解

### 5.1 界面结构

```qml
// SystemSetup.qml - 设备状态界面
RowLayout {
    visible: pageflag==4&&pageindex == 1?true:false
    Rectangle{
        height: 750
        width: 700
        
        Column{
            Text { text: "FIRMWARE VERSION" }
            
            // Main MCU版本显示
            RowLayout{
                Text { text: "Main MCU:" }
                Rectangle{
                    Text {
                        id:main_mcu
                        text: qsTr("")
                    }
                }
            }
            
            // C51 MCU版本显示
            RowLayout{
                Text { text: "C51 MCU:" }
                Rectangle{
                    Text {
                        id:key_mcu
                        text: qsTr("")
                    }
                }
            }
            
            // Main FPGA版本显示
            RowLayout{
                Text { text: "Main FPGA:" }
                Rectangle{
                    Text {
                        id:main_fpga
                        text: qsTr("")
                    }
                }
            }
            
            // Control Module版本显示
            RowLayout{
                Text { text: "Control Module:" }
                Rectangle{
                    Text {
                        id:lan_mcu
                        text: qsTr("")
                    }
                }
            }
            
            // DSP Module版本显示
            RowLayout{
                Text { text: "DSP Module:" }
                Rectangle{
                    Text {
                        id:dsp_module
                        text: qsTr("")
                    }
                }
            }
            
            Text { text: "MAIN CHIP TEMPERATURE" }
            
            // 主控MCU温度
            RowLayout{
                Text { text: "Main MCU:" }
                Rectangle{
                    Text {
                        id:chip_main_mcu
                        text: qsTr("")
                    }
                }
            }
            
            // 主FPGA温度
            RowLayout{
                Text { text: "Main FPGA:" }
                Rectangle{
                    Text {
                        id:chip_main_fgpa
                        text: qsTr("")
                    }
                }
            }
            
            // 控制模块温度
            RowLayout{
                Text { text: "Control Module:" }
                Rectangle{
                    Text {
                        id:chip_aux_fpga
                        text: qsTr("")
                    }
                }
            }
        }
    }
}
```

### 5.2 设备状态数据获取

```javascript
// SystemSetup.qml - 页面切换时触发数据获取
MouseArea{
    onClicked: {
        pageflag=number
        pageindex = 1
        if(pageflag==4){
            // Vitals - 获取系统状态信息
            confirmsignal("vitals",0x00);  // 请求所有组件状态
        }
    }
}
```

### 5.3 Vitals数据处理后端

```javascript
// main.qml - Vitals信号处理
function onConfirmsignal(str, num){
    if(str === "vitals"){
        strcode = "58 F8 ";
        command_length = "06 00 ";
        hexString = "10"
        
        // 读取温度传感器数据
        cht8310.readData();
        serialPortManager.writeDataUart5("GET NTC 1 VALUE\r\n",1);
        serialPortManager.writeDataUart5("GET NTC 1 VALUE\r\n",1);
        
        // 获取版本信息
        serialPortManager.writeDataUart5("GET VER INF\r\n",1);
        serialPortManager.writeDataUart6("AA 01 00 05 00 01 00 58 F8",0);
        
        // 发送FPGA命令获取版本
        var completeString = command_header +command_length + command_group_address + command_device_address + strcode + hexString;
        serialPortManager.writeData(completeString, typecmd);
    }
}
```

### 5.4 版本信息和温度数据解析

```javascript
// main.qml - 串口数据接收处理
onDataReceived: {
    // 解析C51 MCU版本信息
    if(strcode == "58F8"){
         systemSetup.key_mcu.text = "V"+parseInt(getdata[10],16)+"."+getdata[11];
         webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+ "0,V" + parseInt(getdata[10],16)+"."+getdata[11] +"\r\n");
    }
    // 解析FPGA版本信息
    else if(strcode == "FFFF" && getdata[9]+getdata[10]=== "58F8"){
        systemSetup.main_fpga.text = "V"+parseInt(getdata[11],16)+".0";
        webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+ "16,V" + parseInt(getdata[11],16)+"."+"0" +"\r\n");
    }
}

onDataReceivedASCALL:{
    // 解析主控MCU版本
    if(data.indexOf("MAIN MCU")!=-1){
        linedata = data.split(" ");
        systemSetup.main_mcu.text = linedata[2].replace("\r\n","");
        webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+"1," + linedata[2].replace("\r\n","") +"\r\n");
    }
    // 解析DSP模块版本
    else if(data.indexOf("VER DSP")!=-1){
        linedata = data.split(" ");
        systemSetup.dsp_module.text = linedata[2].replace("\r\n","");
        webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+"34," + linedata[2].replace("\r\n","") +"\r\n");
        // 同时发送控制模块版本（当前软件版本）
        webSocketServer.sendMessageToAllClients("RESPONSE||F858||"+"32," + version +"\r\n");
    }
    // 解析温度数据
    else if(data.indexOf("NTC1 VALUE")!=-1){
        linedata = data.split(" ");
        systemSetup.chip_main_mcu.text = linedata[2].replace("\r\n","")+"°C";
        webSocketServer.sendMessageToAllClients("RESPONSE||F859||"+ "1," + linedata[2].replace("\r\n","") +"\r\n");
    }
}
```

### 5.5 温度传感器CHT8310

```cpp
// cht8310.cpp - 温度传感器读取
void CHT8310::readData() {
    // I2C读取温度传感器数据
    // 具体实现根据CHT8310芯片规格
}
```

## 6. 系统初始化和配置管理

### 6.1 系统启动初始化

```javascript
// main.qml - Component.onCompleted
Component.onCompleted: {
    // 初始化网络配置
    var ip_mode = fileManager.getValue("ipmode");
    systemSetup.ip_management_dhcp_flag = ip_mode ==="static" ? false : true
    systemSetup.host_ip.text = netManager.ipAddress
    systemSetup.router_ip.text = netManager.routerIpAddress
    systemSetup.ip_mask.text = netManager.netmask
    systemSetup.mac_address.text = netManager.macAddress
    systemSetup.tcp_port.text = netManager.tcpPorts

    // 初始化风扇控制
    systemSetup.fan_control_flag = parseInt(fileManager.getValue("FanControl"),16);
    if(systemSetup.fan_control_flag==4){
        serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
    }else{
        serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
        serialPortManager.writeDataUart5("SET FAN SPEED "+parseInt(fileManager.getValue("FanControl"),16), 1);
    }
    
    // 初始化版本信息显示
    systemSetup.main_mcu.text = ""
    systemSetup.key_mcu.text = ""
    systemSetup.lan_mcu.text = version  // 当前软件版本
    systemSetup.main_fpga.text = ""
    systemSetup.dsp_module.text = ""
    systemSetup.chip_main_mcu.text = ""
    systemSetup.chip_main_fgpa.text = ""
    systemSetup.chip_aux_fpga.text = ""
}
```

### 6.2 配置文件管理

```cpp
// filemanager.cpp - 配置数据持久化
class FileManager {
public:
    // 更新配置数据
    void updateData(const QString& key, const QString& value);
    
    // 获取配置值
    QString getValue(const QString& key);
    
private:
    // 配置文件路径和格式
    QString configFilePath;
};
```

## 7. WebSocket API接口

### 7.1 IP管理相关接口

```javascript
// 获取IP配置信息
"get ip mode"     -> "ip mode dhcp/static\r\n"
"get host ip"     -> "host ip 192.168.1.199\r\n"
"get ip mask"     -> "ip mask 255.255.255.0\r\n"
"get route ip"    -> "route ip 192.168.1.1\r\n"
"get mac address" -> "mac address AA:BB:CC:DD:EE:FF\r\n"
"get tcp port"    -> "tcp port 8081\r\n"
```

### 7.2 风扇控制相关接口

```javascript
// 获取风扇状态
"get fan speed"   -> "fan speed 4\r\n"

// 风扇控制响应
"RESPONSE||F803||4\r\n"  // 风扇模式响应
```

### 7.3 设备状态相关接口

```javascript
// 版本信息响应
"RESPONSE||F858||0,V1.0\r\n"   // C51 MCU版本
"RESPONSE||F858||1,V2.1\r\n"   // 主控MCU版本
"RESPONSE||F858||16,V3.0\r\n"  // FPGA版本
"RESPONSE||F858||32,V1.5\r\n"  // 控制模块版本
"RESPONSE||F858||34,V2.0\r\n"  // DSP模块版本

// 温度信息响应
"RESPONSE||F859||1,45\r\n"     // 主控MCU温度
```

## 8. SystemSetupPanel.qml 对比分析

### 8.1 当前SystemSetupPanel实现状况

SystemSetupPanel.qml是一个更现代化的实现，采用了不同的设计风格：

```qml
// SystemSetupPanel.qml - 现代化界面设计
Rectangle {
    id: systemSetupPanel
    color: "#585858"          // 深灰色背景
    border.color: "black"
    border.width: 2
    radius: 4

    // 功能导航按钮区 - 水平布局
    RowLayout {
        Repeater {
            model: [
                { name: "IP Management", index: 0 },
                { name: "Fan Control", index: 1 },
                { name: "Reset & Reboot", index: 2 },
                { name: "Vitals", index: 3 }
            ]
            
            Button {
                background: Rectangle {
                    color: currentSection === modelData.index ? "#ffffff" : "#888888"
                    border.color: "black"
                    border.width: 2
                    radius: 4
                }
            }
        }
    }
}
```

### 8.2 主要差异对比

| 功能模块 | SystemSetup.qml (SG System) | SystemSetupPanel.qml (System Setup) | 状态 |
|----------|----------------------------|-------------------------------------|------|
| **界面布局** | 网格布局，分页显示 | 标签页布局，单页切换 | ✅ 已实现 |
| **IP管理** | 完整DHCP/Static切换 | 基础实现，缺少DHCP逻辑 | ⚠️ 需改进 |
| **风扇控制** | 4档控制(Auto+3速) | 5档控制(OFF+4档) | ⚠️ 需统一 |
| **重置重启** | 基础功能 | 增强UI设计 | ✅ 已实现 |
| **设备状态** | 完整版本+温度显示 | 更多组件支持 | ⚠️ 需整合 |

### 8.3 SystemSetupPanel的优势

1. **更好的UI设计**：
```qml
// 现代化按钮设计
Button {
    background: Rectangle {
        color: fanControlMode === modelData.value ? "#ffffff" : "#888888"
        border.color: "black"
        border.width: 2
        radius: 4
    }
    
    contentItem: Text {
        color: fanControlMode === modelData.value ? "black" : "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
```

2. **更完善的风扇控制**：
```qml
// 支持5档风扇控制
model: [
    { name: "OFF", value: 0x00 },
    { name: "LOW SPEED", value: 0x01 },
    { name: "MIDDLE SPEED", value: 0x02 },
    { name: "HIGH SPEED", value: 0x03 },
    { name: "AUTO", value: 0x04 }
]
```

3. **更丰富的设备状态显示**：
```qml
// 支持更多组件的版本和温度显示
Grid {
    // Main MCU, TX MCU, Key MCU, LAN MCU
    // Main FPGA, AUX FPGA, AUX2 FPGA, DSP Module
    // 对应的温度监控
}
```

## 9. 改进建议和实施方案

### 9.1 IP管理功能改进

**问题**：SystemSetupPanel的IP管理缺少完整的DHCP/Static切换逻辑

**解决方案**：
```qml
// 在SystemSetupPanel.qml中添加DHCP/Static切换
RowLayout {
    Button {
        text: "DHCP"
        background: Rectangle {
            color: isDhcpMode ? "#ffffff" : "#888888"
        }
        onClicked: {
            isDhcpMode = true
            confirmsignal("DHCP", true)
        }
    }
    
    Button {
        text: "Static"
        background: Rectangle {
            color: !isDhcpMode ? "#ffffff" : "#888888"
        }
        onClicked: {
            isDhcpMode = false
            confirmsignal("DHCP", false)
        }
    }
}
```

### 9.2 风扇控制统一

**问题**：两个实现的风扇档位不一致

**建议**：采用SystemSetupPanel的5档设计（OFF+4档），更符合用户需求

**实施**：
```javascript
// 修改main.qml中的风扇控制逻辑
function onConfirmsignal(str, num){
    if(str === "FanControl"){
        if(num === 0){  // OFF模式
            serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
            serialPortManager.writeDataUart5("SET FAN SPEED 0\r\n", 1);
        }else if(num === 4){  // 自动模式
            serialPortManager.writeDataUart5("SET FAN MODE 0\r\n", 1);
        }else{  // 手动模式 1-3档
            serialPortManager.writeDataUart5("SET FAN MODE 1\r\n", 1);
            serialPortManager.writeDataUart5("SET FAN SPEED "+num+"\r\n", 1);
        }
    }
}
```

### 9.3 设备状态功能整合

**建议**：将SystemSetup.qml的完整后端逻辑移植到SystemSetupPanel.qml

**实施步骤**：

1. **添加信号连接**：
```qml
// SystemSetupPanel.qml中添加
Connections {
    target: systemSetupPanel
    function onConfirmsignal(str, num) {
        // 复制SystemSetup.qml中的完整逻辑
    }
}
```

2. **添加数据更新函数**：
```qml
// 版本信息更新
function updateVersionInfo(componentId, version) {
    switch(componentId) {
        case "main_mcu":
            mainMcuText.text = version;
            break;
        case "key_mcu":
            keyMcuText.text = version;
            break;
        // ... 其他组件
    }
}

// 温度信息更新
function updateTemperatureInfo(componentId, temperature) {
    switch(componentId) {
        case "main_mcu":
            mainMcuTempText.text = temperature + "°C";
            break;
        // ... 其他组件
    }
}
```

3. **集成WebSocket支持**：
```qml
// 添加WebSocket消息处理
function handleWebSocketMessage(message) {
    if(message.indexOf("RESPONSE||F858||") !== -1) {
        // 解析版本信息
        var parts = message.split("||");
        var data = parts[2].split(",");
        var componentId = parseInt(data[0]);
        var version = data[1];
        
        switch(componentId) {
            case 0: updateVersionInfo("key_mcu", version); break;
            case 1: updateVersionInfo("main_mcu", version); break;
            case 16: updateVersionInfo("main_fpga", version); break;
            case 32: updateVersionInfo("lan_mcu", version); break;
            case 34: updateVersionInfo("dsp_module", version); break;
        }
    }
}
```

### 9.4 实施优先级

1. **高优先级**：
   - IP管理DHCP/Static切换逻辑
   - 风扇控制档位统一
   - 基础设备状态显示

2. **中优先级**：
   - 完整的WebSocket API支持
   - 温度监控功能
   - 配置持久化

3. **低优先级**：
   - UI美化和动画效果
   - 错误处理和用户反馈
   - 高级网络诊断功能

## 10. 总结

sa01h-48g-v04的SG System页面实现了完整的系统管理功能：

1. **IP Management**: 支持DHCP/Static双模式，实时网络配置
2. **Fan Control**: 4档风扇控制（自动+3档手动）
3. **Reset & Reboot**: 工厂重置和系统重启
4. **Vitals**: 实时设备状态和温度监控

所有功能都通过QML界面、C++后端和串口通信协同工作，支持WebSocket远程控制，具有完善的配置持久化机制。

SystemSetupPanel.qml提供了更现代化的UI设计和更丰富的功能支持，建议将SystemSetup.qml的完整后端逻辑移植过来，实现功能和界面的最佳结合。 