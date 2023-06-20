extern array_idx_1      ;; int array_idx_1

section .text
    global inorder_parc

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

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
    enter 0, 0
    
    mov eax, [ebp+8]  ; node
    mov edx, [ebp+12] ; array

check_left:
    ;; Check if there's a node on the left side.
    cmp dword [eax+node.left], 0
    je insert_values

    ;; Call the function again, for the left node.
    pusha
    push edx
    push dword [eax+node.left]
    call inorder_parc
    add esp, 8
    popa

insert_values:
    ;; Put the value inside the array.
    push eax
    mov ecx, dword [array_idx_1]
    mov eax, dword [eax+node.value]
    mov [edx+ecx*4], eax
    inc dword [array_idx_1]
    pop eax

check_right:
    ;; Check if there's a node on the right side.
    cmp dword [eax+node.right], 0
    je get_out

    ;; Call the function again, for the right node.
    pusha
    push edx
    push dword [eax+node.right]
    call inorder_parc
    add esp, 8
    popa

get_out:
    leave
    ret
