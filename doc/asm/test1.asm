start:ori $t1,$0,10
loop: sub $t1,$t1,1
	ori $t2,$t0,1
	beq $t1,0,start
	j loop
	nop
	