TITLE: pa2.asm
;//Program Description: Program that moves specific values into registers-sets specific flags, and makes use of symbolics and macros
;//Author:Matthew Lynn-Goin
;//Creation Date: 2/7/18

Include Irvine32.inc

clearEAX TEXTEQU <mov eax, 0> ; //text macro's to clear registers
clearEBX TEXTEQU <mov ebx, 0> ;
clearECX TEXTEQU <mov ecx, 0> ;
clearEDX TEXTEQU <mov edx, 0> ;



.data

var1 SDWORD 00110000000000000000000000000000b; //declare a variable-signed dword- with a binary number as its value
var2 SDWORD 01010000000000000000000000000000b; //declare a variable-signed dword- with a binary number as its value
var3 DWORD 10111000000000000000000000000000b; // declare a variable- dword space- with a binary number
var4 DWORD 11000000000000000000000000000000b; //declare a variable-dword space-with abinary number

SECONDS EQU 60 * 60 * 24; //seconds = 86,400
SECONDS_IN_A_DAY TEXTEQU <mov edx, SECONDS>; //expandable macro, move seconds into the edx register

.code
main PROC

clearEAX; //clear eax register
mov eax, 2*3*4*5*6*7; // move 5,040 into eax register

clearEDX; //clear edx register
mov EDX, var1; //move var1 into edx register
add EDX, var2; //add var2 to the edx register=>therefore casusing overflow from signed arithmetic being out of range

clearECX; //clear ecx register
mov ECX, var3; //move var3 into the ecx register
add ECX, var4; //add var4 to the ecx register, causing the carry flag to be set

clearEDX; //clear the edx register

SECONDS_IN_A_DAY; //Make use of the macro's-this line will move 86,400 (SECONDS) into the edx register

call DumpRegs; //display the contents of the registers

exit
main ENDP
END main
