/**
 * @file terminalmanager.cpp
 * @brief 终端管理器实现文件
 * 负责执行终端命令和处理命令输出
 */

#include "terminalmanager.h"
#include <QDebug>

/**
 * @brief 构造函数 - 创建终端管理器实例
 * @param parent 父对象指针，用于Qt对象树管理
 * 初始化命令输出为空字符串
 */
TerminalManager::TerminalManager(QObject* parent)
    : QObject(parent), m_commandOutput("") {
}

/**
 * @brief 获取最近命令的输出结果
 * @return 命令执行的输出文本
 * 用于获取执行命令后的输出结果，供外部调用
 */
QString TerminalManager::commandOutput() const {
    return m_commandOutput;
}

/**
 * @brief 执行终端命令
 * @param command 要执行的命令字符串
 * 
 * 使用shell环境执行指定的命令，等待命令完成，
 * 并更新命令输出结果。成功执行后会发出commandOutputChanged信号。
 */
void TerminalManager::executeCommand(const QString& command) {
    // 使用sh作为shell程序执行命令
    m_process.start("sh", QStringList() << "-c" << command);
    // 阻塞等待命令执行完成
    m_process.waitForFinished();

    // 检查命令执行状态
    if (m_process.exitStatus() == QProcess::NormalExit && m_process.exitCode() == 0) {
        // 命令成功执行，获取标准输出
        m_commandOutput = m_process.readAllStandardOutput();
        qDebug() << "Command executed successfully.";
    } else {
        // 命令执行失败，获取错误输出
        m_commandOutput = m_process.readAllStandardError();
        qDebug() << "Failed to execute command:" << m_commandOutput;
    }

    // 发送信号通知命令输出已更新
    emit commandOutputChanged(m_commandOutput);
}