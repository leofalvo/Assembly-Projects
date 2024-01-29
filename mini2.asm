.data
# Set I/O error messages
message: .asciiz "Input a string 30 characters or less: "
message1: .asciiz "Input an integer greater than 0: "
invalidstr: .asciiz "No input. Run again.\n" 
invalidint: .asciiz "Wrong input. Run again.\n"
bracket1: .asciiz "Shifted string = ["
bracket2: .asciiz "]"
bufferstr: .space 31
toreturn: .space 31 
shiftint: .space 10

.text 
main:	
	# String Question
	li $v0, 4 # Set system call $v0 to 4 to print a string
    	la $a0, message # Load the first memory address of the primary message
    	syscall # Activate system call
    	
    	# Take initial Input
    	li $v0, 8 # Set system call to 8 to take string
    	la $a0, bufferstr # Load buffer to accept input
    	li $a1, 31 # Create space to for string
    	syscall
    	
    	# Check for emptiness
    	lb $t0, bufferstr # Load buffer
    	li $t1, 10 # Load newline
    	beq $t0, $t1 strerror # Compare with newline because of how v0 8 handles input
    	
    	
    	
    	
    	# Int Question
    	li $v0, 4 #Set system call $v0 to 4 to print a string
    	la $a0, message1 #Load the first memory address of the primary message
    	syscall
    	
    	#Get user's int as a string
    	li $v0, 8 # Set $v0 to 8 to get string
    	la $a0, shiftint #Load buffer to accept input
    	li $a1, 10 #Assign space for int
    	syscall
    	
    	#Check for emptiness
    	lb $t0, shiftint # Load shiftint
    	li $t1, 10 # Load newline
    	beq $t0, $t1 interror # Compare with newline because of how v0 8 handles input
	

	la $a0, shiftint # Load str to be converted to integer
	li $t1, 0 # Initialize int to 0
	li $t3, 10 # Load newline for comparison
	str_to_int:
		lb $t2, 0($a0) # Load current char
		beq $t2, $t3, end # Leave if newline byte
		sub $t2, $t2, 48 # Convert from ASCII to int
		mul $t1, $t1, 10 # Multiply current int by 10 to adjust for place
		add $t1, $t1, $t2 # Add current digit
		addi $a0, $a0, 1 # Iterate to next char
		j str_to_int # Jump to start
	end:
	blez, $t1 interror # Check if int less than zero
	move $s1, $t1 # Move int value to $s1
	
	li $t3, 10 # Load newline for comparison
	la $a0, bufferstr # Load str
	li $t1, 0 # Init t2 to zero as a counter
	get_str_length:
		lb $t2, 0($a0) # Load current char
		beq $t2, $t3 continue # If newline, leave
		addi $t1, $t1, 1 # Add one to the length
		addi $a0, $a0, 1 # Move to next char
		j get_str_length # Restart loop
	continue:
	
    	div $s1, $t1 # Divide provided len by str length
    	mfhi, $s0 # Move remainer to $s0
    	move $s1, $t1 # Set string length to $s1
    	
    	
    	move $t1, $s0 # Set $t0 as string length for incrementing
    	la $a0, bufferstr # Load str
    	
    	offset:
    		blez $t1, finish # Move on if offset is finished
    		addi $a0, $a0, 1 # Move to next char
    		subi $t1, $t1, 1 # Increment offset
    		j offset # Loop
    	
    	finish:
    	
	la $a1, toreturn # load new string
	move $t0, $s1 # Load string lenght as iterator for $t0
	li $t7, 10 # Load newline for comparison
	writer:
		blez $t0, final # If length reaches end, leave loop
		lb $t1, 0($a0) # Load current char of existing string
		beq $t1, $t7, helper # If char is newline, move to helper to loop around.
		sb $t1, 0($a1) # Save current char of existing to new string
		addi $a1, $a1, 1 # Move forward in new string
		addi $a0, $a0, 1 # Move forward in old string
		subi $t0, $t0, 1 # Decrement iterator
		j writer # Loop
		
	helper:
		la $a0, bufferstr # reset string
		j writer # Jump back to where we were
	
	final:
	
	# Print part one of brackets
    	li $v0, 4
    	la $a0, bracket1
    	syscall
    	
    	# Print shifted string
    	li $v0, 4
    	la $a0, toreturn
    	syscall
    	
    	# Print part two of brackets
    	li $v0, 4
    	la $a0, bracket2
    	syscall
    	
    	#End Program
    	li $v0, 10
    	syscall
    	
    	strerror:
    		#Error Message
    		li $v0, 4 #Enter text print protocol
    		la $a0, invalidstr # Load Error Message
    		syscall #System Call
    		
    		#End Program
    		li $v0, 10
    		syscall
    
    	interror:
    		#Error Message
    		li $v0, 4 #Enter text print protocol
    		la $a0, invalidint # Load Error Message
    		syscall #System Call
    		
    		#End Program
    		li $v0, 10
    		syscall
    		
    		
    	
    	
    	
    	
