#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(graphics)
library(datasets)
library(dplyr)
library(ggplot2)
train <- titanic_train
test <- titanic_test

train$Pclass <- factor(train$Pclass)
train$Sex <- factor(train$Sex)
train$SibSp <- factor(train$SibSp)
train$Parch <- factor(train$Parch)
train$Embarked <- factor(train$Embarked)
train$Survived <- factor(train$Survived, labels = c("No","Yes"))
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

shinyServer(function(input, output,session) {
  observe({
    if(length(input$Pclass) < 1)
    {
      updateCheckboxGroupInput(session, "Pclass", selected = "1")
    }
    if(length(input$Sex) < 1)
    {
      updateCheckboxGroupInput(session, "Sex", selected = "female")
    }
    if(length(input$SibSp) < 1)
    {
      updateCheckboxGroupInput(session, "SibSp", selected = "0")
    }
    if(length(input$Parch) < 1)
    {
      updateCheckboxGroupInput(session, "Parch", selected = "0")
    }
    if(length(input$Embarked) < 1)
    {
      updateCheckboxGroupInput(session, "Embarked", selected = "")
    }
  })

  output$table <- renderDataTable({ 
    data1 <- transmute(train, Pclass = Pclass, Sex = Sex, SibSp = SibSp, Parch = Parch, Embarked = Embarked) 
    data1 <- filter(train, Pclass %in% as.character(input$Pclass),Sex %in% as.character(input$Sex)
                   ,SibSp %in% as.character(input$SibSp),Parch %in% as.character(input$Parch),Embarked %in% as.character(input$Embarked)) 
    data1 
  }, options = list(lengthMenu = c(5, 15, 30), pageLength = 30))
  output$plot <- renderPlot({
    data1 <- transmute(train, Pclass = Pclass, Sex = Sex, SibSp = SibSp, Parch = Parch, Embarked = Embarked) 
    data1 <- filter(train, Pclass %in% as.character(input$Pclass),Sex %in% as.character(input$Sex)
                    ,SibSp %in% as.character(input$SibSp),Parch %in% as.character(input$Parch),Embarked %in% as.character(input$Embarked))
    g <- ggplot(data1, aes_string(input$Variable))                    
    g <- g + geom_bar(aes(fill=Survived), width = 0.5) + theme(axis.text.x = element_text(angle=65, vjust=0.6)) + labs(title="Survivors")
    g
  })
  output$meanTable <- renderDataTable({
    setNames(aggregate(as.numeric(train[,2])-1, list(train[, input$Variable]), mean),
             c(as.character(input$Variable),"Survival Rates"))
  })
  output$oVariable <- renderPrint({input$Variable})
  output$oClass <- renderPrint({input$PClass})
  output$oSex <- renderPrint({input$Sex})
  output$oSibSp <- renderPrint({input$SibSp})
  output$oParch <- renderPrint({input$Parch})
  output$oEmbarked <- renderPrint({input$Embarked})
})
