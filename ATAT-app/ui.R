library(shiny)
library(formattable)
load("Data/lrfv.Rdata")
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
                    background-color: #1a8cff;
                    }
                    
                    .option-group {
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    padding: 4px 5px;
                    margin: 5px -10px;
                    background-color: white;
                    }

                    p {
                    margin: 0px -1px;
                    padding: 0px -1px;
                    }
                    
                    h1 {
                    color: white;
                    }
                    .option-header {
                    color: #1a8cff;
                    text-transform: uppercase;
                    font: bold;
                    margin-bottom: 5px;
                    }
                    "))
    ),
  titlePanel(title = HTML("<h1><font size=\"20\">A</font><font size=\"6\">utomated</font>
                          <font size=\"20\">T</font><font size=\"6\">riage</font>
                          <font size=\"20\">A</font><font size=\"6\">ssignment</font>
                          <font size=\"20\">T</font><font size=\"6\">ool</font></h1>"),
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