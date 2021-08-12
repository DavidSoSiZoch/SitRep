GET_POPULATION_DATA <- function(pop_data, county, state, gender, age_group){
  require(dplyr)
  
  output <-  pop_data %>% 
    dplyr::group_by({{ state }},{{ county }}, {{ gender }}, {{ age_group }}) %>% 
    dplyr::summarise(population = sum(population)) %>% 
    dplyr::distinct()
  
  return(output)
}
