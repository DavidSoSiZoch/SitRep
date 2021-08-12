PLOT_COUNTY_MAP <- function(geo_shapes_data){
  require(ggplot2)
  
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
    annotation_north_arrow(location = "br", which_north = "true",
                           style = north_arrow_fancy_orienteering)
  
}