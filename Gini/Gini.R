library(dplyr)
library(ineq)
library(ggplot2)
library(usmap)

data = read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Political Polarization/countypres.csv")
df <- read.csv("/Users/rahulgupta/Dropbox (Dartmouth College)/Mac/Documents/Dartmouth/FYREE/Political Polarization/countypres.csv")

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

# Calculate the vote share for each party in each county for each election
df <- df %>%
  group_by(year, state, county_name, party) %>%
  summarise(total_votes = sum(candidatevotes)) %>%
  ungroup() %>%
  group_by(year, state, county_name) %>%
  mutate(total_county_votes = sum(total_votes),
         vote_share = total_votes/total_county_votes) %>%
  select(-total_votes, -total_county_votes)

# Print the first few rows of the resulting dataset
head(df)

# Calculate the polarization score using the Gini coefficient

df_polarization <- df %>%
  group_by(year, state, county_name) %>%
  summarise(gini_coef = 1 - ineq(vote_share, type = "Gini"))

# Print the first few rows of the resulting dataset
head(df_polarization)

# Filter the data for the 2020 election
df_polarization_2020 <- df_polarization %>%
  filter(year == 2020)

# Create a heat map of the polarization scores

ggplot(df_polarization_2020, aes(x = county_name, y = state, fill = gini_coef)) +
  geom_tile() +
  scale_fill_gradient(low = "red", high = "white") + # reverse the order of the color gradient
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Polarization Scores for US Counties in the 2020 Presidential Election")


# Filter the data for the 2016 and 2020 elections
df_polarization_16_20 <- df_polarization %>%
  filter(year %in% c(2016, 2020))

# Create a scatter plot of the polarization scores

ggplot(df_polarization_16_20, aes(x = gini_coef, y = year, color = county_name)) +
  geom_point(size = 3) +
  scale_color_manual(values = scales::hue_pal()(51)) +
  facet_wrap(~state, ncol = 5, scales = "free_x") +
  theme(legend.position = "none") +
  labs(x = "Polarization Score (Gini Coefficient)", y = "Year",
       title = "Polarization Scores for US Counties in the 2016 and 2020 Presidential Elections")


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

                       
