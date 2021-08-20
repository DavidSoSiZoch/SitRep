PREP_POPULATION_DATA <- function(data, diverse_imputation){
  
  # This funciton is written based on the package dplyr.
  
  # This function depends on the raw population data from the 
  # population_data.rda file in the /data folder. 
  
  # THis function prepares the raw population data by fitering for the most
  # recent year and imputing data for the diverse gender.
  
  # The imputation for the diverse gender assumes the number of people of
  # diverse gender is 0.1 % of the female population. The divers imputation 
  # can also be excluded by setting diverse_imputation = FALSE
  
  #############################################################################
  
  #filter for latest year
  pop_data <- data %>% 
    dplyr::filter(year == max(year, na.rm = TRUE))
  
  #allocate space for the output outside of the for loop to increase efficiency
  
  #conditional imputation of divers population data
  # instead use pivot wider -> mutate -> pivot longer
  if (diverse_imputation == TRUE){
  for (i in 1:nrow(pop_data)) {
      if (pop_data[i,"gender"] == "f"){
        df <- data.frame(state = pop_data[i,"state"],
                         county = pop_data[i,"county"],
                         gender = "d",
                         age_group = pop_data[i,"age_group"],
                         year = pop_data[i,"year"],
                         population = round(pop_data[i,"population"]*0.001, 0)
        )
        pop_data <- rbind(pop_data, df)
      }
    }
  }
    return(pop_data)
}