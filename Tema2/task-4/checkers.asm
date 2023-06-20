
section .data

    ;; Array of possible moves.
    ;; 0 = upper left, 1 = upper right, 2 = lower left, 3 = lower right.
    neigh times 4 db 1

    ;; Arrays of positions for the possible moves, relative to the current position.
    movex dd 8, 8, -8, -8
    movey dd -1, 1, -1, 1

section .text
	global checkers

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

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
    jne puttheones
    mov byte [neigh+1], 0
    mov byte [neigh+3], 0

puttheones:
    ;; Inserting the ones in the matrix.
    lea edx, [ecx+edx]
    mov ecx, 4

l1:
    ;; Check if I can move to where [neigh] points.
    dec ecx
    cmp byte [neigh+ecx], 0
    je next

    ;; I can!
    ;; Compute the position of the next move.
    push edx
    xor eax, eax
    xor ebx, ebx
    mov eax, [movex+ecx*4]
    mov ebx, [movey+ecx*4]
    add eax, ebx
    add edx, eax
    
    ;; Insert one.
    mov byte [edx], 1
    pop edx

next:
    ;; Rebuild the neigh array.
    mov byte [neigh+ecx], 1
    cmp ecx, 0
    jg l1

    xor eax, eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY