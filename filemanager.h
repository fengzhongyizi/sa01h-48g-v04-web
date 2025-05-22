// 防止头文件重复包含的宏定义保护
#ifndef FILEMANAGER_H
#define FILEMANAGER_H

// 引入必要的Qt头文件
#include <QObject>       // 提供Qt对象系统的基础类
#include <QVariantMap>   // 提供键值对容器，类似于字典
#include <QString>       // 提供字符串处理功能

// FileManager类定义
// 用于管理配置文件的读写操作，提供简单的键值对存储功能
class FileManager : public QObject {
    Q_OBJECT    // Qt元对象宏，启用信号槽机制、属性系统等Qt特性
    
    // Qt属性定义，使filePath在QML中可以直接访问和修改
    // READ指定读取方法，WRITE指定写入方法，NOTIFY指定值变化时发出的信号
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)

public:
    // 构造函数
    // parent: 父对象指针，用于Qt对象树管理，默认为nullptr
    explicit FileManager(QObject* parent = nullptr);

    // 获取当前配置文件路径
    // 返回值: 配置文件的完整路径
    QString filePath() const;
    
    // 设置新的配置文件路径
    // path: 新的配置文件路径
    void setFilePath(const QString& path);

    // 将数据保存到配置文件
    // Q_INVOKABLE宏使此方法可以从QML中直接调用
    // data: 要保存的键值对数据
    Q_INVOKABLE void saveData(const QVariantMap& data);
    
    // 从配置文件加载数据
    // 返回值: 包含所有配置项的键值对映射
    Q_INVOKABLE QVariantMap loadData();
    
    // 更新配置文件中特定键的值
    // key: 要更新的键名
    // value: 要设置的新值
    Q_INVOKABLE void updateData(const QString& key, const QString& value);
    
    // 获取配置文件中特定键的值
    // key: 要获取的键名
    // 返回值: 键对应的值，如果键不存在则返回空字符串
    Q_INVOKABLE QString getValue(const QString& key);

signals:
    // 当配置文件路径变化时发出的信号
    // 用于通知属性监听器路径已更改
    void filePathChanged();

private:
    // 存储当前配置文件的路径
    QString m_filePath;
};

#endif // FILEMANAGER_H