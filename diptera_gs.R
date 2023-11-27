library(tidyverse)

# create a data frame of only the Coleoptera (beetles)
df <- read_csv("insectgs.csv") %>%
  filter(Order == "Diptera")
# export a csv
write.csv(df$Name, "diptera_species.csv", row.names = FALSE)
