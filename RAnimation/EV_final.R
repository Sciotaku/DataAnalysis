# Read in the two data frames
df1 <- read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Adoption Animation/r_PV_modified.csv")
df2 <- read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Adoption Animation/EV_final.csv")

# Merge the two data frames
merged_df <- merge(df1, df2, by = c("Town", "Year"))

library(dplyr)

# Join the two data frames
merged_df <- left_join(df2, df1[,c("Town", "Year", "Latitude", "Longitude")], by = c("Town", "Year"))

library(tidyr)

# fill missing latitude and longitude with the values from the previous year
df2_filled <- fill(merged_df, Latitude, Longitude)

data = df2_filled

class(data)

d <- data

head(d)

# Convert the data to an sf object and calculate the centroids
d <- d %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326) %>%
  st_centroid()

# Extract the 'Year' and 'Rate' columns into separate variables
year <- as.numeric(as.character(d$Year))
rate <- d$Rate

# Add the 'Year' and 'Rate' variables to the sf object as attributes
d <- st_as_sf(d,  crs = 4326, agr = "constant")
d$Year <- year
d$rate <- rate

# Create a ggplot object with the sf object as the data source
p <- ggplot() +
  geom_sf(data = d, aes(size = rate)) +
  scale_size_continuous(range = c(1, 10)) +
  transition_time(Year) +
  labs(title = "Year: {frame_time}")

# Animate the ggplot object and save as a gif file
anim <- animate(p, fps = 100, width = 800, height = 600)
anim_save("pumpanimation.gif", anim)

