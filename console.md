```log
root@rk3568-buildroot:/# Client disconnected: "::ffff:192.168.1.40"          // WebSocketServer::socketDisconnected() - Web客户端断开连接
Close code: 1001                                                               // WebSocketServer::socketDisconnected() - WebSocket关闭代码
Close reason: ""                                                               // WebSocketServer::socketDisconnected() - 关闭原因
qml: Client disconnected                                                       // main.qml WebSocketServer onClientDisconnected signal
Client disconnected: "::ffff:192.168.1.40"                                    // WebSocketServer::socketDisconnected() - 另一个客户端断开
Close code: 1001                                                               // WebSocketServer::socketDisconnected() - WebSocket关闭代码
Close reason: ""                                                               // WebSocketServer::socketDisconnected() - 关闭原因
qml: Client disconnected                                                       // main.qml WebSocketServer onClientDisconnected signal
New client connected to path: "/ws/uart"                                      // WebSocketServer::onNewConnection() - UART WebSocket连接
qml: New client connected                                                      // main.qml WebSocketServer onNewClientConnected signal
qml: Received message from path: /ws/uart Data:                               // main.qml WebSocketServer onMessageReceived signal
READDEFAULT                                                                    // Web前端发送的读取默认配置命令

New client connected to path: "/ws/upload"                                    // WebSocketServer::onNewConnection() - 上传WebSocket连接
qml: New client connected                                                      // main.qml WebSocketServer onNewClientConnected signal
Command executed successfully: "mkdir /tmp/update"                            // WebSocketServer::processTextMessage() - TerminalManager::executeCommand()
Command executed successfully: "rm -rf /tmp/update/*"                         // WebSocketServer::processTextMessage() - TerminalManager::executeCommand()
Start receiving file: "/tmp/update/update.zip"                               // WebSocketServer::processTextMessage() - 开始接收升级包文件
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 写入二进制数据块
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 继续写入数据块
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 继续写入数据块
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 继续写入数据块
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 继续写入数据块
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 继续写入数据块
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 继续写入数据块
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes                // WebSocketServer::processBinaryMessage() - 继续写入数据块
Writing to file: "/tmp/update/update.zip" Size: 410993 bytes                 // WebSocketServer::processBinaryMessage() - 最后一个数据块
Detached command started successfully: "/data/upgrademodule"                  // WebSocketServer::processTextMessage() - TerminalManager::executeDetachedCommand()
File upload completed: "update.zip" Size: 17188209 bytes                     // WebSocketServer::processTextMessage() - 文件上传完成
Command executed successfully: "unzip -o /tmp/update/update.zip -d /tmp/update" // WebSocketServer::processTextMessage() - TerminalManager::executeCommand()
Command executed successfully: "rm -rf /userdata/spi"                         // WebSocketServer::processTextMessage() - TerminalManager::executeCommand()
Command executed successfully: "mv /tmp/update/spi /userdata/spi"             // WebSocketServer::processTextMessage() - TerminalManager::executeCommand()
Command executed successfully: "chmod +x /userdata/spi"                       // WebSocketServer::processTextMessage() - TerminalManager::executeCommand()
[FILE] "c51.zip" Size: 5420 bytes                                            // WebSocketServer::processTextMessage() - 列出升级包内容
[FILE] "fpga.zip" Size: 4998739 bytes                                        // WebSocketServer::processTextMessage() - 列出升级包内容
[FILE] "mcu.zip" Size: 34356 bytes                                           // WebSocketServer::processTextMessage() - 列出升级包内容
[FILE] "sg.zip" Size: 7004850 bytes                                          // WebSocketServer::processTextMessage() - 列出升级包内容
[FILE] "update.zip" Size: 17188209 bytes                                     // WebSocketServer::processTextMessage() - 列出升级包内容
[FILE] "www.zip" Size: 5281428 bytes                                         // WebSocketServer::processTextMessage() - 列出升级包内容
start unzip: "update.zip"                                                     // WebSocketServer::processTextMessage() - 开始解压升级包
Invalid JSON message                                                          // WebSocketServer::processTextMessage() - JSON解析失败
qml: Received message from path: /ws/upload Data: upgrade:mcu,                // main.qml WebSocketServer onMessageReceived - 收到MCU升级命令

Command executed successfully: "rm -rf /data/FW.fwm"                          // main.qml upgrademcu() - TerminalManager::executeCommand()
Command executed successfully: "unzip -o /tmp/update/mcu.zip -d /data/"       // main.qml upgrademcu() - TerminalManager::executeCommand()
Connected to server                                                            // TcpClient::onConnected() - 连接到升级服务器成功
qml: TCP Connected via WebSocketServer                                        // main.qml WebSocketServer onTcpConnected signal
close port uart5!                                                             // SerialPortManager::closePortUart5() - 关闭串口避免冲突
Send to tcpserver...                                                          // TcpClient::sendMessage() - 准备发送TCP消息
Send to tcpserver "\r\nGET FIRMWARELIST\r\n"                                 // TcpClient::sendMessage() - 发送获取固件列表命令
Send to tcpserver...                                                          // TcpClient::sendMessage() - 准备发送TCP消息
NewConnectionSlot                                                              // /data/upgrademodule - 升级模块接受新连接
Send to tcpserver "\r\nUPGRADEMODE||5\r\n"                                   // TcpClient::sendMessage() - 发送升级模式设置命令
Send to tcpserver...                                                          // TcpClient::sendMessage() - 准备发送TCP消息
Send to tcpserver "\r\nSETCOMPORT||ttyS5\r\n"                                // TcpClient::sendMessage() - 发送串口设置命令
Send to tcpserver...                                                          // TcpClient::sendMessage() - 准备发送TCP消息
Send to tcpserver "\r\nUPGRADE||Main,0,0\r\n"                                // TcpClient::sendMessage() - 发送开始升级命令
parseData: "GET FIRMWARELIST"                                                 // /data/upgrademodule - 解析GET FIRMWARELIST命令
getlistfileName: "/data/FW.fwm"                                               // /data/upgrademodule - 获取固件文件名
fileName: "/data/FW.fwm"                                                      // /data/upgrademodule - 确认固件文件名
i: "1024009"                                                                  // /data/upgrademodule - 固件文件大小信息
length: "0"                                                                   // /data/upgrademodule - 长度字段
fileHeadMD5: "8769154f"                                                       // /data/upgrademodule - 文件头MD5校验值
checkMD5: "8769154f"                                                          // /data/upgrademodule - 计算得到的MD5值
checkFWMmd5 OK!!                                                              // /data/upgrademodule - MD5校验通过
TCPServermessage : ("Firmware file checksum ok.")                            // /data/upgrademodule - 固件文件校验成功消息
"127.0.0.1" : 41584 : "UPGRADELOG||Firmware file checksum ok.\r\n"          // /data/upgrademodule - 发送升级日志到客户端
jsonLength: "351"                                                             // /data/upgrademodule - JSON数据长度
TCPServermessage : ("Firmware package version: 6")                           // /data/upgrademodule - 固件包版本信息
"127.0.0.1" : 41584 : "UPGRADELOG||Firmware package version: 6\r\n"         // /data/upgrademodule - 发送版本信息到客户端
Document is an object                                                          // /data/upgrademodule - JSON文档解析成功

TCPServermessage : ("Model Name: SA-V04")                                     // /data/upgrademodule - 设备型号信息
"127.0.0.1" : 41584 : "UPGRADELOG||Model Name: SA-V04\r\n"                   // /data/upgrademodule - 发送型号信息到客户端
TCPServermessage : ("Version: 02")                                            // /data/upgrademodule - 固件版本信息
"127.0.0.1" : 41584 : "UPGRADELOG||Version: 02\r\n"                          // /data/upgrademodule - 发送版本信息到客户端
"127.0.0.1" : 41584 : "FIRMWARELIST||{\"model\":\"SA-V04\",\"version\":\"02\",\"chips\":[{\"name\":\"SA10H-48G-V04\",\"chip_type\":\"1\",\"chip_quanity\":\"1\",\"mcus\":[{\"name\":\"STM32F103RE\",\"mcu_type\":\"3\",\"pcbs\":[{\"name\":\"PCB_V0.1\",\"pcb_version\":\"1\",\"speciality\":\"A\",\"fw_file\":\"D:/Drivers_example/SA10H-48G-V04/MCU/SA10H-48G-V04/build/STM3210E-EVAL/SA10H-48G-V04.bin\",\"ver1\":\"01\",\"ver2\":\"06\",\"ver3\":\"00\"}]}]}]}\r\n" // /data/upgrademodule - 发送完整固件列表JSON
parseData: "UPGRADEMODE||5"                                                   // /data/upgrademodule - 解析升级模式命令
"127.0.0.1" : 41584 : "UPGRADELOG||Set UPGRADEMODE to 5\r\n"                 // /data/upgrademodule - 设置升级模式为5
parseData: "SETCOMPORT||ttyS5"                                                // /data/upgrademodule - 解析串口设置命令
"127.0.0.1" : 41584 : "UPGRADELOG||Set COMPORT to ttyS5\r\n"                 // /data/upgrademodule - 设置串口为ttyS5
parseData: "UPGRADE||Main,0,0"                                                // /data/upgrademodule - 解析开始升级命令
WorkerCOMdisconnected                                                          // /data/upgrademodule - 工作线程串口断开
UploadStart                                                                    // /data/upgrademodule - 开始上传升级
all_disconnected                                                              // /data/upgrademodule - 所有连接断开
TCPServermessage : ("Disconnect")                                             // /data/upgrademodule - 断开连接消息
"127.0.0.1" : 41584 : "UPGRADELOG||Disconnect\r\n"                           // /data/upgrademodule - 发送断开日志
TCPServermessage : (" port is disconnected.")                                // /data/upgrademodule - 端口断开消息
"127.0.0.1" : 41584 : "UPGRADELOG|| port is disconnected.\r\n"               // /data/upgrademodule - 发送端口断开日志
receive: "UPGRADELOG||Firmware file checksum ok.\r\nUPGRADELOG||Firmware package version: 6\r\nUPGRADELOG||Model Name: SA-V04\r\nUPGRADELOG||Version: 02\r\nFIRMWARELIST||{\"model\":\"SA-V04\",\"version\":\"02\",\"chips\":[{\"name\":\"SA10H-48G-V04\",\"chip_type\":\"1\",\"chip_quanity\":\"1\",\"mcus\":[{\"name\":\"STM32F103RE\",\"mcu_type\":\"3\",\"pcbs\":[{\"name\":\"PCB_V0.1\",\"pcb_version\":\"1\",\"speciality\":\"A\",\"fw_file\":\"D:/Drivers_example/SA10H-48G-V04/MCU/SA10H-48G-V04/build/STM3210E-EVAL/SA10H-48G-V04.bin\",\"ver1\":\"01\",\"ver2\":\"06\",\"ver3\":\"00\"}]}]}]}\r\nUPGRADELOG||Set UPGRADEMODE to 5\r\nUPGRADELOG||Set COMPORT to ttyS5\r\n" // TcpClient::onReadyRead() - 接收升级模块返回的消息
receive: "UPGRADELOG||Disconnect\r\nUPGRADELOG|| port is disconnected.\r\n"  // TcpClient::onReadyRead() - 接收断开连接消息
uploadfileName: "/data/FW.fwm"                                                // /data/upgrademodule - 上传固件文件名
fileName: "/data/FW.fwm"                                                      // /data/upgrademodule - 确认固件文件名
TCPServermessage : ("ConnectSuccess", "ttyS5")                               // /data/upgrademodule - 串口连接成功
"127.0.0.1" : 41584 : "Connect success.\r\n"                                 // /data/upgrademodule - 发送连接成功消息
receive: "Connect success.\r\n"                                               // TcpClient::onReadyRead() - 接收连接成功消息
i: "1024009"                                                                  // /data/upgrademodule - 固件文件大小
length: "0"                                                                   // /data/upgrademodule - 长度字段
fileHeadMD5: "8769154f"                                                       // /data/upgrademodule - 文件头MD5
checkMD5: "8769154f"                                                          // /data/upgrademodule - 校验MD5
checkFWMmd5 OK!!                                                              // /data/upgrademodule - MD5校验通过
TypeAndInex: "1"                                                              // /data/upgrademodule - 类型和索引
TCPServermessage : ("Firmware file checksum ok.")                            // /data/upgrademodule - 固件文件校验成功
"127.0.0.1" : 41584 : "UPGRADELOG||Firmware file checksum ok.\r\n"          // /data/upgrademodule - 发送校验成功日志
sendMsg:canRead:true                                                          // /data/upgrademodule - 可以发送消息
write-controlcenterdatas: "AA 5B A5 07 00 00 00 00 F9 00 00 56 "            // /data/upgrademodule - 向MCU发送升级协议命令
TCPServermessage : ("Read bootcode information of 'Main'.")                  // /data/upgrademodule - 读取主控bootcode信息
"127.0.0.1" : 41584 : "UPGRADELOG||Read bootcode information of 'Main'.\r\n" // /data/upgrademodule - 发送读取bootcode日志
receive: "UPGRADELOG||Firmware file checksum ok.\r\n"                        // TcpClient::onReadyRead() - 接收固件校验消息
receive: "UPGRADELOG||Read bootcode information of 'Main'.\r\n"              // TcpClient::onReadyRead() - 接收读取bootcode消息
onTimeOutSendOtherCommand                                                      // /data/upgrademodule - 超时重发命令
sendMsg:canRead:true                                                          // /data/upgrademodule - 可以发送消息
TCPServermessage : ("Read the bootcode information of 'Main' fail, retry 1.") // /data/upgrademodule - 读取bootcode失败，重试1
write-controlcenterdatas: "AA 5B A5 07 00 00 00 00 F9 00 00 56 "            // /data/upgrademodule - 重新发送升级协议命令
"127.0.0.1" : 41584 : "UPGRADELOG||Read the bootcode information of 'Main' fail, retry 1.\r\n" // /data/upgrademodule - 发送重试1日志
TCPServermessage : ("Read bootcode information of 'Main'.")                  // /data/upgrademodule - 再次读取bootcode
"127.0.0.1" : 41584 : "UPGRADELOG||Read bootcode information of 'Main'.\r\n" // /data/upgrademodule - 发送读取bootcode日志
receive: "UPGRADELOG||Read the bootcode information of 'Main' fail, retry 1.\r\nUPGRADELOG||Read bootcode information of 'Main'.\r\n" // TcpClient::onReadyRead() - 接收重试消息
onTimeOutSendOtherCommand                                                      // /data/upgrademodule - 再次超时重发
sendMsg:canRead:true                                                          // /data/upgrademodule - 可以发送消息
TCPServermessage : ("Read the bootcode information of 'Main' fail, retry 2.") // /data/upgrademodule - 读取bootcode失败，重试2
write-controlcenterdatas: "AA 5B A5 07 00 00 00 00 F9 00 00 56 "            // /data/upgrademodule - 第三次发送升级协议命令
"127.0.0.1" : 41584 : "UPGRADELOG||Read the bootcode information of 'Main' fail, retry 2.\r\n" // /data/upgrademodule - 发送重试2日志
TCPServermessage : ("Read bootcode information of 'Main'.")                  // /data/upgrademodule - 第三次读取bootcode
"127.0.0.1" : 41584 : "UPGRADELOG||Read bootcode information of 'Main'.\r\n" // /data/upgrademodule - 发送读取bootcode日志
receive: "UPGRADELOG||Read the bootcode information of 'Main' fail, retry 2.\r\n" // TcpClient::onReadyRead() - 接收重试2消息
receive: "UPGRADELOG||Read bootcode information of 'Main'.\r\n"              // TcpClient::onReadyRead() - 接收读取bootcode消息
onTimeOutSendOtherCommand                                                      // /data/upgrademodule - 最终超时
tmpPercent: "100"                                                              // /data/upgrademodule - 进度设为100%
TCPServermessage : ("Read the bootcode information of 'Main' fail, check the next mcu.") // /data/upgrademodule - 检查下一个MCU
"127.0.0.1" : 41584 : "UPGRADELOG||Read the bootcode information of 'Main' fail, check the next mcu.\r\n" // /data/upgrademodule - 发送检查下一个MCU日志
TCPServermessage : ("Read the bootcode information of 'Main' fail, exit upgrade.") // /data/upgrademodule - 退出升级
"127.0.0.1" : 41584 : "UPGRADELOG||Read the bootcode information of 'Main' fail, exit upgrade.\r\n" // /data/upgrademodule - 发送退出升级日志
TCPServermessage : ("APPSTATUS", "7")                                         // /data/upgrademodule - 应用状态7（升级失败）
WorkerCOMdisconnected                                                          // /data/upgrademodule - 工作线程串口断开
"127.0.0.1" : 41584 : "\r\nDISCONNECTCOM\r\n"                               // /data/upgrademodule - 发送断开串口消息
"127.0.0.1" : 41584 : "\r\nUPGRADEFAIL\r\n"                                 // /data/upgrademodule - 发送升级失败消息
all_disconnected                                                              // /data/upgrademodule - 所有连接断开
TCPServermessage : ("UPGRADERESULT", "Main,0,0,,,,,,,,,0,2", "2")            // /data/upgrademodule - 升级结果（失败，错误代码2）
receive: "UPGRADELOG||Read the bootcode information of 'Main' fail, check the next mcu.\r\nUPGRADELOG||Read the bootcode information of 'Main' fail, exit upgrade.\r\n\r\nDISCONNECTCOM\r\n\r\nUPGRADEFAIL\r\n" // TcpClient::onReadyRead() - 接收最终失败消息
TCPServermessage : ("Disconnect")                                             // /data/upgrademodule - 断开连接
"127.0.0.1" : 41584 : "UPGRADELOG||Disconnect\r\n"                           // /data/upgrademodule - 发送断开日志
TCPServermessage : ("ttyS5 port is disconnected.")                           // /data/upgrademodule - 串口断开消息
"127.0.0.1" : 41584 : "UPGRADELOG||ttyS5 port is disconnected.\r\n"          // /data/upgrademodule - 发送串口断开日志
receive: "UPGRADELOG||Disconnect\r\nUPGRADELOG||ttyS5 port is disconnected.\r\n" // TcpClient::onReadyRead() - 接收最终断开消息
