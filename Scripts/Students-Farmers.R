# Load the necessary libraries
library(tidyverse)
library(dplyr)
library(ggplot2)

# Assuming your data frame is named final_cleaned_df
# Create a new data frame with the specified columns
first_plot_data <- final_cleaned_df %>%
  select(state_violence, clean_identity, gwf_democracy)

# View the new data frame
print(first_plot_data)

# Group and summarize the data for students and farmers
summary_data_farmers <- first_plot_data %>%
  mutate(category = case_when(
    clean_identity %in% c("students", "farmers & students") ~ "Students",
    clean_identity %in% c("farmers", "farmers & students") ~ "Farmers",
    TRUE ~ "Other"
  )) %>%
  filter(category %in% c("Students", "Farmers")) %>%
  group_by(gwf_democracy, category) %>%
  summarize(
    total = n(),
    state_violence_count = sum(state_violence == 1),
    .groups = 'drop'
  ) %>%
  mutate(
    percentage = (state_violence_count / total) * 100,
    gwf_democracy = recode(gwf_democracy, `0` = "non-democratic", `1` = "democratic")
  )

# View the summarized data for students and farmers
print(summary_data_farmers)

# Plot the column chart for students and farmers using ggplot2
ggplot(summary_data_farmers, aes(x = gwf_democracy, y = percentage, fill = category)) +
  geom_col(position = "dodge") +
  geom_text(aes(label = state_violence_count), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    title = "Percentage of protests that encountered State Violence by Democracy for Students and Farmers",
    x = "Democracy",
    y = "Percentage of protests that encountered State Violence",
    fill = "Category"
  ) +
  theme_minimal()

# Group and summarize the data for students and medical workers
summary_data_medical <- first_plot_data %>%
  mutate(category = case_when(
    clean_identity %in% c("students", "farmers & students", "medical workers & students") ~ "Students",
    clean_identity %in% c("medical workers", "medical workers & students") ~ "Medical Workers",
    TRUE ~ "Other"
  )) %>%
  filter(category %in% c("Students", "Medical Workers")) %>%
  group_by(gwf_democracy, category) %>%
  summarize(
    total = n(),
    state_violence_count = sum(state_violence == 1),
    .groups = 'drop'
  ) %>%
  mutate(
    percentage = (state_violence_count / total) * 100,
    gwf_democracy = recode(gwf_democracy, `0` = "non-democratic", `1` = "democratic")
  )

# View the summarized data for students and medical workers
print(summary_data_medical)

# Plot the column chart for students and medical workers using ggplot2
ggplot(summary_data_medical, aes(x = gwf_democracy, y = percentage, fill = category)) +
  geom_col(position = "dodge") +
  geom_text(aes(label = state_violence_count), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    title = "Percentage of protests that encountered State Violence by Democracy for Students and Medical Workers",
    x = "Democracy",
    y = "Percentage of protests that encountered State Violence",
    fill = "Category"
  ) +
  theme_minimal()
