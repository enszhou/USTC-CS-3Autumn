.model  small

.data      
BUFF_STDIN DB 50H
N DB 0
ANS DB 01H, 20 DUP(0) ;string of N!
Temp DB 21 DUP(0)
M equ 20 ;max bits

.stack 100H

.code
BEGIN:
.startup    

;real start
;read N
mov DL, 0
Input_Number:
    mov AH, 01H
    int 21H
    cmp AL, 0DH ;/r/n
    jna Input_End
    sub AL, 30H
    mov AH, DL
    mov DL, AL
    mov AL, 0AH 
    mul AH
    add DL, AL ;DL*10 + new num
    jmp Input_Number

Input_End:
mov N, DL

;calculate 
call factorial


;print ANS
mov CX, M
Test_Max_Digit:
    ;find the fist digit which not be equal to 0
    mov BX, CX
    dec BX
    mov DL, ANS[BX]
    cmp DL, 00H
    jne Print_Digits
    loop Test_Max_Digit

Print_Digits:
    mov BX, CX
    dec BX
    mov DL, ANS[BX]
    add DL, 30H
    mov AH, 02H
    int 21H
    loop Print_Digits




jmp END_main

;factorial, input DL, save DL! to ANS
factorial PROC NEAR
    ;save AX
    push AX
    ;DL=1 return
    cmp DL, 01H
    jna END_factorial
    
    
    
    ;contunue recursion, DL>1
    mov AL, DL ;save n to AL
    dec DL
    ;DL - 1
    call factorial

    ;recover n to DL
    mov DL, AL ;save n to DL

    ;n multily every digit of ANS
    ;DL * (DL-1)!, AL * ANS
    mov CX, M
    Mul_Every_Digit:
        mov BX, CX
        dec BX
        mov AH, ANS[BX] ;BX = M-1, ..., 19, 18, ..., 0 
        mov AL, DL ; n to AL
        mul AH ; AX = AL*AH = n * ANS[i] = AL
        mov ANS[BX], AL
        loop Mul_Every_Digit

    ;some digits may be large than 10, we need to carry them out 
    mov CX, M
        mov DL, 00H ;initial, carry in of every digital
    Fix_Carry:
        mov BX, M
        sub BX, CX
        mov AL, ANS[BX]
        add AL, DL ;carry in + ANS[i]
        mov AH, 00H
        mov DH, 0AH
        div DH ;AX/10 = AL
        mov ANS[BX], AH ;reminder to ANS[i]
        mov DL, AL ;carry out  = AX/10 = AL
        loop Fix_Carry
    ;complete

    jmp END_factorial
    
    
    ;end
    END_factorial:
        pop AX
        RET
factorial ENDP 


;end
END_main:
.EXIT
END



