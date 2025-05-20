#include "filemanager.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

FileManager::FileManager(QObject* parent) : QObject(parent), m_filePath("/userdata/gate.conf") {}

QString FileManager::filePath() const {
    return m_filePath;
}

void FileManager::setFilePath(const QString& path) {
    if (m_filePath != path) {
        m_filePath = path;
        emit filePathChanged();
    }
}

void FileManager::saveData(const QVariantMap& data) {
    QFile file(m_filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for writing:" << m_filePath;
        return;
    }

    QTextStream out(&file);
    for (auto it = data.constBegin(); it != data.constEnd(); ++it) {
        out << it.key() << "=" << it.value().toString() << "\n";
    }

    file.close();
    qDebug() << "Data saved to file:" << m_filePath;
}

QVariantMap FileManager::loadData() {
    QVariantMap data;
    QFile file(m_filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for reading:" << m_filePath;
        return data;
    }

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty() || line.startsWith("#")) {
            continue;
        }

        QStringList parts = line.split("=");
        if (parts.size() == 2) {
            data[parts[0].trimmed()] = parts[1].trimmed();
        }
    }

    file.close();
    return data;
}

void FileManager::updateData(const QString& key, const QString& value) {
    QVariantMap data = loadData();
    data[key] = value;

    saveData(data);
}

QString FileManager::getValue(const QString& key) {
    QVariantMap data = loadData();

    return data.value(key).toString();
}



