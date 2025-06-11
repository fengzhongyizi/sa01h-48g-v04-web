#include "parseedid.h"
#include <QDebug>

ParseEDID::ParseEDID(QObject *parent) : QObject(parent)
{
//    if(tools==nullptr)
//    {
//        tools = new Tools(this);
//    }
}

void ParseEDID::EdidReadStatusShow(char *cEDIDBuf)//int Edidindex)
{
    m_cEDIDBuf_SHOW = cEDIDBuf;
    char CBufTemp[10];
    char cTemp;
    int j;

    m_EdidAll = "";
    m_StatusChkSum = "";
    m_VideoInfoString = "";
    m_AudioInfoString = "";
    m_EdidGeneralInfo = "";

    if(m_cEDIDBuf_SHOW[0] != 0x00 || m_cEDIDBuf_SHOW[1] != (char)0xff || m_cEDIDBuf_SHOW[2] != (char)0xff
            || m_cEDIDBuf_SHOW[3] != (char)0xff || m_cEDIDBuf_SHOW[4] != (char)0xff || m_cEDIDBuf_SHOW[5] != (char)0xff
            || m_cEDIDBuf_SHOW[6] != (char)0xff || m_cEDIDBuf_SHOW[7] != (char)0x00)
    {
        m_StatusChkSum = "EDID data header error !";
        QList<QString> qls;
        qls.append(m_StatusChkSum);
        qls.append(m_EdidAll);
        qls.append(m_EdidGeneralInfo);
        qls.append(m_VideoInfoString);
        qls.append(m_AudioInfoString);
        emit signalEDID(qls);
    }
    else
    {
        if(m_cEDIDBuf_SHOW[126] == 0)
        {
            m_StatusChkSum = "DVI EDID";
            cTemp = 0;
            for(j=0;j<128;j++)
            {
                cTemp += m_cEDIDBuf_SHOW[j];
            }
            if(cTemp !=0)
                m_StatusChkSum += "\rCheck sum error !";
        }
        else
        {
            char cStatusTmp = 0;
            m_StatusChkSum = "HDMI EDID";
            cTemp = 0;
            for(j=0;j<128;j++)
            {
                cTemp += m_cEDIDBuf_SHOW[j];
            }
            if(cTemp != 0)
            {
                m_StatusChkSum += "\rBank0 check sum error !";
                cStatusTmp = 1;
            }
            cTemp = 0;
            for(j=128;j<256;j++)
            {
                cTemp += m_cEDIDBuf_SHOW[j];
            }
            if(cTemp != 0)
            {
                m_StatusChkSum += "\rBank1 check sum error !";
            }
            else
            {
                if(cStatusTmp == 1)
                    m_StatusChkSum += "\rBank1 check sum Ok !";
                else
                    m_StatusChkSum += "\rcheck sum Ok !";
            }

        }
//        for(j=0;j<128;j++)
//        {
//        }

        for(j=0;j<256;j++)
        {
            cTemp = m_cEDIDBuf_SHOW[j]&0x0f;
            if(cTemp>9)
            {
                CBufTemp[1]= 'A';
                CBufTemp[1] += (cTemp - 10);// + m_cEDIDBuf_SHOW[j]&0x0f;
            }
            else
            {
                CBufTemp[1]= '0';
                CBufTemp[1] += cTemp;// + m_cEDIDBuf_SHOW[j]&0x0f;
            }
            cTemp = m_cEDIDBuf_SHOW[j];
            cTemp = cTemp>>4;
            cTemp = cTemp&0x0f;
            if(cTemp>9)
            {
                CBufTemp[0]= 'A';
                CBufTemp[0] += (cTemp -10);
            }
            else
            {
                CBufTemp[0]= '0';
                CBufTemp[0] += cTemp;
            }
            CBufTemp[2] = ' ';
            m_EdidAll+=CBufTemp[0];
            m_EdidAll+=CBufTemp[1];
            m_EdidAll+=CBufTemp[2];
        }

        //        m_VideoInfoString.Empty();
        //        m_AudioInfoString.Empty();
        //        m_EdidGeneralInfo.Empty();

        EdidAnalysseInfo((unsigned char*)m_cEDIDBuf_SHOW,0);
        EdidAnalysseInfo((unsigned char*)m_cEDIDBuf_SHOW,1);
        EdidAnalysseInfo((unsigned char*)m_cEDIDBuf_SHOW,2);

    }
    //    UpdateData(FALSE);
}

//-------------------------------------------------------------
//function:Analyse Edid what suport
//-------------------------------------------------------------
#define BIT0                    0x01
#define BIT1                    0x02
#define BIT2                    0x04
#define BIT3                    0x08
#define BIT4                    0x10
#define BIT5                    0x20
#define BIT6                    0x40
#define BIT7                    0x80

//VideoParCfgType NativeTiming;
//SampleRateSupportType SampleRateSup;
//AudioBPSSupportType AudioBPSSup;

