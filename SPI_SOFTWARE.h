#include "mega88.h"

#define DO_SPI_MOSI PORTB.3//PORTD.2//
#define DO_SPI_SCK  PORTB.5//PORTB.3//
#define DO_SPI_LATCH    PORTD.2

#define DO_SPI_MOSI_HIGHT   DO_SPI_MOSI = 1
#define DO_SPI_MOSI_LOW     DO_SPI_MOSI = 0

#define DO_SPI_SCK_HIGHT    DO_SPI_SCK = 1
#define DO_SPI_SCK_LOW      DO_SPI_SCK = 0

#define DO_SPI_LATCH_HIGHT  DO_SPI_LATCH = 1
#define DO_SPI_LATCH_LOW    DO_SPI_LATCH = 0



void    SPI_SENDBYTE(unsigned char  data,unsigned char action);