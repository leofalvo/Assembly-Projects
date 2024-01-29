.data
	message: .asciiz "hi everybody\n my name is leo"
.text
main:
hi:
	li $t0, 3
	li $t1, 10
	div $t1, $t0
	mflo $t3