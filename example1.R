library(ggplot2)
library(gganimate)
library(gifski)

center_lat <- 37.8
center_long <- -122.4
width <- 0.2
num_points <- 500
test_data <- data.frame('lat'=rnorm(num_points, mean=center_lat, sd=width),
                        'long'=rnorm(num_points, mean=center_long, sd=width),
                        'year'=floor(runif(num_points, min=1990, max=2020)),
                        'temp'=runif(num_points, min=-10, max=40)
)

which_state <- "california"
county_info <- map_data("county", region=which_state)
head(county_info)

base_map <- ggplot(data = county_info, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", fill = "white") +
  coord_quickmap() +
  theme_void()

base_map

map_with_data <- base_map +
  geom_point(data = test_data, aes(x = long, y = lat, group=year))
map_with_data

min_long <- min(test_data$long)
max_long <- max(test_data$long)
min_lat <- min(test_data$lat)
max_lat <- max(test_data$lat)
map_with_data <- map_with_data +
  coord_quickmap(xlim = c(min_long, max_long),  ylim = c(min_lat, max_lat))
map_with_data

map_with_data <- base_map +
  geom_point(data = test_data, aes(x = long, y = lat, color=temp, group=year)) +
  coord_quickmap(xlim = c(min_long, max_long),  ylim = c(min_lat, max_lat))
map_with_data

map_with_data <- base_map +
  geom_point(data = test_data, aes(x = long, y = lat, color=temp, size=temp, group=year)) +
  coord_quickmap(xlim = c(min_long, max_long),  ylim = c(min_lat, max_lat))

map_with_data

map_with_animation <- map_with_data +
  transition_time(year) +
  ggtitle('Year: {frame_time}',
          subtitle = 'Frame {frame} of {nframes}')
num_years <- max(test_data$year) - min(test_data$year) + 1
animate(map_with_animation, nframes = num_years)

map_with_shadow <- map_with_animation +
  shadow_mark()
animate(map_with_shadow, nframes = num_years)

animate(map_with_shadow, nframes = num_years, fps = 2)

anim_save("example1.gif")

anim_save("example1.gif", map_with_shadow, nframes = num_years, fps = 2)
