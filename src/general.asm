; int slen(Sprint message)
; Calculate length of sring

slen:
    push ebx
    mov ebx, eax

.nextchar:
    cmp byte [eax], 0     
    je .finished
    inc eax
    jmp .nextchar

.finished:
    sub eax, ebx
    pop ebx
    ret

; void sprint(String message)
; Prints message 

sprint:
    push edx
    push ecx
    push ebx
    push eax
    call slen

    mov edx, eax 
    pop eax

    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 80h

    pop edx
    pop ecx
    pop ebx
    ret

; void sprintLF(String message)
; Prints message and a linefeed

sprintLF:
    call sprint

    push eax
    mov eax, 0Ah
    push eax
    mov eax, esp 
    call sprint

    pop eax
    pop eax
    ret

iprint:
    push eax
    push ecx
    push edx
    push esi
    mov ecx, 0

divideLoop:
    inc ecx
    mov edx, 0
    mov esi, 10
    idiv esi
    add edx, 48
    push edx
    cmp eax, 0
    jnz divideLoop

printLoop:
    dec ecx
    mov eax, esp
    call sprint
    pop eax
    cmp ecx, 0
    jnz printLoop

    pop esi
    pop edx
    pop ecx
    pop eax
    ret

iprintLF:
    call iprint

    push eax
    mov eax, 0Ah
    push eax
    mov eax, esp
    call sprint
    pop eax
    pop eax 
    ret

