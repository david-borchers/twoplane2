filenames <- paste("results4/", list.files("results4/"), sep = "")
stem <- sapply(strsplit(filenames, "set"), function(x) x[1])
set <- sapply(strsplit(filenames, "set"), function(x) x[2])
n.scenarios <- length(unique(stem))

res <- vector(mode = "list", length = n.scenarios)
names(res) <- unique(stem)
for (i in 1:n.scenarios){
    s.filenames <- filenames[stem == unique(stem)[i]]
    n.files <- length(s.filenames)
    mle.res <- matrix(nrow = 0, ncol = 15)
    palm.res <- matrix(nrow = 0, ncol = 5)
    for (j in 1:n.files){
        mle.res <- rbind(mle.res, readRDS(s.filenames[j])$mle)
        palm.res <- rbind(palm.res, readRDS(s.filenames[j])$palm)
    }
    res[[i]] <- list(mle = mle.res, palm = palm.res)
}

sigmas <- sapply(res, function(x) mean(x[[1]][, "sigmarate.est"])*110)

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
short.D.coverage <- sapply(res, function(x) mean(x[[1]][, "D.inci"]))
## Correlation between estimators.
short.cor <- sapply(res, function(x) cor(x[[1]][, "D.est"], x[[2]][, "Dhat"]))

save(short.res, short.mle.bias, short.palm.bias, short.mle.cv, short.palm.cv, short.diff.cv,
     short.mean.n1, short.mean.m, short.D.coverage, short.cor, file = "../../shortlag-results.RData")


pdf(file = "shortlag-sims4.pdf", width = 8, height = 6)
## Recreating Figure 3.
plot(mean.n1, mle.bias, ylim = c(-2, 7), xlim = c(50, 300))
points(mean.n1 + 8, palm.bias, col = "grey", pch = 3)
abline(h = 0, lty = "dashed")

## Recreating Figure 4(a).
plot(mean.n1, mle.cv, xlim = c(50, 300))
points(mean.n1 + 8, palm.cv, col = "grey", pch = 3)

## Recreating Figure 4(b).
plot(mean.n1, diff.cv)
abline(h = 0, lty = "dashed")

dev.off()
