#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include "uart.h"
#include "timer.h"
#include "adc.h"
#include "pwm.h"
#define BAUD 57600


int main(void)
{
	pwm_init();
	uart_init(57600);
	timer_capture_init();
		
	uint16_t capture_value = timer_measure_period();
	char capture_value_str[6];
	sprintf(capture_value_str, "Medicion modo captura: %05u\n", capture_value);
	uart_send_string(capture_value_str);

	uart_send_string("Valores ADC:\n");

	adc_init();
	
    while (1)
	{
		int adc_value = adc_read(); 
		
		char adc_value_str[5];
		sprintf(adc_value_str, "%04d", adc_value);
		
		uart_send_string(adc_value_str);
			
		uart_send_character('\n');	
	}
}



