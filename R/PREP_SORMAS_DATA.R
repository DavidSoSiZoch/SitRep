PREP_SORMAS_DATA <- function(sormas_persons, matching_key){
  #joining sormas persons dataset with matching key for counties and states
  output <- dplyr::left_join({{ sormas_persons }}, {{ matching_key }})
  return(output)
}