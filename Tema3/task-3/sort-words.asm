global get_words
global compare_func
global sort

section .data
    ;; String used for delimitations.
    delim dd "., ", 0

    ;; Auxiliary values used in order to obtain the 
    ;; return value of compare_func.
    val_a dd 0
    val_b dd 0

section .text

    extern qsort
    extern strlen
    extern strcmp
    extern strtok

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografic
sort:
    enter 0, 0

    mov esi, [ebp+8]  ; words
    mov eax, [ebp+12] ; number_of_words
    mov edx, [ebp+16] ; size

    ;; Compare each word by length and lexicographically.
    pusha
    push compare_func
    push edx
    push eax
    push esi
    call qsort
    add esp, 16
    popa

    leave
    ret

;; int (*compar)(const void *, const void *)
;  Compare function for qsort. Comparing lexicographically while checking lengths.
compare_func:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp+8]  ; first value
    mov edx, [ebp+12] ; second value

    ;; Check if the strings that we're comparing have the same length.
    ;; If they don't, keep the comparison value.
    
    ;; Get the length for the first string.
    pusha
    push dword [ecx]
    call strlen
    add esp, 4
    mov dword [val_a], eax
    popa

    ;; Get the length for the second string.
    pusha
    push dword [edx]
    call strlen
    add esp, 4
    mov dword [val_b], eax
    popa

    ;; Obtain the result.
    mov eax, dword [val_a]
    sub eax, dword [val_b]
    cmp eax, 0
    
    jne keep_comparison

    ;; ... they do have the same length.
    ;; Compare lexicographically using strcmp.
    pusha
    push dword [edx]
    push dword [ecx]
    call strcmp
    mov dword [val_a], eax
    add esp, 8
    popa
    mov eax, dword [val_a]

keep_comparison:
    ;; Keep the comparison value.

    pop ebp
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov edi, [ebp+8]  ; s
    mov esi, [ebp+12] ; words
    mov edx, [ebp+16] ; number_of_words

    xor ecx, ecx

take_the_token:
    ;; Get the word from the input text and put it inside the words array.
    push edx
    push ecx
    push delim
    push edi
    call strtok
    add esp, 8
    pop ecx
    pop edx
    mov [esi+4*ecx], eax

    ;; Get the other words.
    xor edi, edi
    inc ecx
    cmp ecx, edx
    jl take_the_token

    leave
    ret
