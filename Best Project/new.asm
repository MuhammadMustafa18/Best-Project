include irvine32.inc
.data
dot byte ".", 0
space byte "  ", 0
singlespace byte " ", 0

r0 byte ".  .  .  .  .", 0
r1 byte "                  .", 0
r2 byte ".  .  .  .  .", 0
r3 byte "                  .", 0
r4 byte ".  .  .  .  .", 0
r5 byte "                  .", 0
r6 byte ".  .  .  .  .", 0
r7 byte "                  .", 0
r8 byte ".  .  .  .  .", 0


array dword offset r0, offset r1, offset r2, offset r3, offset r4, offset r5, offset r6, offset r7, offset r8

startc byte ?
startr byte ?

startPrompt byte "Input the Row: ", 0
endPrompt byte "Input the Col: ", 0
rcPrompt byte "Input the row or column movement: ", 0

rc byte ?
row byte "r", 0
.code
main proc
	
	
	gameLoop:
    call takeInputs
    
    mov esi, 0
    mov al, rc[esi]
    cmp al, 'r'
    jne stringsAreNotEqual
    jmp stringsAreEqual 

stringsAreEqual:
    call modifyRow
    jmp continueGame

stringsAreNotEqual:
    ; code to execute if strings are not equal
    call modifyCol
    jmp continueGame

continueGame:
    call drawgridbox
    jmp gameLoop ; repeat the game loop


; exit game
mov eax, 0
call exitprocess 


call exitprocess 
main endp

takeInputs proc

	; take row or column input
	mov edx, offset rcPrompt
	call writestring
	mov edx, offset rc
	mov ecx, 2
	call readstring
	
	call writestring
	call crlf



	; Ask for the row
    mov edx, offset startPrompt
    call writestring
    call readint
    mov startr, al       ; Store the row in startr

    ; Ask for the column
    mov edx, offset endPrompt
    call writestring
    call readint
    mov startc, al       ; Store the column in startc

    call crlf
	ret
	takeInputs endp

modifyRow proc
    ; Get the row address
    movzx esi, startr           ; Zero-extend startr to esi (row index)
	imul esi, 2
    mov eax, array[esi * type array] ; Load the address of the specified row

    ; Calculate the offset for the column in the row
    movzx ecx, startc                ; Zero-extend startc to ecx (column index)
	inc eax
    imul ecx, 3                      ; Each dot and space take 3 bytes (".  ")
    add eax, ecx                     ; Move to the desired column

    ; Modify the character at the position to '_ _'
    mov byte ptr [eax], '_'          ; Replace '.' with '_'
    inc eax
    mov byte ptr [eax], '_'          ; Replace the next character with '_'
    ret
modifyRow endp




modifyCol proc
	movzx esi, startr
	imul esi, 2
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
    movzx ecx, startc
	imul ecx, 3
	add eax, ecx

    mov byte ptr [eax], '|' 
	
    ret
modifyCol endp






drawgridbox proc	
	mov eax, 0
	mov edx, offset space
	call writestring
	l2:
		call writedec
		mov edx, offset space
		call writestring
		cmp eax, 4
		jge out3
		inc eax
		jmp l2
	
	out3:
	mov esi, 0
	mov eax, 0
	call crlf
	call crlf
	mov ecx, 0
	
	l1:
		cmp eax, 9
		jge out1
		
		test eax, 1 ; when line is even ie 0 2 4, zero comes and we print the column number
		jnz nn
		push eax
		mov eax, ecx
		call writedec
		pop eax
		inc ecx
		jmp cont
		nn:
		mov edx, offset singlespace
		call writestring
		cont:
		mov edx, offset singlespace
		call writestring
		mov edx, array[esi* type array]
		call writestring
		call crlf
		
		inc esi
		inc eax
		jmp l1
	out1:
	ret
drawgridbox endp
end main