
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
