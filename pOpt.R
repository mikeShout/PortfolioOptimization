pOpt <- function() {
      
      #install.packages("ggplot2")
      library(ggplot2)   
      
      #install.packages("devtools")
      library(devtools)
      
      #install_github('quandl/R-package')      
      library(Quandl)
      
      sym <- c("MO", "CIM", "WYNN") # list of symbols to be considered in portfolio
      incs <- .1 #increment allocations by 10% from 100% to 0% 

      #Set up an empty dataframe to hold portfolios and performance
      dfn <- "portfolio, avgRetn, StdRetn"
      for (i in 1:length(sym)) {
          dfn <- paste(dfn, sym[i], sep=", ") 
      }
      port <- read.csv(text=dfn)
            
      #Start building a number of portfolios by incrementing allocations of each share.  
      
      #Create a vector with the initial allocations and 'the rest'
      a <- 1
      iPoint <-2
      initAll <- data.frame(1, 0)
      names(initAll) <- c("init", "rest")

      while (a > 0) {
            a <- a - incs
            if (a <= 0) {
                  a <- 0
            }
            
            initAll[iPoint,1] <- a
            initAll[iPoint,2] <- (1-a) / (length(sym)-1)
            iPoint <- iPoint + 1
      }

      #Now create portfolios by looping through and assigning allocations to each symbol...

      dfRow <- 1
      for(iter in 1:length(sym)) {
            tempDF <- data.frame(dfRow:(dfRow+(nrow(initAll)-1)), NA, NA)
            dfRow <- dfRow + nrow(initAll)
            
            for (pos in 1:length(sym)) {
                  if(pos == iter) {
                        tempDF <- cbind(tempDF, initAll[1])
                  } 
                  else {
                        tempDF <- cbind(tempDF, initAll[2])
                  }
            }
            names(tempDF) <- names(port)
            port <- rbind(port, tempDF)
            
      }

      # Get the annual % change for each symbol from Quandl  
      # Ignore the first and last years returned because they are not representing a full year 
      
      tickPerf <- Quandl(paste("YAHOO", "/", sym[1], sep=""), transform="rdiff", collapse="annual", trim_start=as.character((Sys.Date() - (6*365))), trim_end=as.character((Sys.Date() -2)))
      tickPerf <- data.frame(tickPerf, sym[1])

      for(symC in 2:length(sym)){
            print(sym[symC])
            downD <- Quandl(paste("YAHOO", "/", sym[symC], sep=""), api_key="kQ3azuY5j-CfNtCaqMMD", transform="rdiff", collapse="annual", trim_start=as.character((Sys.Date() - (6*365))), trim_end=as.character((Sys.Date() -2)))      
            downD <- data.frame(downD, sym[symC])
            names(downD) <- names(tickPerf)
                  
            tickPerf <- rbind(tickPerf, downD)
      }
      tickPerf$Date <- as.numeric(format(tickPerf$Date, "%Y") )

      # Loop through symbol performance dataframe and calcualte average & stdDev port return...
      for (p in 1:nrow(port)) {
            
            #Set up temporary dataframe w/ years and loop through symbols and add a col of allocations * symbol returns
            tempDF <- cbind(subset(tickPerf, sym.1.==names(port[4]) & Date < 2016 & Date > 2011, select = "Date"), subset(tickPerf, sym.1.==names(port[4]) & Date < 2016 & Date > 2011, select = "Adjusted.Close")*port[p,4])

            for (pos in 5:((5+length(sym))-2)) {
                  tempDF <- cbind(tempDF, subset(tickPerf, sym.1.==names(port[pos]) & Date < 2016 & Date > 2011, select = "Adjusted.Close")*port[p,pos])
            }

            
            # Now you have a table of allocations * returns for each symbol for each year...
            #Determine yearly portfolio retn by adding weighted returns for each row...
            tempDF$pRetn <- rowSums(tempDF[2:4])
            # determine the avg and std and add to portfolio... 
            port[p, 2] <- mean(tempDF$pRetn) #average
            port[p, 3] <- sd(tempDF$pRetn) #stdDev 
      }
      
      print(port)
 
      #Create a scatter plot w/ risk on x-axis and retn on the y-axis

      #plot(port$StdRetn, port$avgRetn, main="Efficient Portfolio Fronteer", xlab="Risk", ylab="Return", pch=19)
      ggplot(port, aes(x=StdRetn+.2, y=avgRetn)) + geom_point(shape=21, size=5) + geom_text(aes(label=portfolio), size=5, hjust=0, vjust=0)

}