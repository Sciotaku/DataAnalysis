library(ggplot2)
library(gganimate)
library(gifski)
library(dplyr)
library(transformr)
library(maps)
library(sf)

# Load the data
data = read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Adoption Animation/r_PV_modified.csv")

class(data)

df = data

# Convert the data to an sf object and calculate the centroids
d <- df %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326) %>%
  st_centroid()

# Extract the 'Year' and 'r_PV' columns into separate variables
year <- as.numeric(as.character(d$Year))
r_pv <- d$r_PV

# Add the 'Year' and 'r_PV' variables to the sf object as attributes
d <- st_as_sf(d,  crs = 4326, agr = "constant")
d$Year <- year
d$r_PV <- r_pv

# Create a ggplot object with the sf object as the data source
p <- ggplot() +
  geom_sf(data = d, aes(size = r_PV)) +
  scale_size_continuous(range = c(1, 10)) +
  transition_time(Year) +
  labs(title = "Year: {frame_time}")

# Animate the ggplot object and save as a gif file
animate(p, fps = 100, width = 800, height = 600)
