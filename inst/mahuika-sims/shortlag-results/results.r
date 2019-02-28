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

## Biases from each scenario (MLE).
mle.bias <- sapply(res, function(x) 100*mean(x[[1]][, "D.est"] - 1.24)/1.24)
## Biases from each scenario (Palm).
palm.bias <- sapply(res, function(x) 100*mean(x[[2]][, "Dhat"] - 1.24)/1.24)
## CVs from each scenario (MLE).
mle.cv <- sapply(res, function(x) 100*sd(x[[1]][, "D.est"])/1.24)
## CVs from each scenario (Palm).
palm.cv <- sapply(res, function(x) 100*sd(x[[2]][, "Dhat"])/1.24)
## Difference in CVs, as a percentage of the MLE CV.
diff.cv <- 100*(palm.cv - mle.cv)/mle.cv

## Average number of detections by observer 1.
mean.n1 <- sapply(res, function(x) mean(x[[1]][, "n1"]))

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

pdf("~/Desktop/Dplot.pdf")
for (i in 1:36){
    boxplot(res[[i]][[1]][, 1])
    abline(h = 1.24)
}
dev.off()
