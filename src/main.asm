%include 'general.asm'

SECTION .data
msg db 'Server has started', 0h
res db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 14', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello World!', 0Dh, 0Ah, 0h
len equ $ - res

SECTION .text
global _start

_start:

    xor eax, eax
    xor ebx, ebx
    xor edi, edi
    xor esi, esi
 
; int create() ->
;   eax - file descriptor
; Create a socket

_create:

   push byte 6
   push byte 1
   push byte 2
   mov ecx, esp
   mov ebx, 1
   mov eax, 102
   int 80h

; void bind()
; Bind socket to the ip address 0.0.0.0 and port 8080 

_bind:

    mov edi, eax
    push dword 0x0000000
    push word 0x901F
    push word 2
    mov ecx, esp
    push byte 16
    push ecx
    push edi
    mov ecx, esp
    mov ebx, 2
    mov eax, 102
    int 80h

; void listen()
; Listens for a connection

_listen:

    push byte 4
    push edi
    mov ecx, esp
    mov ebx, 4
    mov eax, 102
    int 80h

    push eax 
    mov eax, msg
    call sprint
    pop eax

; void accept()
; Accepts a socket connection

_accept:
    
    push byte 0
    push byte 0
    push edi 
    mov ecx, esp
    mov ebx, 5
    mov eax, 102
    int 80h

; void fork() ->
;   esi - file descriptor
; Forks process to allow more connections

_fork:
    mov esi, eax
    mov eax, 2
    int 80h
    
    cmp eax, 0
    je _write

    jmp _accept

; void write()
; Sends message to connection

_write:
    mov edx, len
    mov ecx, res
    mov ebx, esi
    mov eax, 4
    int 80h

_exit:

   mov ebx, 0
   mov eax, 1
   int 80h
