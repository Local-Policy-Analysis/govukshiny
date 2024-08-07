library(shiny)

run_preview_app <- function(){
  addResourcePath(prefix = "www", directoryPath = "./www")
   ui <- function(req){htmlTemplate("templates/template.html", 
    contents = fluidPage(fluidRow(
      column(3,
        h3("Buttons"),
        govuk_actionButton("action", "Action"),
        br(),
        br(),
        govuk_submitButton("Submit")),
    
      column(3,
      h3("Single Checkbox"),
      govuk_checkboxInput("checkbox", "Choice A", value = TRUE)),

      column(3,
    govuk_checkboxGroupInput("checkGroup",
      h3("Checkbox group"),
      choices = list("Choice1" = 1,
                    "Choice2" = 2,
                    "Choice3" = 3),
                    selected = 1)),

      column(3,
      govuk_dateInput("date",
        h3("Date input"),
        value = "2014-01-01"))
    ),
    fluidRow(
      column(3,
        govuk_dateRangeInput("dates", h3("Date range"))
      ),

      column(3, 
        h3("File Input"),
        div("Not used")),

      column(3,
        h3("Help text"),
        govuk_helpText("Note: help text isn't a true widget, ",
                       "but it provides an easy way to add text to",
                       "accompany other widgets.")
        ),

      column(3,
        govuk_numericInput("num",
                           h3("Numeric input"),
                           value = 1))
    ),
    fluidRow(
      column(3,
      govuk_radioButtons("radio", h3("Radio buttons"),
                          choices = list("Choice 1" = 1, "Choice 2" = 2,
                                        "Choice 3" = 3), selected = 1)),
                          
      column(3,
      govuk_selectInput("select", h3("Select box"),
                          choices = list("Choice 1" = 1, "Choice 2" = 2,
                                         "Choice 3" = 3), selected = 1)),

      column(3,
        h3("Sliders"),
        div("Hah! Govuk definitely doesn't support sliders (and I'm not rewriting them. That sounds hard)")),

      column(3,
        govuk_textInput("text", h3("Text input")))
    )
  ),
  tab2 = fluidPage(h1("Tab 2", class = "govuk-heading-l"),
        plotly::plotlyOutput('plot')))
  }
  server <- function(input, output, session){
      observe({
    # Trigger this observer every time an input changes
    reactiveValuesToList(input)
    session$doBookmark()
  })
    plt <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = hp)) + ggplot2::geom_point()
    
  output$plot <- plotly::renderPlotly(plotly::ggplotly(plt) |> plotly::layout(font = list(family = "GDS Transport")))

  onBookmarked(function(url) {
    updateQueryString(url)
  })
}
  
  enableBookmarking("url")
  shinyApp(ui,server)
}