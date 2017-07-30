#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
# Define UI for application that draws a histogram
library(jsonlite)
library(curl)
colisionJson <- fromJSON("https://data.cityofnewyork.us/resource/qiz3-axqb.json", flatten = TRUE)
colisionLocations <- data.frame(
        lat = unlist(lapply(colisionJson$latitude, as.numeric)),
        long = unlist(lapply(colisionJson$longitude, as.numeric)),
        cFactor = unlist(colisionJson$contributing_factor_vehicle_1),
        numberOfInjered = unlist(lapply(colisionJson$number_of_persons_injured, as.numeric))
)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Motor Vehicle Collisions locations in New York City"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        selectInput("factor", "Collision factor:", unique(colisionLocations$cFactor)),
       sliderInput("injured",
                   "Number of pepole injured",
                   min = min(colisionLocations$numberOfInjered),
                   max = max(colisionLocations$numberOfInjered),
                   value = 0,
                   step = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
            h3("main page"),
            
       leafletOutput("mapPlot")
    )
  )
))
