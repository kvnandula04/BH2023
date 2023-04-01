# BH2023
Bath Hack 2023

# RISCiest Tape & Arduino Turing Machine
 - Tape as memory
 - ATMega as CPU, using only processing power & registers (no on-board memory)

Written fully in ***AVR assembly***, as programming the ATMega in C would use its on-board memory.

Turing Complete.

## FWKB-I (Our instruction set)
| Instruction | 4-bit Binary |
|---|---|
| lpm | 0001 |
| add |  0010 |
| addi | 0011  |
| sub | 0100 |
| subi | 0101 |
| cpi | 0110 |
| brlo | 0111 |
| breq | 1000 |
| brsh | 1001 |
| rjmp | 1010 |
| mov | 1011 |
| ldi | 1100 |
| out | 1101 |

## Files

**Abstract** is the initial workspace for creating the program (written in Python) <br><br>
**Tape** is the binary code for the physical tape which represents the program and the data