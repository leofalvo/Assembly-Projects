.data
# Set I/O error messages
message: .asciiz "Input a string 30 characters or less: "
message1: .asciiz "Input an integer greater than 0: "
invalid: .asciiz "No input. Run again." 
buffer: .space 30 

.text 
main:
	li $v0, 4 #Set system call $v0 to 4 to print a string
    	la $a0, message #Load the first memory address of the primary message
    	syscall #Activate system call
    	
    	li $v0, 8 #Set system call to 8 to take input
    	la $a0, buffer #Load buffer to accept input
    	li $a1, 30
    	syscall
    	
    	