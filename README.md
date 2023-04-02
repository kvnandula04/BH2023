# BH2023
Bath Hack 2023

# RISCiest Tape & Arduino Turing Machine
We created a Turing Machine using an ATMega and a tape. The tape is a physical strip of paper with binary code written(using the instruction set below) on it, which is read by the ATMega. It then interprets the binary code and performs the instructions. <br>

Some key points:
 - We use the tape as memory to hold the program and the data
 - We use the ATMega as the CPU, using only processing power & registers (no on-board memory)

Written fully in ***AVR assembly***, as programming the ATMega in C would use its on-board memory.

## FWKB-I (Instruction set)
The following is a table of our instruction set, and the binary representation of each instruction. It's composed of 14 instructions and is Turing complete. <br>

## FWKB-I (Our instruction set)
| Instruction | 4-bit Binary |
|---|---|
| hlt | 0000 |
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
**Tape** is the binary code for the physical tape which represents the program and the data <br><br>
**Nibbles** is the binary code from tape broken down into nibbles