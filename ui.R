if (!"shiny" %in% installed.packages()) install.packages("shiny")

library(shiny)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("UK house price calculator"),
  

  # Sidebar with a slider input
  sidebarPanel(
          
    helpText(strong("Input parameters")),
    br(),
    
    sliderInput("FlrArea", "Floor area (square meters):",
                min = 25,
                max = 280,
                value = 25, step = 5),
    br(),
    
    checkboxInput("TypDetch", "Is this a detached house?",
                 value = FALSE),
    
    hr(),
    helpText(strong("Predicted price (", icon("gbp"), ")")),
    
    helpText("Point estimate:", textOutput("point", inline = TRUE)),
    helpText("Lower 95% conf. limit:", textOutput("ll", inline = TRUE)),
    helpText("Upper 95% conf. limit:", textOutput("ul", inline = TRUE)),
    
    hr(),
    
    p(img(src="house.png", height = 100, width = 100), 
      span("Now you know it!", style = "color:blue"))
    
    
  ),

  # Show a plot of the generated distribution
  mainPanel(
#     verbatimTextOutput("test"), 
          
        tabsetPanel(
                
                tabPanel("Calculation results",
                        plotOutput("graph"),
    div("The above plot illustrates the training dataset used to fit the predictive model. Your property is shown as a blue dot with whiskers. These whiskers denote the 95% confidence interval of the predicted price.", style = "color:gray") 
                        ),
    
                tabPanel("Help",
                         div("The purpose of this application is to calculate the price of a dwelling in the United Kingdom (in GBP) based on the total floor area (in square meters) and whether a house is detached or not. The calculations' engine is a regression model, which was trained on a dataset collected by Fotheringham et al. (2002) and is available in the R package GWmodel."),
                         br(),
                         div("In order to predict the price of a house, the user needs to specify its parameters using the controls located in the left sidebar of the application. There are two controls: a slider to select the required floor area (with a step of 5 sq. meters), an a checkbox to indicate whether the house is detached."),
                          br(),
                         div("The predicted price is shown as a large blue point on the plot shown in the main window of the application. Also shown (blue wiskers) is the 95% confidence interval, which provides a measure of uncertainty with regard to the point estimate of the price.")
                         )   
                
                )
     
    
  )

))
