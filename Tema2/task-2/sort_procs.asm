%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here

    mov ecx, eax
    xor eax, eax
    xor ebx, ebx

    ;; Go through the array.
l1:
    ;; Pick one.
    push ecx
    imul ecx, proc_size
    lea eax, [edx+ecx-proc_size]
    pop ecx
    push ecx

l2:
    ;; Compare with the rest...
    ;;... by priority.
    push ecx
    imul ecx, proc_size
    lea ebx, [edx+ecx-proc_size]
    mov cl, [ebx+proc.prio]
    cmp cl, byte [eax+proc.prio]
    jg swap
    jl back2

    ;;... by time.
    mov cx, [ebx+proc.time]
    cmp cx, word [eax+proc.time]
    jg swap
    jl back2

    ;;... by pid.
    mov cx, [ebx+proc.pid]
    cmp cx, word [eax+proc.pid]
    jg swap
    jl back2

back2:
    ;; Back to the second loop.
    pop ecx
    loop l2

back:
    ;; Back to the first loop.
    pop ecx
    loop l1
    jmp exit

swap:
    ;; Swap the elements.
    mov ecx, [ebx]
    xchg ecx, [eax]
    mov [ebx], ecx
    jmp back2
    
exit:
    xor eax, eax
    
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY