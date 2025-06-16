sg01h-48g-v04-web的包发到板子上的启动日志如下：
```log
root@rk3568-buildroot:/data# QML debugging is enabled. Only use this in a safe environment.
QStandardPaths: runtime directory '/var/run' is not a directory, but a symbolic link to a directory permissions 0755 owned by UID 0 GID 0
No such plugin for spec "/dev/input/event1"
Server started on port 80
arm_release_ver: g13p0-01eac0, rk_so_ver: 10
m_ipAddress= "192.168.1.239"
m_netmask= "255.255.255.0"
m_routerIpAddress= "192.168.1.1"
net.....
open port!
open port uart5!
open port uart6!
write uart3: "AA 00 00 06 00 00 00 61 00 72 7D"
write uart3: "AA 00 00 06 00 00 00 62 00 72 7C"
qml: eARCTX_Latency 0
Data saved to file: "/userdata/gate.conf"
qml: Server running: true
WebSocket server listening on port 8081
New client connected to path: "/ws/uart"
qml: New client connected
qml: Received message from path: /ws/uart Data: 
READDEFAULT

qml: Received message from path: /ws/uart Data: 
SENDSINGLE||103,1

write uart3: "AA 00 00 06 00 00 00 67 00 01 E8"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||104,1

write uart3: "AA 00 00 06 00 00 00 68 00 01 E7"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||115,1

write uart3: "AA 00 00 06 00 00 00 73 00 01 DC"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||107,0

write uart3: "AA 00 00 06 00 00 00 6B 00 00 E5"
New client connected to path: "/ws/upload"
qml: New client connected
```

sg上传包升级时的日志
```log
root@rk3568-buildroot:/# 
root@rk3568-buildroot:/# 
root@rk3568-buildroot:/# Client disconnected: "::ffff:192.168.1.40"
Close code: 1001
Close reason: ""
qml: Client disconnected
Client disconnected: "::ffff:192.168.1.40"
Close code: 1001
Close reason: ""
qml: Client disconnected
New client connected to path: "/ws/uart"
qml: New client connected
qml: Received message from path: /ws/uart Data: 
READDEFAULT

New client connected to path: "/ws/upload"
qml: New client connected
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||103,1

write uart3: "AA 00 00 06 00 00 00 67 00 01 E8"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||104,1

write uart3: "AA 00 00 06 00 00 00 68 00 01 E7"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||115,1

write uart3: "AA 00 00 06 00 00 00 73 00 01 DC"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||107,0

write uart3: "AA 00 00 06 00 00 00 6B 00 00 E5"
Command executed successfully: "mkdir /tmp/update"
Command executed successfully: "rm -rf /tmp/update/*"
Start receiving file: "/tmp/update/update.zip"
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 379034 bytes
Detached command started successfully: "/data/upgrademodule"
File upload completed: "update.zip" Size: 17156250 bytes
Command executed successfully: "unzip -o /tmp/update/update.zip -d /tmp/update"
Command executed successfully: "rm -rf /userdata/spi"
Command executed successfully: "mv /tmp/update/spi /userdata/spi"
Command executed successfully: "chmod +x /userdata/spi"
[FILE] "c51.zip" Size: 5420 bytes
[FILE] "fpga.zip" Size: 4998739 bytes
[FILE] "sg.zip" Size: 7007370 bytes
[FILE] "update.zip" Size: 17156250 bytes
[FILE] "www.zip" Size: 5281428 bytes
start unzip: "update.zip"
Invalid JSON message
qml: Received message from path: /ws/upload Data: upgrade:c51,

Command executed successfully: "echo 106 > /sys/class/gpio/export"
Command executed successfully: "echo out > /sys/class/gpio/gpio106/direction"
Command executed successfully: "echo 0 > /sys/class/gpio/gpio106/value"
Command executed successfully: "echo 1 > /sys/class/gpio/gpio106/value"
Command executed successfully: "rm -rf /data/c51.hex"
Command executed successfully: "unzip -o /tmp/update/c51.zip -d /data/"
qml: onDataReceivedASCALL data received: 
JUMP TO ISP MODE...

qml: onDataReceivedASCALL data received: 
Ready to receive...

qml: c51 filesize: 12215
Invalid JSON message
qml: Received message from path: /ws/upload Data: upgrade:fpga

Command executed successfully: "echo 144 > /sys/class/gpio/export"
Command executed successfully: "echo out > /sys/class/gpio/gpio144/direction"
Command executed successfully: "echo 1 > /sys/class/gpio/gpio144/value"
Command executed successfully: "echo 42 > /sys/class/gpio/export"
Command executed successfully: "echo out > /sys/class/gpio/gpio42/direction"
Command executed successfully: "rm -rf /data/top.bin"
Command executed successfully: "unzip -o /tmp/update/fpga.zip -d /data/"
Command executed successfully: "/userdata/spi -w -f /data/top.bin -a 0000"
qml: onDataReceivedASCALL data received: 
** Firmware Update Complete **
qml: onDataReceivedASCALL data received: 

** RESETTING **

```





