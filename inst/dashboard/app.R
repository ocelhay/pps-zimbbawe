library(glue)
library(markdown)
library(ruODK)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(tidyverse)

cred_group <- c("Data Management", "Country", "Gwanda Provincial Hospital",
                "Harare Central Hospital", "Inyathi District Hospital",
                "Kariba District Hospital", "Mpilo Central Hospital",
                "Murewa District Hospital", "Mutare Provincial Hospital",
                "Ndanga District Hospital", "Shamva District Hospital")

vec_files_cred <- list.files(path = "./www/cred/")

read_encrypted_cred <- function(rds, pwd) {
  tmp <- readRDS(rds)
  pwd_sha256 <- openssl::sha256(charToRaw(pwd))
  unserialize(openssl::aes_cbc_decrypt(tmp, key = pwd_sha256))
}

ui <- dashboardPage(
  skin = "blue",
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
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    useShinyjs(),
    tabItems(
      tabItem("welcome",
              box(width = 8, title = "About Antimicrobial resistance", includeMarkdown("www/welcome.md")),
              box(width = 4, title = "Connection",
                  selectInput("cred_group", "Group:", choices = cred_group),
                  textInput("cred_user", tagList(icon("user"), "User:")),
                  passwordInput("cred_password", tagList(icon("key"), "Password:")),
                  actionButton("cred_login", "Log In")
              )
      ),
      tabItem("data_management",
                       box(width = 3, title = "Link to Forms",
                           includeMarkdown("www/links_forms.md")
                       ),
                       box(width = 3, title = "Data Entry Indicators",
                           DT::DTOutput("indicators_table")
                       ),
                       box(width = 6, status = "danger", solidHeader = TRUE, title = "Quality Control",
                           strong("Issues requiring action:"),
                           DT::DTOutput("qc_table")
                       ),
                tabBox(width = 12, title = "Data Tables",
                       tabPanel("Ward data table",
                                DT::DTOutput("ward_table")
                       ),
                       tabPanel("Patient data table",
                                DT::DTOutput("patient_table")
                       ),
                       tabPanel("Antibio data table",
                                DT::DTOutput("antibio_table")
                       ),
                       tabPanel("Microbio data table",
                                DT::DTOutput("microbio_table")
                       )
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
  
  # Source R files to generate outputs.
  file_list <- list.files(path = "./www/R/outputs", pattern = "*.R", recursive = TRUE)
  for (file in file_list) source(paste0("./www/R/outputs/", file), local = TRUE)$value
  
  # Definition of reactive elements.
  cred_rval <- reactiveVal()
  ward_data <- reactiveVal()
  patient_data <- reactiveVal()
  antibio_data <- reactiveVal()
  microbio_data <- reactiveVal()
  
  # Hide at start
  observe({
    hide(id = "data_management")
    hide(id = "data_overview")
    hide(id = "microbiology")
  })
  
  observeEvent(input$cred_login, {
    Sys.sleep(0.2)
    file_cred <- glue("encrypted_cred_{input$cred_group}_{input$cred_user}.rds")
    
    # Test if credentials for this user name exist.
    if (! file_cred %in% vec_files_cred) {
      showNotification("Wrong connection credentials.", type = "error")
      return()
    }
    
    # Test if the password is correct.
    cred <- try(read_encrypted_cred(glue("./www/cred/{file_cred}"), input$cred_password))
    if (inherits(cred, "try-error")) {
      showNotification("Wrong password.", type = "error")
      return()
    }
    
    ru_setup(url = cred$odk_url, un = cred$odk_login, pw = cred$odk_pwd)
    
    # Download data, update credentials with values and open.
    showNotification("Successfully logged in. Downloading PPS Data...", type = "message")
    
    ward_data_odk     <- odata_submission_get(pid = 2, fid = "pps_ward")
    patient_data_odk  <- odata_submission_get(pid = 2, fid = "pps_patient")
    
    antibio_data_odk  <- odata_submission_get(pid = 2, fid = "pps_antibio")
    
    # additional issue with looping through tables
    # https://docs.ropensci.org/ruODK/articles/odata-api.html#odata-service-document
    # antibio_data_list  <- odata_service_get(pid = 2, fid = "pps_antibio")
    # antibio_data_1 <- ruODK::odata_submission_get(table = antibio_data_list$name[1], local_dir = loc)
    
    
    microbio_data_odk <- odata_submission_get(pid = 2, fid = "pps_microbiology")
    
    source("./www/R/tidy_odk_submissions.R", local = TRUE)
    source("./www/R/remove_odk_submissions.R", local = TRUE)
    source("./www/R/join_odk_submissions.R", local = TRUE)
    
    ward_data(ward_data_odk)
    patient_data(patient_data_odk)
    antibio_data(antibio_data_odk)
    microbio_data(microbio_data_odk)
    
    # Tab management
    if (cred$data_management)  show(id = "data_management")
    show(id = "data_overview")
    show(id = "microbiology")
    
    cred_rval(cred)
  })
}

shinyApp(ui, server)