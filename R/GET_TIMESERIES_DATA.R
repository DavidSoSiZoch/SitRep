GET_TIMESERIES_DATA <- function(persons_sormasdata){
  require(tidyr)
  require(dplyr)
  
  #CALLING VECTOR OF DATES AND CREATING DATAFRAME
  #dates would be dynamic in real application!
  
  dt <- seq.Date(as.Date("2020-01-04"),
                    as.Date("2021-05-30"),
                    by = "day")

  ts_data <- data.frame(date = dt)
  
  #CALLING TIMESERIES DATA FOR DIFFERENT VARIABLES
  
  #time series data cases, reporting date
  ts_data_reporting <- persons_sormasdata %>% 
    dplyr::group_by(reporting_date) %>% 
    dplyr::count(case_category) %>% 
    tidyr::pivot_wider(names_from = case_category,
                       names_prefix= "rep_",
                       values_from = n) %>% 
    dplyr::rename(date = reporting_date)
  
  #time series data cases, onset date 
  ts_data_onset <- persons_sormasdata %>% 
    dplyr::group_by(onset_date) %>% 
    dplyr::count(case_category) %>% 
    tidyr::pivot_wider(names_from = case_category,
                       names_prefix= "on_",
                       values_from = n) %>% 
    dplyr::rename(date = onset_date)
  
  #time series data hosp, hosp date 
  ts_data_hosp <- persons_sormasdata %>% 
    dplyr::group_by(hospitalization_date) %>% 
    dplyr::count(hospitalized) %>% 
    tidyr::pivot_wider(names_from = hospitalized,
                       names_prefix= "hosp_",
                       values_from = n) %>% 
    dplyr::rename(date = hospitalization_date)
  
  #time series data died, reporting date death 
  ts_data_died <- persons_sormasdata %>% 
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