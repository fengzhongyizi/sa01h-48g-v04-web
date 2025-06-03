# FPGA Flash升级GPIO控制功能说明

## 概述

该功能为RK3568+XCKU5P方案的48G HDMI信号分析仪提供了通过QT应用控制GPIO引脚来实现FPGA Flash升级的功能。

## 硬件背景

根据系统设计要求：
- **A21引脚**：上电默认低电平，需要给FPGA的FLASH升级时拉高
- **U3引脚**：上电默认高电平，需要给FPGA的FLASH升级时拉低
- **AF2引脚**：上电默认开漏(OD)模式

## 功能特性

### 1. GPIO控制器类 (`GpioController`)
- 封装了RK3568 GPIO控制功能
- 通过Linux sysfs接口操作GPIO引脚
- 提供FPGA Flash升级模式的进入和退出功能
- 支持QML界面直接调用

### 2. 主要方法
- `initializeGpio()`: 初始化GPIO引脚，导出到sysfs
- `enterFpgaFlashMode()`: 进入FPGA Flash升级模式
- `exitFpgaFlashMode()`: 退出FPGA Flash升级模式  
- `setGpioValue(int gpioNum, int value)`: 设置单个GPIO引脚电平
- `getGpioValue(int gpioNum)`: 读取单个GPIO引脚电平

### 3. UI界面
在System Setup页面中新增了"FPGA Control"选项卡，包含：
- 实时状态显示（当前模式和引脚状态）
- 进入升级模式按钮
- 退出升级模式按钮
- 详细的使用说明

## 使用方法

### 1. 进入FPGA Flash升级模式
1. 打开应用程序
2. 进入"System Setup"页面
3. 点击"FPGA Control"选项卡
4. 点击"进入升级模式"按钮
5. 确认状态显示为"FPGA Flash升级模式"

### 2. 执行FPGA升级
在升级模式下，GPIO引脚状态如下：
- A21: HIGH (高电平)
- U3: LOW (低电平)  
- AF2: LOW (低电平)

此时可以通过其他工具或接口对FPGA进行Flash升级操作。

### 3. 退出升级模式
1. FPGA升级完成后
2. 点击"退出升级模式"按钮
3. 确认状态显示为"正常工作模式"

退出升级模式后，GPIO引脚恢复正常状态：
- A21: LOW (低电平)
- U3: HIGH (高电平)
- AF2: HIGH-Z (高阻状态)

## 技术实现

### 1. GPIO编号映射
```cpp
static const int GPIO_A21 = 21;    // A21引脚
static const int GPIO_U3 = 115;    // U3引脚  
static const int GPIO_AF2 = 162;   // AF2引脚
```

**注意**: 这些GPIO编号是示例值，实际使用时需要根据RK3568的具体引脚定义进行调整。

### 2. Linux sysfs操作
通过标准的Linux GPIO sysfs接口操作引脚：
```bash
# 导出GPIO
echo <gpio_num> > /sys/class/gpio/export

# 设置方向为输出
echo "out" > /sys/class/gpio/gpio<gpio_num>/direction

# 设置电平
echo <value> > /sys/class/gpio/gpio<gpio_num>/value
```

### 3. QML集成
GPIO控制器作为全局对象暴露给QML：
```cpp
engine.rootContext()->setContextProperty("gpioController", gpioCtrl);
```

## 安全注意事项

1. **权限要求**: GPIO操作需要root权限或适当的用户组权限
2. **升级完成后必须退出**: 升级完成后务必点击"退出升级模式"按钮
3. **状态确认**: 每次操作后都要确认状态显示正确
4. **GPIO编号验证**: 使用前请验证GPIO编号是否与硬件设计一致

## 调试信息

应用程序会在控制台输出详细的调试信息：
```
GpioController initialized
Initializing GPIO pins for FPGA Flash control
Successfully exported GPIO21
Set GPIO21 direction to out
Entering FPGA Flash upgrade mode
Set GPIO21 = 1
Set GPIO115 = 0
Set GPIO162 = 0
FPGA Flash upgrade mode activated
A21: HIGH, U3: LOW, AF2: LOW
```

## 故障排除

### 1. GPIO操作失败
- 检查应用程序是否以足够的权限运行
- 验证GPIO编号是否正确
- 确认系统支持GPIO sysfs接口

### 2. 界面无响应
- 检查QML中gpioController对象是否正确绑定
- 查看控制台输出的错误信息

### 3. FPGA升级失败
- 确认已正确进入升级模式
- 检查升级工具和接口配置
- 验证FPGA升级文件完整性

## 文件列表

- `gpiocontroller.h`: GPIO控制器头文件
- `gpiocontroller.cpp`: GPIO控制器实现文件
- `SystemSetupPanel.qml`: 系统设置界面(已修改)
- `main.cpp`: 主程序文件(已修改)
- `SA01H-48G-V04.pro`: 项目文件(已修改)

## 版本信息

- 初始版本: v1.0
- 适用硬件: RK3568 + XCKU5P
- QT版本: 5.12+
- 操作系统: Linux 