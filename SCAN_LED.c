#include "scan_led.h"
#include "SPI_SOFTWARE.h"

unsigned int    Uint_data_led1 = 0;
unsigned int    Uint_data_led2 = 0;
unsigned int    Uint_data_led3 = 0;
unsigned int    Uint_data_led4 = 0;
unsigned char   Uc_Select_led=1;

unsigned char   BCDLED[11]={0xF9,0x21,0xEA,0x6B,0x33,0x5B,0xDB,0x29,0xFB,0x7B,0x02};

/* Day du lieu quet led qua duong spi_software
Co thẻ day tu 1 den 3 byte du lieu.
Du lieu sau khi day ra day du moi tien hanh xuat du lieu
num_bytes : so byte duoc day ra
data_first : du lieu dau tien
data_second: du lieu thu 2
data_third ; du lieu thu 3
*/
void    SEND_DATA_LED(unsigned char num_bytes,unsigned char  byte_1,unsigned char  byte_2,unsigned char  byte_3)
{
    unsigned char   i;
    unsigned char   data[6];
    for(i=0;i<6;i++)    data[i] = 0;
    data[0] = byte_1;
    data[1] = byte_2;
    data[2] = byte_3;

    for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
    SPI_SENDBYTE(data[i],1);
}


/* 
Ham quet led
num_led: Thu tu led
data: Du lieu hien thi tren led.
*/
void    SCAN_LED(void)
{
    unsigned char   byte1,byte2,byte3;
    unsigned char    data;
    unsigned char   bit_left;
    bit_left = 0x01;
    byte1 = 0;
    byte2 = 0;
    byte3 = 0;

    Uc_Select_led++;
    bit_left <<= (Uc_Select_led-1);
    if(Uc_Select_led > 8)   
    {
        Uc_Select_led = 1;
        bit_left = 0x01;
    }
    /* 7-seg 1*/
    data = Uint_data_led1/1000;
    byte1 = BCDLED[10];
    // byte1 = 0xFE;
    if((byte1 & bit_left)) byte3 |= 0x04;
    data = Uint_data_led1/100%10;
    byte1 = BCDLED[data];
    // byte1 = 0x06;
    if(byte1 & bit_left) byte3 |= 0x08;
    data = Uint_data_led1/10%10;
    byte1 = BCDLED[data];
    byte1 |= 0x04;
    // byte1 = 0x06;
    if(byte1 & bit_left) byte3 |= 0x10;
    data = Uint_data_led1%10;
    byte1 = BCDLED[data];
    // byte1 = 0x06;
    if(byte1 & bit_left) byte2 |= 0x10;
    /* 7-seg 2 */
    data = Uint_data_led2/1000;
    byte1 = BCDLED[10];
    if(byte1 & bit_left) byte2 |= 0x20;
    data = Uint_data_led2/100%10;
    byte1 = BCDLED[data];
    byte1 |= 0x04;
    if(byte1 & bit_left) byte2 |= 0x08;
    data = Uint_data_led2/10%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte2 |= 0x04;
    data = Uint_data_led2%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte2 |= 0x01;
    /* 7-seg 3 */
    data = Uint_data_led3/1000;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x20;
    data = Uint_data_led3/100%10;
    byte1 = BCDLED[data];
    // byte1 |= 0x80;
    if(byte1 & bit_left) byte3 |= 0x40;
    data = Uint_data_led3/10%10;
    byte1 = BCDLED[data];
    byte1 |= 0x04;
    if(byte1 & bit_left) byte3 |= 0x80;
    data = Uint_data_led3%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x02; 
    /* 7-seg 4 */
    data = Uint_data_led4/1000;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x01; //2
    data = Uint_data_led4/100%10;
    byte1 = BCDLED[data];
    byte1 |= 0x04;
    if(byte1 & bit_left) byte2 |= 0x40;
    data = Uint_data_led4/10%10;
    byte1 = BCDLED[data];
    // byte1 |= 0x80;
    if(byte1 & bit_left) byte2 |= 0x80; //7
    data = Uint_data_led4%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte2 |= 0x02;
    bit_left = 0xff- bit_left;
    SEND_DATA_LED(3,byte3,byte2,bit_left);
}

