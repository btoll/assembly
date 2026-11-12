.intel_syntax noprefix
.global _start

.text
	_start:
		xor r13, r13
		mov r14, 1
		mov r15, 1
		mov ebx, 10 ;# this is the divider

	fib_loop:
		mov rax, r13
		push rax
		call write_to_buffer
		pop rax
		call convert_digit

		;# write current fib number
		mov eax, 1
		mov edi, 1
		mov rdx, r8
		syscall

		cmp r13, 0xE9 ;# 233
		je exit

		;# get next number in the sequence
		mov r13, r14
		mov r14, r15
		add r15, r13
		jmp fib_loop

	write_to_buffer:
		lea rsi, [rip + buffer + 32]
		mov byte ptr [rsi - 1], 10
		dec rsi
		mov r8, 1
		xor rax, rax
		ret

	convert_digit:
		xor edx, edx
		div rbx
		add dl, '0'
		dec rsi
		mov [rsi], dl
		inc r8
		test rax, rax
		jne convert_digit
		ret

	exit:
		mov eax, 60
		xor edi, edi
		syscall

.bss
	buffer:
		.zero 32

