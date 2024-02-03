.data

query1: .asciiz "Please input an integer value greater than or equal to 0: "
interror: .asciiz "The value you entered is less than zero. This program only works with values greater than or equal to zero."

.text
main:
	# Print query one
	li $v0, 4
	la $a0, query1
	syscall
	
	# Take integer input
	li $v0, 5
	syscall
	
	bltz $v0, interror # If less than zero, write int erro
	
	move $s1, $v0 # Write integer input to s1
	
	
	
	#Exit Program
	li $v0, 10 
	syscall
	
	interror:
		#Print integer error
		li $v0, 4
		la $a0, interror
		syscall
		
		#Exit Program
		li $v0, 10
		syscall