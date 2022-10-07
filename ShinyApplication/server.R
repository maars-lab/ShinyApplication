#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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
