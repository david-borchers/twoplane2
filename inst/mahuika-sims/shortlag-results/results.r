filenames <- paste("results5/", list.files("results5/"), sep = "")
stem <- sapply(strsplit(filenames, "set"), function(x) x[1])
set <- sapply(strsplit(filenames, "set"), function(x) x[2])
n.scenarios <- length(unique(stem))

sim.gamma <- numeric(n.scenarios)
sim.lag <- numeric(n.scenarios)
sim.sigmarate <- numeric(n.scenarios)
cutoff <- 50
res <- vector(mode = "list", length = n.scenarios)
names(res) <- unique(stem)
for (i in 1:n.scenarios){
    u.stem <- unique(stem)[i]
    s.filenames <- filenames[stem == u.stem]
    n.files <- length(s.filenames)
    mle.res <- matrix(nrow = 0, ncol = 15)
    palm.res <- matrix(nrow = 0, ncol = 5)
    for (j in 1:n.files){
        mle.res.full <- rbind(mle.res, readRDS(s.filenames[j])$mle)
        palm.res.full <- rbind(palm.res, readRDS(s.filenames[j])$palm)
        mle.res <- mle.res.full[mle.res.full$D.est < cutoff & palm.res.full$Dhat < cutoff, ]
        palm.res <- palm.res.full[mle.res.full$D.est < cutoff & palm.res.full$Dhat < cutoff, ]
    }
    sim.gamma[i] <- as.numeric(substr(u.stem, 20, 22))
    sim.lag[i] <- as.numeric(substr(u.stem, 34, 35))
    sim.sigmarate[i] <- as.numeric(substr(u.stem, 47, 51))*1000
    res[[i]] <- list(mle = mle.res, palm = palm.res)
}

sigmas <- sapply(res, function(x) mean(x[[1]][, "sigmarate.est"])*110)

mle.Ds <- sapply(res, function(x) x[[1]][, "D.est"])
palm.Ds <- sapply(res, function(x) x[[2]][, "Dhat"])

short.res <- res
## Biases from each scenario (MLE).
short.mle.bias <- sapply(res, function(x) 100*mean(x[[1]][, "D.est"] - 1.24)/1.24)
## Biases from each scenario (Palm).
short.palm.bias <- sapply(res, function(x) 100*mean(x[[2]][, "Dhat"] - 1.24)/1.24)
## CVs from each scenario (MLE).
short.mle.cv <- sapply(res, function(x) 100*sd(x[[1]][, "D.est"])/1.24)
## CVs from each scenario (Palm).
short.palm.cv <- sapply(res, function(x) 100*sd(x[[2]][, "Dhat"])/1.24)
## Difference in CVs, as a percentage of the MLE CV.
short.diff.cv <- 100*(short.palm.cv - short.mle.cv)/short.mle.cv
## Average number of detections by observer 1.
short.mean.n1 <- sapply(res, function(x) mean(x[[1]][, "n1"]))
## Average number of recaptures.
short.mean.m <- sapply(res, function(x) mean(x[[1]][, "m"]))
## Coverage for MLE estimator.
short.D.coverage <- sapply(res, function(x) mean(x[[1]][, "D.inci"], na.rm = TRUE))
## Correlation between estimators.
short.cor <- sapply(res, function(x) cor(x[[1]][, "D.est"], x[[2]][, "Dhat"]))

save(short.res, short.mle.bias, short.palm.bias, short.mle.cv, short.palm.cv, short.diff.cv,
     short.mean.n1, short.mean.m, short.D.coverage, short.cor, sim.gamma, sim.lag, sim.sigmarate,
     file = "../../shortlag-results.RData")


pdf(file = "shortlag-sims5.pdf", width = 8, height = 6)
## Recreating Figure 3.
plot(short.mean.n1, short.mle.bias, xlim = c(50, 300))
points(short.mean.n1 + 8, short.palm.bias, col = "grey", pch = 3)
abline(h = 0, lty = "dashed")

## Recreating Figure 4(a).
plot(short.mean.n1, short.mle.cv, xlim = c(50, 300))
points(short.mean.n1 + 8, short.palm.cv, col = "grey", pch = 3)

## Recreating Figure 4(b).
plot(short.mean.n1, short.diff.cv)
abline(h = 0, lty = "dashed")

dev.off()
