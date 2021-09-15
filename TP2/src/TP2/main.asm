.include "m328pdef.inc"

.cseg
.org 0							
	jmp inicio

.org 2
	jmp interrupcion0

.org 4
	jmp interrupcion1
								
inicio:	
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r16, low(RAMEND)
	out SPL, r16				; Inicializo stack		
	ldi r16, 0x3f				
	out DDRC, r16				; Configuro los pines C0 a C5 como salidas
	ldi r16, 0x0f
	sts EICRA, r16				; Configuro INT0 e INT1 como interrupciones por flanco ascendente
	ldi r16, 0x03
	out EIMSK, r16				; Habilito INT0 e INT1
	sei							; Seteo flag I
	
				
desplazamiento_leds:
	sbi PORTC, PC5				; Enciendo el led del pin C5
	ldi r17, 5
derecha:						; Desplazo hacia la derecha los bits del PORTC
	call delay
	in r21, PORTC
	lsr r21
	out PORTC, r21
	dec r17
	brne derecha

	ldi r17, 5
izquierda:						; Desplazo hacia la izquierda los bits del PORTC
	call delay
	in r21, PORTC
	lsl r21
	out PORTC, r21
	dec r17
	brne izquierda
	jmp desplazamiento_leds




delay:							; Delay de 8000000 ciclos (0.5s)
	ldi r18, 41
	ldi r19, 150
	ldi r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ret


/*
Interrupcion INT0: los LEDs de los extremos parpadean
a una frecuencia de 1 Hz, y los centrales se apagan
*/
interrupcion0:
	push r16		; Apilo en el stack el registro r16
	in r16, sreg	
	push r16		; Apilo en el stack el registro de estados
	in r16, PORTC	
	push r16		; Apilo en el stack el estado del puerto C
	ldi r16, 0
	out PORTC, r16	; Apago todos los leds
	ldi r16, 15
parpadear:			
	sbi PORTC, PC0
	sbi PORTC, PC5	; Enciendo los leds de los extremos
	call delay
	cbi PORTC, PC0
	cbi PORTC, PC5	; Apago los leds de los extremos
	call delay
	dec r16
	brne parpadear
	sbi EIFR, 0		; Limpio el bit de flag de INT0
	pop r16
	out PORTC, r16	; Desapilo el estado del puerto C
	pop r16
	out sreg, r16	; Desapilo el registro de estados
	pop r16			; Desapilo el registro 16
	reti	


/*
Interrupcion INT1: los LEDs reflejan el contenido del
registro r16, que incrementa desde 0 hasta 63
*/
interrupcion1:
	push r16		; Apilo en el stack el registro r16
	in r16, sreg	
	push r16		; Apilo en el stack el registro de estados
	in r16, PORTC	
	push r16		; Apilo en el stack el estado del puerto C
	ldi r16, 0
contador:
	out portc, r16	; Actualizo el puerto C con el contenido de r16
	call delay
	inc r16
	cpi r16, 64
	brne contador
	nop
	sbi eifr, 1		; Limpio el bit de flag de INT0
	pop r16
	out PORTC, r16	; Desapilo el estado del puerto C
	pop r16
	out sreg, r16	; Desapilo el registro de estados
	pop r16			; Desapilo el registro 16
	reti