
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
