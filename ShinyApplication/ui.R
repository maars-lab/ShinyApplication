#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application to plot
shinyUI(fluidPage(

    # Application title
    titlePanel("Effects of car weight [wt] on miles per gallon [mpg]"),
    
    # Sidebar with a slider input for car weight
    sidebarLayout(
            sidebarPanel(
                    sliderInput("sliderWT", "What is the weight of the car in 1000 lbs?", 1, 6, value = 3), 
                    checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE), 
                    checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE), 
        ),

        # Show a plot of the generated distribution
        mainPanel(
                plotOutput("carPlot"),
                h3("Predicted mpg from Model 1:"),
                textOutput("pred1"),
                h3("Predicted mpg from Model 2:"),
                textOutput("pred2")
        )
    )
))
