# and andi or ori xor xori nor lui
# sll,sllv sra srav srl srlv
# nop sync 
	.text
__start:
	lui $t1,0xf0
	lui $t2,0x0f
	and $t3,$t1,$t2
	or	$t4,$t1,$t2
	xor $t5,$t1,$t2
	nor $t6,$t1,$t2
	andi $t7,$t1,0x0a
	ori $t3,$t1,0x17
	xori $t4,$t1,0x77
	sll $t6,$1,2
	sllv $t7,$t1,$t2
	sra $t5,$t1,2
	srav $t3,$1,$2
	srl $t4,$t1,2
	srlv $t6,$t1,$t2
	nop
	
