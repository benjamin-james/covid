#!/usr/bin/env Rscript
## library(ggplot2)
library(data.table)
source("mask_mandate.R")

data <- get.data()


date.range <- sprintf("2020-07-%02d", 1:19)

df <- sapply(date.range, function(cur.date) {
    cur.mask <- subset(data$mask, date == cur.date)
    cur.nomask <- subset(data$nomask, date == cur.date)
    d.m <- cur.mask$cases %*% (cur.mask$density / sum(cur.mask$density))
    d.nm <- cur.nomask$cases %*% (cur.nomask$density / sum(cur.nomask$density))
    p.m <- cur.mask$cases %*% (cur.mask$pop / sum(cur.mask$pop))
    p.nm <- cur.nomask$cases %*% (cur.nomask$pop / sum(cur.nomask$pop))

    return(list(mask=median(cur.mask$cases),
                nomask=median(cur.nomask$cases),
                mask.density.weighted=d.m,
                nomask.density.weighted=d.nm,
                mask.pop.weighted=p.m,
                nomask.pop.weighted=p.nm
                ))
})

df <- t(rbind(df))
write.csv(df, file="out/summary.csv")
