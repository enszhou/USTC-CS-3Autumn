.model small
.data
N DW 0
B DW 0
IN_NAME DB "Input3.txt" , 0
BUFF_FILE_IN DB 1000 DUP(?)
NUM DW 100 DUP(0)
FILE DW 0000H

.stack 100H

.code  
start:
mov BP, SP
MOV  AX, @DATA
MOV  DS,AX

;open Input3.txt
lea DX, IN_NAME
mov AL, 00H
mov AH, 3DH
int 21H
mov FILE, AX ;save Input3.txt handle

;read Input3.txt
lea DX, BUFF_FILE_IN
mov BX, AX
mov CX, 1000 ;max
mov AH, 3FH
int 21H
mov B, AX ; the number of bytes read really


;close Input3.txt
mov BX, FILE ; file handle to BX
mov AH, 3EH
int 21H 

;transform to number
mov CX, B

L1: 
mov BX, B
sub BX, CX ;BX = B - CX

mov SI, 0  ;simulate
mov AL, BUFF_FILE_IN[BX] ;signal
cmp AL , 2DH ; == '-'?
je Negtive

Positive_Loop:
    ;mov AL,  BUFF_FILE_IN[BX]
    sub AL, 30H
    push AX
    mov AX, 000AH
    mul SI
    mov SI, AX
    pop AX 
    mov AH, 00H ;number
    add SI, AX; SI = SI*10+number
    ;space?
    inc BX 
    mov AL, BUFF_FILE_IN[BX]
    cmp AL, 20H 
    jne Positive_Loop
    jmp END_NUMBER

Negtive:
    inc BX
    mov AL,  BUFF_FILE_IN[BX]
Negtive_Loop:
    sub AL, 30H
    push AX
    mov AX, 000AH
    mul SI
    mov SI, AX
    pop AX 
    mov AH, 00H ;number
    add SI, AX; SI = SI*10+number
    ;space?
    inc BX 
    mov AL, BUFF_FILE_IN[BX]
    cmp AL, 20H 
    jne Negtive_Loop
    ;==space
    neg SI
    jmp END_NUMBER



END_NUMBER:
    push BX
    mov BX, N
    add BX, N
    mov NUM[BX], SI

    inc N
    pop BX
    mov CX, B
    sub CX, BX
loop L1



;end of read number
;N = quantity of numbers ;NUm = array of numbers

;buble sort
mov CX, N
dec CX ;♀ N - 1 ♀
OUTER_LOOP:
    mov BX,0000H
INNER_LOOP:
    mov SI, NUM[BX]
    mov DI, NUM[BX+2]
    cmp SI, DI
    jng NEXT ; SI <= DI
        ;SI > DI
        mov NUM[BX], DI
        mov NUM[BX+2], SI
    NEXT:
        add BX, 2
        mov AX, CX
        add AX, CX
        cmp BX, AX
        jb INNER_LOOP ;BX < CX 

loop OUTER_LOOP

;print NUM
mov CX, N
PRINT_NUMBER:
    mov BX, N
    sub BX, CX
    add BX, BX ;BX = 2(N-CX)
    mov SI, NUM[BX] ;SI = NUMBER
    cmp SI, 00H
    jnl Positive_Number

Negative_Number:
    ;print '-' then SI > 0
    mov AH, 02H
    mov DL, 2DH
    int 21H ;print '-'
    neg SI ;SI to Positive

Positive_Number:
    ;use CX
    mov DI, CX
    ; SI > 0

    mov AX, SI 
    mov DL, 0AH

 

    ; sentry
    mov BX, 0000H
    push BX

    mov CX, 04H ; max 4 digits



    CAL_EVERY_DIGIT:
    div DL ;AL = SI/10 AH = SI%10
    push AX ; reminder = AH
    mov AH, 00H ;AX = 00:SI/10
    loop CAL_EVERY_DIGIT




    mov CX, 04H ; max 4 digits
    RM_HIGH_ZERO:
    pop AX
    cmp AH, 00H
    jne PRINT_DIGIT
    loop RM_HIGH_ZERO
    inc CX; SI==0

    PRINT_DIGIT:
    mov DL, AH
    add DL, 30H 
    mov AH, 02H
    int 21H
    pop AX
    loop PRINT_DIGIT

    ;recovery CX
    mov CX, DI 

    ;print '\r\n'
    mov AH ,02H 
    mov DL, 0DH 
    int 21H
    mov DL, 0AH 
    int 21H

loop PRINT_NUMBER


mov AH, 4CH
int 21H

END start