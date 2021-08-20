INCIDENCE7 <- function(sormas_persons, population_data, daterange, level = "country") {
  
  # This function is written based on the package dplyr.
  
  # This function depends on the sormas_persons and population_data, for 
  # this test application.
  
  # This function creates a table with the 7 day incidence values on the
  # requested level ('county', 'state' or 'country').
  
  #############################################################################
  
  if(level == "country"){
  n_cases <- sormas_persons %>% 
      dplyr::filter(reporting_date %in% daterange) %>% 
      dplyr::filter(case_category == "confirmed") %>% 
      dplyr::count() %>% 
      dplyr::rename(Incidence = n)
  
  tot_pop <- sum(population_data$population)
  
  incidences <-round(100000*n_cases/tot_pop, 2)
  
  } else if(level == "state"){
    state_pop <- population_data %>% 
      dplyr::group_by(state) %>% 
      dplyr::summarise(s_pop = sum(population))
    
    state_n_cases <- sormas_persons %>% 
      dplyr::group_by(state) %>% 
      dplyr::filter(reporting_date %in% daterange) %>% 
      dplyr::filter(case_category == "confirmed") %>% 
      dplyr::count()
      
    joined_df <- dplyr::left_join(state_pop, state_n_cases, by = "state") %>% 
      base::replace(is.na(.), 0)
      
    incidences <- joined_df %>% 
      dplyr::mutate(Incidence = round(100000*n/s_pop,2)) %>% 
      dplyr::select(state, Incidence)
    
  } else if (level == "county"){
    county_pop <- population_data %>% 
      dplyr::group_by(county) %>% 
      dplyr::summarise(c_pop = sum(population))
    
    county_n_cases <- sormas_persons %>% 
      dplyr::group_by(county) %>% 
      dplyr::filter(reporting_date %in% daterange) %>% 
      dplyr::filter(case_category == "confirmed") %>% 
      dplyr::count()
    
    joined_df <- dplyr::left_join(county_pop, county_n_cases, by = "county") %>% 
      base::replace(is.na(.), 0)
    
    incidences <- joined_df %>% 
      dplyr::mutate(Incidence = round(100000*n/c_pop,2))%>% 
      dplyr::select(county, Incidence)
    
  } else {
    stop("Need to correctly specify level!")
  }
  return(incidences)
}