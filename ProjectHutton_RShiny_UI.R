library(shinydashboard)
library(plotly)
options(autoWidth = F)

header<- dashboardHeader(title = "Hutton Web App",
                         dropdownMenu(type = "notifications",
                                      notificationItem(
                                        text = "Some Wells need validation",
                                        icon("users")
                                      )
                         ))

#Define content of sidebar
sidebar<- dashboardSidebar(
  sidebarMenu(
    selectizeInput(inputId="filetype",label="Select Well",
                   choices=c("Korito-1"="C:/Users/kamal/Documents/Python Scripts/las/Korito-1.csv",
                             "Pakaha-1"="C:/Users/kamal/Documents/Python Scripts/las/Pakaha-1.csv",
                             "Pateke-2"="C:/Users/kamal/Documents/Python Scripts/las/Pateke-2.csv",
                             "Witioria-1"="C:/Users/kamal/Documents/Python Scripts/las/Witioria-1.csv")),
    menuItem("Validate Well", tabName = "Well", icon = icon("dashboard")),
    menuItem("Scatter Plots",tabName="dash_scatter",icon=icon("braille")),
    actionButton(label="Submit to DB",inputId="Submit")
  )
)

#Dasboard body definition. Gives content of each dashboard entry
body<-dashboardBody(
  tabItems(
    # First tab content
    tabItem(
      tabName = "Well",
      fluidRow(
        box(title="Select logs to display histogram",
            selectInput(inputId="logs",label="Select Logs",choices=""),
            plotOutput("distPlot")
            
        ),
        box(title="Select logs to crossplot",
            selectInput(inputId="xlogs",label="Select Logs",choices="",multiple=T),
            plotOutput("XPlot")
        )
      )
    )
  )
)


#Run UI
ui <- dashboardPage(header,sidebar,body,skin="blue")