	.text
	.globl main

main:

	add x10, x0, 1987
	add x11, x0, 12

	add x20, x0, 12
	add x21, x0, 2014
	add x22, x0, 11
	
	sub x1, x20, x11
	sub x2, x21, x10
	mul x3, x2, x20 
	add x4, x1, x3	
	add x12, x4, x21
	
