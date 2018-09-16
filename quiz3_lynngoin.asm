TITLE: Quiz3.asm
;//Program Description: Program gets an integer string from the user, an input N indicating the postion they want the decimal to be placed.
;//The program then produces the ouput-not altering the OG string, padding left zeros as necessary.
;//Author:Matthew Lynn-Goin
;//Creation Date: 3/15/18

Include IRVINE32.inc

clearEAX TEXTEQU <mov eax, 0>;// macros to clear the registers
clearEBX TEXTEQU <mov ebx, 0>;//
clearECX TEXTEQU <mov ecx, 0>;//
clearEDX TEXTEQU <mov edx, 0>;//
clearESI TEXTEQU <mov esi, 0>;//

strsize = 25; //declare a constant for max amount of integers a user can enter


.data
decPosition byte ?; //declare a variable to hold the postion the user wants the decimal to be inserted.
enteredLen byte ?; //declare a variable to store the amount of unsigned integers the user entered
numString BYTE strsize DUP(0), 0; //declare a max size array to store the user entered integer string, along with a null terinator 


.code
main PROC
clearEAX; //clear eax register
clearEDX; //clear edx register
clearECX; //clear ecx register
clearESI; //clear esi register


;//prep for call to EnterString
mov ecx, LENGTHOF numString; //move the lengthof user entered integer string to ecx
mov ebx, OFFSET enteredLen ; //move the offset of variable to hold the number of digits entered
mov edx, OFFSET numString ; //move the offset of array to hoold user eneterd integer string to edx
call enterString; //call the procdedure

;//prep for call to enterDec
mov ebx, OFFSET decPosition; //move offset of varibale to decimal postion into ebx
call enterDec; //call the procedure

;//prep for call to insertDec
movzx ecx, enteredLen; //move zero extend the number of entered digits into ecx
movzx eax, decPosition; //move zero extend the decimal position into eax
mov edx, OFFSET numString; //move the offset of the rray conating the user entered integer stirng into edx
call insertDec; //call the procedure
call crlf ;//return line
call WaitMsg; //display a wait message

exit;
main ENDP;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
enterString Proc 
Comment !
Description:  Get integer string from user
Receives: EBX = OFFSET of variable to hold user enetered length, EDX = offset of string to hold the user entered string
Returns:   enteredLen = how many digits the user entered. numString = the user entered integer string. 
Requires:   
!

.data
prompt1 byte "Please enter a string of unsigned numbers[max of 25]", 0ah, 0dh, 0h ;// prompt the user for the proper input

.code
push edx ;//push edx to the stack
mov edx, OFFSET prompt1 ;//move offset of prompt 1 to edx
call WriteString ;//display prompt1
pop edx ;//pop edx fro the stack
call ReadString ;//read in the uster entered integer string
mov byte ptr [ebx], al  ;//move the number of integers entered by user into variable pointed to by ebx

ret;
enterString ENDP;
;///////////////////////////////////////////////////////////////////////////////////////////////////////
enterDec PROC
Comment !
Description:  Get integer from user indicating where to place the decimal.
Receives: EBX = OFFSET of variable to hold user entered integer indicating where to place decimal(decPosition).
Returns:   decPosition = where to place the decimal. 
Requires:   
!
 
.data
prompt2 byte "Please enter a single number indicating the postion of the decimal", 0ah, 0dh, 0h;
 
.code

push edx; //push edx to the stack
mov edx, OFFSET prompt2; //move the offset oof promtp2 into edx
call WriteString; //display prompt2
pop edx; //pop edx from the stack-restoring its contents
call ReadDec; //read in an integer input from the user
mov byte ptr [ebx], al; //move that integer into the varibale pointed to by ebx

ret
enterDec ENDP;
;/////////////////////////////////////////////////////////////////////////////////////////////////////////
insertDec PROC
Comment !
Description:  Procedure to place thee decimal in the proper positon.
Receives: ECX = the number of digits the user entered. EDX = offset of array containing the user entered integer string.
eax = the position # indicating where to place the decimal.
Returns:  Nothing - just properly displays the decimal positon(with padded zeros as necessary), and the unchanged OG string.
Requires:   Nothing
!

.data

holdVar DWORD 0

.code
mov holdvar, eax ;//save the contents of eax in holdvar
clearESI ;//clear esi register
cmp eax, 0 ;//compare eax to zero
jbe outcome1 ;//jump if below to outcome 1
cmp eax, ecx ;//compare eax to ecx
jb outcome2 ;//jump if below to outcome 2
je outcome3 ;//jump if equal to outcome 3
ja outcome4 ;//jump if above to outcome 4

outcome1:
call WriteString ;//display the string
jmp endFunction ;//jump to the end of the function

outcome2: 
push ecx ;//push ecx to the stack
sub ecx, eax ;//subtarct eax from ecx

L1: 
mov al, byte ptr [edx + esi] ;//move the first element of the array to al
call WriteChar ;//display the first integer
inc esi ;//point to the next element
loop L1;

clearEAX; //clear eax register
mov al, "." ;//move decimal to al
call WriteChar; //display the decimal
pop ecx; //restore the contents of ecx-mainly just to balance pushes and pops
mov ecx, holdVar; //move holdvar to ecx

L2:
mov al, byte ptr [edx + esi]; //move element to al-picking up where the last loop left off
call WriteChar; //display the element
inc esi; //point to the next element
loop L2;

jmp endFunction; //jump to the end of the function

outcome3:
clearEAX; //move zero to eax
call WriteDec; //display the zero
mov al, "."; //move the decimal to al
call WriteChar; //display the decimal
call WriteString; //display the user entered integer string
jmp endFunction; //jump to the end of the function

outcome4:
push ecx; //push ecx to the stack
clearEAX; //clear eax
call WriteDec; display the zero
mov al, "."; //move the decimal to al
call WriteChar; //display the decimal

mov eax, holdVar; //restore eax
sub eax, ecx; //subtract ecx from eax
mov ecx, eax; move the result back into ecx

L3:
clearEAX; //clear eax
call WriteDec; //display the zero
loop L3;
call WriteString; //display the rest of the string
pop ecx ;//restore ecx mainly just to properly align pushes and pops

endFunction:
ret;
insertDec ENDP;
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

END main; //end program