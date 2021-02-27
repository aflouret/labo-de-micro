#include <avr/io.h>
#include <avr/interrupt.h>
#include "pwm.h"

void pwm_init(void)
{
	//Configura PD6 (OC0A) como salida
	DDRD = 1<<PD6;
	//Configura PWM en modo Fast PWM non-inverted
	TCCR0A = (1<<COM0A1)|(1<<WGM01)|(1<<WGM00);
	//Prescaler: clk/1024 -> Frecuencia: 16M/256/1024 = 61.035 Hz
	TCCR0B = (1<<CS02)|(1<<CS00);
	//Duty cycle: 50%
	OCR0A = 128;
}
