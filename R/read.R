#' Read the primary data
#'
#' Read the .csv files of tracking data

#' @describeIn read_family read the output from anTrax tracking
#' @export
#' @param  antrex_output_dir
#'
read.antrax_output <- function(antrex_output_dir) {
   table <- vroom(fs::dir_ls(path = antrex_output_dir, glob = "*_antxy.mat.csv"), id = "tracking_file", na = c("", "NA", "NaN")) # read all the file under antrex_folder using vroom, annotate NAs
   table$tracking_file <- basename(table$tracking_file) # only keep the basename of the file in the tracking_file column
   table
  }

#' @describeIn read_family transform the raw data into r readable pivot tibble
#' @export
#' @param  data
#'
tranform.antrax_output <- function(data) {
  data %>%
    dplyr::group_by(.data$tracking_file) %>% # group data by tracking file (colony)
    dplyr::mutate(frame = row_number()) %>% # add variable of frame
    dplyr::ungroup() %>%
    tidyr::pivot_longer(cols = !.data$tracking_file & !.data$frame, names_to = "colour_axis", values_to = "value") %>% # make colour and axis as one variable of the column
    tidyr::separate(col = .data$colour_axis, into = c("colour", "axis"), sep = "_") %>% # separate colour and axis into different variables
    tidyr::pivot_wider(names_from = .data$axis, values_from = .data$value) %>% # make x and y axis into different variables
    dplyr::rename(x = `1`, y = `2`) # rename x and y axis
}
