args <- commandArgs(trailing = TRUE)

## Simulation set.
i <- as.numeric(args[[1]])
## Number of simulations.
Nsim <- as.numeric(args[[2]])
## Setting seed.
set.seed(i)
seed <- sample(10000, size = 1)

library(twoplane)
library(palm)

nm2km=1.852 # multiplier to convert nautical miles to kilometres
planeknots=100 # observer speed in knots   CHECK THIS
planespd=planeknots*nm2km/(60^2) # observer speed in km/sec

# Density
D = D.2D <- 1.24
## Mean dive-cycle duration (seconds).
tau <- 110
## Transect half-width.
halfw.dist = w <- 0.125
## Transect length.
L = d <- 1100
## Multiplier of sigma, to set bound for maximum distance moved in k seconds
sigma.mult=5
progbar = FALSE
movement = list(forward=TRUE,sideways=TRUE)
control.opt=list(trace=0,maxit=1000)
fn.append = paste("set", i, sep = "")
p=c(1,1)

# --------------- Set up and run the full set of simulations -------------------

sigmarates = c(0.5, 0.95, 1.5)/1000
kappas = c(0.2, 0.5, 0.8)*tau
ks = c(10, 20, 50, 80)

fns = c(rep("",length(sigmarates)*length(kappas)*length(ks))) # filenames
start.a=1; start.k=1; start.s=1
end.a=length(kappas); end.k=length(ks); end.s=length(sigmarates)
simnum = 0
#simethod = "Palm"
simethod = "MLE"
Ltype = "FixedL"
fix.N=FALSE  # Allows the abundance to vary betwen simulations (as Poission with rate D.2D*2*b*L)
En = NULL # Let E[n] be determined by L and D.2D.
if(fix.N) Ntype = "FixedN" else Ntype = "RandomN"
if(!is.null(En)) Ltype = "RandomL"

startime=date()
for(na in start.a:end.a) {
  for(nk in start.k:end.k) {
    for(ns in start.s:end.s) {
      sigma = sigmarates[ns]/(sqrt(2)/sqrt(ks[nk]))
      b <- w + sigma.mult*sigma
      simnum = simnum+1
      fns[simnum] = dosim(D.2D,L,w,b,sigmarates[ns],ks[nk],planespd,kappas[na],tau,p=p,movement=movement,
                          fix.N=fix.N,En=En,Nsim=Nsim,writeout=TRUE,seed=seed,simethod=simethod,
                          control.opt=control.opt,adj.mvt=TRUE,ft.normal=FALSE,sim.ft.normal=TRUE,
                          progbar=progbar,fn.append=fn.append)
    }
  }
  cat(na, "\n")
}
endtime=date()
