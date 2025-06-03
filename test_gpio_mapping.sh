#!/bin/bash

# RK3568 GPIO引脚测试脚本
# 用于确定A21、U3、AF2引脚对应的GPIO编号

echo "========================================"
echo "RK3568 GPIO引脚映射测试脚本"
echo "========================================"

# 显示可用的GPIO信息
echo "1. 检查GPIO子系统信息："
if [ -d "/sys/class/gpio" ]; then
    echo "GPIO sysfs接口可用"
    ls -la /sys/class/gpio/
else
    echo "GPIO sysfs接口不可用"
fi

echo ""
echo "2. 检查设备树中的GPIO信息："
if [ -f "/proc/device-tree/pinctrl/gpio-ranges" ]; then
    echo "GPIO ranges信息："
    hexdump -C /proc/device-tree/pinctrl/gpio-ranges 2>/dev/null || echo "无法读取GPIO ranges"
fi

echo ""
echo "3. 检查现有的GPIO导出："
if [ -d "/sys/class/gpio" ]; then
    echo "已导出的GPIO："
    ls /sys/class/gpio/ | grep "gpio[0-9]"
fi

echo ""
echo "4. 建议的GPIO编号测试步骤："
echo "   对于RK3568，通常需要查看："
echo "   - 设备树文件 (.dts/.dtb)"
echo "   - 硬件原理图"  
echo "   - RK3568技术手册"

echo ""
echo "5. 测试GPIO功能 (需要root权限)："
echo "   以下命令可以测试GPIO是否可用："

# 提供一些常用的RK3568 GPIO编号进行测试
TEST_GPIOS=(21 64 96 115 128 160 162)

for gpio in "${TEST_GPIOS[@]}"; do
    echo ""
    echo "测试GPIO ${gpio}:"
    echo "  导出: echo ${gpio} > /sys/class/gpio/export"
    echo "  设置输出: echo out > /sys/class/gpio/gpio${gpio}/direction"
    echo "  设置高电平: echo 1 > /sys/class/gpio/gpio${gpio}/value"
    echo "  设置低电平: echo 0 > /sys/class/gpio/gpio${gpio}/value"
    echo "  取消导出: echo ${gpio} > /sys/class/gpio/unexport"
done

echo ""
echo "6. 安全测试一个GPIO (如果有root权限):"

# 选择一个相对安全的GPIO进行测试
SAFE_GPIO=162

if [ "$EUID" -eq 0 ]; then
    echo "正在测试GPIO ${SAFE_GPIO}..."
    
    # 导出GPIO
    if echo ${SAFE_GPIO} > /sys/class/gpio/export 2>/dev/null; then
        echo "  ✓ GPIO ${SAFE_GPIO} 导出成功"
        
        # 设置为输出
        if echo "out" > /sys/class/gpio/gpio${SAFE_GPIO}/direction 2>/dev/null; then
            echo "  ✓ GPIO ${SAFE_GPIO} 设置为输出成功"
            
            # 测试高低电平
            echo "1" > /sys/class/gpio/gpio${SAFE_GPIO}/value 2>/dev/null
            echo "  ✓ GPIO ${SAFE_GPIO} 设置为高电平"
            
            sleep 1
            
            echo "0" > /sys/class/gpio/gpio${SAFE_GPIO}/value 2>/dev/null
            echo "  ✓ GPIO ${SAFE_GPIO} 设置为低电平"
            
            # 清理
            echo ${SAFE_GPIO} > /sys/class/gpio/unexport 2>/dev/null
            echo "  ✓ GPIO ${SAFE_GPIO} 取消导出成功"
        else
            echo "  ✗ GPIO ${SAFE_GPIO} 设置方向失败"
        fi
    else
        echo "  ✗ GPIO ${SAFE_GPIO} 导出失败（可能已被占用或编号错误）"
    fi
else
    echo "需要root权限来执行GPIO测试"
    echo "请使用: sudo $0"
fi

echo ""
echo "7. 如何确定正确的GPIO编号："
echo "   a) 查看硬件原理图，找到A21、U3、AF2引脚连接的RK3568管脚"
echo "   b) 对照RK3568数据手册，确定管脚的GPIO功能和编号"
echo "   c) 在设备树中查找相应的GPIO定义"
echo "   d) 使用示波器或万用表验证GPIO输出"

echo ""
echo "8. 常见的RK3568 GPIO计算方法："
echo "   GPIO编号 = 组基数 + 组内偏移"
echo "   例如: GPIO1_A0 = 32*1 + 0 = 32"
echo "         GPIO2_B3 = 32*2 + 8 + 3 = 75"
echo "         GPIO4_C2 = 32*4 + 16 + 2 = 146"

echo ""
echo "========================================"
echo "测试完成"
echo "========================================" 