# Changepoint detection methods

## Dependencies
### MATLAB `findchangepts`
`findchangepts` requires MATLAB's Signal Processing Toolbox. 


### Compiling gfpop
Before running the `gfpop` algorithm, you must compile the [mex](https://www.mathworks.com/help/matlab/call-mex-file-functions.html) file, `gfpop_mex.cpp`, located in the `gfpop` folder. Compile the file using `mex`:
```
mex gfpop_mex.cpp
```
## File descriptions
The row, column, and "both" algorithms are run with the following scripts:

**`findchangepts`**:
- rows: `matlabChptsRows`
- columns: `matlabChptsCols`
- both: `matlabChptsBoth`

**`gfpop`**:
- rows: `gfpopRows`
- columns: `gfpopCols`
- both: `gfpopBoth`

`timingAnalysisScript` records the runtimes of each algorithm.

`changepointAnalysis` computes performance metrics for all the algorithms.

`testingScript` was used to develop and tune the algorithms.