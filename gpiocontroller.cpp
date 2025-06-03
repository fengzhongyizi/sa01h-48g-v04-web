/**
 * @file gpiocontroller.cpp
 * @brief GPIO控制器实现文件
 * 
 * 实现RK3568 GPIO控制功能，主要用于FPGA Flash升级时的引脚控制
 */

#include "gpiocontroller.h"
#include <QProcess>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QDir>

/**
 * @brief 构造函数
 * @param parent 父对象指针
 */
GpioController::GpioController(QObject *parent)
    : QObject(parent)
    , m_fpgaFlashMode(false)
{
    // 初始化引脚映射表
    // 注意：这些GPIO编号需要根据实际的RK3568引脚定义来确定
    m_pinMap["A21"] = GPIO_A21;
    m_pinMap["U3"] = GPIO_U3;
    m_pinMap["AF2"] = GPIO_AF2;
    
    qDebug() << "GpioController initialized";
}

/**
 * @brief 析构函数
 */
GpioController::~GpioController()
{
    // 清理所有已导出的GPIO
    for (int gpio : m_exportedGpios) {
        unexportGpio(gpio);
    }
    qDebug() << "GpioController destroyed";
}

/**
 * @brief 获取FPGA Flash升级模式状态
 */
bool GpioController::fpgaFlashMode() const
{
    return m_fpgaFlashMode;
}

/**
 * @brief 设置FPGA Flash升级模式
 */
void GpioController::setFpgaFlashMode(bool mode)
{
    if (m_fpgaFlashMode != mode) {
        m_fpgaFlashMode = mode;
        
        if (mode) {
            enterFpgaFlashMode();
        } else {
            exitFpgaFlashMode();
        }
        
        emit fpgaFlashModeChanged();
    }
}

/**
 * @brief 初始化GPIO引脚
 */
bool GpioController::initializeGpio()
{
    qDebug() << "Initializing GPIO pins for FPGA Flash control";
    
    bool success = true;
    
    // 导出所需的GPIO引脚
    if (!exportGpio(GPIO_A21)) {
        qWarning() << "Failed to export GPIO_A21";
        success = false;
    }
    
    if (!exportGpio(GPIO_U3)) {
        qWarning() << "Failed to export GPIO_U3";
        success = false;
    }
    
    if (!exportGpio(GPIO_AF2)) {
        qWarning() << "Failed to export GPIO_AF2";
        success = false;
    }
    
    // 设置GPIO方向为输出
    if (success) {
        setGpioDirection(GPIO_A21, "out");
        setGpioDirection(GPIO_U3, "out");
        setGpioDirection(GPIO_AF2, "out");
        
        // 设置初始状态
        exitFpgaFlashMode();
    }
    
    QString message = success ? "GPIO初始化成功" : "GPIO初始化失败";
    emit gpioOperationResult(success, message);
    
    return success;
}

/**
 * @brief 进入FPGA Flash升级模式
 */
bool GpioController::enterFpgaFlashMode()
{
    qDebug() << "Entering FPGA Flash upgrade mode";
    
    bool success = true;
    
    // A21引脚：默认低电平，升级时拉高
    if (!setGpioValue(GPIO_A21, 1)) {
        qWarning() << "Failed to set A21 high";
        success = false;
    }
    
    // U3引脚：默认高电平，升级时拉低
    if (!setGpioValue(GPIO_U3, 0)) {
        qWarning() << "Failed to set U3 low";
        success = false;
    }
    
    // AF2引脚：开漏模式，这里设置为低电平
    if (!setGpioValue(GPIO_AF2, 0)) {
        qWarning() << "Failed to set AF2 low";
        success = false;
    }
    
    QString message = success ? "已进入FPGA Flash升级模式" : "进入FPGA Flash升级模式失败";
    emit gpioOperationResult(success, message);
    
    if (success) {
        qDebug() << "FPGA Flash upgrade mode activated";
        qDebug() << "A21: HIGH, U3: LOW, AF2: LOW";
    }
    
    return success;
}

/**
 * @brief 退出FPGA Flash升级模式
 */
bool GpioController::exitFpgaFlashMode()
{
    qDebug() << "Exiting FPGA Flash upgrade mode";
    
    bool success = true;
    
    // A21引脚：恢复默认低电平
    if (!setGpioValue(GPIO_A21, 0)) {
        qWarning() << "Failed to set A21 low";
        success = false;
    }
    
    // U3引脚：恢复默认高电平
    if (!setGpioValue(GPIO_U3, 1)) {
        qWarning() << "Failed to set U3 high";
        success = false;
    }
    
    // AF2引脚：设置为高阻抗状态（开漏模式）
    if (!setGpioValue(GPIO_AF2, 1)) {
        qWarning() << "Failed to set AF2 high-Z";
        success = false;
    }
    
    QString message = success ? "已退出FPGA Flash升级模式" : "退出FPGA Flash升级模式失败";
    emit gpioOperationResult(success, message);
    
    if (success) {
        qDebug() << "FPGA Flash normal mode restored";
        qDebug() << "A21: LOW, U3: HIGH, AF2: HIGH-Z";
    }
    
    return success;
}

