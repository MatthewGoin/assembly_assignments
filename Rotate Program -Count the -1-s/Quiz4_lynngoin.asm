TITLE quiz4.asm

Include Irvine32.inc 

;//Macros
ClearEAX textequ <mov eax, 0> ;//macros to clear the registers
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>

.data
Menuprompt1 byte 'Please enter a number between 1 and 1,000,000 (or enter 0 to quit the program)', 0Ah, 0Dh, 0h ;//menu display
message2 byte 'The number is: ', 0h
UserOption byte 0h ;//declare a variable to hold the user option
userNumber DWORD 0h;



.code
main PROC
startHere:
clearEAX;
mov userNumber, 0;
call clrscr ;//clear the screen
mov edx, offset menuprompt1 ;//move the offset of menu prompt into edx
call WriteString ;//display the menu 
call readdec ;//read the user choice
mov userNumber, eax ;//save the user choice

cmp userNumber, 0 ;//check to see if the user entered 1
je quitit ;//
call clrscr ;//clear the screen
mov edx, offset message2;
call writestring;
mov eax, userNumber;
call writedec;
call crlf
mov edx, offset userNumber;
call HexCount

jmp startHere;

;//end the program....
quitit:
exit
main ENDP
;;/////////////////////////////////////////////////////////////////////////////////////////////////
HexCount proc uses edx
;// Description:counts the 
;// Requires:  EDX-containing the offset of variable holding user entered number
;// Returns: nothing.

.data
option1prompt byte 'There is/are : ', 0h;
option1prompt2 byte ' one(s) ', 0ah, 0dh, 0h;
numOnes dword 0;

.code
clearEAX;
mov numOnes, 0;
mov ebx, offset numOnes;
mov ecx, 32;
mov eax, dword ptr [edx];
L1:
rol eax, 1; 
jnc ignore;
inc numOnes; //could have just added the carry, because if you add zero it doesnt change anything, so you would just be adding ones, but how do add a carry flag? EFLAGS and the carry is a zero bit(mask it out.)
ignore:
loop L1;

push edx       ;//saving the address of the string
mov edx, offset option1prompt ;//move offset of option1 into edx
call writestring ;//display option1
mov eax, numones;
call writedec;
mov edx, offset option1prompt2;
call writestring;
call waitmsg

pop edx ;//rstore the contents of edx
ret
HexCount endp

END main
