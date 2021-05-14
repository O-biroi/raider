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
   setDT(data)
   data[, frame:=1:.N, by = tracking_file] # group data by tracking file (colony) and add variable of frame
   # it's ridiculous that one need to include data.table in Depends of the package DESCRIPTION file to use :=
   data <- melt(data,
        id.vars = c("tracking_file", "frame"),
        measure.vars = patterns("_[1,2]$"),
        variable.name = "colour_axis",
        value.name = "value") # reshape to long format, with each row represent the x,y axis of each individual at each frame
   data[, c("colour","axis"):=tstrsplit(colour_axis, "_", fixed=TRUE)][colour_axis := NULL] #split the colour and axis column
   data <- dcast(data,
         c("tracking_file", "frame", "colour") ~ axis,
         value.var = "value") # put x and y axis on the same row
}

