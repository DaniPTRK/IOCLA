section .text
    global inorder_fixing

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

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
    enter 0, 0
    
    mov eax, [ebp+8]  ; node
    mov edx, [ebp+12] ; parent

check_left:
    ;; Check if there's a node on the left side.
    cmp dword [eax+node.left], 0
    je check_binary_tree

    ;; Call the function again, for the left node.
    pusha
    push eax
    push dword [eax+node.left]
    call inorder_fixing
    add esp, 8
    popa
    jmp check_right

check_binary_tree:
    ;; Check if the parent node is a binary tree.
    cmp edx, 0
    je get_out

    mov ecx, dword [eax+node.value]

    ;; Check if the node is on the left side of its parent.
    cmp dword [edx+node.left], 0
    je check_the_other_side

    push edx
    mov edx, dword [edx+node.left]
    cmp ecx, dword [edx]
    pop edx
    jne check_the_other_side

    ;; It is. Check if the node has a lower value.
    ;; If it doesn't, insert it.
    cmp ecx, dword [edx+node.value]
    mov ecx, -1
    jge change_values
    jmp check_right
    
check_the_other_side:
    ;; We're on the right side.
    ;; Check if the node has a greater value.
    cmp ecx, dword [edx+node.value]
    mov ecx, 1
    jle change_values
    jmp check_right

change_values:
    ;; Found an intruder. Change its value.
    push ebx
    mov ebx, dword [edx+node.value]
    add ebx, ecx
    mov dword [eax+node.value], ebx
    pop ebx

check_right:
    ;; Check if there's a node on the right side.
    cmp dword [eax+node.right], 0
    je get_out

    ;; Call the function again, for the right node.
    pusha
    push eax
    push dword [eax+node.right]
    call inorder_fixing
    add esp, 8
    popa

get_out:
    leave
    ret
