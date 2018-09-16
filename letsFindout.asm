TITLE pa8v2.asm
; Author:  Matthew Lynn-Goin
; Date:  23 APRIL 2018
; Description: This program presents a menu allowing the user to pick a menu option
;              which then performs a given task.
; 1.  Calculate Primes.
; 3.  Exit the program.
;/////////////////////////////////////////////////////////////////////////////////////
; ====================================================================================

Include Irvine32.inc 

;//declare prototypes to use with invoke

fillMatrix proto, matrixPtr: ptr byte, matrixRow: byte
displayMatrix proto, matrixPtr2: ptr byte, matrixRow1: byte
matrixLetters proto, matrixPtr3: ptr byte, matrixRow2: byte
clearMatrix proto, mtrxPtr: ptr byte

;//Macros
ClearEAX textequ <mov eax, 0> ;//macros to clear the registers
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>

.data

Menuprompt1 byte 'MAIN MENU', 0Ah, 0Dh, ;//menu display
'==========', 0Ah, 0Dh,
'MATRIX PROGRAM', 0Ah, 0Dh,
'This program will generate a matrix of randomly chosen letters', 0Ah, 0Dh,
'Each letter has a 50% chance of being a vowel', 0Ah, 0Dh,
'The program will then display the rows, columns and diagonals with at least 2 vowels', 0Ah, 0Dh,
'Please select from the following menu items:', 0Ah, 0Dh,
'1. Run the program. ',0Ah, 0Dh,
'2. Exit: ',0Ah, 0Dh, 0h

Menuprompt2 byte 'Do you want to run the program again?[1-yes|2-No] ', 0ah, 0dh, 0h ;//2nd menu display

UserOption byte 0h ;//declare a variable to hold the user option
UserOption2 byte 0h ;//declare another variable to hold the second user option
errormessage byte 'You have entered an invalid option. Please try again.', 0Ah, 0Dh, 0h ;//an array to display an error message

matrix byte 0h, 0h, 0h, 0h, 0h
	   byte 0h, 0h, 0h, 0h, 0h
	   byte 0h, 0h, 0h, 0h, 0h
	   byte 0h, 0h, 0h, 0h, 0h
	   byte 0h, 0h, 0h, 0h, 0h
	   
rowsize = 5



.code
main PROC

call ClearRegisters          ;// clears registers
;cleareax
;clearebx
;clearecx
;clearedx
;clearesi
;clearedi

startHere:
call clrscr ;//clear the screen
mov edx, offset menuprompt1 ;//move the offset of menu prompt into edx
call WriteString ;//display the menu 
call readhex ;//read the user choice
mov useroption, al ;//save the user choice

opt1:
cmp useroption, 1 ;//check to see if the user entered 1
jne opt2 ;//jump if not equa to opt2
call clrscr ;//clear the screen
INVOKE fillMatrix, ADDR matrix, rowsize
INVOKE displayMatrix, ADDR matrix, rowsize
INVOKE matrixLetters, ADDR matrix, rowsize
INVOKE clearMatrix, ADDR matrix
call crlf
push edx ;//push edx to the stack
mov edx, offset Menuprompt2; //move offset of menuprompt2 into edx
call writestring; //display the message
pop edx ;//restore edx
call readhex; //get 2nd user input
mov UserOption2, al ;//mov user input into variable
cmp UserOption2, 2 ;//see if they selected 2
je quitit; //if they did-end the program
jmp starthere ;//jump back to starthere

opt2:
cmp useroption, 2 ;//check to see if the user entered 6
jne oops ;//jump not equal to oops
jmp quitit ;//jump to quitit
oops:
push edx ;//push edx to the stack
mov edx, offset errormessage ;//move the offset of errormessage into edx
call writestring ;//display the error message
call waitmsg ;//make the user see the message and wait for a keyboard entry
pop edx ;//restore contents of edx
jmp starthere ;//jump back to starthere

;//end the program....
quitit:
exit
main ENDP
;// Procedures
;// ===============================================================
ClearRegisters Proc
;// Description:  Clears the registers EAX, EBX, ECX, EDX, ESI, EDI
;// Requires:  Nothing
;// Returns:  Nothing, but all registers will be cleared.

cleareax
clearebx
clearecx
clearedx
clearesi
clearedi

ret
ClearRegisters ENDP
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
fillMatrix proc,
matrixPtr: ptr byte,
matrixRow: byte


.data

array1 byte 42h, 43h, 44h, 46h, 47h, 48h, 4ah, 4bh, 4ch, 4dh, 4eh, 50h, 51h, 52h, 53h, 54h, 56h, 57h, 58h, 59h, 5ah
array2 byte 41h, 45h, 49h, 4fh, 55h

array1len byte 21;
array2len byte 5;
RandRange = 256;
randRange2 = 20;
randRange3 = 4;

.code
mov edx, matrixPtr
movzx ecx, matrixRow;//////////////////////////////////CHANGED HERE
mov ecx, 25

L1:
;push edx
clearEAX;
;clearEDX
call Randomize; //set the see for the randomization functions
mov eax, RandRange; //move the random limmit to eax
call RandomRange; //generate a random number
mov bl, 2; //move 2d into bl
div bl; //divide
cmp ah, 0
ja next

