TITLE pa6.asm
; Author:  Matthew Lynn-Goin
; Date:  2 APRIL 2018
; Description: This program presents a menu allowing the user to pick a menu option
;              which then performs a given task.
; 1.  The user enters a string of less than 50 characters to be encrypted/decrypted.
; 2.  The user enters a key to encrypt/decrypt the string.
; 3.  The entered string is encrypted by the key.
; 4.  The entered string is decrypted by the key.
; 5.  Print the encrypted/decrypted string.
; 6.  Exit
;//!!!!!!!!NOTE!!!!!!!!!: Option3 and Option4are structured so that if the user selects "option3" multipple times, it will double encrypt the
;//string, the user would then have to double decrypt the string to restore it to the original string.
;//NOTE: I should have just created a speparate procedure to check if the user has entered a string  or a key instead of having double code
;//at the begiining of option3 and option4. BUT the program works perfect anyway.
;//NOTE: The assignment and professor said if the original user entered string contains non-alpha characters, then we must get rid of all
;//non-alpha character, but that we did NOT have to save the pre-modified string(i.e the strng with spaces and punctuation still in it).
;//so my program does not save the pre-modified string.
;//NOTE: In my program the user must select option 5 to view the necrypted/decrypted/original string. So option 3 and 4 just encrypt/decrypt
;//and then the user must select option 5 to view the encrypt/decrypt string.
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
'1. Enter a String to be encrypted/decrypted:', 0Ah, 0Dh,
'2. Enter the Encryption/Decription key ',0Ah, 0Dh,
'3. Encrypt the String ',0Ah, 0Dh,
'4. Decrypt the String ',0Ah, 0Dh,
'5. Display the Encrypted/Decrypted string: ',0Ah, 0Dh,
'6. Exit: ',0Ah, 0Dh, 0h


UserOption byte 0h ;//declare a variable to hold the user option
theString byte maxLength dup(0) ;//declare an array to hold the user entered string
theKey byte maxLength dup(0)
theStringLen byte 0 ;//declare a variable to hold the number of elements int the string entered by the user
theKeyLen byte 0; //declare a variable to hold the number of elements in the key entered by the user
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
mov ecx, lengthof theKey; //move the max number of elements allowed in the key into ecx
mov edx, OFFSET theKey; //move the offset of thekey into edx
mov ebx, OFFSET theKeyLen; //move the offset of the variable to hold the number of elements in the key netered by the user into ebx
call option2
jmp starthere ;//jump back to starthere

opt3:
cmp useroption, 3 ;//check to see if the user entered 3
jne opt4 ;//jump not equal to opt 4
call clrscr ;//clear the screen
movzx eax, theKeyLen ;//move offset of variable into ebx
movzx ecx, theStringLen ;//move zero extend variable into ecx
mov edx, OFFSET theString ;//move OFFSET of theString into edx
mov esi, OFFSET theKey; //move offset of thekey into esi
call option3;
jmp starthere ;//jump back to starthere

opt4:
cmp useroption, 4 ;//check to see if the user entered 4
jne opt5 ;//jump not equal to opt5
call clrscr ;//clear the screen
movzx eax, theKeyLen ;//move offset of variable into ebx
movzx ecx, theStringLen ;//move zero extend theStringLen into ecx
mov edx, OFFSET theString ;//move the offset of theString into edx
mov esi, OFFSET theKey; //move offset of thekey into esi
call option4;
jmp starthere ;//jump back to starthere

opt5:
cmp useroption, 5 ;//check to see if the user enetered 5
jne opt6 ;//jump not equal to opt6
mov edx, OFFSET theString; //move the offset of the string into edx
movzx ecx, theStringLen; //move zero extend the number of elements in the string into ecx
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
;// Description: GETS the string form the user to be encrypted/decrypted
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
movzx ecx, byte ptr[ebx]; //mov zero extend variable ebx points to into ecx
call LettersOnly;
movzx ecx, byte ptr[ebx] ;//move the new size of the variable (number of elements int he string)into ecx
call ChangeCase;

ret
option1 endp
;/////////////////////////////////////////////////////////////////////////////////////////////////
option2 proc uses edx ecx
;// Description: Gets the user entered key to encrypt/decrypt the user entered string
;// Requires:  EDX-containing the offset of array to hold the user entered key, ecx-containing the max size of the key
;//ebx-containg offset of variable to hold the amount of elements the user entered.
;// Returns:  the user enetered key saved in theKey and the number of elements the user enetered saved in theKeyLen

.data
Menuprompt2 byte 'A key has already been entered. Would you like to use the existing key,or enter a new one? ', 0ah, 0dh,
'1. Enter a new key ', 0ah, 0dh, 
'2. Use the existing key ', 0ah, 0dh, 0h
UserOption2 byte 0h;
option2prompt byte 'Please enter a string of characters (50 or less) to be the encryption/decryption string: ', 0Ah, 0Dh, '--->', 0h ;//prompt to tell the user what to do

.code
cmp byte ptr [ebx], 0; //compare the size of the varibale ebx points to, to zero
je startingPoint; //jump equal to startingpoint

