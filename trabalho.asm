.globl main
.data 

fileRGB:	.string "/home/topes1/Documents/trabalho/exemplo1.rgb"  #a string é a localização do ficheiro
fileGray:	.string "/home/topes1/Documents/trabalho/graytrees.gray" #a string é a localização futura do ficheiro .gray
FileFinal: 	.string "/home/topes/Documents/trabalho/lines.gray" # o ficheiro final do programa
buffer_rgb:	.space 30000 #o espaco reserved para a leitura do ficheiro de rgb
buffer_gray: 	.space 10000 #espaço reservado para o ficheiro .gray
buffer_gray_horizontal .space 10000 #espaço reservado para a aplicação de sobel horizontal
buffer_gray_vertical 	.space 10000 #espaço reservado para a aplicação de sobel vertical
buffer_final 	.space 10000 #espaço reservado para a forma final do ficheiro
SobelH: 	.word -1,0,1,-2,0,2,-1,0,1
SobelV:	
array_somatorio: .space 36 #array com espaço para 9 int
side_size: 	.word 100 # tamanho do lado, contante por isso fica em data
one:		.word 1 # constante que pode ser necessaria 
.text

main:

##############################################
#Fazemos load do adress da string que contem a localização do ficheiro .rgb,
#e do buffer onde vamos ter a imagem antes de a processar para a0 e a1 
#respetivamente
#O a2 é aqui declardo para a facil modificação do codigo para outros tamanhos
##############################################


	la a0,fileRGB
	la a1,buffer_rgb
	li a2,30000 
	jal read_rgb_image
	
	
##############################################
#Fazemos load do adress do buffer do rgb e do gray para podermos começar
#a processar a imagem para gray scale
##############################################


	la a0,buffer_rgb
	la a1, buffer_gray
	li a2, 30000
	jal rgb_to_gray	
	
	
##############################################
#função temporaria para fazer o ficheiro .gray para termos a certeza que esta
# a funcionar
##############################################	
	

	la a0, fileGray
	la a1, buffer_gray
	li a2, 10000
	jal write_gray_image	
	
	
##############################################
#Nós escolhemos implementer a convolution uma unica vez e usar como
#argumento os diferentes buffers e matrizes
##############################################


	la a0,buffer_gray
	la a1,buffer_gray_horizontal
	jal convolution
	
	la a0,buffer_gray
	la a1,buffer_gray_vertical
	jal convolution
	
	
##############################################	
#Função onde somamos ambas as matrizes com o sobel aplicado seja vertical
#ou horizontal e guardando no buffer_final
#
##############################################
	
	la a0,buffer_gray_horizontal
	la a1,buffer_gray_vertical
	la a2,buffer_final
	li a3,10000
	jal final_sum
	
	
##############################################
#The end the grand finale. Wow what a ride damn. Well jeez hope it works
#CPU's are just rocks we fooled into making math for us
##############################################

j end


#####################Funções#####################

		
read_rgb_image: ######### read_rgb_image (a0 - string; a1 - pointer buffer )

	addi sp, sp, -4	
	sw a1, 0(sp)	
	
	li a7, 1024         #
	li a1, 0              #abrir para ler
	ecall                 #
		
	lw a1, 0(sp)       #limpar a stack
	addi sp, sp, 4     #
	
	li a7, 63            	#ler 
	ecall                 #
	
	li a7, 57           #fechar o ficheiro
	ecall		      #

	ret	
		
			
rgb_to_gray: ############ rgb_to_gray (a0 - buffer rgb, a1 - buffer gray, a2 - tamanho)

	li t3, 30 # Red ratio
	li t4, 59 # Green ratio
	li t5, 11 # Blue ratio
	li t6, 100 #divisor
	
	
