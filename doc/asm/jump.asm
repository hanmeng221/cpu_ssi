#jr,jalr,j,jal,beq,bgez,bgezal,bgtz,blez,bltz,bltzal,bne
.text
lui $t1,3
lui $t2,4
j next
lui $t3,1
add $t3,$t1,$t2
addi $t4,$t3,-1
addiu $t5,$t2,-4
next:add $t4,$t1,$t2
andi $t3,0
bgtz $t3,nnext
ori $t1,$t3,0xf
add $t4,$t1,$t2
nnext: and $5,$t4,$t3
andi $t6,$t5,0
lui $t3,2
lui $t4,2
beq $t3,$t4,out
add $t6,$t3,$t4
out:nop