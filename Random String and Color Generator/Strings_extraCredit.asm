TITLE: practice2.asm
;//Program Description: Program get aninput N from user indicating how many randm strings to generate, and then generates N random strings .
;//Program used a clear string method to clear the string after each random generation.
;//Author:Matthew Lynn-Goin
;//Creation Date: 3/5/18

Include IRVINE32.inc

clearEAX TEXTEQU <mov eax, 0>;// macros to clear the registers
clearEBX TEXTEQU <mov ebx, 0>;//
clearECX TEXTEQU <mov ecx, 0>;//
clearEDX TEXTEQU <mov edx, 0>;//

strsize = 32; //declare a constant for max string size


.data
OGcolor BYTE ?; //declare variable to store the original console colors
enteredLen byte ?; //declare a variable to store the user entered number of strings to generate
RandString BYTE strsize DUP(0), 0; //declare a max size array to store the renaodm generated strings, along with a null terinator 


.code
main PROC
clearEAX; //clear eax register
clearEDX; //clear edx register
clearECX; //clear ecx register

call GetTextColor; //get the original consol colors-stored in al
mov OGcolor, al; //save the original colors
clearEAX; //clear the eax register

;//prep for call to EnterInt
mov ebx, OFFSET enteredLen ;//ebx now points to variable enteredLen
call EnterInt ;//call EnterInt function
;//prep for call to RStr
mov edx, OFFSET RandString ;//ebx now points to RandString to store the randomly genterated strings
movzx ecx, enteredLen ;//move zero extend the user entered number to ecx to set the loop counter
call RStr ;// call RStr function
clearEAX ;// clear the eax register
mov al, OGcolor ;//move the orginal color into al
call SetTextColor; //restore the original console colors
call WaitMsg; //call wait message to make the user enter a key before exiting the program

exit;
main ENDP;

EnterInt Proc 
Comment !
Description:  Get input from user
Receives: EBX = OFFSET of variable to hold user enetered length.
Returns:   enteredLen = input N from user indicating how many strings to generate. 
Requires:   
!

.data
prompt1 byte "Please enter (unsigned integer) how many random strings you would like to generate", 0ah, 0dh, 0h ;// prompt the user for the proper input

.code
push edx ;//prep edx for the proper display-push and pop for edx not needed but done just to be safe
mov edx, OFFSET prompt1 ;//edx now points t beginning of promp1
call WriteString ;//display the prompt
pop edx ;//restore contents of edx
call ReadDec ;//get the input from the user-it will be in eax.
mov [ebx], eax ;//store the user input into enteredLen

ret;
EnterInt ENDP;
;///////////////////////////////////////////////////////////////////////////////////////////////////////
RStr PROC
Comment !
Description:  Procedure to generate random strings.
Receives: ECX = input N from user indicating how many random strings to generate. EDX = offset of array to store random generated string
Returns:  Randomly generated strings
Requires:   Nothing
!

RandRange = 26; //declare the range for the random number generation

.data

.code
call Randomize; //set the see for the randomization functions
;//outer loop L1: ecx loop counter is the user entered inout N
L1: 
push ecx; //push ecx to the stack
mov eax, RandRange; //move the random limmit to eax
call RandomRange; //generate a random number
add eax, 7; //add the offset to make sure it is in the desired range
mov ecx, eax; //create a loop counter for the inner loop
push edx; //push edx to the stack
clearEAX; //cleaar the eax register
;//inner loop
L2:
mov eax, RandRange; //move the random limit to eax
call RandomRange; //generate a random number
add eax, 65; //make sure its a capital letter
mov [edx], al; //move that element to the proper postion in the array
inc edx; //point to the next element
loop L2;
pop edx; //restore edx to point to the beginning of the array
push eax; //push eax to the stack
call extracredit; //call the extra credit function to generate a random color
call SetTextColor; //set the random color
call WriteString; //display the random string
call ClearStr ;//call the ClearStr function to clear the randomly generated striing and prep for the next one
pop eax; //restore eax
call crlf; //return line
pop ecx; //restore ecx for the outer loop counter
loop L1;

ret;
RStr ENDP;
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extracredit PROC
Comment !
Description:  Procedure to generate random background colors
Receives: Nothing.
Returns:  eax = color of the string to be generated.
Requires:  Nothing.
!

RanSize = 14 ;//declare the range of random numbers to be generated

.data

.code
mov eax, RanSize; //move the range to the eax register
call RandomRange; //generate the random number
add eax, 1; //add the offset to make sure it is in the desired range

ret;
extracredit ENDP;
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ClearStr PROC USES edx ecx eax
Comment !
Description:  Procedure to clear the string
Receives: edx = offset of string to clear.
Returns:  the cleared out string
Requires:  Nothing.
!


.data
clrStr BYTE 32d; //declare variable the max size of string make sure the entire string is cleared
.code
movzx ecx, clrStr; //move zero extend clrstr into ecx to set the loop counter
L3:
clearEAX; //clear the eax register
mov [edx], al; //move zero into the array postion edx points to
inc edx; //have edx point to the next element
loop L3;

ret;
ClearStr ENDP;

END main; //end program
