.include "m328pdef.inc"

.equ pin_led = PD2				; Defino como constante el pin donde se conecta el led (PD2)

.cseg
.org 0							

								
inicio:							
	sbi DDRD, pin_led			; Configuro el pin del led como salida
parpadear:
	sbi PORTD, pin_led			; Enciendo el led
	call delay					; Delay 0.5s
	cbi PORTD, pin_led			; Apago el led
	call delay					; Delay 0.5s
	jmp parpadear


delay:							; Delay de 8000000 ciclos (0.5s)
	ldi r18, 41
	ldi r19, 150
	ldi r20, 128
l1: dec r20
	brne l1
	dec r19
	brne l1
	dec r18
	brne l1
	ret