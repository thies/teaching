# Vector of Ticker simbols for UK REITs and Property companies
# one can get these from SNL.com, for instance
ukreitspropcos <- c("MKLW","AEWL","AEWU","ALPH","ASPL","AGR","ATL","ATRS","BYG","BLND","CNN","CAPC","CAL","CDFF","CRC","CSH","CLI","CIC","CREI","DJAN","DLN","DUPD","EZH","ESP","ERET","FCPT","FCRE","FLK","DIGS","GRI","GPOR","HMSO","HSTN","HLCL","HCFT","IHG","INTU","LAND","LSR","LOK","LAS","LMP","LXB","LXI","MPO","MSP","MCKS","MXF","MLC","MAB","MTVW","NRP","NFP","NRR","PILR","PNS","PCTN","PHP","PRSR","RUS","RDI","RLE","RGL","RESI","SAFE","SREI","SIR","SGRO","SHB","SRE","SMP","SLI","SMTG","SUPR","THRL","TOWN","SOHO","BBOX","UAI","UKCM","UTG","UANC","WHR","WKP","WSP","YATRA")

library("quantmod")

mret <- list()
wret <- list()
qret <- list()
allPrices <- list()

for( ticker in ukreitspropcos){
  print(ticker)
  # add an .L for London to ticker
  ticker <- paste(ticker, ".L", sep="")
  try( getSymbols(ticker ,src="yahoo", from="1900-01-01")) # from google finance 
  try( allPrices[[ ticker ]] <- get( ticker ))
  try( mret[[ ticker ]] <- monthlyReturn( get( ticker )))
  try( wret[[ ticker ]] <- weeklyReturn( get( ticker )))
  try( qret[[ ticker ]] <- quarterlyReturn( get( ticker )))
}

monthly <- do.call( cbind, mret)
colnames(monthly) <- gsub(".L$", "", names( mret ), perl=TRUE)
quarterly <- do.call( cbind, qret)
colnames(quarterly) <- gsub(".L$", "", names( qret ), perl=TRUE)
 

