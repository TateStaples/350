# ALU
## Name
Tate Staples
## Description of Design
This is my verilog implementation of an ALU. We complete all of the operations in parallel and then use a mux to select the correct output.

### Carry Look Ahead Adder
My ALU implements a 32 bit carry look ahead adder with 8 bit blocks. This adder works by precomputing the propagation (would carry through) and generate (will create carry) bits for each bit adder and 8bit blocks. This parallel carry-in computation parallelizes the bit adder to accelerate addition.

Subtraction is added by the natures of $\bar x + 1 = -x$ in twos complement.

### Logic operations
The bitwise and/or is done just as name. We just and/or match bits and output.

### Shift
Our shift operations are done with multiplexers/ternary operations. I built 1, 2, 4, 8, 16 bit shifters and then used the shift control bits as controls on which layers to apply. Logical vs Arith determines the default bits.

## Bugs
- No currently known bugs