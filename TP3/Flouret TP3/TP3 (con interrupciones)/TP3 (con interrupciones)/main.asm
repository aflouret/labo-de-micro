.include "m328pdef.inc"

.equ    F_CPU = 16000000
.equ    baud = 9600   
.equ    bps    = (F_CPU/16/baud) - 1

.org 0x0000
    rjmp setup

.org URXCaddr
	rjmp interrupcion_recepcion

.org UDREaddr
	rjmp interrupcion_transmision

mensaje:
    .db    "*** Hola Labo de Micro ***", $0D, $0A, "Escriba 1, 2, 3 o 4 para controlar los LEDs", $0A, 0, 0

setup:
	; Inicializa el stack
    ldi r16, LOW(RAMEND)   
    out SPL, r16
    ldi r16, HIGH(RAMEND)   
    out SPH, r16						
    
	; Configura baudrate
    ldi r16, LOW(bps)            
    ldi r17, HIGH(bps)
	sts UBRR0L, r16		    
    sts UBRR0H, r17						
	         
	; Habilita transmision, recepcion e interrupciones    
    ldi r16,(1<<RXEN0)|(1<<TXEN0)|(1<<RXCIE0)|(1<<UDRIE0)		
    sts UCSR0B,r16                   

    ldi r16, (1<<UCSZ00)|(1<<UCSZ01);	; Configuracion 8N1: 8 bits de datos, 
    sts UCSR0C, r16						; sin bit de paridad y 1 bit de stop

	ldi r16, 0x0f				
	out DDRC, r16				; Configura los pines C0 a C3 como salidas
        
	ldi zl, LOW(mensaje<<1)     ; Carga el puntero al mensaje constante en zh:zl
    ldi zh, HIGH(mensaje<<1)
	
	rcall delay					; Delay de 2s para abrir el terminal serie

	sei							; Habilita interrupciones

esperar_interrupcion:
	rjmp esperar_interrupcion	

; Transmite por el puerto serie el mensaje guardado en la memoria flash
interrupcion_transmision:
	push r16
	in r16, sreg
	push r16
	push r17 	 
	lpm	r16, z+					; Carga un byte del mensaje al registro r16, e incrementa el puntero
	tst r16						; Chequea fin de string
    breq finalizar_transmision	; En caso de fin, termina la transmision del mensaje
	sts UDR0, r16				; Transmite el byte  
	rjmp salida_interrupcion_transmision	            
finalizar_transmision:
	lds r16, UCSR0B			
	cbr r16, (1<<UDRIE0)
	sts UCSR0B, r16
salida_interrupcion_transmision:
	pop r17
	pop r16
	out sreg, r16
	pop r16
	reti
	
; Recibe por el puerto serie un digito ('1', '2', '3' o '4') y togglea 
; el led conectado al pin del puerto C 1, 2, 3 o 4, respectivamente	
interrupcion_recepcion:
	push r16
	in r16, sreg
	push r16
	push r17
	push r18
	push r19 
	ldi r16, 0b00000001		; Define una mascara
	lds r17, UDR0			; Carga los datos del buffer en r17
;Compara el byte recibido con cada simbolo hasta encontrarlo, y desplaza 
;la mascara hacia la izquierda para que se corresponda con el bit a modificar
c1:	cpi r17, '1'			
	brne c2
	call toggle
c2: lsl r16
	cpi r17, '2'
	brne c3
	call toggle
c3: lsl r16
	cpi r17, '3'
	brne c4
	call toggle
c4: lsl r16
	cpi r17, '4'
	brne salida_interrupcion_recepcion
	call toggle
salida_interrupcion_recepcion:
	pop r19
	pop r18
	pop r17
	pop r16
	out sreg, r16
	pop r16
	reti

; Invierte un bit del puerto C utilizando la mascara (r16)	
toggle:
	in r18, PORTC	; Lee puerto C
	mov r19, r18	; Copia puerto C para modificarlo con la mascara
	and r19, r16	
	cpi r19, 0		; Verifica si el led seleccionado esta prendido o apagado
	breq prender	; Si esta apagado, va a prender
apagar:
	com r16			
	and r18, r16	; r18 and not r16
	com r16			; Revierte r16 al estado original
	jmp salida_toggle
prender:
	or r18, r16		; r18 or r16
salida_toggle:
	out PORTC, r18	; Escribe puerto C
	ret


; Delay de 32000000 ciclos (2s)
delay:							
	ldi r20, 163
	ldi r21, 87
	ldi r22, 3
L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1
	ret
        

