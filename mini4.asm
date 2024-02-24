.data
	firstbuffer: .space 10
	lastbuffer: .space 10
	firstname: .asciiz "First name: "
	lastname: .asciiz "\nLast name: "
	endstr: .asciiz "\nYou entered: "
	comma: .asciiz ", "
	period: .asciiz "."
	
.text
.globl main
main:
	la $a0, firstname # Load Prompt
	jal puts # Call puts
	
	la $a0, firstbuffer # Load firstbuffer
	li $a1, 9 # Load limit minus one
	jal gets # Call gets
	
	la $a0, lastname # Load lastname to print
	jal puts # Call puts
	
	la $a0, lastbuffer # Load lastname buffer
	li $a1, 9 # Load limit minus one
	jal gets # Call gets
	
	la $a0, endstr # Load end
	jal puts # call puts
	
	la $a0, lastbuffer # Load lastname
	jal puts # Call puts
	
	la $a0, comma # Load comma
	jal puts # Call puts
	
	la $a0, firstbuffer # Load firstname
	jal puts # Call puts
	
	la $a0, period # Load period
	jal puts # Call puts
	
	li $v0, 10
	syscall
	
	puts:
		# int puts(char *buffer)
		addi $sp, $sp -4 # Decrement Sp
		sw $ra 0($sp) # Save ra to sp
		la $t0, ($a0) # Load input buffer
		li $t2, 0 # Init at zero
		puts_loop:
			lb $t1, 0($t0) # Load current byte
			beqz $t1, puts_end # End if zero
			move $a0, $t1 # Move to input
			addi $t2, $t2, 1 # Increment counter
			jal PutChar # Print current byte
			addi $t0, $t0, 1 # Move to next one
			j puts_loop # Loop
		
		puts_end:
		lw $ra, 0($sp) # Restore $ra
		addi $sp, $sp 4 # Restore sp
		move $v0, $t2 # Return counter
		jr $ra # Return
			
	
	gets:
		# int gets(char *buffer, int limit)
		# (Encapsulation)
		addi $sp, $sp, -12 # Make space on stack
		sw $ra, 0($sp) # Save $ra on stack
		sw $t0, 4($sp) # Save $t0 on stack
		sw $t2, 8($sp) # Save $t2 on stack
		
		move $t0, $a0 # Buffer
		li $t2, 0 # Character counter
		
		gets_loop:
			jal GetChar
			beq $v0, 10, newline_finish # If enter, leave
			sb $v0, 0($t0) # store char in buffer
			addi $t0, $t0, 1 # Increment buffer
			addi $t2, $t2, 1 # Increment char count
			bge $t2, $a1, finish # If limit, leave
			j gets_loop # Loop
			
		finish:
		addi $t0, $t0, 1 # Add one to buffer
		
		newline_finish:
		sb $zero, 0($t0) # Save null byte
		move $v0, $t2 #  Move to return address
		lw $t2, 8($sp) # Restore $t2
		lw $t0, 4($sp) # Restore $t0
		lw $ra, 0($sp) # Restore $ra
		addi $sp, $sp, 12 # Re increment stack pointer
		jr $ra # Return

	
	GetChar:
		lui $a3, 0xffff #base address of memory map
		addi $sp, $sp, -4 # Decrement stack pointer
		sw $ra, 0($sp) # Save return address
	CkReady:
		lw $t1, 0($a3) #read from receiver control reg
		andi $t1, $t1, 0x1 #extract ready bit
		beqz $t1, CkReady #if 1, then load char, else loop
		lw $v0, 4($a3)
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
		
		
