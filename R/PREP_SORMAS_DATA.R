PREP_SORMAS_DATA <- function(sormas_persons, matching_key){
  
  # This function is written based on the package dplyr.
  
  # This function depends on the sormas_persons data output of the 
  # 'PREP_SORMAS_DATA.R' function, and the healthauthority_county_key, which is
  # the matching_key.
  
  # This function joins the sormas_persons data with the 
  # healtauthority_county_key.
  
  #############################################################################
  
  #joining sormas persons dataset with matching key for counties and states
  output <- dplyr::left_join({{ sormas_persons }}, {{ matching_key }})
  return(output)
}