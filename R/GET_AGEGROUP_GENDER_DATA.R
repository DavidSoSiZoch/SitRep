GET_AGEGROUP_GENDER_DATA <- function(sormas_persons, population_data){
  
  # This function is written based on the tidyr and dplyr packages.
  
  # This funciton depends on the sormas_persons and population_data, for 
  # this test application.
  
  # This function creates a table with data on the total number of cases,
  # hospitalizations and deaths per population group, as well as the total
  # incidence of these three variabels for population groups by age and gender.
  # Age is divided into bins of 5 years and one bin of 80+ years.
  # The genders are male, female and diverse.
  
  #############################################################################
  
  #get dataframe on population in age groups & gender
  pop_df <- population_data %>% 
    dplyr::group_by(age_group, gender) %>% 
    dplyr::summarise(population = sum(population)) %>% 
    dplyr::arrange(gender)
  
  
  #build base dataframe
  #create df of agegroups 
  ag_df <- sormas_persons %>% 
    dplyr::group_by(age_group = cut(age, breaks = c(seq(-1,79,5),150))) %>% 
    dplyr::select(age_group) %>% 
    dplyr::distinct() %>% 
    dplyr::arrange(age_group)
  
  #build base dataframe w/ agegroup & gender data
  base_df <- data.frame(gender = rep(c("d", "f", "m"), each = nrow(ag_df)),
                      age_group = rep(ag_df$age_group, 3))
  
  
  #get data on variables of interest (cases, hosp, deaths) by age group and gender
  # + bind to base df
  
  # CASES
  ag_data_c <- sormas_persons %>% 
    dplyr::group_by(sex, age_group = cut(age, breaks = c(seq(-1,79,5),150))) %>% 
    dplyr::count(case_category) %>% 
    tidyr::pivot_wider(names_from = case_category,
                       names_prefix = "case_",
                       values_from = n) %>% 
    dplyr::arrange(sex) %>% 
    dplyr::left_join(base_df, ., by=c("age_group" = "age_group", "gender" = "sex"))

  
  # HOSP
  ag_data_h <- sormas_persons %>% 
    dplyr::group_by(sex, age_group = cut(age, breaks = c(seq(-1,79,5),150))) %>% 
    dplyr::count(hospitalized) %>% 
    tidyr::pivot_wider(names_from = hospitalized,
                       names_prefix = "hosp_",
                       values_from = n) %>% 
    dplyr::arrange(sex) %>% 
    dplyr::left_join(base_df, ., by=c("age_group" = "age_group", "gender" = "sex"))
  
    
  # DIED
  ag_data_d <- sormas_persons %>% 
    dplyr::group_by(sex, age_group = cut(age, breaks = c(seq(-1,79,5),150))) %>% 
    dplyr::count(died) %>% 
    tidyr::pivot_wider(names_from = died,
                       names_prefix = "died_",
                       values_from = n) %>% 
    dplyr::arrange(sex) %>% 
    dplyr::left_join(base_df, ., by=c("age_group" = "age_group", "gender" = "sex"))
  
  
  
  ## JOINING 
  
  #join data on variables of interest
  voi_df <- dplyr::left_join(base_df, ag_data_c, by=c("age_group", "gender")) %>% 
    dplyr::left_join(., ag_data_h, by=c("age_group", "gender")) %>% 
    dplyr::left_join(., ag_data_d, by=c("age_group", "gender"))
  
  #join voi_df with pop_df
  # use cbind (possible, because both have same ordering)
  
  final_df <- cbind(pop_df, voi_df) %>% 
    dplyr::select(-c(gender...4, age_group...5)) %>% 
    dplyr::rename(gender = gender...2, 
                  age_group=age_group...1)
  
  ## INCIDENCES
  
  final_df <- final_df %>% 
    dplyr::mutate(tot_case_inc = case_confirmed*100000 / population , .keep = "all") %>%
    dplyr::mutate(tot_hosp_inc = hosp_TRUE*100000 / population , .keep = "all") %>% 
    dplyr::mutate(tot_death_inc = died_TRUE*100000 / population , .keep = "all")
  
  
  
  return(final_df)
}