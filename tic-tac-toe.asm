TITLE Final.asm
; Description: This program will play a tic-tac-toe game with 3 modes.
; 1) The first mode is player vs. player.
; 2) The second mode is player vs. computer. Computer will automatically fill a random location.
; 3) The third mode is computer vs. computer. Each computer will automatically fill a location at a time.
; 4) It will show the statistics when the user enter 4 on the menu.
; Due Date: 12 / 11 / 2019

include irvine32.inc


.data
TheBoard byte 3 dup('-')
	     byte 3 dup('-')
	     byte 3 dup('-')						; Board for every game

UserOption byte 0								; User option
PvsPplayed byte 0								; How many times plaer vs. player played
PvsCplayed byte 0								; How many times plaer vs. computer played
CvsCplayed byte 0								; How many times computer vs. computer played
HMplay1 byte 0									; How many times player1 won in player vs. player mode.
HMplay2 byte 0									; How many times player2 won in player vs. player mode.
HMplay byte 0									; How many times player won in player vs. computer mode.
HMcomp byte 0									; How many times computer won in player vs. computer mode.
HMcomp1 byte 0									; How many times computer1 won in computer vs. computer mode.
HMcomp2 byte 0									; How many times computer2 won in computer vs. computer mode.
HMdraw byte 0									; How many times draw happened in all modes.


.code

;Proto types
PrintBoard PROTO, Board : dword					; Print board
ClearBoard PROTO, Board : dword					; Clear board after every game
PvsP PROTO, Board : dword						; Player vs. player mode
PvsC PROTO, Board : dword						; Player vs. computer mode
CvsC PROTO, Board : dword						; Computer vs. computer mode
Check PROTO, Board : dword						; Check if there's is any 3 'O's or 'X's in a any row or column or diagnal.
Statistics PROTO, val1:byte, val2:byte, val3:byte, val4:byte, val5:byte, val6:byte, val7:byte, val8:byte, val9:byte, val10:byte	; Show statistics
FinalPrint PROTO, Board : dword					; When someone wins the game, print winner's marks with blue background color

main proc
call randomize									; Random number genarator seed

call ClearRegister								; Clear registers

starthere:

mov ebx, offset UserOption
call MainMenu

opt1:
cmp UserOption, 1
jne opt2
INVOKE PvsP, offset TheBoard					; If user enters 1, then play player vs. player mode
jmp starthere


opt2:
cmp UserOption, 2
jne opt3
INVOKE PvsC, offset TheBoard					; If user enters 2, then play player vs. computer mode
jmp starthere


opt3:
cmp UserOption, 3
jne opt4
INVOKE CvsC, offset TheBoard					; If user enters 3, then play computer vs. computer mode
jmp starthere


opt4:
cmp UserOption, 4
jne opt5
call clrscr										; If user enters 4, then show the statistics
INVOKE Statistics, PvsPplayed, PvsCplayed, CvsCplayed, HMplay1, HMplay2, HMcomp, HMdraw, HMplay, HMcomp1, HMcomp2      ; If user enters 4, then show the statistics
call crlf
call waitmsg
jmp starthere

opt5:
cmp UserOption, 5								; If user enters 5, then quit the game
jne oops
jmp quitit


oops:
call errorMsg									; If user writes wrong number, show the error message
jmp starthere

quitit:
call crlf
INVOKE Statistics, PvsPplayed, PvsCplayed, CvsCplayed, HMplay1, HMplay2, HMcomp, HMdraw, HMplay, HMcomp1, HMcomp2		; When the program ends, show the statistics
exit
main endp


ClearRegister proc
; Description: This procedure will clear registers EAX, EBX, ECx, EDX, EDI, and ESI
; Returns: Basic registers becomes 0
mov eax, 0
mov ebx, 0
mov ecx, 0
mov edx, 0
mov edi, 0
mov esi, 0
ret
ClearRegister endp


MainMenu proc
; Description: This procedures shows the menu, and gets an input number (option number) from user
; Returns: 'UserOption' will have the input number
.data
prompt byte '  Welcome to tic tac toe game!', 0ah, 0dh,
    		'================================', 0ah, 0dh,
	        '1. Player vs. Player', 0ah, 0dh,
	        '2. Player vs. Computer', 0ah, 0dh,
	        '3. Computer vs. Computer', 0ah, 0dh,
			'4. Statistics', 0ah, 0dh,
			'5. Exit', 0ah, 0dh,
	        '================================', 0ah, 0dh,
	        'Please enter an option number: ', 0

.code
push edx
call clrscr
mov edx, offset prompt
call writestring
call readhex
mov byte ptr[ebx], al
pop edx
ret
MainMenu endp


ClearBoard proc, Board : dword
; Description: This procedure clears the board with '-'.
; It takes the offset of the board as a parameter.
; Returns: The board has '-' on every location.
push edx
push esi

mov edx, Board
mov esi, 0
mov ecx, 9
Clear:
	mov byte ptr[edx + esi], '-'
	inc esi
loop Clear

pop edi
pop edx

ret
ClearBoard endp


