// CustomButton.qml
// 自定义按钮组件 - 提供统一的按钮外观和交互行为
// 包括圆角矩形、渐变背景、阴影效果及鼠标悬停/按下状态变化

// 这个自定义按钮组件为应用提供了统一的视觉风格，主要特点包括：
// 1.视觉特效：
// 圆角矩形外观
// 垂直渐变背景
// 轻微阴影效果增强深度感
// 2.状态反馈：
// 按下状态时背景和文字颜色变化
// 预留了鼠标悬停效果代码(当前已注释)
// 3.可定制性：
// 组件使用者可以设置文本内容
// 可通过属性覆盖调整尺寸、颜色等
// 这个组件在整个应用中被广泛使用，为界面提供一致的交互元素。

import QtQuick 2.0                    // 导入基本的QtQuick模块
import QtGraphicalEffects 1.0         // 导入图形特效模块，用于实现阴影效果

Rectangle {
    id: root
    width: 300                        // 默认宽度300像素
    height: 120                       // 默认高度120像素
    radius: 8                         // 圆角半径8像素
    border.width: 2                   // 边框宽度2像素
    border.color: "#333333"           // 边框颜色深灰色

    // 定义按钮背景渐变效果
    gradient: Gradient {
        // 渐变起始颜色 - 根据鼠标按下状态变化
        GradientStop { position: 0; color: mouseArea.pressed ? "#e0e0e0" : "#4a4a4a" }  // 鼠标按下时浅灰色，否则深灰色
        // 渐变结束颜色 - 根据鼠标按下状态变化
        GradientStop { position: 1; color: mouseArea.pressed ? "#d0d0d0" : "#3a3a3a" }  // 鼠标按下时浅灰色，否则深灰色
    }

    // 启用图层效果，用于添加阴影
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true        // 透明边框
        radius: 4                      // 阴影半径4像素
        samples: 8                     // 阴影采样数8，影响阴影质量
        color: "#40000000"             // 半透明黑色阴影(40%透明度)
    }

    // 按钮文本 - 注意：文本内容需要由使用者设置
    Text {
//        text: "Button"               // 默认文本(已注释掉)
        anchors.centerIn: parent       // 文本居中显示
        font {
            family: "Arial"            // 字体Arial
            pixelSize: 35              // 字体大小35像素
            bold: true                 // 粗体
        }
        color: mouseArea.pressed ? "#333333" : "white"  // 鼠标按下时深灰色，否则白色
    }

    // 鼠标交互区域
    MouseArea {
        id: mouseArea
        anchors.fill: parent           // 填充整个按钮区域
        hoverEnabled: true             // 启用悬停检测
        
        // 鼠标进入事件处理器(当前未启用)
        onEntered: {
//            parent.border.color = "#666666";  // 改变边框颜色(已注释掉)
//            parent.opacity = 0.9;             // 降低不透明度(已注释掉)
        }
        
        // 鼠标离开事件处理器(当前未启用)
        onExited: {
//            parent.border.color = "#333333";  // 恢复边框颜色(已注释掉)
//            parent.opacity = 1;               // 恢复不透明度(已注释掉)
        }
    }
}