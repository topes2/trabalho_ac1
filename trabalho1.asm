.globl main
.data 

fileRGB:	.string "/home/that_guy/Desktop/arquitetura/trabalho/work.rgb"
fileGray:	.string "/home/that_guy/Desktop/arquitetura/trabalho/gray.gray"
buffer_rgb:	.space 1024
buffer_gray: 	.space 512



.text


main:

	la a0, fileRGB
	la a1, buffer_rgb
	jal read_rgb_image
	
	
	la a0, buffer_rgb
	la a1, buffer_gray
	li a2, 25
	jal rgb_to_gray
	
	la a0, fileGray
	la a1, buffer_gray
	li a2, 50
	jal write_gray_image
	
	j end

#################### read_rgb_image (a0 - string, a1 - pointer buffer )

read_rgb_image:	

	addi sp, sp, -4	# a0 para a stack
	sw a1, 0(sp)	#vai ser utilizado na segunda parte da funcao
	
	#abrir para ler
		
	li a7, 1024
	li a1, 0
	ecall 
	mv t0, a0	#a0 contem o file decriptor
	
	#ler 
	
	li a7, 63
	mv a0, t0
	lw a1, 0(sp)
	addi sp, sp, 4
	li a2, 1024 
	ecall
	
	#fechar 
	
	li a7, 57
	mv a0, t0 
	ecall

	ret

#################### rgb_to_gray (a0 - buffer rgb, a1 - buffer gray, a2 - tamanho)

rgb_to_gray: 

	li t3, 30 # Red ratio
	li t4, 59 # Green ratio
	li t5, 11 # Blue ratio
	li t6, 100 #divisor

loop:

	lbu t0, 0(a0) #Red
	lbu t1, 1(a0) #Green
	lbu t2, 2(a0) #Blue
	
	#operacao rgb para gray I = 0.30R + 0.59G + 0.11B.
	
	mul t0, t0, t3
	mul t1, t1, t4
	mul t2, t2, t5

	div t0, t0, t6
	div t1, t1, t6
	div t2, t2, t6
	
	add t0, t0, t1
	add t0, t0, t2
	
	sb t0, 0(a1)
	
	#incrementações no final do loop
	
	addi a0, a0, 3
	addi a1, a1, 1
	addi a2, a2,-1
	
	bnez a2, loop
	
	
	ret
	
#write_gray_image escreve uma imagem em formato GRAY num ficheiro. A função
#tem como parâmetros o nome de um ficheiro, um buffer com a imagem e o comprimento
#do buffer.

################################ write_gray_image (a0 - string ,a1 - buffer gray, a2 - tamanho) 


write_gray_image: 
	
	
	
	addi sp, sp, -4 
	sw a1, 0(sp) 
	
	
	#open to write
	
	li a7, 1024
	li a1, 1
	ecall
	mv s0 , a0
	
	#write 
	
	li a7, 64 
	
	lw a1, 0(sp)
	addi sp, sp, 4
	ecall 
	
	#close file
	
	li a7, 57
	mv a0, s0 
	ecall

	ret
		
end:
