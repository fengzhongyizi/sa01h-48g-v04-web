# Error Rate MCU通信协议规范

## 概述
本文档定义了SA01H-48G-V04信号分析器与MCU之间关于错误率监控功能的通信协议。所有通信通过UART5进行，波特率57600bps。错误率监控用于实时检测HDMI信号传输过程中的错误和信号丢失情况。

## 监控原理
错误率监控系统将时间划分为多个时间槽(Time Slot)，每个时间槽可设置为1-255秒或分钟。系统总共支持2040个时间槽的监控数据。当检测到信号异常时，在对应的时间槽位置标记异常。

## 指令格式

### 启动监控指令
```
START SIGNAL MONITOR <INTERVAL> <UNIT> <MODE>\r\n
```

#### 参数说明：
- **INTERVAL**: 时间槽间隔，范围1-255
- **UNIT**: 时间单位
  - `SECONDS` - 秒
  - `MINUTES` - 分钟
- **MODE**: 触发模式
  - `0` - 帧差异+信号丢失检测
  - `1` - 仅信号丢失检测

#### 示例：
```
START SIGNAL MONITOR 5 SECONDS 0\r\n    # 每5秒一个时间槽，帧差异+信号丢失模式
START SIGNAL MONITOR 2 MINUTES 1\r\n    # 每2分钟一个时间槽，仅信号丢失模式
START SIGNAL MONITOR 30 SECONDS 0\r\n   # 每30秒一个时间槽，帧差异+信号丢失模式
```

### 停止监控指令
```
STOP SIGNAL MONITOR\r\n
```

### 查询监控状态指令
```
GET MONITOR STATUS\r\n
```

### 清除监控数据指令
```
CLEAR MONITOR DATA\r\n
```

## 返回数据格式

### 监控状态返回
```
MONITOR_STATUS <STATUS> <CURRENT_SLOT> <TOTAL_SLOTS> <START_TIME>\r\n
```

#### 参数说明：
- **STATUS**: 监控状态
  - `RUNNING` - 正在监控
  - `STOPPED` - 已停止
  - `PAUSED` - 已暂停
- **CURRENT_SLOT**: 当前时间槽编号 (0001-2040)
- **TOTAL_SLOTS**: 已使用的总时间槽数
- **START_TIME**: 监控开始时间 (HH:MM:SS格式)

#### 示例：
```
MONITOR_STATUS RUNNING 0125 125 14:35:22\r\n
MONITOR_STATUS STOPPED 0000 0 00:00:00\r\n
```

### 时间槽数据返回
```
SIGNAL_SLOT <SLOT_ID> <STATUS> <TIMESTAMP>\r\n
```

#### 参数说明：
- **SLOT_ID**: 时间槽编号，4位数字格式 (0001-2040)
- **STATUS**: 槽状态
  - `0` - 正常
  - `1` - 检测到异常
- **TIMESTAMP**: 时间戳 (HH:MM:SS格式)

#### 示例：
```
SIGNAL_SLOT 0001 0 14:35:22\r\n    # 第1个时间槽，正常
SIGNAL_SLOT 0025 1 14:37:15\r\n    # 第25个时间槽，检测到异常
SIGNAL_SLOT 0126 1 15:12:03\r\n    # 第126个时间槽，检测到异常
```

### 批量数据返回 (用于状态查询响应)
```
MONITOR_DATA_START\r\n
SIGNAL_SLOT 0001 0 14:35:22\r\n
SIGNAL_SLOT 0025 1 14:37:15\r\n
SIGNAL_SLOT 0126 1 15:12:03\r\n
...
MONITOR_DATA_END\r\n
```

## 错误处理

### 错误返回格式
```
MONITOR_ERROR <ERROR_CODE> <ERROR_MESSAGE>\r\n
```

### 错误代码定义
```
ERROR_CODE值：
- 101: "Monitor already running"
- 102: "Monitor not running"  
- 103: "Invalid time interval"
- 104: "Invalid time unit"
- 105: "Invalid trigger mode"
- 106: "Maximum slots exceeded"
- 107: "Hardware initialization failed"
- 108: "Signal detection failed"
- 199: "Unknown monitor error"
```

### 错误返回示例
```
MONITOR_ERROR 101 Monitor already running\r\n
MONITOR_ERROR 103 Invalid time interval\r\n
MONITOR_ERROR 106 Maximum slots exceeded\r\n
```

## 触发模式详细说明

