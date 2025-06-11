09:14:15: Running steps for project SG01H-48G-V04...
09:14:15: Configuration unchanged, skipping qmake step.
09:14:15: Starting: "/usr/bin/make" -j12
/opt/Qt5.12.0/5.12.0/gcc_64/bin/qmake -o Makefile ../sg01h-48g-v04-web/SG01H-48G-V04.pro -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I../sg01h-48g-v04-web -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o main.o ../sg01h-48g-v04-web/main.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I../sg01h-48g-v04-web -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o signalanalyzermanager.o ../sg01h-48g-v04-web/signalanalyzermanager.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/rcc -name qml ../sg01h-48g-v04-web/qml.qrc -o qrc_qml.cpp
/opt/Qt5.12.0/5.12.0/gcc_64/bin/moc -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB --include /root/SA/build-SG01H-48G-V04-Desktop_Qt_5_12_0_GCC_64bit-Debug/moc_predefs.h -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -I/root/SA/sg01h-48g-v04-web -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -I/usr/include/c++/11 -I/usr/include/x86_64-linux-gnu/c++/11 -I/usr/include/c++/11/backward -I/usr/lib/gcc/x86_64-linux-gnu/11/include -I/usr/local/include -I/usr/include/x86_64-linux-gnu -I/usr/include ../sg01h-48g-v04-web/signalanalyzermanager.h -o moc_signalanalyzermanager.cpp
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I../sg01h-48g-v04-web -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o moc_signalanalyzermanager.o moc_signalanalyzermanager.cpp
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qlocale.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui/qguiapplication.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui/QGuiApplication:1,
                 from ../sg01h-48g-v04-web/main.cpp:1:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantList:1,
                 from ../sg01h-48g-v04-web/signalanalyzermanager.h:6,
                 from ../sg01h-48g-v04-web/signalanalyzermanager.cpp:1:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
g++ -c -pipe -g -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_QML_DEBUG -DQT_QUICK_LIB -DQT_GUI_LIB -DQT_QML_LIB -DQT_WEBSOCKETS_LIB -DQT_NETWORK_LIB -DQT_SERIALPORT_LIB -DQT_CORE_LIB -I../sg01h-48g-v04-web -I. -I/opt/Qt5.12.0/5.12.0/gcc_64/include -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQuick -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtGui -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtWebSockets -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtNetwork -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtSerialPort -I/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I/opt/Qt5.12.0/5.12.0/gcc_64/mkspecs/linux-g++ -o qrc_qml.o qrc_qml.cpp
In file included from ../sg01h-48g-v04-web/signalanalyzermanager.cpp:1:
../sg01h-48g-v04-web/signalanalyzermanager.h: In constructor ‘SignalAnalyzerManager::SignalAnalyzerManager(SerialPortManager*, QObject*)’:
../sg01h-48g-v04-web/signalanalyzermanager.h:197:24: warning: ‘SignalAnalyzerManager::m_serialPortManager’ will be initialized after [-Wreorder]
  197 |     SerialPortManager* m_serialPortManager;
      |                        ^~~~~~~~~~~~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.h:171:13: warning:   ‘QString SignalAnalyzerManager::m_frameUrl’ [-Wreorder]
  171 |     QString m_frameUrl;
      |             ^~~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp:8:1: warning:   when initialized here [-Wreorder]
    8 | SignalAnalyzerManager::SignalAnalyzerManager(SerialPortManager* spMgr, QObject* parent)
      | ^~~~~~~~~~~~~~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp: In member function ‘void SignalAnalyzerManager::updateInfo(const QString&, const QString&, const QString&, const QString&, const QString&, const QString&, const QString&, const QString&)’:
../sg01h-48g-v04-web/signalanalyzermanager.cpp:188:10: warning: variable ‘changed’ set but not used [-Wunused-but-set-variable]
  188 |     bool changed = false;
      |          ^~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp: In member function ‘void SignalAnalyzerManager::updateMonitorData(const QStringList&, const QList<QPointF>&)’:
../sg01h-48g-v04-web/signalanalyzermanager.cpp:251:66: warning: unused parameter ‘slotLabels’ [-Wunused-parameter]
  251 | void SignalAnalyzerManager::updateMonitorData(const QStringList &slotLabels, const QList<QPointF> &data)
      |                                               ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp:251:100: warning: unused parameter ‘data’ [-Wunused-parameter]
  251 | void SignalAnalyzerManager::updateMonitorData(const QStringList &slotLabels, const QList<QPointF> &data)
      |                                                                              ~~~~~~~~~~~~~~~~~~~~~~^~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp: In member function ‘void SignalAnalyzerManager::processMonitorCommand(const QByteArray&)’:
