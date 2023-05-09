library(ggplot2)
library(gganimate)
library(gifski)
library(dplyr)
library(transformr)
library(maps)
library(sf)

data = rahul

# Convert the geometry column to an sf object
data_sf <- st_as_sf(data, wkt = "geometry")

# Extract the centroids of each town
centroids <- st_centroid(data_sf)

# Extract the centroids of each town and combine with the data
centroids_df <- st_centroid(data_sf) %>% st_coordinates() %>% as.data.frame()
centroids_df$r_PV <- data$r_PV
year <- as.numeric(as.character(d$Year))

p <- ggplot() +
  geom_sf(data = data_sf %>%
            mutate(Year = as.integer(Year)), fill = "white", color = "black") +
  geom_point(data = na.omit(centroids_df), aes(x = X, y = Y, size = r_PV), color = "red") +
  scale_size_continuous(range = c(1, 10)) +
  transition_time(Year) +
  labs(title = "Year: {frame_time}") +
  coord_sf(default_crs = st_crs(data_sf))

# Animate the ggplot object and save as a gif file
animate(p, fps = 10, width = 800, height = 600)




