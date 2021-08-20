GET_POPULATION_DATA <- function(population_data, county, state, gender, age_group){
  
  # This function is written based on the package dplyr.
  
  # This function depends on the population_data for this test application.
  
  # This function is only called within the 'GET_MASTER_TABLE.R' function.
  
  #############################################################################
  
  output <-  population_data %>% 
    dplyr::group_by({{ state }},{{ county }}, {{ gender }}, {{ age_group }}) %>% 
    dplyr::summarise(population = sum(population)) %>% 
    dplyr::distinct()
  
  return(output)
}
