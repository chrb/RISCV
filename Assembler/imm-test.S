	.text
	.globl main

main:

	addi x1, x0, -1
	addi x2, x0, 0x555
	sll x3, x2, 12 
	addi x4, x3, 0x555 
	sll x5, x4, 8 
	addi x3, x5, 0x55	
	xor x10, x1, x3
	addi x30, x10, 0x56	
