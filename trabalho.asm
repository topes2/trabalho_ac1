.globl main
.data 

fileRGB:	.string "/home/that_guy/Desktop/trabalho_ac1/lena/lena.rgb"  #a string é a localização do ficheiro
fileGray:	.string "/home/that_guy/Desktop/trabalho_ac1/lena/teste.gray" #a string é a localização futura do ficheiro .gray
FileFinal: 	.string "/home/that_guy/Desktop/trabalho_ac1/lena/final.gray" # o ficheiro final do programa
buffer_rgb:	.space 786432 #o espaço reserved para a leitura do ficheiro de rgb
buffer_gray: 	.space 262144 #espaço reservado para o ficheiro .gray
		

buffer_gray_horizontal: .space 262144	#espaço reservado para a aplicação de sobel horizontal
buffer_gray_vertical: 	.space 262144 	#espaço reservado para a aplicação de sobel vertical
buffer_final: 	.space 262144  	#espaço reservado para a forma final do ficheiro


SobelH: 	.word -1,0,1,-2,0,2,-1,0,1
SobelV:		.word -1,-2,-1,0,0,0,1,2,1


array_somatorio: .space 36 #array com espaço para 9 int
side_size: 	.word 512 # tamanho do lado, contante por isso fica em data
matriz_A: .space 9 # array para 9 bytes

.text		

main:

##############################################
#Fazemos load do adrress da string que contem a localização do ficheiro .rgb,
#e do buffer onde vamos ter a imagem antes de a processar para a0 e a1 
#respetivamente
#O a2 é aqui declardo para a facil modificação do codigo para outros tamanhos
##############################################


	la a0,fileRGB
	la a1,buffer_rgb
	li a2,786432 
	jal read_rgb_image
	
	
##############################################
#Fazemos load do adress do buffer do rgb e do gray para podermos começar
#a processar a imagem para gray scale
##############################################


	la a0,buffer_rgb
	la a1, buffer_gray
	li a2, 262144
	jal rgb_to_gray	
	
	
##############################################
#função que cria o ficheiro .gray sem qualquer outra
#alteração ou modificação
##############################################	
	

	la a0, fileGray
	la a1, buffer_gray
	li a2, 262144
	jal write_gray_image	
	
	
##############################################
#Nós escolhemos implementer a convolution uma unica vez e usar como
#argumento os diferentes buffers e matrizes
##############################################

	la a0 , buffer_gray
	la a1, SobelH
	la a2, buffer_gray_horizontal
	jal convolution 
	
	la a0 , buffer_gray
	la a1, SobelV
	la a2, buffer_gray_vertical
	jal convolution
	
##############################################	
#Função onde somamos ambas as matrizes com o sobel aplicado seja vertical
#ou horizontal e guardando no buffer_final
##############################################
	
	la a0, buffer_gray_horizontal
	la a1, buffer_gray_vertical
	la a2, buffer_final
	li a3, 262144
	jal contour
	
	
##############################################
#The end the grand finale. Wow what a ride damn. Well jeez hope it works
#CPU's are just rocks we fooled into making math for us
##############################################
	
	la a0, FileFinal
	la a1, buffer_final
	li a2, 262144
	jal write_gray_image 

j End 


#####################Funções#####################


############################################
# Função: read_rgb_image
# Descrição: Esta função lê um ficheiro de formato .rgb para um buffer pré-alocado 
# Argumentos:
#	a0 - string com o caminho para o fichero 
#	a1 - pointer para o buffer de destino
#	a2 - tamanho do buffer 
# Retorna: 
#	Void
############################################
read_rgb_image: 

	addi sp, sp, -4
	sw s0, 0(sp)

	mv t0, a1	

	li a7, 1024          #abrir para ler
	li a1, 0             #
	ecall                #

	mv s0, a0			 #guardar o file descriptor no s0		


	li a7, 63            #ler 
	# mv a0, s0			 # instrução redundante, o valor do a0 não foi alterado
	mv a1, t0			 #	
	# mv a2, a2		     # instrução redundante, já temos a informação nesseçaria no a2
	ecall                #


	li a7, 57           #fechar o ficheiro
	mv a0, s0			#
	ecall		    	#


	lw s0, 0(sp)
	addi sp, sp, 4

	ret	
		
######################################
# Função: rgb_to_gray
# Descrição: converte uma imagem no formato .rgb para uma imagem .gray e coloca o resultado num array
# Argumentos: 
# 	a0 - pointer para buffer com a imagem RGB
#	a1 - pointer para buffer de destino
#	a2 - tamanho da imagem l*l (Ex: imagem 5x5 -> tamanho 25)	 
# Retorna
#	Void
##############################################################

