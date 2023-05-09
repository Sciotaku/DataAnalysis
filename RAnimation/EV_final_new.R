library(ggplot2)
library(gganimate)
library(gifski)
library(dplyr)
library(transformr)
library(maps)
library(sf)

data = rahul

df = read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Adoption Animation/EV_final.csv")

# merge the datasets based on town and year
merged_df <- merge(data, df, by = c("Town", "Year"), all.x = TRUE)

# replace any missing rate values with 0
merged_df$Rate[is.na(merged_df$Rate)] <- 0

df <- merged_df

# Convert the geometry column to an sf object
data_sf <- st_as_sf(df, wkt = "geometry")

# Extract the centroids of each town
centroids <- st_centroid(data_sf)

# Extract the centroids of each town and combine with the data
centroids_df <- st_centroid(data_sf) %>% st_coordinates() %>% as.data.frame()
centroids_df$rate <- df$Rate
year <- as.numeric(as.character(df$Year))

p <- ggplot() +
  geom_sf(data = data_sf %>%
            mutate(Year = as.integer(Year)), fill = "white", color = "black") +
  geom_point(data = na.omit(centroids_df), aes(x = X, y = Y, size = rate), color = "red") +
  scale_size_continuous(range = c(1, 10)) +
  transition_time(Year) +
  labs(title = "Year: {frame_time}") +
  coord_sf(default_crs = st_crs(data_sf))

# Animate the ggplot object and save as a gif file
anim <- animate(p, fps = 10, width = 800, height = 600)

anim_save("EV.gif", anim)



