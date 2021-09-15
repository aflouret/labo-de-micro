#include <avr/io.h>
#include <avr/interrupt.h>


// Escribe el valor del registro del ADC en el puerto D
// e inicia la conversion nuevamente
ISR(ADC_vect)
{
	PORTD = ADCH;			
	ADCSRA |= (1<<ADSC);
}

int main(void)
{
	// Configura puerto D como salida
	DDRD = 0xFF;
	
	// Configura ADC con entrada simple en PC2, alineado a izquierda y prescaler CLK/128,
	// habilita interrupcion e inicia conversion
	ADMUX = (1<<ADLAR)|(1<<MUX1);
	ADCSRA = (1<<ADEN)|(1<<ADSC)|(1<<ADIE)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
	
	sei();
	
	while(1);
}



