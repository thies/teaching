###########################
#
# INDEX EXAMPLES
# Thies Lindenthal
#
###########################
try( setwd(dirname(rstudioapi::getActiveDocumentContext()$path)))
try(dir.create("imgs"))

# Load additional libraries
if (!require("stargazer")) {
  install.packages("stargazer")
  library(stargazer)
}

## Colour scheme
colour <- c("#230356","#076391","#2fd1d1","#b51676","#e90d3a","#f98e19","#ffc217")


# Load Land Registry data, residential, Cambridge
sales <- read.csv("sales_cambridge.csv", as.is=TRUE, header=FALSE)
# this file is based on the complete sales file, 
# downloaded here: http://prod1.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv
# and then filtered for all lines that contain ',"CAMBRIDGE",'

colnames(sales) <- c("id","price","date","postcode","propertytype","new","estatetype","paon","saon","street","locality","town","district","county","PPDcategory","recordstatus")
sales$date <- strptime(sales$date,"%Y-%m-%d")
# create time dummy variables, monthly and yearly
sales$month <- format(sales$date, format="%Y-%m" )
sales$year <- format(sales$date, format="%Y")
# exclude type "Other"
sales <- subset(sales, propertytype != "O")
print(dim(sales))

### Summary Statistics of the Data
# basic summary statistics for "Price"
summary(sales$price)
# histograms etc.
jpeg(file="imgs/hist.jpg", width=1800, height=800, quality=100)
par(mar = c(6,6,6,2))
hist(log(sales$price), breaks=50, xlab="ln(price, in GBP)", col="lightblue", main="Distribution of Prices",
     border="white", cex=2, cex.axis=2, cex.lab=2, cex.main=3)
box()
dev.off()

# breakdown by years
barplot(table(sales$year), main="Distribution of transactions in time")

# barplot property types
jpeg(file="imgs/barplot_types.jpg", width=1400, height=800, quality=100)
  par(mar = c(6,6,6,2))
  barplot(table(sales$propertytype), main="Distribution of property types", col=colour, xlab="F=Flat, S=Semi-detached, D=Detached, T=Terraced", cex=2, cex.axis=2, cex.lab=2, cex.main=3, ylab="Frequency")
  box()
dev.off()



#============================
## INDICES

### Mean and median price per year


mean <- tapply(sales$price, sales$year, mean, na.rm=TRUE)
indices <- as.data.frame(mean)
colnames(indices) <- "mean"
indices$year <- row.names(indices)
# plot
jpeg(file="imgs/index_means.jpg", width=1400, height=800, quality=100)
par(mar = c(6,6,6,2))
plot(indices$year,
     indices$mean, 
     type='l',
     xlab="Year", 
     ylab="Average Price (GBP)", 
     lwd=7,
     main="Average Price",
     col="red",
     cex=2, cex.axis=2, cex.lab=2, cex.main=3
     )
dev.off()


# Medians, less influenced by outliers
median <- tapply(sales$price, sales$year, median, na.rm=TRUE)
tmp <- as.data.frame(median)
colnames(tmp) <- "median"
tmp$year <- row.names(tmp)
indices <- merge(indices, tmp, by="year", all=TRUE)
# plot
jpeg(file="imgs/index_medians.jpg", width=1400, height=800, quality=100)
par(mar = c(6,6,6,2))
plot(indices$year,
     indices$mean, 
     type='l',
     xlab="Year", 
     ylab="Average Price (GBP)", 
     lwd=7,
     main="Average Price",
     col=colour[5],
     cex=2, cex.axis=2, cex.lab=2, cex.main=3
)
lines(indices$year, indices$median, lwd=7, col=colour[1])
legend("topleft",c("Mean","Median"), lwd=7, col=colour[c(5,1)], bty="n", cex=2)
dev.off()



