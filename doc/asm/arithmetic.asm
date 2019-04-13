# add,addi,addiu,addu,sub,subu,clo,clz,slt.slti.sltiu.sltu.mul.mult.multu
.text
lui $t1,3
lui $t2,4
add $t3,$t1,$t2
addi $t4,$t3,-1
addiu $t5,$t2,-4
addu $t6,$t4,$t5
sub $t4,$t2,$t1
subu $t5,$t3,$2
clo $t1,$t3
clz $t1,$t4
slt $t1,$t2,$t3
slt $t5,$t3,$t2
slti $t6,$t2,-1
slti $t7,$t2,2
sltiu $t3,$t2,-1
sltiu $t3,$t2,2
mul $t5,$t1,$t2
lui $t1,2
lui $t2,3
mult $t1,$t2
multu $t1,$t2
nop


