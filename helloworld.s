.intel_syntax noprefix
.global _start

.text
	_start:
		jmp print

		exit:
			mov eax, 60     # 60 is the exit system call
			xor edi, edi    # status code 0
			syscall

		print:
			mov eax, 1
			mov edi, 1
			lea esi, [helloworld]
			lea edx, [helloworld_len]
			syscall
			jmp exit

.data
;#	helloworld: .byte 'H', 'e', 'l', 'l', 'o'
	helloworld: .ascii "Hello, world!\n"
	helloworld_len = . - helloworld

