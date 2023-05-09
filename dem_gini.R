library(dplyr)
library(ineq)
library(ggplot2)

# Read the data from a csv file
df <- read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Political Polarization/countypres.csv")
data = df

# Select only the necessary columns
df <- select(df, year, state, county_name, party, candidatevotes, totalvotes)

# Get the unique parties for each election in each county
parties <- df %>%
  group_by(year, state, county_name) %>%
  distinct(party) %>%
  filter(!is.na(party)) %>%
  pull(party)

# Print the unique parties
unique(parties)

# Create a binary variable indicating whether a county voted for Democrats or Republicans
df_binary <- df %>%
  group_by(year, state, county_name) %>%
  summarise(dem_vote = sum(candidatevotes[party == "DEMOCRAT"]),
            rep_vote = sum(candidatevotes[party == "REPUBLICAN"]),
            total_votes = sum(totalvotes)) %>%
  ungroup() %>%
  mutate(voted_dem = ifelse(dem_vote > rep_vote, 1, 0))

# Print the first few rows of the resulting dataset
head(df_binary)

# Calculate the polarization score using the Gini coefficient
df_polarization <- df_binary %>%
  group_by(year, state) %>%
  summarise(gini_coef = ineq(voted_dem, type = "Gini"))

# Print the first few rows of the resulting dataset
head(df_polarization)

# Filter the data for the 2020 election
df_polarization_2020 <- df_polarization %>%
  filter(year == 2020)

# Remove rows with missing values
df_polarization_2020 <- df_polarization_2020[complete.cases(df_polarization_2020), ]

# Filter the data for the 2020 election and remove NaN values
df_polarization_2020 <- df_polarization %>%
  filter(year == 2020 & !is.na(gini_coef))

# Create a heat map of the polarization scores
ggplot(df_polarization_2020, aes(x = state, fill = gini_coef)) +
  geom_tile(aes(y = 1), color = "white") +
  scale_fill_gradient(low = "white", high = "red") +
  ggtitle("Polarization Scores for US States in the 2020 Presidential Election")

# Filter the data for the 2016 and 2020 elections
df_polarization_16_20 <- df_polarization %>%
  filter(year %in% c(2016, 2020))

# Create a scatter plot of the polarization scores
ggplot(df_polarization_16_20, aes(x = gini_coef, y = year, color = state)) +
  geom_point(size = 3) +
  scale_color_manual(values = scales::hue_pal()(51)) +
  facet_wrap(~state, ncol = 5, scales = "free_x") +
  theme(legend.position = "none") +
  labs(x = "Polarization Score (Gini Coefficient)", y = "Year",
       title = "Polarization Scores for US States in the 2016 and 2020 Presidential Elections")

df_polarization_2020 <- merge(df_polarization_2020, data)
results <- rename(df_polarization_2020, fips = county_fips)

# Generate color palette
library(RColorBrewer)
colors <- brewer.pal(n = 12, name = "Paired")

plot_usmap(data = results,
           values = "gini_coef",
           color = "white") +
  scale_fill_gradientn(colors = colors,
                       name = "Political Polarization",
                       label = scales::comma) +
  labs(title = "United States",
       subtitle = "Presidential Election Data from 2000 to 2020") +
  theme(legend.position = "right")