/**
 * @brief 设置单个GPIO引脚电平
 */
bool GpioController::setGpioValue(int gpioNum, int value)
{
    QString valuePath = QString("/sys/class/gpio/gpio%1/value").arg(gpioNum);
    
    QFile file(valuePath);
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open" << valuePath << "for writing";
        return false;
    }
    
    QTextStream stream(&file);
    stream << value;
    file.close();
    
    qDebug() << QString("Set GPIO%1 = %2").arg(gpioNum).arg(value);
    return true;
}

/**
 * @brief 获取单个GPIO引脚电平
 */
int GpioController::getGpioValue(int gpioNum)
{
    QString valuePath = QString("/sys/class/gpio/gpio%1/value").arg(gpioNum);
    
    QFile file(valuePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open" << valuePath << "for reading";
        return -1;
    }
    
    QTextStream stream(&file);
    QString valueStr = stream.readLine();
    file.close();
    
    bool ok;
    int value = valueStr.toInt(&ok);
    if (!ok) {
        qWarning() << "Failed to parse GPIO value:" << valueStr;
        return -1;
    }
    
    return value;
}

/**
 * @brief 导出GPIO引脚到sysfs
 */
bool GpioController::exportGpio(int gpioNum)
{
    // 检查GPIO是否已经导出
    QString gpioPath = QString("/sys/class/gpio/gpio%1").arg(gpioNum);
    if (QDir(gpioPath).exists()) {
        qDebug() << QString("GPIO%1 already exported").arg(gpioNum);
        if (!m_exportedGpios.contains(gpioNum)) {
            m_exportedGpios.append(gpioNum);
        }
        return true;
    }
    
    QFile file("/sys/class/gpio/export");
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open /sys/class/gpio/export for writing";
        return false;
    }
    
    QTextStream stream(&file);
    stream << gpioNum;
    file.close();
    
    // 等待一小段时间确保导出完成
    QProcess::execute("sleep", QStringList() << "0.1");
    
    // 验证导出是否成功
    if (QDir(gpioPath).exists()) {
        qDebug() << QString("Successfully exported GPIO%1").arg(gpioNum);
        m_exportedGpios.append(gpioNum);
        return true;
    } else {
        qWarning() << QString("Failed to export GPIO%1").arg(gpioNum);
        return false;
    }
}

/**
 * @brief 取消导出GPIO引脚
 */
bool GpioController::unexportGpio(int gpioNum)
{
    QString gpioPath = QString("/sys/class/gpio/gpio%1").arg(gpioNum);
    if (!QDir(gpioPath).exists()) {
        qDebug() << QString("GPIO%1 is not exported").arg(gpioNum);
        return true;
    }
    
    QFile file("/sys/class/gpio/unexport");
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open /sys/class/gpio/unexport for writing";
        return false;
    }
    
    QTextStream stream(&file);
    stream << gpioNum;
    file.close();
    
    m_exportedGpios.removeAll(gpioNum);
    qDebug() << QString("Successfully unexported GPIO%1").arg(gpioNum);
    return true;
}

/**
 * @brief 设置GPIO引脚方向
 */
bool GpioController::setGpioDirection(int gpioNum, const QString &direction)
{
    QString directionPath = QString("/sys/class/gpio/gpio%1/direction").arg(gpioNum);
    
    QFile file(directionPath);
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open" << directionPath << "for writing";
        return false;
    }
    
    QTextStream stream(&file);
    stream << direction;
    file.close();
    
    qDebug() << QString("Set GPIO%1 direction to %2").arg(gpioNum).arg(direction);
    return true;
}

/**
 * @brief 执行系统命令
 */
QString GpioController::executeCommand(const QString &command)
{
    QProcess process;
    process.start("sh", QStringList() << "-c" << command);
    process.waitForFinished();
    
    if (process.exitStatus() == QProcess::NormalExit && process.exitCode() == 0) {
        return process.readAllStandardOutput();
    } else {
        qWarning() << "Command failed:" << command;
        qWarning() << "Error:" << process.readAllStandardError();
        return QString();
    }
}

/**
 * @brief 将引脚名称转换为GPIO编号
 */
int GpioController::pinNameToGpioNum(const QString &pinName)
{
    return m_pinMap.value(pinName, -1);
}

/**
 * @brief 系统命令执行完成处理
 */
void GpioController::onCommandFinished()
{
    // 预留用于处理异步命令完成
    qDebug() << "Command finished";
} 