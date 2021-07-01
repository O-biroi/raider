# Ant movement simple
library(gganimate)

# define the scale of x and y -> the space of movement
xscale <- c(-100:100)
yscale <- c(-100:100)
timescale <- 2000

# create the starting vector (x, y, 0)
# the starting point will be randomly chosen by sample from the
session <- data.frame(x = numeric(),
                      y = numeric(),
                      t = integer())
x_init <- sample(xscale, 1, replace = TRUE)
y_init <- sample(yscale, 1, replace = TRUE)
session[1,] = c(x_init, y_init, 1)
direction_init <- runif(1, min = -2*pi, max = 2*pi )


# create threshold level of movement
max_speed <- 2


# create a movement session
for (i in 1:timescale){
  # calculate next step direction
    # if i = 1, initial direction
    # if i > 1, current direction (calculated by the tangent of the current step
    # and the step before) + a direction changer (normal distribution)
  direction <- ifelse(i = 1, direction_init, rnorm(-pi, pi) + atan((session[i,]$y - session[i-1,]$y)/(session[i,]$x - session[i-1,]$x)))
  x_change <- rnorm(-max_speed, max_speed)
  y_change
  c(sample(-1:1, 1), sample(-1:1, 1), 1)

  # judge whether ant is at the edge of the area
  # add new rows
  session[nrow(session) + 1, ] <- session[nrow(session), ]
  # if the new location exceed the scale of area, retreat one step back
  if (abs(session[nrow(session),]$x) - abs(max(xscale)) > 0){session[nrow(session),]$x <- session[nrow(session) -1 ,]$x}
  if (abs(session[nrow(session),]$y) - abs(max(yscale)) > 0){session[nrow(session),]$y <- session[nrow(session) -1 ,]$y}
  i <- i + 1
}

data.frame(lapply(session, as.integer)) %>%
  ggplot(aes(x = x, y = y)) +
    geom_point(size = 0.5) +
    lims(x = c(-100,100), y = c(-100,100)) +
    transition_reveal(t) +
    labs(title = "Time : {frame_along}")



