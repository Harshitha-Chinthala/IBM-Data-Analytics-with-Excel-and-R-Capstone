library(shiny)
library(ggplot2)
library(leaflet)
library(tidyverse)
library(httr)
library(scales)
source("model_prediction.R")

shinyServer(function(input, output) {
  # Define color scale for bike prediction levels
  color_levels <- colorFactor(
    palette = c("green", "yellow", "red"),
    levels = c("small", "medium", "large")
  )
  
  # Reactive expression for weather/bike data
  city_weather_bike_data <- reactive({
    generate_city_weather_bike_data()
  })
  
  # Create summary data with max bike prediction for each city
  cities_max_bike <- reactive({
    city_weather_bike_data() %>%
      group_by(CITY_ASCII, LAT, LNG) %>%
      summarize(
        MAX_BIKE_PREDICTION = max(BIKE_PREDICTION),
        BIKE_PREDICTION_LEVEL = calculate_bike_prediction_level(MAX_BIKE_PREDICTION),
        LABEL = first(LABEL),
        DETAILED_LABEL = first(DETAILED_LABEL)
      )
  })
  
  # Render the leaflet map
  output$city_bike_map <- renderLeaflet({
    if(input$selected_city == "All") {
      # Map for all cities
      leaflet(cities_max_bike()) %>%
        addTiles() %>%
        addCircleMarkers(
          lng = ~LNG, 
          lat = ~LAT,
          radius = ~ifelse(BIKE_PREDICTION_LEVEL == "small", 6, 
                           ifelse(BIKE_PREDICTION_LEVEL == "medium", 9, 12)),
          color = ~color_levels(BIKE_PREDICTION_LEVEL),
          fillOpacity = 0.8,
          popup = ~LABEL,
          label = ~CITY_ASCII
        ) %>%
        addLegend(
          "bottomright",
          pal = color_levels,
          values = ~BIKE_PREDICTION_LEVEL,
          title = "Bike Demand Level"
        )
    } else {
      # Map for a single city
      city_data <- city_weather_bike_data() %>%
        filter(CITY_ASCII == input$selected_city)
      
      leaflet(city_data) %>%
        addTiles() %>%
        addMarkers(
          lng = ~LNG, 
          lat = ~LAT,
          popup = ~DETAILED_LABEL,
          label = ~paste(CITY_ASCII, "- Temp:", TEMPERATURE, "°C")
        )
    }
  })
  
  # Task 1: Temperature trend plot
  output$temp_line <- renderPlot({
    req(input$selected_city != "All")
    city_data <- city_weather_bike_data() %>%
      filter(CITY_ASCII == input$selected_city)
    
    ggplot(city_data, aes(x = as.POSIXct(FORECASTDATETIME), y = TEMPERATURE)) +
      geom_line(color = "red", size = 1) +
      geom_point(color = "red", size = 3) +
      geom_text(aes(label = paste0(TEMPERATURE, "°C")), 
                vjust = -1.5, size = 3.5) +
      labs(
        title = paste("Temperature Forecast for", input$selected_city),
        x = "Date/Time",
        y = "Temperature (°C)"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(size = 12))
  })
  
  # Task 2: Interactive bike demand plot
  output$bike_line <- renderPlot({
    req(input$selected_city != "All")
    city_data <- city_weather_bike_data() %>%
      filter(CITY_ASCII == input$selected_city)
    
    ggplot(city_data, aes(x = as.POSIXct(FORECASTDATETIME), y = BIKE_PREDICTION)) +
      geom_line(color = "blue", size = 1) +
      geom_point(aes(color = BIKE_PREDICTION_LEVEL), size = 3) +
      scale_color_manual(values = c("small" = "green", "medium" = "yellow", "large" = "red")) +
      geom_text(aes(label = BIKE_PREDICTION), 
                vjust = -1.5, size = 3.5) +
      labs(
        title = paste("Bike Demand Forecast for", input$selected_city),
        x = "Date/Time",
        y = "Predicted Bike Demand",
        color = "Demand Level"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(size = 12))
  })
  
  # Task 2: Click event handler for bike demand plot
  output$bike_date_output <- renderText({
    req(input$plot_click)
    city_data <- city_weather_bike_data() %>%
      filter(CITY_ASCII == input$selected_city)
    
    # Find nearest point to click
    near_point <- nearPoints(city_data, input$plot_click, 
                             xvar = "FORECASTDATETIME", 
                             yvar = "BIKE_PREDICTION",
                             threshold = 10, maxpoints = 1)
    
    if(nrow(near_point) > 0) {
      paste("Time:", near_point$FORECASTDATETIME, "\n",
            "Predicted Demand:", near_point$BIKE_PREDICTION)
    } else {
      "Click on a point to see details"
    }
  })
  
  # Task 3: Humidity correlation plot
  output$humidity_pred_chart <- renderPlot({
    req(input$selected_city != "All")
    city_data <- city_weather_bike_data() %>%
      filter(CITY_ASCII == input$selected_city)
    
    ggplot(city_data, aes(x = HUMIDITY, y = BIKE_PREDICTION)) +
      geom_point(color = "purple", size = 3) +
      geom_smooth(method = "lm", formula = y ~ poly(x, 4), 
                  color = "orange", se = FALSE) +
      labs(
        title = paste("Humidity vs. Bike Demand for", input$selected_city),
        x = "Humidity (%)",
        y = "Predicted Bike Demand"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(size = 12))
  })
})