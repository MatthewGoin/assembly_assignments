TITLE: fibonacci.asm
;//Program Description: Program calculates the n=2-10 fib numbers using the function Fn= Fn-1 + Fn-2, and stores them into an array.
;//Then places fib(3)-fib(6) in consecutive bytes into the ebx register
;//Author:Matthew Lynn-Goin
;//Creation Date: 2/18/18

Include IRVINE32.inc

clearEAX TEXTEQU <mov eax, 0> ; //text macro's to clear registers
clearEBX TEXTEQU <mov ebx, 0> ;
clearECX TEXTEQU <mov ecx, 0> ;
clearESI TEXTEQU <mov esi, 0> ;
clearEDI TEXTEQU <mov edi, 0> ;

.data
fibArray BYTE 0, 1, 9 DUP(0); //declare an array fill the first 2 spots with fib(0) and fib(1)
currentA DWORD 2; // Create a counter with value 2

.code
main PROC

clearECX; //clear the ecx register
clearEDI; //clear the edx register
mov ecx, LENGTHOF fibArray - 2; //initialize loop counter (subtract 2 because the first 2 elements of the array already have values)
mov esi, OFFSET fibArray; //have esi point to the beginning of fib array 

top:
clearEAX; //clear the eax register
clearEBX; //clear the ebx register
mov al, [esi]; //move the element into al
inc esi; //have esi point to the next element
mov bl, [esi]; //move the next element into bl
add bl, al; //add al and bl-result will be inn bl
mov edi, currentA; //move currentA into edi-marking the spot to place the newly calculated element
mov [fibArray + edi], bl; //move newly calculated element into proper array position
inc currentA; //increment current A-indicating the next spot the newly calculated value will go into
loop top; //loop back to top

clearEBX; //clear the ebx register
mov esi, OFFSET fibArray; //have esi point to beginning of array
mov ebx, DWORD PTR [esi+3]; //grab the proper elements of fibarray and place them into ebx(little endian)
;//mov ebx, DWORD PTR [fibArray + 3]; //alternate way of doing this-commented out of program

call DumpRegs; //display the regsiters

exit;
main ENDP;
END main;