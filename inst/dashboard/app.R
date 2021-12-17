library(markdown)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)

ui <- dashboardPage(
  dashboardHeader(title = "PPS in Zimbabwe"),
  dashboardSidebar(minified = FALSE,
                   sidebarMenu(
                     id = "tabs",
                     menuItem("Welcome", tabName = "welcome"),
                     menuItemOutput("data_management"),
                     menuItemOutput("data_overview"),
                     menuItemOutput("microbiology")
                   )
  ),
  dashboardBody(
    useShinyjs(),
    tabItems(
      tabItem("welcome",
              box(width = 8, title = "About Antimicrobial resistance", includeMarkdown("www/welcome.md")),
              box(width = 4, title = "PPS Data",
                  actionButton("show_data", "Explore Zimbabwe PPS Data"),
                  br(), br(), br(), br(),
                  hr(),
                  p("Type password and click 'Access' to open data management section"),
                  passwordInput("password", "Password:"),
                  actionButton("show_data_management", "Access")
              )
      ),
      tabItem("data_management",
              box(width = 12, title = "Forms",
                  includeMarkdown("www/links_forms.md")
              )
      ),
      tabItem("data_overview",
              p("Placeholder for data overview content!")
      ),
      tabItem("microbiology",
              p("Placeholder for microbiology content!")
      )
    )
  )
)

server <- function(input, output, session) { 
  output[["data_management"]] <- renderMenu({
    menuItem("Data Management", tabName = "data_management")
    
  })
  
  output[["data_overview"]] <- renderMenu({
    menuItem("Data Overview", tabName = "data_overview")
  })
  
  output[["microbiology"]] <- renderMenu({
    menuItem("Microbiology", tabName = "microbiology")
  })
  
  # Hide at start
  observe({
    hide(id = "data_management")
    hide(id = "data_overview")
    hide(id = "microbiology")
  })
  
  observeEvent(input$show_data_management, {
    Sys.sleep(0.2)
    if(input$password == Sys.getenv("DM_TAB_PWD")) {
      show(id = "data_management")
      updateTabItems(session, inputId = "tabs", selected = "data_management")
    }
  })
  
  observeEvent(input$show_data, {
    show(id = "data_overview")
    show(id = "microbiology")
  })
}

shinyApp(ui, server)