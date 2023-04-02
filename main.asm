
.nolist
.include "m328def.inc"
.list

.dseg
    .def        LDR_reg = r17
    .equ        LOAD    = 1

    ; .def        Z = Z

.cseg
main:
    ldi     ZL, low(string<<1)
    ldi     ZH, high(string<<1)

; //beginning of program
loop:
    lpm     r19, Z
    ; inc     ZL
    subi    ZL, -1
    cpi     r19, 50
    brsh    letter
    mov     r18, r19
    cpi     r18, 0x00
    breq    end
    rjmp    loop
letter:
    ; //end of load

    subi    r19, 60
    subi    r19, 5
    add     r19, r18
    cpi     r19, 26
    brlo    dont_mod
    subi    r19, 26
dont_mod:
    subi    r19, -5
    subi    r19, -60
    ; //end of shift

    out     DDRB, r19; putc    r18; 7-segment output
    ; //end of display

    rjmp    loop
; //end of program

end:
    rjmp    end

string:
    .db        0x0C,"YOP",0x00
