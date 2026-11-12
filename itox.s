.intel_syntax noprefix
.global _start

;# RDI, RSI, RDX, RCX, R8, R9

.text
	_start:
		mov rdi, 256
		push rdi

		lea rsi, [buf + 32]
		call _itoa

		mov rdi, rax
		call _print

		pop rdi
		lea rsi, [buf + 32]
		call _itob

		mov rdi, rax
		call _print

		call _exit

	_itoa:
		mov rdx, 10
		call _itox
		ret

	_itob:
		mov rdx, 2
		call _itox
		ret

	_itox:
		mov rax, rdi
		mov rbx, rdx
		mov rdi, rsi
		mov byte ptr [rdi], 0 ;# an immediate value is ambiguous so a size specifier is needed
		dec rdi
		mov byte ptr [rdi], 10 ;# add a newline char

		_itox_loop:
			xor rdx, rdx ;# clear rdx, it will contain the remainder when dividing
			dec rdi
			div rbx
			add rdx, '0' ;# convert to ascii byte
			mov [rdi], dl
			cmp rax, 0
			jne _itox_loop
			mov rax, rdi
			ret

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
	buf:
		.skip 1024 ;# skip allocates and initializes to 0

