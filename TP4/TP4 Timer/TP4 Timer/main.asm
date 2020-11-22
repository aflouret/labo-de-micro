.def overflow = r18
.equ valor_inicial_TCNT1 = -16000
.equ pin_led = PB0

.org 0
        rjmp inicio

.org OVF1addr
    rjmp interrupcion_overflow

inicio: 
		;Inicializa stack
        ldi r16, high(RAMEND)   
        out SPH, r16
        ldi r16, low(RAMEND)
        out SPL, r16
		
		ldi r16, (1<<TOIE1)
		sts TIMSK1, r16			; Habilita interrupcion por overflow

		sbi DDRB, pin_led		; Configura el pin del led como salida

		sei						
		

main:	call toggle_led
		call seleccionar_modo
		call inicializar_contador
		clr overflow
loop:	cpi overflow, 1
		brne loop	; espera que se ejecute la interrupcion por overflow      
		rjmp main


; Configura el timer segun los pulsadores presionados
seleccionar_modo:
		in r16, PIND
		andi r16, 0b00001100
caso0:	cpi r16, 0x00000000
		brne caso1
		; Mientras no haya ningun pulsador presionado, enciende el led y apaga el timer
		sbi PORTB, pin_led	
		ldi r20, 0
		sts TCCR1B, r20	
		rjmp seleccionar_modo
caso1:	cpi r16, 0b00001000
		brne caso2
		ldi r20, (1<<CS11)|(1<<CS10) ; Prescaler clk/64
		rjmp salida
caso2:	cpi r16, 0b00000100
		brne caso3
		ldi r20, (1<<CS12)	; Prescaler clk/256
		rjmp salida
caso3:	cpi r16, 0b00001100
		brne salida
		ldi r20, (1<<CS12)|(1<<CS10) ; Prescaler clk/1024
salida:	sts TCCR1B, r20
		ret

; Conmuta el estado del led
toggle_led:
		in r16, PORTB
		ldi r17, (1<<pin_led)
		eor r16, r17
		out PORTB, r16		
		ret

; Inicializa el contador TCNT1 del timer 1
inicializar_contador:
		ldi r16, high(valor_inicial_TCNT1)
		sts TCNT1H, r16
		ldi r16, low(valor_inicial_TCNT1)
		sts TCNT1L, r16
		ret

; Setea el registro de overflow
interrupcion_overflow:
	push r16
	in r16, sreg
	push r16
	ldi overflow, 1
	pop r16
	out sreg, r16
	pop r16
    reti   
 
		