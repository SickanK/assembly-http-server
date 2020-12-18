SECTION .data
get_str db 'GET', 0h
head_str db 'HEAD', 0h
post_str db 'POST', 0h
put_str db 'PUT', 0h
delete_str db 'DELETE', 0h
options_str db 'OPTIONS', 0h

; int compareResponse() ->
;   eax - 1 if equal, 0 if not
; Compare string with other null terminated

compareResponse:
    push ebx
    push esi
    mov esi, edx

.responseLoop:
    mov al, byte [ecx]
    mov bl, byte [edx]

    inc ecx
    inc edx

    cmp al, bl
    je .responseLoop

    cmp al, 0h
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
;     2 : HEAD
;     3 : POST 
;     4 : PUT
;     5 : DELETE
;     6 : OPTIONS
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

    mov ecx, head_str
    call compareResponse
    cmp eax, 1
    je .isHead

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

    mov ecx, options_str
    call compareResponse
    cmp eax, 1
    je .isOptions


.isInvalid:
    mov eax, 0
    jmp .return

.isGet:
    mov eax, 1
    jmp .return

.isHead:
    mov eax, 2
    jmp .return

.isPost:
    mov eax, 3
    jmp .return

.isPut:
    mov eax, 4
    jmp .return

.isDelete:
    mov eax, 5
    jmp .return

.isOptions:
    mov eax, 6
    jmp .return
    
.return:
    pop ecx
    pop edx
    ret

; string getResource() ->
; eax - message
; Return resource

getResource:
    push ebx
    push edx
    xor ebx, ebx
    xor ecx, ecx
    mov edx, eax

.resourceLoop1:
    mov bl, byte [eax]

    cmp bl, 2Fh
    je .resourceLoop2

    inc eax

    jmp .resourceLoop1

.resourceLoop2:
    mov bl, byte [eax]

    cmp bl, 20h
    je .return

    inc eax
    inc ecx

    jmp .resourceLoop2

.return:
    mov byte [eax], 0h
    sub eax, ecx
    pop ebx 
    pop edx 
    ret

; string getVersion() ->
; eax - message
; Return versio

getVersion:
    push ebx
    push edx
    push esi
    xor esi, esi
    xor ebx, ebx
    xor ecx, ecx
    mov edx, eax
    jmp .versionLoop1

.incrementSpace:
    inc esi

.versionLoop1:
    
    cmp esi, 2
    je .versionLoop2

    mov bl, byte [eax]
    inc eax

    cmp bl, 20h
    je .incrementSpace

    jmp .versionLoop1

.versionLoop2:
    mov bl, byte [eax]

    cmp bl, 0Dh
    je .return

    inc eax
    inc ecx

    jmp .versionLoop2

.return:
    mov byte [eax], 0h
    sub eax, ecx
    pop ebx 
    pop edx 
    pop esi 
    ret

; string getBody() ->
; eax - body
; Return body from POST or PUT request

getBody:
    push ebx
    xor ebx, ebx

.msgLoop:
    mov bl, byte [eax]

    inc eax

    cmp bl, 0Ah
    je .equal

    jmp .msgLoop

.equal:
    inc eax
    mov bl, byte [eax]

    cmp bl, 0Ah
    jne .msgLoop

    inc eax

    jmp .return

.return:
    pop ebx 
    ret


;string getHeaders() ->
;stack - headers
;Return headers

getHeaders:
    push ebx
    push ecx
    push edx

    ; holds bytes of eax
    xor ebx, ebx
    xor edx, edx

.charLoop1:
    mov bl, byte[eax]
    inc eax 
    inc edx

    cmp bl, 0Ah
    je .printResult

    jmp .charLoop1

.printResult:
    push eax
    sub eax, 2
    mov bl, byte[eax]
    mov eax, ebx
    call iprintLF
    pop eax

    mov byte [eax], 0h

    inc eax
    inc edx
    mov bl, byte[eax]

    cmp bl, 0Ah
    je .return

    jmp .charLoop1

.return:
    sub eax, edx
    call sprintLF

    pop ebx
    pop ecx
    pop edx
    ret
