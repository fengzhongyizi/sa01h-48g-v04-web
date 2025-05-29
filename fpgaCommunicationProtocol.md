# FPGA通信协议规范

## 概述
本文档定义了SA01H-48G-V04信号分析器中RK3568与FPGA (XCKU5P)之间的通信协议。

## 通信接口说明

### 1. PCIe 3.0
- **用途**：高速视频数据传输（Monitor页面图像）
- **带宽**：8GT/s
- **数据类型**：原始视频帧数据、压缩视频流

### 2. UART3
- **用途**：控制命令和状态数据传输
- **波特率**：115200bps, 8N1
- **数据类型**：Signal Info、Error Rate等小量数据

### 3. SPI
- **用途**：固件升级、配置数据传输
- **速率**：可配置

## UART3通信协议（FPGA数据获取）

### 命令格式
```
发送：AA <CMD_H> <CMD_L> <LEN_H> <LEN_L> <DATA...> <CHECKSUM>
响应：AB <CMD_H> <CMD_L> <LEN_H> <LEN_L> <DATA...> <CHECKSUM>
```

### Signal Info数据获取

#### 1. 获取视频信息
```
命令：AA 00 61 00 00 <CHECKSUM>
响应：AB 00 61 00 20 <VIDEO_DATA> <CHECKSUM>

VIDEO_DATA结构（32字节）：
- [0-1]: 分辨率宽度 (uint16)
- [2-3]: 分辨率高度 (uint16)
- [4]: 帧率 (uint8)
- [5]: 色彩空间 (uint8) 
  - 0x00: RGB
  - 0x01: YUV444
  - 0x02: YUV422
  - 0x03: YUV420
- [6]: 色彩深度 (uint8)
  - 0x08: 8bit
  - 0x0A: 10bit
  - 0x0C: 12bit
- [7]: HDR格式 (uint8)
  - 0x00: SDR
  - 0x01: HDR10
  - 0x02: HDR10+
  - 0x03: Dolby Vision
- [8]: HDMI/DVI模式 (uint8)
  - 0x00: DVI
  - 0x01: HDMI
- [9]: FRL速率 (uint8)
  - 0x00: TMDS
  - 0x01-0x0C: FRL 3-48Gbps
- [10]: DSC模式 (uint8)
  - 0x00: OFF
  - 0x01: ON
- [11]: HDCP版本 (uint8)
  - 0x00: None
  - 0x14: HDCP 1.4
  - 0x22: HDCP 2.2
  - 0x23: HDCP 2.3
- [12-31]: 保留
```

#### 2. 获取音频信息
```
命令：AA 00 62 00 00 <CHECKSUM>
响应：AB 00 62 00 10 <AUDIO_DATA> <CHECKSUM>

AUDIO_DATA结构（16字节）：
- [0]: 采样频率 (uint8)
  - 0x00: 32kHz
  - 0x01: 44.1kHz
  - 0x02: 48kHz
  - 0x03: 88.2kHz
  - 0x04: 96kHz
  - 0x05: 176.4kHz
  - 0x06: 192kHz
- [1]: 采样位深 (uint8)
  - 0x10: 16bit
  - 0x14: 20bit
  - 0x18: 24bit
- [2]: 声道数 (uint8) 1-8
- [3]: 音频格式 (uint8)
  - 0x00: PCM
  - 0x01: DTS
  - 0x02: Dolby Digital
- [4-15]: 保留
```

### Error Rate数据获取

#### 1. 启动错误率监控
```
命令：AA 00 70 00 04 <INTERVAL> <UNIT> <MODE> <RESERVED> <CHECKSUM>
- INTERVAL: 时间间隔 (1-255)
- UNIT: 0x00=秒, 0x01=分钟
- MODE: 0x00=帧差异+信号丢失, 0x01=仅信号丢失

响应：AB 00 70 00 01 <STATUS> <CHECKSUM>
- STATUS: 0x00=成功, 0x01=失败
```

#### 2. 停止错误率监控
```
命令：AA 00 71 00 00 <CHECKSUM>
响应：AB 00 71 00 01 <STATUS> <CHECKSUM>
```

