.intel_syntax noprefix
.global _start

;# rdi, rsi, rdx, rcx, r8, r9

.text
  _start:
    mov rbp, rsp
    mov edi, 5
    call recurse
    call _exit

  recurse:
    push rbp
    mov rbp, rsp

    cmp edi, 0
    je recurse.end
    sub rsp, 16
    mov [rbp - 4], edi
    dec edi
    call recurse

    recurse.end:
      mov rsp, rbp
      pop rbp
      ret

  _exit:
    mov eax, 0x3c
    xor edi, edi
    syscall

