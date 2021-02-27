#include <avr/io.h>
#include <avr/interrupt.h>
#include "timer.h"

void timer_capture_init(void)
{
	TCCR1A = 0;
	TCCR1B = (1<<ICES1)|(1<<CS10)|(1<<CS12);//flanco ascendente, 1024 prescaler, sin cancelacion de ruido
}

uint16_t timer_measure_period(void)
{
	uint16_t capture_value;
	while(!(TIFR1&(1<<ICF1)));
	capture_value = ICR1;
	TIFR1 = 1<<ICF1;
	while(!(TIFR1&(1<<ICF1)));
	return ICR1 - capture_value;
}