push edx       ;//saving the address of the string
mov edx, offset Menuprompt2; //move offset of menuprompt2 into edx
call writestring; //display the message
call readhex ;//read the user choice
mov UserOption2, al ;//save the user choice
pop edx; //restore contents of edx
cmp UserOption2, 2 ;//compare useroption2 to two
je skip; //jump equal to skip

startingPoint:
push edx; //save contents of edx
mov edx, offset option2prompt ;//move offset of option2prompt into edx
call writestring ;//display the message
pop edx ;//rstore the contents of edx

call ClearStr ;//call the clear string procedure

call readstring ;//get the user input
mov byte ptr [ebx], al     ;//length of user entered string, now in thestringlen

skip:
ret
option2 endp
;/////////////////////////////////////////////////////////////////////////////////////////////////
option3 PROC uses edx ecx;
;// Description: uses theKey to encrypt theString
;// Requires:  EDX-containing the offset of array containg theString, ECX-containing the size of theString, ESI-containg offset
;//of theKey, EAX-containg the number of elements in theKey 
;// Returns:  Nothing, but encrypts the string.

.data
keyHold dword 0; //declare a variable to hod the key length
keyHold2 dword 0; //delare another variable to hold the key length
varableHold byte 0; 
esiHOLD dword 0; //declare a variable to hold esi
compVariable byte 0; //declare a variable to hold a number indicating if the user needs to go back and enter necessary information
option3prompt byte 'You have not entered a string to be encrypted/decrypted. Please go back and select option 1', 0Ah, 0Dh, 0h
option3prompt2 byte 'You have not entered a key to encrypt/decrypt a string. Please go back and select option 2', 0Ah, 0Dh, 0h

.code
mov compVariable, 0 ;//clear the vaiable
cmp ecx, 0; //compare ecx to zero
jne nextComp3 ;//jump not equal to nextComp3
push edx; //save the contents of edx
mov edx, offset option3prompt; //move offset of option3prompt into edx
call writestring ;//display the message
pop edx ;//restore the contents of edx
inc compVariable ;//incremement compVariable

nextComp3:
cmp eax, 0 ;//compare eax to zero
jne usercheck ;//jump not equal to usercheck
push edx ;//save contents of edx
mov edx, offset option3prompt2 ;//move the offset of option3prompt2 into edx 
call writestring ;//display the message
pop edx ;//restore contents of edx
inc compVariable ;//incrememnt compVariable

usercheck:
call waitmsg ;//make the user notice the messages
cmp compVariable, 0 ;//compare compvariable to zero
jne endOption3; //if the user failed to enter a key or a string they are prompted to return to main menu and do so

beginning3:

mov esiHOLD, esi; //save contents of esi
mov keyHold, eax; //save eax
mov keyHold2, eax; //save ax again-used to restore the decrememnted variable

L1:
cmp keyHold, 0; //compare keyHold to zero
jne continue; //jump not equal to continue
mov esi, esiHOLD; //restore contents of esi
mov eax, keyHold2; //move keyHold2 to eax
mov keyHold, eax; //restore the contents of keyhold
continue:
movzx ax, byte ptr [esi]; //move zero extend a byte size chunk of element esi points to into ax
mov bl, 1ah; //move 1ah into bl
div bl; //divide
mov variableHold, ah; //move ah into variableHold

mov al, byte ptr [edx]; //move a byte size chunk of element edx pints to into al
add al, variableHold; //add variableHold to al
mov byte ptr [edx], al ;//move nnewly computed element back into element edx points to
cmp byte ptr [edx], 5ah; //compare element edx points to to 5ah indicating the end of capital letters
jle continue2; //jump less than or equal to continue2
sub byte ptr [edx], 1ah; //subtract 1ah from the element
continue2:
inc edx; //incrememtn edx
inc esi; //incremet esi
dec keyHold; //decrememnt keyHold
loop L1

endOption3:
ret
option3 endp;
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
option4 PROC uses edx ecx;
;// Description: uses theKey to decrypt theString
;// Requires:  EDX-containing the offset of array holding user entered string, ECX-containing the number of element in theString
;//ESI-containg the offset of theKey, EAX-containg the number of elements in theKey
;// Returns:  nothing, but theString is decrypted and saved

.data
keyHolder byte 0; //declare varibale to hold theKey length
keyHolder2 byte 0; //decxlare another varibale to hold theKey length
esiHolder dword 0; //declare a varibale to hold esi
variableHold byte 0; //declare a varibale
compVariable2 byte 0; //declare avaribale to hold the number of things the user needs to go bac and fix
option4prompt byte 'You have not entered a string to be encrypted/decrypted. Please go back and select option 1', 0Ah, 0Dh, 0h
option4prompt2 byte 'You have not entered a key to encrypt/decrypt a string. Please go back and select option 2', 0Ah, 0Dh, 0h

