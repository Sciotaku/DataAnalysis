library(ggplot2)
library(gganimate)
library(gifski)
library(dplyr)
library(transformr)
library(maps)
library(sf)

data = rahul

class(data)

d <- data %>%
  st_centroid()

head(d)

df = d
# Convert the 'geometry' column to a sf POINT object
df_sf <- st_as_sf(df, coords = c("geometry"))

# Extract the 'Latitude' and 'Longitude' coordinates into separate columns
df_sf$Latitude <- st_coordinates(df_sf)[, 2]
df_sf$Longitude <- st_coordinates(df_sf)[, 1]

# Convert the sf POINT object back to a data frame
df <- as.data.frame(df_sf)

d %>%
  ggplot() +
  geom_sf()




