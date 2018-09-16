TITLE exam2.asm
; Author:  Matthew Lynn-Goin
; Date:  15 APRIL 2018
; Description: This program presents a menu allowing the user to pick a menu option
;              which then performs a given task.
; 1.  Play the hangman game.
; 2.  View game statistics.
; 3.  Exit the program.
;//!!!!!!!!NOTE!!!!!!!!!: WHEN ASKING TO SELECT A LETTER OR WORD HIT 1 OR 2 AND THEN PRESS ENTER, BUT WHEN ENTERING A LETTER,
;//JUST PRESS THE DESIRED LETTER [FOR INSTANCE DO NOT HIT A THEN ENTER], IT DOESNT COMPRAMISE THE PROGRAM, PRESSING ENTER AFTER
;// A LETTER MAKES THE PROGRAM ASSUME YOU WANT TO DO ANOTHER LETTER GUESS.
;// !!!!!!!NOTE!!!!!!!!: THE WAY THE PROGRAM IS STRUCTURED, IT WILL INDICATE A WIN IF THE USER ENTERS THE ALL OF THE CORRECT ELEMENTS
;// AND THEN SOME: [FOR INSTANCE: IF THE WORD IS "MACHINE" AND THE USER ENTERS "MACHINEEEEEEEEEEEEE" THAT WILL BE COUNTED AS A WIN].
; ====================================================================================

Include Irvine32.inc 

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
'WELCOME TO THE HANGMAN GAME', 0Ah, 0Dh,
'You have 10 letter guesses and 3 [complete word] guesses', 0Ah, 0Dh,
'If you run out of both-you lose the game.', 0Ah, 0Dh,
'Please select from the following menu items:', 0Ah, 0Dh,
'1. Play the game. ',0Ah, 0Dh,
'2. View Hangman game statistics ',0Ah, 0Dh,
'3. Exit: ',0Ah, 0Dh, 0h

Menuprompt2 byte 'Would you like to play another game (1 for yes[back to main], 2 for no[exit program])?', 0ah, 0dh, 0h ;//2nd menu display

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
call randomGenerator;
call hangMan
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
cmp useroption, 2 ;//check to see if the user entered 2(for first input)
jne opt3 ;//jump not equal to option 3
call clrscr ;//clear the screen
clearEAX ;//clear these registers to not affect the game stats
clearEBX
clearECX
call option2 ;//display the game stats
jmp starthere ;//jump back to starthere

opt3:
cmp useroption, 3 ;//check to see if the user entered 6
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
clearEAX ;//clear te registers to not affect the game stats
clearEBX
clearECX
call option2;
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
option2 proc
;// Description:  DISPLAYS THE GAME STATS
;// Requires:  EAX-containing a number indicating if a game has just been played. EBX-containg i the user won the game.
;//ECX-containg a number indicating if the user lost.
;// Returns:  Nothing, but displays the game stats.

.data
gamesWon byte 0;
gamesLost byte 0;
gamesPlayed byte 0;
option2prompt byte 'Number of Games Won: ', 0h
option2prompt2  byte 'Number of Games Lost: ', 0h
option3prompt2 byte 'Number of games played: ', 0h

.code
call crlf;
add gamesPlayed, al ;//add al to gamesPlayed
add gamesWon, bl ;//add bl to gamesWon
add gamesLost, cl ;//add cl to games lost
push edx ;//save edx
mov edx, offset option3prompt2 ;//move offset of option3prompt2 into edx
call writestring ;//display the message
pop edx ;//restore edx
movzx eax, gamesPlayed ;//mov zero extend variable into eax
call writedec ;//display the number

call crlf;

push edx ;//save edx
mov edx, offset option2prompt ;//mov the offset of option2prompt into edx
call writestring ;//display the string
pop edx ;//restore edx

movzx eax, gamesWon ;//move zero extend variable into eax
call writedec ;//display the number

call crlf;

push edx ;//save edx
mov edx, offset option2prompt2 ;//move the offset of option2prompt2 into edx
call writestring ;//display the string
pop edx ;//restore edx

