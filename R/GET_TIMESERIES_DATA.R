GET_TIMESERIES_DATA <- function(sormas_persons){
  
  # This function is written based on the packages dplyr and tidyr.
  
  # This function depends on the sormas_persons data for 
  # this test application.
  
  # This function creates a table of timeseries data, where each observation
  # is one date. 
  # For each date there are variables on the number of reported cases,
  # hospitalizations and deaths on that day, as well as number of cases by
  # date of onset of disease.
  
  # In this example SitRep we use the dates from 2020-01-04 to 2021-05-30.
  # In the real application a dynamically defined vector of all the dates
  # of the last 365 days can be used.
  
  #############################################################################
  
  #CALLING VECTOR OF DATES AND CREATING DATAFRAME
  #dates would be dynamic in real application!
  # for example:
  # dt =  seq(Sys.Date()-365, Sys.Date(), by = "day")
  
  dt <- seq.Date(as.Date("2020-01-04"),
                    as.Date("2021-05-30"),
                    by = "day")

  ts_data <- data.frame(date = dt)
  
  #CALLING TIMESERIES DATA FOR DIFFERENT VARIABLES
  
  #time series data cases, reporting date
  ts_data_reporting <- sormas_persons %>% 
    dplyr::group_by(reporting_date) %>% 
    dplyr::count(case_category) %>% 
    tidyr::pivot_wider(names_from = case_category,
                       names_prefix= "rep_",
                       values_from = n) %>% 
    dplyr::rename(date = reporting_date)
  
  #time series data cases, onset date 
  ts_data_onset <- sormas_persons %>% 
    dplyr::group_by(onset_date) %>% 
    dplyr::count(case_category) %>% 
    tidyr::pivot_wider(names_from = case_category,
                       names_prefix= "on_",
                       values_from = n) %>% 
    dplyr::rename(date = onset_date)
  
  #time series data hosp, hosp date 
  ts_data_hosp <- sormas_persons %>% 
    dplyr::group_by(hospitalization_date) %>% 
    dplyr::count(hospitalized) %>% 
    tidyr::pivot_wider(names_from = hospitalized,
                       names_prefix= "hosp_",
                       values_from = n) %>% 
    dplyr::rename(date = hospitalization_date)
  
  #time series data died, reporting date death 
  ts_data_died <- sormas_persons %>% 
    dplyr::group_by(reporting_date_death) %>% 
    dplyr::count(died) %>% 
    tidyr::pivot_wider(names_from = died,
                       names_prefix= "died_",
                       values_from = n) %>% 
    dplyr::rename(date = reporting_date_death)
  
  # JOINING TIMESERIES DATA
  # and replacing NA with 0
  ts_data <- dplyr::left_join(ts_data,
                              ts_data_reporting,
                              by = "date") %>% 
    dplyr::left_join(., ts_data_onset, by = "date") %>% 
    dplyr:: left_join(., ts_data_hosp, by = "date") %>% 
    dplyr:: left_join(., ts_data_died, by = "date") %>% 
    base::replace(is.na(.), 0)
  
  return(ts_data)
}