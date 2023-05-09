library(ggplot2)
library(gganimate)
library(gifski)
library(dplyr)
library(transformr)
library(maps)
library(sf)

data = rahul

data <- st_as_sf(data, wkt="geometry")

data <- data %>%
  group_by(Town, Year) %>%
  summarize(Total_Number = sum(Number), r_PV = mean(r_PV), geometry = st_combine(geometry)) %>%
  ungroup()

ggplot(data) +
  geom_sf(aes(fill = r_PV), color = NA) +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Total Number of Towns", x = "Longitude", y = "Latitude") +
  transition_time(Year) + 
  labs(title = "Year: {frame_time}")




