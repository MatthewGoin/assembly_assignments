TITLE pa7.asm
; Author:  Matthew Lynn-Goin
; Date:  15 APRIL 2018
; Description: This program presents a menu allowing the user to pick a menu option
;              which then performs a given task.
; 1.  Calculate Primes.
; 3.  Exit the program.
;/////////////////////////////////////////////////////////////////////////////////////
; ====================================================================================

Include Irvine32.inc 

;//declare prototypes to use with invoke

Primes proto
displayPrimes proto, prtPrime: ptr dword, szPrime: dword, enteredNum: dword
ClearStr proto, ptrPrime2: ptr dword
restoreArray proto, ptrPrime3: ptr dword

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
'PRIMES PROGRAM', 0Ah, 0Dh,
'The user will enter a number from 2-1000', 0Ah, 0Dh,
'This program will then calculate and diplay all primes at or before that number', 0Ah, 0Dh,
'Please select from the following menu items:', 0Ah, 0Dh,
'1. Calculate Primes. ',0Ah, 0Dh,
'2. Exit: ',0Ah, 0Dh, 0h

Menuprompt2 byte 'Would you like to go again?[1-for yes|2-for no.]', 0ah, 0dh, 0h ;//2nd menu display

UserOption byte 0h ;//declare a variable to hold the user option
UserOption2 byte 0h ;//declare another variable to hold the second user option
errormessage byte 'You have entered an invalid option. Please try again.', 0Ah, 0Dh, 0h ;//an array to display an error message



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
INVOKE Primes
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
;///////////////////////////////////////////////////////////////////////////////////////////////
Primes proc
;// Description: Procedure to calculate the primes between 2 and a given number N
;// Requires: Nothing.
;// Returns: An array filled with the prime number between 2 and N.

.data


PrimesPrompt byte 'Please enter a number from 2 to 1000', 0ah, 0dh, 0h ;//2nd menu display
PrimesPrompt2 byte 'You entered a number outside the desired range, please enter a number from 2-1000', 0ah, 0dh, 0h;
primeArray byte 1000 dup(1); //array to mark off non prime numbers
primeHolder dword 168 dup(0); //array to hole the prime numbers
sqrt1k byte 31; //hard coded sqrt of 1000
userNum dword 0;
counter dword 2;
counter2 dword 0;
counter3 dword 0;
counter4 dword 0;

.code

starthere2:
mov userNum, 0 ;//clear variable
mov counter, 2 ;//set variable
mov counter3, 0 ;//clear variable
push edx;//save edx
mov edx, offset PrimesPrompt ;//move the offset of primespromtp into edx
call writestring ;//display the message
pop edx;//restore edx
push eax;//save eax
call readdec ;//get user input
mov userNum, eax ;//save the user entered number
pop eax ;//restore eax
cmp userNum, 2 ;//see if the user enetered soomthing less that 2
jae nextComp ;//if not go the next check
push edx;//save edx
mov edx, offset PrimesPrompt2 ;//move the offset of primesprompt2 into edx
call writestring ;//display the message
pop edx;//restore edx
call waitmsg ;//make the user see the message
jmp starthere2 ;//start over
nextComp:
cmp userNum, 2
ja nextCompp
mov edx, offset primeHolder
mov eax, userNum
mov [edx], eax
mov counter3, 1;
jmp finale
nextCompp:
cmp userNum, 1000 ;//see if the user entered above 1000
jbe letsGo ;//if not jump to lets go
push edx;//save edx
mov edx, offset PrimesPrompt2 ;//move the offset of primesprompt2
call writestring ;//display the message
pop edx;//restore edx
call waitmsg ;//make the user see the string
jmp starthere2 ;//startover
letsGo:


clearEAX
mov esi, 2 ;//move 2 to esi
mov ecx, userNum ;//move the user entered number into ecx
mov edx, offset primeArray ;//move the offset of primearray into edx
add edx, esi ;//make edx point to 2
;mov edx, [primeArray + esi];

