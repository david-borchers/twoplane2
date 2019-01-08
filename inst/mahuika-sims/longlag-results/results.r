## Change this depending on what lag you are considering.
setwd("longlag1100")

filenames <- list.files(pattern = ".Rds")
n.files <- length(filenames)
mle.res <- matrix(nrow = 0, ncol = 16)
palm.res <- matrix(nrow = 0, ncol = 5)

for (i in 1:n.files){
    mle.res <- rbind(mle.res, readRDS(filenames[i])$mle)
    palm.res <- rbind(palm.res, readRDS(filenames[i])$palm)
}

## Bias for MLE:
100*(mean(mle.res[, 1]) - 1.05)/1.05 ## vs 7.1/3.2/2.0 in paper for 1100/2200/3300 lags.
## CV for MLE:
100*sd(mle.res[, 1])/1.05 ## vs 24.6/20.0/16.0 in paper for 1100/2200/3300 lags.
## Bias for palm:
100*(mean(palm.res[, 1]) - 1.05)/1.05 ## vs 10.9/3.5/2.5 in paper for 1100/2200/3300 lags.
## CV for palm:
100*sd(palm.res[, 1])/1.05 ## vs 33.3/23.0/18.0 in paper for 1100/2200/3300 lags.
## Correlation:
cor(mle.res[, 1], palm.res[, 1]) ## vs 0.86 in paper for 1100 lag.
## P-value for the observed difference.
mean(abs(mle.res[, 1] - palm.res[, 1]) >= (1.24 - 1.05)) ## vs 0.18 in paper for 1100 lag.



for (j in 1:100){
    dummy.mle.res <- mle.res[sample(1:1000, size = 150), ]
    print(100*(mean(dummy.mle.res[, 1]) - 1.05)/1.05)
}
