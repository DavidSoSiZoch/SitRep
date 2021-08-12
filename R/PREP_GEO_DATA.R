PREP_GEO_DATA <- function(geo_shapes, master_table){
  require(dplyr)
  
  # Rename column "region" to "health_authority" in geo_shapes
  geo_shapes_data <- dplyr::rename(geo_shapes, health_authority = region) %>% 
    dplyr::left_join(., master_table, by ="health_authority") %>% 
    base::replace(is.na(.), 0)
  
  return(geo_shapes_data)
}