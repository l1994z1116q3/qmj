#' getincomestatements
#'
#' Retrieves data from the list of companies generated by getcompanies() and 
#' writes associated income statements into a data frame.
#' @examples
#' \dontrun{
#' getincomestatements()
#' }
#' @export

getincomestatements <- function() {
  filepath <- system.file("data", package="qmj")
  filepath1 <- paste(filepath, "/companies.RData", sep='')
  load(filepath1)
  tickers <- as.character(companies$tickers)
  incomestatements <- list()
  n <- 1
  for(i in tickers) {
    prospective <- tryCatch(quantmod::getFinancials(i,auto.assign = FALSE),
                            error=function(e) {
                              e
                            })
    matr <- matrix()
    if(!inherits(prospective,"error") && nrow(matr <- quantmod::viewFinancials(prospective,type = 'IS',period = 'A'))) {
      a <- 1
      while(a <= length(colnames(matr))) {
        colnames(matr)[a] <- sub("[-][0-9]*[-][0-9]*","",paste(i,colnames(matr)[a]))
        a = a + 1
      }
      incomestatements[[n]] <- matr
      n = n+1
    } else {
      incomestatements[[n]] <- matrix(dat=NA, ncol=4, nrow=49)
      n = n+1
    }
  }
  filepath2 <- paste(filepath, "/incomestatements.RData", sep='')
  #save(incomestatements, file="incomestatements.RData")
  incomestatements
}