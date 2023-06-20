%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here
    xor eax, eax
    xor ebx, ebx

l1:
    ;;Shift the characters that are inside the plain string.
    mov al, [esi+ebx]
    add eax, edx
    ;;Check if the characters are inside A-Z range.
    cmp al, 'Z'
    jg decval

back:
    ;;Insert the encrypted character.
    mov [edi+ebx], al
    inc ebx
    loop l1

decval:
    ;;Set the value of the character inside A-Z range.
    ;;Check if loop is done.
    cmp ecx, 0
    je exit
    sub al, 'Z'
    add al, 'A'-1
    jmp back

exit:
    ;;Exit.
    xor eax, eax
    xor ebx, ebx
    
    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