PrintBoard proc, Board : dword
; Description: This procedure prints out the board 'X' with red background and 'O' with yellow background. The color is changed by calling 'ColorChange' procedure.
; It takes the offset of the board as a parameter.
.data
firstline	byte '1.   |2.   |3.   |', 0ah, 0dh, 0
secondline  byte '4.   |5.   |6.   |', 0ah, 0dh, 0
thirdline   byte '7.   |8.   |9.   |', 0ah, 0dh, 0
line 		byte '-----------------', 0ah, 0dh, 0

.code
push edx
mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline
call writestring							; Write the first line that indicates location's number 1~3.
pop edx

mov ecx, 3
first:
mov al, ' '
call writechar
call writechar
call ColorChange							; If the location has 'X', change the background color to red. If the location has 'O', change the background color to yellow.
mov al, byte ptr[edx + esi]			
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first

call crlf

push edx
mov edx, offset line
call writestring

mov edx, offset secondline
call writestring							; Write the second line that indicates location's number 4~6.
pop edx

mov ecx, 3
second:
mov al, ' '
call writechar
call writechar
call ColorChange							; If the location has 'X', change the background color to red. If the location has 'O', change the background color to yellow.
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop second

call crlf

push edx
mov edx, offset line
call writestring

mov edx, offset thirdline
call writestring							; Write the third line that indicates location's number 7~9.
pop edx

mov ecx, 3
third:
mov al, ' '
call writechar
call writechar
call ColorChange							; If the location has 'X', change the background color to red. If the location has 'O', change the background color to yellow.
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third
call crlf

pop edx

ret
PrintBoard endp


PvsP proc, Board : dword
; Description: This procedure playes player vs. player mode tic tac toe
; 1) It will choose which player plays first by making a random number 0 or 1.
; 2) First player will mark the board with 'X', and the second player will mark the board with 'O'.
; 3) 'X' will have red background color, and 'O' will have yellow background color.
; 4) When one of players wins, winner's 3 of 'O's or 'X's have blue background color.
; It takes the offset of the board.

.data
PvsPprompt2 byte 'Player1 gets to make the first move.', 0ah, 0dh, 0
PvsPprompt3 byte 'Player2 gets to make the first move.', 0ah, 0dh, 0
PvsPprompt4 byte 'Wrong move. Enter a right place: ', 0
PvsPprompt5 byte 'Do you want to play it again? (Y/N): ', 0

player1prompt byte 'Player1', 27h, 's turn to move: ', 0
player2prompt byte 'Player2', 27h, 's turn to move: ', 0
p1wins byte 'Player1 wins! ', 0
p2wins byte 'Player2 wins! ', 0

counter1 byte 0									; When the counter becomes 9, and there's still no winner --> draw
playagain1 byte 2 dup(0h)						
nowins1 byte 'Nobody wins this game. ', 0		

.code
NewPvsP:
INVOKE ClearBoard, Board						; Clear the board every game
mov counter1, 0									; Clear the counter
call clrscr
mov eax, 2h
call randomrange
cmp al, 0										; if AL is 0, player1 first
jne p2first										; if AL is 1, player2 first

p1first:										; Player1 starts first
mov edx, offset PvsPprompt2
call writestring

L1:												; Endless loop until counter get to 9 or until someone wins 
INVOKE PrintBoard, Board
mov edx, offset player1prompt
call writestring
mov edx, Board
reenter1:
call readdec									; Ask user to choose a location
cmp al, 9
ja wrongmove1
cmp al, 1
jb wrongmove1									; If the input number is less than 1 or greater than 9, then make user re-enter the number.
jmp continue1
wrongmove1:
push edx
mov edx, offset PvsPprompt4
call writestring
pop edx
jmp reenter1

continue1:
dec eax
cmp byte ptr[edx + eax], 'O'
je wrongmove1
cmp byte ptr[edx + eax], 'X'
je wrongmove1									; If the location is already 'O' or 'X', then re-enter the number.

mov byte ptr[edx + eax], 'X'					; If it is not, then fill the lcoation with 'X'
inc counter1								
INVOKE Check, Board								; Check if there's any 3 of 'X's or 'O's
cmp ebx, 1
je someoneWin1									; If EBX is 1, it means someone wins the game
cmp counter1, 9
je nobodywin1									; If the counter is 9, it means nobody wins the game (draw)

call clrscr										; From here, it's player2's turn
												; It will use the same algorithm with player1's one
INVOKE PrintBoard, Board
mov edx, offset player2prompt
call writestring
mov edx, Board
reenter2:
call readdec
cmp al, 9
ja wrongmove2
cmp al, 1
jb wrongmove2
jmp continue2
wrongmove2:
push edx
mov edx, offset PvsPprompt4
call writestring
pop edx
jmp reenter2

continue2:
dec eax
cmp byte ptr[edx + eax], 'O'
je wrongmove2
cmp byte ptr[edx + eax], 'X'
je wrongmove2

mov byte ptr[edx + eax], 'O'
inc counter1
INVOKE Check, Board
cmp ebx, 1
je someoneWin1
cmp counter1, 9
je nobodywin1

call clrscr
jmp L1

someoneWin1:
call clrscr
INVOKE FinalPrint, Board						; When someone wins the game, call 'FinalPrint' procedure, which will print blue color background with winner's 3 'O's or 'X's
cmp edi, 1
jne p2won1										; If EDI is 1, it means player1 wins the game
inc HMplay1										; If EDI if not 1, player2 wins the game, and increase the number of player1 wins
mov edx, offset p1wins
call writestring
jmp quitPvsP

p2won1:
inc HMplay2										; When player2 wins, increase the number of player2 wins
mov edx, offset p2wins
call writestring
jmp quitPvsP



p2first:										; When player2 gets to start first
												; It use the same method with when player1 starts first
												; Just order difference
mov edx,  offset PvsPprompt3
call writestring
L2:
INVOKE PrintBoard, Board
mov edx, offset player2prompt
call writestring
mov edx, Board
reenter3:
call readdec
cmp al, 9
ja wrongmove3
cmp al, 1
jb wrongmove3
jmp continue3
wrongmove3:
push edx
mov edx, offset PvsPprompt4
call writestring
pop edx
jmp reenter3

continue3:
dec eax
cmp byte ptr[edx + eax], 'O'
je wrongmove3
cmp byte ptr[edx + eax], 'X'
je wrongmove3

mov byte ptr[edx + eax], 'X'
inc counter1
INVOKE Check, Board
cmp ebx, 1
je someoneWin2
cmp counter1, 9
je nobodywin1

call clrscr
INVOKE PrintBoard, Board
mov edx, offset player1prompt
call writestring
mov edx, Board
reenter4:
call readdec
cmp al, 9
ja wrongmove4
cmp al, 1
jb wrongmove4
jmp continue4
wrongmove4:
push edx
mov edx, offset PvsPprompt4
call writestring
pop edx
jmp reenter4

continue4:
dec eax
cmp byte ptr[edx + eax], 'O'
je wrongmove4
cmp byte ptr[edx + eax], 'X'
je wrongmove4

mov byte ptr[edx + eax], 'O'
inc counter1
INVOKE Check, Board
cmp ebx, 1
je someonewin2
cmp counter1, 9
je nobodywin1

call clrscr

jmp L2

nobodywin1:
inc HMdraw										; Increase the number of draws
call clrscr
INVOKE PrintBoard, Board
mov edx, offset nowins1
call writestring
jmp quitPvsP

someoneWin2:
call clrscr
INVOKE FinalPrint, Board						
cmp edi, 0
jne p2won2
inc HMplay1
mov edx, offset p1wins
call writestring
jmp quitPvsP

p2won2:
inc HMplay2
mov edx, offset p2wins
call writestring

quitPvsP:
inc PvsPplayed									; End of every game, increase the number of player vs. player mode played
mov edx, offset PvsPprompt5
call writestring
mov edx, offset playagain1
mov ecx, 2
call readstring
mov al, playagain1
cmp al, 'Y'
je NewPvsP
cmp al, 'y'
je NewPvsP										

ret
PvsP endp


PvsC proc, Board : dword
; Description: This procedure playes player vs. computer mode tic tac toe
; 1) It will choose which player plays first by making a random number 0 or 1.
; 2) First player will mark the board with 'X', and the second player will mark the board with 'O'.
; 3) If computer starts first, it will fills the middle cell of the board.
; 4) If player did not fill the middle cell on player's turn, computer will take the middle cell.
; 5) 'X' will have red background color, and 'O' will have yellow background color.
; 6) When one of players wins, winner's 3 of 'O's or 'X's have blue background color.
; It takes the offset of the board.

.data
PvsCprompt2 byte 'Player gets to make the first move.', 0ah, 0dh, 0
PvsCprompt3 byte 'Computer gets to make the first move.', 0ah, 0dh, 0
PvsCprompt4 byte 'Wrong move. Enter a right place: ', 0
PvsCprompt5 byte 'Do you want to play it again? (Y/N): ', 0

playerprompt byte 'Player', 27h, 's turn to move: ', 0
computerprompt byte 'Computer', 27h, 's turn to move: ', 0
pwins byte 'Player wins! ', 0
cwins byte 'Computer wins! ', 0

counter2 byte 0									; When the counter becomes 9, and there's still no winner --> draw
playagain2 byte 2 dup(0h)
nowins2 byte 'Nobody wins this game. ', 0

.code
NewPvsC:
INVOKE ClearBoard, Board						; Clear the board every game
mov counter2, 0									; Clear the counter
call clrscr
mov eax, 2h
call randomrange
cmp al, 0										; If al is 0, player first
jne cfirst										; If al is 1, computer first

pfirst:											; Player starts first
mov edx, offset PvsCprompt2
call writestring

L3:												; Endless loop until counter get to 9 or until someone wins
INVOKE PrintBoard, Board
mov edx, offset playerprompt
call writestring
mov edx, Board
reenter5:
call readdec									; Ask user to choose a location
cmp al, 9
ja wrongmove5
cmp al, 1
jb wrongmove5									; If the input is less than 1 or greater than 9, make user re-enter the number.
jmp continue5
wrongmove5:
push edx
mov edx, offset PvsCprompt4
call writestring
pop edx
jmp reenter5

