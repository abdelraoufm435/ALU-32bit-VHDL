# 32-Bit Structural ALU in VHDL

A 32-bit Arithmetic Logic Unit (ALU) designed in VHDL using a structural design approach. The project combines arithmetic and logical components to implement basic ALU operations and status flags.

## Overview

This project implements a 32-bit ALU using separate hardware components, including multiplexers, logic gates, and an adder-subtractor.

The ALU supports configurable operand inversion, arithmetic operations, logical operations, and signed comparison.

## Features

- 32-bit input operands and result
- AND and OR logical operations
- Addition and subtraction
- Signed Set on Less Than (SLT)
- Configurable A and B operand inversion
- Carry, overflow, zero, and negative status flags
- Testbench with directed test cases

## Operation Selection

| S | Operation | Description |
|---|---|---|
| `00` | AND | Bitwise AND |
| `01` | OR | Bitwise OR |
| `10` | Arithmetic | Addition or subtraction |
| `11` | SLT | Signed comparison: A < B |

For arithmetic operations, `Bnegate = 0` selects addition, while `Bnegate = 1` selects subtraction. For SLT, set `Bnegate = 1` and `Ainvert = 0`.

## Status Flags

| Flag | Meaning |
|---|---|
| `C` | Carry output from the arithmetic unit |
| `V` | Signed arithmetic overflow |
| `Z` | Result is zero |
| `N` | Most significant bit of the result |

The carry flag's interpretation during subtraction depends on the adder-subtractor implementation.

## Project Structure

```text
ALU-32bit-VHDL/
├── src/
│   ├── ALU.vhd
│   ├── addsub1.vhd
│   ├── mux.vhd
│   ├── mux4to1.vhd
│   ├── and_gate.vhd
│   └── or_gate.vhd
├── tb/
│   └── tb_ALU.vhd
├── docs/
│   ├── block_diagram.pdf
│   └── simulation_waveform.pdf
├── .gitignore
└── README.md
```

## Verification

The testbench applies different operand values and control signals to verify the ALU's operations and status flags.

Test cases include:
- Logical AND and OR
- Operand inversion
- Addition and subtraction
- Carry and signed overflow
- Zero and negative results
- Signed comparison, including negative operands and overflow edge cases

## Tools

- VHDL
- ASUsim
- Git and GitHub

## Learning Objectives

- Structural hardware description in VHDL
- Component instantiation and port mapping
- Multiplexer-based control selection
- Arithmetic and logic circuit integration
- Testbench design and simulation-based verification

## Author

Created as a digital design project while studying Computer and Artificial Intelligence Engineering.

## Project Status

Educational project. Verification and further improvements are ongoing.
