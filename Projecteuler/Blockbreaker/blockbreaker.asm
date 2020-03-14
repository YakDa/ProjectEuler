#include <sfr51.inc>             ; 8051 sfr and ports are defined here

HONR            EQU 95           ; ASCII of "_"
VERT            EQU 124          ; ASCII of "|"
SPACE           EQU 32           ; ASCII of space

FRAME_TOPLEFT_X EQU 23           ; the x value of left top of the frame
FRAME_TOPLEFT_Y EQU 05           ; the y value of left top of the frame
FRAME_L         EQU 24           ; length of frame
FRAME_H         EQU 10            ; height of frame
FRAME_COLOUR    EQU 33H
HONR_BRICKS     EQU 5            ; number of bricks in a line
VERT_BRICKS     EQU 4            ; number of bricks in a column
BRICKS_COLOUR   EQU 35H

BRICK_L         EQU 4            ; the length of a brick
BOARD_L         EQU 6            ; the length of the board
BOARD_ORIG_X    EQU FRAME_TOPLEFT_X+8           ; the original X position of the board
BOARD_ORIG_Y    EQU FRAME_TOPLEFT_Y+8           ; the original Y position of the board
BOARD_COLOUR    EQU 34H
LEFT            EQU 97           ; Left direction ASCII ('a')
RIGHT           EQU 100          ; Right direction ASCII ('b')
STEP            EQU 2            ; Steps the board move


BALL            EQU 42           ; The ASCII of ball ('*')
BALL_ORIG_X     EQU 13           ; the original X position of the ball
BALL_ORIG_Y     EQU 8            ; the original Y position of the ball
SPEED           EQU 01           ; The speed of the ball

RED             EQU 31H
GREEN           EQU 32H
BLUE            EQU 34H
YELLOW          EQU 33H
WHITE           EQU 37H
MAGENTA         EQU 35H


STACK	        EQU	70H	                 ; stack pointer starting address(growing upward)

        DSEG    AT  08H
        LOCATE_IN0:     DS       1
        LOCATE_IN1:     DS       1
        ASCII_HONR:     DS       1       ; 
        ASCII_VERT:     DS       1
        TEMP:           DS       1
        TEMP1:          DS       1
        TEMP2:          DS       1
        END

        BSEG    AT  00H
        DATA_RX:        DBIT     1
        ONE_SEC:        DBIT     1
        END

        DSEG    AT  18H
        MYSTACK:        DS       8       ; my working stack
        END

        DSEG	AT	30h                 
        BRICKS_X:       DS       20     ; This is unnecessary
        BRICKS_KEY:     DS       20
        DIRECTION:      DS       1
        BOARD_X:        DS       1
        TIMER_COUNT:    DS       1
        BALL_X:         DS       1
        BALL_Y:         DS       1
        BALL_X_STEP:    DS       1
        BALL_Y_STEP:    DS       1
        IN0:            DS       1
        IN1:            DS       1
        IN2:            DS       1
        IN3:            DS       1
        IN4:            DS       1
        IN5:            DS       1
        IN6:            DS       1
        IN7:            DS       1
        SCORE:          DS       1
        END

;-----------------------------------------------------------------------------------------
;       Beginning of the main program
;-----------------------------------------------------------------------------------------
        CSEG	AT	0000h	     ; absolute code segment starting at 0000h
        LJMP	START		     ; reset vector - first instruction is to jump to user program
        END
    	CSEG	AT	23H		; serial port interrupt vector address 
    	LJMP	SERIAL_ISR
        END
    	CSEG	AT	0BH
    	LJMP	TIMER_ISR
        END
	    CSEG	AT	0100H	     ; absolute code segment starting at 0100h
        TITLE:	  DB	"BLOCKBREAKER"              ; Position X: 34 Y: 3
        GAMEOVER: DB    "GAME OVER!"                ; Position X: 35 Y: 9
        YOUWIN:   DB    "CONGRATULATIONS! YOU WIN!" ; Position X: 28 Y: 9
