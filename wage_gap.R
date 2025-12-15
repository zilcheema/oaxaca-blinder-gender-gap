library(tidyverse) # lets us use %>% (pipe operator), filter (to select rows), and ggplot
library(oaxaca)
library(carData) # Official StatCan Data (SLID)

data("SLID") # loads the dataset 
View(SLID)

# Remove missing values (NA)
# Convert 'Male'/'Female' to 0/1
real_data <- SLID %>%
  filter(!is.na(wages), !is.na(education), !is.na(age)) %>%
  mutate(is_male = ifelse(sex == "Male", 1, 0)) # If Sex is Male, make it 1. If Female, make it 0.


# Notice we now use 'is_male' (the number) instead of 'sex' (the text)
# Formula: Log Wage ~ Education + Age | Split by is_male
results_real <- oaxaca(log(wages) ~ education + age | is_male, data = real_data)
# In other words, wage depends on amount of education and your age.
# We run this regression twice for MALE and FEMALE. 
# Why are we logging wages? Because wages are skewed (a few billionaires distort the average)

# --- VISUALIZE ---
vals <- results_real$threefold$overall # Three-fold decomposition, splits the wage gap in 3 buckets
# endowments, coefficients and interaction

plot_data <- data.frame(
  Factor = c("Endowments", "Coefficients"),
  Amount = c(vals[1], vals[2])
)

# interaction (differences in endowments and coefficients), not in the code for simplicity
# vals[1] -> endowment effect, part of the gap explained by Education/Age
# vals[2] -> coefficient effect, unexplained/structural gap

plot_data$Factor <- factor(plot_data$Factor, levels = c("Endowments", "Coefficients"))
# R wants to plot alphabetically ("Coefficients" first). 
# We force it to respect our specific order: Endowments first, Coefficients second.

ggplot(plot_data, aes(x = Factor, y = Amount, fill = Factor)) +
  geom_col(width = 0.5) +
  theme_light() +
  scale_fill_manual(values = c("#3498db", "#e74c3c")) + 
  labs(
    title = "Decomposing the Ontario Gender Wage Gap",
    subtitle = "Real Data (SLID): Skills (Blue) vs. Structure (Red)",
    y = "Log Wage Gap Contribution",
    caption = "Source: Statistics Canada SLID"
  ) +
  geom_text(aes(label = round(Amount, 3)), vjust = -0.5)