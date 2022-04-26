.globl main

.data
	nome: .string "lena.png"		 #nome do ficheiro
	
.text

load_file:
	li a7,1024
	la a0,nome
	li a1,0
	ecall 			#aqui fazemos o syscall para abrir o ficheiro
	mv s6, a0
	sw s6,0(sp)
	
	
close_file:
	li a7,57
	mv a0,s6
	ecall
	

main:
	j load_file
	j close_file
	
