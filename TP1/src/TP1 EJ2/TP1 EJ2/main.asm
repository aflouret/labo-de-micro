.include "m328pdef.inc"

; Defino las constantes correspondientes a los pines que voy a utilizar
.equ pin_led = PD2
.equ pin_pulsador_1 = PB0
.equ pin_pulsador_2 = PD7

.cseg
.org	0


inicio:
	cbi PORTD, pin_led				; Inicializo el pin del led con un 0 logico
	sbi DDRD, pin_led				; Configuro el pin del led como salida
	cbi DDRB, pin_pulsador_1		; Configuro los pines de los pulsadores como entradas
	cbi DDRD, pin_pulsador_2		
l0:	sbis PINB, pin_pulsador_1		; Mientras el pulsador 1 no se presione, seguira en el loop. Si se presiona, salta a parpadear
	jmp l0							
parpadear:
	sbi PORTD, pin_led			
	call delay
	cbi PORTD, pin_led
	call delay
	jmp parpadear


delay:
	ldi r18, 41
	ldi r19, 150
	ldi r20, 128
l1: dec r20							
	sbic PIND, pin_pulsador_2		;  Mientras el pulsador 2 no se presione, continuara el delay. Si se presiona, apaga el led y retorna
	jmp apagar_led
	brne l1
	dec r19
	brne l1
	dec r18
	brne l1
	ret
apagar_led:
	pop r21
	pop r21
	jmp inicio


