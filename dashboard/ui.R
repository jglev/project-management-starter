#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(dplyr)
library(DT)
library(ggplot2)
library(lubridate)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinythemes)
library(timevis)

source("shared.R")

statuses_to_choose <- c(
    "TODO",
    "RIGHT NOW",
    "SCHEDULED",
    "MIGRATED",
    "CANCELLED",
    "BLOCKED",
    "DONE"
)

dashboardPage(
    useShinyjs(),
    skin = "black",
    
    header = dashboardHeader(
        title = "Project Dashboard"
    ),
    sidebar = dashboardSidebar(
        fileInput(
            "uploaded_files",
            "Files (Markdown)",
            multiple = TRUE,
            accept = c("text/plain", "text/markdown"),
            buttonLabel = "Select file(s)"
        ),
        checkboxGroupInput(
            "selected_files",
            label = NULL,
            inline = TRUE
        ),
        actionButton(
            "delete_all_files", 
            label = "Delete all files from server",
            icon = icon("trash")
        ),
        hr(),
        sidebarSearchForm(textId = "content_search", buttonId = "searchbtn", label = "Search descriptions..."),
        checkboxGroupInput(
            "selected_statuses",
            label = "Statuses",
            inline = FALSE,
            choices = statuses_to_choose,
            selected = statuses_to_choose
        ),
        hr(),
        sidebarMenu(
            menuItem("Visual", tabName = "visual", icon = icon("chart-bar")),
            menuItem("Tabular", tabName = "tabular", icon = icon("table")),
            menuItem("About", tabName = "about", icon = icon("asterisk"))
        )
    ),
    body = dashboardBody(
        tags$head(
            # This follows https://community.rstudio.com/t/overflow-scroll-for-shinydashboard-sidebar/2888/2,
            # for getting the sidebar to scroll on overflow:
            tags$script(
                type="text/javascript",
                '$(document).ready(function(){
                     $(".main-sidebar").css("height","100%");
                     $(".main-sidebar .sidebar").css({"position":"relative","max-height": "100%","overflow": "auto"})
                 })'
            )
        ),
        
        
        tabItems(
            # First tab content
            tabItem(
                tabName = "visual",
                fluidRow(
                    box(timevisOutput("gantt_chart"), width = 12),
                    box(plotOutput("statuses_chart", height = "40vh"), width = 12)
                )
            ),
            tabItem(
                tabName = "tabular",
                fluidRow(
                    box(
                        tabBox(type = "tabs",
                            id = "selected_table_tab",
                            tabPanel(
                                "Scheduled",
                                p("Items scheduled to begin work within the next two weeks."),
                                br(),
                                dataTableOutput("scheduled_table")
                            ),
                            tabPanel(
                                "Due",
                                p("Items with deadlines within the next week."),
                                br(),
                                dataTableOutput("deadline_table")
                            ),
                            tabPanel(
                                "Other",
                                p("Items that have neither a Scheduled nor Deadline date."),
                                br(),
                                dataTableOutput("non_scheduled_non_deadline_table")
                            ),
                            width = 12
                        ),
                        width = 12
                    )
                )
            ),
            tabItem(
                tabName = "about",
                fluidRow(
                    box(
                        HTML(paste0("
                            <p>
                                This app's code, and an explanation of the Project Management concepts and approach for the workflow that this app facilitates, are available at <a href='https://github.com/publicus/project-management-starter'>this GitHub repository</a>.
                            </p>
                            <p>
                                It expects that uploaded files have a name that ends in a <a href='https://guides.github.com/features/mastering-markdown/'>Markdown</a> extension (<code>", paste(accepted_extensions, collapse = "</code>, <code>"),"</code>), and that they follow <a href='https://github.com/publicus/project-management-starter/blob/master/Project_Notes_Example.md#conventions-in-this-document'>several conventions</a> and use <a href='https://raw.githubusercontent.com/publicus/project-management-starter/master/key.md'>any of a list of pre-defined 'todo' list markers</a>.
                            </p> 
                        ")),
                        width = 12
                    ),
                )
            )
        )
    )
)
