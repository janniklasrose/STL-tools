# STL_Tools

This repository contains MATLAB functions for handling STL files. They are primarily taken from MATLAB FileExchange and tweaked if needed.

A quick overview is given here. Please consult the function help for details.

|   Function    |                      Description                      |
| ------------- | ----------------------------------------------------- |
| `stlRead`     | supports reading STL files in Binary and ASCII format |
| `stlWrite`    | supports writing STL files in Binary and ASCII format |
| `stlPlot`     | plots the mesh and applies material and lighting      |
| `stlGetVerts` | returns those vertices that are 'opened' or 'closed'  |
| `stlDelVerts` | removes the specified vertices from the triangulation |
| `stlAddVerts` | triangulates new vertices and adds them to the list   |

The script `stlDemo` makes use of all of the above functions

## Comparison with MATLAB provided functions

As of version R2018b, MATLAB comes with `stlread` and `stlwrite` which are capable of reading and writing STL files (as expected).
They generate a `triangulation` object with non-intuitively named, **read-only** properties `Points` (Vertices) and `ConnectivityList` (Faces).

To compare their performance, run the code below.

```MATLAB
timeit(@() stlread('demo/femur_binary.stl'))
timeit(@() stlRead('demo/femur_binary.stl'))
```
