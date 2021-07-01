#' Read the primary data
#'
#' Read the .csv files of tracking data

#' @describeIn read_family read the output from anTrax tracking
#' @export
#' @param antrax_output_dir full path of directory where files are saved
#' @param suffix suffix of file names
#' @param col_names Either TRUE, FALSE or a character vector of column names.
#'   If TRUE, the first row of the input will be used as the column names, and
#'   will not be included in the data frame. If FALSE, column names will be
#'   generated automatically: X1, X2, X3 etc. If col_names is a character vector,
#'   the values will be used as the names of the columns, and the first row of
#'   the input will be read into the first row of the output data frame.

read_antrax_output <- function(antrax_output_dir, suffix, col_names = TRUE) {
   table <- vroom::vroom(fs::dir_ls(path = antrax_output_dir, glob = suffix), col_names = col_names, id = "file", na = c("", "NA", "NaN")) # read all the file under antrex_folder using vroom, annotate NAs
   table$file <- basename(table$file) # only keep the basename of the file in the file column
   table
  }

#' @describeIn read_family transform the raw data into r readable pivot tibble
#' @export
#' @param  data
#'
transform_antrax_output <- function(data) {
   data.table::setDT(data) # use data.table format
   data[, frame:=1:.N, by = file] # group data by tracking file (colony) and add variable of frame
   # it's ridiculous that one need to include data.table in Depends of the package DESCRIPTION file to use :=
   data <- data.table::melt(data,
        id.vars = c("file", "frame"),
        measure.vars = measure(colour, value.name=function(x)ifelse(x==1, "x", "y"), sep="_")) # measure function only exist in development version
}

