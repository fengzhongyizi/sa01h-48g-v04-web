# Signal Info MCU通信协议规范

## 概述
本文档定义了SA01H-48G-V04信号分析器与MCU之间关于信号信息获取的通信协议。所有通信通过UART5进行，波特率57600bps。

## 指令格式

### 通用指令格式
```
GET SIGNAL <PARAMETER>\r\n
```

### 支持的参数列表

#### 视频信息参数
| 参数名称      | 指令                        | 说明           |
|---------------|----------------------------|----------------|
| VIDEO_FORMAT  | `GET SIGNAL VIDEO_FORMAT\r\n`  | 视频格式       |
| COLOR_SPACE   | `GET SIGNAL COLOR_SPACE\r\n`   | 色彩空间       |
| COLOR_DEPTH   | `GET SIGNAL COLOR_DEPTH\r\n`   | 色彩深度       |
| HDR_FORMAT    | `GET SIGNAL HDR_FORMAT\r\n`    | HDR格式        |
| HDMI_DVI      | `GET SIGNAL HDMI_DVI\r\n`      | HDMI/DVI类型   |
| FRL_RATE      | `GET SIGNAL FRL_RATE\r\n`      | FRL传输速率    |
| DSC_MODE      | `GET SIGNAL DSC_MODE\r\n`      | DSC压缩模式    |
| HDCP_TYPE     | `GET SIGNAL HDCP_TYPE\r\n`     | HDCP版本类型   |

#### 音频信息参数
| 参数名称           | 指令                           | 说明              |
|-------------------|-------------------------------|-------------------|
| SAMPLING_FREQ     | `GET SIGNAL SAMPLING_FREQ\r\n`     | 采样频率          |
| SAMPLING_SIZE     | `GET SIGNAL SAMPLING_SIZE\r\n`     | 采样位深          |
| CHANNEL_COUNT     | `GET SIGNAL CHANNEL_COUNT\r\n`     | 声道数量          |
| CHANNEL_NUMBER    | `GET SIGNAL CHANNEL_NUMBER\r\n`    | 声道编号          |
| LEVEL_SHIFT       | `GET SIGNAL LEVEL_SHIFT\r\n`       | 电平偏移          |
| CBIT_SAMPLING_FREQ| `GET SIGNAL CBIT_SAMPLING_FREQ\r\n`| C位采样频率       |
| CBIT_DATA_TYPE    | `GET SIGNAL CBIT_DATA_TYPE\r\n`    | C位数据类型       |

#### 批量获取指令
| 指令                        | 说明                    |
|----------------------------|-------------------------|
| `GET SIGNAL ALL_VIDEO\r\n` | 获取所有视频信息        |
| `GET SIGNAL ALL_AUDIO\r\n` | 获取所有音频信息        |
| `GET SIGNAL ALL_INFO\r\n`  | 获取所有信号信息        |

## 返回数据格式

### 单项数据返回格式
```
SIGNAL_INFO <PARAMETER> <VALUE>\r\n
```

### 示例返回数据

#### 视频信息返回示例
```
SIGNAL_INFO VIDEO_FORMAT 4K60Hz\r\n
SIGNAL_INFO COLOR_SPACE RGB(0-255)\r\n
SIGNAL_INFO COLOR_DEPTH 8Bit\r\n
SIGNAL_INFO HDR_FORMAT HDR10\r\n
SIGNAL_INFO HDMI_DVI HDMI\r\n
SIGNAL_INFO FRL_RATE 40Gbps\r\n
SIGNAL_INFO DSC_MODE OFF\r\n
SIGNAL_INFO HDCP_TYPE V2.3\r\n
```

#### 音频信息返回示例
```
SIGNAL_INFO SAMPLING_FREQ 48kHz\r\n
SIGNAL_INFO SAMPLING_SIZE 16Bit\r\n
SIGNAL_INFO CHANNEL_COUNT 2CH\r\n
SIGNAL_INFO CHANNEL_NUMBER 1-2\r\n
SIGNAL_INFO LEVEL_SHIFT 0dB\r\n
SIGNAL_INFO CBIT_SAMPLING_FREQ 48kHz\r\n
SIGNAL_INFO CBIT_DATA_TYPE PCM\r\n
```

## 数据值规范

### VIDEO_FORMAT (视频格式)
```
有效值：
- "1080P@60Hz"
- "1080P@30Hz"
- "4K30Hz"
- "4K60Hz"
- "8K30Hz"
- "8K60Hz"
- "No Signal"
- "Unknown"
```

### COLOR_SPACE (色彩空间)
```
有效值：
- "RGB(0-255)"
- "RGB(16-235)"
- "YUV444"
- "YUV422"
- "YUV420"
- "Unknown"
```

### COLOR_DEPTH (色彩深度)
```
有效值：
- "8Bit"
- "10Bit"
- "12Bit"
- "16Bit"
- "Unknown"
```

