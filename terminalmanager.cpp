#include "terminalmanager.h"
#include <QDebug>

TerminalManager::TerminalManager(QObject* parent)
    : QObject(parent), m_commandOutput("") {
}

QString TerminalManager::commandOutput() const {
    return m_commandOutput;
}

void TerminalManager::executeCommand(const QString& command) {
    m_process.start("sh", QStringList() << "-c" << command);
    m_process.waitForFinished();

    if (m_process.exitStatus() == QProcess::NormalExit && m_process.exitCode() == 0) {
        m_commandOutput = m_process.readAllStandardOutput();
        qDebug() << "Command executed successfully.";
    } else {
        m_commandOutput = m_process.readAllStandardError();
        qDebug() << "Failed to execute command:" << m_commandOutput;
    }

    emit commandOutputChanged(m_commandOutput);
}
