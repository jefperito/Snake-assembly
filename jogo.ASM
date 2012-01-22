.MODEL SMALL
.STACK 100H
.DATA
linha	DB ?
coluna	DB ?
xis	DB "X$"
dir	DB ?
esq	DB ?
bai	DB ?
cim	DB ?
sair	DB ?
.CODE
;Inicio procedimento limpa tela
limpa_tela proc near
	push cx
	mov ah, 6
	mov al, 0
	mov bh, 0EH
	mov cx, 0
	mov dh, 24
	mov dl, 79
	int 10h
	pop cx
	ret
limpa_tela endp
;Fim procedimento limpa tela

;Inicio procedimento limpa buffer
limpa_buffer proc near
		MOV AH,0CH
		MOV AL,0
		INT 21H
		RET
limpa_buffer endp
;Fim procedimento limpa buffer

;Inicio procedimento de movimentação do cursor
mov_cursor proc near
	mov ah, 2
	mov dh, [linha]
	mov dl, [coluna]
	mov bh, 0
	int 10h
	ret
mov_cursor endp
;Fim procedimento de movimentação do cursor

;Inicio procedimento scroll up
scroll_up proc near
	mov ah, 6
	mov al, 0
	mov bh, 0
	mov ch, 0
	mov cl, 0
	mov dh, 79
	mov dl, 79
	int 10h
	ret
scroll_up endp
;Fim procedimento scroll up

;Inicio procedimento de tempo
tempo proc near
	push cx
	mov cx, 50000
volta2:	push cx
	mov cx, 5000
	volta3:
		loop volta3
	pop cx
	loop volta2
	pop cx
	ret
tempo endp
;Fim procedimento de tempo


;Inicio procedimento mostra na tela o X
joga_x proc near
	mov dx, offset xis
	mov ah, 09h
	int 21h
	ret
joga_x endp
;Fim procedimento mostra na tela o X

roda_tudo proc near
	mov ah, 27		; Colocando o codigo ascii nas variaveis
	mov [sair], ah 
	mov ah, 4BH
	mov [esq], ah
	mov ah, 4DH
	mov [dir], ah
	mov ah, 48H
	mov [cim], ah
	mov ah, 50H
	mov [bai], ah		; Fim
	mov ah, 12		; Posição inicial do cursor na tela
	mov [linha], ah
	mov ah, 39
	mov [coluna], ah	; Fim
volta:	call limpa_buffer
	call mov_cursor
	call joga_x
	inc [linha]		
	call tempo
	call limpa_tela
	mov bh, 25		
	cmp [linha], bh		; Compara final da tela com a posição atual do cursor
	je sobe
	mov ah, 1		; Função que pega codigo do botao do teclado quando pressionado
	int 16h
	jnz compara		; Se tem algum botao pressionado, joga para o compara
	jmp volta
	compara:
		cmp ah, [cim]
		je sobe
		cmp ah, [bai]
		je desce
		cmp ah, [esq]
		je left2
		cmp ah, [dir]
		je right2
		cmp al, [sair]
		je sai2
		jmp volta
	desce:	call limpa_buffer
		inc [linha]
		call mov_cursor
		call joga_x
		call tempo
		call limpa_tela
		mov bh, 24
		cmp [linha], bh
		je sobe
		mov ah, 1
		int 16h
		jnz compara
		jmp desce
	sobe:	call limpa_buffer
		dec [linha]
		call mov_cursor
		call joga_x
		call tempo
		call limpa_tela
		mov bh, 0
		cmp [linha], bh
		je desce
		mov ah, 1
		int 16h
		jnz compara
		jmp sobe

sai2:		jmp sai
right2:		jmp right
left2:		jmp left
compara2:	jmp compara

	left:	call limpa_buffer
		mov ax, 0
		dec [coluna]
		call mov_cursor
		call joga_x
		call tempo
		call limpa_tela
		mov bh, 0
		cmp [coluna], bh
		je right
		mov ah, 1
		int 16h
		jnz compara2
		jmp left
	right:	call limpa_buffer
		mov ax, 0
		inc [coluna]
		call mov_cursor
		call joga_x
		call tempo
		call limpa_tela
		mov bh, 79
		cmp [coluna], bh
		je left
		mov ah, 1
		int 16h
		jnz compara2
		jmp right
	ret
roda_tudo endp

inicio:
mov ax, @data
mov ds, ax

call limpa_tela
call roda_tudo
sai:
mov ah, 4ch
int 21h
END inicio