------






sa01h-48g-v04-web的包发到板子上的启动日志

```log
root@rk3568-buildroot:/# pkill SG01H-48G-V04
.168.1.4068-buildroot:/# tftp -g -r SG01H-48G-V04 -l /userdata/SG01H-48G-V04 192.
root@rk3568-buildroot:/# /userdata/SG01H-48G-V04&
[1] 819
root@rk3568-buildroot:/# QML debugging is enabled. Only use this in a safe environment.
QStandardPaths: runtime directory '/var/run' is not a directory, but a symbolic link to a directory permissions 0755 owned by UID 0 GID 0
No such plugin for spec "/dev/input/event1"
open port!
open port uart5!
open port uart6!
write uart6: "AA 01 00 05 00 01 00 98 80 37"
write uart6: "AA 01 00 05 00 01 00 99 80 36"
SignalAnalyzerManager created
Server started on port 80
arm_release_ver: g13p0-01eac0, rk_so_ver: 10
m_ipAddress= "192.168.1.239"
m_netmask= "255.255.255.0"
m_routerIpAddress= "192.168.1.1"
net.....
Error opening port: "Permission error while locking the device"
Error opening port: "Permission error while locking the device"
Error opening port: "Permission error while locking the device"
qrc:/SignalAnalyzer.qml:1254:37: QML RadioButton: Binding loop detected for property "checked"
qrc:/SignalAnalyzer.qml:898:37: QML SpinBox: Binding loop detected for property "value"
qrc:/SignalAnalyzer.qml:1254:37: QML RadioButton: Binding loop detected for property "checked"
qrc:/SignalAnalyzer.qml:898:37: QML SpinBox: Binding loop detected for property "value"
qrc:/SignalAnalyzer.qml:1254:37: QML RadioButton: Binding loop detected for property "checked"
qrc:/SignalAnalyzer.qml:898:37: QML SpinBox: Binding loop detected for property "value"
qrc:/SignalAnalyzer.qml:1254:37: QML RadioButton: Binding loop detected for property "checked"
qrc:/SignalAnalyzer.qml:898:37: QML SpinBox: Binding loop detected for property "value"
write uart3: "AA 00 00 06 00 00 00 61 00 72 7D"
write uart3: "AA 00 00 06 00 00 00 62 00 72 7C"
write uart5: "AA 00 00 06 00 00 00 B1 00 02 9D"
write uart5: "AA 00 00 06 00 00 00 B1 00 02 9D"
write uart5: "AA 00 00 06 00 00 00 B2 00 00 9E"
write uart5: "SET HDMI 5V OFF\r\n"
qml: eARCTX_Latency 0
Data saved to file: "/userdata/gate.conf"
write uart5: "AA 00 00 06 00 00 00 7A 00 00 D6"
write uart5: "SET TXLAT NaN"
write uart5: "AA 00 00 06 00 00 00 7A 00 00 D6"
qrc:/main.qml:1422: Error: Cannot assign to non-existent property "out_setup_flag"
qml: SystemSetupPanel initialized
qml: Server running: true
WebSocket server listening on port 8081
Data received from uart6: "\xAB\x01\x00\x07\x00\x01\x00\x98\x80\x00\x00""4\xAB\x01\x00\x07\x00\x01\x00\x99\x80\x01\x00""2"
Data received from uart6: "AB 01 00 07 00 01 00 98 80 00 00 34"
Data received from uart6: "AB 01 00 07 00 01 00 99 80 01 00 32"
qml: No error rate monitoring data to display
qml: No error rate monitoring data to display
qml: No error rate monitoring data to display
qml: No error rate monitoring data to display
New client connected to path: "/ws/upload"
qml: New client connected
New client connected to path: "/ws/uart"
qml: New client connected
qml: Received message from path: /ws/uart Data: 
READDEFAULT

qml: Received message from path: /ws/uart Data: 
SENDSINGLE||103,1

write uart3: "AA 00 00 06 00 00 00 67 00 01 E8"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||104,1

write uart3: "AA 00 00 06 00 00 00 68 00 01 E7"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||115,1

write uart3: "AA 00 00 06 00 00 00 73 00 01 DC"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||107,0

write uart3: "AA 00 00 06 00 00 00 6B 00 00 E5"
write uart6: "AA 01 00 05 00 01 00 98 80 37"

```

