.global _start

.section .data
    message: .asciz "hello asshole\n"

.section .text
_start:
    # write syscall
    mov $1, %rax        # syscall: write
    mov $1, %rdi        # file descriptor: stdout
    lea message(%rip), %rsi  # pointer to message
    mov $14, %rdx       # length of string (13 chars + newline)
    syscall

    # exit syscall
    mov $60, %rax       # syscall: exit
    mov $0, %rdi        # exit code 0
    syscall

