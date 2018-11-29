#include "SPI_SOFTWARE.h"


void    SPI_SENDBYTE(unsigned char  data,unsigned char action)
{
    unsigned char   i;
    for(i=0;i<8;i++)
    {
        if((data & 0x80) == 0x80)    DO_SPI_MOSI_HIGHT;
        else    DO_SPI_MOSI_LOW;
        data <<= 1;
        DO_SPI_SCK_HIGHT;
        DO_SPI_SCK_LOW;
    }
    if(action)
    {
        DO_SPI_LATCH_HIGHT;
        DO_SPI_LATCH_LOW;
    }
}