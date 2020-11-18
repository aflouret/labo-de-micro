.org 0000
        rjmp prog

		
.org 0x02
		rjmp interrupcion0

.org 0x04
		rjmp interrupcion1


prog:
        ;Inicializa stack
        ldi r20,high(ramend)   
        out sph,r20
        ldi r20,low(ramend)
        out spl,r20
		
		ldi r21, 0x00
		sts OCR1AH, r21
		ldi r22, 0x01
		sts OCR1AL, r22

		ldi r16, (1<<COM1A1)|(1<<WGM10)
		sts TCCR1A, r16

		ldi r16, (1<<WGM12)|(1<<CS10)
		sts TCCR1B, r16

		ldi r16, 0x0f
		sts EICRA, r16				; Configuro INT0 e INT1 como interrupciones por flanco ascendente
		ldi r16, 0x03
		out EIMSK, r16				; Habilito INT0 e INT1

		sei

		ldi r16, 0xFF
		out ddrb, r16

here:	
		rjmp here
		

interrupcion0:	
		lds r16, OCR1AL
		cpi r16, 0xFF
		breq salida_int0
		sec
		rol r16
		sts OCR1AL, r16
		call delay
		sbi EIFR, 0x00
salida_int0:	
		reti


interrupcion1:
		
		lds r16, OCR1AL
		cpi r16, 0x00
		breq salida_int1
		lsr r16
		sts OCR1AL, r16
		call delay
		sbi EIFR, 0x01
salida_int1:
		reti


; Assembly code auto-generated
; by utility from Bret Mulvey
; Delay 3 200 000 cycles
; 200ms at 16.0 MHz
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
