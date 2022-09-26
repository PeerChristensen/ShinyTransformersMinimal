
library(shiny)
library(dplyr)
library(purrr)
library(ggplot2)
library(reticulate)

#Sys.setenv(RETICULATE_PYTHON="/Users/peerchristensen/miniconda3/envs/my_env/bin/python")
reticulate::use_condaenv("my_env")
reticulate::py_run_file("python_functions.py")

model <- py$get_model()

ui <- fluidPage(

    titlePanel("My very basic emotion classification app"),

    sidebarLayout(
        sidebarPanel(
            textAreaInput("text", "Input", placeholder = "Type some text here.."),
            actionButton("submit", "Submit")
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)

server <- function(input, output) {
    
    observeEvent(input$submit, {
      
    predictions <- py$get_predictions(input$text,model)
  
    df <- map_df(predictions[[1]], unlist)

    output$plot <- renderPlot({

      df %>%
        mutate(score = as.numeric(score)) %>%
        ggplot(aes(reorder(label, score), score)) +
                 geom_col(fill="steelblue") +
        coord_flip() +
        theme_minimal(base_size = 24) +
        theme(axis.title = element_blank())
    })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
