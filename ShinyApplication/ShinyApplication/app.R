#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
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

# Define server logic required to draw a histogram
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        mtcars$wtif <- ifelse(mtcars$wt - 3 > 0, mtcars$wt - 3, 0) 
        model1 <- lm(mpg ~ wt, data = mtcars)
        model2 <- lm(mpg ~ wtif + wt, data = mtcars)
        
        model1pred <- reactive({
                wtInput <- input$sliderWT
                predict(model1, newdata = data.frame(wt = wtInput))
        })
        
        model2pred <- reactive({
                wtInput <- input$sliderWT
                predict(model2, newdata = data.frame(wt = wtInput,
                                                     wtif = ifelse(wtInput - 3 > 0,
                                                                   wtInput - 3, 0)))
        })
        
        output$carPlot <- renderPlot({
                wtInput <- input$sliderWT
                
                plot(mtcars$wt, mtcars$mpg, 
                     xlab = "weight in 1000 lbs", ylab = "miles per gallon", 
                     bty = "n", pch = 16,
                     xlim = c(1, 6), ylim = c(10, 40))
                if(input$showModel1){
                        abline(model1, col = "goldenrod", lwd = 2)
                }
                if(input$showModel2){
                        model2lines <- predict(model2, newdata = data.frame(
                                wt = 1:6, wtif = ifelse(1:6 - 3 > 0, 1:6 - 3, 0)))
                        lines(1:6, model2lines, col = "darkblue", lwd = 2)
                }
                
                legend(25, 250, c("Model 1 Prediction", "Model 2 Prediction"), 
                       pch=16, col = c("goldenrod", "darkblue"), bty = "n", cex = 1.2)
                points(wtInput, model1pred(), col = "goldenrod", pch = 16, cex = 2) 
                points(wtInput, model2pred(), col = "darkblue", pch = 16, cex = 2)
        })
        
        output$pred1 <- renderText({
                model1pred()
        })
        
        output$pred2 <- renderText({
                model2pred()
        })
})