../sg01h-48g-v04-web/signalanalyzermanager.cpp:271:69: warning: unused parameter ‘data’ [-Wunused-parameter]
  271 | void SignalAnalyzerManager::processMonitorCommand(const QByteArray &data)
      |                                                   ~~~~~~~~~~~~~~~~~~^~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp: In member function ‘void SignalAnalyzerManager::updateSlotData(const QString&, const QString&)’:
../sg01h-48g-v04-web/signalanalyzermanager.cpp:276:59: warning: unused parameter ‘slotId’ [-Wunused-parameter]
  276 | void SignalAnalyzerManager::updateSlotData(const QString &slotId, const QString &stateStr)
      |                                            ~~~~~~~~~~~~~~~^~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp:276:82: warning: unused parameter ‘stateStr’ [-Wunused-parameter]
  276 | void SignalAnalyzerManager::updateSlotData(const QString &slotId, const QString &stateStr)
      |                                                                   ~~~~~~~~~~~~~~~^~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp: In member function ‘void SignalAnalyzerManager::updateSlotError(const QString&, int, int)’:
../sg01h-48g-v04-web/signalanalyzermanager.cpp:281:60: warning: unused parameter ‘slotId’ [-Wunused-parameter]
  281 | void SignalAnalyzerManager::updateSlotError(const QString &slotId, int slotIndex, int statusValue)
      |                                             ~~~~~~~~~~~~~~~^~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp:281:72: warning: unused parameter ‘slotIndex’ [-Wunused-parameter]
  281 | void SignalAnalyzerManager::updateSlotError(const QString &slotId, int slotIndex, int statusValue)
      |                                                                    ~~~~^~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp:281:87: warning: unused parameter ‘statusValue’ [-Wunused-parameter]
  281 | void SignalAnalyzerManager::updateSlotError(const QString &slotId, int slotIndex, int statusValue)
      |                                                                                   ~~~~^~~~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp: In member function ‘bool SignalAnalyzerManager::detectTriggerEvent(const QByteArray&, const QByteArray&)’:
../sg01h-48g-v04-web/signalanalyzermanager.cpp:291:66: warning: unused parameter ‘currentFrame’ [-Wunused-parameter]
  291 | bool SignalAnalyzerManager::detectTriggerEvent(const QByteArray &currentFrame, const QByteArray &previousFrame)
      |                                                ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp:291:98: warning: unused parameter ‘previousFrame’ [-Wunused-parameter]
  291 | bool SignalAnalyzerManager::detectTriggerEvent(const QByteArray &currentFrame, const QByteArray &previousFrame)
      |                                                                                ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
../sg01h-48g-v04-web/signalanalyzermanager.cpp: In member function ‘bool SignalAnalyzerManager::isSignalLost(const QByteArray&)’:
../sg01h-48g-v04-web/signalanalyzermanager.cpp:297:60: warning: unused parameter ‘frame’ [-Wunused-parameter]
  297 | bool SignalAnalyzerManager::isSignalLost(const QByteArray &frame)
      |                                          ~~~~~~~~~~~~~~~~~~^~~~~
../sg01h-48g-v04-web/main.cpp: In function ‘int main(int, char**)’:
../sg01h-48g-v04-web/main.cpp:35:25: error: invalid use of incomplete type ‘class QQmlContext’
   35 |     engine.rootContext()->setContextProperty("signalAnalyzerManager", saMgr);
      |                         ^~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/qqmlengine.h:47,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/qqmlapplicationengine.h:43,
                 from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/QQmlApplicationEngine:1,
                 from ../sg01h-48g-v04-web/main.cpp:2:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtQml/qqml.h:570:7: note: forward declaration of ‘class QQmlContext’
  570 | class QQmlContext;
      |       ^~~~~~~~~~~
In file included from /opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/QVariantList:1,
                 from ../sg01h-48g-v04-web/signalanalyzermanager.h:6,
                 from moc_signalanalyzermanager.cpp:9:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h: In constructor ‘QVariant::QVariant(QVariant&&)’:
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:273:25: warning: implicitly-declared ‘QVariant::Private& QVariant::Private::operator=(const QVariant::Private&)’ is deprecated [-Wdeprecated-copy]
  273 |     { other.d = Private(); }
      |                         ^
/opt/Qt5.12.0/5.12.0/gcc_64/include/QtCore/qvariant.h:399:16: note: because ‘QVariant::Private’ has user-provided ‘QVariant::Private::Private(const QVariant::Private&)’
  399 |         inline Private(const Private &other) Q_DECL_NOTHROW
      |                ^~~~~~~
make: *** [Makefile:2302: main.o] Error 1
make: *** Waiting for unfinished jobs....
09:14:23: The process "/usr/bin/make" exited with code 2.
Error while building/deploying project SG01H-48G-V04 (kit: Desktop Qt 5.12.0 GCC 64bit)
When executing step "Make"
09:14:23: Elapsed time: 00:07.