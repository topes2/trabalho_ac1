convolution: # convolution(a0 - imagem .gray, a1- operador de Sobel, a2 - buffer para nova matriz)

	addi sp, sp, -36
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw s6, 24(sp)
	sw s7, 28(sp)
	sw ra, 32(sp)
	
	lw s0, side_size
	addi s7, s0, -1             #vai ser usado para parametro de comparação dos for's
	
	mv s4, a0
	mv s5, a1
	mv s6, a2
	
	
	li s1, 0 # i em array[i,j]																																																							
for_i: 
	
    
    li s2, 0 # j em array[i,j]
for_j:#{  dentro do nosso loop	
 		
 		li a0, 124
 	
 	if:	beqz s1, else       #
 		beqz s2, else       #
 		beq s7, s1, else	#if( s1 == 0 || s1 == limite do array  || s2 == 0 || s2 == limite do array )
 		beq s7, s2, else	# se for marguem damos store a 124 por default
 		
 		
 		mul s3, s0, s1 	    # efeito de i no movimento do array
 		add s3, s3, s2      #somamos o efeito de j no movimento do array
 		
 		add t1, s4, s3	    #byte em que vamos trabalhar
 		
 		mv a0, t1           #
 		mv a1, s5           #
 		jal sobel           # chamada da função sobel, em relação 
 	
else:   sb a0, 0(s6)
 		addi s6, s6, 1		
    
 		#}
 		
  		addi s2, s2, 1	  	# incrementação  de for_j	
  		blt s2, s0, for_j 	# condição de for_j
  		
  		
	addi s1, s1, 1		# incrementação  de for_i
    	blt s1, s0, for_i 	# condição de for_i
    	


	
		
    lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw s6, 24(sp)
	lw s7, 28(sp)
	lw ra, 32(sp)
	addi sp, sp, 36

	ret 
	
###############################
###############################
#################################
####################################

convolution: # convolution(a0 - imagem .gray, a1- operador de Sobel, a2 - buffer para nova matriz)

	addi sp, sp, -36
	sw s1, 0(sp)
	sw s2, 4(sp)
	sw s3, 8(sp)
	sw s4, 12(sp)
	sw s5, 16(sp)
	sw s6, 20(sp)
	sw s7, 24(sp)
	sw ra, 28(sp)
	sw s0, 32(s0)
	
	
	mv s4, a0
	mv s5, a1
	mv s6, a2
	
	lw s0, side_size
	addi s7, s0, -1 	#vai ser usado para parametro de comparação dos for's
	
	
	li s1, 0 # i em array[i,j]		
		 #inicializados em 1 porque a primira posiçao fora das margens é array[1,1]										
																																													
for_i: 
	li s2, 0 # j em array[i,j]
	
for_j:		#{  dentro do nosso loop	
 		
 		li a0, 124
 	
 	if:	beqz s1, condicao
 		beqz s2, condicao
 		beq s7, s1, condicao	#if( s1 == 0 || s1 == limite do array  || s2 == 0 || s2 == limite do array )
 		beq s7, s2, condicao	# se for marguem damos store a 124 por default
 		
 		
 		lw t6 , side_size
 		mul s3, t6, s1 	# efeito de i no movimento do array
 		add s3, s3, s2 #somamos o efeito de j no movimento do array
 		
 		add t1, s4, s3	# byte em que vamos trabalhar
 		
 		mv a0, t1
 		mv a1, s5
 		
 		jal sobel
 	
condicao: 	sb a0, 0(s6)
 		addi s6, s6, 1		
		
 		#}
 		
  		addi s2, s2, 1	  	# incrementação  de for_j	
  		blt s2, s0, for_j 	# condição de for_j
  		
  		
	addi s1, s1, 1		# incrementação  de for_i
    	blt s1, s0, for_i 	# condição de for_i
    	




    lw s1, 0(sp)
	lw s2, 4(sp)
	lw s3, 8(sp)
	lw s4, 12(sp)
	lw s5, 16(sp)
	lw s6, 20(sp)
	lw s7, 24(sp)
	lw ra, 28(sp)
	lw s0, 32(s0)
	addi sp, sp, 36

	ret 