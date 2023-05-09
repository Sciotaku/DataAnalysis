library(tidyverse)
library(sf)
library(dplyr)

# Load data
rates <- read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Adoption Animation/newdata.csv")
towns <- rahul

towns$geometry <- st_cast(towns$geometry, "MULTIPOLYGON")

# Identify duplicate rows based on town name
duplicate_rows <- duplicated(towns$Town)

# Remove duplicate rows
towns <- towns[!duplicate_rows, ]

Edu <- rates[, 8]

ggplot() +
  geom_sf(data = towns, aes(fill = Edu)) +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Town Education Levels")
