twoplane
======

twoplane is an R package implementing the method described in the paper _A latent capture history model for digital aerial surveys_ by D. L. Borchers, P. Nightingale, B. C. Stevenson, and R. M. Fewster, to appear in the journal Biometrics. 

The method is based on maximum likelihood estimation, and estimates animal density and related parameters from mark-recapture line transect surveys on which recaptures are not identified, there is animal movement and animals' availability is governed by a Markov model. The current version ignores forward distances, assumes all detected animals are at zero forward distance when detected (as is the case for high-definition video survey, for example).

It is a standard R package, and has been tested (most recently) with R version 4.0.2. 

The package contains a small component written in C++, so it requires a C++ compiler toolchain to be installed. 

To build and install the package in R using devtools, you may use the following commands:

_Start R and set the working directory to the directory containing this file_

install.packages("devtools")
library(devtools)
build()
install()

_Now the package should be ready to load:_

library(twoplane)

Alternatively, to build and install the package in RStudio:
1. Open the project file: twoplane2.Rproj 
2. Open the Build tab
3. Under "More", select "Clean and Rebuild"





