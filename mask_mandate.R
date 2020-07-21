#!/usr/bin/env Rscript

get.data <- function() {
    all.pop <- read.csv("population.csv")
    all.pop <- all.pop[c("State", "Pop", "density")]
    names(all.pop) <- c("state", "pop", "density")
    all.pop[["pop"]] <- all.pop[["pop"]] / sum(all.pop[["pop"]])
    all.pop[["density"]] <- all.pop[["density"]] / sum(all.pop[["density"]])

    mask.states <- read.csv("mask_states.txt", header=FALSE)$V1

    mask.pop <- all.pop[(all.pop$state %in% mask.states),]
    nomask.pop <- all.pop[!(all.pop$state %in% mask.states),]

    data <- read.csv("covid-19-data/us-states.csv")
    mask <- merge(mask.pop, data)
    mask <- mask[order(mask$state), ]

    nomask <- merge(nomask.pop, data)
    nomask <- nomask[order(nomask$state), ]
    return(list(mask=mask, nomask=nomask))
}
