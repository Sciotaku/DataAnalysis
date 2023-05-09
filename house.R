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

house <- rates[, 6]

ggplot() +
  geom_sf(data = towns, aes(fill = house)) +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "House Ownership")
