library(shiny)
library(leaflet)
library(ggplot2)

shinyUI(
  fluidPage(
    titlePanel("Bike-sharing Demand Prediction Dashboard"),
    
    # CSS styling
    tags$head(
      tags$style(HTML("
        .sidebar {
          background-color: #f8f9fa;
          padding: 20px;
          border-radius: 5px;
        }
        .main-panel {
          padding: 20px;
        }
        .plot-container {
          margin-bottom: 20px;
          border: 1px solid #ddd;
          border-radius: 4px;
          padding: 10px;
          background-color: white;
        }
        .click-info {
          background-color: #f0f7ff;
          padding: 10px;
          border-radius: 4px;
          margin-top: 10px;
        }
      "))
    ),
    
    sidebarLayout(
      # Sidebar panel for inputs and city details
      sidebarPanel(
        class = "sidebar",
        width = 3,
        
        selectInput(
          inputId = "selected_city",
          label = "Select City:",
          choices = c("All", "Seoul", "New York", "Paris", "London", "Suzhou"),
          selected = "All"
        ),
        
        # Conditional panels that only show when a city is selected
        conditionalPanel(
          condition = "input.selected_city != 'All'",
          h4("City Details"),
          
          # Task 1: Temperature trend plot
          div(class = "plot-container",
              h5("5-Day Temperature Forecast"),
              plotOutput("temp_line", height = "200px")
          ),
          
          # Task 2: Interactive bike demand plot
          div(class = "plot-container",
              h5("Bike Demand Prediction Trend"),
              plotOutput("bike_line", 
                         height = "200px",
                         click = "plot_click"),
              div(class = "click-info",
                  verbatimTextOutput("bike_date_output")
              )
          ),
          
          # Task 3: Humidity correlation plot
          div(class = "plot-container",
              h5("Humidity vs. Bike Demand"),
              plotOutput("humidity_pred_chart", height = "200px")
          )
        )
      ),
      
      # Main panel for the map
      mainPanel(
        class = "main-panel",
        width = 9,
        leafletOutput("city_bike_map", height = "600px")
      )
    )
  )
)