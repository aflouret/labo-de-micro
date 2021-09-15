#include <avr/io.h>
#include <avr/interrupt.h>
#include "adc.h"

void adc_init(void)
{
	// Configura ADC con entrada simple en PC2 y prescaler CLK/128
	ADMUX = (1<<REFS0)|(1<<MUX1);
	ADCSRA = (1<<ADEN)|(1<<ADSC)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
}

uint16_t adc_read(void)
{
	ADCSRA |= (1<<ADSC);
	while(!(ADCSRA&(1<<ADIF)));
	return ADC;
}