loop: #operacao rgb para gray I = 0.30R + 0.59G + 0.11B.

	lbu t0, 0(a0) #Red
	lbu t1, 1(a0) #Green
	lbu t2, 2(a0) #Blue
	
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
																																			
																								
write_gray_image: #### write_gray_image (a0 - string ,a1 - buffer gray, a2 - tamanho) 
	
	addi sp, sp, -8  
	sw a0,4(sp)      
	sw a1, 0(sp)     
	
	li a7, 1024    #
	li a1, 1         #open to write
	ecall 		   #
	
	 
	lw a1, 0(sp)	
	addi sp, sp, 4     
	
	li a7, 64       	#write	
	ecall 			#
	
	
	lw a0,0(sp)
	addi sp,sp,4
	
	li a7, 57		#close file
	ecall			#

	ret	
	

convolution: # convolution(a0 - imagem .gray, a1- operador de Sobel, a2 - buffer para nova matriz)

	lw s0, side_size
	addi t0, s0, -1 #vai ser usado para parametro de comparação dos for's
	
	
	li t1, 1 # i em array[i,j]		
		 #inicializados em 1 porque a primira posiçao fora das margens é array[1,1]										
																																												
for_i: 
	li t2, 1 # j em array[i,j]
	
for_j:		#{dentro do nosso loop	
 		
 		mul s1, s0, t1 # efeito de i no movimento do array
 		addi s1, s1, t2 #somamos o efeito de j no movimento do array
 		
 		li t4, 4 #para multiplicar o incidce de movimento pelos 4  bits
 		
 		mul s1, s1, t4 	#movimento a partir de a0 
 		add t3, a0, s1	#byte de byte em que vamos trabalho 
 		
 		
 		
 		
 
 		#}
  		addi t2, t2, 1
  		blt t2, t0, for_j
	addi t1, t1, 1
		
    	blt t1, t0, for_i 

final_sum:###final_sum(a0-buffer com o sobel horizontal;a1-buffer com o sobel vertical;a2-buffer final;a3-tamanho para criar) 
	addi sp,sp,4
	sw ra,0(sp)
	
	lbu t0, 0(a0) 
	lbu t1, 0(a1) 
	
	add t2,t2,t0
	add t2,t2,t1
	
	addi a0,a0,1
	addi a1,a1,1
	addi a2,a2,1
	addi a3,a3,-1
	
	bnez a3,final_sum
	
	#open to write
	
	li a7, 1024
	la a0, FileFinal
	li a1, 1
	ecall
	
	#write 
	
	li a7, 64
	la a1,buffer_final 
	li a2,10000	
	ecall 
	
	#close file
	
	lw a0,0(sp)
	addi sp,sp,4
	
	li a7, 57
	ecall	
							
								
											
																																																														
end:


sobel: 	#nem sei bem dizer o que isto faz, mas isto faz o que isto faz  
	#recebe um operador se sobel, e o bit que quermos trabalhar na matriz e retorna o resultado da convolution para o A[i,j]
	# (a0- byte de trabalho,  a1- sobel )
	
	la a2, array_somatorio
	#vamos percorrer os valores -1,0,1 para i e j 
	li t6, 1
	lw t5, side_size
	
	li t0, -1 # i de [i,j]
for_i2:
	li t1, -1 # j de [i,j]
for_j2:	
	#{dentro do nosso loop	
	
	mul t2 , t5, t0 # efeito de i no movimento do array
 	addi t2, t2, t1 #somamos o efeito de j no movimento do array
 		
 	li t4, 4 #para multiplicar o incidce de movimento pelos 4  bits
 		
 	mul t2, t2, t4 	#movimento a partir de a0 
 	add t2, a0, t2
 	
 	lw t2, 0(t2)
 	lw t3, 0(a1)
	 			
	mul t2, t2, t3
	
	sw t2, 0(a2)
	
	addi a2, a2, 1
	addi a1, a1, 1
	
	#}
	addi t1, t1, 1
	ble t1, t6, for_j2
	
	addi t0, t0, 1
	ble t0, t6, for_i2
 	
 	#fora do loop for
	
	la a0, array_somatorio
	li a1, 9
	jal soma_array
	
	
soma_array: #(a0 - array, a1- sz)

	li t0, 0
	
loop1: lw t1, 0(a0)
	add t0, t0, t1
	addi a1, a1, -1
	addi a0, a0, 1
	
	bgtz a0, loopl
	
	mv a0, t0
	ret

	
	
	
	
	
