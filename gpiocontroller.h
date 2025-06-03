/**
 * @file gpiocontroller.h
 * @brief GPIO控制器类头文件
 * 
 * 提供对RK3568 GPIO引脚的控制功能，支持引脚电平设置
 * 主要用于控制FPGA FLASH升级时的引脚状态
 */

#ifndef GPIOCONTROLLER_H
#define GPIOCONTROLLER_H

#include <QObject>
#include <QString>
#include <QMap>

/**
 * @class GpioController
 * @brief GPIO控制器类
 * 
 * 封装了RK3568 GPIO控制功能，提供引脚配置和电平控制接口
 * 支持通过sysfs接口控制GPIO引脚
 */
class GpioController : public QObject
{
    Q_OBJECT
    
    // 导出属性给QML使用
    Q_PROPERTY(bool fpgaFlashMode READ fpgaFlashMode WRITE setFpgaFlashMode NOTIFY fpgaFlashModeChanged)

public:
    /**
     * @brief 构造函数
     * @param parent 父对象指针
     */
    explicit GpioController(QObject *parent = nullptr);
    
    /**
     * @brief 析构函数
     */
    ~GpioController();

    /**
     * @brief 获取FPGA Flash升级模式状态
     * @return true表示处于升级模式，false表示正常模式
     */
    bool fpgaFlashMode() const;

    /**
     * @brief 设置FPGA Flash升级模式
     * @param mode true进入升级模式，false退出升级模式
     */
    void setFpgaFlashMode(bool mode);

    /**
     * @brief 初始化GPIO引脚
     * @return true表示初始化成功
     */
    Q_INVOKABLE bool initializeGpio();

    /**
     * @brief 进入FPGA Flash升级模式
     * @return true表示设置成功
     */
    Q_INVOKABLE bool enterFpgaFlashMode();

    /**
     * @brief 退出FPGA Flash升级模式
     * @return true表示设置成功
     */
    Q_INVOKABLE bool exitFpgaFlashMode();

    /**
     * @brief 设置单个GPIO引脚电平
     * @param gpioNum GPIO编号
     * @param value 电平值(0=低电平, 1=高电平)
     * @return true表示设置成功
     */
    Q_INVOKABLE bool setGpioValue(int gpioNum, int value);

    /**
     * @brief 获取单个GPIO引脚电平
     * @param gpioNum GPIO编号
     * @return 引脚电平值(-1表示读取失败)
     */
    Q_INVOKABLE int getGpioValue(int gpioNum);

signals:
    /**
     * @brief FPGA Flash模式状态变化信号
     */
    void fpgaFlashModeChanged();
    
    /**
     * @brief GPIO操作结果信号
     * @param success 操作是否成功
     * @param message 操作信息
     */
    void gpioOperationResult(bool success, const QString &message);

private slots:
    /**
     * @brief 系统命令执行完成处理
     */
    void onCommandFinished();

private:
    /**
     * @brief 导出GPIO引脚到sysfs
     * @param gpioNum GPIO编号
     * @return true表示导出成功
     */
    bool exportGpio(int gpioNum);

    /**
     * @brief 取消导出GPIO引脚
     * @param gpioNum GPIO编号
     * @return true表示取消导出成功
     */
    bool unexportGpio(int gpioNum);

    /**
     * @brief 设置GPIO引脚方向
     * @param gpioNum GPIO编号
     * @param direction 方向("in"或"out")
     * @return true表示设置成功
     */
    bool setGpioDirection(int gpioNum, const QString &direction);

    /**
     * @brief 执行系统命令
     * @param command 要执行的命令
     * @return 命令执行结果
     */
    QString executeCommand(const QString &command);

    /**
     * @brief 将引脚名称转换为GPIO编号
     * @param pinName 引脚名称(如"A21", "U3", "AF2")
     * @return GPIO编号
     */
    int pinNameToGpioNum(const QString &pinName);

private:
    bool m_fpgaFlashMode;           ///< FPGA Flash升级模式状态
    QMap<QString, int> m_pinMap;    ///< 引脚名称到GPIO编号的映射
    QList<int> m_exportedGpios;     ///< 已导出的GPIO列表
    
    // RK3568 FPGA Flash升级相关引脚定义
    static const int GPIO_A21 = 21;    // A21引脚 - 默认低电平，升级时需拉高
    static const int GPIO_U3 = 115;    // U3引脚  - 默认高电平，升级时需拉低  
    static const int GPIO_AF2 = 162;   // AF2引脚 - 默认开漏模式
};

#endif // GPIOCONTROLLER_H 