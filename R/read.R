#' Read the primary data
#'
#' Read the .csv files of tracking data

#' @describeIn read_family read the output from anTrax tracking
#' @export
#' @param  antrex_output_dir
#'
read.antrax_output <- function(antrex_output_dir) {
   table <- vroom(fs::dir_ls(path = antrex_output_dir, glob = "*_antxy.mat.csv"), id = "file", na = c("", "NA", "NaN")) # read all the file under antrex_folder using vroom, annotate NAs
   table$file <- basename(table$tracking_file) # only keep the basename of the file in the file column
   table
  }

#' @describeIn read_family transform the raw data into r readable pivot tibble
#' @export
#' @param  data
#'
transform.antrax_output <- function(data) {
   data.table::setDT(data) # use data.table format
   data[, frame:=1:.N, by = file] # group data by tracking file (colony) and add variable of frame
   # it's ridiculous that one need to include data.table in Depends of the package DESCRIPTION file to use :=
   data <- data.table::melt(data,
        id.vars = c("file", "frame"),
        measure.vars = measure(colour, value.name=function(x)ifelse(x==1, "x", "y"), sep="_")) # measure function only exist in development version
}

