ORG 0000H
LJMP MAIN
ORG 0003H ;ISR for INT0
 DEC R3 ;decrement the count for minute (tenth_digit)
MOV A,R3 ;display minute(tenth_digit)
ADD A,R0
MOV R1,A
MOV P1,@R1
RETI
ORG 0013H ;ISR for INT1
DEC R4 ;decrement the count for hour
MOV A,R4 ;display hour
ADD A,R0
MOV R1,A
MOV P2,@R1
RETI
ORG 0030H
MAIN: ;main program
MOV R0,#30H ;starting address of lookup table
 ;look up table for 7 segment display
MOV @R0,#00H ;turn OFF display
INC R0
MOV @R0,#3FH ;digit_0
INC R0
MOV @R0,#06H ;digit_1
INC R0
MOV @R0,#5BH ;digit_2 
INC R0
MOV @R0,#4FH ;digit_3
INC R0
MOV @R0,#66H ;digit_4
INC R0
MOV @R0,#6DH ;digit_5
INC R0
MOV @R0,#7DH ;digit_6
INC R0
MOV @R0,#07H ;digit_7
INC R0
MOV @R0,#7FH ;digit_8
INC R0
MOV @R0,#6FH ;digit_9
INC R0
MOV @R0,#77H ;digit_A
INC R0
MOV @R0,#7CH ;digit_B
INC R0
MOV @R0,#39H ;digit_C
INC R0
MOV @R0,#5EH ;digit_D
INC R0
MOV @R0,#79H ;digit_E
INC R0
MOV @R0,#71H ;digit_F
MOV R0,# 30H ;starting adrees of look-up table
MOV TMOD,#01H ;timer-0 in mode-1
CLR P3.1 ;Alarm pin1(output)
CLR P3.4 
MOV IE,#10000101B ;enable INT0 & INT1
SETB TCON.0 ;INT0 in edge triggered
SETB TCON.2 ;INT1 in edge triggered
CLR C
;initialization of ports and registers
MOV P0,#6FH 
MOV P1,#6FH
MOV P2,#6FH
MOV R2,#0AH
MOV R3,#06H
MOV R4,#10H
HOUR:MOV A,R4
ADD A,R0
MOV R1,A
MOV P2,@R1 ;display hour
MOV R3,#06H
MINUTE_1:MOV A,R3
ADD A,R0
MOV R1,A
MOV P1,@R1 ;display minute(tenth digit)
MOV R2,#0AH
MINUTE_0:MOV A,R2
ADD A,R0
MOV R1,A
MOV P0,@R1 ;display minute(unit)
MOV R6,#78H ;delay generation of 1 minute
TMR2:MOV R7,#07H
TMR1:
MOV TL0,#00H 
MOV TH0,#00H
SETB TR0
BACK:JNB TF0,BACK
CLR TR0
CLR TF0
DJNZ R7,TMR1
CPL P3.0
DJNZ R6,TMR2
DJNZ R2,MINUTE_0 ;jump to display new digits
DJNZ R3,MINUTE_1
DJNZ R4,HOUR
SETB P3.4 ;turn on alarm
ALARM: 
CPL P3.1 ;blink alarm LED with 500ms delay
MOV R5,#03H
REP3:MOV R6,#0FFH
REP2:MOV R7,#0FFH
REP1:DJNZ R7,REP1
DJNZ R6,REP2
DJNZ R5,REP3
SJMP ALARM
END
