ori $1,$0,0xf
mtc0 $1,$11
lui $1,0x1000
ori $1,$1,0x401
mtc0 $1,$12
mfc0 $2,$12
_loop:
	j _loop
	nop