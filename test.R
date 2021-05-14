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



data %>%
  dplyr::group_by(.data$tracking_file) %>% # group data by tracking file (colony)
  dplyr::mutate(frame = row_number()) %>% # add variable of frame
  dplyr::ungroup() %>%
  tidyr::pivot_longer(cols = !.data$tracking_file & !.data$frame, names_to = "colour_axis", values_to = "value") %>% # make colour and axis as one variable of the column
  tidyr::separate(col = .data$colour_axis, into = c("colour", "axis"), sep = "_") %>% # separate colour and axis into different variables
  tidyr::pivot_wider(names_from = .data$axis, values_from = .data$value) %>% # make x and y axis into different variables
  dplyr::rename(x = `1`, y = `2`) # rename x and y axis
