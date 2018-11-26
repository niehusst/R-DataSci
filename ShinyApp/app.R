#Liam Niehus-Staab
# My first shiny app
# 10/16/18

library(shiny)
library(ggplot2)
#rando data
data = read.csv("~/Shared/F18MAT295/LoveandMoneyData.csv")
 
# Shiny apps are contained in a single script called app.R. The script app.R lives in a directory 
# (for example, newdir/) and the app can be run with runApp("path/to/newdir"). app.R has three components:
#  1. a user interface object
#  2. a server function
#  3. a call to the shinyApp function

#runExample("01_hello")
# Define UI for app that draws a histogram ----
# ui <- fluidPage(
# 
#   # App title ----
#   titlePanel("Hello Shiny!"),
# 
#   # Sidebar layout with input and output definitions ----
#   sidebarLayout(
# 
#     # Sidebar panel for inputs ----
#     sidebarPanel(
# 
#       # Input: Slider for the number of bins ----
#       sliderInput(inputId = "bins",
#                   label = "Number of bins:",
#                   min = 1,
#                   max = 50,
#                   value = 30)
# 
#     ),
# 
#     # Main panel for displaying outputs ----
#     mainPanel(
# 
#       # Output: Histogram ----
#       plotOutput(outputId = "distPlot")
# 
#     )
#   )
# )
# 
# # Define server logic required to draw a histogram ----
# server <- function(input, output) {
# 
#   # Histogram of the Old Faithful Geyser Data ----
#   # with requested number of bins
#   # This expression that generates a histogram is wrapped in a call
#   # to renderPlot to indicate that:
#   #
#   # 1. It is "reactive" and therefore should be automatically
#   #    re-executed when inputs (input$bins) change
#   # 2. Its output type is a plot
#   output$distPlot <- renderPlot({
# 
#     x    <- faithful$waiting
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
# 
#     hist(x, breaks = bins, col = "#75AADB", border = "white",
#          xlab = "Waiting time to next eruption (in mins)",
#          main = "Histogram of waiting times")
# 
#   })
# 
# }
# 
# # Create Shiny app ----
# shinyApp(ui = ui, server = server)

ui = fluidPage(
  #header title
  titlePanel("Practice App"),
  
  #layout container
  #instead of sidebarLayout, you could use fluidRows and columns within to bootstrap design it
  sidebarLayout(position = "left", #left is default but can be changed
    
    #side controls/input stuff
    sidebarPanel(
      
      #you can do basic html stuff
      div(style = "color:red",
          h2("Reason for doing this?"),
          p("Literally none. ther is no reason at all lorem ipsum deus ex machina.")
      ),
      
      #input widgets: each one needs an id and label
      helpText(h3("Look @ this for help"),
        p("radio buttons have no purpose, don't touch the m they scream v loud plz no")
               ),
      
      radioButtons("radio", label = h3("Radio Buttons"),
                   choices = list(
                     "Radio 1"= 1,
                     "radio 2"= 2,
                     "rAdIO 3"= 3),
                   selected = 3
                   ),
      
      selectInput("inputList", label = h4("List options"),
                  choices = list(
                    "Red" = "red",
                    "Blue" = "blue",
                    "Green" = "green"),
                  selected = 1
                  )
      
    ),
    
    #main graph to display
    mainPanel(
      # the output type in mainPanel must be specified. avaialbale options are
      # dataTableOutput	DataTable
      # htmlOutput	raw HTML
      # imageOutput	image
      # plotOutput	plot
      # tableOutput	table
      # textOutput	text
      # uiOutput	raw HTML
      # verbatimTextOutput	text
      
      # plot some basic data and color by input
      #this just tells ui what sort of thing is to be displayed, actual code is run in server
      plotOutput(outputId = "basic_plotID"),
      
      #just a second example
      textOutput(outputId = "basic_txt")
    )
  )
  
)

server = function(input, output) {
  
  #define behaviour for the specified output ID
  #the render function means that for every change in UI call, the item is rerendered using new input
  output$basic_plotID = renderPlot({
    ggplot() + geom_point(data = data, aes(x=data$Love, y = data$MoneySpent), color = input$inputList)+
      labs(title("Love v Money"), x = "Love", y = "Money Spent")
    
  })
  
  #second exapmle
  output$basic_txt = renderText({
    paste(c("This is text rendering",input$radio), collapse = "")
  })
}

shinyApp(ui=ui, server=server)