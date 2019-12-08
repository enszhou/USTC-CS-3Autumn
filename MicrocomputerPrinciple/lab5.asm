.model small

.data 


.stack 100H

.code
BEGIN:
.startup

;char '\n', '+', '-', '(', ')'


;call cal, DI save result
call Cal

xchg DI, SI
;print SI
call Print_Number


jmp END_main



Cal proc NEAR ;return DI
    push AX
    push BX
    push CX
    push DX

    call Input_Token ;DI, SI
    .if SI == 0000H ;'-'
        call Input_Token
        .if SI == 0000H ;'('
            call Cal
            mov AX, DI
            neg AX ;a
            call Input_Token
            mov CX, DI ;op
        .else  ;'number'
            mov AX, DI
            neg AX ;a
            mov CX, SI ;op
        .endif
    .else ;number
        mov AX, DI ;a
        ;call Input_Token
        mov CX, SI ;op
    .endif

    .WHILE CX != 0AH && CX != 29H && CX != 0DH
        mov DX, CX
        call Input_Token
        .if SI == 0000H ;'('
            call Cal
            mov BX, DI; b
            call Input_Token
            mov CX, DI; op
        .else
            mov BX, DI ;b 
            mov CX, SI; op  
        .endif

        .if DX == 2BH ;'+'
            add AX, BX
        .else
            sub AX, BX
        .endif
    .ENDW

    mov DI, AX


    pop DX
    pop CX
    pop BX
    pop AX
    ret
Cal endp



Print_Number proc NEAR
    push AX
    push BX
    push CX
    push DX

    ; sentry
    mov AX, 0000H
    push AX

    ;SI save number, max 5 digits
    cmp SI, 00H
    jnl Positive_Number


    Negative_Number:
        ;print '-', then SI > 0
        mov AH, 02H
        mov DL, 2DH
        int 21H ;print '-'
        neg SI ;SI to Positive

    Positive_Number:
        ; SI > 0

        mov AX, SI 
        mov DX, 0000H
        mov BX, 000AH

        mov CX, 05H ; max 5 digits

        CAL_EVERY_DIGIT:
        div BX ;AX = SI/10 DX = SI%10
        push DX ; reminder = DX
        mov DX, 0000H
        ;mov AH, 00H ;AX = 00:SI/10
        loop CAL_EVERY_DIGIT


        mov CX, 05H ; max 5 digits
        RM_HIGH_ZERO:
        pop AX
        cmp AL, 00H
        jne PRINT_DIGIT
        loop RM_HIGH_ZERO
        inc CX; SI==0

        PRINT_DIGIT:
        mov DL, AL
        add DL, 30H 
        mov AH, 02H
        int 21H
        pop AX
        loop PRINT_DIGIT

    ;end
    pop DX
    pop CX
    pop BX
    pop AX
    ret
Print_Number endp




Input_Token proc NEAR ;SI=0,DI=char='\n' or operator; SI=char, DI=number
    push AX
    push DX

    ;init
    mov SI, 0000H

    LL1:
        ;space
        mov AH, 01H
        int 21H
        cmp AL, 20H
        je LL1

    ;crlf
    mov DI, 0AH
    cmp AL, 0AH
    je END_Input_Token
    cmp AL, 0DH
    je END_Input_Token


    ;operator
    mov AH, 00H
    mov DI , AX
    cmp AL, 30H
    jb END_Input_Token

    ;number
    sub DI, 30H

    LL2:
        mov AH, 01H
        int 21H
        cmp AL, 30H
        jb LL3
        sub AL, 30H
        mov AH, 00H
        xchg AX, DI
        mov DX, 0AH
        mul DX ;DI*10
        add DI, AX  
        jmp LL2

    LL3:
    ;char
        cmp AL, 20H
        jne LL4
        mov AH, 01H
        int 21H
        jmp LL3

    ;op
    LL4:
    mov AH, 00H
    mov SI, AX

    END_Input_Token:
        pop DX
        pop AX
        ret
Input_Token endp








;end
END_main:
.EXIT
END