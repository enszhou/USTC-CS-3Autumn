.model small
.data
NUM DB 100 DUP(0)
.stack 100H

.code  
start:
mov BP, SP
MOV  AX, @DATA
MOV  DS,AX

;read n
mov AH, 01H
int 21H
push AX

sub AL, 30H ;ascii to number
mul AL
mov CX, AX ;repeat times

;set 2d array
L1:
mov BX, CX 
dec BX
mov NUM[BX], CL
loop L1

;print
;\r\n
mov AH ,02H 
mov DL, 0DH 
int 21H
mov DL, 0AH 
int 21H

pop CX
sub CL, 30H ;ascii to number
mov CH, 00H
mov DL, CL ;DL=n

;outer loop
L2:
mov DH, DL
sub DH, CL
inc DH ;row
mov DI, CX ;save CX

mov CL, DH
mov CH, 00H ; j =1:row

;inner loop
L3:

;liner order
mov AL, DH
dec AL 
mul DL ;AX = (row-1)*n =AL
add AL, DH 
sub AL, CL
mov BL, AL
mov BH, 00H
mov BL, NUM[BX] ;BL = num

;2 or 1 bits
cmp BL, 0AH ;BL >= 10?
JB B1

;B2
mov BH, DL
mov AL, BL
mov AH, 00H
mov BL, 0AH
div BL ;AX/10

mov BL, AH; 1*

;10*
mov DL, AL
add DL, 30H
mov AH, 02H
int 21H 

;1*
mov DL, BL
add DL, 30H
mov AH, 02H
int 21H

mov DL, BH ;recorver
jmp Bspace

;num only 1 digit
B1:
add BL, 30H
XCHG BL, DL ;DL = n ,AL = ascii num
mov AH, 02H
int 21H
XCHG BL,DL

Bspace:
mov BL, DL
mov DL, 20H
mov AH, 02H
int 21H
mov DL, BL

Loop L3

;print \n
mov BL, DL
mov AH ,02H 
mov DL, 0DH 
int 21H
mov DL, 0AH 
int 21H
mov DL, BL

mov CX, DI
LOOP L2



mov AH, 4CH
int 21H

END start