#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#import excel data
library(readxl)
raw_credit <- read_excel("credit_card.xlsx", 
                         col_types = c("numeric", "text", "text", "text", "text", "numeric", "text", "text", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric"))
#check for missing values
raw_credit[!complete.cases(raw_credit),] #24 rows with missing balances
#create new dataset without missing data
data_credit <- na.omit(raw_credit)

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Average Bank Account Balance"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            # select the color of the graph
            selectInput("select", "Select a Color", 
                        choices = c("red", "green", "purple")),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- data_credit$"Average Balance" #store Average Balance
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        #store title
        titl <- paste("Histogram of Average Balance")
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = input$select, border = 'white', main = titl)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)