# rebase, 1995=100
rebase <- function(x, base=1, cols){
  for(col in cols){
    x[,col] <- (x[,col]/x[base,col])*100
  }
  return(x)
}
indices <- rebase(indices, 1, c("mean","median"))
# plot
jpeg(file="imgs/index_medians_rebased.jpg", width=1400, height=800, quality=100)
par(mar = c(6,6,6,2))
plot(indices$year,
     indices$mean, 
     type='l',
     xlab="Year", 
     ylab="Average Price (GBP)", 
     lwd=7,
     main="Average Price",
     col=colour[5],
     cex=2, cex.axis=2, cex.lab=2, cex.main=3
)
lines(indices$year, indices$median, lwd=7, col=colour[1])
legend("topleft",c("Mean","Median"), lwd=7, col=colour[c(5,1)], bty="n", cex=2)
dev.off()


### Calculating returns
# calculating returns
calc_returns <- function(ind, cols){
  tmp <- sapply(cols, function(x){
    exp( diff(ts(log(ind[,x]))) )*100 -100
  } )
  return(as.data.frame( tmp ))
}

returns <-calc_returns(indices,c("mean","median") )
rownames(returns) <- 1996:2021
jpeg(file="imgs/index_returns.jpg", width=1400, height=600, quality=100)
par(mar = c(6,6,5,2))
barplot(t(as.matrix(returns)), beside=TRUE, col=colour[c(1,5)],
        xlab="Year",
        ylab="Annual change (%)",
        main="Returns",
        border=NA,
        cex=2, cex.axis=2, cex.lab=2, cex.main=3)
box()
legend("top",c("Mean","Median"), fill=colour[c(1,5)], border=NA, bty="n", cex=2)
dev.off()

## Accounting for quality and location differences

# Is the sample evenly distributed, in quality, in space? If not, the average or median values won't reflect price changes adequately.

typeyear <- cbind( table(sales$year, sales$propertytype), table(sales$year))
colnames(typeyear) <- c("Detached","Flat","Semi-detached","Terraced","Total")
types <- c("Detached","Flat","Semi-detached","Terraced")

jpeg(file="imgs/type_shares.jpg", width=1400, height=600, quality=100)
par(mar = c(6,6,5,2))
plot(c(1995, 2021), c(0.1,0.35),
     type="n",
     xlab="Year",
     ylab="Share",
     cex=2, cex.axis=2, cex.lab=2, cex.main=3)
for(t in 1:length(types)){
  lines(rownames(typeyear), typeyear[,t ]/typeyear[,"Total"],lwd=7,col=colour[t])
}
legend("bottomright", c("Detached","Flat","Semi-detached","Terraced"), lwd=7, col=colour[1:4], bty="n", cex=2)
dev.off()

# Controlling for quality differences
## Hedonic regressions
# ln(Price_i) = \alpha + \sum_{k=1}^{k=K} \beta_kX_{k,i} +  \sum_{y=1995}^{y=2021} \gamma_kY_{y,i} + \epsilon_i

hed <- lm(log(price)~propertytype+new+estatetype+factor(year), data=sales)
library(stargazer)
stargazer(hed, type="text", header=FALSE)

# extract year coefficients to calculate index
indices$hedonic <- c(0, hed$coefficients[grepl('year', names(hed$coefficients))])
indices$hedonic <- exp(indices$hedonic)*100

jpeg(file="imgs/index_hedonic.jpg", width=1400, height=800, quality=100)
par(mar = c(6,6,5,2))
plot(range(indices$year), range(indices[, c('mean','median',"hedonic")]), 
     type='n', 
     xlab="Year", 
     ylab="1995=100",
     main="Average Price vs Median Price vs Hedonic Index", 
     cex=2, cex.axis=2, cex.lab=2, cex.main=3)
lines(indices$year, indices$mean, ylab="GBP", lwd=7, col=colour[5])
lines(indices$year, indices$median, ylab="GBP", lwd=7, col=colour[1])
lines(indices$year, indices$hedonic, ylab="GBP", lwd=7, col=colour[3])
legend("topleft",c("Mean","Median","Hedonic"), lwd=7, col=colour[c(5,1,3)], bty="n", cex=2)
dev.off()

