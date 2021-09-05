PREP_GEO_DATA <- function(geo_shapes, master_table){
  
  # This function is written based on the package dplyr.
  
  # This function depends on the geo_shapes output of the 
  # 'sormasdatagen::GetGeoData()' function, as well as the master_table output
  # of the 'GET_MASTER_TABLE.R' function.
  
  # This function renames the column 'region' in 'geo_shapes to
  # 'health_authority' and then joins geo_shapes with the master table.
  
  #############################################################################
  
  # Rename column "region" to "health_authority" in geo_shapes
  geo_shapes_data <- dplyr::rename(geo_shapes, health_authority = region) %>% 
    dplyr::left_join(., master_table, by ="health_authority") %>% 
    base::replace(is.na(.), 0)
  
  return(geo_shapes_data)
}