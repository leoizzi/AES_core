
if __name__== "__main__":
    PlainTxt = "0f0b07030e0a06020d0905010c080400"
    hex_base = "0x"
    plt_init = "uint8_t plaintxt[] = { "

    for i in range (len (PlainTxt)-2):
        if (i%2 == 0 and i != 0):
            plt_init += hex_base + PlainTxt[i-2 : i] +", "
    plt_init += hex_base + PlainTxt[(len(PlainTxt)-2) : len(PlainTxt)] +" };"
    file = open("c_plaintext_init.txt", "w")
    file.write(plt_init)
    file.close()    