# RegisterFile
## Name
Tate Staples
## Description of Design
Implementation of Register file with 32 different 32-bit registers. Register 0 is hardwired to always stay as 0.

## Register design
This is a wrapper class that splits a 32-bit input and piecewise passes into 32 D-flip-flops.

## Tristate
Uses the enable to select whether to pass value or impede

## General Regfile
Selectivly optionally writes to a register and and reads from two resigisters

## Bugs
- No currently known bugs