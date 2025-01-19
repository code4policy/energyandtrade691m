library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(stringr)
library(svglite)

data <- read.csv("~/Desktop/primary-energy-production-by-major-source-history.csv")
data <- data %>%
  mutate (Petroleum = Crude.Oil + NGPL)
data$Crude.Oil <- NULL
data$NGPL <- NULL

data

data_long <- data %>%
  pivot_longer(cols = -Year, 
               names_to = "Energy_Source", 
               values_to = "Production",
  )%>%
  mutate(Production = round(Production, 2))
data_long


data_long$Energy_Source <- str_replace_all(data_long$Energy_Source, "\\.", " ")


head(data_long)

# Add a temporary column for tooltip text
data_long$tooltip_text <- paste(
  "Year: ", data_long$Year, "<br>",
  "Production: ", data_long$Production, "<br>",
  "Energy Source: ", data_long$Energy_Source
)
data_long

data_long$Energy_Source <- factor(data_long$Energy_Source, 
                                  levels = c("Renewables", "Nuclear", "Petroleum", "Natural Gas", "Coal")) # Specify your desired order

# Create the ggplot with dynamic tooltip
p <- ggplot(data_long, aes(
    x = Year, 
    y = Production, 
    fill = Energy_Source,
    label = tooltip_text,
  )) +  
  geom_area(alpha = 0.9) +
  scale_fill_manual(values = c(
    "Renewables" = "#EFFD6F",    # Light blue (softer for Renewables)
    "Nuclear" = "#FFBF00",      # Soft yellow
    "Coal" = "#800000",         # Deep maroon
    "Natural Gas" = "#D73027",  # Bold red
    "Petroleum" = "#F4A460"   # Vibrant orange
  )) +
  scale_x_continuous(breaks = seq(min(data_long$Year), max(data_long$Year), by = 10)) +
  scale_y_continuous(breaks = seq(10, 105, by = 10), limits = c(0, 105)) +
  labs(title = "U.S. Energy Production Surges with Natural Gas Leading the Way",  # New headline
       subtitle = "U.S. Primary Energy Production by Major Sources (1950-2023)",# Subheadline,
       x = "Year", 
       y = "Production (Quadrillion BTU)",
       fill = "Energy Source",
       caption = "Source: U.S. Energy Information Administration") +
  theme(
    plot.title = element_text(size = 15, face = "bold", color = "#990000"),
    plot.subtitle = element_text(size = 12, color = "#990000"),
    axis.title = element_text(size = 12, color = "#990000"),
    legend.title = element_text(size = 12, color = "#990000")
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
    plot.caption = element_text(size = 10, hjust = 0.5, color = "#990000")# Adjust axis text size
  ) +
  coord_cartesian(expand = FALSE)  # Prevents axis expansion
p


ggsave("production.svg", p)


