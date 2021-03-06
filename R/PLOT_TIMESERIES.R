PLOT_TIMESERIES <- function(timeseries_data){
  
  # This function is written based on the packages ggplot2 and gridExtra.
  
  # This function depends on the output of the 'GET_TIMESERIES_DATA.R' 
  # function.
  # It provides a plot that is based on the timeseries data output of the 
  # 'GET_TIMESERIES_DATA.R' function.
  
  #############################################################################
  
  # setting date and daterange
  
  #last date for reporting_date in testdata is 15 of April 2021
  today = as.Date("2021-04-15")
  
  # in real application instead:
  # today = Sys.Date()
  
  #theme
  theme_set(theme_bw())
  
  #Timeseries confirmed cases by reporting date
  p1 <- ggplot2::ggplot(timeseries_data, aes(x=date, y =rep_confirmed )) +
    geom_line(color = "steelblue", size =1.5)+
    labs(x="", y="", subtitle = "Cases by reporting date")+
    scale_x_date(date_breaks = "3 months")+
    xlim(as.Date("2020-01-01"), today)
  
  p2 <- ggplot2::ggplot(timeseries_data, aes(x = date, y = on_confirmed))+
    geom_line(color = "darkred", size = 1.5)+
    labs(x="", y="", subtitle = "Cases by onset of disease")+
    scale_x_date(date_breaks = "3 months")+
    xlim(as.Date("2020-01-01"), today)
  
  p3 <- ggplot2::ggplot(timeseries_data, aes(x = date, y = hosp_TRUE))+
    geom_line(color = "#E69F00", size = 1)+
    labs(x="", y="", subtitle = "Hospitalizations by hospitalisation date")+
    scale_x_date(date_breaks = "3 months")+
    xlim(as.Date("2020-01-01"), today)
  
 gridExtra::grid.arrange(p1,p2,p3)
 
}