continue5:
dec eax
cmp byte ptr[edx + eax], 'O'
je wrongmove5
cmp byte ptr[edx + eax], 'X'
je wrongmove5									; If the location is alreay 'O' or 'X', re-enter the number.

mov byte ptr[edx + eax], 'X'					; If not, fill the lcation with 'X'
inc counter2
INVOKE Check, Board								; Check if there's any 3 of 'X's or 'O's
cmp ebx, 1			
je someoneWin3									; If EBX is 1, it means someone wins the game
cmp counter2, 9									
je nobodywin2									; If the counter is 9, it means nobody wins the game (draw)

call clrscr										; From here, it's computer's turn
INVOKE PrintBoard, Board
mov edx, offset computerprompt
call writestring
mov edx, Board

mov eax, 4										; On computer's turn, if the middle location (location with number 5) is still empty, computer has that location. 
cmp byte ptr[edx + eax], 'X'
je reenter6
cmp byte ptr[edx + eax], 'O'
je reenter6
mov byte ptr[edx + eax], 'O'
inc eax
call writedec
mov eax, 1000
call Delay
inc counter2
INVOKE Check, Board
cmp ebx, 1
je someoneWin3
cmp counter2, 9
je nobodywin2
call clrscr
jmp L3

reenter6:
mov eax, 9d
call randomrange								; It will choose a random location between 1 ~ 9

cmp byte ptr[edx + eax], 'O'
je reenter6
cmp byte ptr[edx + eax], 'X'
je reenter6										; If the location is already 'O' or 'X', re-make a random number

mov byte ptr[edx + eax], 'O'					; If not, fill the location with 'O'
inc eax
call writedec
mov eax, 1000
call Delay										; Delay the screen 1 second
inc counter2
INVOKE Check, Board								; Check if there's any 3 of 'X's or 'O's
cmp ebx, 1
je someoneWin3									; If EBX is 1, it means someone wins the game
cmp counter2, 9
je nobodywin2									; If the counter is 9, it means nobody wims the game (draw)



call clrscr
jmp L3

someoneWin3:
call clrscr
INVOKE FinalPrint, Board						; When someone wins the game, call 'FinalPrint' procedure, which will print blue color background with winner's 3 'O's or 'X's 
cmp edi, 1
jne cwon1										; If EDI is 1, it means player wins the game
inc HMplay										; If EDI is not 1, computer wins the game, and increase the number of player wins
mov edx, offset pwins
call writestring
jmp quitPvsC

cwon1:
inc HMcomp										; Increase the number of computer wins
mov edx, offset cwins
call writestring
jmp quitPvsC



cfirst:											
mov edx,  offset PvsCprompt3
call writestring
INVOKE PrintBoard, Board
mov edx, offset computerprompt
call writestring
mov edx, Board
mov eax, 4
mov byte ptr[edx + eax], 'X'					; When computer moves first, it automatically has the fifth location (the middle one).
inc counter2
inc eax
call writedec
mov eax, 1000
call Delay

L4:												; Endless loop until counter get to 9 or until someone wins
call clrscr
INVOKE PrintBoard, Board
mov edx, offset playerprompt
call writestring
mov edx, Board
reenter7:
call readdec
cmp al, 9
ja wrongmove6
cmp al, 1
jb wrongmove6
jmp continue6
wrongmove6:
push edx
mov edx, offset PvsCprompt4
call writestring
pop edx
jmp reenter7									; The algorithm is the same. Ask user to enter when to move. If the location is already filled, ask again to choose another location.

continue6:
dec eax
cmp byte ptr[edx + eax], 'O'
je wrongmove6
cmp byte ptr[edx + eax], 'X'
je wrongmove6

mov byte ptr[edx + eax], 'O'
inc counter2
INVOKE Check, Board
cmp ebx, 1
je someonewin4
cmp counter2, 9
je nobodywin2

call clrscr

INVOKE PrintBoard, Board
mov edx, offset computerprompt
call writestring
mov edx, Board
reenter8:
mov eax, 9d
call randomrange

cmp byte ptr[edx + eax], 'O'
je reenter8
cmp byte ptr[edx + eax], 'X'
je reenter8

mov byte ptr[edx + eax], 'X'
inc counter2
inc eax
call writedec
mov eax, 1000
call Delay
INVOKE Check, Board
cmp ebx, 1
je someoneWin4
cmp counter2, 9
je nobodywin2

jmp L4

nobodywin2:
inc HMdraw										; Increase the number of draws
call clrscr
INVOKE PrintBoard, Board
mov edx, offset nowins2
call writestring
jmp quitPvsC

someoneWin4:
call clrscr
INVOKE FinalPrint, Board						; Print board with blue background for the winner
cmp edi, 0
jne cwon2
inc HMplay										; If edi is 0, then player wins the game, and increase the number of player wins
mov edx, offset pwins
call writestring
jmp quitPvsC

cwon2:
inc HMcomp										; If edi is not 0, then computer wins the game, and increase the number of computer wins
mov edx, offset cwins
call writestring

quitPvsC:
inc PvsCplayed									; End of every game, increase the number of player vs. computer mode played
mov edx, offset PvsCprompt5
call writestring
mov edx, offset playagain2
mov ecx, 2
call readstring
mov al, playagain2
cmp al, 'Y'
je NewPvsC
cmp al, 'y'
je NewPvsC										; If user wants to play it again, come back to 'NewPvsC'