returns <-calc_returns(indices,c("mean","median","hedonic") )
rownames(returns) <- 1996:2021
jpeg(file="imgs/index_hedonic_returns.jpg", width=1400, height=800, quality=100)
par(mar = c(6,6,5,2))
barplot(t(as.matrix(returns)), 
        beside=TRUE, 
        col=colour[c(5,1,3)], 
        ylab="annual change (%)",
        xlab="Year",
        border=NA,
        cex=2, cex.axis=2, cex.lab=2, cex.main=3)
box()
legend("top",c("Mean","Median","Hedonic"), fill=colour[c(5,1,3)], bty="n", cex=2, border=FALSE)
dev.off()



## Repeat Sales Regression

# get repeat sales index from https://github.com/thies/openindex
# - download file in case the direct download does not work (never tested on Windows)
source('https://raw.githubusercontent.com/thies/openindex/master/r/openindex_includes.R')

# define a unique ID for each property
sales$id <- apply(sales, 1, function(x){ paste(x['paon'], x['saon'], x['street'] ) })
# only ID, price and date needed for repeat sales regression
s <- sales[, c("id","price","date")]

# estimate annual index (Bailey, Muth & Nourse)
BMN <- RepeatSalesIndex(s,indexFrequency=12, method="BaileyMuthNourse", dateMin=as.Date("1995-01-01"), dateMax=as.Date("2021-10-31"), minDaysBetweenSales=1, maxReturn=NA, minReturn=NA, diagnostics=FALSE)

# add to other indices and plot
indices$repeatsalesBMN <- unlist(BMN$index)[2:28]
indices$repeatsalesBMN <- (indices$repeatsalesBMN/indices$repeatsalesBMN[1])*100
jpeg(file="imgs/index_hedonic_repeat.jpg", width=1400, height=800, quality=100)
par(mar = c(6,6,5,2))
plot(range(indices$year), 
     range(indices[, c("hedonic","repeatsalesBMN")]),
     type='n',
     xlab="Year",
     ylab="1995=100",
     main="Hedonic Index vs Repeat Sales",
     cex=2, cex.axis=2, cex.lab=2, cex.main=3)
lines(indices$year, indices$hedonic, ylab="1995=100", lwd=7, col=colour[3])
lines(indices$year, indices$repeatsalesBMN, ylab="1995=100", lwd=7, col=colour[4])
legend("topleft",c("Hedonic index","Repeat sales index"), lwd=7, col=colour[3:4], cex=2, bty="n")
dev.off()


### Are repeat sales representative?
idcounts <- as.data.frame( table(sales$id) )
colnames(idcounts) <- c("id","count")
idcounts <- merge(idcounts, subset(sales, select=c("id","propertytype")), by="id")
idcounts$repsales <- "no repeat sales"
idcounts$repsales[idcounts$count > 1] <- "repeat sales"

tab <- table(idcounts$repsales, idcounts$propertytype)
tab[1,] <- tab[1,]/sum(tab[1,])*100
tab[2,] <- tab[2,]/sum(tab[2,])*100
colnames(tab) <- c("Detached","Flat","Semi-det.","Terraced")
print(round(tab, 1))

jpeg(file="imgs/sample_differences.jpg", width=1400, height=400, quality=100)
par(mar = c(2,6,1,1))
barplot(tab, beside=TRUE, 
        col=colour[c(1,5)], 
        border=FALSE, xlab="",
        ylab="%",
        cex=2, cex.axis=2, cex.lab=2, cex.main=3)
legend("top", c("All sales","Repeat sales"), fill=colour[c(1,5)], bty="n", cex=2, ncol=2, border=FALSE)
box()
dev.off()
# do a Chi-Square test to see if difference are significant... 
# (they most likely are)
with(idcounts, chisq.test(propertytype, repsales))

