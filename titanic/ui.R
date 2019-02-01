#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(titanic)
train <- titanic_train
test <- titanic_test

## Preprocessing
### Factorizing
train$Pclass <- factor(train$Pclass)
train$Sex <- factor(train$Sex)
train$SibSp <- factor(train$SibSp)
train$Parch <- factor(train$Parch)
train$Embarked <- factor(train$Embarked)
train$Survived <- factor(train$Survived)
test$Pclass <- factor(test$Pclass)
test$Sex <- factor(test$Sex)
test$SibSp <- factor(test$SibSp)
test$Parch <- factor(test$Parch)
test$Embarked <- factor(test$Embarked)

classChoices <- c(unique(levels(train$Pclass)))
sexChoices <- c(unique(levels(train$Sex)))
sibspChoices <- c(unique(levels(train$SibSp)))
parchChoices <- c(unique(levels(train$Parch)))
embarkedChoices <- c(unique(levels(train$Embarked)))
variableChoices <- c("Pclass","Sex","Embarked")
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  headerPanel("Titanic Survivors"),
  # Sidebar with a slider input for number of bins 
  
    sidebarPanel(
      selectInput("Variable", "Plot Variable", variableChoices, selected = "Pclass" )
      ,checkboxGroupInput("Pclass", "Class: ", classChoices, selected = classChoices)
      ,checkboxGroupInput("Sex", "Sex: ", sexChoices, selected = sexChoices)
      ,checkboxGroupInput("SibSp", "SibSp: ", sibspChoices, selected = sibspChoices)
      ,checkboxGroupInput("Parch", "Parch: ", parchChoices, selected = parchChoices)
      ,checkboxGroupInput("Embarked", "Embarked: ", embarkedChoices, selected = embarkedChoices)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3('Survivors')      
      #,h4('Variables')
      ,plotOutput('plot')
      ,dataTableOutput('table')
      

    )
  )
)