.code
mov compVariable2, 0 ;//clear the variable
cmp ecx, 0; //compare ecx to zero
jne nextComp4 ;//jump not equal to nextcomp4
push edx; //save contents of edx
mov edx, offset option4prompt; //move the offset of option4prompt into edx
call writestring ;//display the string
pop edx ;//restore edx
inc compVariable2 ;//incrment varibale

nextComp4:
cmp eax, 0 ;//compare eax ot zero
jne usercheck4 ;//jump not equal to userchck4
push edx ;//save contents of edx
mov edx, offset option4prompt2 ;//move the offset of option4prompt2 into edx
call writestring ;//display the message
pop edx ;//restore edx
inc compVariable2 ;//increment varibale

usercheck4:
call waitmsg ;//make the user notice the error messages
cmp compVariable2, 0 ;//compare varibale to zero
jne endOption4; //jump not equal to endOption4

beginning4:

mov esiHolder, esi; //save contents of esi
mov keyHolder, al; //mov al into keyHolder
mov keyHolder2, al; //move al into keyHolder2

L1:
cmp keyHolder, 0; //compare keyHolder to zero
jne continue; //jump not equal to continue
mov esi, esiHolder; //rstore esi
mov al, keyHolder2; //mov keyHolder2 into al
mov keyHolder, al; //restore keyHolder
continue:
movzx ax, byte ptr [esi]; //move zero extend byte size chunk of element esi points to into ax
mov bl, 1ah; //move 1ah into bl
div bl; //divide 
mov variableHold, ah; //move ah into variableHold

mov al, byte ptr [edx]; //move byte size chunk of elelemtn edx points to into al
sub al, variableHold; //subtract variableHold from al
mov byte ptr [edx], al ;//move new contents of al into back into element edx points to
cmp byte ptr [edx], 41h; //compare that new element to 41h-the first capital letter
jge continue2; //jump greater than or equal to continue2
add byte ptr [edx], 1ah; //add 1ah to element edx points to-bringing it back into range
continue2:
inc edx; //increment edx to point ot next eleemnt in the String
inc esi; //incremet esi to point to next element in key
dec keyHolder;//dec keyholder
loop L1;

endOption4:
ret
option4 endp;
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
option5 proc uses edx
;// Description:  DISPLAYS TH STRING AT ANY GIVEN PROGRAM TIME, whether it be the original string, the encrypted or decrypted string
;//displays the string in specific format-5 elemets then space and so forth
;// Requires:  EDX-containing offset of theString, ECX-containg the number of elements in theString
;// Returns:  Nothing, but the string will be displayed in proper format.
.data
option5prompt byte 'The String is: ', 0h
saveECX dword 0; //declare varibale to save ecx
.code
mov saveECX, ecx; //save ecx
call clrscr ;//clear the screen
push edx ;//push edx to the stack
mov edx, offset option5prompt ;//move the offset of option5prompt into edx
call writestring ;//display option5prompt
pop edx ;//restore contents of edx

mov ax, cx; //move cx into ax
mov bl, 5; //move 5 into bl
div bl; //divide

push eax; //save eax
movzx ecx, al; //move zero extend the quotient into ecx
L5:
push ecx; //save ecx
mov ecx, 5; //move 5 into ecx
L6:
movzx eax, byte ptr [edx]; //move zero extend byte size chhunk of element edx points to into eax
call writechar; //display the character
inc edx; //increment edx
loop L6;
mov al, 20h; //move 20h(spoace) into al
call writechar; //display the space
pop ecx; //restore ecx
loop L5;

pop eax; //restore eax
movzx ecx, ah; //move zero extend the remainder into ecx
cmp ecx, 0 ;//compare ecx to zero
je endProcedure ;//jump equal to end of the procedure
L7:
movzx eax, byte ptr [edx]; //move zero extend byte size chunk of element pointed to by edx into eax
inc edx ;//increment edx
call writechar; //display the character
loop L7;

;call writestring ;//display theString
endProcedure:
call waitmsg ;//have progra wait so suer can see string
ret
option5 endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LettersOnly PROC uses edx ecx ebx
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
LettersOnly ENDP;
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
;////////////////////////////////////////////////
ChangeCase proc uses edx ebx
;// Description: Converts all alphabetical elements to lower case
;// Requires:  EDX-containing the offset of the user entered string, ECX-conatining the number of elements the user entered
;// Returns:  The user entered string with all aplhabetical characters converted to lowercase.

clearESI ;//clear the esi register
cmp ecx, 0 ;//check to see if the user has entered anything
jbe endFunction2;

L2:
mov al, byte ptr [edx+esi] ;//move byte size element into al
cmp al, 61h ;//compare contents of al to 61h
jb keepgoing ;//jump if below to keepgoing
cmp al, 7ah ;//compare conntents of al to 7ah
ja keepgoing ;//jump if above to keepgoing
sub al, 20h     ;//subtract 20h from al
mov byte ptr [edx+esi], al ;//move newly converted alpha element back into spot
keepgoing:
inc esi ;//increment esi to point to next element
loop L2

endFunction2:
ret
ChangeCase endp
;///////////////////////////////////////////////
END main;
