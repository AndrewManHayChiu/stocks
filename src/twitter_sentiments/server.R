library(shiny)

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    tweets_df <- reactive({
        tweets <- searchTwitter(input$stringSearch, n = 25)
        
        twListToDF(tweets)
    })
    
    output$searchResults <- renderTable({
        
        tweets_df()[, c(1, 11, 12)]
        
    })
    
})
