# insight
Those are the scripts and functions used to implement the ATAT app (https://atat.shinyapps.io/ATAT-app/). The ATAT (Automatic Triage Assignment Tool) is an web application to help nurses evaluating the triage score of patients. Specifically, the app collects a small set of information about visitors of the emergency room - such as chief complain (reason for visit), vital signs and historic of chronic diseases - and tries to estimate the triage score of this visitors. The triage score is a 5 level scale where level 1 patient's demand urgent care (i.e. cardiac arrest) while level 5 patients present no immediate life treating problems and can wait longer for care.
The data for this project came from the National Hospital Ambulatory Medical Care Survey and can be found at http://www.cdc.gov/nchs/ahcd/ahcd_questionnaires.htm

The  scripts used to implement the app are found in the ATAT-app folder. The app was implementing using R and the web application framework Shiny.
Other scripts and functions were mostly used for some exploration of the data, such as feature selection and model performance.
