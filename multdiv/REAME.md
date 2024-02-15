# RegisterFile
## Name
Tate Staples
## Description of Design
Implementation of efficient multiplication (Wallace Tree) and division (TBD).

## Multiplier design
This computes a one cycle multiplication using a wallace tree as generated from wallace.py. The wallace tree is a tree of adders that reduces the number of partial products to be added together. The wallace tree is generated from the python script `wallace.py` and the output is copied into the `wallace_tree.v` file. The wallace tree is then instantiated in the `multdiv.v` file.

## Division
In progress

## Bugs
- Doesn't handle -i32 well