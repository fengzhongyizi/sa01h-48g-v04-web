// BatteryIndicator.qml
// 电池状态指示器组件，显示设备电池电量和充电状态
// 用于在界面右上角提供电池信息的可视化展示
// 电量显示：通过填充矩形的宽度直观展示当前电池电量
// 充电状态：当设备充电时显示闪电图标并添加闪烁动画
// 颜色编码：根据电池电量级别改变颜色（红色表示低电量，橙色表示中等电量，绿色表示高电量）
// 低电量警告：电量低于15%时触发闪烁警告效果
// 交互信息：鼠标悬停时显示详细的电池状态信息
// 平滑过渡：电池电量和颜色变化时有平滑的动画过渡

import QtQuick 2.12              // 提供基本QML元素
import QtQuick.Controls 2.12     // 提供控件
import QtGraphicalEffects 1.0    // 提供图形特效如阴影、渐变等

// 主容器
Item {
    id: root
    
    // 组件默认尺寸
    width: 42                    // 默认宽度
    height: 24                   // 默认高度
    
    // 可定制属性
    property int batteryLevel: 0      // 电池电量，范围0-100
    property bool isCharging: false   // 充电状态，true表示正在充电
    
    // 电池颜色属性，根据电量变化
    property color batteryColor: {
        // 根据电池电量显示不同颜色
        if (batteryLevel <= 20) {
            return "#FF4444";    // 低电量显示红色
        } else if (batteryLevel <= 50) {
            return "#FFBB33";    // 中等电量显示橙色
        } else {
            return "#99CC00";    // 高电量显示绿色
        }
    }
    
    // 电池外框
    Rectangle {
        id: batteryOutline
        width: parent.width - 4   // 减去4像素给电池正极的空间
        height: parent.height
        color: "transparent"      // 透明背景
        border.color: "#FFFFFF"   // 白色边框
        border.width: 2
        radius: 3
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        
        // 电池电量填充区域
        Rectangle {
            id: batteryFill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2    // 内边距，与外框保持间距
            
            // 电池填充宽度与电量成正比
            width: Math.max(0, Math.min(
                        parent.width - anchors.margins * 2, 
                        (parent.width - anchors.margins * 2) * batteryLevel / 100
                    ))
            
            color: batteryColor   // 使用根据电量计算的颜色
            radius: 2             // 圆角半径
            
            // 电量过渡动画
            Behavior on width {
                NumberAnimation {
                    duration: 300  // 过渡动画持续时间
                    easing.type: Easing.OutQuad  // 缓动类型
                }
            }
            
            Behavior on color {
                ColorAnimation {
                    duration: 300  // 颜色变化动画
                }
            }
        }
        
        // 电池电量百分比文本（可选显示）
        Text {
            anchors.centerIn: parent
            text: batteryLevel + "%"
            font.pixelSize: 10
            color: batteryLevel > 50 ? "#333333" : "#FFFFFF"
            visible: batteryLevel > 15  // 低电量时不显示文字
        }
    }
    
    // 电池正极突起部分
    Rectangle {
        id: batteryTip
        width: 3
        height: parent.height * 0.6
        radius: 1
        color: "#FFFFFF"   // 白色
        anchors.left: batteryOutline.right
        anchors.verticalCenter: parent.verticalCenter
    }
    
    // 充电指示器,充电标志显示控制
    Item {
        id: chargingIndicator
        anchors.fill: batteryOutline
        visible: isCharging  // 仅在充电时显示
        
        // 闪电图标或其他充电标志
        Canvas {
            id: chargingSymbol
            anchors.fill: parent
            anchors.margins: 6  // 留出足够空间
            
            // 绘制闪电图标
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                
                // 设置闪电颜色
                ctx.fillStyle = "#FFFFFF";
                
                // 绘制闪电形状
                var width = chargingSymbol.width;
                var height = chargingSymbol.height;
                
                ctx.beginPath();
                // 闪电形状坐标
                ctx.moveTo(width * 0.5, 0);              // 顶部中间
                ctx.lineTo(width * 0.2, height * 0.5);   // 左侧中间
                ctx.lineTo(width * 0.4, height * 0.5);   // 中间左侧
                ctx.lineTo(width * 0.3, height);         // 底部左侧
                ctx.lineTo(width * 0.8, height * 0.5);   // 右侧中间
                ctx.lineTo(width * 0.6, height * 0.5);   // 中间右侧
                ctx.lineTo(width * 0.5, 0);              // 回到顶部
                ctx.closePath();
                ctx.fill();
            }
        }
        
        // 充电闪烁动画
        SequentialAnimation {
            running: isCharging  // 充电状态下启动动画
            loops: Animation.Infinite  // 无限循环
            
            NumberAnimation {
                target: chargingSymbol
                property: "opacity"
                from: 1.0
                to: 0.3
                duration: 800
            }
            
            NumberAnimation {
                target: chargingSymbol
                property: "opacity"
                from: 0.3
                to: 1.0
                duration: 800
            }
        }
    }
    
    // 低电量警告闪烁效果
    SequentialAnimation {
        id: lowBatteryAnimation
        running: !isCharging && batteryLevel <= 15  // 低电量且未充电时启动
        loops: Animation.Infinite  // 无限循环
        
        // 闪烁效果
        NumberAnimation {
            target: batteryFill
            property: "opacity"
            from: 1.0
            to: 0.3
            duration: 500
        }
        
        NumberAnimation {
            target: batteryFill
            property: "opacity"
            from: 0.3
            to: 1.0
            duration: 500
        }
    }
    
    // 鼠标悬停显示详细信息的工具提示
    ToolTip {
        id: batteryTooltip
        visible: batteryMouseArea.containsMouse
        delay: 500  // 延迟显示
        timeout: 5000  // 显示时间
        
        contentItem: Text {
            text: {
                if (isCharging)
                    return qsTr("Charging: %1%").arg(batteryLevel)
                else if (batteryLevel <= 15)
                    return qsTr("Low Battery: %1%").arg(batteryLevel)
                else
                    return qsTr("Battery: %1%").arg(batteryLevel)
            }
            color: "#FFFFFF"
            font.pixelSize: 12
        }
        
        background: Rectangle {
            color: "#80000000"  // 半透明黑色背景
            radius: 3
        }
    }
    
    // 鼠标交互区域
    MouseArea {
        id: batteryMouseArea
        anchors.fill: parent
        hoverEnabled: true  // 启用悬停检测
        
        // 可添加点击事件处理，如显示详细的电池信息等
        onClicked: {
            console.log("Battery status: " + batteryLevel + "%, Charging: " + isCharging)
            // 这里可以添加更多交互逻辑
        }
    }
    
    // 组件状态变化
    Component.onCompleted: {
        console.log("BatteryIndicator initialized with level: " + batteryLevel)
    }
    
    // 监听电池电量变化
    onBatteryLevelChanged: {
        // 确保电量在有效范围内
        if (batteryLevel < 0) batteryLevel = 0
        if (batteryLevel > 100) batteryLevel = 100
        
        // 可以在这里添加额外的逻辑，如电量过低时的警告
        if (batteryLevel <= 10 && !isCharging) {
            console.log("Battery critically low!")
            // 可以触发系统警告或其他操作
        }
    }
}