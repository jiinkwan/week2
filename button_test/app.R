#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

myChoices <- letters[1:5]
runApp(list(
  ui = basicPage(
    checkboxGroupInput('foo', 'FOO', myChoices),
    checkboxInput('bar', 'All/None')
  ),
  server = function(input, output, session) {
    observe({
      updateCheckboxGroupInput(
        session, 'foo', choices = myChoices,
        selected = if (input$bar) myChoices
      )
    })
  }
))