sa升级日志
```log
Client disconnected: "::ffff:192.168.1.40"
Close code: 1001
Close reason: ""
qml: Client disconnected
Client disconnected: "::ffff:192.168.1.40"
Close code: 1001
Close reason: ""
qml: Client disconnected
New client connected to path: "/ws/uart"
qml: New client connected
New client connected to path: "/ws/upload"
qml: New client connected
qml: Received message from path: /ws/uart Data: 
READDEFAULT

qml: Received message from path: /ws/uart Data: 
SENDSINGLE||103,1

write uart3: "AA 00 00 06 00 00 00 67 00 01 E8"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||104,1

write uart3: "AA 00 00 06 00 00 00 68 00 01 E7"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||115,1

write uart3: "AA 00 00 06 00 00 00 73 00 01 DC"
qml: Received message from path: /ws/uart Data: 
SENDSINGLE||107,0

write uart3: "AA 00 00 06 00 00 00 6B 00 00 E5"
write uart6: "AA 01 00 05 00 01 00 98 80 37"
write uart6: "AA 01 00 05 00 01 00 99 80 36"
write uart5: "GET NTC 1 VALUE\r\n"
write uart6: "AA 01 00 05 00 01 00 98 80 37"
Command executed successfully: "mkdir /tmp/update"
Command executed successfully: "rm -rf /tmp/update/*"
Start receiving file: "/tmp/update/update.zip"
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 2097152 bytes
Writing to file: "/tmp/update/update.zip" Size: 379034 bytes
Detached command started successfully: "/data/upgrademodule"
File upload completed: "update.zip" Size: 17156250 bytes
Command executed successfully: "unzip -o /tmp/update/update.zip -d /tmp/update"
Command executed successfully: "rm -rf /userdata/spi"
Command executed successfully: "mv /tmp/update/spi /userdata/spi"
Command executed successfully: "chmod +x /userdata/spi"
[FILE] "c51.zip" Size: 5420 bytes
[FILE] "fpga.zip" Size: 4998739 bytes
[FILE] "sg.zip" Size: 7007370 bytes
[FILE] "update.zip" Size: 17156250 bytes
[FILE] "www.zip" Size: 5281428 bytes
start unzip: "update.zip"
Invalid JSON message
qml: Received message from path: /ws/upload Data: upgrade:c51,

Command executed successfully: "echo 106 > /sys/class/gpio/export"
Command executed successfully: "echo out > /sys/class/gpio/gpio106/direction"
Command executed successfully: "echo 0 > /sys/class/gpio/gpio106/value"
Command executed successfully: "echo 1 > /sys/class/gpio/gpio106/value"
Command executed successfully: "rm -rf /data/c51.hex"
Command executed successfully: "unzip -o /tmp/update/c51.zip -d /data/"
write uart6: "ISP 51 2\r\n"

```