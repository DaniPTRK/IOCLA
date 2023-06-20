section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	push	rbp
	mov 	rbp, rsp

	push rbx

	mov rax, rdi ; v1
	mov rbx, rsi ; n1
	mov rdi, rcx ; n2
	mov rsi, r8 ; v
	;; Keep v2 inside rdx.

	;; Keep inside r8 and r9 the current position of v1 and v2.
	xor r8, r8
	xor r9, r9
	xor rcx, rcx 
	
mix_them_up:
	;; Check if we've reached the last position for each array.
	cmp rbx, r8
	je insert_second_array

	cmp rdi, r9
	je insert_first_array

	;; Check which value we put first in the new array.
	push rcx
	mov rcx, r8
	cmp rcx, r9
	pop rcx
	jg insert_second_array

insert_first_array:
	;; Insert a value from the first array inside the resulting array.
	push rbx
	push rcx
	mov rcx, r8
	xor rbx, rbx
	mov ebx, dword [rax+rcx*4]
	pop rcx
	mov dword [rsi+rcx*4], ebx
	pop rbx

	;; Keep mixing.
	inc r8
	inc rcx
	jmp mix_them_up

insert_second_array:
	;; Check again if we've reached the last position for the second array.
	cmp rdi, r9
	je stop_mixing

	;; Insert a value from the second array inside the resulting array.
	push rbx
	push rcx
	mov rcx, r9
	xor rbx, rbx
	mov ebx, dword [rdx+rcx*4]
	pop rcx
	mov dword [rsi+rcx*4], ebx
	pop rbx

	;; Keep mixing.
	inc r9
	inc rcx
	jmp mix_them_up

stop_mixing:
	pop rbx
	leave
	ret
