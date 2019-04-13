.data
array1: .word  0xffe0ffe0,0xf81ff81f,0x07ff07ff,0x000f000f,0x78007800,0x03e003e0,0x7be07be0,0xc618c618,0x001f001f,0x07e007e0,0xf800f800,0xffffffff,0x7bef7bef,0x780f780f,0x03ef03ef
.text

#start:lw $t1,var1
#lw $t2,var2
#add $t3,$t1,$t2
#lw $t4,var3
#add $t5,$t3,$t4
#j start
#ori $t0,$0,1

start: lw $t1,array1+0
lw $t2,array1+4
lw $t3,array1+8
lw $t4,array1+12
lw $t5,array1+16
lw $t6,array1+20
j start
lw $t7,array1+24