movzx eax, gamesLost ;//move variable into eax
call writedec ;//display the number

call crlf;
call waitmsg

ret
option2 endp
;//////////////////////////////////////////////////////////////////////////////////////////////
randomGenerator Proc
;// Description:  Generates a random number to pick a random string
;// Requires:  NOTHING
;// Returns: Returns the random generated number in ebx

RandRange = 1000; //set the base range

.code
clearEAX;
call Randomize; //set the seed for the randomization functions
mov eax, RandRange; //move the random limmit to eax
call RandomRange; //generate a random number
add eax, 1000d; //add the offset to make sure it is in the desired range
mov bl, 20d; //move 20d into bl
div bl; //divide
;//ah contains the remaidner from which we will choose our string;
movzx ebx, ah;
ret
randomGenerator ENDP
;///////////////////////////////////////////////////////////////////////////////////////////////
hangMan proc uses edx ecx
;// Description: Outter shell of the overall hangman function. Picks the random string and then preps for the inner hangman call
;// Requires: EBX-containg which string to pick.
;// Returns: If agame was played, if it was wond and if it was lost, also displays appropriate messages.

.data

String0 byte 'kiwi', 0h
String1 byte 'canoe', 0h
String2 byte 'doberman', 0h
String3 byte 'puppy', 0h
String4 byte 'banana', 0h
String5 byte 'orange', 0h
String6 byte 'frigate', 0h
String7 byte 'ketchup', 0h
String8 byte 'postal', 0h
String9 byte 'basket', 0h
String10 byte 'cabinet', 0h
String11 byte 'mutt', 0h
String12 byte 'machine', 0h
String13 byte 'mississippian', 0h
String14 byte 'destroyer', 0h
String15 byte 'zoomies', 0h
String16 byte 'body', 0h
String17 byte 'algorithm', 0h
String18 byte 'interstellar', 0h
String19 byte 'cataclysmic', 0h

prompt9 byte 'You have used all of your guesses. You lose.', 0h
prompt20 byte 'Here is the word: ', 0h
;// create an array of offsets to choose the appropraite string

list1 dword offset String0, offset String1, offset String2, offset String3, offset String4, offset String5, offset String6, offset String7, offset String8, offset String9,
			offset String10, offset String11, offset String12, offset String13, offset String14, offset String15, offset String16, offset String17, offset String18, offset String19

lenArray byte 4, 5, 8, 5, 6, 6, 7, 7, 6, 6, 7, 4, 7, 13, 9, 7, 4, 9, 12, 11; //create an array of the lengths of the strings.


saveEcx11 byte 0; //declare the appropriate varibales
clearVars byte 0;
checkGame byte 0;
saveBL byte 0;
saveEDX dword 0;

playedGames byte 0;
wonGames byte 0;
lostGames byte 0;

.code
inc playedGames; //increment variable to indicate a game is being played
mov saveBL, bl; //save the string being used
mov saveEcx11, 0; //clear the variable
push edx ;//save edx
mov edx, offset lenArray ;//mov the offset of lenArray into edx
mov cl, [edx + ebx]; //move the corresponding string length into cl
pop edx; //restore edx
mov esi, offset list1 ;//move the offset of list1 into esi
mov eax, ebx ;//move the number into eax
mov ebx, 4 ;//move 4 into ebx to prep for multiplication
mul ebx ;//multiply-result will be in eax
mov ebx, eax; //restore ebx with the new number-this is done b/c it is dword array and we need to increment by 4
mov edx, [esi + ebx]; //move the appropriate string offset into edx
mov saveEDX, edx; //save the offset

mov saveEcx11, cl; //save the length of the string
movzx ebx, saveEcx11 ;//move the length of the string into ebx
mov ecx, 13 ;//move 13 into ecx-the user has 13 tries total if the loop iterates through all of them, they have lost



L1:
mov eax, offset checkGame; //prep for inner hang man function
mov esi, offset clearVars; //move offset of varibel into esi
mov bl, saveECX11 ;//restore bl containing the length of the string
cmp checkGame, 1 ;//if the user won the game
je Whoo; //jump equal to Whoo
call hangManInternal
loop L1;

