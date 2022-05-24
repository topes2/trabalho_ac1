###############################
# Função: identifca_margem
# Descriçao: verifica se nos encontramos numa margem da imagem e altera a Matriz para calculo do sobel de acordo
# Arguentos:
# 	a0 - valor de i em Array[i,j]
#   a1 - valor de j em Arrayp[i,j]
#   a2 - Matriz para calculo do sobel, MatrizA
# Retorna: 
#	Void
##################################################################

identifca_margem:

	lw t2, side_size
	li t0, 0

India: 

	bnez a0, India0
		sb t0, 0(a2)	#|0|0|0|
		sb t0, 1(a2)	#|x|x|x|
		sb t0, 2(a2)	#|x|x|x|
India0: 
	bne a0, t2, Juliet 
		sb t0, 6(a2)	#|x|x|x|
		sb t0, 7(a2)	#|x|x|x|
		sb t0, 8(a2)	#|0|0|0|
	
Juliet:
	bnez a1, Juliet0
		sb t0, 0(a2)	#|0|x|x|
		sb t0, 3(a2)	#|0|x|x|
		sb t0, 6(a2)	#|0|x|x|
Juliet0:
	bne a1, t2, Romeo
		sb t0, 2(a2)	#|x|x|0|
		sb t0, 5(a2)	#|x|x|0|
		sb t0, 8(a2)	#|x|x|0|
		

Romeo: 
		ret
