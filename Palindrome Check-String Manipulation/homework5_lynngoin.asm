TITLE homework5.asm
; Author:  Matthew Lynn-Goin
; Date:  7 March 2018
; Description: This program presents a menu allowing the user to pick a menu option
;              which then performs a given task.
; 1.  The user enters a string of less than 50 characters.
; 2.  The entered string is converted to lower case.
; 3.  The entered string has all non - letter elements removed.
; 4.  Is the entered string a palindrome.
; 5.  Print the string.
; 6.  Exit
;//please note I decided to implement this homework using no temporary strings(i.e
;//I did not create empty strings to copy the user entered string over and then perform functions on the copied and original string.)
;//I decided to use stacks to practice a different style of programming, and enhance my knowledge of them. I still performed the same necessary functions.
;// Note: The same operations could have
;//been done using declared empty strings and duplicating the original string over and performing operations on them.
; ====================================================================================

Include Irvine32.inc 

;//Macros
ClearEAX textequ <mov eax, 0> ;//macros to clear the registers
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>

maxLength = 51d ;//declare a variable for the max lenght of the string

.data
Menuprompt1 byte 'MAIN MENU', 0Ah, 0Dh, ;//menu display
'==========', 0Ah, 0Dh,
'1. Enter a String:', 0Ah, 0Dh,
'2. Convert all elements to lower case: ',0Ah, 0Dh,
'3. Remove all non-letter elements: ',0Ah, 0Dh,
'4. Determine if the string is a palindrome: ',0Ah, 0Dh,
'5. Display the string: ',0Ah, 0Dh,
'6. Exit: ',0Ah, 0Dh, 0h
UserOption byte 0h ;//declare a variable to hold the user option
theString byte maxLength dup(0) ;//declare an array to hold the user entered string
theStringLen byte 0 ;//declare a variable to hold the number of elements entered by user
errormessage byte 'You have entered an invalid option. Please try again.', 0Ah, 0Dh, 0h ;//an array to display an error message


.code
main PROC

call ClearRegisters          ;// clears registers
startHere:
call clrscr ;//clear the screen
mov edx, offset menuprompt1 ;//move the offset of menu prompt into edx
call WriteString ;//display the menu 
call readhex ;//read the user choice
mov useroption, al ;//save the user choice

mov edx, offset theString ;//move the offset of the string into the edx register
mov ecx, lengthof theString ;//move the size of the string into ecx-so yu have a max amount of elements the user can enter
opt1:
cmp useroption, 1 ;//check to see if the user entered 1
jne opt2 ;//jump if not equa to opt2
call clrscr ;//clear the screen
mov ebx, offset thestringlen ;//move the offset the variable into ebx
call option1 
jmp starthere ;//jump back to starthere

opt2:
cmp useroption, 2 ;//check to see if the user entered 2
jne opt3 ;//jump not equal to option 3
call clrscr ;//clear the screen
movzx ecx, thestringlen ;//move zero extend variable into ecx-setting loop counter
mov edx, OFFSET theString; ;//move OFFSET  of theString into edx register
call option2
jmp starthere ;//jump back to starthere

opt3:
cmp useroption, 3 ;//check to see if the user entered 3
jne opt4 ;//jump not equal to opt 4
call clrscr ;//clear the screen
mov ebx, OFFSET theStringLen ;//move offset of variable into ebx
movzx ecx, theStringLen ;//move zero extend variable into ecx
mov edx, OFFSET theString ;//move OFFSET of theString into edx
call option3;
jmp starthere ;//jump back to starthere

opt4:
cmp useroption, 4 ;//check to see if the user entered 4
jne opt5 ;//jump not equal to opt5
call clrscr ;//clear the screen
mov ebx, OFFSET theStringLen ;//move offset of variable into ebx
movzx ecx, theStringLen ;//move zero extend theStringLen into ecx
mov edx, OFFSET theString ;//move the offset of theString into edx
call option4;
jmp starthere ;//jump back to starthere

opt5:
cmp useroption, 5 ;//check to see if the user enetered 5
jne opt6 ;//jump not equal to opt6
call option5
jmp starthere ;//jump back to starthere
opt6:
cmp useroption, 6 ;//check to see if the user entered 6
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
option1 proc uses edx ecx
;// Description: DISPLAYS THE STRING AT ANY GIVEN POINT IN PROGRAM TIME
;// Requires:  EDX-containing the offset of array to hold the user entered string, ecx-containing the max size of the string
;//ebx-containg offset of variable to hold the amount of elements the user entered.
;// Returns:  the user enetered string saved in theString and the number of elements the user enetered saved in theStringLen