### 模式0: 帧差异+信号丢失检测
- **帧差异检测**: 对比连续帧的图像内容，检测异常变化
- **信号丢失检测**: 检测HDMI信号是否完全丢失
- **触发条件**: 任一条件满足即触发异常标记
- **适用场景**: 全面的信号质量监控

### 模式1: 仅信号丢失检测  
- **信号丢失检测**: 仅检测HDMI信号是否完全丢失
- **触发条件**: 信号完全丢失时触发异常标记
- **适用场景**: 基础的信号连通性监控

## 数据组织格式

### 时间槽编号规则
```
槽编号范围: 0001 - 2040
格式: 4位数字，前导零填充
示例: 0001, 0025, 0126, 1999, 2040
```

### 网格显示映射
```
每行显示100个时间槽
行1: 槽 0001-0100 (编号 0000-0099)
行2: 槽 0101-0200 (编号 0100-0199)  
行3: 槽 0201-0300 (编号 0200-0299)
...
行21: 槽 2001-2040 (编号 2000-2039)
```

### 批次标签对应
```
行标签 | 时间槽范围 | 数组索引范围
-------|------------|-------------
0001   | 0001-0100  | 0-99
0101   | 0101-0200  | 100-199
0201   | 0201-0300  | 200-299
0301   | 0301-0400  | 300-399
...    | ...        | ...
1901   | 1901-2000  | 1900-1999
2001   | 2001-2040  | 2000-2039
```

## 实时数据推送

### MCU主动上报
当检测到异常时，MCU应主动发送SIGNAL_SLOT数据：
```
检测到异常 → 立即发送: SIGNAL_SLOT <SLOT_ID> 1 <TIMESTAMP>\r\n
```

### 心跳数据 (可选)
每个时间槽结束时，MCU可发送正常状态确认：
```
时间槽结束 → 发送: SIGNAL_SLOT <SLOT_ID> 0 <TIMESTAMP>\r\n
```

## 通信时序

### 启动监控时序
```
1. 上位机: START SIGNAL MONITOR 5 SECONDS 0\r\n
2. MCU: MONITOR_STATUS RUNNING 0001 0 14:35:22\r\n  
3. MCU开始监控，异常时主动上报
4. MCU: SIGNAL_SLOT 0025 1 14:37:15\r\n (异常时)
```

### 停止监控时序
```
1. 上位机: STOP SIGNAL MONITOR\r\n
2. MCU: MONITOR_STATUS STOPPED 0125 125 14:35:22\r\n
```

### 状态查询时序
```
1. 上位机: GET MONITOR STATUS\r\n
2. MCU: MONITOR_STATUS RUNNING 0125 125 14:35:22\r\n
3. MCU: MONITOR_DATA_START\r\n
4. MCU: SIGNAL_SLOT 0025 1 14:37:15\r\n
5. MCU: SIGNAL_SLOT 0087 1 14:58:42\r\n
6. MCU: ...  (所有异常数据)
7. MCU: MONITOR_DATA_END\r\n
```

## 性能要求

### MCU端要求
1. **实时性**: 异常检测延迟 < 100ms
2. **数据存储**: 支持存储2040个时间槽的状态
3. **并发性**: 支持监控的同时响应查询指令
4. **稳定性**: 长时间运行不丢失数据

### 上位机端要求  
1. **缓冲处理**: 处理MCU的实时数据推送
2. **状态同步**: 定期查询确保数据一致性
3. **异常恢复**: 通信中断后能恢复监控状态
4. **内存管理**: 有效管理大量时间槽数据

## 测试用例

### 正常启动测试
```
发送: START SIGNAL MONITOR 10 SECONDS 0\r\n
期望: MONITOR_STATUS RUNNING 0001 0 <时间>\r\n
```

### 异常检测测试
```
启动监控后模拟信号异常
期望: SIGNAL_SLOT <编号> 1 <时间>\r\n
```

### 停止监控测试
```
发送: STOP SIGNAL MONITOR\r\n  
期望: MONITOR_STATUS STOPPED <编号> <总数> <开始时间>\r\n
```

### 错误处理测试
```
发送: START SIGNAL MONITOR 300 SECONDS 0\r\n (超出范围)
期望: MONITOR_ERROR 103 Invalid time interval\r\n
```

## 版本信息
- **协议版本**: v1.0
- **创建日期**: 2024年
- **适用设备**: SA01H-48G-V04信号分析器
- **通信接口**: UART5 (57600bps, 8N1)
- **最大监控时长**: 2040个时间槽
- **支持触发模式**: 2种 (帧差异+信号丢失 / 仅信号丢失) 