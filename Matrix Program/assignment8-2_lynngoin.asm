TITLE pa8_2.asm
; Author:  Matthew Lynn-Goin
; Date:  23 APRIL 2018
; Description: This program genterate a matrix of random capital letters
;Each letter has a 50% chance of being a vowel. Then the program prints the matrix
;and display the words in the matrix that contain 2 vowels(rows, columns, or diagonals).
; 1.  Run the program.
; 3.  Exit the program.
;///NOTE: "Y" is nto considered a vowel in this program
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
;// Description:  Fills the matrix wiith random capital letters
;// Requires:  [AS ARGUMENTS] pointer to beginning of matrix, and the row size of the matrix
;// Returns:  The matrix filled with random numbers.



.data

array1 byte 42h, 43h, 44h, 46h, 47h, 48h, 4ah, 4bh, 4ch, 4dh, 4eh, 50h, 51h, 52h, 53h, 54h, 56h, 57h, 58h, 59h, 5ah ;//declare array of non-vowels
array2 byte 41h, 45h, 49h, 4fh, 55h ;//declare array of vowels

array1len byte 21;
array2len byte 5;
RandRange = 256;
randRange2 = 20;
randRange3 = 4;

.code
call Randomize; //set the see for the randomization functions [SIDE NOTE-this was inside a loop and generated an error, it worked when debugging but didnt when just running the program-so must be outside of a loop]
mov edx, matrixPtr ;//move local variable containg address of matrix into edx
movzx ecx, matrixRow;//                                                     ////////////////////////////////CHANGED HERE
mov ecx, 25 ;//set the loop counter

L1:
clearEAX;
mov eax, RandRange; //move the random limmit to eax
call RandomRange; //generate a random number
mov bl, 2; //move 2d into bl
div bl; //divide [basically heads or tails]
cmp ah, 0
ja next

mov esi, offset array1 ;//move the offset of arra1 into esi
mov eax, randRange2 ;//move limit into eax
call RandomRange
add esi, eax ;//point to the random letter
mov bl, [esi]
mov [edx], bl ;//move that letter into the matrix
jmp endloop
next:
mov esi, offset array2 ;//move the offset of array2 into esi
mov eax, randRange3 ;//set the limit for the random number
call RandomRange
add esi, eax ;//point to the proper element
mov bl, [esi] 
mov [edx], bl ;//move that element into the matrix
endloop:
inc edx
loop L1

ret
fillMatrix endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
displayMatrix proc,
matrixPtr2: ptr byte,
matrixRow1: byte
;// Description:  Displays the matrix
;// Requires:  [AS ARGUMENTS] a pointer to the beginning of the matrix, the row size of the matrix
;// Returns:  NOTHING.


.data
displayprompt1 byte 'The Matrix is: ', 0ah, 0dh, 0h
;vowelCount byte 0;

.code
push edx
mov edx, offset displayprompt1 ;//move the offset of displayprompt1 into edx
call writestring ;//display the message
pop edx

call crlf

mov edx, matrixPtr2 ;//mov local variable containg address of beginning of matrix into edx
;push ecx
movzx ecx, matrixRow1;//set the loop counter via the local variable        ////////CHANGED HERE
L2:
push ecx ;//save ecx
movzx ecx, matrixRow1;//set the loop counter              /////////CHANGED HERE
	L3:
	mov al, [edx] ;//move matrix element into al
	call writechar ;//display the element
	inc edx ;//pointot next element
	loop L3
call crlf
pop ecx
loop L2;

call crlf

ret
displayMatrix endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
matrixLetters proc,
matrixPtr3: ptr byte,
matrixRow2: byte
;// Description: this function goes through the matrix and determines what words contain two vowels(row, column, or diagonal)
;// Requires: [AS ARGUMENTS] pointer to the beginning of the matrix, the row size of the matrix.
;// Returns: NOTHING BUT DISPLAYS the numbers.

.data
lettersPrompt byte 'The words from this matrix is/are: ', 0ah, 0dh, 0h
vowelArray byte 41h, 45h, 49h, 4fh, 55h
vowelCount byte 0;

.code
mov vowelCount, 0 ;//clear the variable
clearEAX;//clear eax
push edx ;//save edx
mov edx, offset lettersPrompt ;//move offset of message into edx
call writestring ;//display the message
pop edx ;//restor edx

call crlf


mov edx, matrixPtr3 ;//have edx point to beginning of array
movzx ecx, matrixRow2 ;//set the loop counter