inc lostGames; //if the y reach here they have lost
push edx ;//save edx
mov edx, offset prompt9 ;//move offset of prompt 9 into edx
call writestring; //display the message
pop edx; //restore edx
call crlf;

push edx ;//save edx
mov edx, offset prompt20 ;//move the offset of prompt20 into edx
call writestring ;//display the string
pop edx ;//restore edx

push edx ;//save edx
mov edx, saveEDX; //restore the offset of the proper string into edx
call writestring ;//display the string
pop edx ;//restore edx
jmp endFunction2

Whoo:
inc wonGames; //increment variable to indicate that they won
	
endFunction2:
push eax; //save registers
push ebx;
push ecx;
movzx eax, playedGames ;//move proper info into registers
movzx ebx, wonGames
movzx ecx, lostGames
call option2
pop ecx ;//restore register
pop ebx
pop eax
mov playedGames, 0 ;//restore variables
mov wonGames, 0
mov lostGames, 0
mov clearVars, 1; //move 1 into varibale indicating a game has been completed
mov checkGame, 0;

ret
hangMan endp
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////
hangManInternal proc uses eax ecx edx esi
;// Description:  inner procedure of overall hangman, this is the procedure that plays the game.
;// Requires:  EAX-offset of checkGame, EBX-containing the length of the string, EDX-containing the offset of the proper string
;// Returns: Displays proper messages, increments proper variables to indicate status of the game and program. increments check game
;// to indicate if the user won.

.data
prompt1 byte 'Would you like to guess a letter or a word(1 for letter, 2 for whole word)?', 0ah, 0dh, 0h
prompt2 byte 'Guess a letter: ', 0h
prompt3 byte 'Guess the word: ', 0h
prompt4 byte 'That is correct- ', 0h
prompt5 byte 'That is incorrect- ', 0h
prompt6 byte ' letter guesses remaining.', 0h
prompt7 byte ' word guesses remaining.', 0h
prompt8 byte ' You Win!', 0h

prompt10 byte 'word = ', 0h
prompt11 byte '[', 0h
prompt12 byte '  letter guesses left]', 0h
prompt13 byte '  word guesses left', 0h 
prompt14 byte 'sorry you out of word guesses, please go back and select option1. ', 0ah, 0dh, 0h
prompt15 byte 'sorry you are out of letter guesses, please go back and select option2. ', 0ah, 0dh, 0h
prompt16 byte 'you have guessed all  letters correctly. You win!', 0h

userGuess byte 13 dup(0);
userGuessLen byte 0;
userCount byte 0;
correctGuess byte 0;

letterGuesses byte 10;
wordGuesses byte 3;

underScoreArray byte 13 dup('_'); //declare an underscore array to display

saveEcx1 byte 0;
tempVar1 byte 0;
WonorLost byte 0;
saveEAX dword 0;

.code
push eax ;//save eax
movzx eax, byte ptr [esi] ;//move variable esi points to into eax
mov tempVar1, al ;//mov al into variable
pop eax ;//restore eax
cmp tempVar1, 1; //if a game has been played we need to clear out the necessary variables
jb begin ;//jump below to begin

push edx ;//save edx
mov edx, offset underScoreArray; //move the offset of underscore array into edx
call restoreStr
pop edx; //restore edx

push edx ;//save edx
mov edx, offset userGuess ;//move the offset of the user entered word Guess into edx
call ClearStr;
pop edx ;//restore edx

mov WonorLost, 0; //clear and restore all of the proper elements
mov userGuessLen, 0
mov userCount, 0
mov correctGuess, 0
mov userGuess, 0
mov saveEcx1, 0
mov letterGuesses, 10;
mov wordGuesses, 3;
mov byte ptr [esi], 0;


