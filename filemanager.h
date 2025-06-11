#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QVariantMap>
#include <QString>
#include <QFile>

class FileManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)

public:
    explicit FileManager(QObject* parent = nullptr);

    QString filePath() const;
    void setFilePath(const QString& path);

    Q_INVOKABLE void saveData(const QVariantMap& data);
    Q_INVOKABLE QVariantMap loadData();
    Q_INVOKABLE void updateData(const QString& key, const QString& value);
    Q_INVOKABLE QString getValue(const QString& key);
    Q_INVOKABLE QByteArray readBinaryFile(const QString &filePath);
    Q_INVOKABLE quint32 getFileSize(const QString &filePath);

signals:
    void filePathChanged();

private:
    QString m_filePath;
};

#endif // FILEMANAGER_H
