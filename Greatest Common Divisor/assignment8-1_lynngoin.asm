TITLE pa8_1.asm
; Author:  Matthew Lynn-Goin
; Date:  23 APRIL 2018
; Description: This program presents a menu allowing the user to pick a menu option
;              which then performs a given task. Specifically, the program calculates the gcd of two numbers and determines if that gcd is prime
; 1.  RUN PROGRAM.
; 3.  Exit the program.
;/////////////////////////////////////////////////////////////////////////////////////
; ====================================================================================

Include Irvine32.inc 

;//declare prototypes to use with invoke

gcdFunction proto, numOne: dword, numTwo: dword
getInput proto, ptrNum1: ptr dword, ptrNum2: ptr dword
Primes proto, One: dword, Two: dword, Three: dword
displayPrimes proto, userNum1: dword, userNum2: dword, userGCD: dword, isPrime: byte
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
'GCD PROGRAM', 0Ah, 0Dh,
'The user will enter 2 numbers [1000 is the max]', 0Ah, 0Dh,
'This program will then calculate the GCD of the two numbers', 0Ah, 0Dh,
'And determine if the GCD is prime', 0Ah, 0Dh,
'Please select from the following menu items:', 0Ah, 0Dh,
'1. Run the program[enter 2 numbers]]. ',0Ah, 0Dh,
'2. Exit: ',0Ah, 0Dh, 0h

Menuprompt2 byte 'Do you wish to enter another pair?[1-for yes|2-for no.]', 0ah, 0dh, 0h ;//2nd menu display

UserOption byte 0h ;//declare a variable to hold the user option
UserOption2 byte 0h ;//declare another variable to hold the second user option
errormessage byte 'You have entered an invalid option. Please try again.', 0Ah, 0Dh, 0h ;//an array to display an error message

firstNum dword 0;
secondNum dword 0;
mainGCD dword 0;



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
mov firstNum, 0
mov secondNum,0
mov mainGCD, 0
call clrscr ;//clear the screen
mov edx, offset menuprompt1 ;//move the offset of menu prompt into edx
call WriteString ;//display the menu 
call readhex ;//read the user choice
mov useroption, al ;//save the user choice

opt1:
cmp useroption, 1 ;//check to see if the user entered 1
jne opt2 ;//jump if not equa to opt2
call clrscr ;//clear the screen
INVOKE getInput, ADDR firstNum, ADDR secondNum
mov eax, firstNum
mov ebx, secondNum
cmp eax, ebx ;//see which one is bigger
;cmp firstNum, secondNum;
jb mainSkip
INVOKE gcdFunction, firstNum, secondNum
mov mainGCD, eax
jmp keepGoing
mainSkip:
INVOKE gcdFunction, secondNum, firstNum
mov mainGCD, eax
jmp keepGoing
keepGoing:
INVOKE Primes, firstNum, secondNum, mainGCD
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
getInput proc,
ptrNum1: ptr dword,
ptrNum2: ptr dword
;// Description:  Gets the two numbers from the user and performs input validation
;// Requires:  [AS ARGUMENTS]- pointers to the variables that will hold the user entered numbers
;// Returns:  The two user entered numbers.

.data
getinputPrompt byte 'Please enter 2 positive numbers[1000 max]', 0ah, 0dh, 0h ;
getinputPrompt2 byte '1st number: ', 0ah, 0dh, 0h ;
getinputPrompt3 byte '2nd number ', 0ah, 0dh, 0h ;
getinputPrompt4 byte 'You entered a number outside the desired range, please enter a number from 2-1000', 0ah, 0dh, 0h;
getInput1 dword 0;
getInput2 dword 0;

.code
getInputStart:
push edx ;//save edx
mov edx, offset getinputPrompt ;//move offset of message into edx
call writestring ;//display the message
pop edx ;//restor edx

push edx ;//save dx
mov edx, offset getinputPrompt2 ;//move the offset of the messsage into edx
call writestring ;//display the message
pop edx ;//restor edx
call readdec ;//get the first number
mov getInput1, eax ;//save the first number
cmp getInput1, 0 ;//see if the user enetered a negative number
jae nextComp ;//if not go the next check
push edx;//save edx
mov edx, offset getinputPrompt4 ;//move the offset of message into edx
call writestring ;//display the message
pop edx;//restore edx
call waitmsg ;//make the user see the message
jmp getInputStart ;//start over
nextComp:
cmp getInput1, 1000 ;//see if the user enetered soomthing over 1000
jbe letsGo1 ;//if not-good to go
push edx;//save edx
mov edx, offset getinputPrompt4 ;//move the offset of primesprompt2 into edx
call writestring ;//display the message
pop edx;//restore edx
call waitmsg ;//make the user see the message
jmp getInputStart ;//start over

letsGo1:
push edx ;//save edx
mov edx, ptrNum1 ;//have edx point to varibale that will contain the first user number
mov [edx], eax ;//move that number into the varibale pointed to by edx
pop edx ;//restore edx

push edx ;//save edx
mov edx, offset getinputPrompt3 ;//move the offset of thhe message into edx
call writestring; //display
pop edx ;//restore edx
call readdec ;//get the second number
mov getInput2, eax
cmp getInput2, 0 ;//see if the user enetered soomthing below 0
jae nextComp2 ;//if not go the next check
push edx;//save edx
mov edx, offset getinputPrompt4 ;//move the offset of message into edx
call writestring ;//display the message
pop edx;//restore edx
call waitmsg ;//make the user see the message
jmp getInputStart ;//start over
nextComp2:
cmp getInput2, 1000 ;//see if the user enetered soomthing over 1000
jbe letsGo2 ;//if not-good to go
push edx;//save edx
mov edx, offset getinputPrompt4 ;//move the offset of primesprompt2 into edx
call writestring ;//display the message
pop edx;//restore edx
call waitmsg ;//make the user see the message
jmp getInputStart ;//start over
letsGo2:
push edx
mov edx, ptrNum2 ;//move the local variable containg address to varibale that will hold the second number into edx
mov [edx], eax ;//move the second number into the proper space
pop edx

