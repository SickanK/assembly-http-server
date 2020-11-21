SECTION .data
get_str db 'GET', 0h
post_str db 'POST', 0h
put_str db 'PUT', 0h
delete_str db 'DELETE', 0h

; int compareResponse() ->
;   eax - 1 if equal, 0 if not
; Compare string with other null terminated

compareResponse:
    push ebx
    push esi
    mov esi, edx

.loop:
    mov al, byte [ecx]
    mov bl, byte [edx]

    inc ecx
    inc edx

    cmp al, bl
    je .loop

    cmp al, 0
    je .equal

    xor eax, eax
    mov eax, 0
    jmp .return

.equal:
    xor eax, eax
    mov eax, 1
    jmp .return

.return:
    mov edx, esi
    pop ebx
    pop esi
    ret

; int getRequestType() ->
;   eax - 0 to 4 what type of request
;     0 : Doesn't match, invalid
;     1 : GET
;     2 : POST 
;     3 : PUT
;     4 : DELETE
; Get and return what request type that's present

getRequestType:

    push ecx
    push edx
    mov edx, eax
    xor eax, eax

    mov ecx, get_str
    call compareResponse
    cmp eax, 1
    je .isGet

    mov ecx, post_str
    call compareResponse
    cmp eax, 1
    je .isPost
    
    
    mov ecx, put_str
    call compareResponse
    cmp eax, 1
    je .isPut
    
    
    mov ecx, delete_str
    call compareResponse
    cmp eax, 1
    je .isDelete

.isInvalid:
    mov eax, 0
    jmp .return

.isGet:
    mov eax, 1
    jmp .return

.isPost:
    mov eax, 2
    jmp .return

.isPut:
    mov eax, 3
    jmp .return

.isDelete:
    mov eax, 4
    jmp .return
    
.return:
    pop ecx
    pop edx
    ret

