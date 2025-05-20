
MCU 与 RK3568 通信:
=SET INx EDIDy	                     用于切换需要对外使用的EDID	       EDID数量暂不定义，等待后续通知

=SET INx EDID Uy DATA zz	         用于写入User EDID	              目前，前29个EDID为固定EDID，30~32为User EDID。支持最大512Byte

=SET INx EDID CY	                 将外部EDID写入User EDID中	       支持最大512Byte

=SET AUDIO PACKET x1.x2.x3.x4.x5	 设置eARC输入的音频参数	           "x1=[1、2],x2=[1~4],x3=[1`6],x4=[1~9],x5=[1~4]
																      x1 = [1=IIS;2=SPDIF]
																      x2 = [1=LPCM;2=NLPCM;3=HBR;4=DSD]
																      x3 = [1=2CH;2=3CH;3=4CH;4=5CH;5=6CH;6=7CH]
																      x4 = [1=32K;2=44K;3=48K;4=64K;5=88K;6=96K;7=128K;8=176K;9=192K]
																      x5 = [1=16B;2=18B;3=20B;4=24B]"

=SET INx EARCy	                     用于指示eARC芯片是否启用eARC功能	x=[0,1],y=[0,1]{y=0,DISABLE;y=1,ENABLE}

=SET FAN SPEED x	                "设置风扇档位                      x=[0~3]{ x=0,0%; x=1,50%; x=2,85%; x=3,100%}
                	               （内测使用，正常状态由MCU自动控制）"	

=SET TXLAT x	                    设置IT6621芯片需要延迟声音的时长，以ms为单位	  x=[0~200]
		
=SET RBT		

=SET RST		
										
=GET NTCx VALUE	                    "用于NET芯片获取机体温度            "返回值为电压值，范围1.62~2.75V。若为0V需要检查硬件或命令格式
						    （内测使用，正常由MCU自动监测机体温度）"	         x=[0,1,2]"									

=GET INx EDIDy DATA	                用于获取EDID数据	              目前前29EDID为固定EDID，30~32为User EDID。支持最大512Byte

=GET EDID Ux NAME		
