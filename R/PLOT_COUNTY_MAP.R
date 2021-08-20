PLOT_COUNTY_MAP <- function(geo_shapes_data){
  
  # This function is written based on the packages ggplot2, ggspatial
  # and viridis.
  
  # This function depends on the output of the 'PREP_GEO_DATA.R' function.
  # It provides a map that is based on the output of the 'PREP_GEO_DATA.R'
  # function.
  
  #############################################################################
  
  # build map
  ggplot(geo_shapes_data) +
    geom_sf(aes(fill = Seven_Day_incidence_county))+
    labs(x = "", y = "")+
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          panel.background = element_rect(fill = "cornsilk", color = "black"))+
    scale_fill_viridis(option= "viridis",
                       name="Seven day incidence") +
    ggspatial::annotation_north_arrow(location = "br", which_north = "true",
                           style = north_arrow_fancy_orienteering)
  
}
