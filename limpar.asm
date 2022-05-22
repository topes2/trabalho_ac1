sobel: 	#recebe um operador se sobel, e o bit que quermos trabalhar na matriz e retorna o resultado da convolution para o A[i,j]
	# (a0- byte de trabalho,  a1- sobel )
	
	addi sp, sp ,-4
	sw ra, 0(sp)
	
	la a2, array_somatorio
	lw t5, side_size
	li t6, 1
	

	#
	# primeira parte: aplocamos a convulução em relação ao bit que recebemos sem fazer o somatorio
	#				  guarda apena cada um dos 9 valores num array 	



		li t0, -1 # i de [i,j]
for_i2: #for( i = -1 ; i <= 1 ; i++){

		li t1, -1 # j de [i,j]
for_j2:	#for( j = -1 ; j <= 1 ; j++){
		
	
		mul t2 , t5, t0 	# efeito de i no movimento do array
 		add t2, t2, t1 		#somamos o efeito de j no movimento do array
 		 
 		add t2, a0, t2		#bite em que vamos trabalhar
 	
 		lbu t2, 0(t2)		#retiramos o valor do bit para t2 
 		lw t3, 0(a1)		#retiramos o valor da matriz de Sobel para t3
	 			
		mul t2, t2, t3		
	
		sw t2, 0(a2)		#guardamos o valor no array_somatorio
	
		addi a2, a2, 4		#avançamos no array_somatorio
		addi a1, a1, 4		#avançamos na matriz de Sobel
	

		#}
		addi t1, t1, 1
		ble t1, t6, for_j2
	#}
	addi t0, t0, 1
	ble t0, t6, for_i2


	#
	# segunda parte: usamos a função soma_array para obter o valor absoluto do somatório do array_somatorio
	#


	la a0, array_somatorio
	li a1, 9
	jal soma_array
	
	lw ra, 0(sp)
	addi sp, sp, 4
		
	ret
	

	

	