#### 3. 获取错误率数据（FPGA主动上报）
```
FPGA主动发送：AB 00 72 <LEN_H> <LEN_L> <SLOT_DATA> <CHECKSUM>

SLOT_DATA结构：
- [0-1]: 时间槽ID (uint16, 0-2039)
- [2]: 状态 (uint8)
  - 0x00: 正常
  - 0x01: 检测到错误
- [3-6]: 时间戳 (uint32, 秒数)
```

## PCIe数据传输协议

### 视频帧传输格式
```
帧头结构（16字节）：
- [0-3]: 同步字 0x56494446 ("VIDF")
- [4-5]: 帧宽度 (uint16)
- [6-7]: 帧高度 (uint16)
- [8]: 像素格式 (uint8)
  - 0x00: RGB24
  - 0x01: YUV420
  - 0x02: YUV422
- [9]: 压缩标志 (uint8)
  - 0x00: 未压缩
  - 0x01: JPEG压缩
- [10-11]: 帧序号 (uint16)
- [12-15]: 帧数据长度 (uint32)

数据部分：
- 原始像素数据或压缩数据
```

### PCIe DMA传输模式
```
1. FPGA将视频数据写入DMA缓冲区
2. 发送中断通知RK3568
3. RK3568读取DMA缓冲区数据
4. 清除中断标志
```

## 实现建议

### 1. SerialPortManager扩展
```cpp
// 在serialportmanager.cpp中添加FPGA命令处理
void SerialPortManager::requestSignalInfo() {
    // 构建获取视频信息命令
    QByteArray cmd;
    cmd.append(0xAA);
    cmd.append(0x00);
    cmd.append(0x61);
    cmd.append(0x00);
    cmd.append(0x00);
    cmd.append(calculateChecksum(cmd));
    
    writeData(cmd, 0);  // 发送到UART3
}

void SerialPortManager::onReadyRead() {
    // 现有代码...
    
    // 添加FPGA响应处理
    if (buffer.startsWith("\xAB\x00\x61")) {
        // 处理视频信息响应
        processVideoInfoResponse(buffer);
    }
    else if (buffer.startsWith("\xAB\x00\x72")) {
        // 处理错误率数据
        processErrorRateData(buffer);
    }
}
```

### 2. PCIe视频接收实现
```cpp
class PCIeVideoReceiver : public QObject {
    Q_OBJECT
    
private:
    int pcie_fd;  // PCIe设备文件描述符
    void* dma_buffer;  // DMA缓冲区
    
public:
    bool init() {
        // 打开PCIe设备
        pcie_fd = open("/dev/pcie_fpga", O_RDWR);
        
        // 映射DMA缓冲区
        dma_buffer = mmap(NULL, DMA_BUFFER_SIZE, 
                         PROT_READ | PROT_WRITE, 
                         MAP_SHARED, pcie_fd, 0);
        
        // 注册中断处理
        // ...
        
        return true;
    }
    
    void onFrameReady() {
        // 读取帧头
        FrameHeader* header = (FrameHeader*)dma_buffer;
        
        // 验证同步字
        if (header->sync != 0x56494446) return;
        
        // 创建QImage
        QImage frame(header->width, header->height, 
                    QImage::Format_RGB888);
        
        // 复制像素数据
        memcpy(frame.bits(), 
               (uint8_t*)dma_buffer + sizeof(FrameHeader),
               header->data_length);
        
        // 发送信号
        emit frameReceived(frame);
    }
    
signals:
    void frameReceived(const QImage& frame);
};
```

### 3. 系统集成
```cpp
// 在main.cpp中
PCIeVideoReceiver* pcieReceiver = new PCIeVideoReceiver(&app);
pcieReceiver->init();

// 连接到SignalAnalyzerManager
connect(pcieReceiver, &PCIeVideoReceiver::frameReceived,
        saMgr, &SignalAnalyzerManager::updateFrame);
```

## 测试建议

1. **UART3通信测试**
   - 使用串口调试工具验证命令响应
   - 检查校验和计算是否正确

2. **PCIe传输测试**
   - 先测试小数据块传输
   - 逐步增加到完整视频帧

3. **性能测试**
   - Monitor页面帧率测试
   - Error Rate数据实时性测试

## 注意事项

1. FPGA固件需要实现对应的协议处理逻辑
2. PCIe驱动需要在Linux内核中正确配置
3. 考虑添加数据完整性校验机制
4. 注意处理通信超时和错误恢复 