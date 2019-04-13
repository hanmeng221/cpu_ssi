def tohex(length, addr, inst, datatype):
    inst_cmd = int(inst[0:2], 16) + int(inst[2:4], 16) + int(inst[4:6], 16) + int(inst[6:8], 16)
    cmd_all = (int((length + addr/256 + addr % 256 + datatype + inst_cmd) % 256))
    cmd = "%02x" % (256 - cmd_all)
    if cmd_all == 0:
        cmd = "00"
    formater = "%02x%04x%02x"
    return (":" + formater % (length, addr, datatype) + inst + cmd).upper() + "\n"

def encodefile(filename, rename):
    with open(filename, "r") as f:
        insts = f.readlines()
    f.close()
    with open(rename, "w") as r:
        addr = 0
        for inst in insts:
            inst = inst[:-1]
            lenth = 4
            datatype = 0
            r.write(tohex(lenth, addr, inst, datatype))
            addr = addr + 1
        r.write(":00000001FF\r\n")
        r.close()

if __name__ == "__main__":
    encodefile("E:\\北航计组\\inst.data", "C:\\altera\\CPU\\rtl\\inst1.hex")
    encodefile("E:\\北航计组\\dm.data", "C:\\altera\\CPU\\rtl\\dm1.hex")
