include irvine32.inc
.data
dot byte ".", 0

space byte "   ", 0
dspace byte "  ", 0
singlespace byte " ", 0
substr1 BYTE 2 DUP(0)       ; Reserve space for one character + null terminator
tempeax dword ?
tempecx dword ?


r0 byte ".   .   .   .   .", 0
r1 byte "                       .", 0
r2 byte "                       .", 0
r3 byte ".   .   .   .   .", 0
r4 byte "                       .", 0
r5 byte "                       .", 0
r6 byte ".   .   .   .   .", 0
r7 byte "                       .", 0
r8 byte "                       .", 0
r9 byte ".   .   .   .   .", 0
r10 byte "                       .", 0
r11 byte "                       .", 0
r12 byte ".   .   .   .   .", 0


r13 byte "                 ", 0
r14 byte "                       .", 0
r15 byte "                       .", 0
r16 byte "                 ", 0
r17 byte "                       .", 0
r18 byte "                       .", 0
r19 byte "                 ", 0
r20 byte "                       .", 0
r21 byte "                       .", 0
r22 byte "                 ", 0
r23 byte "                       .", 0
r24 byte "                       .", 0
r25 byte "                 ", 0

r26 byte "                 ", 0
r27 byte "                       .", 0
r28 byte "                       .", 0
r29 byte "                 ", 0
r30 byte "                       .", 0
r31 byte "                       .", 0
r32 byte "                 ", 0
r33 byte "                       .", 0
r34 byte "                       .", 0
r35 byte "                 ", 0
r36 byte "                       .", 0
r37 byte "                       .", 0
r38 byte "                 ", 0


array dword offset r0, offset r1, offset r2, offset r3, offset r4, offset r5, offset r6, offset r7, offset r8, offset r9, offset r10, offset r11, offset r12
RedArray dword offset r13, offset r14, offset r15, offset r16, offset r17, offset r18, offset r19, offset r20, offset r21, offset r22, offset r23, offset r24, offset r25
BlueArray dword offset r26, offset r27, offset r28, offset r29, offset r30, offset r31, offset r32, offset r33, offset r34, offset r35, offset r36, offset r37, offset r38


startc byte ?
startr byte ?

startPrompt byte "Input the Row: ", 0
endPrompt byte "Input the Col: ", 0
rcPrompt byte "Input the row or column movement: ", 0
p1prompt byte "Player 1", 0
p2prompt byte "Player 2", 0
contprompt byte "Press any key to continue: ", 0

turns dword 0
rc byte ?
row byte "r", 0
.code
main proc
	
	mov eax, 0
	gameLoop:
	call drawgridbox
	mov eax, turns
	test turns, 1
	jz player1    ;player 1 turn
	
	player2:
	mov edx, offset p2prompt
	call writestring
	call crlf
	jmp cont
	
	player1:
	mov edx, offset p1prompt
	call writestring
	call crlf




	cont:
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
	inc turns
	mov edx, offset contprompt
	call writestring
	call ReadChar  ; wait for key press
	call clrscr
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
    ; For main array
    movzx esi, startr           
	imul esi, 3
    mov eax, array[esi * type array] 

    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx                     

    mov byte ptr [eax], '_'          
    inc eax
    mov byte ptr [eax], '_'          
	inc eax
	mov byte ptr [eax], '_' 

	; for red or blue array

	test turns, 1	; if even(0) player 1, else player 2
	jz p1
	; p2 part, Bluearray
	
	movzx esi, startr           
	imul esi, 3
    mov eax, Bluearray[esi * type array] 

    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx                     

    mov byte ptr [eax], '_'          
    inc eax
    mov byte ptr [eax], '_'          
	inc eax
	mov byte ptr [eax], '_'
	jmp cont

	; p1 part, Redarray
	p1:
	
	movzx esi, startr           
	imul esi, 3
    mov eax, Redarray[esi * type array] 

    movzx ecx, startc                
	inc eax
    imul ecx, 4                      
    add eax, ecx                     

    mov byte ptr [eax], '_'          
    inc eax
    mov byte ptr [eax], '_'          
	inc eax
	mov byte ptr [eax], '_'

	cont:
    ret
modifyRow endp




modifyCol proc
	
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, array[esi * TYPE array] 
	
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

    mov byte ptr [eax], '|' 
	inc esi
	mov eax, array[esi * TYPE array] 
	movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	mov byte ptr [eax], '|' 


	test turns, 1	; if even(0) player 1, else player 2
	jz p1
	; p2 part, Bluearray
	
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, Bluearray[esi * TYPE array] 
	
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

    mov byte ptr [eax], '|' 
	inc esi
	mov eax, Bluearray[esi * TYPE array] 
	movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	mov byte ptr [eax], '|' 
	jmp cont


	p1:
	movzx esi, startr
	imul esi, 3
	inc esi 
	
    
	mov eax, Redarray[esi * TYPE array] 
	
    movzx ecx, startc
	imul ecx, 4
	add eax, ecx

    mov byte ptr [eax], '|' 
	inc esi
	mov eax, Redarray[esi * TYPE array] 
	movzx ecx, startc
	imul ecx, 4
	add eax, ecx
	mov byte ptr [eax], '|' 


	cont:
    ret
modifyCol endp






drawgridbox proc	
	
	mov eax, white
	call settextcolor
	mov eax, 0
	mov edx, offset dspace
	call writestring
	l3:
		call writedec
		mov edx, offset space
		call writestring
		cmp eax, 4
		jge out3
		inc eax
		jmp l3
	
	out3:
	mov esi, 0
	mov eax, 0
	call crlf
	call crlf
	mov ecx, 0
	

	L2:
		Cmp eax, 13
		Jge out2

		mov tempeax, eax
		mov tempecx, ecx
		mov eax, white
		call settextcolor
		mov eax, tempeax
		mov ecx, 3
		mov edx, 0 ; 
		div ecx	; eax gets divided by 3, edx has the remainder, 
		test edx, edx
		jnz nn
		call writedec ; quotient already in eax
		
		jmp cont1
		
		nn:
			mov edx, offset singlespace
			call writestring
		cont1:
		mov edx, offset singlespace
		call writestring
		mov eax, tempeax
		mov ecx, tempecx

		mov ecx, array[esi * type array]		; current string
		mov edx, Redarray[esi * type Redarray]
		mov edi, Bluearray[esi * type Bluearray]
		mov tempeax, eax
		
		L1:
			Cmp byte ptr [ecx], 0	; check if end of current
			Je out1
			Mov bl, [ecx]		; only one byte gets moved
			Mov bh, [edx]		; the red array
			Mov [substr1], bl
			mov byte ptr [substr1 + 1], 0
			push edx
			Cmp bl, bh			
			Je dosmth
	
			Dosmthelse:
				Mov bl, [ecx]		; only one byte gets moved
				Mov bh, [edi]		; the red array
				Cmp bl, bh
				jne cont3
				mov eax, blue
				call settextcolor
				jmp cont
				cont3:
				Mov eax, white
				Call settextcolor
				Jmp cont
			Dosmth:
	
				Mov eax, red
				Call settextcolor
			Cont:
				Mov edx, offset substr1
				Call writestring
				Pop edx
				Inc edx
				Inc ecx
				inc edi
				Jmp l1
				Out1:

			mov eax, tempeax
			Inc eax	; eax is used as row counter
			Inc esi	; row index
			Call crlf
			Jmp l2
			Out2:

	
	call crlf
	mov eax, white
	call settextcolor
	ret
drawgridbox endp

end main