START:
        NOP
        NOP

        MOV	SP, #STACK	         ; set up the stack pointer
        LCALL INIT_SERIAL
        LCALL INIT_TIMER0

        MOV   A, #0CH            ;clear hyperterminal
        LCALL TX_DATA
        MOV   A, #0CH
        LCALL TX_DATA

        LCALL CLEAR
        LCALL INIT_BRICKS

        MOV BOARD_X, #BOARD_ORIG_X
        MOV IN0, BOARD_X
        MOV IN1, #BOARD_ORIG_Y
        MOV IN2, #BOARD_L
        MOV IN3, #1
        MOV IN4, #BOARD_COLOUR
        MOV ASCII_HONR, #HONR
        MOV ASCII_VERT, #VERT
        LCALL DRAW_SQUARE
        MOV A, #BALL_ORIG_X
        ADD A, #FRAME_TOPLEFT_X
        MOV BALL_X, A
        MOV A, #BALL_ORIG_Y
        ADD A, #FRAME_TOPLEFT_Y
        MOV BALL_Y, A
        MOV BALL_X_STEP, #FFH
        MOV BALL_Y_STEP, #01H  
;;;;;;;;;;;;;;;;;Draw the main frame;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV IN0, #18
        MOV IN1, #1
        MOV IN2, #44
        MOV IN3, #17
        MOV IN4, #GREEN
        LCALL DRAW_SQUARE
;;;;;;;;;;;;;;;;;Draw title;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV R2, #12
        MOV LOCATE_IN0, #34
        MOV LOCATE_IN1, #3
        LCALL LOCATE
        MOV DPTR, #TITLE
LABEL0:        
    	CLR	    A
    	MOVC	A, @A+DPTR
    	INC	    DPTR
    	ACALL	TX_DATA
    	DJNZ	R2, LABEL0

LOOP:

        LCALL FRAME_WORK
        LCALL CHECK_KEY
        LCALL BALL_MOVE
        
        LJMP LOOP
;-----------------------------------------------------------------------------------------
;       The movement of ball
;-----------------------------------------------------------------------------------------
BALL_MOVE:
        LCALL PUSHSTACK
        JB ONE_SEC, BALL_LABEL1
        LJMP BALL_LABEL0
BALL_LABEL1:
        CLR ONE_SEC
        MOV TIMER_COUNT, #SPEED
;;;;;;;;;;;;;;;;;;;;;;;;;judge if the ball hit the frame;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        CLR C
        MOV A, BALL_X
        SUBB A, #FRAME_TOPLEFT_X
        JZ MOVE_LABEL0
        CLR C
        MOV A, #FRAME_TOPLEFT_X-1
        ADD A, #FRAME_L
        MOV R2, A
        MOV A, BALL_X
        SUBB A, R2                      ;#FRAME_L+#FRAME_TOPLEFT_X-1
        JZ MOVE_LABEL0
        SJMP MOVE_LABEL1
MOVE_LABEL0:
        XRL BALL_X_STEP, #11111110B
MOVE_LABEL1:
        CLR C
        MOV A, BALL_Y
        SUBB A, #FRAME_TOPLEFT_Y+1
        JZ MOVE_LABEL2
        CLR C
        MOV A, #FRAME_TOPLEFT_Y
        ADD A, #BALL_ORIG_Y
        MOV R2, A
        MOV A, BALL_Y
        SUBB A, R2                   ;#BALL_ORIG_Y+#FRAME_TOPLEFT_Y
        JZ MOVE_LABEL2
        SJMP MOVE_LABEL3
MOVE_LABEL2:
        XRL BALL_Y_STEP, #11111110B
MOVE_LABEL3:
        MOV IN0, BALL_X
        MOV IN1, BALL_Y
        MOV IN2, #SPACE
        MOV IN3, #RED
        LCALL PIXELDISP
        MOV A, BALL_X_STEP
        ADD A, BALL_X
        MOV BALL_X, A
        MOV A, BALL_Y_STEP
        ADD A, BALL_Y
        MOV BALL_Y, A
        MOV IN0, BALL_X
        MOV IN1, BALL_Y
        MOV IN2, #BALL
        MOV IN3, #RED
        LCALL PIXELDISP