mov esi, offset array1
mov eax, randRange2
call RandomRange
add esi, eax
mov bl, [esi]
mov [edx], bl
jmp endloop
next:
mov esi, offset array2
mov eax, randRange3
call RandomRange
add esi, eax
mov bl, [esi]
mov [edx], bl
endloop:
inc edx
loop L1

ret
fillMatrix endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
displayMatrix proc,
matrixPtr2: ptr byte,
matrixRow1: byte

.data
displayprompt1 byte 'The Matrix is: ', 0ah, 0dh, 0h
;vowelCount byte 0;

.code
push edx
mov edx, offset displayprompt1
call writestring
pop edx

call crlf

mov edx, matrixPtr2
;push ecx
movzx ecx, matrixRow1;/////////////////////////////////////////////////////CHANGED HERE
L2:
push ecx
movzx ecx, matrixRow1;/////////////////////////////////////////////////CHANGED HERE
	L3:
	mov al, [edx]
	call writechar
	inc edx
	loop L3
call crlf
pop ecx
loop L2;

ret
displayMatrix endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
matrixLetters proc,
matrixPtr3: ptr byte,
matrixRow2: byte
;// Description: Procedure to calculate the primes between 2 and a given number N
;// Requires: Nothing.
;// Returns: An array filled with the prime number between 2 and N.

.data
lettersPrompt byte 'The words from this matrix is/are: ', 0ah, 0dh, 0h
vowelArray byte 41h, 45h, 49h, 4fh, 55h
vowelCount byte 0;

.code
mov vowelCount, 0
clearEAX
push edx
mov edx, offset lettersPrompt
call writestring
pop edx

call crlf


mov edx, matrixPtr3
movzx ecx, matrixRow2

;///////////this is for the rows
L3:
mov vowelCount, 0
push ecx
push edx
mov ecx, 5
	L31:
	push ecx
	;push edx
	mov ecx, 5
	mov esi, offset vowelArray
		L311:
		mov al, [edx]
		mov bl, [esi]
		cmp al, bl
		jne skip ;/////////////////////////////////////////CHANGED HERE
		inc vowelCount
		jmp breakloop
		skip:
		inc esi
		loop L311
	breakloop:
	pop ecx
	inc edx
	loop L31;
pop edx
pop ecx
mov al, vowelCount
cmp al, 2
jb skip2
push ecx
push edx
mov ecx, 5
	L32:
	mov al, [edx]
	call writechar
	inc edx
	loop L32
pop edx
pop ecx
;call crlf
mov al, 20h
call writechar
skip2:
add edx, 5;
loop L3;

mov edx, matrixPtr3
movzx ecx, matrixRow2
;////////this is for columns
L4:
mov vowelCount, 0
push ecx
push edx
mov ecx, 5
	L41:
	push ecx
	;push edx
	mov ecx, 5
	mov esi, offset vowelArray
		L411:
		mov al, [edx]
		mov bl, [esi]
		cmp al, bl
		jne skip11 ;/////////////////////////////////////CHANGED HERE
		inc vowelCount
		skip11:
		inc esi
		loop L411
	pop ecx
	add edx, 5
	loop L41;
pop edx
pop ecx
mov al, vowelCount
cmp al, 2
jb skip22
push ecx
push edx
mov ecx, 5
	L42:
	mov al, [edx]
	call writechar
	add edx, 5
	loop L42
pop edx
pop ecx
;call crlf
mov al, 20h
call writechar
skip22:
inc edx;
loop L4;
		
mov edx, matrixPtr3
;////////////this is for the diaginals
mov ecx, 5
mov vowelCount, 0
L5:
push ecx
mov ecx, 5
mov esi, offset vowelArray
	L51:
	mov al, [edx]
	mov bl, [esi]
	cmp al, bl
	jne skip12 ;////////////////////////////////////////////CHANGED HERE
	inc vowelCount
	skip12:
	inc esi
	loop L51
pop ecx
add edx, 6
loop L5;

mov al, vowelCount
cmp al, 2
jb skip23
mov edx, matrixPtr3
mov ecx, 5
L6:
mov al, [edx]
call writechar
add edx, 6
loop L6
mov al, 20h
call writechar


skip23:
mov vowelCount, 0
mov edx, matrixPtr3
add edx, 20
mov ecx, 5
L7:
push ecx
mov ecx, 5
mov esi, offset vowelArray
	L71:
	mov al, [edx]
	mov bl, [esi]
	cmp al, bl
	jne skip13  ;/////////////////////////CHANGED HERE
	inc vowelCount
	skip13:
	inc esi
	loop L71
pop ecx
sub edx, 4
loop L7;

mov al, vowelCount
cmp al, 2
jb endFunction
mov edx, matrixPtr3
add edx, 20
mov ecx, 5
L8:
mov al, [edx]
call writechar
sub edx, 4
loop L8
mov al, 20h
call writechar

endFunction:
ret
matrixLetters endp
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
clearMatrix proc,
mtrxPtr: ptr byte


.data
matrixElements byte 25;

.code
movzx ecx, matrixElements ;//////////////////////////////////CHANGED HERE
mov edx, mtrxPtr

L9:
clearEAX
mov [edx], al
inc edx
loop L9

ret
clearMatrix endp
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


END main