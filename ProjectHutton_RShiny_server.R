#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



library(shiny)
library(shinydashboard)
library(plotly)
library(ggplot2)
library(aws.s3)

s3BucketName <- "projecthuttons4"
Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAIPFPQT6N2BLYI6RQ",
           "AWS_SECRET_ACCESS_KEY" = "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",
           "AWS_DEFAULT_REGION" = "us-east-1")


# Define server logic required to draw a histogram
shinyServer(function(session,input, output) {
  
  well_data<-reactive({
    tmp_data<- read.table(input$filetype,sep=",",header=T,na.strings="-999.25")
    tmp_data
  })
  
  #select logs to plot (multi-selection)
  observe({
    updateSelectInput(session,"logs", label = "Select logs to Plot", choices = colnames(well_data()))
    updateSelectInput(session,"xlogs", label = "Select logs to Crossplot", choices = colnames(well_data()))
  })
  
  
  #Display histogram of selected log
  output$distPlot <- renderPlot({
    p<-ggplot(data=well_data(),aes(x=well_data()[[input$logs]],fill="red"))+
      geom_density()+
      xlab(input$logs)+ theme(legend.position="none")
    p
  })
  
  #Display Xplot
  output$XPlot <- renderPlot({
    x<-well_data()[[input$xlogs[1]]]
    y<-well_data()[[input$xlogs[2]]]
    color<-well_data()[[input$xlogs[3]]]
    # draw the histogram with the specified number of bins
    if(!is.null(color)){
      ggplot(data=well_data(),aes(x=x,y=y,colour=color,alpha=0.3))+
        geom_point()+
        xlab(input$xlogs[1])+
        ylab(input$xlogs[2])+
        scale_colour_gradientn(colours = terrain.colors(10),name=input$xlogs[3])
    }else{
      ggplot(data=well_data(),aes(x=x,y=y,fill="black"))+
        geom_point()+
        xlab(input$xlogs[1])+
        ylab(input$xlogs[2])
    }
  })
  
  #Send data to Amazon s3
  observeEvent(input$Submit,{
   if(input$filetype=="C:/Users/kamal/Documents/Python Scripts/las/Pateke-2.csv"){
   file_name<-"C:/Users/kamal/Documents/Python Scripts/las/Pateke-2.las"
   destination_name<-"New_Zealand_wells/Pateke-2.las"
   well_name<-"Pateke-2"
   }else if(input$filetype=="C:/Users/kamal/Documents/Python Scripts/las/Korito-1.csv"){
     file_name<-"C:/Users/kamal/Documents/Python Scripts/las/Korito-1.las"
     destination_name<-"New_Zealand_wells/Korito-1.las"
     well_name<-"Korito-1"
   }else if(input$filetype=="C:/Users/kamal/Documents/Python Scripts/las/Witioria-1.csv"){
     file_name<-"C:/Users/kamal/Documents/Python Scripts/las/Witioria-1.las"
     destination_name<-"New_Zealand_wells/Witioria-1.las"
     well_name<-"Witioria-1"
  }else if(input$filetype=="C:/Users/kamal/Documents/Python Scripts/las/Pakaha-1.csv"){
    file_name<-"C:/Users/kamal/Documents/Python Scripts/las/Pakaha-1.las"
    destination_name<-"New_Zealand_wells/Pakaha-1.las"
    well_name<-"Pakaha-1"
   }
    put_object(file = file_name,object=destination_name , bucket = s3BucketName)
      showModal(modalDialog(
        title = "Successful Transfer to Hutton DynamoDB v1.0",
        paste("Well ",well_name," has been uploaded to Amazon S3. It is now available in Dynamo DB.")))
    })
  
})
