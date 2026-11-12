.intel_syntax noprefix
.global _start

.text
  _start:
    lea rdi, [buf]
    lea rsi, [buf_len - 1]
    call _readline

;#    call _memview

    lea rdi, [buf]
    lea rsi, [tokens]
    call _tokenize

    call _print_tokens

    ;#mov rdi, [rdi] ;# this will dereference itself
    call _exit

  _print_tokens:
    lea r15, [tokens]

    _pt.loop:
      mov rdi, [r15]
      cmp rdi, 0
      je _pt.end

      call _println
      add r15, 8
      jmp _pt.loop

    _pt.end:
      ret

  _print:
    call _strlen

    mov rdx, rax
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1
    syscall

    ret

  _println:
    call _strlen

    mov rdx, rax
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ret

  _strlen:
    xor rcx, rcx
    _strlen.loop:
      cmp byte ptr [rdi + rcx], 0
      je _strlen.end
      inc rcx
      jmp _strlen.loop
    _strlen.end:
      mov rax, rcx
      ret

  _readline:
    mov rdx, rsi
    mov rsi, rdi
    mov eax, 0
    mov edi, 0
    syscall
    mov byte ptr [rsi + rax], 0
    ret

  _memview:
    mov r11, rsp
    lea rsp, [buf]
    mov rsp, r11
    ret

  _tokenize:
    mov r15, rsi

    _t.loop:
      mov [r15], rdi
      add r15, 8 ;# 64-bit addresses (pointer)
;#      call _memview
      call _split
      cmp byte ptr [rdi], 0
      je _t.end
      mov byte ptr [rdi], 0
      inc rdi
      jmp _t.loop

    _t.end:
      ret

  _split:
    cmp byte ptr [rdi], ' '
    je _s.end

    cmp byte ptr [rdi], 0
    je _s.end

    inc rdi
    jmp _split

    _s.end:
      ret

  _exit:
    mov eax, 0x3c
    xor edi, edi
    syscall

.data
	buf:
		.skip 128
  buf_len = . - buf

  tokens:
    .skip 128

  newline:
  	.asciz "\n"