ret
PvsC endp


CvsC proc, Board : dword
; Description: This procedure playes computer vs. computer mode tic tac toe
; 1) It will choose which player plays first by making a random number 0 or 1.
; 2) First player will mark the board with 'X', and the second player will mark the board with 'O'.
; 3) Each computer will fill a random location. They don't choose the middle location unconditionally
; 4) 'X' will have red background color, and 'O' will have yellow background color.
; 5) When one of players wins, winner's 3 of 'O's or 'X's have blue background color.
; It takes the offset of the board.

.data
CvsCprompt2 byte 'Computer1 gets to make the first move.', 0ah, 0dh, 0
CvsCprompt3 byte 'Computer2 gets to make the first move.', 0ah, 0dh, 0
CvsCprompt4 byte 'Wrong move. Enter a right place: ', 0
CvsCprompt5 byte 'Do you want to play it again? (Y/N): ', 0

computer1prompt byte 'Computer1', 27h, 's turn to move: ', 0
computer2prompt byte 'Computer2', 27h, 's turn to move: ', 0

c1wins byte 'Computer1 wins! ', 0
c2wins byte 'Computer2 wins! ', 0

counter3 byte 0									; When the counter becomes 9, and there's still no winner --> draw
playagain3 byte 2 dup(0h)
nowins3 byte 'Nobody wins this game. ', 0

.code
NewCvsC:
INVOKE ClearBoard, Board						; Clear the board every game
mov counter3, 0									; Clear the counter
call clrscr
mov eax, 2h
call randomrange
cmp al, 0										; If al is 0, computer1 first
jne c2first										; If al is 1, computer2 first

c1first:										; computer1 starts first
mov edx, offset CvsCprompt2
call writestring

L5:												; Endless loop until counter gets to 9 of until someone wins
INVOKE PrintBoard, Board
mov edx, offset computer1prompt
call writestring
mov edx, Board

reenter9:
mov eax, 9d
call randomrange								; It will choose a random location between 1 ~ 9

cmp byte ptr[edx + eax], 'O'
je reenter9
cmp byte ptr[edx + eax], 'X'
je reenter9										; If the location is already 'O' or 'X', re-make a random number

mov byte ptr[edx + eax], 'X'					; If not, fill the location with 'O'
inc eax
call writedec
inc counter3
mov eax, 1000
call Delay										; Delay the screen 1 second
INVOKE Check, Board								; Check if there's any 3 of 'X's or 'O's
cmp ebx, 1										; If EBX is 1, it means someone wins the game
je someoneWin5
cmp counter3, 9									; If the counter is 9, it means nobody wins the game (draw)
je nobodywin3

call clrscr
INVOKE PrintBoard, Board						; From here, it's computer2's turn
												; User the same algorithm with computer 1
mov edx, offset computer2prompt
call writestring
mov edx, Board
reenter10:
mov eax, 9d
call randomrange

cmp byte ptr[edx + eax], 'O'
je reenter10
cmp byte ptr[edx + eax], 'X'
je reenter10

mov byte ptr[edx + eax], 'O'
inc eax
call writedec
mov eax, 1000
call Delay
inc counter3
INVOKE Check, Board
cmp ebx, 1
je someoneWin5
cmp counter3, 9
je nobodywin3

call clrscr
jmp L5

someoneWin5:									
call clrscr
INVOKE FinalPrint, Board						; When someone wins the game, call 'FinalPrint' procedure, which will print blue color background with winner's 3 'O's or 'X's
cmp edi, 1
jne c2won1										; If EDI is 1, it means computer1 wins the game
inc HMcomp1										; If EDI is not 1, computer2 wins the game, and increase the number of computer1 wins
mov edx, offset c1wins
call writestring
jmp quitCvsC

c2won1:
inc HMcomp2										; If computer2 wins, increase the number of computer2 wins
mov edx, offset c2wins
call writestring
jmp quitCvsC



c2first:										; When computer2 starts first
												; It works the same way as when c1 starts first
												; Just order difference
mov edx,  offset CvsCprompt3
call writestring

L6:
INVOKE PrintBoard, Board
mov edx, offset computer2prompt
call writestring
mov edx, Board
reenter11:
mov eax, 9d
call randomrange

cmp byte ptr[edx + eax], 'O'
je reenter11
cmp byte ptr[edx + eax], 'X'
je reenter11

mov byte ptr[edx + eax], 'X'
inc eax
call writedec
mov eax, 1000
call Delay
inc counter3
INVOKE Check, Board
cmp ebx, 1
je someonewin6
cmp counter3, 9
je nobodywin3

call clrscr

INVOKE PrintBoard, Board
mov edx, offset computer1prompt
call writestring
mov edx, Board
reenter12:
mov eax, 9d
call randomrange

cmp byte ptr[edx + eax], 'O'
je reenter12
cmp byte ptr[edx + eax], 'X'
je reenter12

mov byte ptr[edx + eax], 'O'
inc counter3
inc eax
call writedec
mov eax, 1000
call Delay
INVOKE Check, Board
cmp ebx, 1
je someoneWin6
cmp counter3, 9
je nobodywin3