L1:
clearEAX
mov al, [edx] ;//move element into al
cmp al, 1 ;//see if it is 1
jne skipMid ;//if it is 0 skip
push ecx;//save ecx
push edx;//save edx
mov ecx, userNum ;//move the user num into ecx
mov eax, counter ;//move variable into eax
mov ebx, counter ;//move same varibale into ebx
mul bl ;//multiply the numbers together(basically this is done to square the number)
mov edx, offset primeArray ;//move the offset of primeArray into edx
add edx, eax ;//have edx start at i^2
mov counter4, eax ;//move i^2 into variable
;mov edx, offset [primeArray + al] ;;/////WOULD NOT COMPILE BECAUE OF THIS LINE THIS IS NOT LEGAL
;push eax;////
	L2:
	mov eax, counter4 ;//move variable into eax
	cmp eax, userNum ;//basically this is a loop "as long as its not greater than N"
	jae skipL1 ;//skip its greater than N
	mov eax, 0
	mov [edx], al ;//move zero into the element pointed to by edx
	add edx, counter ;//incrememnt by i
	mov eax, counter 
	add counter4, eax
	loop L2
skipL1:
;pop eax;//////
pop edx;//restore edx
pop ecx;//restore ecx
skipMid:
inc counter ;//incrment counter
inc edx ;//point to next element
loop L1;

clearEBX
push ecx ;//save ecx
push edx ;//save edx
push esi ;//save esi
mov counter2, 2 ;//set counter2
mov ecx, userNum ;//move the uuser enteerd number into ecx
sub ecx, counter2 ;//starrting at 2 so subtract 2 from the counter
mov edx, offset primeArray ;//move the offset of primearray into edx
add edx, counter2 ;//have edx start at 2
;mov edx, offset [primeArray + counter2];//////////////////////////ILLEGAL LINE
mov esi, offset primeHolder ;//move the offset of primeHolder into esi

L3:
mov bl, [edx] ;//move element into bl
cmp bl, 1 ;//see if its 1
jne skip2 ;//if its not jump to skip2
mov eax, counter2 ;//move counter2 into eax
mov [esi], eax ;//move that number into esi-this will be a prime number
inc counter3; //increment counter 3
add esi, 4; //point to next available space
skip2:
inc edx; //point to next element
inc counter2 ;//increment counter2
loop L3;

pop esi ;//restore registers
pop edx
pop ecx

finale:
;mov edx, offset primeHolder
;mov ecx, counter3
;mov ebx, userNum
INVOKE displayPrimes, ADDR primeHolder, counter3, userNum ;//INVOKE THE PROCEDURE-list the raguments
push edx ;//save edx
;mov edx, offset primeHolder
INVOKE clearStr, ADDR primeHolder ;//INVOKE THE PROCEDURE-list the argument
pop edx; //restor edx
push edx ;//save edx
;mov edx, offset primeArray
INVOKE restoreArray, ADDR primeArray ;//INVOKE THE PROCEDURE-list the argument
pop edx ;//restore edx

ret
Primes endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////
displayPrimes PROC,
prtPrime: ptr dword,
szPrime: dword,
enteredNum: dword
;//declare the local variables
;// Description:  displays the prime numbers in specified format
;// Requires:  INVOKE with arguments: pointer to primeHolder, the variable counter3, and the variable userNUm
;// Returns:  Nothing, but the primes are displayed in proper format.


.data

displayprompt1 byte 'There are: ', 0h


displayprompt3 byte '-------------------------------', 0ah, 0dh, 0h
displayprompt2 byte ' PRIMES between 2 and n (n =  ', 0h

.code
mov ecx, szPrime ;//move the passed in arguments into the proper registers
mov edx, prtPrime
mov ebx, enteredNum

push edx ;//save dx
mov edx, offset displayprompt1 ;//move the offset of displayprompt1 into edx
call writestring ;//display the message
pop edx ;//restore edx

push eax ;//save eax
mov eax, ecx ;//mov ecx into eax
call writedec ;//display the number of primes in the range
pop eax ;//restore eax
;call crlf

push edx ;//save dx
mov edx, offset displayprompt2 ;//move the offset of displayprompt2 into edx
call writestring ;//display the message
pop edx ;//restore edx

