try( setwd(dirname(rstudioapi::getActiveDocumentContext()$path)))

plot.gradient <- function(r,col.extremes,m,sd){
  colfunc <- colorRampPalette(col.extremes)
  colours <- colfunc(250)
  y <- dnorm(r[1]:r[2], mean=m, sd=sd)
  df <- data.frame(y)
  df$col <- NA
  df$x <- 1

  y.steps <- seq(from=min(y), to=max(y), length.out = length(colours))
  for(i in 1:length(colours)){
    df$col[ df$y >= y.steps[i]]  <- colours[i]
  }
  png(filename = paste(paste(m,sd,col.extremes,sep="_"),".png", sep=""),
      height=400, width=900)
  barplot( df$x , space=0, col=df$col, border=NA, axes = FALSE)
  par(new=TRUE)
  plot(r[1]:r[2],x, type="n", yaxt = "n", ylab=NA, xlab=NA, bty='n', cex.axis=2)
  dev.off()
}

# some examples...
plot.gradient(c(1,500),c("darkblue", "white"),250,100)
plot.gradient(c(1,500),c("darkgreen", "white"),377,70)
plot.gradient(c(1,500),c("darkred", "white"),124,10)
plot.gradient(c(1,500),c("orange", "white"),178,200)
plot.gradient(c(1,500),c("purple", "white"),205,5)
plot.gradient(c(1,500),c("black", "white"),195,250)
plot.gradient(c(1,500),c("darkblue", "white"),350,50)
plot.gradient(c(1,500),c("darkgreen", "white"),85,100)
plot.gradient(c(1,500),c("darkred", "white"),380,400)
plot.gradient(c(1,500),c("orange", "white"),474,30)

