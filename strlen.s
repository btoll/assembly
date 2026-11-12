.intel_syntax noprefix
.global _start

.text
    _start:
		lea rdi, [s2]
		call _print
		jmp _exit

	_print:
		push rdi ;# save rdi in case _strlen clobbers it
		call _strlen
		pop rsi

		;# write the string to stdout
		mov rdx, rax ;# move return value from _strlen into rdx
		mov rax, 1 ;# write syscall
		mov rdi, 1 ;# STDOUT
		syscall

		xor rax, rax
		ret

	_strlen:
		xor rcx, rcx

		_strlen_loop:
			mov bl, [rdi + rcx]
			cmp bl, 0
			je _strlen_exit
			inc rcx
			jmp _strlen_loop

		_strlen_exit:
			mov rax, rcx
			ret

    _exit:
        mov eax, 60     # 60 is the exit system call
        xor edi, edi    # status code 0
        syscall

.data
	s1:
		.asciz "Hello, world!\n"
	s2:
		.asciz "Goodbye, cruel world!\n"

