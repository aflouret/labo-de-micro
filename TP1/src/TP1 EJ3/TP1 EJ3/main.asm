.include "m328pdef.inc"

; Defino las constantes correspondientes a los pines que voy a utilizar
.equ pin_led = PD2
.equ pin_pulsador_1 = PB0
.equ pin_pulsador_2 = PD7

.cseg
.org	0


inicio:
	cbi PORTD, pin_led					; Inicializo el pin del led con un 0 logico	
	sbi DDRD, pin_led					; Configuro el pin como salida	
	
	sbi PORTB, pin_pulsador_1			; Activo resistencia de pull up interna del pin correspondiente al pulsador 1
	cbi DDRB, pin_pulsador_1			; Configuro el pin como entrada		
	
	sbi PORTD, pin_pulsador_2			; Activo resistencia de pull up interna del pin correspondiente al pulsador 1
	cbi DDRD, pin_pulsador_2			; Configuro el pin como entrada
		
l0:	sbic PINB, pin_pulsador_1			; Mientras el pulsador 1 no se presione, seguira en el loop. Si se presiona, salta a parpadear
	jmp l0
	
parpadear:
	sbi PORTD, 2
	call delay
	cbi PORTD, 2
	call delay
	jmp parpadear

	
delay:
	ldi r18, 41
	ldi r19, 150
	ldi r20, 128
l1: dec r20
	sbis PIND, 7						;  Mientras el pulsador 2 no se presione, continuara el delay. Si se presiona, salta a inicio
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