.data
option1prompt byte 'Please enter a string of characters (50 or less): ', 0Ah, 0Dh, '--->', 0h ;//prompt to tell the user what to do

.code
push edx       ;//saving the address of the string
mov edx, offset option1prompt ;//move offset of option1 into edx
call writestring ;//display option1
pop edx ;//rstore the contents of edx

call ClearStr ;//call the clear string procedure

call readstring ;//get the user input
mov byte ptr [ebx], al     ;//length of user entered string, now in thestringlen

ret
option1 endp
;/////////////////////////////////////////////////////////////////////////////////////////////////
option2 proc uses edx ebx
;// Description: Converts all alphabetical elements to lower case
;// Requires:  EDX-containing the offset of the user entered string, ECX-conatining the number of elements the user entered
;// Returns:  The user entered string with all aplhabetical characters converted to lowercase.

clearESI ;//clear the esi register
cmp ecx, 0 ;//check to see if the user has entered anything
jbe endFunction2;

L2:
mov al, byte ptr [edx+esi] ;//move byte size element into al
cmp al, 41h ;//compare contents of al to 41h
jb keepgoing ;//jump if below to keepgoing
cmp al, 5ah ;//compare conntents of al to 5ah
ja keepgoing ;//jump if above to keepgoing
or al, 20h     ;//could use add al, 20h
mov byte ptr [edx+esi], al ;//move newly converted alpha element back into spot
keepgoing:
inc esi ;//increment esi to point to next element
loop L2

endFunction2:
ret
option2 endp
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////
option3 PROC uses edx ecx ebx
;// Description:  Removes all non alpha elements.
;// Requires:  EBX-containing offset of variable containing the number of elements the user entered, ECX-containg the number of
;//elements the user enetered, EDX-containing the offset of the user entered string.
;// Returns:  The string with all non-alphabetical characters removed.

.data
storeECX DWORD 0 ;//create varibale to store ecx

.code
cmp ecx, 0;
jbe endofFunction; //if the user has not entered anything....

mov byte ptr [ebx], 0 ;//move zero into the variable that ebx points to
mov storeECX, ecx ;//save the contents of ecx
clearESI ;//clear esi register
mov esi, edx ;//have esi point to beginning of string
add esi, ecx ;//add ecx to esi
dec esi  ;//decrement esi-esi now points to last element in user entered string

L3:
clearEAX ;//clear eax register
movzx eax, byte ptr [esi] ;//move zero extend byte size chunk esi points to into eax
push eax ;//push eax to the stack
dec esi ;//decrement esi
loop L3 ;//loop back

call ClearStr ;//clear the user entered string
clearESI ;//clear the esi register
mov ecx, storeECX ;//restore contents of ecx

L4:
clearEAX ;//clear the eax register
pop eax ;//pop top of stack into eax
cmp al, 41h ;//compare al to 41h
jb dontAdd ;//jump if below to dontadd
cmp al, 5ah ;//compare al to 5ah
jbe addLetter ;//jump if below or equal to addletter
cmp al, 61h ;//compare al to 61h 
jb dontAdd ;//jump below to dontadd
cmp al, 7ah ;//compare al to 7ah
jbe addLetter ;//jump below or equal to add letter
jmp dontAdd ;//jump to dontadd

addLetter:
mov byte ptr [edx + esi], al; //move contents of al to array holding user entered string at posiotn pointed to by edx+esi
add byte ptr [ebx], 1; //add 1 to variable containing the number of elements in the user entered string
inc esi; //increment esi

dontAdd:
loop L4;

endofFunction:
ret
option3 ENDP
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////
option4 PROC uses edx ecx
;// Description: *****EXTRA CREDIT***** CHECKS IF THE STRING IS A PALINDROME-CASE SENSITIVE,PER PROFESSOR INSTRUCTION
;//SPACES AND PUNCTUATION ARE NOT CONSIDERED IN THE PALINDROME CHECK-THEY DO NOT MAKE A DIFFERENCE.
;// Requires:  EBX-containing offset of variable holding the nuber of elements in the string, ECX-contaaing the
;//number of elements in the string, EDX-containing the offset of array holding the user entered string.
;// Returns:  Nothing, just displays if the string is palindrome or not.

