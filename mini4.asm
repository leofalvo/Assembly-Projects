.data
	
.text
.globl main
main:
	
	jal gets
	la $v0, ($a0)
	li $v0, 4
	syscall
	
	li $v0, 10 # End Program
	syscall
	
	
	gets:
		# int gets(char *buffer, int limit)
		# (Encapsulation)
		addi $sp, $sp, -12 # Make space on stack
		sw $ra, 0($sp) # Save $ra on stack
		sw $t0, 4($sp) # Save $t0 on stack
		sw $t2, 8($sp) # Save $t2 on stack
		
		move $t0, $a0 # Buffer
		li $t2, 0 # Character counter
		li $t3, 0 # Read char counter
		
		gets_loop:
			jal GetChar
			sb $v0, 0($t0) # store char in buffer
			addi $t0, $t0, 1 # Increment buffer
			addi $t2, $t2, 1 # Incrememnt char count
			addi $t3, $t3, 1 # incremeant read
			beq $v0, 13, finish # If enter, leave
			bge $t2, $a1, finish # If limit, leave
			j gets_loop
		
		finish:
		sb $zero, 0($t0)
		move $v0, $t3
		
		lw $t2, 8($sp) # Restore $t2
		lw $t0, 4($sp) # Restore $t0
		lw $ra, 0($sp) # Restore $ra
		addi $sp, $sp, 12 # Re increment stack pointer
		jr $ra # Return

	
	loop:
		
		
		
		
		
	
	
	
	GetChar:
		lui $a3, 0xffff #base address of memory map
		addi $sp, $sp, -4 # Decrement stack pointer
		sw $ra, 0($sp) # Save return address
	CkReady:
		lw $t1, 0($a3) #read from receiver control reg
		andi $t1, $t1, 0x1 #extract ready bit
		beqz $t1, CkReady #if 1, then load char, else loop
		lw $ra 0($sp) # Load return address 
		addi $sp, $sp, 4 # Reincrement stack pointer
		jr $ra #return to place in program
		# before function call

	PutChar:
		lui $a3, 0xffff #base address of memory map
		addi $sp, $sp, -4 # Decrement stack pointer
		sw $ra, 0($sp) # Save return address
	XReady:
		lw $t1, 8($a3) #read from transmitter control reg
		andi $t1, $t1, 0x1 #extract ready bit
		beqz $t1, XReady #if 1, then store char, else loop
		sw $a0, 12($a3) #send character to display
		lw $ra 0($sp) # Load return address 
		addi $sp, $sp, 4 # Reincrement stack pointer
		jr $ra #return to place in program before
		# function call
		
		
