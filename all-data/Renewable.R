library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(stringr)
library(svglite)

data <- read.csv("~/Desktop/Selected_Energy_Consumption_Data_Updated.csv")
data <- data %>%
  filter(Year > 1990 & Year < 2024)
data$Year <- as.numeric(data$Year)
data

# Ensure unique combinations of Year and Description
data <- data %>%
  group_by(Year, Description) %>%
  summarize(Value = mean(Value, na.rm = TRUE), .groups = "drop")

# Reshape data
data_long <- data %>%
  pivot_wider(names_from = Description, values_from = Value) %>%
  pivot_longer(cols = -Year, names_to = "Energy_Source", values_to = "Consumption")

# Ensure Consumption is a double
data_long <- data_long %>%
  mutate(Consumption = as.double(Consumption))

print(data_long)

write.csv(data_long, "~/Desktop/data_long.csv")

data_long$Energy_Source <- factor(data_long$Energy_Source, 
                                  levels = c("Geothermal", "Solar", "Wind", "Hydroelectric", "Biomass")) 


p <- ggplot(data_long, aes(
  x = Year, 
  y = Consumption, 
  fill = Energy_Source
)) +  
  geom_area(alpha = 0.9) +
  scale_fill_manual(values = c(
    "Geothermal" = "#9ACD32",  # Dark Green
    "Solar" = "#7FFF00",       # Jade Green
    "Wind" = "#32CD32",        # Lime Green
    "Hydroelectric" = "#00A86B", # Chartreuse
    "Biomass" = "#006400"      # Pale Green
  )) +

  scale_x_continuous(breaks = seq(min(data_long$Year), 2023, by = 5)) +
  scale_y_continuous(breaks = seq(100, 1300, by = 100), limits = c(0, 1300)) +
  
  labs(title = "U.S. Renewable Energy Consumption Has Grown Over Time, but Slowly",  # New headline
       subtitle = "U.S. Primary Renewable Energy Consumption by Major Sources (1991-2023)",# Subheadline,
       x = "Year", 
       y = "Consumption (Quadrillion BTU)",
       fill = "Energy Source",
       caption = "Source: U.S. Energy Information Administration") +
  theme(
    plot.title = element_text(size = 15, face = "bold", color = "#006400" ),
    plot.subtitle = element_text(size = 12, color = "#006400" ),
    axis.title = element_text(size = 12, color = "#006400" ),
    legend.title = element_text(size = 12, color = "#006400" )
  )+
  theme(
    text = element_text(family = "sans"),
    panel.grid = element_blank(),          # Removes grid lines
    panel.background = element_blank(),    # Removes panel background
    plot.background = element_blank(),     # Removes outer background
    plot.margin = unit(c(1, 0.5, 1, 1.5), "cm"), # Eliminates margins
    axis.line = element_line(color = "black"), # Keeps axis lines
    axis.ticks = element_line(color = "black"), # Keeps ticks
    axis.text = element_text(size = 12),
    panel.grid.major.y = element_line(color = "lightgray", size = 0.5),
    plot.caption = element_text(size = 10, hjust = 0.5, color = "#006400" )# Adjust axis text size
  ) +
  coord_cartesian(expand = FALSE)  # Prevents axis expansion

print(p)

ggsave("renewable.svg", p)