.data
option4prompt byte 'The string is NOT a palindrome ', 0Ah, 0Dh, 0h ;//message displaying the string is not a palindrome
option42prompt byte 'The string IS a palindrome ', 0Ah, 0Dh, 0h ;//message displaying the string is a palindrome
storeInt DWORD 0 ;//variable to save contents of ecx

.code

mov storeInt, ecx ;//move contents of ecx into storeInt
mov esi, edx ;//mov edx into esi
add esi, ecx ;//add ecx to esi
dec esi ;//decrement esi-esi now points to last element of user entered string
;//the following loop is to save the original string
L5:
movzx eax, byte ptr [esi] ;//move zero extend byte size that esi points to into eax
push eax ;//push eax to the stack
dec esi ;// decrement esi
loop L5;

mov ecx, storeInt ;//restore contents of ecx

call option3 ;//call option 3 to remove all non alphabetical characters

movzx ecx, byte ptr [ebx] ;//the number of elements in the string has been changed-so set ecx equal to the new value of variable pointed to by ebx

push ebx ;//push ebx to the stack
clearEBX ;//clear ebx
mov esi, edx ;//move contents of edx into esi
add esi, ecx ;//add ecx to esi
dec esi ;//decrement esi-esi now points to last element of newly modified string containing only alphabetical elements
push edx ;//push edx to the stack

L6:
movzx eax, byte ptr [edx] ;//move zero extend byte size of edx points into eax
movzx ebx, byte ptr [esi] ;//move zero extend byte size of esi points into ebx
cmp eax, ebx ;//compare eax and ebx
jne L7 ;//jump not equal to L7
inc edx ;//otherwise increment edx
dec esi ;//decrement esi
loop L6 ;
jmp L8 ;//if everything was equal then jump to L8

;mov ecx, storeInt;
;pop edx;//////////////////////////////////////////

L7:
push edx ;//push edx to the stack
mov edx, OFFSET option4prompt ;//move offset of option4prompt into edx
call WriteString ;//display option4prompt
call WaitMsg ;//have the program wait so user can see message
pop edx ;//rrstore contents of edx
jmp endFunction ;

L8:
push edx;//push edx to the stack
mov edx, OFFSET option42prompt ;//move the offset of option42prompt into edx
call WriteString ;//display option42prompt
call WaitMsg ;//have the program wait so user can see message
pop edx ;//restore contents of edx

endFunction:
pop edx ;//rrstore contents of edx
pop ebx ;//rrstore contents of ebx-ebx again now points to variable containing the number of elements in the string
mov byte ptr [ebx], 0 ;//clear out the variable(was midified by the call to option3, but we now want to restore original string)
mov ecx, storeInt ;//restore original value of ecx
L9:
add byte ptr [ebx], 1 ;//add 1 to variable pointed to ebx
pop eax ;//put top value of stack into eax(will be al)
mov byte ptr [edx], al ;//move al to proper positon in theString
inc edx ;//increment edx to point to next element
loop L9 ;


ret
option4 endp
;//////////////////////////////////////////////////////////////////////////////////////////////////////////
option5 proc uses edx
;// Description:  DISPLAYS TH STRING AT ANY GIVEN PROGRAM TIME
;// Requires:  EDX-containing offset of theString
;// Returns:  Nothing, but the string will be displayed.
.data
option5prompt byte 'The String is: ', 0h
.code
call clrscr ;//clear the screen
push edx ;//push edx to the stack
mov edx, offset option5prompt ;//move the offset of option5prompt into edx
call writestring ;//display option5prompt
pop edx ;//restore contents of edx
call writestring ;//display theString
call waitmsg ;//have progra wait so suer can see string
ret
option5 endp
;///////////////////////////////////////////////////////////////////////////////////////////////////////////
ClearStr PROC USES edx ecx eax
Comment !
Description:  Procedure to clear the string
Receives: edx = offset of string to clear.
Returns:  the cleared out string
Requires:  Nothing.
!


.data
clrStr BYTE 51d; //declare variable the max size of string make sure the entire string is cleared
.code
movzx ecx, clrStr; //move zero extend clrstr into ecx to set the loop counter
L3:
clearEAX; //clear the eax register
mov [edx], al; //move zero into the array postion edx points to
inc edx; //have edx point to the next element
loop L3;

ret;
ClearStr ENDP;
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////

END main

