INCIDENCE7 <- function(persons_sormasdata, population_data, daterange, level = "country") {
  require(dplyr)
  
  if(level == "country"){
  n_cases <- persons_sormasdata %>% 
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
    
    state_n_cases <- d %>% 
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
    
    county_n_cases <- d %>% 
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