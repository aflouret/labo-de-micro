#ifndef _UART_H_
#define _UART_H_

void uart_init(uint16_t);
void uart_send_character(char);
void uart_send_string(char*);

#endif