library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(stringr)
library(svglite)

data <- read.csv("~/Desktop/production2.csv")
data
data$Year <- as.numeric(data$Year)
data_long <- data %>%
  pivot_wider(names_from = Description, values_from = Value) %>% # Reshape to wide format
  pivot_longer(cols = -Year, names_to = "Energy_Source", values_to = "Consumption") # Reshape back to long format

data_long

data_long$Energy_Source <- factor(data_long$Energy_Source, 
                                  levels = c("Renewables", "Nuclear", "Petroleum", "Natural Gas", "Coal")) # Specify your desired order
p <- ggplot(data_long, aes(
  x = Year, 
  y = Consumption, 
  fill = Energy_Source
)) +  
  geom_area(alpha = 0.9) +
  scale_fill_manual(values = c(
    "Renewables" = "#caf0f8",    # Light blue (softer for Renewables)
    "Nuclear" = "#90e0ef",      # Soft yellow
    "Coal" = "#03045e",         # Deep maroon
    "Natural Gas" = "#0077b6",  # Bold red
    "Petroleum" = "#00b4d8"   # Vibrant orange
  )) +
  scale_x_continuous(breaks = seq(1950, 2023, by = 10)) +
  scale_y_continuous(breaks = seq(10, 105, by = 10), limits = c(0, 105)) +
  labs(title = "Petroleum Remains Dominant in U.S. Energy Consumption",  # New headline
       subtitle = "U.S. Primary Energy Consumption by Major Sources (1950-2023)",# Subheadline,
       x = "Year", 
       y = "Consumption (Quadrillion BTU)",
       fill = "Energy Source",
       caption = "Source: U.S. Energy Information Administration") +
  theme(
    plot.title = element_text(size = 15, face = "bold", color = "#03045e"),
    plot.subtitle = element_text(size = 12, color = "#03045e"),
    axis.title = element_text(size = 12, color = "#03045e"),
    legend.title = element_text(size = 12, color = "#03045e")
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
    plot.caption = element_text(size = 10, hjust = 0.5, color = "#03045e")# Adjust axis text size
  ) +
  coord_cartesian(expand = FALSE)  # Prevents axis expansion
  
p

ggsave("consumption2.svg", p)