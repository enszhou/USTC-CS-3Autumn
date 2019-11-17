.model small
.data
PROMPT DB "Please enter a string$"
IN_NAME DB "Input1.txt" , 0
OUT_NAME DB "Output1.txt", 0
BUFF_STD_IN DB 100, ? , 100 DUP(?)
BUFF_FILE_IN DB 100 DUP(?)
BUFF_FILE_OUT DB 100 DUP(?)

.stack 100H

.code  
start:
;set data segment
MOV  AX, @DATA
MOV  DS,AX

;create Input1.txt
lea DX, IN_NAME
mov CX, 00H
mov AH, 3CH 
int 21H 
push AX ;save file handle

;input string
lea DX, BUFF_STD_IN 
mov AH, 0AH
int 21H

;write Input1.tx 
lea DX, BUFF_STD_IN + 2
;mov BX, [BP-2]
pop BX
push BX
mov CH, 00H
mov CL, BUFF_STD_IN[1]
mov AH, 40H
int 21H


;close Input1.txt
pop BX ;pop file handle to BX
mov AH, 3EH
int 21H 

;open Input1.txt
lea DX, IN_NAME
mov AL, 00H
mov AH, 3DH
int 21H
push AX ;push Input1.txt handle

;read Input1.txt
lea DX, BUFF_FILE_IN
pop BX
push BX
mov CX, 90 ;max
mov AH, 3FH
int 21H
mov DX, AX ; the number of bytes read really

;close Input1.txt
pop BX ;pop file handle to BX
mov AH, 3EH
int 21H 

;transfer
push DX ;number
mov CX, DX ;repeat number

mov BX, CX
mov BUFF_FILE_OUT[BX], 24H ; '$'
;if null
cmp CX, 0H
je Next


;not null
L1:
    mov BX, CX
    mov AL, BUFF_FILE_IN[BX - 1]
    cmp AL, 61H
    jb Next2
        sub AL, 20H
    Next2:
    mov BUFF_FILE_OUT[BX-1], AL
    loop L1

Next:
;print
mov DL, 0AH
mov AH, 02H
int 21H
lea DX, BUFF_FILE_OUT
mov AH, 09H
int 21H

;create Output1.txt
lea DX, OUT_NAME
mov CX, 00H
mov AH, 3CH 
int 21H 
;push AX ;save file handle

;write Output1.txt 
lea DX, BUFF_FILE_OUT
;mov BX, [BP-2]
mov BX, AX
pop CX ;length
push BX
mov AH, 40H
int 21H

;close Output1.txt
pop BX ;pop file handle to BX
mov AH, 3EH
int 21H 



mov AH, 4CH
int 21H

END start