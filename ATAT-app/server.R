library(shiny)
library(caret)
library(kernlab)
library(formattable)
source("auxfunc.R")
# Load data
load("fitlmgood.Rdata")
load("Data/basepatient.Rdata") # Standard patient from hospcode 072
load("Data/lpatients.Rdata")
load("Data/lrfv.Rdata")
shinyServer(function(input,output,session) {
  # Show predictions
  values = reactiveValues()
  values$count = 1
  values$df = data.frame(name = character(),predict = character(),fasttrack = character(),stringsAsFactors = FALSE)
  observeEvent(input$Predict,{
    values$df <- prednsort(values$df,fitlm,basepatient,input$name,input$age,input$sex,
                           input$chronic,input$arrival,input$rfv,input$temp,
                           input$pulse,input$popct,input$respr,input$bpsys,
                           input$bpdias)
    df = createnewdf(values$df)
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5, "color:green","color:blue"))
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))})
    }
  })
  observeEvent(input$List,{
    values$df <- populate(values$df)
    df = createnewdf(values$df)
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5, "color:green","color:blue"))
    # output$view = renderTable(
    #   df
    # )
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))})
    }
  })
  observeEvent(input$Remove,{
    values$df <- removepatient(values$df)
    df = createnewdf(values$df)
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5, "color:green","color:blue"))
    # output$view = renderTable(
    #   df
    # )
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))})
    }
  })
  observeEvent(input$Fasttrack,{
    values$df <- removefasttrack(values$df)
    df = createnewdf(values$df)
    f1 = formatter("span",style = ~ ifelse(values$df$predict > 3.5, "color:green","color:blue"))
    # output$view = renderTable(
    #   df
    # )
    if (nrow(df) > 0){
      output$view = renderFormattable({formattable(df, list(fasttrack = f1,name = f1))})
    }
  })
  observeEvent(input$Create,{
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
  #   updateCheckboxGroupInput(session,inputId = "chronic", choices = list("Cerebrovascular disease" = 1,
  #                                                             "Congestive heart failure" = 2,
  #                                                             "Condition requiring dialysis" = 3,
  #                                                             "HIV" = 4,"Diabetes" = 5),
  #                            selected = lpatients$chron[[values$count]])
  #   updateCheckboxGroupInput(session, "arrival", choices = list("By ambulance" = 1, "Injury" = 2),
  #                            selected = lpatients$arrival[[values$count]])
    if (values$count < length(lpatients$age)){
      values$count <- values$count + 1
    }
    })
}
)