begin:
mov saveEAX, eax; //save eax variable
mov saveEcx1, bl; //save the legnth of the string
mov userGuessLen, 0 ;//clear the proper variables
mov userCount, 0
push edx ;//save edx
mov edx, offset prompt10; //move the offset of prompt10 into edx
call writestring ;//display the string
pop edx; //restore edx
push ecx; //save ecx
movzx ecx, saveEcx1; //move zero extend the length of the string intoo ecx
mov esi, offset underScoreArray; //move the offset of underscore array into esi
	L2:	
	mov al, [esi]; //move element into al
	call writechar; //display the element
	mov al, 20h; //move space into al
	call writechar; //display the space
	inc esi; //point to next element
	loop L2;
pop ecx; //restore ecx

push edx ;//save edx
mov edx, offset prompt11; //move the offset of prompt11 into edx
call writestring ;//display the message
pop edx ;//restore edx
movzx eax, letterGuesses; //mov zero extend variable into eax
call writedec ;//display the number
push edx ;//save edx
mov edx, offset prompt12 ;//move the offset of prompt12 into edx
call writestring ;//display the message
pop edx ;//restore edx
	
call crlf;
decision:
push edx ;//save edx
mov edx, offset prompt1; //move the offset of prompt1 into edx
call writestring ;//display the string
pop edx ;//restore edx
call readhex; //get the user decision
cmp al, 1; //check if they enetered 1
ja message2 ;//jump above to message2
cmp letterGuesses, 0; //see if they have any letter Guesses left
jne letsGo ;//jump not equal to letsGo
push edx ;//save edx 
mov edx, offset prompt15; //move  the offset of prompt15 into edx
call writestring; //display the message
pop edx ;//restore edx
jmp decision; //jump back to decision
letsGo:
push edx ;//save edx
mov edx, offset prompt2 ;//move the offset of prompt2 into edx
call writestring ;//display the message
pop edx ;//restore edx
call readchar ;//get the user letter guess
call writechar; //display that letter guess
call crlf;
;//////convert to lower case here
	cmp al, 41h ;//compare contents of al to 41h
	jb keepgoing ;//jump if below to keepgoing
	cmp al, 5ah ;//compare conntents of al to 5ah
	ja keepgoing ;//jump if above to keepgoing
	or al, 20h     ;//could use add al, 20h
	keepgoing:
push ecx ;//save ecx
push edx ;//save edx
mov esi, offset underScoreArray ;//move the offset of underscore array into esi
movzx ecx, saveEcx1 ;//move the length of the striing into ecx
	L3:
	mov bl, [edx] ;//move element into ebx
	cmp bl, al ;//compare letter guess to current element
	jne next ;//jump not equal to next
	mov [esi], al; //if they are equal move that letter into the array
	inc correctGuess; //increment that they have giessed a letter correct
	next:
	inc esi; //point to next element
	inc edx; //point to next element
	loop L3
pop edx; //restore edx
pop ecx; //restore ecx 
dec letterGuesses; //they now have one less letter guess
mov bl, saveEcx1 ;//restore bl
cmp correctGuess, bl; //see if they have guessed all letters corretcly
jb keepgoing2 ;//jump below to keepgoing(if they havent guessed all correctly)
push edx ;//save edx
mov edx, offset prompt16 ;//move the offset of prompt16 into edx
call writestring ;//display the string 
pop edx ;//restore edx
mov WonorLost, 1; //notify that they have won
jmp after ;//jump after
keepgoing2:
jmp after;// not needed

message2:
cmp wordGuesses, 0; //see if they have any word guesses left
jne letsGo2 ;//if they do jump to letsGo2
push edx ;//save edx
mov edx, offset prompt14; //move the offset of prompt14 into edx
call writestring; //display the message
pop edx ;//restore edx
jmp decision ;//jump back to decision
letsGo2:
push edx ;//save edx
mov edx, offset prompt3 ;//move the offset of prompt3 into edx
call writestring ;//display the string
pop edx ;//restore edx
push ecx;//save ecx
movzx ecx, saveEcx1 ;//move the length of the striing into ecx
add ecx, 1; //add one for the null terminator
push edx;//save edx
mov edx, offset userGuess ;//move the offset of the array to hold the user guess into edx
call readstring ;//get the user word guess
mov userGuessLen, al ;//move the number of characters entered by user into variable
pop edx ;//restore edx
pop ecx ;//restore ecx

