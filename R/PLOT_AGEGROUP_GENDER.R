PLOT_AGEGROUP_GENDER <- function(agegroup_gender_data, voi = "tot_death_inc"){
  
  # This function is written based on the packages dplyr, ggplot2 and 
  # gridExtra.
  
  # This function is dependent on the output of the 
  # 'GET_AGEGROUP_GENDER_DATA.R' function because it provides a plot based on
  # the agegroup_gender_data output of the 'GET_AGEGROUP_GENDER_DATA.R'
  # function.
  
  # The three available variables of interest (voi) are:
  # 'tot_death_inc'
  # 'tot_hosp_inc'
  # 'tot_case_inc'
  
  #############################################################################
  
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
    labs(x="", y="", subtitle = "Diverse")+
    theme(axis.text.x = element_text(angle = 90, hjust =1))+
    geom_hline(yintercept = 0)  +
    expand_limits(y=0)
  #NB: death incidence for diverse gender is always 0
  
  gridExtra::grid.arrange(p1,p2,p3)
  
}