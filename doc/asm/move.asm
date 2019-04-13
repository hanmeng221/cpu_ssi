# movn,movz,mfhi,mthi,mflo,mtlo

	.text
__start:
	lui $t1,0xf0
	lui $t2,0x0f
	movn $t3,$t2,$t1
	movz $t4,$t1,$zero
	mthi $t3
	mtlo $t4
	mfhi $t5
	mflo $t4
	movn $t7,$t4,$zero
	movz $t6,$t5,$t1
	nop
	
