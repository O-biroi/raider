# testing
format(object.size(data.frame(rep(1, 1e8))), "MB")
write.csv(data.frame(rep(1, 1e8)), file = "large.csv")
vroom("large.csv", delim = ",")

library(tidyverse)
library(fs)
library(vroom)
library(dtplyr)

genetic_data <- read.antrax_output(antrex_output_dir = "/Users/zimai/polybox/DoctorToBe/01 Project documents/ZIM00 General documents /tracking/Mix colony networks/1 Data/1 Raw data/01 Position/")

genetic_data_cut <- genetic_data %>%
  group_by(tracking_file) %>%
  slice_head(n = 1000) %>%
  ungroup()

foo <- tranform.antrax_output(genetic_data_cut)

