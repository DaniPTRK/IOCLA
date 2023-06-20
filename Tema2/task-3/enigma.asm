%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain

    ;; Auxiliary array which will keep the rotated values.
    rotate_data times LETTERS_COUNT db 0

    ;; Array which contains the lines from config matrix in an order
    ;; that depicts the circuit that a letter has to follow in order
    ;; to be encrypted.
    encrypt_data dd 9, 4, 2, 0, 6, 1, 3, 5, 10

    ;; Array which indicates if the rotor is going to be rotated or not.
    ;; Position 0 = left rotor, Position 1 = middle rotor, Position 2 = right rotor.
    rotate_next_data db 0, 0, 0

section .text
    global rotate_x_positions
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward);
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY
    ;; TODO: Implement rotate_x_positions
    ;; FREESTYLE STARTS HERE

    xchg eax, ecx

    ;; Find the rotor.
    imul ebx, LETTERS_COUNT*2
    lea eax, [eax+ebx]
    mov ebx, ecx
    mov ecx, 2
    cmp edx, 0
    jg l0
    imul ebx, -1

l0:
    ;; Do the rotation twice, once for each line.

    push ecx
    mov ecx, LETTERS_COUNT

l1:
    ;; Start the rotation.
    push ecx
    dec ecx

    ;; Get the new position.
    xor edx, edx
    add edx, ecx
    add edx, ebx

    ;;Check if the position is in 0-25 range.
    cmp edx, 26
    jl checkifneg

    ;; Must decrease!
    sub edx, 26
    jmp continue

checkifneg:
    ;; Check if the new position is below 0.
    cmp edx, 0
    jge continue

    ;; Must increase!
    add edx, 26

continue:
    ;; Push the characters in the auxiliary array.
    mov cl, [eax+ecx]
    mov [rotate_data+edx], cl
    pop ecx
    loop l1

    mov ecx, 26

replace:
    ;; Move the auxiliary array inside the matrix.
    push ecx
    dec ecx
    mov dl, [rotate_data+ecx]
    mov [eax+ecx], dl
    pop ecx
    loop replace

    ;; Going on the next line.
    pop ecx
    add eax, LETTERS_COUNT
    loop l0

    xor eax,eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc);
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement enigma
    ;; FREESTYLE STARTS HERE

    mov esi, eax
    mov eax, ecx
    mov ecx, 0

convert_loop:
    ;; Encrypt the plain text.
    push eax
    mov al, [esi+ecx]
    mov [edi+ecx], al
    pop eax

    ;; Set [rotate_next_data+2] to 1.
    ;; The right rotor is rotating everytime.
    push ecx
    mov ecx, 2
    mov byte [rotate_next_data+ecx], 1

    check_rotations:
    ;; Check if the key is on the same position as the notch before the rotation.
    push ecx
    push edx
    xor edx, edx
    mov dl, [ebx+ecx]
    mov cl, [eax+ecx]
    cmp edx, ecx
    pop edx
    pop ecx
    jne no_new_rotation

    ;; It is on the same position. We must rotate both this rotor and the next one.
    ;; Set the values inside rotate_next_data to 1.
    mov byte [rotate_next_data+ecx], 1
    mov byte [rotate_next_data+ecx-1], 1

no_new_rotation:
    ;; No new rotation. Check for the next rotor.
    dec ecx
    cmp ecx, 1
    jge check_rotations

    mov ecx, 2
    
rotate_it:
    ;; Check if the rotor is going to rotate.
    cmp byte [rotate_next_data+ecx], 0
    je next_rotation

    ;; It will.
    ;; Rotate the selected rotor using rotate_x_positions().
    push 0
    push edx
    push ecx
    push 1
    call rotate_x_positions
    add esp, 16
    inc byte [ebx+ecx]
    mov byte [rotate_next_data+ecx], 0

next_rotation:
    ;; It won't rotate.
    ;; Move to the next one.
    dec ecx
    cmp ecx, 0
    jge rotate_it

    mov ecx, 3

check_range:
    ;; Check if the incremented values inside the key are in the A-Z range.
    push ecx
    dec ecx
    cmp byte [ebx+ecx], 'Z'
    jle continue_checking_range
    mov byte [ebx+ecx], 'A'

continue_checking_range:
    ;; Continue checking the key.
    pop ecx
    loop check_range

    ;; Get the letter meant to be encrypted.
    pop ecx
    push ecx
    push esi
    lea esi, [edi+ecx]
    push eax
    push ebx
    mov ecx, 0

search:
    ;; Search for the position of the letter on the rotors.
    push ecx
    mov ebx, LETTERS_COUNT
    imul ebx, [encrypt_data+ecx*4]
    mov ecx, LETTERS_COUNT-1

through_rotor:
    ;; Find the letter through the rotor.
    mov al, [edx+ebx]
    cmp al, [esi]
    je found_you
    inc ebx
    loop through_rotor

found_you:
    ;; Found the letter. Compute the position on the next rotor.
    mov eax, LETTERS_COUNT
    pop ecx
    imul eax, [encrypt_data+ecx*4]

    ;; Find the position of the found letter relative to the rotor.
    sub ebx, eax
    inc ecx
    mov eax, [encrypt_data+ecx*4]
    cmp ecx, 4
    jle continue_moves
    sub eax, 2

continue_moves:
    ;; Move the letter that's inside the next rotor.
    add eax, 1
    imul eax, LETTERS_COUNT
    add ebx, eax
    mov eax, [edx+ebx]
    mov [esi], eax

    ;; Continue the search.
    cmp ecx, 8
    jl search

    ;; Pop everything and continue the conversion.
    pop ebx
    pop eax
    pop esi
    pop ecx
    inc ecx
    cmp ecx, [len_plain]
    jl convert_loop

    ;; Add string terminator.
    mov byte [edi+ecx], 0

    xor eax, eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY