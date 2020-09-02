        org 0

        lxi d,0
        xchg
        lxi b,end
        dad d
        dad b
        xchg

RELOCADDR macro
        dad d
        mov a, m
        add e
        mov m, a
        inx h
        mov a, m
        add d
        mov m, a

        endm
