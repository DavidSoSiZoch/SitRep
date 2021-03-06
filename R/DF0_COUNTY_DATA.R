DF0_COUNTY_DATA <- function(matching_key){
  
  # This function depends on the matching key, for this test application
  # specifically the healthauthority_county_key.
  
  # This function creates a dataframe, with the first 3 columns equal to 
  # the three columns of the matching key. The rest of the dataframe is filled 
  # with zeros.
  # Each observation is one county.
  # The varialbles for each county can be seen from the list of colnames below.
  # The created dataframe is used later on to be updated with data from the
  # sormas_persons on the the county level values for each variable
  # listed below.
  
  #############################################################################
  
  df0 <- data.frame(matrix(0, ncol = 23, nrow = nrow(matching_key)))
  colnames(df0) <- c("state",
                     "county",
                     "health_authority",
                     "population",
                     "case_category_confirmed",
                     "case_category_none",
                     "case_category_suspected",
                     "hospitalized_FALSE",
                     "hospitalized_NA",
                     "hospitalized_TRUE",
                     "died_FALSE",
                     "died_NA",
                     "died_TRUE",
                     "new_case_category_confirmed",
                     "new_case_category_none",
                     "new_case_category_suspected",
                     "new_hospitalized_FALSE",
                     "new_hospitalized_NA",
                     "new_hospitalized_TRUE",
                     "new_died_FALSE",
                     "new_died_NA",
                     "new_died_TRUE",
                     "n")
  
  df0$county <- matching_key$county
  df0$state <- matching_key$state
  df0$health_authority <- matching_key$health_authority
                    
  return(df0)
}