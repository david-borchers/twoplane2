## Change this depending on what lag you are considering.
transect.lengths <- 1100*(1:3)
bias.mle <- numeric(3)
cv.mle <- numeric(3)
bias.palm <- numeric(3)
cv.palm <- numeric(3)
correlation <- numeric(3)
p.val <- numeric(3)
for (i in 1:3){
    l <- transect.lengths[i]
    dirname <- paste("longlag", l, sep = "")
    setwd(dirname)
    filenames <- list.files(pattern = ".Rds")
    n.files <- length(filenames)
    mle.res <- matrix(nrow = 0, ncol = 16)
    palm.res <- matrix(nrow = 0, ncol = 5)
    
    for (j in 1:n.files){
        mle.res <- rbind(mle.res, readRDS(filenames[j])$mle)
        palm.res <- rbind(palm.res, readRDS(filenames[j])$palm)
    }
    
    ## Bias for MLE:
    bias.mle[i] <- 100*(mean(mle.res[, 1]) - 1.05)/1.05 ## vs 7.1/3.2/2.0 in paper for 1100/2200/3300 lags.
    ## CV for MLE:
    cv.mle[i] <- 100*sd(mle.res[, 1])/1.05 ## vs 24.6/20.0/16.0 in paper for 1100/2200/3300 lags.
    ## Bias for palm:
    bias.palm[i] <- 100*(mean(palm.res[, 1]) - 1.05)/1.05 ## vs 10.9/3.5/2.5 in paper for 1100/2200/3300 lags.
    ## CV for palm:
    cv.palm[i] <- 100*sd(palm.res[, 1])/1.05 ## vs 33.3/23.0/18.0 in paper for 1100/2200/3300 lags.
    ## Correlation:
    correlation[i] <- cor(mle.res[, 1], palm.res[, 1]) ## vs 0.86 in paper for 1100 lag.
    ## P-value for the observed difference.
    p.val[i] <- mean(abs(mle.res[, 1] - palm.res[, 1]) >= (1.24 - 1.05)) ## vs 0.18 in paper for 1100 lag.
    setwd("..")

}

save(bias.mle, cv.mle, bias.palm, cv.palm, correlation, p.val, file = "../../longlag-results.RData")
