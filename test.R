# testing
format(object.size(data.frame(rep(1, 1e8))), "MB")
write.csv(data.frame(rep(1, 1e8)), file = "large.csv")
vroom("large.csv", delim = ",")

library(tidyverse)
library(fs)
library(vroom)
library(profvis)

genetic_data <- read.antrax_output(antrex_output_dir = "/Users/zimai/polybox/DoctorToBe/01 Project documents/ZIM00 General documents /tracking/Mix colony networks/1 Data/1 Raw data/01 Position/")
genetic_data <- read.antrax_output(antrex_output_dir = "/Volumes/Elements/01 Position/")
genetic_data_cut <- genetic_data %>%
  group_by(file) %>%
  slice_head(n = 10000) %>%
  ungroup()

saveRDS(genetic_data_cut, file = "test.rds")

foo_full <- transform.antrax_output(genetic_data)
vroom("/Volumes/Elements/01 Position/Genetic_B1_antxy.mat.csv")

genetic_data_cut <- readRDS("test")
setnames(genetic_data_cut, "tracking_file", "file")

foo <- transform.antrax_output(genetic_data_cut)

transform.antrax_output <- function(data) {
  data.table::setDT(data) # use data.table format
  data[, frame:=1:.N, by = tracking_file] # group data by tracking file (colony) and add variable of frame
  # it's ridiculous that one need to include data.table in Depends of the package DESCRIPTION file to use :=
}
