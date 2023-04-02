# BH2023

Bath Hack 2023

# RISCiest Tape & Arduino Turing Machine

-   Tape as memory
-   ATMega as CPU, using only processing power & registers (no on-board memory)

Written fully in **_AVR assembly_**, as programming the ATMega in C would use its on-board memory.

Turing Complete.

## FWKB-I (Our instruction set)

| Instruction | 4-bit Binary |
| ----------- | ------------ |
| HALT        | 0000         |
| LOAD        | 0001         |
| ADD         | 0010         |
| ADDK        | 0011         |
| SUB         | 0100         |
| SUBK        | 0101         |
| COMP        | 0110         |
| iLESS       | 0111         |
| iEQIV       | 1000         |
| iGEQ        | 1001         |
| JUMP        | 1010         |
| COPY        | 1011         |
| LOADK       | 1100         |
| DISP        | 1101         |

## Files

**Abstract** is the initial workspace for creating the program (written in Python) <br><br>
**Tape** is the binary code for the physical tape which represents the program and the data
**Nibbles** is the binary code from tape broken down into nibbles
