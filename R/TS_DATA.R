TS_DATA <- function(date_type, variable){
  ts_data <- persons %>% 
    dplyr::group_by(date_type) %>% 
    dplyr::count(variable) %>% 
    tidyr::pivot_wider(names_from = variable, values_from = n)
  return(ts_data)
}