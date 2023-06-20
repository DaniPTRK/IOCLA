extern array_idx_2      ;; int array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

struc node
    .value: resd 1
    .left: resd 1
    .right: resd 1
endstruc

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
    enter 0, 0
    
    push ebx

    mov eax, [ebp+8]  ; node
    mov ebx, [ebp+12] ; parent
    mov edx, [ebp+16] ; array

check_left:
    ;; Check if there's a node on the left side.
    cmp dword [eax+node.left], 0
    je check_binary_tree

    ;; Call the function again, for the left node.
    pusha
    push edx
    push eax
    push dword [eax+node.left]
    call inorder_intruders
    add esp, 12
    popa
    jmp check_right

check_binary_tree:
    ;; Check if the parent node is a binary tree.
    cmp ebx, 0
    je get_out

    mov ecx, dword [eax+node.value]

    ;; Check if the node is on the left side of its parent.
    cmp dword [ebx+node.left], 0
    je check_the_other_side

    push ebx
    mov ebx, dword [ebx+node.left]
    cmp ecx, dword [ebx+node.value]
    pop ebx
    jne check_the_other_side

    ;; It is. Check if the node has a lower value.
    ;; If it doesn't, insert it.
    cmp ecx, dword [ebx+node.value]
    jge insert_values
    jmp check_right
    
check_the_other_side:
    ;; We're on the right side.
    ;; Check if the node has a greater value.
    cmp ecx, dword [ebx+node.value]
    jle insert_values
    jmp check_right

insert_values:
    ;; Found an intruder. Insert it inside the array.
    push eax
    mov ecx, dword [array_idx_2]
    mov eax, dword [eax+node.value]
    mov [edx+ecx*4], eax
    inc dword [array_idx_2]
    pop eax

check_right:
    ;; Check if there's a node on the right side.
    cmp dword [eax+node.right], 0
    je get_out

    ;; Call the function again, for the right node.
    pusha
    push edx
    push eax
    push dword [eax+node.right]
    call inorder_intruders
    add esp, 12
    popa

get_out:
    pop ebx

    leave
    ret
