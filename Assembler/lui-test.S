	.text
	.globl main

main:

	lui x1, 0x12345
	sll x2, x1, 20
	addi x3, x2, 0x678	
