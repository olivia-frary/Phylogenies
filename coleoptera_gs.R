library(tidyverse)

# create a data frame of only the Coleoptera (beetles)
df <- read_csv("insectgs.csv") %>%
  filter(Order == "Coleoptera")
# export a csv
