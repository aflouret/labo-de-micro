.org 0000
        rjmp prog

.org OVF1addr
    rjmp onOVF1addr

prog:
        ;Inicializa stack
        ldi r20,high (ramend)   
        out sph,r20
        ldi r20,low (ramend)
        out spl,r20
		

		ldi r20, (1<<TOIE1)
		sts TIMSK1, r20        ; Habilita interrupcion por overflow

		sei

		ldi r16, 0
		sbi ddrb,0


main:	in r17, PORTB
		ldi r16, 1
		eor r17, r16
		out PORTB, r17
		call seleccionar_modo
		ldi r20, 0xD0
		sts TCNT1H, r20
		sts TCNT1L, r20	;inicializo contador
		call delay
		rjmp main


/*seleccionar_modo:
		ldi r20, 0
		sbis PIND, 0
		rjmp casox0
		sbis PIND, 1
		rjmp caso01
		ldi r20, 0b00000101
		rjmp salida
caso01:	ldi r20, 0b00000100
		rjmp salida
casox0:	sbis PIND, 1
		rjmp caso00
		ldi r20, 0b00000011
		rjmp salida
caso00:	sbi PORTB, 0
		rjmp seleccionar_modo
salida:	sts TCCR1B, r20
		ret*/



seleccionar_modo:
		in r16, PIND
		andi r16, 0b00000011
caso0:	cpi r16, 0x00000000
		brne caso1
		sbi PORTB, 0
		ldi r20, 0b00000000
		rjmp seleccionar_modo
caso1:	cpi r16, 0b00000010
		brne caso2
		ldi r20, 0b00000011
		rjmp salida
caso2:	cpi r16, 0b00000001
		brne caso3
		ldi r20, 0b00000100
		rjmp salida
caso3:	cpi r16, 0b00000011
		brne salida
		ldi r20, 0b00000101
salida:	sts TCCR1B, r20
		ret

		


onOVF1addr:
	push r16
	in r16, sreg
	push r16
	inc r18
	pop r16
	out sreg, r16
	pop r16
    reti   

delay:
		clr r18          
sec_count:
		cpi r18, 1      
		brne sec_count           
		ret