# Processor
## NAME (NETID)
Tate Staples (jts98)
## Description of Design
Standard 32 pipelined processors with a 5 stage pipeline (Fetch, Decode, Execute, Memory, Writeback). Supports a minimal ISA with arithmatic, branching and memory options.

## Bypassing
Supports WM, WX, and MX bypassing. The only remaining hazard is read after lw.
## Stalling
The division algorithm is the only instruction that stalls the pipeline. It stalls the pipeline for 32 cycles.
## Optimizations
Use a single cycle multiplier and a 32 cycle divider. This allows for the pipeline to be stalled for 32 cycles and then continue without any additional stalls.
## Bugs
No known bugs.
