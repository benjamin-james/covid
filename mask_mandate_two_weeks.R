#!/usr/bin/env Rscript

source("mask_mandate.R")

start.date <- "2020-07-05"
now.date <- "2020-07-19"
print(paste("comparing dates", start.date, "and", now.date))

data <- get.data()

two_weeks.mask <- subset(data$mask, date == start.date)
two_weeks.nomask <- subset(data$nomask, date == start.date)

now.mask <- subset(data$mask, date == now.date)
now.nomask <- subset(data$nomask, date == now.date)

change <- function(cur, old, by="density") {
    diff <- (cur$cases - old$cases) / old$cases
    weights <- old[[by]] / sum(old[[by]])
    return(diff * weights)
}

mask.change <- change(now.mask, two_weeks.mask)
nomask.change <- change(now.nomask, two_weeks.nomask)

print(t.test(mask.change, nomask.change))

print(paste("mask change:", sum(mask.change)))
print(paste("nomask change:", sum(nomask.change)))
