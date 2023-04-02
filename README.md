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

| Instruction | 4-bit Binary | Description |
| ----------- | ------------ | ----------- |
| HALT        | 0000         | Halt the program |
| LOAD        | 0001         | Load the value into the specified register |
| ADD         | 0010         | Add the values of the 2 specified register |
| ADDK        | 0011         | Add constant k to the value of the specified register |
| SUB         | 0100         | Subtract the values of the 2 specified register |
| SUBK        | 0101         | Subtract constant k from the value of the specified register |
| COMP        | 0110         | Compare constant k to the specified register |
| iLESS       | 0111         | If the specified register is less than k, jump to the next instruction |
| iEQIV       | 1000         | If the specified register is equal to k, jump to the next instruction |
| iGEQ        | 1001         | If the specified register is greater than or equal to k, jump to the next instruction |
| JUMP        | 1010         | Jump to the specified location  |
| COPY        | 1011         | Copy the value from one register to another |
| LOADK       | 1100         | Load constant k into the specified register |
| DISP        | 1101         | Display the value of the specified register on the 7-segment display |

## Abstract Program
1. Fetch and store cipher key
2. Fetch next data item <br>
    a. If there is a letter, decrypt the letter and display it on the 7-segment display <br>
    b. If it's a 0, halt the program

## Example
The following is a general purpose demonstration of a Caeser shift program: <br>
 - Shift length = 12 <br>
 - Input data = "VSZZC" <br>
 - Decrypted output on 7 segment display = "HELLO" (printed one char at a time)

## Files
1. **abstract.py** is the initial workspace for creating the program (Python) <br><br>
2. **main.asm** is the assembly code for testing out the program (AVR) <br><br>
3. **tape.bin** is the binary code for the physical tape which represents the program and the data <br><br>
4. **nibbles.bin** is the binary code from tape broken down into nibbles