;;;;;;;;;;;;;;;;;;;;;;;;;judge if the ball hit the bricks;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV R0, #BRICKS_KEY+20                      ; pointer that points to BRICKS_KEY+20 position
        MOV R1, #BRICKS_X+5                         ; pointer that points to BRICKS_X+5
        MOV R3, #VERT_BRICKS                        ; j count
        MOV R4, #HONR_BRICKS                        ; i count
MOVE_LABEL4:
        MOV R4, #HONR_BRICKS                        ; i count
        MOV R1, #BRICKS_X+5                         ; pointer that points to BRICKS_X+5
MOVE_LABEL5:
        DEC R1
        DEC R0        
        MOV A, BALL_X
        INC A
        CLR C
        SUBB A, @R1                                 ; if(BALL_X+1>=@R1)
        JC MOVE_LABEL6        
        MOV A, @R1
        ADD A, #BRICK_L+1
        MOV R6, A
        MOV A, BALL_X
        CLR C
        SUBB A, R6                                  ; if(BALL_X<@R1+#BRICK_L+1)
        JNC MOVE_LABEL6        
        CLR C
        MOV A, R3
        ADD A, #FRAME_TOPLEFT_Y
        MOV R6, A
        INC R6
        MOV A, BALL_Y
        SUBB A, R6                                  ; if(BALL_Y==R6+1)
        JNZ MOVE_LABEL6        
        MOV A, @R0
        CLR C
        SUBB A, #1
        JNZ MOVE_LABEL6
        SJMP DESTROY
MOVE_LABEL6:
        DJNZ R4, MOVE_LABEL5
        DJNZ R3, MOVE_LABEL4
        SJMP MOVE_LABEL7
DESTROY:        
        XRL BALL_Y_STEP, #11111110B
        MOV @R0, #0
        MOV A, R4
        DEC A
        MOV B, #BRICK_L+1
        MUL AB
        ADD A, #FRAME_TOPLEFT_X
        MOV IN0, A
        MOV A, R3
        ADD A, #FRAME_TOPLEFT_Y-1
        MOV IN1, A
        LCALL DELETE_SQUARE
        INC SCORE
        LCALL DISPSCORE
        MOV A, #20
        CJNE A, SCORE, MOVE_LABEL7
        LCALL WIN_GAME
MOVE_LABEL7:
;;;;;;;;;;;;;;;;;;;;;;;;;judge if the ball hit the board;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        CLR C
        MOV A, BALL_Y
        SUBB A, #BOARD_ORIG_Y
        JNZ BALL_LABEL0
        CLR C
        MOV R6, BOARD_X
        DEC R6
        MOV A, BALL_X
        SUBB A, R6
        JC MOVE_LABEL8
        CLR C
        MOV R6, BOARD_X
        MOV A, R6
        ADD A, #BOARD_L+1
        MOV R6, A
        MOV A, BALL_X
        SUBB A, R6
        JNC MOVE_LABEL8
        SJMP BALL_LABEL0
MOVE_LABEL8:
        LCALL LOSE_GAME
BALL_LABEL0:   

        LCALL POPSTACK
        XRL P1, #FFH
        RET
;-----------------------------------------------------------------------------------------
;       Win game
;       --Position X: 28 Y:9
;       --Num: 25
;-----------------------------------------------------------------------------------------
WIN_GAME:
        MOV A, #0CH
        LCALL TX_DATA
        MOV A, #0CH
        LCALL TX_DATA
;;;;;;;;;;;;;;;;;Draw the main frame;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV IN0, #18
        MOV IN1, #1
        MOV IN2, #44
        MOV IN3, #17
        MOV IN4, #GREEN
        LCALL DRAW_SQUARE
;;;;;;;;;;;;;;;;;Draw win notification;;;;;;;;;;;;;;;;;;;;;;;;
        MOV R2, #25
        MOV LOCATE_IN0, #28
        MOV LOCATE_IN1, #9
        LCALL LOCATE
        MOV DPTR, #YOUWIN
WIN_LABEL0:        
    	CLR	    A
    	MOVC	A, @A+DPTR
    	INC	    DPTR
    	LCALL	TX_DATA
    	DJNZ	R2, WIN_LABEL0
        
        SJMP $+0
        RET
;-----------------------------------------------------------------------------------------
;       Lose game
;       --Position X: 35 Y:9
;       --Num: 10
;-----------------------------------------------------------------------------------------
LOSE_GAME:
        MOV A, #0CH
        LCALL TX_DATA
        MOV A, #0CH
        LCALL TX_DATA
;;;;;;;;;;;;;;;;;Draw the main frame;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV IN0, #18
        MOV IN1, #1
        MOV IN2, #44
        MOV IN3, #17
        MOV IN4, #GREEN
        LCALL DRAW_SQUARE
;;;;;;;;;;;;;;;;;Draw fail notification;;;;;;;;;;;;;;;;;;;;;;
        MOV R2, #10
        MOV LOCATE_IN0, #35
        MOV LOCATE_IN1, #9
        LCALL LOCATE
        MOV DPTR, #GAMEOVER
LOSE_LABEL0:        
    	CLR	    A
    	MOVC	A, @A+DPTR
    	INC	    DPTR
    	LCALL	TX_DATA
    	DJNZ	R2, LOSE_LABEL0
        
        SJMP $+0
        RET
;-----------------------------------------------------------------------------------------
;       Display score
;-----------------------------------------------------------------------------------------
DISPSCORE:

        MOV A, #1BH              ; 'ESC'
        LCALL TX_DATA
        MOV A, #5BH              ; '['
        LCALL TX_DATA
        MOV A, #GREEN
        SWAP A
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #GREEN
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #6DH              ; 'm'
        LCALL TX_DATA

        MOV LOCATE_IN0, #55
        MOV LOCATE_IN1, #9
        LCALL LOCATE
        MOV A, SCORE
        MOV B, #10
        DIV AB
        ADD A, #30H
        LCALL TX_DATA  
        MOV A, B
        ADD A, #30H
        LCALL TX_DATA

        RET
;-----------------------------------------------------------------------------------------
;       Check the key board
;-----------------------------------------------------------------------------------------
CHECK_KEY:
        LCALL PUSHSTACK

        MOV C, DATA_RX
        JNC CHECK_LABEL2
        MOV IN0, BOARD_X
        MOV IN1, #BOARD_ORIG_Y
        MOV IN2, #BOARD_L
        MOV IN3, #1
        MOV IN4, #BOARD_COLOUR
        MOV ASCII_HONR, #SPACE
        MOV ASCII_VERT, #SPACE
        LCALL DRAW_SQUARE
        CLR C
        MOV DATA_RX, C
        MOV A, #LEFT
        CLR C
        SUBB A, DIRECTION
        JNZ CHECK_LABEL1
        MOV A, BOARD_X
        CLR C
        SUBB A, #STEP
        MOV BOARD_X, A
CHECK_LABEL1:
        MOV A, #RIGHT
        CLR C
        SUBB A, DIRECTION
        JNZ CHECK_LABEL0
        MOV A, #STEP
        ADD A, BOARD_X
        MOV BOARD_X, A
CHECK_LABEL0:
        MOV IN0, BOARD_X
        MOV IN1, #BOARD_ORIG_Y
        MOV IN2, #BOARD_L
        MOV IN3, #1
        MOV IN4, #BOARD_COLOUR
        MOV ASCII_HONR, #HONR
        MOV ASCII_VERT, #VERT
        LCALL DRAW_SQUARE
CHECK_LABEL2:

        LCALL POPSTACK
        RET
;-----------------------------------------------------------------------------------------
;       Initialization of some variables
;-----------------------------------------------------------------------------------------
CLEAR:
        MOV SCORE, #0
        CLR C
        MOV DATA_RX, C
        RET
;-----------------------------------------------------------------------------------------
;       Initialization of brick position and life value
;-----------------------------------------------------------------------------------------
INIT_BRICKS:
        LCALL PUSHSTACK

        MOV R0, #BRICKS_X               ; Initialize X of bricks
        MOV R2, #HONR_BRICKS
        MOV A, #FRAME_TOPLEFT_X
BRICKS_X_LABEL:
        MOV @R0, A
        ADD A, #BRICK_L+1
        INC R0
        DJNZ R2, BRICKS_X_LABEL

        MOV R0, #BRICKS_KEY             ; Initialize the life of bricks
        MOV R2, #20
BRICKS_KEY_LABEL:
        MOV @R0, #1
        INC R0
        DJNZ R2, BRICKS_KEY_LABEL
 
        LCALL POPSTACK
        RET
;-----------------------------------------------------------------------------------------
;       Delete a certain square
;       --IN0-The position of square in line
;       --IN1-The position of square in column
;-----------------------------------------------------------------------------------------
DELETE_SQUARE:
        LCALL PUSHSTACK
        
        MOV IN2, #BRICK_L
        MOV IN3, #1
        MOV IN4, #WHITE
        MOV ASCII_HONR, #SPACE
        MOV ASCII_VERT, #SPACE
        LCALL DRAW_SQUARE

        LCALL POPSTACK
        RET
;-----------------------------------------------------------------------------------------
;       Frame work of game
;       --IN0-left top X of frame
;       --IN1-left top Y of frame
;-----------------------------------------------------------------------------------------
FRAME_WORK:
        LCALL PUSHSTACK

        MOV IN0, #FRAME_TOPLEFT_X
        MOV IN1, #FRAME_TOPLEFT_Y
        MOV IN2, #FRAME_L
        MOV IN3, #FRAME_H
        MOV ASCII_HONR, #HONR
        MOV ASCII_VERT, #VERT
        MOV IN4, #FRAME_COLOUR
        LCALL DRAW_SQUARE   
;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY COLOUR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
        MOV A, #1BH              ; 'ESC'
        LCALL TX_DATA
        MOV A, #5BH              ; '['
        LCALL TX_DATA
        MOV A, #BRICKS_COLOUR
        SWAP A
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #BRICKS_COLOUR
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #6DH              ; 'm'
        LCALL TX_DATA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV R1, #HONR_BRICKS
        MOV R2, #BRICK_L
        MOV R4, #VERT_BRICKS
        MOV R0, #BRICKS_KEY
        MOV LOCATE_IN0, #FRAME_TOPLEFT_X
        MOV LOCATE_IN1, #FRAME_TOPLEFT_Y+1
        LCALL LOCATE

FRAME_LABEL2:
        MOV R1, #HONR_BRICKS
FRAME_LABEL3:
        MOV R2, #BRICK_L
        MOV A, @R0
        INC R0
        JZ FRAME_LABEL7
        LCALL MOVE_L
        MOV A, #VERT
        LCALL TX_DATA
FRAME_LABEL4:
        MOV A, #HONR
        LCALL TX_DATA
        DJNZ R2, FRAME_LABEL4
        MOV A, #VERT
        LCALL TX_DATA
        SJMP FRAME_LABEL8
FRAME_LABEL7:
        LCALL MOVE_R
        DJNZ R2, FRAME_LABEL7
        LCALL MOVE_R
FRAME_LABEL8:
        DJNZ R1, FRAME_LABEL3
        INC LOCATE_IN1
        LCALL LOCATE
        DJNZ R4, FRAME_LABEL2

        LCALL POPSTACK
        RET

;-------------------------------------------------------------------------
;      Move action
;-------------------------------------------------------------------------
MOVE_R:
        MOV A, #1BH
        LCALL TX_DATA
        MOV A, #5BH
        LCALL TX_DATA
        MOV A, #43H
        LCALL TX_DATA
        RET
MOVE_L:
        MOV A, #1BH
        LCALL TX_DATA
        MOV A, #5BH
        LCALL TX_DATA
        MOV A, #44H
        LCALL TX_DATA
        RET
;-----------------------------------------------------------------------------------------
;       Push working registers into my stack
;-----------------------------------------------------------------------------------------
PUSHSTACK:
        MOV TEMP, R0
        MOV R0, #MYSTACK
        MOV @R0, TEMP
        INC R0
        MOV A, R1
        MOV @R0, A
        INC R0
        MOV A, R2
        MOV @R0, A
        INC R0
        MOV A, R3
        MOV @R0, A
        INC R0
        MOV A, R4
        MOV @R0, A
        INC R0
        MOV A, R5
        MOV @R0, A
        INC R0
        MOV A, R6
        MOV @R0, A
        INC R0
        MOV A, R7
        MOV @R0, A
        MOV R0, TEMP
        RET
;-----------------------------------------------------------------------------------------
;       Pop working registers back from my stack
;-----------------------------------------------------------------------------------------

POPSTACK:
        MOV R0, #MYSTACK
        INC R0
        MOV A, @R0
        MOV R1, A
        INC R0
        MOV A, @R0
        MOV R2, A
        INC R0
        MOV A, @R0
        MOV R3, A
        INC R0
        MOV A, @R0
        MOV R4, A
        INC R0
        MOV A, @R0
        MOV R5, A
        INC R0
        MOV A, @R0
        MOV R6, A
        INC R0
        MOV A, @R0
        MOV R7, A
        MOV R0, #MYSTACK
        MOV A, @R0
        MOV R0, A
        RET

;-----------------------------------------------------------------------------------------
;       Initialization of serial
;-----------------------------------------------------------------------------------------
INIT_SERIAL:				    ; initialize serial port (& timer 1) for serial communication 
        CLR EA
        CLR	ES		            ; disable serial port interrupt 
        ORL PCON, #80H          ; set baudrate 19200
        MOV	SCON, #50h	    	; set serial port(mode 1 : 8-bit variable baudrate) 
       	MOV	TMOD, #20h		    ; timer 1 mode 2 : 8-bit auto reload mode 
        MOV	TH1, #0fdh	    	; reload value for baudrate 
        MOV	IE, #10010010B      ; enable time interrupt, enable serial interrupt and enable the mother interrupt bit
        SETB	TR1		    	; start timer 1 
        RET
;---------------------------------------------------------
;                       init timer                       ;
;---------------------------------------------------------

INIT_TIMER0:  			       ; routine to initialize timer 0 (complete the following routine) 
  	CLR  	EA           	   ; disable all interrupt 
    CLR  	ET0    		       ; disable timer0 interrupt 
    CLR  	TR0          	   ; stop timer0  
 	CLR  	ONE_SEC
  	MOV  	TL0, #0fch	       ; load timer value 
  	MOV  	TH0, #0fh 
   	MOV 	TIMER_COUNT,  #SPEED
    MOV   	TMOD,#21h   	   ; timer 0 in 16 bit internal mode , timer1 is used to provide one second
    SETB  	ET0         	   ; timer 0 interrupt enabled 
    SETB  	EA          	   ; enable cpu to be interrupted 
    SETB  	TR0            	   ; start timer 0 â€?i.e. run
    RET 
;-----------------------------------------------------------------------------------------
;       Locate cursor subroutine
;       --LOCATE_IN0-X position
;       --LOCATE_IN1-Y position
;-----------------------------------------------------------------------------------------
LOCATE:       
        LCALL PUSHSTACK
        MOV A, #1BH              ; 'ESC'
        LCALL TX_DATA
        MOV A, #5BH              ; '['
        LCALL TX_DATA
        MOV A, LOCATE_IN1
        MOV B, #10
        DIV AB
        ADD A, #30H
        LCALL TX_DATA  
        MOV A, B
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #3BH              ; ';'
        LCALL TX_DATA
        MOV A, LOCATE_IN0
        MOV B, #10
        DIV AB
        ADD A, #30H
        LCALL TX_DATA
        MOV A, B
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #48H              ; 'H'
        LCALL TX_DATA
        LCALL POPSTACK
        RET       
;-----------------------------------------------------------------------------------------
;       Cursor control subroutine
;       --IN0-X position(from 1)
;       --IN1-Y position(from 1)
;       --IN2-ASCII(BALL or SPACE)
;       --IN3-Colour
;-----------------------------------------------------------------------------------------
PIXELDISP: 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY COLOUR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
        LCALL PUSHSTACK

        MOV A, #1BH              ; 'ESC'
        LCALL TX_DATA
        MOV A, #5BH              ; '['
        LCALL TX_DATA
        MOV A, IN3
        SWAP A
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, IN3
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #6DH              ; 'm'
        LCALL TX_DATA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LOCATE AND DISPLAY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV A, #1BH              ; 'ESC'
        LCALL TX_DATA
        MOV A, #5BH              ; '['
        LCALL TX_DATA
        MOV A, IN1
        MOV B, #10
        DIV AB
        ADD A, #30H
        LCALL TX_DATA  
        MOV A, B
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #3BH              ; ';'
        LCALL TX_DATA
        MOV A, IN0
        MOV B, #10
        DIV AB
        ADD A, #30H
        LCALL TX_DATA
        MOV A, B
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #48H              ; 'H'
        LCALL TX_DATA
        MOV A, IN2
        LCALL TX_DATA

        LCALL POPSTACK

        RET


;-----------------------------------------------------------------------------------------
;       Draw a square (move right at least one time whatever, different from PIXELDISP)
;       --IN0-Left top X (use hex)
;       --IN1-Left top Y (use hex)
;       --IN2-Longth of square
;       --IN3-Height of square
;       --IN4-Colour of square
;       --ASCII_HONR-The ASCII display in line
;       --ASCII_VERT-The ASCII display in column
;-----------------------------------------------------------------------------------------
DRAW_SQUARE:
        LCALL PUSHSTACK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY COLOUR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
        LCALL PUSHSTACK

        MOV A, #1BH              ; 'ESC'
        LCALL TX_DATA
        MOV A, #5BH              ; '['
        LCALL TX_DATA
        MOV A, IN4
        SWAP A
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, IN4
        ANL A, #0FH
        ADD A, #30H
        LCALL TX_DATA
        MOV A, #6DH              ; 'm'
        LCALL TX_DATA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Draw up lines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV LOCATE_IN0, IN0
        MOV LOCATE_IN1, IN1
        LCALL LOCATE
        MOV R2, IN2
UP_HONR:
        MOV A, ASCII_HONR
        LCALL TX_DATA
        DJNZ R2, UP_HONR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Draw down lines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV A, IN1
        ADD A, IN3
        MOV LOCATE_IN1, A
        LCALL LOCATE
        MOV R2, IN2
DOWN_HONR:
        MOV A, ASCII_HONR
        LCALL TX_DATA
        DJNZ R2, DOWN_HONR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Draw left lines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        DEC LOCATE_IN0
        LCALL LOCATE
        MOV R2, IN3
LEFT_VERT:
        MOV A, ASCII_VERT
        LCALL TX_DATA
        DEC LOCATE_IN1
        LCALL LOCATE
        DJNZ R2, LEFT_VERT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Draw right lines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV A, IN2
        ADD A, IN0
        MOV LOCATE_IN0, A
        INC LOCATE_IN1
        LCALL LOCATE
        MOV R2, IN3
RIGHT_VERT:
        MOV A, ASCII_VERT
        LCALL TX_DATA
        INC LOCATE_IN1
        LCALL LOCATE
        DJNZ R2, RIGHT_VERT

        LCALL POPSTACK
        RET

;-------------------------------------------------------------------------
;      Serial deliver
;-------------------------------------------------------------------------
TX_DATA:					       ; transmit data that is passed through the accumulator 
	   CLR	TI			        
	   MOV	SBUF, A			     
	   JNB	TI, $+0		               ; loop here until data is sent(ti will be set) 
	   CLR	TI	     
	   RET
;-------------------------------------------------------------------------
;       Serial isr
;-------------------------------------------------------------------------
SERIAL_ISR:

	JB	RI, RX
	RETI

RX:
    MOV TEMP1, A
	MOV	A, SBUF
	MOV	DIRECTION, A
	SETB	DATA_RX
	CLR	RI
    MOV A, TEMP1
	RETI

;---------------------------------------
;      timer isr
;---------------------------------------
TIMER_ISR:
	CLR TR0
    MOV TEMP2, R7
    MOV R7, TIMER_COUNT
	MOV TL0, #0fch	; load timer value 
  	MOV	TH0, #0fh
	DJNZ R7, NOT_ONE_SEC
	SETB ONE_SEC
NOT_ONE_SEC:
    MOV TIMER_COUNT, R7
    MOV R7, TEMP2
	SETB TR0
	RETI 

    END