rgb_to_gray:

	li t3, 30 # Red ratio
	li t4, 59 # Green ratio
	li t5, 11 # Blue ratio
	li t6, 100 #divisor
	
	
loop0: ############### operacao rgb para gray I = 0.30R + 0.59G + 0.11B.

	lbu t0, 0(a0) #Red
	lbu t1, 1(a0) #Green
	lbu t2, 2(a0) #Blue
	
	mul t0, t0, t3	
	mul t1, t1, t4
	mul t2, t2, t5

	add t0, t0, t1
	add t0, t0, t2
	
	div t0, t0, t6

	sb t0, 0(a1)
	
	#incrementações no final do loop0
	
	addi a0, a0, 3
	addi a1, a1, 1
	addi a2, a2,-1
	
	bnez a2, loop0
	
	ret				
																																			
##################################
# Função: write_gray_image
# Descrição: escreve uma imagem em formato .gray num ficheiro
# Argumentos: 
# 	a0 - string com o nome do ficheiro a criar 
#	a1 - ponteiro para o buffer com a imagem
#	a2 - tamanho do buffer
# Retorna: 
#	Void
###################################
write_gray_image: 
	

	addi sp, sp, -4
	sw s0, 0(sp)



	mv t0, a1
	
	li a7, 1024         #open to write
	li a1, 1            #
	ecall 		   		#

	mv s0, a0			#guardar o file descriptor no t1
	 

	li a7, 64       	# write
	# mv a0, s0			# instrução redundante, o valor do a0 não foi alterado
	mv a1, t0			#
	# mv a2, a2			# instrução redundante, já temos a informação nesseçaria no a2	
	ecall 				#
	

	li a7, 57			#close file
	mv a0, s0			#
	ecall				#



	lw s0, 0(sp)
	addi sp, sp, 4

	ret	

#############################################
# Função: convolution 
# Descrição: calcula a convolução de uma imagem A com um operador Sobel (matriz 3×3) e coloca o resultado numa matriz B
# Argumentos: 
#	a0 - pointer para buffer com imagem em formato GRAY
#	a1 - array com operador de Sobel
#	a2 - Buffer da matriz "B"
# Retorna: 
#	Void
#################################################

convolution: 

	addi sp, sp, -24
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw ra, 20(sp)
	
	lw s0, side_size
	mul s0, s0, s0		# tamanho em bits da imagem
	 
	
	mv s2, a0
	mv s3, a1
	mv s4, a2
	
    	li s1, 0 # j em array[i,j]
	for_j:#for (j = 0 ; j < tamanho; j++){ 
 		
	 		
 			add t1, s2, s1    #byte em que vamos trabalhar					

			mv a0, t1			#
			la a1, matriz_A		#	
			jal n_matriz		# crimanos uma matriz 3*3 com os valores que rodeam o bit de trabalho

			mv a0, s1			  #	
			la a1, matriz_A		  #	
			jal identifca_margem  # verifica se nos encontramos numa margem

	 		la a0, matriz_A     #
	 		mv a1, s3           #
	 		jal sobel           # chamada da função sobel

		    sb a0, 0(s4)
 			addi s4, s4, 1		
    
 		#}
 		
  		addi s1, s1, 1	  	# incrementação  de for_j	
  		blt s1, s0, for_j 	# condição de for_j
  		
		
    lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw ra, 20(sp)	
	addi sp, sp, 24

	ret 


###############################################
# Função: contour 
# Descrição: Calcula a imagem final combinando as duas imagens convolvidas e coloca o resultado num buffer pré-alocado
# Argumentos: 
#	a0 - string com convolução a partir de Sobel horizontal
#	a1 - string com convolução a partir de Sobel horizontal	
# 	a2 - buffer para produto final
#	a3 - tamanho da imagem a criar 
# Retorna:
#	Void
###############################################
contour:
	
		li t6, 255
							# primeira parte: fazer as operações com as Imagens resultantes dos filtros sobel para obter a imagem Final 
loop1:	lbu t0, 0(a0) 		#		
		lbu t1, 0(a1) 		# load dos bits de SobelH e SobelV
	
		add t2, t0, t1		# 
		srli t2, t2, 1		# t2/2 
		sub t2, t6, t2		# 255 - t2	
		sb t2, 0(a2)		# store resultado na nova matriz
	
		addi a0,a0,1		#	
		addi a1,a1,1		#
		addi a2,a2,1		#
		addi a3,a3,-1		# incrementações de final de loop 
	
		bnez a3,loop1

		ret



