#ifndef TERMINALMANAGER_H
#define TERMINALMANAGER_H

#include <QObject>
#include <QProcess>
#include <QString>

class TerminalManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString commandOutput READ commandOutput NOTIFY commandOutputChanged)

public:
    explicit TerminalManager(QObject* parent = nullptr);

    QString commandOutput() const;

    Q_INVOKABLE void executeCommand(const QString& command);
    Q_INVOKABLE void executeDetachedCommand(const QString& command);


signals:
    void commandOutputChanged(const QString& output);
    void progressUpdated(int percent);

private slots:
    void onProcessOutputReady();

private:
    QString m_commandOutput;
    QProcess m_process;
};

#endif // TERMINALMANAGER_H
