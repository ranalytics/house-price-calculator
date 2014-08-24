if (!"shiny" %in% installed.packages()) install.packages("shiny")
if (!"GWmodel" %in% installed.packages()) install.packages("GWmodel")
if (!"Cairo" %in% installed.packages()) install.packages("Cairo")
if (!"ggplot2" %in% installed.packages()) install.packages("ggplot2")

library(shiny)
library(GWmodel) # contains training data
library(ggplot2) # for plotting
library(splines) # for model fitting
library(Cairo)

data(EWHP) # call the datafarame

# Change level labels for convinience:
# processed <- ewhp
# processed$TypFlat <- factor(ifelse(processed$TypFlat == 0, "No", "Yes"))
# processed$TypDetch <- factor(ifelse(processed$TypDetch == 0, "No", "Yes"))


# Define server logic:
shinyServer(function(input, output) {

# Fit the model:
M <- lm(I(log(PurPrice)) ~ ns(FlrArea, 3) + factor(TypDetch), data = ewhp)

pred.dat <- reactive({

        dat <- data.frame(
                FlrArea = input$FlrArea,
                TypDetch = as.numeric(input$TypDetch)
                )
        dat$PurPrice <- exp(predict(M, newdata = dat))
        dat$LL <- exp(predict(M, newdata = dat, interval = "pred"))[2]
        dat$UL <- exp(predict(M, newdata = dat, interval = "pred"))[3]
        dat

})

output$point <- renderText({as.integer(pred.dat()$PurPrice)}) 
output$ll <- renderText({as.integer(pred.dat()$LL)}) 
output$ul <- renderText({as.integer(pred.dat()$UL)}) 

# output$test <- renderPrint({pred.dat()})

output$graph <- renderPlot({

mf_labeller <- function(var, value){
    value <- as.character(value)
    if (var=="TypDetch") { 
        value[value==0] <- "Non-detached"
        value[value==1] <- "Detached"
    }
    return(value)
}

p <- ggplot(data = ewhp, aes(x = FlrArea, y = PurPrice)) + 
        geom_point(alpha = 0.2) +
        facet_grid(~ TypDetch, labeller=mf_labeller) + 
        geom_point(data = pred.dat(), aes(x = FlrArea, y = PurPrice), 
                   shape = 16, size = 6, colour = "blue") +
        geom_errorbar(data = pred.dat(), aes(ymin = LL,  ymax = UL),
                      width = 0, colour = "blue", size = 1) +
        theme_bw() + xlab("Floor area (square meters)") +
        ylab("Property price (GBP)")
print(p)

})


})