ret
getInput endp
;///////////////////////////////////////////////////////////////////////////////////////////////
gcdFunction proc,
numOne: dword,
numTwo: dword
;// Description:  DETERMINES THE GCD OF THE TWO NUMBERS-EUCLID RECURSIVE FUNCTION-FOUND ON WIKIPEDIA
;// Requires:  [AS ARGUMENTS]- the first user entered number, and the second user enetered number
;// Returns:  GCD of the two numbers.

.data
modNum dword 0;

.code
clearEAX
clearEBX
mov modNum, 0 ;//clear the variable
cmp numTwo, 0 ;//base case see if the second number is 0
ja gcd1; //if not then jump to gcd1
mov eax, numOne ;//if it is put numOne into eax an return
jmp gcd2;

gcd1:
mov edx, 0 ;//clear edx
mov eax, numOne ;//move numOne into eax
mov ecx, numTwo ;//move numtwo into ecx
div cx ;//divide
mov modNum, edx; //move the remainder into modnum
INVOKE gcdFunction, numTwo, modNum ;//recursive call with the modified arguments

gcd2:
ret
gcdFunction endp
;///////////////////////////////////////////////////////////////////////////////////////////////
Primes proc,
One: dword,
Two: dword,
Three: dword
;// Description: Procedure to calculate the primes between 2 and a given number N
;// Requires: Nothing.
;// Returns: An array filled with the prime number between 2 and N.

.data


PrimesPrompt byte 'Please enter a number from 2 to 1000', 0ah, 0dh, 0h ;//2nd menu display
primeArray byte 1000 dup(1); //array to mark off non prime numbers
primeHolder dword 168 dup(0); //array to hole the prime numbers
sqrt1k byte 31; //hard coded sqrt of 1000
userNum dword 0;
counter dword 2;
;counter2 dword 0;
;counter3 dword 0;
counter4 dword 0;
isitPrime byte 0;

.code
mov isitPrime, 0;
starthere2:
mov eax, Three
mov userNum, eax;//set the variable
mov counter, 2 ;//set variable
;mov counter3, 0 ;//clear variable

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
	ja skipL1 ;//skip its greater than N
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
mov edx, offset primeArray ;//move the offset of primeArray into edx
add edx, userNum; //have edx point ot proper element
mov bl, [edx] ;//move element into bl
cmp bl, 1 ;//see if its1
jne finale
mov isitPrime, 1

finale:
;mov edx, offset primeHolder
;mov ecx, counter3
;mov ebx, userNum
INVOKE displayPrimes, One, Two, userNum, isitPrime ;//INVOKE THE PROCEDURE-list the raguments
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
userNum1: dword,
userNum2: dword,
userGCD: dword,
isPrime: byte
;//declare the local variables
;// Description:  displays the prime numbers in specified format
;// Requires:  INVOKE with arguments: pointer to primeHolder, the variable counter3, and the variable userNUm
;// Returns:  Nothing, but the primes are displayed in proper format.


.data

displayprompt1 byte 'Number #1     Number #2     GCD     GCD Prime? ', 0ah, 0dh, 0h


displayprompt2 byte '-----------------------------------------------------', 0ah, 0dh, 0h
displayprompt3 byte 'Yes', 0h
displayprompt4 byte 'No', 0h

.code

push edx ;//save dx
mov edx, offset displayprompt1 ;//move the offset of displayprompt1 into edx
call writestring ;//display the message
pop edx ;//restore edx

push edx ;//save edx
mov edx, offset displayprompt2 ;//move the offset of the message into edx
call writestring ;//display the message
pop edx ;//restor edx

mov eax, userNum1
call writedec ;//display the first number

cmp userNum1, 10 ;//see if it is 2 digits 
jae nextcomp1
mov ecx, 13
L4:
mov al, 20h
call writechar ;//display the proper amount of spaces\
loop L4
jmp nextNum
nextcomp1:
cmp userNum1, 100 ;//see if it is 3 digits
jae nextcomp2
mov ecx, 12
L5:
mov al, 20h
call writechar ;//display the proper amount of spaces
loop L5
jmp nextNum
nextComp2:
mov ecx, 11 
L6:
mov al, 20h
call writechar ;//display the proper amount of spaces
loop L6

nextNum:
mov eax, userNum2
call writedec ;//display the second number

cmp userNum2, 10 ;//same as above-see if its 2 digits
jae nextcomp12
mov ecx, 13
L7:
mov al, 20h
call writechar ;//display the proper amount of spcaes
loop L7
jmp nextNum2
nextcomp12:
cmp userNum2, 100 ;//see if its 3 digits
jae nextcomp22
mov ecx, 12
L8:
mov al, 20h
call writechar ;//display the proper amount of spaces
loop L8
jmp nextNum2
nextComp22:
mov ecx, 11
L9:
mov al, 20h
call writechar ;//dosplay the proper amount of spaces
loop L9

nextNum2:

mov eax, userGCD
call writedec ;//display the GCD

mov ecx, 7
L10:
mov al, 20h
call writechar ;//display the proper amount of spaces
loop L10

cmp isPrime, 0 ;//see if the number is prime
ja nextdisplay ;//if it is then jump
push edx
mov edx, offset displayprompt4
call writestring ;//display the message
pop edx
jmp endDisplay
nextdisplay:
push edx
mov edx, offset displayprompt3
call writestring ;//display the message
pop edx

endDisplay:
call crlf
call waitmsg
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