;///////////this is for the rows
L3:
mov vowelCount, 0 ;//clear the variable
push ecx ;//save ecx
push edx ;//save edx
mov ecx, 5 ;//move 5 into ecx
	L31:
	push ecx ;//save ecx
	;push edx
	mov ecx, 5 ;//move 5 into ecx
	mov esi, offset vowelArray ;//have esi pointot vowel array
		L311:
		mov al, [edx] ;//move matrix element into al
		mov bl, [esi] ;//move vowel element into bl
		cmp al, bl ;//see if matrix element is a vowel
		jne skip ;//                                          /////////CHANGED HERE
		inc vowelCount ;//if it is inc the variable
		jmp breakloop
		skip:
		inc esi ;//point to next element
		loop L311
	breakloop:
	pop ecx ;//restore ecx
	inc edx ;//point to next element
	loop L31;
pop edx ;//restor edx
pop ecx ;//restor ecx
mov al, vowelCount
cmp al, 2 ;//see if at least two elements in the row were vowels
jb skip2
push ecx ;//restor ecx
push edx ;//restore edx
mov ecx, 5
	L32:
	mov al, [edx] ;//move matrix element into al
	call writechar ;//display
	inc edx ;//point to next
	loop L32
pop edx ;//restore edx
pop ecx ;//restore ecx
;call crlf
mov al, 20h
call writechar ;//display a space
skip2:
add edx, 5; //point to next row
loop L3;

mov edx, matrixPtr3 ;//haave edx point to beginning of matrix
movzx ecx, matrixRow2 ;//set the loop counter
;////////this is for columns
L4:
mov vowelCount, 0 ;//clear the variable
push ecx ;//save ecx
push edx ;//save edx
mov ecx, 5
	L41:
	push ecx ;//save ecx
	;push edx
	mov ecx, 5 ;//set innner loop counter
	mov esi, offset vowelArray
		L411:
		mov al, [edx] ;//move matrix element into al
		mov bl, [esi] ;//move vowel element into bl
		cmp al, bl ;//see if matrix element is a vowel
		jne skip11 ;//                               //////////////CHANGED HERE
		inc vowelCount ;//if it is inc variable
		skip11:
		inc esi ;//point to next element
		loop L411
	pop ecx ;//restor ecx
	add edx, 5
	loop L41;
pop edx ;//restor edx
pop ecx ;//restore ecx
mov al, vowelCount
cmp al, 2 ;//see if at least two were vowels
jb skip22
push ecx
push edx
mov ecx, 5 ;//display the column
	L42:
	mov al, [edx]
	call writechar
	add edx, 5 ;//point to next element in same column but one row below
	loop L42
pop edx
pop ecx
;call crlf
mov al, 20h
call writechar ;//display the space
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
	cmp al, bl ;//seee if the lement is a vowel
	jne skip12 ;//                           /////CHANGED HERE
	inc vowelCount ;//if it is increment vowel count
	skip12:
	inc esi ;//point to ext element
	loop L51
pop ecx
add edx, 6 ;//grab the next diagonal[this function goes north west to south east]
loop L5;

mov al, vowelCount
cmp al, 2 ;//see if two element were vowels
jb skip23
mov edx, matrixPtr3
mov ecx, 5 ;//display the diagonal
L6:
mov al, [edx]
call writechar
add edx, 6 ;//point to next element int he diagonal
loop L6
mov al, 20h
call writechar


skip23:
mov vowelCount, 0 ;//clear the variable
mov edx, matrixPtr3 ;//point to beginning of the array
add edx, 20 ;//point to first element int he last row[this function goes south-west to north-east]
mov ecx, 5
L7:
push ecx
mov ecx, 5
mov esi, offset vowelArray
	L71:
	mov al, [edx]
	mov bl, [esi]
	cmp al, bl ;//see if it is a vowel
	jne skip13  ;//                ////CHANGED HERE
	inc vowelCount
	skip13:
	inc esi ;//point ot next element
	loop L71
pop ecx
sub edx, 4
loop L7;

mov al, vowelCount
cmp al, 2 ;//see if at least two vowels were in the diagonal
jb endFunction
mov edx, matrixPtr3
add edx, 20 ;//point to the first element int he last row 
mov ecx, 5
L8:
mov al, [edx]
call writechar
sub edx, 4 ;//go north east in the diagonal
loop L8
mov al, 20h
call writechar

endFunction:
ret
matrixLetters endp
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
clearMatrix proc,
mtrxPtr: ptr byte
;// Description: this function clears th ematrix and restors it to zeros
;// Requires: [AS ARGUMENTS] pointer to the beginning of the matrix.
;// Returns: The cleared out matrix.


.data
matrixElements byte 25;

.code
movzx ecx, matrixElements ;//////////////////////////////////CHANGED HERE
mov edx, mtrxPtr ;//have edx point to beginning of matrix

L9:
clearEAX ;//clear eax
mov [edx], al ;//move zero into matrix position
inc edx ;//point to next matrix positon
loop L9

ret
clearMatrix endp
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


END main