library(ggplot2)
library(gganimate)
library(gifski)

house_data <- read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Adoption Animation/house_data.csv")
head(house_data)

which_state <- "washington"
county_info <- map_data("county", region=which_state)
base_map <- ggplot(data = county_info, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", fill = "white") +
  coord_quickmap() +
  theme_void()
base_map

min_long <- min(house_data$long)
max_long <- max(house_data$long)
min_lat <- min(house_data$lat)
max_lat <- max(house_data$lat)
num_years <- max(house_data$yr_built) - min(house_data$yr_built) + 1

map_with_data <- base_map +
  geom_point(data = house_data, aes(x = long, y = lat, group=yr_built)) +
  coord_quickmap(xlim = c(min_long, max_long),  ylim = c(min_lat, max_lat)) +
  transition_time(yr_built) +
  ggtitle('Year: {frame_time}',
          subtitle = 'Frame {frame} of {nframes}') +
  shadow_mark()
animate(map_with_data, nframes = num_years, fps = 2)

map_with_data <- base_map +
  geom_point(data = house_data, aes(x = long, y = lat, group=yr_built, color=price)) +
  coord_quickmap(xlim = c(min_long, max_long),  ylim = c(min_lat, max_lat)) +
  transition_time(yr_built) +
  ggtitle('Year: {frame_time}',
          subtitle = 'Frame {frame} of {nframes}') +
  shadow_mark() +
  scale_color_gradient(low = "green", high = "red")
animate(map_with_data, nframes = num_years, fps = 2)

map_with_data <- base_map +
  geom_point(data = house_data, aes(x = long, y = lat, group=yr_built, color=price)) +
  coord_quickmap(xlim = c(min_long, max_long),  ylim = c(min_lat, max_lat)) +
  transition_time(yr_built) +
  ggtitle('Year: {frame_time}',
          subtitle = 'Frame {frame} of {nframes}') +
  shadow_mark() +
  scale_color_gradientn(colors = rainbow(7))
animate(map_with_data, nframes = num_years, fps = 2)

map_with_data <- base_map +
  geom_point(data = house_data, aes(x = long, y = lat, group=yr_built, color=price)) +
  coord_quickmap(xlim = c(min_long, max_long),  ylim = c(min_lat, max_lat)) +
  transition_time(yr_built) +
  ggtitle('Year: {frame_time}',
          subtitle = 'Frame {frame} of {nframes}') +
  shadow_mark() +
  scale_color_gradientn(colors = palette())
animate(map_with_data, nframes = num_years, fps = 2)