char *AudioFormatStr[16]={
    "Refer to Stream Header.",
    "LPCM.",
    "AC-3.",
    "MPEG1.",//"MPEG1(Layer1,2).",
    "MP3(Layer3).",
    "MPEG2.",//"MPEG2(multichannel).",
    "AAC.",
    "DTS.",
    "ATRAC.",
    "OneBitAudio.",//"One Bit Audio.",
    "Dolby D+.",//"Dolby Digital+.",
    "DTS-HD.",
    "MAT(MLP).",
    "DST.",
    "WMA Pro.",
    "Reserved.",
};
char *AudioSmpRStr[7]={
    "32KHz",
    "44.1KHz",
    "48KHz",
    "88KHz",
    "96KHz",
    "176KHz",
    "192KHz",
};
char *AudioSmpBStr[3]={
    "16Bit",
    "20Bit",
    "24Bit",
};
#define MAX_VALID_VIC 219 //, CTA-861-G. //107, CEA-F
char *VideoSDStr[MAX_VALID_VIC]={
    "640x480p@60Hz  4:3",//0
    "720x480p@60Hz  4:3",
    "720x480p@60Hz  16:9",
    "1280x720p@60Hz  16:9",
    "1920x1080i@60Hz  16:9",
    "720(1440)x480i@60Hz  4:3",
    "720(1440)x480i@60Hz  16:9",
    "720(1440)x240p@60Hz  4:3",
    "720(1440)x240p@60Hz  16:9",
    "2880x480i@60Hz  4:3",

    "2880x480i@60Hz  16:9",
    "2880x240p@60Hz  4:3",
    "2880x240p@60Hz  16:9",
    "1440x480p@60Hz  4:3",
    "1440x480p@60Hz  16:9",
    "1920x1080p@60Hz  16:9",
    "720x576p@50Hz  4:3",
    "720x576p@50Hz  16:9",
    "1280x720p@50Hz  16:9",
    "1920x1080i@50Hz  16:9",

    "720(1440)x576i@50Hz  4:3",
    "720(1440)x576i@50Hz  16:9",
    "720(1440)x288p@50Hz  4:3",
    "720(1440)x288p@50Hz  16:9",
    "2880x576i@50Hz  4:3",
    "2880x576i@50Hz  16:9",
    "2880x288p@50Hz  4:3",
    "2880x288p@50Hz  16:9",
    "1440x576p@50Hz  4:3",
    "1440x576p@50Hz  16:9",

    "1920x1080p@50Hz  16:9",
    "1920x1080p@24Hz  16:9",
    "1920x1080p@25Hz  16:9",
    "1920x1080p@30Hz  16:9",
    "2880x480p@60Hz  4:3",
    "2880x480p@60Hz  16:9",
    "2880x576p@50Hz  4:3",
    "2880x576p@50Hz  16:9",
    "1920x1080i(1250 total)@50Hz  16:9",
    "1920x1080i@100Hz  16:9",

    "1280x720p@100Hz  16:9",
    "720x576p@100Hz  4:3",
    "720x576p@100Hz  16:9",
    "720(1440)x576i@100Hz  4:3",
    "720(1440)x576i@100Hz  16:9",
    "1920x1080i@120Hz  16:9",
    "1280x720@120Hz  16:9",
    "720x480p@120Hz  4:3",
    "720x480p@120Hz  16:9",
    "720(1440)x480i@120Hz  4:3",

    "720(1440)x480i@120Hz  16:9",
    "720x576p@200Hz  4:3",
    "720x576p@200Hz  16:9",
    "720(1440)x576i@200Hz  4:3",
    "720(1440)x576i@200Hz  16:3",
    "720x480p@240Hz  4:3",
    "720x480p@240Hz  16:9",
    "720(1440)x480i@240Hz  4:3",
    "720(1440)x480i@240Hz  16:9",
    "1280x720p@24Hz  16:9",
    "1280x720p@25Hz  16:9",
    "1280x720p@30Hz  16:9",
    "1920x1080p@120Hz  16:9",
    "1920x1080p@100Hz  16:9",
    "1280x720p@24Hz  64:27",
    "1280x720p@25Hz  64:27",
    "1280x720p@30Hz  64:27",
    "1280x720p@50Hz  64:27",
    "1280x720p@60Hz  64:27",
    "1280x720p@100Hz  64:27",
    "1280x720p@120Hz  64:27",
    "1920x1080p@24Hz  64:27",
    "1920x1080p@25Hz  64:27",
    "1920x1080p@30Hz  64:27",
    "1920x1080p@50Hz  64:27",
    "1920x1080p@60Hz  64:27",
    "1920x1080p@100Hz  64:27",
    "1920x1080p@120Hz  64:27",
    "1680x720p@24Hz  64:27",
    "1680x720p@25Hz  64:27",
    "1680x720p@30Hz  64:27",
    "1680x720p@50Hz  64:27",
    "1680x720p@60Hz  64:27",
    "1680x720p@100Hz  64:27",
    "1680x720p@120Hz  64:27",
    "2560x1080p@24Hz  64:27",
    "2560x1080p@25Hz  64:27",
    "2560x1080p@30Hz  64:27",
    "2560x1080p@50Hz  64:27",
    "2560x1080p@60Hz  64:27",
    "2560x1080p@100Hz  64:27",
    "2560x1080p@120Hz  64:27",
    "3840x2160p@24Hz  16:9",
    "3840x2160p@25Hz  16:9",
    "3840x2160p@30Hz  16:9",
    "3840x2160p@50Hz  16:9",
    "3840x2160p@60Hz  16:9",
    "4096x2160p@24Hz  256:135",
    "4096x2160p@25Hz  256:135",
    "4096x2160p@30Hz  256:135",
    "4096x2160p@50Hz  256:135",
    "4096x2160p@60Hz  256:135",
    "3840x2160p@24Hz  64:27",
    "3840x2160p@25Hz  64:27",
    "3840x2160p@30Hz  64:27",
    "3840x2160p@50Hz  64:27",
    "3840x2160p@60Hz  64:27",

    //seven at 20200325
    "1280x720p@48Hz  16:9",//108
    "1280x720p@48Hz  64:27",
    "1680x720p@48Hz  64:27",//110
    "1920x1080p@48Hz  16:9",
    "1920x1080p@48Hz  64:27",
    "2560x1080p@48Hz  64:27",
    "3840x2160p@48Hz  16:9",
    "4096x2160p@48Hz  256:135",//115
    "3840x2160p@48Hz  64:27",
    "3840x2160p@100Hz  16:9",
    "3840x2160p@120Hz  16:9",
    "3840x2160p@100Hz  64:27",
    "3840x2160p@120Hz  64:27",//120
    "5120x2160p@24Hz  64:27",
    "5120x2160p@25Hz  64:27",
    "5120x2160p@30Hz  64:27",
    "5120x2160p@48Hz  64:27",
    "5120x2160p@50Hz  64:27",//125
    "5120x2160p@60Hz  64:27",
    "5120x2160p@100Hz  64:27",//127, index = 126
    //128~192 Forbidden
    "","","","","","","","","","",//128-137
    "","","","","","","","","","",//138-147
    "","","","","","","","","","",//148-157
    "","","","","","","","","","",//158-167
    "","","","","","","","","","",//168-177
    "","","","","","","","","","",//178-187
    "","","","","",//188-192
    "5120x2160p@120Hz  64:27",//193, index = 192
    "7680x4320p@24Hz  16:9",
    "7680x4320p@25Hz  16:9",
    "7680x4320p@30Hz  16:9",//196
    "7680x4320p@48Hz  16:9",//197
    "7680x4320p@50Hz  16:9",
    "7680x4320p@60Hz  16:9",
    "7680x4320p@100Hz  16:9",//200
    "7680x4320p@120Hz  16:9",
    "7680x4320p@24Hz  64:27",
    "7680x4320p@25Hz  64:27",
    "7680x4320p@30Hz  64:27",
    "7680x4320p@48Hz  64:27",//205
    "7680x4320p@50Hz  64:27",
    "7680x4320p@60Hz  64:27",
    "7680x4320p@100Hz  64:27",
    "7680x4320p@120Hz  64:27",
    "10240x4320p@24Hz  64:27",//210
    "10240x4320p@25Hz  64:27",
    "10240x4320p@30Hz  64:27",
    "10240x4320p@48Hz  64:27",
    "10240x4320p@50Hz  64:27",
    "10240x4320p@60Hz  64:27",//215
    "10240x4320p@100Hz  64:27",
    "10240x4320p@120Hz  64:27",
    "4096x2160p@100Hz  256:135",//218
    "4096x2160p@120Hz  256:135"//219, index = 218
    //220~255, Reserved for the Future
};
char cVideoInfo[500];
void ParseEDID::EdidAnalysseInfo(unsigned char *pEdid, char inde)
{
    unsigned int temp,i,ii,j,jj;
    unsigned short int  tempW,k;
    char DisplayInfo[14];
    bool EnReceive=false;
    char AudioBPS=0,AudioFS=0;
    unsigned short int  TempH,TempV,Temp1,Temp2;
    float tempclk;
    unsigned short int  HTotal,VTotal;
    bool bSupportHDR = false;
    //Preferred Timing
    if(inde==0){
        //			sprintf(cVideoInfo,"$sta 3 0 ");
        //////////////////////////////////////////////////////////////////Preferred Timing
        if(pEdid[0X36+17]&0x80){//Interlaced
            TempH = pEdid[0X36+2]&0x00ff;
            TempH |=(pEdid[0X36+4]&0XF0)<<4;
            TempV=pEdid[0X36+5]&0x00ff;
            TempV |=(pEdid[0X36+7]&0XF0)<<4;
            //tempclk=((float)(pEdid[0X36]))|((float)(pEdid[0X36+1]<<8));
            Temp1 = pEdid[0x36+3]&0x00ff;
            Temp2 = pEdid[0x36+4]&0x00ff;
            Temp2 = (Temp2&0X0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+3]|(pEdid[0x36+4]&0X0f)<<8;
            HTotal=TempH+tempW;
            Temp1=pEdid[0x36+6]&0x00ff;
            Temp2=pEdid[0x36+7]&0x00ff;
            Temp2=(Temp2&0x0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+6]|(pEdid[0x36+7]&0X0f)<<8;
            VTotal=TempV+tempW;
            VTotal=TempV+tempW;
            Temp1=pEdid[0X36]&0x00ff;
            Temp2=pEdid[0X36+1]&0x00ff;
            Temp2=Temp2<<8;
            tempclk=Temp1|Temp2;
            //tempclk=pEdid[0X36]|(pEdid[0X36+1]<<8);
            tempclk=tempclk*10000/HTotal/VTotal;

            TempV=2*TempV;
            sprintf(cVideoInfo,"Preferred Timing:%dx%di@%dHz \r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
            m_VideoInfoString +=cVideoInfo;
        }
        else {//Non-interlaced
            TempH = pEdid[0X36+2]&0x00ff;
            TempH |=(pEdid[0X36+4]&0XF0)<<4;
            TempV=(pEdid[0X36+5])&0x00ff;
            TempV |=(pEdid[0X36+7]&0X00F0)<<4;
            //tempclk=pEdid[0X36]|(pEdid[0X36+1]<<8);
            Temp1 = pEdid[0x36+3]&0x00ff;
            Temp2 = pEdid[0x36+4]&0x00ff;
            Temp2 = (Temp2&0X0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+3]|(pEdid[0x36+4]&0X0f)<<8;
            HTotal=TempH+tempW;
            Temp1=pEdid[0x36+6]&0x00ff;
            Temp2=pEdid[0x36+7]&0x00ff;
            Temp2=(Temp2&0x0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+6]|(pEdid[0x36+7]&0X0f)<<8;
            VTotal=TempV+tempW;
            Temp1=pEdid[0X36]&0x00ff;
            Temp2=pEdid[0X36+1]&0x00ff;
            Temp2=Temp2<<8;
            tempclk=Temp1|Temp2;
            //tempclk=pEdid[0X36]|(pEdid[0X36+1]<<8);
            tempclk=tempclk*10000/HTotal/VTotal;
            //tempclk=((pEdid[0X36]|(pEdid[0X36+1]<<8)))*10000/TempH/TempV;
            sprintf(cVideoInfo,"Preferred Timing:%dx%d@%dHz\r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
            m_VideoInfoString +=cVideoInfo;
        }
        //////////////////////////////////////////////////////////////////Detailed Timing
        for(i=0x48;i<=0x6c;i=i+18){
            if(pEdid[i]!=0x00&&pEdid[i+1]!=0x00){
                if(pEdid[i+17]&0x80){//Interlaced
                    TempH=(pEdid[i+2]&0x00ff)|(pEdid[i+4]&0X00F0)<<4;
                    TempV=(pEdid[i+5]&0x00ff)|(pEdid[i+7]&0X00F0)<<4;
                    tempW=(pEdid[i+3]&0x00ff)|(pEdid[i+4]&0X0f)<<8;
                    HTotal=TempH+tempW;
                    tempW=(pEdid[i+6]&0x00ff)|(pEdid[i+7]&0X0f)<<8;
                    VTotal=TempV+tempW;
                    tempclk=(pEdid[i]&0x00ff)|(pEdid[i+1]<<8);
                    tempclk=tempclk*10000/HTotal/VTotal;
                    TempV=2*TempV;
                    sprintf(cVideoInfo,"Detailed Timing:%dx%di@%dHz\r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
                    m_VideoInfoString +=cVideoInfo;
                }
                else {//Non-interlaced
                    TempH=(pEdid[i+2]&0x00ff)|((pEdid[i+4]&0XF0)<<4);
                    TempV=(pEdid[i+5]&0x00ff)|((pEdid[i+7]&0XF0)<<4);
                    tempW=(pEdid[i+3]&0x00ff)|((pEdid[i+4]&0X0f)<<8);
                    HTotal=TempH+tempW;
                    tempW=(pEdid[i+6]&0x00ff)|(pEdid[i+7]&0X0f)<<8;
                    VTotal=TempV+tempW;
                    tempclk=(pEdid[i]&0x00ff)|(pEdid[i+1]<<8);
                    tempclk=tempclk*10000/HTotal/VTotal;
                    sprintf(cVideoInfo,"Detailed Timing:%dx%d@%dHz\r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
                    m_VideoInfoString +=cVideoInfo;
                }

            }
        }
        //////////////////////////////////////////////////////////////////Extension Detailed Timing
        j=0;
        if((pEdid[0x7e])&&(pEdid[0x80]==0x02))
            for(k=0x0080+pEdid[0x82];k<0x00ff;k=k+18){
                if(pEdid[k]!=0x00&&pEdid[k+1]!=0x00){
                    j++;
                    if(pEdid[k+17]&0x80){//Interlaced
                        TempH=(pEdid[k+2]&0x00ff)|(pEdid[k+4]&0XF0)<<4;
                        TempV=(pEdid[k+5]&0x00ff)|(pEdid[k+7]&0XF0)<<4;
                        tempW=(pEdid[k+3]&0x00ff)|(pEdid[k+4]&0X0f)<<8;
                        HTotal=TempH+tempW;
                        tempW=(pEdid[k+6]&0x00ff)|(pEdid[k+7]&0X0f)<<8;
                        VTotal=TempV+tempW;
                        tempclk=(pEdid[k]&0x00ff)|(pEdid[k+1]<<8);
                        tempclk=tempclk*10000/HTotal/VTotal;
                        TempV=2*TempV;
                        sprintf(cVideoInfo,"Extension Detailed Timing%d:%dx%di@%dHz\r\n\0",(int)j,(int)TempH,(int)TempV,(int)(tempclk+0.5));
                        m_VideoInfoString +=cVideoInfo;
                    }
                    else {//Non-interlaced
                        TempH=(pEdid[k+2]&0x00ff)|(pEdid[k+4]&0XF0)<<4;
                        TempV=(pEdid[k+5]&0x00ff)|(pEdid[k+7]&0XF0)<<4;
                        tempW=(pEdid[k+3]&0x00ff)|(pEdid[k+4]&0X0f)<<8;
                        HTotal=TempH+tempW;
                        tempW=(pEdid[k+6]&0x00ff)|(pEdid[k+7]&0X0f)<<8;
                        VTotal=TempV+tempW;
                        tempclk=(pEdid[k]&0x00ff)|(pEdid[k+1]<<8);
                        tempclk=tempclk*10000/HTotal/VTotal;
                        sprintf(cVideoInfo,"Extension Detailed Timing%d:%dx%d@%dHz\r\n\0",(int)j,(int)TempH,(int)TempV,(int)(tempclk+0.5));
                        m_VideoInfoString +=cVideoInfo;
                    }
                }
            }
        ////////////////////////////////////////////////////////////////////Short Video Descripter
//20200323, change Native to
//        if(pEdid[0x7e]&&(pEdid[0x80]==0x02)){
//            sprintf(cVideoInfo,"\r\n\0");
//            m_VideoInfoString +=cVideoInfo;
//            sprintf(cVideoInfo,"Short Video Descripter\r\n\0");
//            m_VideoInfoString +=cVideoInfo;
//            unsigned int cMyTemp;
//            cMyTemp = (unsigned int)0x85+(pEdid[0x84]&0x1f);
//            for(i=0x85;i<cMyTemp;i++){
//                if(((pEdid[i]&0x7f)>MAX_VALID_VIC)||((pEdid[i]&0x7f)==0))//when MAX_VALID_VIC = 107
//                    continue;
//                sprintf(cVideoInfo,"%s\0",VideoSDStr[(pEdid[i]&0x7f)-1]);
//                m_VideoInfoString +=cVideoInfo;
//                if(pEdid[i]&0x80)
//                {
//                    sprintf(cVideoInfo,"  Native\0");
//                    m_VideoInfoString +=cVideoInfo;
//                }

//                sprintf(cVideoInfo,"\r\n\0");
//                m_VideoInfoString +=cVideoInfo;
//            }
//        }
                //add start 20200323, change Native to
        k=0;
        if(pEdid[0x7e]&&(pEdid[0x80]==0x02))
        {
            sprintf(cVideoInfo,"\r\n\0");
            m_VideoInfoString +=cVideoInfo;
            sprintf(cVideoInfo,"Short Video Descripter:\r\n\0");
            m_VideoInfoString +=cVideoInfo;
            for(i=0x85;i<(0x85+(pEdid[0x84]&0x1f));i++)
            {
                if(pEdid[i]==0)
                    continue;//reserved
                else if((pEdid[i]>=1)&&(pEdid[i]<=64))
//                    continue;//7-bit VIC defined(7-LSB's)and NOT a native code
                {
                    sprintf(cVideoInfo,"%s\0",VideoSDStr[pEdid[i]-1]);
                    m_VideoInfoString +=cVideoInfo;
                }
                else if((pEdid[i]>=65)&&(pEdid[i]<=127))
//                    continue;//8-bit VIC is defined(from first new set)
                {
                    sprintf(cVideoInfo,"%s\0",VideoSDStr[pEdid[i]-1]);
                    m_VideoInfoString +=cVideoInfo;
                }
                else if(pEdid[i]==128)
                    continue;//reserved
                else if((pEdid[i]>=129)&&(pEdid[i]<=192))
                {
                //7-bit VIC defined(7-LSB's)and IS a native code
                    k=1;
//                    printf2string(&tempstr[strlen(tempstr)],"%s",VideoSDStr[(pEdid[i]&0x7f)-1]);
                    sprintf(cVideoInfo,"%s\0",VideoSDStr[(pEdid[i]&0x7f)-1]);
                    m_VideoInfoString +=cVideoInfo;
                    if(pEdid[i]&0x80)
                    {
                        sprintf(cVideoInfo,"  Native\0");
                        m_VideoInfoString +=cVideoInfo;
                    }
//                    if((strlen(tempstr)>52))
//                    {
//                        CharacterDisplay(HSTAR_ADDR,VAddr+LineNum*32,strlen(tempstr2),1,tempstr2,0,BG_COLOR_WHILTE,1);
//                        printf2string(tempstr,"              ");
//                        printf2string(tempstr2,"              ");
//                        printf2string(&tempstr[strlen(tempstr)],"%s/",VideoSDStr[(pEdid[i]&0x7f)-1]);
//                        printf2string(&tempstr2[strlen(tempstr2)],"%s/",VideoSDStr[(pEdid[i]&0x7f)-1]);
//                        sprintf(cVideoInfo,"%s\r\n\0/",VideoSDStr[(pEdid[i]&0x7f)-1]);
//                        m_VideoInfoString +=cVideoInfo;
//                        LineNum++;
//                    }
//                    else
//                    {
//                        printf2string(&tempstr2[strlen(tempstr2)],"%s/",VideoSDStr[(pEdid[i]&0x7f)-1]);
//                    }
                }
                else if((pEdid[i]>=193)&&(pEdid[i]<=253))
//                    continue;//8-bit VIC is defined(from second new set)
                {
                    if(pEdid[i]<=219)
                    {
                        sprintf(cVideoInfo,"%s\0",VideoSDStr[pEdid[i]-1]);
                        m_VideoInfoString +=cVideoInfo;
                    }
                }
                else if(pEdid[i]==254)
                    continue;//reserved
                else if(pEdid[i]==255)
                    continue;//reserved

                sprintf(cVideoInfo,"\r\n\0");
                m_VideoInfoString +=cVideoInfo;

            #if 0
                if(((pEdid[i]&0x7f)>MAX_VALID_VIC)||((pEdid[i]&0x7f)==0))
                    continue;

                if(pEdid[i]&0x80)
                {
                    k=1;
                    printf2string(&tempstr[strlen(tempstr)],"%s",VideoSDStr[(pEdid[i]&0x7f)-1]);

                    if((strlen(tempstr)>52))
                    {
                        CharacterDisplay(HSTAR_ADDR2,VAddr+LineNum*32,strlen(tempstr2),1,tempstr2,0,BG_COLOR_WHILTE,1);
                        printf2string(tempstr,"              ");
                        printf2string(tempstr2,"              ");
                        printf2string(&tempstr[strlen(tempstr)],"%s/",VideoSDStr[(pEdid[i]&0x7f)-1]);
                        printf2string(&tempstr2[strlen(tempstr2)],"%s/",VideoSDStr[(pEdid[i]&0x7f)-1]);
                        LineNum++;
                    }
                    else
                    {
                        printf2string(&tempstr2[strlen(tempstr2)],"%s/",VideoSDStr[(pEdid[i]&0x7f)-1]);
                    }
                }

            #endif
            }
        }
        //add end 20200323, change Native to

        sprintf(cVideoInfo,"\r\n");
    }
    else if(inde==1){
        sprintf(cVideoInfo,"$sta 3 1 ");
        /////////////////////////////////////////////
        //vsdb audio
        if(pEdid[0x7e]&&(pEdid[0x80]==0x02)){
            for(i=4; i<pEdid[130];)//audio 2ch,6ch,8ch,dtshd
            {
                if((pEdid[128+i] & 0xE0) == 0x20) { // find tag code - Verdor Specific Data Block
                    // Vendor specific Code Tag
                    temp = (pEdid[128+i] & 0x1F) ;
                    for(j=1;j<temp;j+=3)
                    {
                        //////audio format
                        sprintf(cVideoInfo,"Audio Format:%s\r\n\0",AudioFormatStr[(pEdid[128+i+j]>>3)&0x0f]);
                        m_AudioInfoString+=cVideoInfo;
                        sprintf(cVideoInfo,"Audio Channel(s):%d\r\n\0",(int)((pEdid[128+i+j]&0x07)+1));
                        m_AudioInfoString+=cVideoInfo;
                        sprintf(cVideoInfo,"Sample Frequency:\r\n\0");
                        m_AudioInfoString+=cVideoInfo;
                        for(jj=0,ii=6;jj<7;++jj,ii--){
                            if((pEdid[128+i+j+1]>>ii)&(BIT0))
                            {
                                sprintf(cVideoInfo,"%s\r\n\0",AudioSmpRStr[ii]);
                                m_AudioInfoString+=cVideoInfo;
                            }
                        }
                        sprintf(cVideoInfo,"\r\n\0");
                        ////////////////////////
                        if(pEdid[128+i+j+1]&BIT2){
                            AudioFS=2;
                        }
                        //////////////////////////
                        if(pEdid[128+i+j+2]&0x07){
                            sprintf(cVideoInfo,"Sample Bit:\r\n\0");
                            m_AudioInfoString+=cVideoInfo;
                            for(jj=0,ii=2;jj<3;++jj,ii--){
                                if((pEdid[128+i+j+2]>>ii)&(BIT0))
                                {
                                    sprintf(cVideoInfo,"%s \r\n\0",AudioSmpBStr[ii]);
                                    m_AudioInfoString+=cVideoInfo;
                                }
                            }
                            sprintf(cVideoInfo,"\r\n\0");
                            m_AudioInfoString+=cVideoInfo;
                            //////////////////////////////////////////
                            if(pEdid[128+i+j+2]&0x07){
                                if(AudioBPS<(pEdid[128+i+j+2]&0x07))
                                    AudioBPS=pEdid[128+i+j+2]&0x07;
                            }
                            /////////////////////////////////
                        }
                        sprintf(cVideoInfo,"\r\n\0");
                        m_AudioInfoString+=cVideoInfo;
                    }
                    break;
                }
                else {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }

            /*if(siiTX_DS.siiTXInputAudioFs!=AudioFS){
                siiTX_DS.siiTXInputAudioFs=AudioFS;
                Output_Update_Flag|=(1<<SAMPLE_RATE_SEQ);
                }

            if(AudioBPS&0x04)
                siiTX_DS.siiTXInputAudioSampleLength=0x0b;
            else if(AudioBPS&0x02)
                siiTX_DS.siiTXInputAudioSampleLength=0x03;
            else
                siiTX_DS.siiTXInputAudioSampleLength=0x02;*/
        }
        sprintf(cVideoInfo,"\r\n");
        m_AudioInfoString+=cVideoInfo;
    }
    else if(inde==2){
        //sprintf(cVideoInfo,"$sta 3 2 ");
        //		sprintf(cVideoInfo,"General Info:\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;


        ////////////////////////////////other information
        //Manufacture's Name
        sprintf(cVideoInfo,"Manufacture's Name:");
        m_EdidGeneralInfo +=cVideoInfo;
        temp=(pEdid[8]>>2)&0x3f;
        temp+=0X40;
        sprintf(cVideoInfo,"%c",temp);
        m_EdidGeneralInfo +=cVideoInfo;
        //		RS232_write(&temp,1);
        temp=((pEdid[9]>>5)&0X07)|((pEdid[8]<<3)&0X18);
        temp+=0X40;
        //		if(EN_DBG)
        //		RS232_write(&temp,1);
        sprintf(cVideoInfo,"%c",temp);
        m_EdidGeneralInfo +=cVideoInfo;
        temp=pEdid[9]&0X1F;
        temp+=0X40;
        //		if(EN_DBG)
        //		RS232_write(&temp,1);
        sprintf(cVideoInfo,"%c",temp);
        m_EdidGeneralInfo +=cVideoInfo;
        sprintf(cVideoInfo,"\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;
        //Product Code
        tempW=pEdid[0X0B]<<8|pEdid[0X0A];
        sprintf(cVideoInfo,"Product Code:%d\r\n\0",(int)tempW);
        m_EdidGeneralInfo +=cVideoInfo;
        //Video Signal Interface
        sprintf(cVideoInfo,"Video Signal Interface:%s\r\n\0",((pEdid[0X14]&0x80)?"Digtal":"Analog"));
        m_EdidGeneralInfo +=cVideoInfo;
        //Color Bit Depth
        sprintf(cVideoInfo,"Color Bit Depth:Reserved\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;
        //Color Encoding Format
        //Display Product Name:
        for(i=0;i<14;i++)
            DisplayInfo[i]=0x20;
        for(i=0x36;i<0x6d;i++)
        {
            if(pEdid[i]==0 &&
                    pEdid[i+1]==0 &&
                    pEdid[i+2]==0 &&
                    pEdid[i+3]==(char)0xFC ) //moniter data tag
            {
                char indexS=i+5,indexT=0;
                while(pEdid[indexS]!= 0x0A && indexT<14)
                {
                    DisplayInfo[indexT++]=pEdid[indexS++];
                    //DBG_printf(("DisplayInfo[%x]=%x Temp_Array=%x str=%s\r\n",(int)indexT-1,(int)DisplayInfo[indexT-1],(int)Temp_Array[indexS],DisplayInfo));
                }
                //DBG_printf(("DisplayInfo[%x]=%x \r\n",(int)indexT,(int)DisplayInfo[indexT]));
                //DBG_printf(("%s\r\n",DisplayInfo));
                DisplayInfo[13]=0;//end of string
                EnReceive=true;
            }
        }
        if(EnReceive){
            sprintf(cVideoInfo,"Display Product Name:%s\r\n\0",DisplayInfo);
            m_EdidGeneralInfo +=cVideoInfo;
            EnReceive=false;
        }
        //Vertical Rate   Horizontal Rate Maximum Pixel Clock
        for(i=0;i<14;i++)
            DisplayInfo[i]=0x20;
        for(i=0x36;i<0x6d;i++)
        {
            if(pEdid[i]==0 &&
                    pEdid[i+1]==0 &&
                    pEdid[i+2]==0 &&
                    pEdid[i+3]==(char)0xFD ) //moniter data tag
            {
                sprintf(cVideoInfo,"Vertical Rate:%dHz--%dHz\r\n\0",(int)pEdid[i+5],(int)pEdid[i+6]);
                m_EdidGeneralInfo +=cVideoInfo;
                sprintf(cVideoInfo,"Horizontal Rate:%dKHz--%dKHz\r\n\0",(int)pEdid[i+7],(int)pEdid[i+8]);
                m_EdidGeneralInfo +=cVideoInfo;
                sprintf(cVideoInfo,"Maximum Pixel Clock:%dMHz\r\n\0",(int)(pEdid[i+9]*10));
                m_EdidGeneralInfo +=cVideoInfo;
            }
        }

        if(pEdid[0x7e]&&(pEdid[0x80]==0x02)){
            //Extension Device Support:
            if(pEdid[0x83]&0X70){
                sprintf(cVideoInfo,"Extension Device Support:\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
                if(pEdid[0x83]&BIT6)
                {
                    sprintf(cVideoInfo,"Base Audio\r\n\0");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                if(pEdid[0x83]&BIT5)
                {
                    sprintf(cVideoInfo,"YCbCr4:4:4\r\n\0");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                if(pEdid[0x83]&BIT4)
                {
                    sprintf(cVideoInfo,"YCbCr4:2:2\r\n\0");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                sprintf(cVideoInfo,"\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
            }
            //Native Timings:
            ii=0;
            for(i=4; i<pEdid[130];)//1080P
            {
                if((pEdid[128+i] & 0xE0) == 0x40) { // find tag code - Verdor Specific Data Block
                    // Vendor specific Code Tag
                    temp = (pEdid[128+i] & 0x1F) ;
                    for(j=1;j<=temp;++j)
                    {
                        if(pEdid[128+i+j]&0x80)
                        {
                            ii++;
                        }

                    }
                    break;
                }
                else {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }
            sprintf(cVideoInfo,"Native Timings:%d\r\n\0",(int)ii);
            m_EdidGeneralInfo +=cVideoInfo;
            //Deep Color:
            ii=0;
            for(i=4; i<pEdid[130];)
            {
                if((pEdid[128+i] & 0xE0) == 0x60) { // find tag code - Verdor Specific Data Block
                    // Vendor specific Code Tag
                    temp = (pEdid[128+i] & 0x1F) ;
                    if(temp>=6)	{
                        if(!(pEdid[128+i+6]& 0x70))
                            ii = 0;   // 24 bit capability
                        if(pEdid[128+i+6]& 0x40)
                            ii|= 0x40;   // 48 bit capability
                        if(pEdid[128+i+6]& 0x20)
                            ii|= 0x20;   // 36 bit capability
                        if(pEdid[128+i+6]& 0x10)
                            ii|=0x10;   // 30 bit capability
                        if(pEdid[128+i+6]& 0x08)
                            ii|=0x08;   // dc y444
                    }
                    else{
                        ii= 0;   // 24 bit capability
                    }
                    break;
                }
                else {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }

            if(ii&0x70){
                sprintf(cVideoInfo,"Deep Color:\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
                if(ii&0x40)
                {
                    sprintf(cVideoInfo,"48Bit ");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                if(ii&0x20)
                {
                    sprintf(cVideoInfo,"36Bit ");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                if(ii&0x10)
                {
                    sprintf(cVideoInfo,"30Bit ");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                sprintf(cVideoInfo,"\r\n\0");
            }
            ///YCbCr444 in Deep Color modes:
            if(ii&0x08)
            {
                sprintf(cVideoInfo,"YCbCr444 DeepColor:support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
            }
            else
            {
                sprintf(cVideoInfo,"YCbCr444 DeepColor:not support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
            }

            /// 3D Present,and 4Kx2K VIC  cooper131018
            ii=0;
            jj=0;
            for(i=4; i<pEdid[130];)
            {
                if((pEdid[128+i] & 0xE0) == 0x60)  // find tag code - Verdor Specific Data Block
                {
                    temp = (pEdid[128+i] & 0x1F) ;
                    if(temp>=8)
                    {
                        if(pEdid[128+i+8]&BIT5)//find HDMI_VIDEO_PRESENT
                        {
                            temp=1;
                            if(pEdid[128+i+8]&BIT7)
                                temp+=2;
                            if(pEdid[128+i+8]&BIT6)
                                temp+=2;
                            if(pEdid[128+i+8+temp]&BIT7)//fine 3D Present
                            {
                                ii=1;

                            }

                            if(pEdid[128+i+8+temp+1]&(BIT7|BIT6|BIT5))//fine HMID_VIC_LEN
                            {
                                jj=(pEdid[128+i+8+temp+1]>>5)&0x7;
                                j=128+i+8+temp+1;
                            }
                        }
                    }
                    break;
                }
                else
                {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }

            if(ii)
            {
                sprintf(cVideoInfo,"3D video:support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
                sprintf(cVideoInfo,"\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
            }
            else
            {
                sprintf(cVideoInfo,"3D video:not support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
                sprintf(cVideoInfo,"\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
            }

            if(jj)
            {
                sprintf(cVideoInfo,"Extended Resolution(4Kx2K):\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
                for(i=0;i<jj;i++)
                {
                    switch(pEdid[++j])
                    {
                    case 1:
                        sprintf(cVideoInfo,"4Kx2K@30Hz\r\n\0");
                        m_EdidGeneralInfo +=cVideoInfo;
                        break;
                    case 2:
                        sprintf(cVideoInfo,"4Kx2K@25Hz\r\n\0");
                        m_EdidGeneralInfo +=cVideoInfo;
                        break;
                    case 3:
                        sprintf(cVideoInfo,"4Kx2K@24Hz\r\n\0");
                        m_EdidGeneralInfo +=cVideoInfo;
                        break;
                    case 4:
                        sprintf(cVideoInfo,"4Kx2K@24Hz(SMPTE)\r\n\0");
                        m_EdidGeneralInfo +=cVideoInfo;
                        break;
                    default:
                        break;
                    }
                }
            }


        }

        ////Find Y420VDB and  cooper131018
        ii=0;
        jj=0;
        for(i=4; i<pEdid[130];)
        {
            //                        if((pEdid[128+i] & 0xE0) == 0x70)  // find tag code - Y420VDB
            if((pEdid[128+i] & 0xE0) == 0xE0)  // find tag code - Y420VDB
            {

                temp = (pEdid[128+i] & 0x1F)-1 ;
                if((pEdid[128+i+1]) ==0x0e)//Y420VDB
                {

                    sprintf(cVideoInfo,"\r\nY420VDB Descripter :\r\n\0");
                    m_EdidGeneralInfo +=cVideoInfo;

                    for(j=0;j<temp;j++)
                    {
                        //                                    RS232_printf("%s",VideoSDStr[(pEdid[130+i+j])-1]);
                        //                                    RS232_printf("<br/>");
                        sprintf(cVideoInfo,"%s\r\n\0",VideoSDStr[(pEdid[130+i+j])-1]);
                        m_EdidGeneralInfo +=cVideoInfo;


                    }
                }
                else if((pEdid[128+i+1] & 0x1F) ==0x0f)//Y420CMDB
                {
                    //                                RS232_printf("<br/>");
                    //                                RS232_printf("Y420CMDB Descripter :<br/>");
                    sprintf(cVideoInfo,"\r\nY420CMDB Descripter :\r\n\0");
                    m_EdidGeneralInfo +=cVideoInfo;

                    if(temp==0)
                    {
                        //                                    RS232_printf("All SVDs do support YUV420<br/>");
                        sprintf(cVideoInfo,"All SVDs do support YUV420\r\n\0");
                        m_EdidGeneralInfo +=cVideoInfo;

                        for(j=(char)0x85;j<((char)0x85+(pEdid[0x84]&0x1f));j++)
                        {
                            if(((pEdid[i]&0x7f)>MAX_VALID_VIC)||((pEdid[i]&0x7f)==0))//Cooper140207
                                continue;


                        }

                    }
                    else
                    {
                        for(j=0;j<temp;j++)
                        {
                            for(jj=0;jj<8;jj++)
                            {
                                if(pEdid[130+i+j]&(1<<jj))
                                {
                                    ii=j*8+jj;

                                    if(((pEdid[(char)0x85+ii]&0x7f)>MAX_VALID_VIC)||((pEdid[(char)0x85+ii]&0x7f)==0))//Cooper140207
                                        continue;

                                    //                                                RS232_printf("%s",VideoSDStr[(pEdid[0x85+ii])-1]);
                                    //                                                RS232_printf("<br/>");
                                    sprintf(cVideoInfo,"%s\r\n\0",VideoSDStr[(pEdid[0x85+ii])-1]);
                                    m_EdidGeneralInfo +=cVideoInfo;


                                }
                            }
                        }
                    }

                }
                else if((pEdid[128+i+1] & 0x1F) ==0x06)//HDR
                {
                    bSupportHDR=true;
                }
                i += (pEdid[128+i] & 0x1F) +1;//cooper151217

                //                            break;
            }
            else
            {
                i += (pEdid[128+i] & 0x1F) +1;
            }
        }

        sprintf(cVideoInfo,"\r\nHDR :");
        m_EdidGeneralInfo +=cVideoInfo;
        if(bSupportHDR == true)
            sprintf(cVideoInfo,"Support\r\n\0");
        else
            sprintf(cVideoInfo,"Not support\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;




        sprintf(cVideoInfo,"\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;
    }
    QList<QString> qls;
    qls.append(m_StatusChkSum);
    qls.append(m_EdidAll);
    qls.append(m_EdidGeneralInfo);
    qls.append(m_VideoInfoString);
    qls.append(m_AudioInfoString);
    emit signalEDID(qls);
}

//void ParseEDID::OnButtonEdidSave(QString filePath)
//{
//    tools->saveDatas(filePath, m_cEDIDBuf_SHOW, 256, 0);
//}

void ParseEDID::OnButtonEdidOpen(QString filePathName)
{
    int length = 0;
//    tools->openDatas(filePathName, m_cEDIDBuf, &length);

    //Fill the m_EdidAll with the data read from file.
    char CBufTemp[10];
    char cTemp;
    int j;

    m_EdidAll = "";
    //        m_StatusChkSum = "";
    m_VideoInfoString = "";
    m_AudioInfoString = "";
    m_EdidGeneralInfo = "";

    for(j=0;j<256;j++)
    {
        cTemp = m_cEDIDBuf[j]&0x0f;
        if(cTemp>9)
        {
            CBufTemp[1]= 'A';
            CBufTemp[1] += (cTemp - 10);// + m_cEDIDBuf[j]&0x0f;
        }
        else
        {
            CBufTemp[1]= '0';
            CBufTemp[1] += cTemp;// + m_cEDIDBuf[j]&0x0f;
        }
        cTemp = m_cEDIDBuf[j];
        cTemp = cTemp>>4;
        cTemp = cTemp&0x0f;
        if(cTemp>9)
        {
            CBufTemp[0]= 'A';
            CBufTemp[0] += (cTemp -10);
        }
        else
        {
            CBufTemp[0]= '0';
            CBufTemp[0] += cTemp;
        }
        CBufTemp[2] = ' ';
        m_EdidAll+=CBufTemp[0];
        m_EdidAll+=CBufTemp[1];
        m_EdidAll+=CBufTemp[2];
        //			}
    }

    EdidAnalysseInfo((unsigned char*)m_cEDIDBuf,0);
    EdidAnalysseInfo((unsigned char*)m_cEDIDBuf,1);
    EdidAnalysseInfo((unsigned char*)m_cEDIDBuf,2);

    m_cEDIDBuf_SHOW = m_cEDIDBuf;

    //edid2 and edid3
    if(length==384)
    {
        QList<QString> qls;
        QString edidStr;
        edidStr.append("02 ");
        for(int i=0; i<128; i++)
        {
            edidStr.append(QStringLiteral("%1").arg((unsigned char)m_cEDIDBuf[256+i], 2, 16, QLatin1Char('0')).toUpper()+" ");
        }
        qls.append(edidStr);
        emit signalEDID(qls);
    }
    else if(length==512)
    {
        QList<QString> qls;
        QString edidStr;
        edidStr.append("02 ");
        for(int i=0; i<128; i++)
        {
            edidStr.append(QStringLiteral("%1").arg((unsigned char)m_cEDIDBuf[256+i], 2, 16, QLatin1Char('0')).toUpper()+" ");
        }
        qls.append(edidStr);
        emit signalEDID(qls);
        qls.clear();
        edidStr.clear();
        edidStr.append("03 ");
        for(int i=0; i<128; i++)
        {
            edidStr.append(QStringLiteral("%1").arg((unsigned char)m_cEDIDBuf[384+i], 2, 16, QLatin1Char('0')).toUpper()+" ");
        }
        qls.append(edidStr);
        emit signalEDID(qls);
    }
}

//AutoTiming
void ParseEDID::getSimpleParseEDID(char *cEDIDBuf)
{
    m_cEDIDBuf_SHOW = cEDIDBuf;
    char CBufTemp[10];
    char cTemp;
    int j;

    m_EdidAll = "";
    m_StatusChkSum = "";
    m_VideoInfoString = "";
    m_AudioInfoString = "";
    m_EdidGeneralInfo = "";

    if(m_cEDIDBuf_SHOW[0] != 0x00 || m_cEDIDBuf_SHOW[1] != (char)0xff || m_cEDIDBuf_SHOW[2] != (char)0xff
            || m_cEDIDBuf_SHOW[3] != (char)0xff || m_cEDIDBuf_SHOW[4] != (char)0xff || m_cEDIDBuf_SHOW[5] != (char)0xff
            || m_cEDIDBuf_SHOW[6] != (char)0xff || m_cEDIDBuf_SHOW[7] != (char)0x00)
    {
        m_StatusChkSum = "EDID data header error !";
        QList<QString> qls;
        qls.append(m_StatusChkSum);
        qls.append(m_EdidAll);
        qls.append(m_EdidGeneralInfo);
        qls.append(m_VideoInfoString);
        qls.append(m_AudioInfoString);
        emit signalEDIDAutoTiming(qls);
    }
    else
    {
        if(m_cEDIDBuf_SHOW[126] == 0)
        {
            m_StatusChkSum = "DVI EDID";
            cTemp = 0;
            for(j=0;j<128;j++)
            {
                cTemp += m_cEDIDBuf_SHOW[j];
            }
            if(cTemp !=0)
                m_StatusChkSum += "\rCheck sum error !";
        }
        else
        {
            char cStatusTmp = 0;
            m_StatusChkSum = "HDMI EDID";
            cTemp = 0;
            for(j=0;j<128;j++)
            {
                cTemp += m_cEDIDBuf_SHOW[j];
            }
            if(cTemp != 0)
            {
                m_StatusChkSum += "\rBank0 check sum error !";
                cStatusTmp = 1;
            }
            cTemp = 0;
            for(j=128;j<256;j++)
            {
                cTemp += m_cEDIDBuf_SHOW[j];
            }
            if(cTemp != 0)
            {
                m_StatusChkSum += "\rBank1 check sum error !";
            }
            else
            {
                if(cStatusTmp == 1)
                    m_StatusChkSum += "\rBank1 check sum Ok !";
                else
                    m_StatusChkSum += "\rcheck sum Ok !";
            }

        }
//        for(j=0;j<128;j++)
//        {

//        }

        for(j=0;j<256;j++)
        {
            cTemp = m_cEDIDBuf_SHOW[j]&0x0f;
            if(cTemp>9)
            {
                CBufTemp[1]= 'A';
                CBufTemp[1] += (cTemp - 10);// + m_cEDIDBuf_SHOW[j]&0x0f;
            }
            else
            {
                CBufTemp[1]= '0';
                CBufTemp[1] += cTemp;// + m_cEDIDBuf_SHOW[j]&0x0f;
            }
            cTemp = m_cEDIDBuf_SHOW[j];
            cTemp = cTemp>>4;
            cTemp = cTemp&0x0f;
            if(cTemp>9)
            {
                CBufTemp[0]= 'A';
                CBufTemp[0] += (cTemp -10);
            }
            else
            {
                CBufTemp[0]= '0';
                CBufTemp[0] += cTemp;
            }
            CBufTemp[2] = ' ';
            m_EdidAll+=CBufTemp[0];
            m_EdidAll+=CBufTemp[1];
            m_EdidAll+=CBufTemp[2];
        }

        EdidAnalysseInfoAutoTiming(m_cEDIDBuf_SHOW,0);
        EdidAnalysseInfoAutoTiming(m_cEDIDBuf_SHOW,1);
        EdidAnalysseInfoAutoTiming(m_cEDIDBuf_SHOW,2);
    }
}

void ParseEDID::EdidAnalysseInfoAutoTiming(char *pEdid, char inde)
{
    unsigned int temp,i,ii,j,jj;
    unsigned short int  tempW,k;
    char DisplayInfo[14];
    bool EnReceive=false;
    char AudioBPS=0,AudioFS=0;
    unsigned short int  TempH,TempV,Temp1,Temp2;
    float tempclk;
    unsigned short int  HTotal,VTotal;
    bool bSupportHDR = false;
    //Preferred Timing
    if(inde==0){
        //			sprintf(cVideoInfo,"$sta 3 0 ");
        //////////////////////////////////////////////////////////////////Preferred Timing
        if(pEdid[0X36+17]&0x80){//Interlaced
            TempH = pEdid[0X36+2]&0x00ff;
            TempH |=(pEdid[0X36+4]&0XF0)<<4;
            TempV=pEdid[0X36+5]&0x00ff;
            TempV |=(pEdid[0X36+7]&0XF0)<<4;
            //tempclk=((float)(pEdid[0X36]))|((float)(pEdid[0X36+1]<<8));
            Temp1 = pEdid[0x36+3]&0x00ff;
            Temp2 = pEdid[0x36+4]&0x00ff;
            Temp2 = (Temp2&0X0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+3]|(pEdid[0x36+4]&0X0f)<<8;
            HTotal=TempH+tempW;
            Temp1=pEdid[0x36+6]&0x00ff;
            Temp2=pEdid[0x36+7]&0x00ff;
            Temp2=(Temp2&0x0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+6]|(pEdid[0x36+7]&0X0f)<<8;
            VTotal=TempV+tempW;
            VTotal=TempV+tempW;
            Temp1=pEdid[0X36]&0x00ff;
            Temp2=pEdid[0X36+1]&0x00ff;
            Temp2=Temp2<<8;
            tempclk=Temp1|Temp2;
            //tempclk=pEdid[0X36]|(pEdid[0X36+1]<<8);
            tempclk=tempclk*10000/HTotal/VTotal;

            TempV=2*TempV;
            sprintf(cVideoInfo,"Preferred Timing:%dx%di@%dHz \r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
            m_VideoInfoString +=cVideoInfo;
        }
        else {//Non-interlaced
            TempH = pEdid[0X36+2]&0x00ff;
            TempH |=(pEdid[0X36+4]&0XF0)<<4;
            TempV=(pEdid[0X36+5])&0x00ff;
            TempV |=(pEdid[0X36+7]&0X00F0)<<4;
            //tempclk=pEdid[0X36]|(pEdid[0X36+1]<<8);
            Temp1 = pEdid[0x36+3]&0x00ff;
            Temp2 = pEdid[0x36+4]&0x00ff;
            Temp2 = (Temp2&0X0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+3]|(pEdid[0x36+4]&0X0f)<<8;
            HTotal=TempH+tempW;
            Temp1=pEdid[0x36+6]&0x00ff;
            Temp2=pEdid[0x36+7]&0x00ff;
            Temp2=(Temp2&0x0f)<<8;
            tempW=Temp1|Temp2;
            //tempW=pEdid[0x36+6]|(pEdid[0x36+7]&0X0f)<<8;
            VTotal=TempV+tempW;
            Temp1=pEdid[0X36]&0x00ff;
            Temp2=pEdid[0X36+1]&0x00ff;
            Temp2=Temp2<<8;
            tempclk=Temp1|Temp2;
            //tempclk=pEdid[0X36]|(pEdid[0X36+1]<<8);
            tempclk=tempclk*10000/HTotal/VTotal;
            //tempclk=((pEdid[0X36]|(pEdid[0X36+1]<<8)))*10000/TempH/TempV;
            sprintf(cVideoInfo,"Preferred Timing:%dx%d@%dHz\r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
            m_VideoInfoString +=cVideoInfo;
        }
        //////////////////////////////////////////////////////////////////Detailed Timing
//        for(i=0x48;i<=0x6c;i=i+18){
//            if(pEdid[i]!=0x00&&pEdid[i+1]!=0x00){
//                if(pEdid[i+17]&0x80){//Interlaced
//                    TempH=(pEdid[i+2]&0x00ff)|(pEdid[i+4]&0X00F0)<<4;
//                    TempV=(pEdid[i+5]&0x00ff)|(pEdid[i+7]&0X00F0)<<4;
//                    tempW=(pEdid[i+3]&0x00ff)|(pEdid[i+4]&0X0f)<<8;
//                    HTotal=TempH+tempW;
//                    tempW=(pEdid[i+6]&0x00ff)|(pEdid[i+7]&0X0f)<<8;
//                    VTotal=TempV+tempW;
//                    tempclk=(pEdid[i]&0x00ff)|(pEdid[i+1]<<8);
//                    tempclk=tempclk*10000/HTotal/VTotal;
//                    TempV=2*TempV;
//                    sprintf(cVideoInfo,"Detailed Timing:%dx%di@%dHz\r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
//                    m_VideoInfoString +=cVideoInfo;
//                }
//                else {//Non-interlaced
//                    TempH=(pEdid[i+2]&0x00ff)|((pEdid[i+4]&0XF0)<<4);
//                    TempV=(pEdid[i+5]&0x00ff)|((pEdid[i+7]&0XF0)<<4);
//                    tempW=(pEdid[i+3]&0x00ff)|((pEdid[i+4]&0X0f)<<8);
//                    HTotal=TempH+tempW;
//                    tempW=(pEdid[i+6]&0x00ff)|(pEdid[i+7]&0X0f)<<8;
//                    VTotal=TempV+tempW;
//                    tempclk=(pEdid[i]&0x00ff)|(pEdid[i+1]<<8);
//                    tempclk=tempclk*10000/HTotal/VTotal;
//                    sprintf(cVideoInfo,"Detailed Timing:%dx%d@%dHz\r\n\0",(int)TempH,(int)TempV,(int)(tempclk+0.5));
//                    m_VideoInfoString +=cVideoInfo;
//                }

//            }
//        }
        //////////////////////////////////////////////////////////////////Extension Detailed Timing
//        j=0;
//        if((pEdid[0x7e])&&(pEdid[0x80]==0x02))
//            for(k=0x0080+pEdid[0x82];k<0x00ff;k=k+18){
//                if(pEdid[k]!=0x00&&pEdid[k+1]!=0x00){
//                    j++;
//                    if(pEdid[k+17]&0x80){//Interlaced
//                        TempH=(pEdid[k+2]&0x00ff)|(pEdid[k+4]&0XF0)<<4;
//                        TempV=(pEdid[k+5]&0x00ff)|(pEdid[k+7]&0XF0)<<4;
//                        tempW=(pEdid[k+3]&0x00ff)|(pEdid[k+4]&0X0f)<<8;
//                        HTotal=TempH+tempW;
//                        tempW=(pEdid[k+6]&0x00ff)|(pEdid[k+7]&0X0f)<<8;
//                        VTotal=TempV+tempW;
//                        tempclk=(pEdid[k]&0x00ff)|(pEdid[k+1]<<8);
//                        tempclk=tempclk*10000/HTotal/VTotal;
//                        TempV=2*TempV;
//                        sprintf(cVideoInfo,"Extension Detailed Timing%d:%dx%di@%dHz\r\n\0",(int)j,(int)TempH,(int)TempV,(int)(tempclk+0.5));
//                        m_VideoInfoString +=cVideoInfo;
//                    }
//                    else {//Non-interlaced
//                        TempH=(pEdid[k+2]&0x00ff)|(pEdid[k+4]&0XF0)<<4;
//                        TempV=(pEdid[k+5]&0x00ff)|(pEdid[k+7]&0XF0)<<4;
//                        tempW=(pEdid[k+3]&0x00ff)|(pEdid[k+4]&0X0f)<<8;
//                        HTotal=TempH+tempW;
//                        tempW=(pEdid[k+6]&0x00ff)|(pEdid[k+7]&0X0f)<<8;
//                        VTotal=TempV+tempW;
//                        tempclk=(pEdid[k]&0x00ff)|(pEdid[k+1]<<8);
//                        tempclk=tempclk*10000/HTotal/VTotal;
//                        sprintf(cVideoInfo,"Extension Detailed Timing%d:%dx%d@%dHz\r\n\0",(int)j,(int)TempH,(int)TempV,(int)(tempclk+0.5));
//                        m_VideoInfoString +=cVideoInfo;
//                    }
//                }
//            }
        ////////////////////////////////////////////////////////////////////Short Video Descripter
//        if(pEdid[0x7e]&&(pEdid[0x80]==0x02)){
//            sprintf(cVideoInfo,"\r\n\0");
//            m_VideoInfoString +=cVideoInfo;
//            sprintf(cVideoInfo,"Short Video Descripter\r\n\0");
//            m_VideoInfoString +=cVideoInfo;
//            unsigned int cMyTemp;
//            cMyTemp = (unsigned int)0x85+(pEdid[0x84]&0x1f);
//            for(i=0x85;i<cMyTemp;i++){
//                if(((pEdid[i]&0x7f)>MAX_VALID_VIC)||((pEdid[i]&0x7f)==0))
//                    continue;
//                sprintf(cVideoInfo,"%s\0",VideoSDStr[(pEdid[i]&0x7f)-1]);
//                m_VideoInfoString +=cVideoInfo;
//                if(pEdid[i]&0x80)
//                {
//                    sprintf(cVideoInfo,"  Native\0");
//                    m_VideoInfoString +=cVideoInfo;
//                }

//                sprintf(cVideoInfo,"\r\n\0");
//                m_VideoInfoString +=cVideoInfo;
//            }
//        }
        sprintf(cVideoInfo,"\r\n");
    }
    else if(inde==1){
        sprintf(cVideoInfo,"$sta 3 1 ");
        /////////////////////////////////////////////
        //vsdb audio
        if(pEdid[0x7e]&&(pEdid[0x80]==0x02)){
            for(i=4; i<pEdid[130];)//audio 2ch,6ch,8ch,dtshd
            {
                if((pEdid[128+i] & 0xE0) == 0x20) { // find tag code - Verdor Specific Data Block
                    // Vendor specific Code Tag
                    temp = (pEdid[128+i] & 0x1F) ;
                    for(j=1;j<temp;j+=3)
                    {
                        //////audio format
                        sprintf(cVideoInfo,"Audio Format:%s\r\n\0",AudioFormatStr[(pEdid[128+i+j]>>3)&0x0f]);
                        m_AudioInfoString+=cVideoInfo;
                        sprintf(cVideoInfo,"Audio Channel(s):%d\r\n\0",(int)((pEdid[128+i+j]&0x07)+1));
                        m_AudioInfoString+=cVideoInfo;
//                        sprintf(cVideoInfo,"Sample Frequency:\r\n\0");
//                        m_AudioInfoString+=cVideoInfo;
//                        for(jj=0,ii=6;jj<7;++jj,ii--){
//                            if((pEdid[128+i+j+1]>>ii)&(BIT0))
//                            {
//                                sprintf(cVideoInfo,"%s\r\n\0",AudioSmpRStr[ii]);
//                                m_AudioInfoString+=cVideoInfo;
//                            }
//                        }
//                        sprintf(cVideoInfo,"\r\n\0");
                        ////////////////////////
                        if(pEdid[128+i+j+1]&BIT2){
                            AudioFS=2;
                        }
                        //////////////////////////
//                        if(pEdid[128+i+j+2]&0x07){
//                            sprintf(cVideoInfo,"Sample Bit:\r\n\0");
//                            m_AudioInfoString+=cVideoInfo;
//                            for(jj=0,ii=2;jj<3;++jj,ii--){
//                                if((pEdid[128+i+j+2]>>ii)&(BIT0))
//                                {
//                                    sprintf(cVideoInfo,"%s \r\n\0",AudioSmpBStr[ii]);
//                                    m_AudioInfoString+=cVideoInfo;
//                                }
//                            }
//                            sprintf(cVideoInfo,"\r\n\0");
//                            m_AudioInfoString+=cVideoInfo;
//                            //////////////////////////////////////////
//                            if(pEdid[128+i+j+2]&0x07){
//                                if(AudioBPS<(pEdid[128+i+j+2]&0x07))
//                                    AudioBPS=pEdid[128+i+j+2]&0x07;
//                            }
//                            /////////////////////////////////
//                        }
                        sprintf(cVideoInfo,"\r\n\0");
                        m_AudioInfoString+=cVideoInfo;
                    }
                    break;
                }
                else {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }

            /*if(siiTX_DS.siiTXInputAudioFs!=AudioFS){
                siiTX_DS.siiTXInputAudioFs=AudioFS;
                Output_Update_Flag|=(1<<SAMPLE_RATE_SEQ);
                }

            if(AudioBPS&0x04)
                siiTX_DS.siiTXInputAudioSampleLength=0x0b;
            else if(AudioBPS&0x02)
                siiTX_DS.siiTXInputAudioSampleLength=0x03;
            else
                siiTX_DS.siiTXInputAudioSampleLength=0x02;*/
        }
        sprintf(cVideoInfo,"\r\n");
        m_AudioInfoString+=cVideoInfo;
    }
    else if(inde==2){
        //sprintf(cVideoInfo,"$sta 3 2 ");
        //		sprintf(cVideoInfo,"General Info:\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;


        ////////////////////////////////other information
        //Manufacture's Name
        sprintf(cVideoInfo,"Manufacture's Name:");
        m_EdidGeneralInfo +=cVideoInfo;
        temp=(pEdid[8]>>2)&0x3f;
        temp+=0X40;
        sprintf(cVideoInfo,"%c",temp);
        m_EdidGeneralInfo +=cVideoInfo;
        //		RS232_write(&temp,1);
        temp=((pEdid[9]>>5)&0X07)|((pEdid[8]<<3)&0X18);
        temp+=0X40;
        //		if(EN_DBG)
        //		RS232_write(&temp,1);
        sprintf(cVideoInfo,"%c",temp);
        m_EdidGeneralInfo +=cVideoInfo;
        temp=pEdid[9]&0X1F;
        temp+=0X40;
        //		if(EN_DBG)
        //		RS232_write(&temp,1);
        sprintf(cVideoInfo,"%c",temp);
        m_EdidGeneralInfo +=cVideoInfo;
        sprintf(cVideoInfo,"\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;
        //Product Code
//        tempW=pEdid[0X0B]<<8|pEdid[0X0A];
//        sprintf(cVideoInfo,"Product Code:%d\r\n\0",(int)tempW);
//        m_EdidGeneralInfo +=cVideoInfo;
        //Video Signal Interface
//        sprintf(cVideoInfo,"Video Signal Interface:%s\r\n\0",((pEdid[0X14]&0x80)?"Digtal":"Analog"));
//        m_EdidGeneralInfo +=cVideoInfo;
        //Color Bit Depth
//        sprintf(cVideoInfo,"Color Bit Depth:Reserved\r\n\0");
//        m_EdidGeneralInfo +=cVideoInfo;
        //Color Encoding Format
        //Display Product Name:
        for(i=0;i<14;i++)
            DisplayInfo[i]=0x20;
        for(i=0x36;i<0x6d;i++)
        {
            if(pEdid[i]==0 &&
                    pEdid[i+1]==0 &&
                    pEdid[i+2]==0 &&
                    pEdid[i+3]==(char)0xFC ) //moniter data tag
            {
                char indexS=i+5,indexT=0;
                while(pEdid[indexS]!= 0x0A && indexT<14)
                {
                    DisplayInfo[indexT++]=pEdid[indexS++];
                    //DBG_printf(("DisplayInfo[%x]=%x Temp_Array=%x str=%s\r\n",(int)indexT-1,(int)DisplayInfo[indexT-1],(int)Temp_Array[indexS],DisplayInfo));
                }
                //DBG_printf(("DisplayInfo[%x]=%x \r\n",(int)indexT,(int)DisplayInfo[indexT]));
                //DBG_printf(("%s\r\n",DisplayInfo));
                DisplayInfo[13]=0;//end of string
                EnReceive=true;
            }
        }
        if(EnReceive){
            sprintf(cVideoInfo,"Display Product Name:%s\r\n\0",DisplayInfo);
            m_EdidGeneralInfo +=cVideoInfo;
            EnReceive=false;
        }
        //Vertical Rate   Horizontal Rate Maximum Pixel Clock
        for(i=0;i<14;i++)
            DisplayInfo[i]=0x20;
//        for(i=0x36;i<0x6d;i++)
//        {
//            if(pEdid[i]==0 &&
//                    pEdid[i+1]==0 &&
//                    pEdid[i+2]==0 &&
//                    pEdid[i+3]==(char)0xFD ) //moniter data tag
//            {
//                sprintf(cVideoInfo,"Vertical Rate:%dHz--%dHz\r\n\0",(int)pEdid[i+5],(int)pEdid[i+6]);
//                m_EdidGeneralInfo +=cVideoInfo;
//                sprintf(cVideoInfo,"Horizontal Rate:%dKHz--%dKHz\r\n\0",(int)pEdid[i+7],(int)pEdid[i+8]);
//                m_EdidGeneralInfo +=cVideoInfo;
//                sprintf(cVideoInfo,"Maximum Pixel Clock:%dMHz\r\n\0",(int)(pEdid[i+9]*10));
//                m_EdidGeneralInfo +=cVideoInfo;
//            }
//        }

        if(pEdid[0x7e]&&(pEdid[0x80]==0x02)){
//            //Extension Device Support:
//            if(pEdid[0x83]&0X70){
//                sprintf(cVideoInfo,"Extension Device Support:\r\n\0");
//                m_EdidGeneralInfo +=cVideoInfo;
//                if(pEdid[0x83]&BIT6)
//                {
//                    sprintf(cVideoInfo,"Base Audio\r\n\0");
//                    m_EdidGeneralInfo +=cVideoInfo;
//                }
//                if(pEdid[0x83]&BIT5)
//                {
//                    sprintf(cVideoInfo,"YCbCr4:4:4\r\n\0");
//                    m_EdidGeneralInfo +=cVideoInfo;
//                }
//                if(pEdid[0x83]&BIT4)
//                {
//                    sprintf(cVideoInfo,"YCbCr4:2:2\r\n\0");
//                    m_EdidGeneralInfo +=cVideoInfo;
//                }
//                sprintf(cVideoInfo,"\r\n\0");
//                m_EdidGeneralInfo +=cVideoInfo;
//            }
            //Native Timings:
            ii=0;
            for(i=4; i<pEdid[130];)//1080P
            {
                if((pEdid[128+i] & 0xE0) == 0x40) { // find tag code - Verdor Specific Data Block
                    // Vendor specific Code Tag
                    temp = (pEdid[128+i] & 0x1F) ;
                    for(j=1;j<=temp;++j)
                    {
                        if(pEdid[128+i+j]&0x80)
                        {
                            ii++;
                        }

                    }
                    break;
                }
                else {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }
            sprintf(cVideoInfo,"Native Timings:%d\r\n\0",(int)ii);
            m_EdidGeneralInfo +=cVideoInfo;
            //Deep Color:
            ii=0;
            for(i=4; i<pEdid[130];)
            {
                if((pEdid[128+i] & 0xE0) == 0x60) { // find tag code - Verdor Specific Data Block
                    // Vendor specific Code Tag
                    temp = (pEdid[128+i] & 0x1F) ;
                    if(temp>=6)	{
                        if(!(pEdid[128+i+6]& 0x70))
                            ii = 0;   // 24 bit capability
                        if(pEdid[128+i+6]& 0x40)
                            ii|= 0x40;   // 48 bit capability
                        if(pEdid[128+i+6]& 0x20)
                            ii|= 0x20;   // 36 bit capability
                        if(pEdid[128+i+6]& 0x10)
                            ii|=0x10;   // 30 bit capability
                        if(pEdid[128+i+6]& 0x08)
                            ii|=0x08;   // dc y444
                    }
                    else{
                        ii= 0;   // 24 bit capability
                    }
                    break;
                }
                else {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }

            if(ii&0x70){
                sprintf(cVideoInfo,"Deep Color:\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
                if(ii&0x40)
                {
                    sprintf(cVideoInfo,"48Bit ");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                if(ii&0x20)
                {
                    sprintf(cVideoInfo,"36Bit ");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                if(ii&0x10)
                {
                    sprintf(cVideoInfo,"30Bit ");
                    m_EdidGeneralInfo +=cVideoInfo;
                }
                sprintf(cVideoInfo,"\r\n\0");
            }
            ///YCbCr444 in Deep Color modes:
            if(ii&0x08)
            {
                sprintf(cVideoInfo,"YCbCr444 DeepColor:support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
            }
            else
            {
                sprintf(cVideoInfo,"YCbCr444 DeepColor:not support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
            }

            /// 3D Present,and 4Kx2K VIC  cooper131018
            ii=0;
            jj=0;
            for(i=4; i<pEdid[130];)
            {
                if((pEdid[128+i] & 0xE0) == 0x60)  // find tag code - Verdor Specific Data Block
                {
                    temp = (pEdid[128+i] & 0x1F) ;
                    if(temp>=8)
                    {
                        if(pEdid[128+i+8]&BIT5)//find HDMI_VIDEO_PRESENT
                        {
                            temp=1;
                            if(pEdid[128+i+8]&BIT7)
                                temp+=2;
                            if(pEdid[128+i+8]&BIT6)
                                temp+=2;
                            if(pEdid[128+i+8+temp]&BIT7)//fine 3D Present
                            {
                                ii=1;

                            }

                            if(pEdid[128+i+8+temp+1]&(BIT7|BIT6|BIT5))//fine HMID_VIC_LEN
                            {
                                jj=(pEdid[128+i+8+temp+1]>>5)&0x7;
                                j=128+i+8+temp+1;
                            }
                        }
                    }
                    break;
                }
                else
                {
                    i += (pEdid[128+i] & 0x1F) +1;
                }
            }

            if(ii)
            {
                sprintf(cVideoInfo,"3D video:support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
//                sprintf(cVideoInfo,"\r\n\0");
//                m_EdidGeneralInfo +=cVideoInfo;
            }
            else
            {
                sprintf(cVideoInfo,"3D video:not support\r\n\0");
                m_EdidGeneralInfo +=cVideoInfo;
//                sprintf(cVideoInfo,"\r\n\0");
//                m_EdidGeneralInfo +=cVideoInfo;
            }

//            if(jj)
//            {
//                sprintf(cVideoInfo,"Extended Resolution(4Kx2K):\r\n\0");
//                m_EdidGeneralInfo +=cVideoInfo;
//                for(i=0;i<jj;i++)
//                {
//                    switch(pEdid[++j])
//                    {
//                    case 1:
//                        sprintf(cVideoInfo,"4Kx2K@30Hz\r\n\0");
//                        m_EdidGeneralInfo +=cVideoInfo;
//                        break;
//                    case 2:
//                        sprintf(cVideoInfo,"4Kx2K@25Hz\r\n\0");
//                        m_EdidGeneralInfo +=cVideoInfo;
//                        break;
//                    case 3:
//                        sprintf(cVideoInfo,"4Kx2K@24Hz\r\n\0");
//                        m_EdidGeneralInfo +=cVideoInfo;
//                        break;
//                    case 4:
//                        sprintf(cVideoInfo,"4Kx2K@24Hz(SMPTE)\r\n\0");
//                        m_EdidGeneralInfo +=cVideoInfo;
//                        break;
//                    default:
//                        break;
//                    }
//                }
//            }

        }

        ////Find Y420VDB and  cooper131018
        ii=0;
        jj=0;
        for(i=4; i<pEdid[130];)
        {
            //                        if((pEdid[128+i] & 0xE0) == 0x70)  // find tag code - Y420VDB
            if((pEdid[128+i] & 0xE0) == 0xE0)  // find tag code - Y420VDB
            {

                temp = (pEdid[128+i] & 0x1F)-1 ;
                if((pEdid[128+i+1]) ==0x0e)//Y420VDB
                {

                    sprintf(cVideoInfo,"\r\nY420VDB Descripter :\r\n\0");
                    m_EdidGeneralInfo +=cVideoInfo;

                    for(j=0;j<temp;j++)
                    {
                        //                                    RS232_printf("%s",VideoSDStr[(pEdid[130+i+j])-1]);
                        //                                    RS232_printf("<br/>");
                        sprintf(cVideoInfo,"%s\r\n\0",VideoSDStr[(pEdid[130+i+j])-1]);
                        m_EdidGeneralInfo +=cVideoInfo;


                    }
                }
                else if((pEdid[128+i+1] & 0x1F) ==0x0f)//Y420CMDB
                {
                    //                                RS232_printf("<br/>");
                    //                                RS232_printf("Y420CMDB Descripter :<br/>");
                    sprintf(cVideoInfo,"\r\nY420CMDB Descripter :\r\n\0");
                    m_EdidGeneralInfo +=cVideoInfo;

                    if(temp==0)
                    {
                        //                                    RS232_printf("All SVDs do support YUV420<br/>");
                        sprintf(cVideoInfo,"All SVDs do support YUV420\r\n\0");
                        m_EdidGeneralInfo +=cVideoInfo;

                        for(j=(char)0x85;j<((char)0x85+(pEdid[0x84]&0x1f));j++)
                        {
                            if(((pEdid[i]&0x7f)>MAX_VALID_VIC)||((pEdid[i]&0x7f)==0))//Cooper140207
                                continue;


                        }

                    }
                    else
                    {
                        for(j=0;j<temp;j++)
                        {
                            for(jj=0;jj<8;jj++)
                            {
                                if(pEdid[130+i+j]&(1<<jj))
                                {
                                    ii=j*8+jj;

                                    if(((pEdid[(char)0x85+ii]&0x7f)>MAX_VALID_VIC)||((pEdid[(char)0x85+ii]&0x7f)==0))//Cooper140207
                                        continue;

                                    //                                                RS232_printf("%s",VideoSDStr[(pEdid[0x85+ii])-1]);
                                    //                                                RS232_printf("<br/>");
                                    sprintf(cVideoInfo,"%s\r\n\0",VideoSDStr[(pEdid[0x85+ii])-1]);
                                    m_EdidGeneralInfo +=cVideoInfo;


                                }
                            }
                        }
                    }

                }
                else if((pEdid[128+i+1] & 0x1F) ==0x06)//HDR
                {
                    bSupportHDR=true;
                }
                i += (pEdid[128+i] & 0x1F) +1;//cooper151217

                //                            break;
            }
            else
            {
                i += (pEdid[128+i] & 0x1F) +1;
            }
        }

        sprintf(cVideoInfo,"\r\nHDR :");
        m_EdidGeneralInfo +=cVideoInfo;
        if(bSupportHDR == true)
            sprintf(cVideoInfo,"Support\r\n\0");
        else
            sprintf(cVideoInfo,"Not support\r\n\0");
        m_EdidGeneralInfo +=cVideoInfo;

//        sprintf(cVideoInfo,"\r\n\0");
//        m_EdidGeneralInfo +=cVideoInfo;
    }
//    qDebug()<<"|1|:"<<m_EdidGeneralInfo;
//    qDebug()<<"|2|:"<<m_VideoInfoString;
//    qDebug()<<"|3|:"<<m_AudioInfoString;

    QList<QString> qls;
    qls.append(m_StatusChkSum);
    qls.append(m_EdidAll);
    qls.append(m_EdidGeneralInfo);
    qls.append(m_VideoInfoString);
    qls.append(m_AudioInfoString);
    emit signalEDIDAutoTiming(qls);
}
