TITLE: reorder.asm
;//Program Description: Program simply declares an array and then rearranges the elements.
;//Author:Matthew Lynn-Goin
;//Creation Date: 2/18/18

Include IRVINE32.inc

.data
arrayD DWORD 32, 51, 12; //declare an array

.code
main PROC
mov eax, arrayD; //move the first element into eax
mov ebx, [arrayD + 4]; //move the second element into ebx
mov ecx, [arrayD + 8]; //move the last element into ecx
xchg ebx, [arrayD + 8]; //put the second element in the last position
xchg eax, [arrayD + 4]; //put the first element in the second postion
xchg ecx, arrayD; //put the last element in the first position

call DumpRegs; //display the registers

exit;
main ENDP;
END main;