##################################################
# Função: sobel
# Descrição: Aplica a convolução a partir de duas matrizes A e B para um unico bit
# Argumentos: 
#	a0 - Matriz 9*9 para fazer a convulition com o Sobel
#	a1 - matriz de Sobel
# Retorna:
# 	a0 - valor da convolução
###############################################
sobel:
	
	addi sp, sp ,-4
	sw ra, 0(sp)
	
	la a2, array_somatorio
	lw t5, side_size
	
	#
	# primeira parte: aplocamos a convulução em relação ao bit que recebemos sem fazer o somatorio
	#				  guarda apena cada um dos 9 valores num array 	



		li t0, 9 # i de [i,j]
for_i2: #for( i = 9 ; i > 0 ; i--){
		

 		lbu t2, 0(a0)		#retiramos o valor do bit para t2 
 		lw t3, 0(a1)		#retiramos o valor da matriz de Sobel para t3
	 			
		mul t2, t2, t3		
	
		sw t2, 0(a2)		#guardamos o valor no array_somatorio

		addi a2, a2, 4		#avançamos no array_somatorio
		addi a1, a1, 4		#avançamos na matriz de Sobel
		addi a0, a0, 1      #avançamos na matriz_A

		
	addi t0, t0, -1
	bgtz t0, for_i2


	#
	# segunda parte: usamos a função modulo_soma para obter o valor absoluto do somatório do array_somatorio
	#


	la a0, array_somatorio
	li a1, 9
	jal modulo_soma
	
	lw ra, 0(sp)
	addi sp, sp, 4
		
	ret
	
############################################
# Função: modulo_soma
# Descrição: retorna o módulo da soma de um array de inteiros
# Argumentos: 
#	a0 - array
#	a1 - tamanho
# Retorna:
#	a0 - módulo da soma 
###########################################
modulo_soma: 

	li t0, 0 
	
loop2:  

	lw t1, 0(a0) 		# primeira parte: soma todos o valores do array
	add t0, t0, t1		#
						#
	addi a1, a1, -1		#
	addi a0, a0, 4		#
						#
	bgtz a1, loop2      #
	
	bgez t0, R         	# segunda parte: obtemos o valor absoluto da soma
		not t0,t0		#
		addi t0,t0,1  	# 
		
R:	mv a0, t0
	ret

																																																														
#################################
# Função: n_matriz
# Descrição: cria uma matriz para ser trabalhada pela função sobel
# 	a0 - byte em que vamos trabalhar 
# 	a1 - novo array 
# Retorna:
#	void
###############################################

n_matriz:

	####criar a nova matriz
	lw t0, side_size

	li t6, 1 # parametro de comparação

		li t0, -1 # i de [i,j]
for_i3: #for( i = -1 ; i <= 1 ; i++){

		li t1, -1 # j de [i,j]
for_j3:	#for( j = -1 ; j <= 1 ; j++){
		

		mul t2 , t5, t0 	# efeito de i no movimento do array
 		add t2, t2, t1 		#somamos o efeito de j no movimento do array
 		 
 		add t2, a0, t2		#bite em que vamos trabalhar
 	
 		lbu t2, 0(t2)		#retiramos o valor do bit para t2 
 		
		sb t2, 0(a1)

		addi a1, a1, 1

		#}
		addi t1, t1, 1
		ble t1, t6, for_j3
	#}
	addi t0, t0, 1
	ble t0, t6, for_i3


	ret


###############################
# Função: identifca_margem
# Descriçao: verifica se nos encontramos numa margem da imagem e altera a Matriz para calculo do sobel de acordo
# Arguentos:
# 	a0 - deslocamento em relação ao inicio do buffer
#   a1 - Matriz para calculo do sobel, MatrizA
# Retorna: 
#	Void
##################################################################

identifca_margem:

	lw t6, side_size
	addi t6, t6, -1
	lbu t2, 4(a1)

	# vamos passar o valor absoluto do deslicamento para o deslocamento em matriz
	# em imagem 512*512 um deslocamnto de 515 bits = A[1,3]

	divu t0, a0, t6 # valor de i em A[i,j]

	mul t1, t0, t6
	sub t1, , a0, t1  # valor de j em A[i,j]

India: 

	bnez t0, India0
		sb t2, 0(a1)	#|0|0|0|
		sb t2, 1(a1)	#|x|x|x|
		sb t2, 2(a1)	#|x|x|x|
India0: 
	bne t0, t6, Juliet 
		sb t2, 6(a1)	#|x|x|x|
		sb t2, 7(a1)	#|x|x|x|
		sb t2, 8(a1)	#|0|0|0|
	
Juliet:
	bnez t1, Juliet2
		sb t2, 0(a1)	#|0|x|x|
		sb t2, 3(a1)	#|0|x|x|
		sb t2, 6(a1)	#|0|x|x|
Juliet2:
	bne t1, t6, Romeo
		sb t2, 2(a1)	#|x|x|0|
		sb t2, 5(a1)	#|x|x|0|
		sb t2, 8(a1)	#|x|x|0|
		

Romeo: 
		ret

End:
