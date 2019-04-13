.data
array1: .word  0xffe0ffe0,0xf81ff81f,0x07ff07ff,0x000f000f,0x78007800,0x03e003e0,0x7be07be0,0xc618c618,0x001f001f,0x07e007e0,0xf800f800,0xffffffff,0x7bef7bef,0x780f780f,0x03ef03ef
len: .word 60

.text
lw $t1,len
ori $t2,$0,0 #i
ori $t3,$0,4 #j
ori $t4,$0,4 #²½³¤
ori $t0,$0,0
loop1: 
		lw $t5, array1($t2)
		lw $t6,array1($t3)
		addu $t7,$t5,$t6
		add $t3,$t3,$t4
		sw $t7,array1($t2)
		add $t2,$t2,$t4
		bne $t3,$t1,continuej
		addiu,$t0,$t0,1
 	    ori $t3,$0,0
continuej:	bne $t2,$t1,toloop
		addiu,$t0,$t0,1
		ori $t2,$0,0
toloop:		j loop1
		addiu,$t0,$t0,1
				
