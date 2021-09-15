#include <avr/io.h>
#include <avr/interrupt.h>
#include "uart.h"
#define F_CLOCK  16000000

void uart_init(uint16_t baudrate)
{
	//Habilita transmision de datos
	UCSR0B = (1<<TXEN0);
	//Configuracion 8N1: 8 bits de datos, sin bit de paridad y 1 bit de stop
	UCSR0C = (1<<UCSZ01)|(1<<UCSZ00);
	
	UBRR0L = (F_CLOCK/16/baudrate)-1;
	UBRR0H = ((F_CLOCK/16/baudrate)-1)>>8;
}

void uart_send_character(char c)
{
	while(!(UCSR0A & (1<<UDRE0)));
	UDR0 = c;
}

void uart_send_string(char* str)
{
	for(int i=0; str[i]!='\0'; i++)
	uart_send_character(str[i]);
}