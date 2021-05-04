# Download the file containing all EPC from https://epc.opendatacommunities.org/domestic/search
# You'll need to login.
# Unzip the files and save this script into downloaded folder

# Download the price paid data
# Website: https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads
# save the file(s) in the same folder as the script

try( setwd(dirname(rstudioapi::getActiveDocumentContext()$path)))

# load price data
prices <- read.csv("pp-complete.csv", as.is=TRUE)
# set colnames
colnames(prices) <- c("id","price","date","postcode","propertytype","new","estatetype","paon","saon","street","locality","town","district","county","PPDcategory","recordstatus")
# reduce the data a bit
prices$id <- NULL
prices$PPDcategory <- NULL
prices$recordstatus <- NULL
prices$merge_str <- tolower(paste(prices$paon, prices$street, prices$postcode, sep=", "))

epc <- lapply(list.dirs(), function(x){
  print(x)
  if(grepl("domestic-E", x)){
    tmp <- read.csv(paste(x,"certificates.csv", sep="/"), as.is=TRUE)
    tmp$merge_str <- tolower(paste(tmp$ADDRESS, tmp$POSTCODE, sep=", "))
    m <-  merge(tmp, prices, by="merge_str")
    m$merge_str <- NULL
    write.csv(m, file=paste(x,"_merged.csv", sep=""), row.names=FALSE)
    return( m )
  }
})

# free up some memory
rm(prices)
# and combine all (might crash, fingers crossed you have enough memory)
e <- do.call(rbind, epc)
write.csv(e, file="merged.csv", row.names = FALSE)
