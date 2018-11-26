#Shiny App for showing Iowa counties census data
# Liam Niehus-Staab
# Ishaan Tibrewal
# Thomas Leistikow

#libs
library(shiny)    # ShinyApp package
library(ggplot2)  # cute graphs
library(maptools) # creates maps and work with spatial files
library(broom)    # assists with tidy data
library(readr)    # quickly reads files into R

#import shapes files for world map data
merged = read.csv("IowaCensusShapelyDataMerged.csv")



### SHINY STUFF

#specify the UI layout
ui = fluidPage(
  #App title
  titlePanel("Geographic Visualization of Iowa Census Data"),
  
  #layout container
  sidebarLayout(
    
    #specify input sidepanel
    sidebarPanel(
      h3("Mapped and Census Data with Correlation"),
      helpText("Select the census variables displayed in the graph. The first variable is shown on the map by fill color and as
               the response variable on the scatter plot.\nThe second variable is showed as the explanitory variable on the scatter plot."),
      # options spinner 1
      selectInput("dropDown1ID", h4("Percentage Variable"),
                  choices = list(
                    "Percent Poverty",
                    "Percent Child Poverty",
                    "Percent Family Work",
                    "Percent Self Employment",
                    "Percent Unemployment"),
                  selected = 1),
      
      #options spinner 2
      selectInput("dropDown2ID", h4("Quantitative Variable"),
                  choices = list(
                    "Total Population",
                    "Number of Citizens",
                    "Average Household Income",
                    "Average Income Per Capita"),
                  selected = 1)
    ),
    
    #specify what output goes in main panel
    mainPanel(
      
      #id UI placement for the map graphed
      plotOutput(outputId = "map"),
      
      #id UI placement for teh scatter plot
      plotOutput(outputId = "scatter")
    )
  )
)

#specify server graph building actions
server = function(input, output) {
  
  
  #define map plot behavior
  output$map = renderPlot({
    
    #switch to convert input string choice to data vectors
    #percentages from drop down 1
    percentData = switch(input$dropDown1ID,
                         "Percent Poverty" = merged$Poverty,
                         "Percent Child Poverty" = merged$ChildPoverty,
                         "Percent Family Work" = merged$FamilyWork,
                         "Percent Self Employment" = merged$SelfEmployed,
                         "Percent Unemployment" = merged$Unemployment
    )
    #change fill color by second input
    color = switch(input$dropDown2ID,
                          "Total Population" = "red",
                          "Number of Citizens" = "blue",
                          "Average Household Income" = "gold",
                          "Average Income Per Capita" = "darkgreen"
    )
    
    ggplot() +                                                            #change fill with input
      geom_polygon(data = merged, aes(x = long, y = lat, group = group,  fill = percentData), 
                   color = "black") +              
      scale_fill_continuous(name = input$dropDown1ID,
                            low = "white", high = color) +
      labs(title = paste("Iowa Counties by", input$dropDown1ID, collapse = ""),
             x = "Longitude", y = "Latitude", fill = input$dropDown1ID)
  })
  
  #define scatter plot behavior
  output$scatter = renderPlot({
    
    #switch to convert input string choice to data vectors
    #quantitative data from drop down 2
    quantitative = switch(input$dropDown2ID,
                          "Total Population" = merged$TotalPop,
                          "Number of Citizens" = merged$Citizen,
                          "Average Household Income" = merged$Income,
                          "Average Income Per Capita" = merged$IncomePerCap
    )
    #percentages from drop down 1
    percentData = switch(input$dropDown1ID,
                         "Percent Poverty" = merged$Poverty,
                         "Percent Child Poverty" = merged$ChildPoverty,
                         "Percent Family Work" = merged$FamilyWork,
                         "Percent Self Employment" = merged$SelfEmployed,
                         "Percent Unemployment" = merged$Unemployment
    )
    
    #graph scatter plot of percentData vs quantitative
    ggplot(merged, aes(x = quantitative, y = percentData)) +
      geom_point() + geom_smooth(method = "lm") +
      labs(title = paste("Plot of ", input$dropDown2ID, " vs ", input$dropDown1ID, " for Iowa counties", collapse = ""),
           x = input$dropDown2ID, y = input$dropDown1ID)
  })
}

#build the app!
shinyApp(ui = ui, server = server)