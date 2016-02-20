# ui.R creates the app's interface, placing buttons and text boxes.
# Licurgo de Almeida (licurgoalmeida@gmail.com)
# 01/25/2016
library(shiny)
library(formattable)
load("Data/lrfv.Rdata") # Load reason for visit table
shinyUI(fluidPage(
  # Some custom CSS
  tags$head(
    tags$style(HTML("
                    /* Smaller font for preformatted text */
                    pre, table.table {
                    font-size: smaller;
                    }
                    #Predict {
                    background-color:red;
                    color: white;
                    }
                    #Remove {
                    background-color:blue;
                    color: white;
                    }
                    #view {
                    font-size: 30px;
                    }
                    #Fasttrack {
                    background-color:green;
                    color: white;
                    }
                    body {
                    background-color: white;
                    }
                    
                    .option-group {
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    padding: 4px 5px;
                    margin: 5px -10px;
                    background-color: #f5f5f5;
                    }

                    p {
                    margin: 0px -1px;
                    padding: 0px -1px;
                    }
                    
                    h1 {
                    color: blue;
                    margin: 0px -1px;
                    padding: 0px -1px;
                    }
                    .option-header {
                    color: #1a8cff;
                    text-transform: uppercase;
                    font: bold;
                    margin-bottom: 5px;
                    }
                    "))
    ),
  titlePanel(title = HTML("<a href=\"https://docs.google.com/presentation/d/1D0b5w0qja8fQ2EQDL2pGoqpxRR5IU24X5dpIxTyq-38/pub?start=false&loop=false&delayms=3000\">
                          <h1><font size=\"10\">A</font><font size=\"4\">utomated</font>
                          <font size=\"10\">T</font><font size=\"4\">riage</font>
                          <font size=\"10\">A</font><font size=\"4\">ssignment</font>
                          <font size=\"10\">T</font><font size=\"4\">ool</font></h1></a>"),
             windowTitle = "ATAT"),
  fluidRow(
    column(3,div(class = "option-group",div(class = "option-header", "Demo use only"),
    actionButton("Create","Load Example"),
    actionButton("List","Populate List")),
    div(class = "option-group",div(class = "option-header", "Basic Information"),
    textInput("name", label = p("Name:"), value = ""),
    numericInput('age', label = p("Age (years):"), 0,min = 0, max = 120),
    radioButtons("sex", label = p("Sex:"),choices = list("Female" = 1, "Male" = 2),
                 selected = 1,inline = TRUE)),
    div(class = "option-group",div(class = "option-header", "Chronic disease"),
    checkboxGroupInput(inputId = "chronic", label = NULL, 
                       choices = list("Cerebrovascular disease" = 1, "Congestive heart failure" = 2,
                                      "Condition requiring dialysis" = 2,"HIV" = 4,"Diabetes" = 5))),
    div(class = "option-group",div(class = "option-header", "Arrival information"),
    checkboxGroupInput("arrival", label = NULL, 
                       choices = list("By ambulance" = 1, "Injury" = 2),inline = TRUE)
  )),
  column(2,div(class = "option-group",div(class = "option-header", "Reasons for visit"),
    selectizeInput('rfv', label = NULL,
                   choices = lrfv, multiple = TRUE)),
    div(class = "option-group",div(class = "option-header", "Vital signs"),
    numericInput('temp', label = p("Temperature (F):"), 98,min = 0, max = 120),
    numericInput('pulse', label = p("Pulse:"), 65,min = 7, max = 200),
    numericInput('popct', label = p("Pulse oximetry:"), 98,min = 0, max = 200),
    numericInput('respr', label = p("Respiratory rate:"), 16,min = 0, max = 200),
    numericInput('bpsys', label = p("Systolic blood pressure:"), 117,min = 0, max = 200),
    numericInput('bpdias', label = p("Diastolic blood pressure:"), 76,min = 0, max = 200)
  )),
    
    column(4,div(class = "option-group",div(class = "option-header", "Priority list"),
      actionButton("Predict","Add to List"),
      actionButton("Remove","Send to ER"),
      actionButton("Fasttrack","Send to Fast-Track"),
      #tableOutput("view")
      formattableOutput("view")
    ))
)))