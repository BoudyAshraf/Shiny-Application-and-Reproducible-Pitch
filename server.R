#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(jsonlite)
library(curl)
library(leaflet)

colisionJson <- fromJSON("https://data.cityofnewyork.us/resource/qiz3-axqb.json", flatten = TRUE)
colisionLocations <- data.frame(
        lat = unlist(lapply(colisionJson$latitude, as.numeric)),
        long = unlist(lapply(colisionJson$longitude, as.numeric))
)
colisionStat <- data.frame(
        cFactor = unlist(colisionJson$contributing_factor_vehicle_1),
        numberOfInjered = unlist(lapply(colisionJson$number_of_persons_injured, as.numeric))
)

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        test <- reactive({     
                injured_num <- input$injured
                factors <- input$factor
                condition1 <- colisionStat$numberOfInjered == injured_num
                condition2 <- colisionStat$cFactor == factors
                colisionLocations[which(condition1&condition2),]
        }) 
       # print( colisionLocations$cFactor == renderText(input$factor))

        #x <-reactive({y <- input$injured})
        
  output$mapPlot <- renderLeaflet({test() %>% leaflet() %>% addTiles() %>%
          addMarkers(clusterOptions = markerClusterOptions())})
  #x()
  #print(y)
  
})
