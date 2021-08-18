# library
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(tidyverse)
library(viridis)
library(forcats)

outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/analysis"
filename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/analysis/phenotype.asd"
data = read.table(filename, header=TRUE, sep="\t", na = "NA")

# Build dataset with different distributions
data <- data.frame(
  type = data['Genotype'],
  value = data['TOTAL_SOLUBLE_SOLIDS']
)

# Represent it
p <- data %>%
  ggplot( aes(x=TOTAL_SOLUBLE_SOLIDS, fill=Genotype)) +
  geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  theme_ipsum() +
  labs(fill="")

p