call clrscr
jmp L6

nobodywin3:
inc HMdraw										; Increase the number of draws
call clrscr
INVOKE PrintBoard, Board
mov edx, offset nowins3
call writestring
jmp quitCvsC

someoneWin6:
call clrscr
INVOKE FinalPrint, Board						; Print board with the blue background for the winner
cmp edi, 0
jne c2won2
inc HMcomp1										; If EDI is 0, computer1 wins the game, and increase the number of computer1 wins
mov edx, offset c1wins
call writestring
jmp quitCvsC

c2won2:
inc HMcomp2										; If EDI is not 0, then computer2 wins the gmame, and increase the number of computer2 wins
mov edx, offset c2wins
call writestring

quitCvsC:
inc CvsCplayed									; End of every game, increase the number of computer1 vs. computer2 mode played
mov edx, offset CvsCprompt5
call writestring
mov edx, offset playagain3
mov ecx, 2
call readstring
mov al, playagain3
cmp al, 'Y'
je NewCvsC
cmp al, 'y'
je NewCvsC										; If user wants to play it again, come back to 'NewCvsC'

ret
CvsC endp


Check proc, Board : dword
; Description: This procedure will check if any user made 3 'O's or 'X's in any row or column or diagnal.
; It takes the offset of the board
; Returns: if someone wins ---> EBX = 1
;
;		   if 'O' mark wins ---> EDI = 0
;		   if 'X' mark wins ---> EDI = 1
;
;		   if the first row made wins ---> EAX = 0d
;		   if the second row made wins ---> EAX = 1d
;		   if the third row made wins ---> EAX = 2d
;		   if the first column made wins ---> EAX = 3d
;		   if the second column made wins ---> EAX = 4d
;		   if the third column made wins ---> EAX = 5d
;		   if the diagnal from left top to right bottom made wins ---> EAX = 6d
;		   if the diagnal from right top to left bottom made wins ---> EAX =70d

.data
Ocounter byte 0
Xcounter byte 0
loopcounter byte 0

.code
mov edx, Board
mov esi, 0
mov ecx, 3
row:												; Check every row
	push ecx
	mov Xcounter, 0									; Clear Xcounter and Ocounter
	mov Ocounter, 0
	mov ecx, 3
	eachRow:
		mov al, byte ptr[edx + esi]
		cmp al, 'O'
		je itsO1		
		cmp al, 'X'
		je itsX1
		jmp nextcheck1


		itsO1: 
		inc Ocounter
		jmp nextcheck1

		itsX1:
		inc Xcounter

		nextcheck1:
		inc esi
	loop eachRow

	cmp Ocounter, 3
	je cmpO1

	cmp Xcounter, 3
	je cmpX1

	continuecheck1:
	inc loopcounter
	pop ecx
loop row											; If the counter becomes 3 after checking each row, it means there is a winner


cmpO1:
	cmp loopcounter, 0									; loopcounter == 0  ---> implies first raw
	je OwinRow1
	cmp loopcounter, 1									; loopcounter == 1  ---> implies second raw
	je OwinRow2
	cmp loopcounter, 2									; loopcounter == 2  ---> implies third raw
	je OwinRow3

cmpX1:
	cmp loopcounter, 0
	je XwinRow1
	cmp loopcounter, 1
	je XwinRow2
	cmp loopcounter, 2
	je XwinRow3



cmp loopcounter, 0
	je OwinRow1
	cmp loopcounter, 1
	je OwinRow2
	cmp loopcounter, 2
	je OwinRow3


; Clear loopcounter
mov loopcounter, 0

mov esi, 0
mov ecx, 3
column:
	push ecx
	mov Xcounter, 0										; Clear Xcounter and Ocounter
	mov Ocounter, 0
	mov ecx, 3
	eachColumn:
		mov al, byte ptr[edx + esi]
		cmp al, 'O'
		je itsO2		
		cmp al, 'X'
		je itsX2
		jmp nextcheck2


		itsO2: 
		inc Ocounter
		jmp nextcheck2

		itsX2:
		inc Xcounter

		nextcheck2:
		add esi, 3
	loop eachColumn

	cmp Ocounter, 3
	je cmpO2

	cmp Xcounter, 3
	je cmpX2

	continuecheck2:
	pop ecx
	inc edx
	mov esi, 0
	inc loopcounter
loop column											; If the counter becomes 3 after checking each column, it means there is a winner


cmpO2:
	cmp loopcounter, 0									; loopcounter == 0  ---> implies first column
	je OwinCol1
	cmp loopcounter, 1									; loopcounter == 0  ---> implies second column
	je OwinCol2
	cmp loopcounter, 2									; loopcounter == 0  ---> implies third column
	je OwinCol3

cmpX2:
	cmp loopcounter, 0
	je XwinCol1
	cmp loopcounter, 1
	je XwinCol2
	cmp loopcounter, 2
	je XwinCol3

; Clear loopcounter, Xcounter, Ocounter
mov loopcounter, 0
mov edx, Board
mov Xcounter, 0
mov Ocounter, 0