### HDR_FORMAT (HDR格式)
```
有效值：
- "SDR"
- "HDR10"
- "HDR10+"
- "Dolby Vision"
- "HLG"
- "Unknown"
```

### HDMI_DVI (接口类型)
```
有效值：
- "HDMI"
- "DVI"
- "Unknown"
```

### FRL_RATE (FRL传输速率)
```
有效值：
- "TMDS"
- "FRL 3Gbps"
- "FRL 6Gbps"
- "FRL 8Gbps"
- "FRL 10Gbps"
- "FRL 12Gbps"
- "FRL 16Gbps"
- "FRL 20Gbps"
- "FRL 24Gbps"
- "FRL 32Gbps"
- "FRL 40Gbps"
- "FRL 48Gbps"
- "Unknown"
```

### DSC_MODE (DSC压缩模式)
```
有效值：
- "OFF"
- "ON"
- "Unknown"
```

### HDCP_TYPE (HDCP版本)
```
有效值：
- "None"
- "V1.4"
- "V2.2"
- "V2.3"
- "Unknown"
```

### SAMPLING_FREQ (采样频率)
```
有效值：
- "32kHz"
- "44.1kHz"
- "48kHz"
- "88.2kHz"
- "96kHz"
- "176.4kHz"
- "192kHz"
- "Unknown"
```

### SAMPLING_SIZE (采样位深)
```
有效值：
- "16Bit"
- "20Bit"
- "24Bit"
- "Unknown"
```

### CHANNEL_COUNT (声道数量)
```
有效值：
- "1CH"
- "2CH"
- "3CH"
- "4CH"
- "5CH"
- "6CH"
- "7CH"
- "8CH"
- "Unknown"
```

### CHANNEL_NUMBER (声道编号)
```
有效值：
- "1"
- "1-2"
- "1-3"
- "1-4"
- "1-5"
- "1-6"
- "1-7"
- "1-8"
- "Unknown"
```

### LEVEL_SHIFT (电平偏移)
```
有效值：
- "0dB"
- "+3dB"
- "+6dB"
- "+9dB"
- "+12dB"
- "-3dB"
- "-6dB"
- "-9dB"
- "-12dB"
- "Unknown"
```

### CBIT_SAMPLING_FREQ (C位采样频率)
```
有效值：
- "32kHz"
- "44.1kHz"
- "48kHz"
- "88.2kHz"
- "96kHz"
- "176.4kHz"
- "192kHz"
- "Unknown"
```

### CBIT_DATA_TYPE (C位数据类型)
```
有效值：
- "PCM"
- "DTS"
- "Dolby Digital"
- "DSD"
- "Unknown"
```

## 错误处理

### 错误返回格式
```
SIGNAL_ERROR <ERROR_CODE> <ERROR_MESSAGE>\r\n
```

### 错误代码定义
```
ERROR_CODE值：
- 001: "Invalid parameter"
- 002: "No signal detected"
- 003: "Signal unstable"
- 004: "Hardware error"
- 005: "Communication timeout"
- 999: "Unknown error"
```

### 错误返回示例
```
SIGNAL_ERROR 002 No signal detected\r\n
SIGNAL_ERROR 001 Invalid parameter\r\n
```

## 通信时序

### 请求时序
1. 上位机发送指令
2. 等待50ms避免指令冲突
3. MCU处理并返回数据
4. 上位机解析返回数据

### 超时处理
- 单个指令超时时间：2秒
- 批量指令超时时间：10秒
- 超时后上位机应显示"N/A"或"Timeout"

## 实现注意事项

### MCU端实现要求
1. **实时性**：信号参数变化时应主动上报
2. **稳定性**：确保数据准确性，避免读取不稳定信号时返回错误数据
3. **响应性**：单个指令响应时间应在500ms内
4. **并发性**：支持连续指令请求，但需要排队处理

### 上位机端实现要求
1. **解析容错**：对于格式不匹配的返回数据应显示"Unknown"
2. **超时处理**：超时后显示适当的错误信息
3. **实时更新**：接收到数据后立即更新UI显示
4. **状态缓存**：保存最后一次有效的数据状态

## 测试用例

### 正常情况测试
```
发送: GET SIGNAL VIDEO_FORMAT\r\n
期望: SIGNAL_INFO VIDEO_FORMAT 4K60Hz\r\n

发送: GET SIGNAL ALL_VIDEO\r\n
期望: 返回8个视频参数的SIGNAL_INFO响应
```

### 异常情况测试
```
发送: GET SIGNAL INVALID_PARAM\r\n
期望: SIGNAL_ERROR 001 Invalid parameter\r\n

无信号状态下发送: GET SIGNAL VIDEO_FORMAT\r\n
期望: SIGNAL_INFO VIDEO_FORMAT No Signal\r\n
```

## 版本信息
- **协议版本**: v1.0
- **创建日期**: 2024年
- **适用设备**: SA01H-48G-V04信号分析器
- **通信接口**: UART5 (57600bps, 8N1) 