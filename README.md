# 5-Stage Pipelined RISC-V Processor with Branch Prediction (BTB)

## Overview
This repository contains a Verilog-based 32-bit RISC-V processor implementing a classic 5-stage pipeline (Fetch, Decode, Execute, Memory, Write-Back). The core executes the standard RV32I base integer instruction set (excluding system calls). 

To optimize Instructions Per Cycle (IPC) and resolve pipeline dependencies, the architecture integrates a robust Hazard/Forwarding Unit and a sophisticated 4-way set-associative Branch Target Buffer (BTB) for dynamic branch prediction.

## Key Features

Full RV32I Instruction Support: Fully handles R-type, I-type, S-type, B-type, U-type (LUI, AUIPC), and J-type (JAL, JALR) instructions. 

5-Stage Pipeline Architecture: Structurally divided into IF, ID, EX, MEM, and WB stages using custom parameterized pipeline latches for clean clock-cycle separation.

Dynamic Branch Prediction (BTB): Integrates a hardware Branch Target Buffer to predict branch outcomes during the Fetch stage. It features 4-way set-associativity, a 2-bit bimodal saturating counter for taken/not-taken tracking, and a highly efficient Tree-based Pseudo-LRU (PLRU) replacement policy.

Hazard & Forwarding Unit: Actively monitors register dependencies across pipeline stages. It resolves Read-After-Write (RAW) data hazards via direct data forwarding (bypassing) to the ALU, and manages pipeline stalls and multi-cycle flushes during load-use hazards or branch mispredictions.

Control Unit: Decodes all RISC-V opcodes directly into hardware execution flags, managing multiplexer routing, ALU operation codes, and memory read/write enables.

## Architecture & Module Hierarchy

datapath.v: The top-level data routing matrix. It instantiates the pipeline registers, multiplexers, and the ALU. It evaluates BTB prediction accuracy in the Execute stage and calculates the misprediction flush signals.

btb.v: The Branch Target Buffer module. Caches the 24-bit tags, 30-bit target addresses, and predictor states to provide zero-cycle branch prediction to the Fetch stage.

hazard_unit.v: The pipeline controller. Generates routing signals for the forwarding multiplexers, and asserts stall/flush signals across the latches when a misprediction or load-use hazard is detected.

control_unit.v: The instruction decoder. Parses the 32-bit instruction to assert signals like regwrite, mem_write, and alu_control.

alu.v & signextent.v: The arithmetic engine and immediate formatting logic, supporting dynamic shifts, logical operations, and specialized immediate structures for branching and U-type instructions.

## Simulation & Testing Workflow

To rigorously verify the 5-stage pipeline, hazard resolution, and BTB prediction accuracy, a complex algorithmic testbench was employed.

Algorithm Implementation: The Bellman-Ford algorithm (used for finding the shortest paths from a single source vertex in a weighted graph) was utilized as the primary stress test.

Toolchain Compilation: The algorithm was converted into standard RV32I machine code using the official RISC-V GNU Compiler Toolchain. 

Hardware Execution: The compiled machine code was loaded into the processor's instruction memory. Successfully executing this heavy, mathematically complex, and branch-intensive algorithm proved the architectural stability of the core, the accuracy of the data forwarding logic, and the efficiency of the branch target buffer under real-world workload conditions.

## Pipeline Breakdown

Instruction Fetch (IF): Calculates the next Program Counter (PC). It relies on a cascaded multiplexer design to select between normal PC+4, BTB predicted addresses, or corrected addresses derived from misprediction recoveries.

Instruction Decode (ID): Decodes the instruction, extracts operands from the Register File, calculates early branch targets, and passes BTB metadata (hit, way, taken status) into the pipeline.

Execute (EX): The core execution phase. Contains the ALU for mathematical operations and memory address calculations. This stage verifies BTB predictions by evaluating actual branch conditions and target addresses, asserting a misprediction flag if the BTB guessed incorrectly.

Memory (MEM): Interfaces with the Data RAM. Routes ALU results to the address port and manages memory write-enable signals for store instructions.

Write-Back (WB): The final routing stage. Selects the appropriate resultant data (ALU output, Memory Read Data, PC+4 for linking, or target addresses) and writes it back to the destination register in the Register File.
