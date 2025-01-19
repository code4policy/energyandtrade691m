
library(readxl)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(stringr)
library(svglite)

# Load the Excel data
data <- read_excel("Desktop/Book5.xlsx", sheet = "Sheet1")
data
colnames(data) <- c("Year", "RenewableEnergy")

# Create the line chart
p <- ggplot(data, aes(x = Year, y = RenewableEnergy)) +
  geom_line(color = "#006400", size = 1) +  # Add the line
  scale_x_continuous(breaks = seq(1950, 2023, by = 10)) +
  scale_y_continuous(breaks = seq(500, 3500, by = 500), limits = c(0, 3500)) +
  labs(title = "Renewable Consumption in Electric Power Sector: A Journey toward Dominance",  # New headline
       subtitle = "U.S. Renewable Energy Consumption in Electric Power Sector (1950-2023)",# Subheadline,
       x = "Year", 
       y = "Consumption (Quadrillion BTU)",
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
p

ggsave("electric.svg", p)