
#define NUM_LED_SCAN 2
#define TIME_LED_BLINK  250



extern unsigned int    Uint_data_led1;
extern unsigned int    Uint_data_led2;
extern unsigned int    Uint_data_led3;
extern unsigned int    Uint_data_led4;

extern  bit Bit_led_1_warning;
extern  bit Bit_led_2_warning;
extern  bit Bit_led_3_warning;
extern  bit Bit_led_4_warning;

void    SCAN_LED(void);