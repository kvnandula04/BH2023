# BH2023

Bath Hack 2023

# RISC-iest Tape & Arduino Turing Machine
We created a Turing Machine using an ATMega and a tape. The tape is a physical strip of paper with binary code written(using the instruction set below) on it, which is read by the ATMega. It then interprets the binary code and performs the instructions. <br>

Some key points:
 - We use the tape as memory to hold the program and the data
 - We use the ATMega as the CPU, using only processing power & registers (no on-board memory)

Written fully in **_AVR assembly_**, as programming the ATMega in C would use its on-board memory.

## FWKB-I (Instruction set)
The following is a table of our instruction set, and the binary representation of each instruction. It's composed of 14 instructions and is Turing complete. <br>

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

 - **abstract.py** is the initial workspace for creating the program (Python) <br><br>
 - **main.asm** is the assembly code for testing out the program (AVR) <br><br>
 - **tape.bin** is the binary code for the physical tape which represents the program and the data <br><br>
 - **nibbles.bin** is the binary code from tape broken down into nibbles
