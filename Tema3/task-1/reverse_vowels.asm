section .data
	; declare global vars here

	;; String of vowels.
	vowels dd "aeiou", 0

	;; Auxiliary which keeps the closest value to the array.
	closest_value dd -1

section .text
	global reverse_vowels

	extern strchr

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp
	push esp
	pop ebp
	
	;; Get the string.
	push dword [ebp+8]
	pop esi

	;; Keep a value which indicates what happens when searching for vowels:
	;; 1 = put the values inside the string.
	;; 0 = keep the values inside the stack.
	xor edx, edx
	
prepare_for_inversion:
	;; Prepare for loop.
	push esi
	pop edi
	xor ecx, ecx

search_for_vowels:
	;; Go through the array char by char.
	xor eax, eax
	push ecx
	xor ecx, ecx

look_for_vowels:
	;; Find the next vowel using strchr.
	push edx
	push ecx
	push dword [vowels+ecx]
	push edi
	call strchr
	add esp, 8
	pop ecx
	pop edx

	;; Check if the found value is closer to the start.
	cmp eax, 0
	je continue_looking
	sub eax, edi

	;; Initialize the value if it's still -1.
	cmp dword [closest_value], -1
	je set_closest_value

	;; Is it closer?
	cmp eax, dword [closest_value]
	jg continue_looking

set_closest_value:
	;; Set the new closest value.
	push eax
	pop dword [closest_value]

continue_looking:
	;; Keep on looking for vowels.
	inc ecx
	cmp ecx, 5
	jl look_for_vowels

check_closest_value:
	;; Check if the closest value has been found.
	pop ecx
	cmp dword [closest_value], -1
	je redo_it

	;; Found it. Move the pointer towards the vowel.
	add ecx, [closest_value]
	add edi, [closest_value]

	;; Check what we must do next.
	cmp edx, 0
	je save_the_value

	;; We must change the value.
	xor edx, edx
	xor eax, eax

	;; Pop the kept value.
	;; Compute the difference between the 2 vowels.
	pop edx
	push dword [edi]
	pop eax
	sub dl, al

	;; Add the difference to the actual vowel.
	add byte [esi+ecx], dl
	push 1
	pop edx
	jmp continue_the_search

save_the_value:
	;; Keep the value inside the stack.
	push dword [edi]

continue_the_search:
	;; Continue going through the array.
	inc edi
	inc ecx

	;; Set closest value back to -1.
	push -1
	pop dword [closest_value]

	cmp byte [edi], 0
	jne search_for_vowels

redo_it:
	;; Check if we must do the whole process again.
	inc edx
	cmp edx, 1
	je prepare_for_inversion

	;; Leave.
	xor eax, eax
	pop ebp
	ret