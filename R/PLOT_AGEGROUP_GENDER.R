PLOT_AGEGROUP_GENDER <- function(agegroup_gender_data, voi = "tot_death_inc"){
  require(dplyr)
  require(ggplot2)
  # build 3 bar plots, one for each gender
  
  p1 <- agegroup_gender_data %>% 
    dplyr::filter(gender == "f") %>% 
    ggplot(aes(x=age_group, y = .data[[voi]] ))+
    geom_bar(stat = "identity")+
    labs(x="", y="", subtitle = "Female")+
    theme(axis.text.x = element_text(angle = 90, hjust =1))+
    geom_hline(yintercept = 0) +
    expand_limits(y=0)
  
  p2 <- agegroup_gender_data %>% 
    dplyr::filter(gender == "m") %>% 
    ggplot(aes(x=age_group, y = .data[[voi]]))+
    geom_bar(stat = "identity")+
    labs(x="", y="", subtitle = "Male")+
    theme(axis.text.x = element_text(angle = 90, hjust =1))+
    geom_hline(yintercept = 0) # +
    expand_limits(y=0)
  
  p3 <- agegroup_gender_data %>% 
    dplyr::filter(gender == "d") %>% 
    ggplot(aes(x=age_group, y = .data[[voi]]))+
    geom_bar(stat = "identity")+
    labs(x="", y="", subtitle = "Divers")+
    theme(axis.text.x = element_text(angle = 90, hjust =1))+
    geom_hline(yintercept = 0)  +
    expand_limits(y=0)
  #NB: death incidence for diverse gender is always 0
  
  grid.arrange(p1,p2,p3)
  
}