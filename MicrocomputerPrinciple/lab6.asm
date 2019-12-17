.387
.model small

.data 
BUFF_STD_IN DB 20, 21 dup(0)
Temp DB 20 dup(0)
Message_Error_Neg DB "Error: x < 0!$"
Message_Error_Zero DB "Error: x = 0!$"
fx DT 0
fa1 DT 0
fa2 DT 0
fa3 DT 0
fans DT 0

Cof DT 01000000H
Point equ 6

x equ BYTE ptr fx
a1 equ BYTE ptr fa1
a2 equ BYTE ptr fa2
a3 equ BYTE ptr fa3
ans equ BYTE ptr fans

.stack 100H

.code
BEGIN:
.startup



mov DL, 78H ;x
call Prompt_Input
lea SI, x
call Input_Int

.if x[9] == 80H
    lea DX, Message_Error_Neg
    mov AH, 09H 
    int 21H
    jmp END_main
.endif



; ;test
; lea SI, Cof
; call Output_Int
; jmp END_main
; ;test

mov DL, 61H ;a1
call Prompt_Input
lea SI, a1
call Input_Int

mov DL, 62H ;a2
call Prompt_Input 
lea SI, a2
call Input_Int

mov DL, 63H ;a3
call Prompt_Input
lea SI, a3
call Input_Int

;calculate
FBLD fx
FSQRT 
FBLD fa1
FMULP ST(1), ST ;a1sqrt(x)
FBLD fa2
FBLD fx
FYL2X 
FADDP ST(1), ST ;a1*sqrt(x)+a2*log2x
FBLD fx
fsin
FBLD fa3
FMULP ST(1), ST
FADDP ST(1), ST ;a1*sqrt(x)+a2*log2x+a2*sinx
;mul 10000
FBLD Cof
FMULP ST(1), ST ;mul 10000
FBSTP fans



lea SI, ans
call Output_Int



jmp END_main



Prompt_Input proc NEAR
;DL save char
    mov AH, 02H
    mov DH, DL
    mov DL, 0AH
    int 21H

    mov DL, DH
    int 21H
    mov DL, 3AH
    int 21H
    ret
Prompt_Input endp

Output_Int proc NEAR
    ;print BCD number, SI save start 
    ;print \n
    mov AH, 02H
    mov DL, 0AH
    int 21H
    ;print '-'
    mov BX, SI
    mov DL, [SI + 9]
    .if DL == 80H
        mov AH, 02H
        mov DL, 2DH
        int 21H
    .endif

    mov BX, 0009H
    mov AH, 02H
    mov CL, 04H
    mov CH, 00H
    .WHILE BX > 0
        mov DI, BX 
        add DI, DI ;number of digits to be print
        .if DI == Point
            mov DL, 2EH 
            int 21H 
        .endif
        dec BX
        mov DL, [BX + SI]
        mov DH, DL
        shr DL, CL 
        add DL, 30H
        ;high 4 bits
        .if DL != 30H
            mov CH, 01H
            int 21H
        .else  
            .if CH == 01H
                int 21H
            .endif
        .endif

        ;low 4 bits
        mov DL, DH
        AND DL, 0FH
        add DL, 30H
        .if DL != 30H
            mov CH, 01H
            int 21H
        .else  
            .if CH == 01H
                int 21H
            .endif
        .endif
    .ENDW
    ret
Output_Int endp

Input_Int proc NEAR
    ;SI save the Int address
    ;assume positve
    lea DX, BUFF_STD_IN
    mov AH, 0AH
    int 21H
    mov CL, BUFF_STD_IN[1]
    mov CH, 00H
    inc CX ;n+1
    mov AL ,00H
    ;reverse the string

    .WHILE CX > 1
        mov BX, CX
        mov DL, BUFF_STD_IN[BX] 
        .if DL == 2DH ;negative
            mov BX, SI  
            mov [BX+9], 80H ;
            mov BL, AL
            mov BH, 00H
            mov Temp[BX], 00H
        .else
            sub DL, 30H
            mov BL, AL
            mov BH, 00H
            mov Temp[BX], DL
        .endif
        inc AL
        dec CX
    .ENDW
    ;fill high of Temp with zeros
    mov BL, AL
    mov BH, 00H
    .WHILE BX < 18
        mov Temp[BX], 00H
        inc BX
    .ENDW
    ;compress BCD, 18->9
    mov BX, 0000H
    .WHILE BX < 9
        mov AX, BX
        add BX, BX
        mov DH, Temp[BX+1]
        mov CL, 04H
        shl DH, CL
        mov DL, Temp[BX]
        add DH, DL
        mov BX, AX
        mov [SI + BX], DH 
        inc BX
    .ENDW

ret
Input_Int endp

;end
END_main:
.EXIT
END