mov ecx, 3
diag1:
	mov al, byte ptr[edx + esi]
	cmp al, 'O'
	je itsO3	
	cmp al, 'X'
	je itsX3
	jmp nextcheck3
	
	itsO3: 
	inc Ocounter
	jmp nextcheck3
	
	itsX3:
	inc Xcounter
	
	nextcheck3:
	add esi, 4
loop diag1											; If the counter becomes 3 after the first diagnal, it means there is a winner

cmp Ocounter, 3
je OwinDiag1
cmp Xcounter, 3
je XwinDiag1

add edx, 2
mov esi, 0
mov Xcounter, 0
mov Ocounter, 0

mov ecx, 3
diag2:
	mov al, byte ptr[edx + esi]
	cmp al, 'O'
	je itsO4	
	cmp al, 'X'
	je itsX4
	jmp nextcheck4
	
	itsO4: 
	inc Ocounter
	jmp nextcheck4
	
	itsX4:
	inc Xcounter
	
	nextcheck4:
	add esi, 2
loop diag2											; If the counter becomes 3 after the second diagnal, it means there is a winner

cmp Ocounter, 3
je OwinDiag2
cmp Xcounter, 3
je XwinDiag2

mov ebx, 0
jmp quitcheck

OwinRow1:
mov ebx, 1
mov edi, 0
mov eax, 0d
jmp quitcheck

OwinRow2:
mov ebx, 1
mov edi, 0
mov eax, 1d
jmp quitcheck

OwinRow3:
mov ebx, 1
mov edi, 0
mov eax, 2d
jmp quitcheck

OwinCol1:
mov ebx, 1
mov edi, 0
mov eax, 3d
jmp quitcheck

OwinCol2:
mov ebx, 1
mov edi, 0
mov eax, 4d
jmp quitcheck

OwinCol3:
mov ebx, 1
mov edi, 0
mov eax, 5d
jmp quitcheck

OwinDiag1:
mov ebx, 1
mov edi, 0
mov eax, 6d
jmp quitcheck

OwinDiag2:
mov ebx, 1
mov edi, 0
mov eax, 7d
jmp quitcheck

XwinRow1:
mov ebx, 1
mov edi, 1
mov eax, 0d
jmp quitcheck

XwinRow2:
mov ebx, 1
mov edi, 1
mov eax, 1d
jmp quitcheck

XwinRow3:
mov ebx, 1
mov edi, 1
mov eax, 2d
jmp quitcheck

XwinCol1:
mov ebx, 1
mov edi, 0
mov eax, 3d
jmp quitcheck

XwinCol2:
mov ebx, 1
mov edi, 1
mov eax, 4d
jmp quitcheck

XwinCol3:
mov ebx, 1
mov edi, 1
mov eax, 5d
jmp quitcheck

XwinDiag1:
mov ebx, 1
mov edi, 1
mov eax, 6d
jmp quitcheck

XwinDiag2:
mov ebx, 1
mov edi, 1
mov eax, 7d
jmp quitcheck


quitcheck:

ret
Check endp


ColorChange proc
; Description: This procedure will change the letter color and the background colors of 'O' and 'X'
; 'X' with red background and black letter colors.
; 'O' with yellow background and black letter colors.

cmp byte ptr[edx + esi], 'X'
je itsX
cmp byte ptr[edx + esi], 'O'
je itsO
mov eax, white + (black*16)
call SetTextColor
jmp endChange

itsX:												; When it is 'X'
mov eax, black + (red*16)
call SetTextColor
jmp endChange

itsO:												; When it is 'O'
mov eax, black + (yellow*16)
call SetTextColor

endChange:											; If it is not either 'X' or 'O', don't change anything. (Keep the original colors).
ret
ColorChange endp


Statistics proc, val1:byte, val2:byte, val3:byte, val4:byte, val5:byte, val6:byte, val7:byte, val8:byte, val9:byte, val10:byte
; Description: This procedure will show user the statistics.
; 1) How many times player vs. player mode played
;	 How many times player1 won games in player vs. player mode
;	 How many times player2 won games in player vs. player mode
;
; 2) How many times player vs. computer mode played
;	 How many times player won games in player vs. computer mode
;	 How many times computer won games in player vs. computer mode
;
; 3) How many times computer vs. computer mode played
;	 How many times computer1 won games in computer vs. computer mode
;	 How many times computer2 won games in computer vs. computer mode
;
; 4) How many times all games made draws
;
; * val1 = PvsPplayed
;   val2 = PvsCplayed 
;   val3 = CvsCplayed
;   val4 = HMplay1
;   val5 = HMplay2
;   val6 = HMcomp
;   val7 = HMdraw 
;   val8 = HMplay
;   val9 = HMcomp1
;   val10 = HMcomp2


.data
statPrompt1 byte 'PvP: ', 0
statPrompt2 byte 'PvC: ', 0
statPrompt3 byte 'CvC: ', 0
statPrompt4 byte ' times played.', 0ah, 0dh, 0
statPrompt5 byte 'Player1: ', 0
statPrompt6 byte 'Player2: ', 0
statPrompt7 byte 'Computer: ', 0
statPrompt8 byte ' times won.', 0ah, 0dh, 0
statPrompt9 byte 'Total Draw: ', 0
statPrompt10 byte ' times', 0
statPrompt11 byte 'Player: ', 0
statPrompt12 byte 'Computer1: ', 0
statPrompt13 byte 'Computer2: ', 0