push edx ;//save edx
push ecx ;//save ecx
mov edx, offset userGuess ;//move the offset of userGuess into edx-this and the previous lines are not needed but done to be on the safe side
movzx ecx, userGuessLen ;//set the loop-prep for next call
call ChangeCase
pop ecx ;//restore ecx
pop edx ;//restore edx
push ecx ;//save ecx
movzx ecx, userGuessLen ;//move the length of the user enetered string into ecx
mov esi, offset userGuess ;//move the offset of userGuess into esi
	L4:
	movzx eax, byte ptr [edx] ;//move zero extend element into eax
	movzx ebx, byte ptr [esi] ;//move zero extend element into ebx
	cmp eax, ebx ;//compare them
	jne next2 ;//jump not equal
	inc userCount ;//increment that they are equal
	next2:
	inc edx ;//point to next element
	inc esi ;//pointot next element
	loop L4
pop ecx; //restore ecx
mov bl, userGuessLen ;//move the lenght of the userGuess into bl
cmp userCount, bl; //see if they guessed everything correctly
jb nope ;//jump below
push edx ;//save edx
mov edx, offset prompt4 ;//move the ofset of prompt4 into edx
call writestring ;//display the message
pop edx ;//restor edx
push edx ;//save edx
mov edx, offset prompt8; //move the offset of prompt8 into edx
call writestring ;//dispaly the message
pop edx ;//restor edx
mov WonorLost, 1; //indicate that they have won
jmp after ;///jump after
nope:
push edx ;//save edx
mov edx, offset userGuess ;//move the ofset of userGuess into edx
call ClearStr;
pop edx ;//restore edx
dec wordGuesses; //they now have one less wordguess
push edx ;//save edx
mov edx, offset prompt5; //move the offset of prompt5 into edx
call writestring ;//display the message
pop edx ;//restore edx
movzx eax, wordGuesses ;//move zero extend variable into eax
call writedec ;//display the number
push edx ;//save edx
mov edx, offset prompt7; //move the offset of prompt7 into edx
call writestring; //display the string
pop edx	;//restore edx
call crlf;
after:
push ebx ;//save ebx
mov eax, saveEAX ;//restore original eax
mov bl, WonorLost ;//move variable into bl
mov [eax], bl; //move that number into variable pointed to by eax
pop ebx ;//restore ebx



ret
hangManInternal endp
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////
ClearStr PROC USES edx ecx eax
Comment !
Description:  Procedure to clear the string
Receives: edx = offset of string to clear.
Returns:  the cleared out string
Requires:  Nothing.
!


.data
clrStr BYTE 13d; //declare variable the max size of string make sure the entire string is cleared
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
restoreStr PROC USES edx ecx eax
Comment !
Description:  Procedure to clear the string
Receives: edx = offset of string to clear.
Returns:  the cleared out string
Requires:  Nothing.
!


.data
clrStr2 BYTE 13d; //declare variable the max size of string make sure the entire string is cleared
.code
movzx ecx, clrStr2; //move zero extend clrstr into ecx to set the loop counter
L3:
clearEAX; //clear the eax register
mov al, 5fh
mov [edx], al; //move underscore into the array postion edx points to
inc edx; //have edx point to the next element
loop L3;

ret;
restoreStr ENDP;
;//////////////////////////////////////////////////////////////////////////////////////////////////////
;ClearRegisters Proc
;// Description:  Clears the registers EAX, EBX, ECX, EDX, ESI, EDI
;// Requires:  Nothing
;// Returns:  Nothing, but all registers will be cleared.

;cleareax
;clearebx
;clearecx
;clearedx
;clearesi
;clearedi

;ret
;ClearRegisters ENDP
;////////////////////////////////////////////////////////////////////////////////////////////////////
ChangeCase proc uses edx ebx
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
ChangeCase endp
;///////////////////////////////////////////////
END main;