// 引入必要的头文件
#include "filemanager.h"     // FileManager类的声明头文件
#include <QFile>             // 提供文件操作功能
#include <QTextStream>       // 提供文本流处理功能，用于读写文本文件
#include <QDebug>            // 提供调试输出功能

// FileManager构造函数
// 创建一个文件管理器实例，默认配置文件路径设置为"/userdata/gate.conf"
// parent: 父对象指针，用于Qt对象树管理
FileManager::FileManager(QObject* parent) : QObject(parent), m_filePath("/userdata/gate.conf") {}

// 获取当前配置文件路径
// 返回值: 当前配置文件的完整路径字符串
QString FileManager::filePath() const {
    return m_filePath;
}

// 设置新的配置文件路径
// path: 新的配置文件路径
// 如果路径发生变化，会触发filePathChanged信号
void FileManager::setFilePath(const QString& path) {
    if (m_filePath != path) {
        m_filePath = path;
        emit filePathChanged();
    }
}

// 保存数据到配置文件
// data: 包含键值对的QVariantMap，将被写入到配置文件
// 以"键=值"的格式逐行保存每个键值对
// 注意：如果文件无法打开则会输出警告日志但不会抛出异常
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

// 从配置文件加载数据
// 返回值: QVariantMap，包含文件中读取的所有键值对
// 每行按"键=值"格式解析，忽略空行和以#开头的注释行
// 如果文件无法打开，返回空的QVariantMap对象
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
            continue;  // 跳过空行和注释行
        }

        QStringList parts = line.split("=");
        if (parts.size() == 2) {
            data[parts[0].trimmed()] = parts[1].trimmed();
        }
    }

    file.close();
    return data;
}

// 更新配置文件中特定键的值
// key: 要更新的键名
// value: 要设置的新值
// 先加载现有配置，更新指定键的值，然后保存整个配置文件
void FileManager::updateData(const QString& key, const QString& value) {
    QVariantMap data = loadData();
    data[key] = value;

    saveData(data);
}

// 获取配置文件中特定键的值
// key: 要获取的键名
// 返回值: 键对应的值，如果键不存在则返回空字符串
QString FileManager::getValue(const QString& key) {
    QVariantMap data = loadData();

    return data.value(key).toString();
}