.code
;;
mov edx, offset statPrompt1
call writestring
mov al, val1
call writedec
mov edx, offset statPrompt4
call writestring

mov edx, offset statPrompt5
call writestring
mov al, val4
call writedec
mov edx, offset statPrompt8
call writestring

mov edx, offset statPrompt6
call writestring
mov al, val5
call writedec
mov edx, offset statPrompt8
call writestring
call crlf
;;
mov edx, offset statPrompt2
call writestring
mov al, val2
call writedec
mov edx, offset statPrompt4
call writestring

mov edx, offset statPrompt11
call writestring
mov al, val8
call writedec
mov edx, offset statPrompt8
call writestring

mov edx, offset statPrompt7
call writestring
mov al, val6
call writedec
mov edx, offset statPrompt8
call writestring
call crlf
;;
mov edx, offset statPrompt3
call writestring
mov al, val3
call writedec
mov edx, offset statPrompt4
call writestring

mov edx, offset statPrompt12
call writestring
mov al, val9
call writedec
mov edx, offset statPrompt8
call writestring

mov edx, offset statPrompt13
call writestring
mov al, val10
call writedec
mov edx, offset statPrompt8
call writestring
call crlf
;
mov edx, offset statPrompt9
call writestring
mov al, val7
call writedec
mov edx, offset statPrompt10
call writestring

ret
Statistics endp



FinalPrint proc, Board : dword
; Description: This procedure is used every end of the game because this procedure prints out blue background color for the winner.
; It takes the offset of the board.
; It will determine which row, column or diagnal made it win by checking EAX register.
; EAX register has the information from 'Check' procedure.

.data
firstline2	byte '1.   |2.   |3.   |', 0ah, 0dh, 0
secondline2 byte '4.   |5.   |6.   |', 0ah, 0dh, 0
thirdline2  byte '7.   |8.   |9.   |', 0ah, 0dh, 0
line2 		byte '-----------------', 0ah, 0dh, 0

.code
push edx

cmp eax, 0d											; If EAX is 0, the first row will be colored with blue.
jne row2

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov ecx, 3
first1:
mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first1

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov ecx, 3
second1:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop second1

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov ecx, 3
third1:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third1
call crlf
jmp quitFinalPrint

row2:
cmp eax, 1d											; If EAX is 1d, the second row will be colored with blue.
jne row3

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov ecx, 3
first2:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first2

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov ecx, 3
second2:
mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop second2

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov ecx, 3
third2:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third2
call crlf

jmp quitFinalPrint

row3:
cmp eax, 2d											; If EAX is 2d, the third row will be colored with blue.
jne col1

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov ecx, 3
first3:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first3

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov ecx, 3
second3:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop second3

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov ecx, 3
third3:
mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third3
call crlf

jmp quitFinalPrint

col1:
cmp eax, 3d											; If EAX is 3d, the first column will be colored with blue.
jne col2

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov ecx, 2
first4:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first4

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov ecx, 2
second4:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop second4

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov ecx, 2
third4:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third4
call crlf

jmp quitFinalPrint

col2:
cmp eax, 4d											; If EAX is 4d, the second column will be colored with blue.
jne col3

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf



jmp quitFinalPrint


col3:
cmp eax, 5d											; If EAX is 5d, the third column will be colored with blue.
jne diag1

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov ecx, 2
first5:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first5

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov ecx, 2
second5:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop second5

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov ecx, 2
third5:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third5

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

jmp quitFinalPrint

diag1:
cmp eax, 6d											; If EAX is 6d, the first diagnal will be colored with blue.
jne diag2

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov ecx, 2
first6:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first6

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov ecx, 2
third6:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third6

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

jmp quitFinalPrint


diag2:
cmp eax, 7d											; If EAX is 7d, the first row will be colored with blue.

mov edx, Board
mov esi, 0

push edx
mov edx, offset firstline2
call writestring
pop edx

mov ecx, 2
first7:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop first7

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset secondline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

call crlf

push edx
mov edx, offset line2
call writestring

mov edx, offset thirdline2
call writestring
pop edx

mov al, ' '
call writechar
call writechar
mov eax, black + (blue*16)
call SetTextColor
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi

mov ecx, 2
third7:
mov al, ' '
call writechar
call writechar
call ColorChange
mov al, byte ptr[edx + esi]
call writechar
mov eax, white + (black*16)
call SetTextColor
mov al, ' '
call writechar
call writechar
mov al, '|'
call writechar
inc esi
loop third7
call crlf

quitFinalPrint:
pop edx
ret
FinalPrint endp


errorMsg PROC
; Description:  This procedure displays error message on invalid entry

.data
errormessage byte 'You have entered an invalid option. Please try again.', 0ah, 0dh, 0h

.code
push edx                      ; Save value in edx
mov edx, offset errormessage
call writestring
call waitmsg
pop edx                       ; restore value in edx

ret
errorMsg ENDP


end main