.globl main
.data 

fileRGB:	.string "/home/topes1/Documents/trabalho/exemplo1.rgb"  #a string é a localização do ficheiro
fileGray:	.string "/home/topes1/Documents/trabalho/image1.gray" #a string é a localização futura do ficheiro .gray
buffer_rgb:	.space 30000 #o espaco reserved para a leitura do ficheiro de rgb
buffer_gray: 	.space 10000 #espaço reservado para o ficheiro .gray



.text


main:

	la a0, fileRGB #load do adress do string fileRGB
	la a1, buffer_rgb #load do adress do buffer que esta reservado
	jal read_rgb_image #ler a imagem rgb para o buffer respetivo

#Fazemos load do adress da string que contem a localização do ficheiro .rgb
# fazemos load do adress da string do buffer para onde ler o ficheiro em si
#saltamos para a read rgb que vai ler a imagem e por os seus dados dentro do buffer
#que foi reservado antes

	la a0,buffer_rgb
	la a1, buffer_gray
	li a2, 30720
	jal rgb_to_gray
	
#Fazemos load do adress do buffer do rgb
#fazemos load do adress do buffer do gray que vai estar vazio
# o a2 vai ser o valor total para ler do buffer de rgb esta aqui para ser mais facil e rapido modificar lo
	
	la a0, fileGray
	la a1, buffer_gray
	li a2, 10000
	jal write_gray_image
	
	j end



read_rgb_image: ######### read_rgb_image (a0 - string; a1 - pointer buffer )

	addi sp, sp, -4	# a1 para a stack (é o buffer)
	sw a1, 0(sp)	#vai ser utilizado na segunda parte da funcao
	
	#abrir para ler
	li a7, 1024
	li a1, 0
	ecall 
	
	#ler 
	li a7, 63
	
	lw a1, 0(sp) #retomar o valor de a1 que foi guardado na stack
	addi sp, sp, 4 #soltar o sp do sitio onde esta preso
	li a2,30000 
	ecall
	
	#fechar 
	li a7, 57
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
	
	
	
	addi sp, sp, -8
	sw a0,4(sp) 
	sw a1, 0(sp)
	 
	
	
	#open to write
	
	li a7, 1024
	li a1, 1
	ecall
	
	#write 
	
	li a7, 64 
	
	lw a1, 0(sp)
	addi sp, sp, 4
	
	ecall 
	
	#close file
	
	lw a0,0(sp)
	addi sp,sp,4
	
	li a7, 57
	ecall

	ret

		
sobel_horizontal:


		
end:
