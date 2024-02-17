.data

query1: .asciiz "\nPlease input an integer value greater than or equal to 0: "
intmessage: .asciiz "The value you entered is less than zero. This program only works with values greater than or equal to zero."

yourinput: .asciiz "Your input: "
factorialhelper: .asciiz "\nThe factorial is "
repeatprompt: .asciiz "\nWould you like to do this again (Y/N):"
repeatbuffer: .space 10

	.text
	.globl main
main:
	# Print query one
	li $v0, 4
	la $a0, query1
	syscall
	
	# Take integer input
	li $v0, 5
	syscall
	bltz $v0, interror # If less than zero, write int error
	
	# Save input for later use
	move $s0, $v0 # Write integer input to s0
	
	# Call factorial function
	move $a0, $s0 # Move input to argument
	jal factorial
	move $t1, $v0 # Save factorial for later use

	
	# Print your input prompt
	li $v0, 4
	la $a0, yourinput
	syscall
	
	# Print their input
	li $v0, 1 
	move $a0, $s0
	syscall
	
	# Print factorial helper string 
	li $v0, 4
	la $a0, factorialhelper
	syscall
	
	#Print answer
	li $v0, 1
	move $a0, $t1
	syscall
	
	# Print repeat prompt
	li $v0, 4
	la $a0, repeatprompt
	syscall
	
	# Take input
	li $v0, 12
	syscall
	
	# Compare to Y
	li $t1, 89
	beq $v0, $t1, main
	
	# Exit if not Y
	li $v0, 10
	syscall
	
	factorial:
		# BC
		li $v0, 1
		blez $a0, return_factorial
		
		# Save $ra and $a0 on stack
		addiu $sp, $sp, -8
		sw $ra, 4($sp)
		sw $a0, 0($sp)
		
		# PREPARE FOR RECURSION
		addiu $a0, $a0, -1
		jal factorial
		
		# Restore $a0, $ra, set up multiplication
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addiu $sp, $sp, 8
		
		# Multiply
		mul $v0, $a0, $v0
		
	return_factorial:
		jr $ra

	
	interror:
		#Print integer error
		li $v0, 4
		la $a0, intmessage
		syscall
		
		#Exit Program
		li $v0, 10
		syscall
