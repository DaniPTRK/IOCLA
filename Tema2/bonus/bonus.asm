section .data

    ;; Array of possible moves.
    ;; 0 = upper left, 1 = upper right, 2 = lower left, 3 = lower right
    neigh times 4 db 1

    ;; Arrays of positions for the possible moves, relative to the current position.
    movex db 8, 8, -8, -8
    movey db -1, 1, -1, 1

    ;; Array of actual positions for the possible moves.
    poz times 4 db 0

section .text
    global bonus

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    ;; Get the initial position.
    mov edx, eax
    imul edx, 8
    add edx, ebx

first_line:
    ;; Check if the checker is on the first line.
    cmp eax, 0
    jne last_line
    mov byte [neigh+2], 0
    mov byte [neigh+3], 0

last_line:
    ;; Check if the checker is on the last line.
    cmp eax, 7
    jne first_column
    mov byte [neigh], 0
    mov byte [neigh+1], 0

first_column:
    ;; Check if the checker is on the first column.
    cmp ebx, 0
    jne last_column
    mov byte [neigh], 0
    mov byte [neigh+2], 0

last_column:
    ;; Check if the checker is on the last column.
    cmp ebx, 7
    jne compute_pos
    mov byte [neigh+1], 0
    mov byte [neigh+3], 0

compute_pos:
    ;; Compute the positions.
    mov eax, ecx
    mov ecx, 4

l1:
    push ecx
    dec ecx

    ;;Find the actual position.
    mov bl, dl
    add bl, [movex+ecx]
    add bl, [movey+ecx]
    imul ebx, [neigh+ecx]

    ;;Place it inside the array
    mov [poz+ecx], bl
    pop ecx
    loop l1

    mov ecx, 4

l2:
    ;;Put the ones inside.
    push ecx
    dec ecx

    ;; Rebuild the neigh array.
    mov byte [neigh+ecx], 1

    ;; Check if I can make the move.
    cmp byte [poz+ecx], 0
    je next

    ;; Check in which number is the bit.
    mov edx, eax
    cmp byte [poz+ecx], 32
    jl secondnr

    ;; First number.
    sub byte [poz+ecx], 32
    jmp compute_nr

secondnr:
    ;; Second number.
    add edx, 4

compute_nr:
    mov ebx, 1
    mov cl, [poz+ecx]

    ;; Shift to the correct position.
    shl ebx, cl

    ;; Add the result to the position.
    add [edx], ebx

next:
    ;; Continue the loop.
    pop ecx
    dec ecx
    jnz l2

    xor eax, eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY