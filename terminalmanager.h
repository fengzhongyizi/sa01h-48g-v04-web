/**
 * @file terminalmanager.h
 * @brief 终端管理器类头文件
 * 
 * 提供执行终端命令并获取命令输出的功能，
 * 可从QML/C++双向调用，实现系统命令执行与UI交互。
 */

#ifndef TERMINALMANAGER_H
#define TERMINALMANAGER_H

#include <QObject>      // 提供Qt对象基类
#include <QProcess>     // 提供进程执行功能
#include <QString>      // 字符串处理

/**
 * @class TerminalManager
 * @brief 终端管理器类
 * 
 * 封装了终端命令执行功能，提供命令执行和结果获取接口。
 * 通过Q_PROPERTY导出属性到QML，使界面可以直接绑定命令执行结果。
 */
class TerminalManager : public QObject {
    Q_OBJECT  // Qt元对象宏，启用信号槽和属性机制
    
    /**
     * @property commandOutput
     * @brief 命令输出属性
     * 
     * 导出命令执行的输出结果给QML
     * - READ: 通过commandOutput()方法读取
     * - NOTIFY: 通过commandOutputChanged信号通知变化
     */
    Q_PROPERTY(QString commandOutput READ commandOutput NOTIFY commandOutputChanged)

public:
    /**
     * @brief 构造函数
     * @param parent 父对象指针，用于Qt对象树管理
     * 
     * 创建终端管理器实例，初始化命令输出为空
     */
    explicit TerminalManager(QObject* parent = nullptr);

    /**
     * @brief 获取命令输出
     * @return 命令执行的输出文本
     * 
     * 用于获取最近一次执行命令的输出结果
     */
    QString commandOutput() const;

    /**
     * @brief 执行终端命令
     * @param command 要执行的命令字符串
     * 
     * 使用Q_INVOKABLE修饰，使其可从QML中调用
     * 执行指定的shell命令，并在完成后更新commandOutput属性
     */
    Q_INVOKABLE void executeCommand(const QString& command);

signals:
    /**
     * @brief 命令输出变化信号
     * @param output 新的命令输出内容
     * 
     * 当命令执行完成并且输出结果变化时发出此信号
     * 用于通知QML界面更新绑定的输出内容
     */
    void commandOutputChanged(const QString& output);

private:
    /**
     * @brief 命令输出缓存
     * 
     * 存储最近一次执行命令的输出结果
     */
    QString m_commandOutput;
    
    /**
     * @brief 进程对象
     * 
     * 用于执行外部命令的QProcess实例
     */
    QProcess m_process;
};

#endif // TERMINALMANAGER_H