mov eax, ebx ;//move ebx into eax
call writedec ;//display the uster entered number N
call crlf;

push edx;//save edx
mov edx, offset displayprompt3 ;//move the offset of displayprompt3 into edx
call writestring ;//display the message
pop edx ;//restore edx
mov eax, ecx ;//move ecx into eax
mov bl, 5 ;//move 5 into bl
div bl ;//divide by 5
cmp al, 0 ;//see if the quotient is zero
je skip3 ;//if it is then jump to skip3- only going to be displaying the remainder
movzx ecx, al ;//move zero extend the quotient into ecx
push eax ;//save eax
L4:
push ecx ;//save ecx
mov ecx, 5 ;//move 5 into ecx
	L5:
	mov eax, [edx] ;//move element into eax
	call writedec ;//display the element
	push ecx ;//save ecx
	cmp eax, 10 ;//see if the number is a single digit
	jae nextComp ;//if not then jump
	mov ecx, 5 ;//move 5 into ecx
		L6:
		mov al, 20h ;//move space into al
		call writechar ;//display the space
		loop L6
	jmp endL5 ;//jump
	nextComp:
	cmp eax, 100 ;//see if the number is a double digit
	jae finalComp;
	mov ecx, 4 ;//move 4 into ecx
		L62:
		mov al, 20h ;//move space into al
		call writechar ;//display the space
		loop L62
	jmp endL5
	finalComp:
	mov ecx, 3 ;//if here it is a 3 digit number
		L63:
		mov al, 20h ;//move space into al
		call writechar ;//dispaly the space
		loop L63
	endL5:
	pop ecx ;//restor ecx
	add edx, 4 ;//point to next element
	loop L5
call crlf
pop ecx;//restore ecx
loop L4;

pop eax; //restor eax
cmp ah, 0 ;//see if the remainder is 0
je endDisplay; //if it is we are done

skip3:
movzx ecx, ah ;//move zero extend the remainder into ecx
L7:
mov eax, [edx] ;//move element into eax
call writedec ;//display the element
push ecx ;//save ecx
	cmp eax, 10 ;//see if number is single digit
	jae nextComp2
	mov ecx, 5
		L8:
		mov al, 20h
		call writechar
		loop L8
	jmp endL7
	nextComp2:
	cmp eax, 100 ;//see if number is double digit
	jae finalComp2;
	mov ecx, 4
		L82:
		mov al, 20h
		call writechar
		loop L82
	jmp endL7
	finalComp2:
	mov ecx, 3 ;//if here then the number is triple digit
		L83:
		mov al, 20h
		call writechar
		loop L83
	endL7:
	pop ecx ;//restore ecx
	add edx, 4
	loop L7

endDisplay:
ret
displayPrimes ENDP
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////
restoreArray proc,
ptrPrime3: ptr dword
;// Description: Procedure to restore the primeArray with positive values
;// Requires: INVOKE with argument of a ptr to the offset of primearray.
;// Returns: The primeArray filled with positive values again.

.data
rstrArray dword 1000 ;//declare a variable, the max size of the array

.code
mov ecx, rstrArray; //set ecx counter
L5:
mov edx, ptrPrime3 ;//move local variable into edx
clearEAX
mov al, 1 ;//move 1 into al
mov [edx], al ;//move 1 into to space that edx points to
inc edx ;//point ot the next element
loop L5;

ret
restoreArray endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////
ClearStr PROC,
ptrPrime2: ptr dword
Comment !
Description:  Procedure to clear the string
Receives: INVOKE argument of pointer ot the beginning of the primeHolder array.
Returns:  the cleared out array
!


.data
clrStr word 168; //declare variable the max size of array
.code
mov edx, ptrPrime2 ;//move local variable into edx
movzx ecx, clrStr; //move zero extend clrstr into ecx to set the loop counter
L6:
clearEAX; //clear the eax register
mov [edx], al; //move zero into the array postion edx points to
inc edx; //have edx point to the next element
loop L6;

ret;
ClearStr ENDP;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
END main;