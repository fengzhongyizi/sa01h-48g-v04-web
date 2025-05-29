23:29:55: Running steps for project SA01H-48G-V04...
23:29:55: Starting: "/usr/bin/make" clean -j12
rm -f qrc_qml.cpp
rm -f moc_predefs.h
rm -f moc_serialportmanager.cpp moc_pcievideoreciver.cpp moc_netmanager.cpp moc_terminalmanager.cpp moc_filemanager.cpp moc_websocketserver.cpp moc_tcpserver.cpp moc_signalanalyzermanager.cpp
rm -f main.o serialportmanager.o pcievideoreciver.o netmanager.o terminalmanager.o filemanager.o websocketserver.o tcpserver.o signalanalyzermanager.o qrc_qml.o moc_serialportmanager.o moc_pcievideoreciver.o moc_netmanager.o moc_terminalmanager.o moc_filemanager.o moc_websocketserver.o moc_tcpserver.o moc_signalanalyzermanager.o
rm -f *~ core *.core
23:29:55: The process "/usr/bin/make" exited normally.
23:29:55: Configuration unchanged, skipping qmake step.
23:29:55: Starting: "/usr/bin/make" -j12
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o main.o main.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o serialportmanager.o serialportmanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o pcievideoreciver.o pcievideoreciver.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o netmanager.o netmanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o terminalmanager.o terminalmanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o filemanager.o filemanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o websocketserver.o websocketserver.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o tcpserver.o tcpserver.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o signalanalyzermanager.o signalanalyzermanager.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/rcc -name qml qml.qrc -o qrc_qml.cpp
g++ -pipe -g -std=gnu++11 -Wall -W -dM -E -o moc_predefs.h /opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/features/data/dummy.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include serialportmanager.h -o moc_serialportmanager.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include pcievideoreciver.h -o moc_pcievideoreciver.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include netmanager.h -o moc_netmanager.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include terminalmanager.h -o moc_terminalmanager.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include filemanager.h -o moc_filemanager.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include websocketserver.h -o moc_websocketserver.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include tcpserver.h -o moc_tcpserver.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/sa01h-48g-v04-web/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sa01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1 -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/aarch64-linux-gnu -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/11.3.1/backward -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/lib/gcc/aarch64-linux-gnu/11.3.1/include-fixed -I/opt/gcc-linaro-11.3.1-2022.06-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include -I/usr/local/include -I/usr/include signalanalyzermanager.h -o moc_signalanalyzermanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o qrc_qml.o qrc_qml.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_serialportmanager.o moc_serialportmanager.cpp
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantMap:1,
                 from filemanager.h:7,
                 from filemanager.cpp:2:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qtextstream.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qdebug.h:49,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QDebug:1,
                 from terminalmanager.cpp:8:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/qjsengine.h:45,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/qqmlengine.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/qqmlapplicationengine.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/QQmlApplicationEngine:1,
                 from main.cpp:5:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qtextstream.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qdebug.h:49,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qabstractsocket.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qhostaddress.h:48,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qnetworkinterface.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/QNetworkInterface:1,
                 from netmanager.h:7,
                 from netmanager.cpp:2:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_pcievideoreciver.o moc_pcievideoreciver.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_netmanager.o moc_netmanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_terminalmanager.o moc_terminalmanager.cpp
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qtextstream.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qdebug.h:49,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qabstractsocket.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qhostaddress.h:48,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/QHostAddress:1,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets/qwebsocketserver.h:48,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets/QWebSocketServer:1,
                 from websocketserver.h:14,
                 from websocketserver.cpp:8:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantMap:1,
                 from serialportmanager.h:10,
                 from serialportmanager.cpp:2:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qtextstream.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qdebug.h:49,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qabstractsocket.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qtcpserver.h:45,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/QTcpServer:1,
                 from tcpserver.h:12,
                 from tcpserver.cpp:4:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantMap:1,
                 from pcievideoreciver.h:11,
                 from pcievideoreciver.cpp:1:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantList:1,
                 from signalanalyzermanager.h:6,
                 from signalanalyzermanager.cpp:1:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_filemanager.o moc_filemanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_websocketserver.o moc_websocketserver.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_tcpserver.o moc_tcpserver.cpp
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantMap:1,
                 from serialportmanager.h:10,
                 from moc_serialportmanager.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_CHARTS_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCharts -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWidgets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_signalanalyzermanager.o moc_signalanalyzermanager.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qtextstream.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qdebug.h:49,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qabstractsocket.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qhostaddress.h:48,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qnetworkinterface.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/QNetworkInterface:1,
                 from netmanager.h:7,
                 from moc_netmanager.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantMap:1,
                 from pcievideoreciver.h:11,
                 from moc_pcievideoreciver.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantMap:1,
                 from filemanager.h:7,
                 from moc_filemanager.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qtextstream.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qdebug.h:49,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qabstractsocket.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qhostaddress.h:48,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/QHostAddress:1,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets/qwebsocketserver.h:48,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets/QWebSocketServer:1,
                 from websocketserver.h:14,
                 from moc_websocketserver.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qtextstream.h:46,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qdebug.h:49,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qabstractsocket.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/qtcpserver.h:45,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork/QTcpServer:1,
                 from tcpserver.h:12,
                 from moc_tcpserver.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantList:1,
                 from signalanalyzermanager.h:6,
                 from moc_signalanalyzermanager.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
g++ -Wl,--allow-shlib-undefined -Wl,--no-as-needed -Wl,-rpath,/opt/Qt5.12.0/5.12.0/gcc_64/lib -o SA01H-48G-V04 main.o serialportmanager.o pcievideoreciver.o netmanager.o terminalmanager.o filemanager.o websocketserver.o tcpserver.o signalanalyzermanager.o qrc_qml.o moc_serialportmanager.o moc_pcievideoreciver.o moc_netmanager.o moc_terminalmanager.o moc_filemanager.o moc_websocketserver.o moc_tcpserver.o moc_signalanalyzermanager.o   -L/opt/Qt5.12.0/5.12.0/gcc_64/lib -lQt5Quick -lQt5Charts -lQt5Widgets -lQt5Gui -lQt5Qml -lQt5WebSockets -lQt5Network -lQt5SerialPort -lQt5Core -lGL -lpthread   
23:30:09: The process "/usr/bin/make" exited normally.
23:30:09: Elapsed time: 00:14.