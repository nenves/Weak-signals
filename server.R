library(shiny)
library(jsonlite)
library(tm)
library(wordcloud)

# Server logic required to generate and plot histograms and wordcloud
shinyServer(function(input, output) {
  
  # Expression that generates a wordcloud for CATEGORIES.  
  output$wordCloudPlotCATEGORIES <- renderPlot({
    
    pinsAll <- fromJSON("https://api.pinterest.com/v1/boards/<YOUR_USER>/<YOUR_BOARD_NAME>/pins/?access_token=<YOUR_ACCESS_TOKEN>&fields=id%2Clink%2Cnote%2Curl&limit=100")
    pins<-data.frame(pinsAll$data)
    pinNotes<-paste(pins$note,sep = " ", collapse = " ")
    cleanPinNotes<-unlist(strsplit(pinNotes,split = " "))
    tags<-grep("#.*",cleanPinNotes,value = TRUE)
    
    steepled<-c("#societal","#technology","#economic","#environmental","#political","#legal","#ethical","#demographics")
    tags<-as.character(d[!(tolower(d$tags) %in% steepled),])
    corpus<-Corpus(VectorSource(tags))
    wordcloud(corpus, scale=c(4,0.5), min.freq = 1, random.order=FALSE, rot.per=0.0, colors=brewer.pal(8, "Dark2"))

  })
  
  # Expression that generates a STEEPLED histogram.
  output$histPlotSTEEPLED <- renderPlot({
    
    pinsAll <- fromJSON("https://api.pinterest.com/v1/boards/<YOUR_USER>/<YOUR_BOARD_NAME>/pins/?access_token=<YOUR_ACCESS_TOKEN>&fields=id%2Clink%2Cnote%2Curl&limit=100")
    pins<-data.frame(pinsAll$data)
    pinNotes<-paste(pins$note,sep = " ", collapse = " ")
    cleanPinNotes<-unlist(strsplit(pinNotes,split = " "))
    tags<-grep("#.*",cleanPinNotes,value = TRUE)
    
    corpus<-Corpus(VectorSource(tags))
    
    term.matrix <- TermDocumentMatrix(corpus)
    term.matrix <- as.matrix(term.matrix)
    term.matrix <- as.data.frame(term.matrix)
    
    freqs<-sort(rowSums(term.matrix),decreasing = TRUE)
    d <- data.frame(word = names(freqs),freq=freqs)
    
    columns<-c("#societal","#technology","#economic","#environmental","#political","#legal","#ethical","#demographics")
    steepled<-matrix(d[columns,"freq"],1,8)
    colnames(steepled)<-columns
    par(las=2)
    par(mar = c(10,4,4,2) + 0.1)
    barplot(steepled,col = "#01A9DB", ylab = "Number of pins per STEEPLED category", main = "STEEPLED")
  })

  # Expression that generates a CATEGORIES histogram.
  output$histPlotCATEGORIES <- renderPlot({
    
    pinsAll <- fromJSON("https://api.pinterest.com/v1/boards/<YOUR_USER>/<YOUR_BOARD_NAME>/pins/?access_token=<YOUR_ACCESS_TOKEN>&fields=id%2Clink%2Cnote%2Curl&limit=100")
    pins<-data.frame(pinsAll$data)
    pinNotes<-paste(pins$note,sep = " ", collapse = " ")
    cleanPinNotes<-unlist(strsplit(pinNotes,split = " "))
    tags<-grep("#.*",cleanPinNotes,value = TRUE)

    steepled<-c("#societal","#technology","#economic","#environmental","#political","#legal","#ethical","#demographics")
    tags<-as.character(d[!(tolower(d$tags) %in% steepled),])
    
    corpus<-Corpus(VectorSource(tags))
    
    term.matrix <- TermDocumentMatrix(corpus)
    term.matrix <- as.matrix(term.matrix)
    term.matrix <- as.data.frame(term.matrix)
    freq<-rowSums(term.matrix)
    freq<-sort(freq,decreasing = TRUE)
    
    par(las=2)
    par(mar = c(10,4,4,2) + 0.1)
    barplot(freq, col = "#01A9DB", ylab = "Number of pins per category")
  })

})
