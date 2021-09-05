GET_STATE_TABLE <- function(master_table){
  
  # This funciton is written based on the package dplyr.
  
  # This function depends on the master_table created by the
  # 'GET_MASTER_TABLE.R' function.
  
  # This function builds the state_table from the master_table.
  
  #############################################################################
  
  ## building state table
  state_table <- master_table %>% 
    dplyr::group_by(state) %>% 
    dplyr::summarise("Total cases" = sum(case_category_confirmed),
                     "New cases" = sum(new_case_category_confirmed),
                     "Total hospitalizations" = sum(hospitalized_TRUE),
                     "New hospitalizations" = sum(new_hospitalized_TRUE),
                     "Total deaths" = sum(died_TRUE),
                     "New deaths" = sum(new_died_TRUE),
                     "7 Day Incidence" = mean(Seven_Day_incidence_state),
                     "Change in 7 day incidence since yesterday" = mean(Change_in_7_day_incidence_state) ) %>% 
    dplyr::rename(State = state)
  
  return(state_table)
  
}