#include "terminalmanager.h"
#include <QDebug>

TerminalManager::TerminalManager(QObject* parent)
    : QObject(parent), m_commandOutput("") {
    connect(&m_process, &QProcess::readyReadStandardOutput, this, &TerminalManager::onProcessOutputReady);
    connect(&m_process, &QProcess::readyReadStandardError, this, &TerminalManager::onProcessOutputReady);
}

QString TerminalManager::commandOutput() const {
    return m_commandOutput;
}

void TerminalManager::executeCommand(const QString& command) {


    m_process.start("sh", QStringList() << "-c" << command);
    m_process.waitForFinished();

    if (m_process.exitStatus() == QProcess::NormalExit && m_process.exitCode() == 0) {
        m_commandOutput = m_process.readAllStandardOutput();
        qDebug() << "Command executed successfully:"<<command;
    } else {
        m_commandOutput = m_process.readAllStandardError();
        qDebug() << "Failed to execute command:" << m_commandOutput;
    }

    emit commandOutputChanged(m_commandOutput);
}

void TerminalManager::executeDetachedCommand(const QString& command) {
    bool success = QProcess::startDetached("sh", QStringList() << "-c" << command);
    if (success) {
        qDebug() << "Detached command started successfully:" << command;
    } else {
        qDebug() << "Failed to start detached command:" << command;
    }
}

void TerminalManager::onProcessOutputReady() {

    QString output = m_process.readAllStandardOutput() + m_process.readAllStandardError();
    m_commandOutput += output;

    QStringList lines = output.split("\r\n");
    for (const QString &line : lines) {
        emit commandOutputChanged(line);
    }

}

