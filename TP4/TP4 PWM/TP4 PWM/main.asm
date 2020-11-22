.equ pin_led = PB1

.org 0000
        rjmp inicio

		
.org 0x02
		rjmp interrupcion_pulsador0

.org 0x04
		rjmp interrupcion_pulsador1


inicio:
        ;Inicializa stack
        ldi r20,high(ramend)   
        out sph,r20
        ldi r20,low(ramend)
        out spl,r20
		
		; Inicializa el registro de comparacion del timer 1
		ldi r21, 0x00
		sts OCR1AH, r21
		ldi r22, 0x01
		sts OCR1AL, r22

		; Configura el timer en modo 5 (Fast PWM, 8-bit), non-inverting
		ldi r16, (1<<COM1A1)|(1<<WGM10)
		sts TCCR1A, r16
		ldi r16, (1<<WGM12)|(1<<CS10)
		sts TCCR1B, r16

		; Habilita INT0 e INT1 como interrupciones por flanco ascendente
		ldi r16, (1<<ISC11)|(1<<ISC10)|(1<<ISC01)|(1<<ISC00)
		sts EICRA, r16				
		ldi r16, (1<<INT1)|(1<<INT0)
		out EIMSK, r16				

		sbi DDRB, pin_led		; Configura el pin del led como salida

		sei		; Habilita interrupciones globales

esperar:	
		rjmp esperar	; Espera que se presione algun pulsador
		
; Aumenta el valor del registro OCR, si el valor no es el maximo (0xFF)
interrupcion_pulsador0:	
		lds r16, OCR1AL
		cpi r16, 0xFF
		breq salida_int0
		sec
		rol r16
		sts OCR1AL, r16
		; Llama a la rutina de delay y limpia el flag de interrupcion,
		; para evitar que la interrupcion se ejecute dos veces por el rebote
		call delay
		sbi EIFR, 0x00
salida_int0:	
		reti

; Disminuye el valor del registro OCR, si el valor no es el minimo (0x00)
interrupcion_pulsador1:	
		lds r16, OCR1AL
		cpi r16, 0x00
		breq salida_int1
		lsr r16
		sts OCR1AL, r16
		; Llama a la rutina de delay y limpia el flag de interrupcion,
		; para evitar que la interrupcion se ejecute dos veces por el rebote
		call delay	
		sbi EIFR, 0x01
salida_int1:
		reti



; Delay de 200ms (3200000 ciclos)
delay:
    ldi  r18, 17
    ldi  r19, 60
    ldi  r20, 204
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ret
