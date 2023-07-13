     .INCLUDE "M32DEF.INC"
	  .ORG 0
	   RJMP main
      .ORG $200
	  

main:   CLR R16
        OUT DDRA, R16  ;PORTA:INPUT
		OUT SFIOR, R16  ;PUD=0
		SER R16
		OUT PORTA, R16  ;PORTA=FF
		OUT DDRC,R16    ;PORTC:OUTPUT
        CLR R17
        SER R20
	    OUT DDRB,R20

        
		 
		CLR R18
		CLR R22
        
in_btn:	IN R16, PINA    ;READ INPUT
		 CPI R16, $01  ;0001 if press in button 
	     BRNE in_btn   ;
        
	  	SBI PORTC,0     ; LED
		
req_btn: IN R16, PINA    ;READ INPUT
	     CPI R16, $03   ;0011  
	     BRNE req_btn
	 
		 
          ;LDI R29,$07
	 	 ; OUT PORTC,R29
		 
          SBI PORTC,1    ;LED
		  
open:  SBI PORTB,0   ;OPEN=1
       SBI PORTC,2    
        CPI R26 ,$FF   ;baraye out
         BREQ  L4
         
        
L4:      CPI R26 ,$FF ;check mikone age az out zade bud led(out) =1
         BRNE wait1
         SBI PORTC,5
        
wait1:   CPI R17,20   ;wait for 20s
         BREQ alarm
		 INC R17
		 RJMP wait1 




alarm:  IN R16, PINA
        CPI R16, $07  ;0000 0111 check if alarm=1
		BRNE L1
        RCALL route_1
		
L1:     LDI R31,$00   ;flag 
    

        CBI PORTB,0    ;OPEN=0
         CBI PORTC,2    ;LED : OFF
		  CLR R26
          CBI PORTC,5 ;LED(out) : OFF

        CLR R17	
        CPI R31,0
	    BREQ wait2	
		        
wait2:   CPI R21,$FF    ;check mikone age ghablesh alarm dashtim dige 60s wait anjam nashe va close anjam she
		 BREQ L2
         CPI R18,60
         BREQ L2
		 INC R18
		 RJMP wait2
		 
		 
L2:    LDI R31,$00
      
       ;CBI PORTC,2  
	   ;CBI PORTB.0    age dar nazar begirim k 60s open = 1 bashe
	    SBI PORTB,1    ;CLOSE=1
        SBI PORTC,3    ;LED : ON
        CLR R18
        CPI R31,0
	    BREQ wait3

wait3:   CPI R17,20
         BREQ L3
		 INC R17
		 RJMP wait3

L3:     CBI PORTB,1    ;CLOSE=0
        CBI PORTC,3   ;LED : OFF
		CLR R17


out_btn:  SER R26 
          IN R16, PINA
          CPI R16, $0B  ;0000 1011 check if OUT=1

		  BREQ open
           
          RJMP out_btn


route_1:       SBI PORTB,0   ;OPEN=1
               SBI PORTC,2  ;LED : ON
               ; LDI R29,$17   ;0001 0111
	 	       ; OUT PORTC,R29
               SBI PORTC,4   ;FOR ALARM=1 , LED:ON
        
        w1:    CPI R22,30  ;wait for 30s
               BREQ alrm
		       INC R22
		       RJMP w1 

        

       alrm:   IN R16, PINA      ;check again alarm
               CPI R16, $07  ;0000 0111
               BRNE w2
		       CLR R22
               RJMP route_1
			   

          w2:  CBI PORTB,0    ;OPEN=0
               CBI PORTC,2    ;LED : OFF
               CBI PORTC,4  ;led(alarm) : off

		       SER R21
               RJMP L1   