# methods2models
![m2m logo](https://github.com/robingarcia/methods2models/blob/master/m2m_logo_320.jpg)

## What does this software do?

This software gives you the (best) protein combination that allows you to analyze cell processes in different phases of the cell cycle.

## Required dependencies

- [http://www.intiquan.com/iqm-tools/](http://www.intiquan.com/iqm-tools/)
- [https://www.c2b2.columbia.edu/danapeerlab/html/wanderlust.html](https://www.c2b2.columbia.edu/danapeerlab/html/wanderlust.html)
- [http://sbml.org/Software/libSBML](http://sbml.org/Software/libSBML)

## Installation

0. Did you read the README?
1. Save this directory in your MATLAB path
2. $run M2M_check
3. $run m2m

## Files
### Input files
- cellcyclemodel.txt (For more help vist: [http://www.intiquan.com](www.intiquan.com))

### Output files
- pyyyymmddThhmmss.txt (Your parameters which were used for this simulation)
- ryyyymmddThhmmss.txt (Your results)
- wyyyymmddThhmmss.mat (Your workspace)


## Example
$ m2m(0:1000,1000,2,0.01,'model_toettcher2008MEX',0);

## License


Note: You can run this script in headless mode.
