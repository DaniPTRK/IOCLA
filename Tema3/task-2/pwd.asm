section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here

section .text
	global pwd

	extern strcmp
	extern strrchr
	extern strcat
	
;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0

	mov eax, [ebp+8]  ; directories
	mov edx, [ebp+12] ; n
	mov esi, [ebp+16] ; output 

	xor ecx, ecx

go_through_dirs:
	;; Start going through the array of strings.

	;; Check if we must go backwards.
	pusha
	push back
	push dword [eax+ecx*4]
	call strcmp
	add esp, 8
	cmp eax, 0
	popa
	je go_backwards

	;; Check if we must change anything.
	pusha
	push curr
	push dword [eax+ecx*4]
	call strcmp
	add esp, 8
	cmp eax, 0
	je through_dirs

	;; Haven't found any special input.
	;; Add the slash.
	popa 

	pusha
	push slash
	push esi
	call strcat
	add esp, 8
	popa

	;; Add the new directory.
	pusha
	push dword [eax+ecx*4]
	push esi
	call strcat
	add esp, 8
	
	jmp through_dirs

go_backwards:
	;; Search for the last "/".
	pusha
	push '/'
	push esi
	call strrchr
	add esp, 8

	;; Check if we have where to go backwards.
	cmp eax, 0
	je through_dirs

	;; We've found the last slash. Exclude the last directory.
	mov byte [eax], 0
	
through_dirs:
	;; Continue going through the array of strings.
	popa
	inc ecx
	cmp ecx, edx
	jl go_through_dirs
	
	;; Add the final slash.
	pusha
	push slash
	push esi
	call strcat
	add esp, 8
	popa

	leave
	ret