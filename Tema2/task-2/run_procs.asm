%include "../include/io.mac"

    ;;avg struct
struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xchg ebx, ecx
    xor edx, edx

stack_em:
    ;; Go through the array.
    push ecx
    imul ecx, proc_size
    lea ecx, [ebx+ecx-proc_size]

    ;; Increment the number of priorities [prio_result]
    ;; and pile up the time for each priority [time_result].  
    mov dl, [ecx+proc.prio]
    dec edx
    mov cx, [ecx+proc.time]
    add [time_result+4*edx], ecx
    inc dword [prio_result+4*edx]
    pop ecx
    loop stack_em

    mov ecx, 5
    xchg eax, ebx

compute_values:
    ;; Go through the arrays of priorities and time.
    xor eax, eax
    xor edx, edx
    push ecx
    dec ecx
    mov ax, [time_result+4*ecx]
    mov cx, [prio_result+4*ecx]
    cmp ecx, 0
    je back

    ;; Divide and transfer the values from register to struct.
    div ecx
    pop ecx
    push ecx
    dec ecx
    mov [ebx+4*ecx+avg.quo], ax
    mov [ebx+4*ecx+avg.remain], dx

back:
    ;; Continue the loop.
    pop ecx
    loop compute_values

    xor eax, eax
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY