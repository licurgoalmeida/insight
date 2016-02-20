# server.R is concerned with the under the hood process of the app. Particularly the interactions between
# user inputs and the machine learning model. These interaction are implemented in auxfunc.R
# Licurgo de Almeida (licurgoalmeida@gmail.com)
# 01/25/2016
library(shiny)
library(caret)
library(kernlab)
library(formattable)
source("auxfunc.R")
# Load data
load("fitlmgood.Rdata") # load linear model object
load("Data/basepatient.Rdata") # Standard patient used in the linear model. This patient
                               # carries information from hospcode 072
load("Data/lpatients.Rdata") # Load list of pre-defined patients to use duting the demonstration
load("Data/lrfv.Rdata") # # Load reason for visit table
shinyServer(function(input,output,session) {
  # Show predictions
  values = reactiveValues() # create variable that stores other variables
  values$count = 1 # counter for pre-defined patients
  values$df = data.frame(name = character(),predict = character(),fasttrack = character(),
                         stringsAsFactors = FALSE) # Create output data frame
  observeEvent(input$Predict,{
    values$df <- prednsort(values$df,fitlm,basepatient,input$name,input$age,input$sex,
                           input$chronic,input$arrival,input$rfv,input$temp,
                           input$pulse,input$popct,input$respr,input$bpsys,
                           input$bpdias) # Call predictor for arriving patient.
    df = createnewdf(values$df) # Create temporary data frame.
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5,
                                           "color:green","color:blue")) # Define format for temporary
                                                                        # data frame
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))}) # Print formatted
                                                                                         # data frame
    } else {
      output$view = renderFormattable({formattable(df, list())})
    }
  })
  observeEvent(input$List,{
    values$df <- populate(values$df) # Populate waiting list with some pre-defined patients
    df = createnewdf(values$df) # Create temporary data frame.
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5,
                                           "color:green","color:blue")) # Define format for temporary
                                                                        # data frame
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))}) # Print formatted
                                                                                         # data frame
    } else {
      output$view = renderFormattable({formattable(df, list())})
    }
  })
  observeEvent(input$Remove,{
    values$df <- removepatient(values$df) # Remove patient from waiting room (send to ER)
    df = createnewdf(values$df) # Create temporary data frame.
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5,
                                           "color:green","color:blue")) # Define format for temporary
                                                                        # data frame
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))}) # Print formatted
                                                                                         # data frame
    } else {
      output$view = renderFormattable({formattable(df, list())})
    }
  })
  observeEvent(input$Fasttrack,{
    values$df <- removefasttrack(values$df) # Remove patient from waiting room (send to fasttrack)
    df = createnewdf(values$df) # Create temporary data frame.
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5,
                                           "color:green","color:blue")) # Define format for temporary
                                                                        # data frame
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))}) # Print formatted
                                                                                         # data frame
    } else {
      output$view = renderFormattable({formattable(df, list())})
    }
  })
  observeEvent(input$Create,{ # Create pre-defined patient
    updateTextInput(session,"name",value = lpatients$name[values$count])
    updateNumericInput(session, "age", value = lpatients$age[values$count])
    updateNumericInput(session, "temp", value = lpatients$temp[values$count])
    updateNumericInput(session, "pulse", value = lpatients$pulse[values$count])
    updateNumericInput(session, "popct", value = lpatients$pulseox[values$count])
    updateNumericInput(session, "respr", value = lpatients$resp[values$count])
    updateNumericInput(session, "bpsys", value = lpatients$bpsys[values$count])
    updateNumericInput(session, "bpdias", value = lpatients$bpdia[values$count])
    updateSelectizeInput(session,"rfv",choices = lrfv,selected = lpatients$rfv[[values$count]])
    updateRadioButtons(session, "sex", choices = list("Female" = 1, "Male" = 2),
                       selected = lpatients$sex[values$count],inline = TRUE)
    if (values$count < length(lpatients$age)){
      values$count <- values$count + 1
    }
    })
}
)