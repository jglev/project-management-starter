#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)

source("shared.R")

shinyServer(function(input, output, session) {
    
    hide("selected_files")
    hide("delete_all_files")
    
    status_color_groups <- tribble(
        ~id,          ~content,     ~color,
        "TODO",       "TODO",       "#FF0000", 
        "RIGHT NOW",  "RIGHT NOW",  "#0000FF",
        "SCHEDULED",  "SCHEDULED",  "#0000FF",
        "MIGRATED",   "MIGRATED",   "#9370D8",
        "BLOCKED",    "BLOCKED",    "#FFA500",
        "CANCELLED",  "CANCELLED",  "#82d882",
        "DONE",       "DONE",       "#90EE90",
    ) %>% 
        mutate(
            style = paste0("color: ", color)
        )
    
    observeEvent(input$uploaded_files, {
        markdown_files_indexes <- grepl(
            paste0(".*\\.", paste(accepted_extensions, collapse = "|"), "$"), 
            input$uploaded_files$name,
            perl = TRUE
        ) & (
            input$uploaded_files$type == "text/markdown" |
                input$uploaded_files$type == "text/plain"
        )
        
        markdown_files <- input$uploaded_files[markdown_files_indexes,]
        
        choice_names <- NULL
        choice_values <- NULL
        if (length(markdown_files_indexes) != 0) {
            choice_names = markdown_files$name
            choice_values = markdown_files$datapath
        }
        
        updateCheckboxGroupInput(
            session,
            "selected_files",
            choiceNames = choice_names[order(choice_names)],
            choiceValues = choice_values[order(choice_names)],
            selected = choice_values,
            label = "Enabled project files",
            inline = FALSE
        )
        
        show("selected_files")
        show("delete_all_files")
    })
    
    ignore_value <- "IGNORE_VALUE"
    
    observeEvent(input$delete_all_files, {
        
        for (file_to_delete in input$uploaded_files$datapath) {
            file.remove(file_to_delete)
        }
        
        reset("uploaded_files")
        hide("selected_files")
        updateCheckboxGroupInput(
            session,
            "selected_files",
            # These are used because, per ?updateCheckboxGroupEvent, 
            # "Any arguments with NULL values will be ignored; they will not result in any changes to the input object on the client."
            choiceNames = ignore_value,
            choiceValues = ignore_value,
        )
        hide("delete_all_files")
    })
    
    reactive_parsed_data <- reactive({
        
        # Create a blank dataframe, which we'll fill in below:
        parsed_data <- data.frame(
            group=character(),
            content=character(), 
            start=character(), 
            end=character(),
            style=character(),
            start_represents_deadline=logical(),
            stringsAsFactors=FALSE
        )
        
        for (file_to_use in input$selected_files) {
            if (file_to_use == ignore_value) {
                next
            }
            
            raw_text <- readLines(file_to_use)
            
            # Loop though the todo file's lines, and find and parse the todo lines within it:
            # See the ?timevis documentation to understand the column names and
            # values that are used below:
            for (line in raw_text) {
                line_data <- data.frame(
                    group=character(),
                    content=character(), 
                    start=character(), 
                    end=character(),
                    style=character(),
                    start_represents_deadline=logical(),
                    stringsAsFactors=FALSE
                )
                
                status_marker_regex <- "\\s*- \\[(.)\\].*"
                status_marker <- gsub(status_marker_regex, "\\1", line, perl = TRUE)
                
                # If no match was found above, status_marker will be the same as line. In that case, we
                # can consider this not to be a todo line:
                if (status_marker == line) {
                    next 
                }
                
                if (status_marker == " ") {
                    line_data[1, "group"] <- "TODO" 
                } else if (status_marker == "/") {
                    line_data[1, "group"] <- "RIGHT NOW" 
                } else if (status_marker == "x" || status_marker == "X") {
                    line_data[1, "group"] <- "DONE" 
                } else if (status_marker == "V" || status_marker == "v") {
                    line_data[1, "group"] <- "DONE" 
                } else if (status_marker == ">") {
                    line_data[1, "group"] <- "SCHEDULED" 
                } else if (status_marker == "<") {
                    line_data[1, "group"] <- "MIGRATED" 
                } else if (status_marker == "-") {
                    line_data[1, "group"] <- "CANCELLED" 
                } else if (status_marker == "O") {
                    line_data[1, "group"] <- "BLOCKED" 
                }
                
                description <- gsub(
                    paste0(status_marker_regex, "? (.*?)(\\s*(SCHEDULED|DEADLINE).*|$)"),
                    "\\2", 
                    line, 
                    perl = TRUE
                )
                
                if (description != line) {
                    line_data[1, "content"] <- description
                }
                
                scheduled <- gsub(".* SCHEDULED: (.*?)(\\s|$).*", "\\1", line, perl = TRUE)
                if (scheduled != line) {
                    line_data[1, "start"] <- scheduled
                }
                
                deadline <- gsub(".* DEADLINE: (.*?)(\\s|$).*", "\\1", line, perl = TRUE)
                if (deadline != line) {
                    line_data[1, "end"] <- deadline
                }
                
                # These colors are colorblind safe, per https://colorbrewer2.org/#type=diverging&scheme=RdYlBu&n=3:
                scheduled_color <- "#91bfdb"
                deadline_color <- "#fc8d59"
                
                if (!is.na(line_data[1, "start"]) && is.na(line_data[1, "end"])) {
                    line_data[1, "style"] <- paste0("color: black; background: white; border-bottom: .5em solid ", scheduled_color)
                } else if (is.na(line_data[1, "start"]) && !is.na(line_data[1, "end"])) {
                    # timevis requires every charted line to have a 'start' value. In this
                    # case, we will call the Deadline date the "start", but will mark it with a different
                    # color:
                    line_data[1, "start"] <- line_data[1, "end"]
                    line_data[1, "end"] <- NA
                    line_data[1, "style"] <- paste0("color: black; background: white; border: 1px solid ", deadline_color, "; border-bottom: .5em solid ", deadline_color, ";")
                    line_data[1, "start_represents_deadline"] <- TRUE
                } else {
                    # If both start and end are set:
                    line_data[1, "style"] <- paste0("color: black; background: white; border-image-source: linear-gradient(to right, ", scheduled_color,", ", deadline_color, "); border-image-slice: 1; border-bottom: .5em solid; border-top: 1px solid; border-left: 1px solid; border-right: 1px solid;")
                }
                
                parsed_data <- rbind(parsed_data, line_data)
            }
        }
        
        # Return parsed_data:
        parsed_data %>% 
            filter(
                group %in% input$selected_statuses &
                grepl(input$content_search, content, fixed = TRUE)
            )
    })
    
    output$gantt_chart <- renderTimevis({
        reactive_parsed_data() %>% 
            filter(
                !is.na(start)
            ) %>% 
            timevis(
                groups = status_color_groups %>% 
                    filter(
                        id %in% input$selected_statuses
                    )
            )
    })
    
    output$statuses_chart <- renderPlot({
        ggplot(reactive_parsed_data(), aes(
            factor(group, levels = c(
                "DONE",
                "BLOCKED",
                "CANCELLED",
                "MIGRATED",
                "SCHEDULED",
                "RIGHT NOW",
                "TODO"
            )), 
            fill = factor(group)
        )) + 
            xlab("Status") + 
            ylab("Count") +
            geom_bar() + 
            coord_flip() +
            theme_classic() +
            scale_fill_manual(values = c(
                "TODO" = "#FF0000", 
                "RIGHT NOW" = "#0000FF",
                "SCHEDULED" = "#0000FF",
                "MIGRATED" = "#9370D8",
                "CANCELLED" = "#82d882",
                "BLOCKED" = "#FFA500",
                "DONE" = "#90EE90"
            )) + 
            theme(
                legend.position = "none",
                text = element_text(size = 16),
                axis.text.y = element_text(angle = 30, vjust = 0.5)
            )
    })
    
    create_tasks_table <- function(initial_filter_function) {
        datatable(
            reactive_parsed_data() %>% 
                initial_filter_function() %>% 
                select(-style, -start_represents_deadline) %>% 
                rename(
                    Status = group,
                    Description = content,
                    Scheduled = start,
                    Deadline = end
                ) %>% 
                filter(
                    Status %in% input$selected_statuses
                ),
            options = list(pageLength = 25)
        ) %>% formatStyle(
            "Status",
            backgroundColor = styleEqual(
                status_color_groups$content,
                # Add opacity:
                paste0(status_color_groups$color, 25)
            )
        )
    }
    
    output$scheduled_table <- DT::renderDataTable({
        create_tasks_table(
            function(input_table) {
                input_table %>% 
                    filter(
                        # + 14 adds 14 days
                        ymd(start) <= (Sys.Date() + 14) & 
                            group != "DONE"
                    )
            }
        )
    })
    
    output$deadline_table <- DT::renderDataTable({
        create_tasks_table(
            function(input_table) {
                input_table %>% 
                    filter(
                        start_represents_deadline == TRUE &
                            ymd(start) <= (Sys.Date() + 7) & 
                            group != "DONE"
                    )
            }
        )
    })
    
    output$non_scheduled_non_deadline_table <- DT::renderDataTable({
        create_tasks_table(
            function(input_table) {
                input_table %>% 
                    filter(
                        is.na(start) &
                            is.na(end) &
                            group != "DONE"
                    )
            }
        )
    })
})
