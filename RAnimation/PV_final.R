library(ggplot2)
library(gganimate)
library(dplyr)
library(sf)
library(animation)

# Load the data
rates <- read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Adoption Animation/PV_final.csv")
towns <- rahul

# Merge the data
merged_data <- left_join(towns, rates, by = c("Town" = "Town", "Year" = "Year"))

# Create a logical matrix of missing values
missing_values <- is.na(merged_data)

# Count the number of missing values in each row
missing_counts <- rowSums(missing_values)

# Subset the merged data to only keep rows with no missing values
merged_data <- merged_data[missing_counts == 0, ]

# Convert the data to an sf object and calculate the centroids
d <- merged_data %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326) %>%
  st_centroid()

# Extract the 'Year' and 'r_PV' columns into separate variables
year <- as.numeric(as.character(d$Year))
rate <- d$Rate

# Add the 'Year' and 'r_PV' variables to the sf object as attributes
d <- st_as_sf(d,  crs = 4326, agr = "constant")
d$Year <- year
d$rate <- rate

# Create a ggplot object with the sf object as the data source
p <- ggplot() +
  geom_sf(data = d, aes(size = r_PV)) +
  scale_size_continuous(range = c(1, 10)) +
  transition_time(Year) +
  labs(title = "Year: {frame_time}")

# Animate the ggplot object and save as a gif file
animate(p, fps = 100, width = 800, height = 600)





