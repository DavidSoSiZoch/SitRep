GET_MASTER_TABLE <- function(population_data,
                             persons_sormasdata,
                             key = matching_key){
  # depends on the following:
  # require(tidyr)
  # require(dplyr)
  # source("R/GET_POPULATION_DATA.R")
  # source("R/GET_SORMAS_DATA.R")
  # source("R/DF0_COUNTY_DATA.R")
  
  ## POPULATION DATA
  
  # get population data on county and state
  pd_cs <- GET_POPULATION_DATA(population_data,
                               county,
                               state)
  
  #join population data by county with matching key
  pd_cs <- dplyr::left_join(key,
                            pd_cs,
                            by = "county") %>% 
    dplyr::select(state.x, county, health_authority, population) %>% 
    dplyr::rename(state = state.x)
  
  ## SORMAS DATA
  
  #get totals on county level
  t_c <- GET_SORMAS_DATA(persons_sormasdata,
                         NEW = FALSE,
                         level = "county",
                         "case_category",
                         "hospitalized",
                         "died")
  
  #get news on county level
  n_c <- GET_SORMAS_DATA(persons_sormasdata,
                         NEW = TRUE,
                         level = "county",
                         "case_category",
                         "hospitalized",
                         "died")
  
  #joining totals
  c_t_c <- dplyr::left_join(t_c$case_category,
                            t_c$hospitalized,
                            by = "county") %>% 
    dplyr::left_join(.,
                     t_c$died,
                     by = "county")
  
  ## JOINING
  # joining news
  c_n_c <- dplyr::full_join(n_c$case_category,
                            n_c$hospitalized,
                            by = "county") %>% 
    dplyr::full_join(.,
                     n_c$died,
                     by = "county")
  
  
  # joining c_t_c and c_n_c and pd_cs
  c_c_d <- dplyr::left_join(c_t_c,
                            pd_cs,
                            by = "county") %>% 
    dplyr::left_join(.,
                     c_n_c,
                     by = "county") %>% 
    base::replace(is.na(.), 0)
  
  ## updating
  # getting df of 0s 
  df <- DF0_COUNTY_DATA(key)
  
  #updating df with latest complete county data ( c_c_d )
  c_f <- dplyr::rows_update(df,
                            c_c_d,
                            by = "county") %>% 
    dplyr::select(-n)
  
  # join with geoshapes_data to create m_table
  m_table <- c_f
    
    
  
  ###########################################################################
  
  ## CALCULATING INCIDENCES
  
  # setting date and daterange
  
  #last date for reportin_date in testdata is 15 of April 2021
  today = as.Date("2021-04-15")
  
  # in real application instead:
  # today = Sys.Date()
  
  #setting date range for last week
  daterange_week <- seq(today-6, by = "day", length.out = 7)
  
  #setting date range for week before yesterday
  y_daterange_week <- seq(today-7, by = "day", length.out = 7)
  
  ############################################################
  
  # 7 DAY INCIDENCE & CHANGE ON COUNTY LVL: NUTS-3
  # 7 DAY INC
  i7_c <- INCIDENCE7(persons_sormasdata = persons_sormasdata,
                           population_data = population_data,
                           daterange = daterange_week,
                           level = "county")
  
  # YESTERDAY'S 7 DAY INC
  yi7_c <- INCIDENCE7(persons_sormasdata = persons_sormasdata,
                     population_data = population_data,
                     daterange = y_daterange_week,
                     level = "county") %>% 
    dplyr::rename(y_Incidence = Incidence)
  
  # Join i7_c and ci7_c and calculate change since yesterday
  df_i7_county <- dplyr::left_join(i7_c, yi7_c, by = "county") %>% 
    dplyr::mutate(Change_in_7_day_incidence_county = Incidence - y_Incidence) %>% 
    dplyr::select(-y_Incidence) %>% 
    dplyr::rename(Seven_Day_incidence_county = Incidence)

    
 
   # 7 DAY INCIDENCE & CHANGE ON STATE LVL: NUTS-2
  # 7 DAY INC
  i7_s <- INCIDENCE7(persons_sormasdata = persons_sormasdata,
                     population_data = population_data,
                     daterange = daterange_week,
                     level = "state")
  
  # YESTERDAY'S 7 DAY INC
  yi7_s <- INCIDENCE7(persons_sormasdata = persons_sormasdata,
                      population_data = population_data,
                      daterange = y_daterange_week,
                      level = "state") %>% 
    dplyr::rename(y_Incidence = Incidence)
  
  # Join i7_s and ci7_s and calculate change since yesterday
  df_i7_state <- dplyr::left_join(i7_s, yi7_s, by = "state") %>% 
    dplyr::mutate(Change_in_7_day_incidence_state = Incidence - y_Incidence) %>% 
    dplyr::select(-y_Incidence) %>% 
    dplyr::rename(Seven_Day_incidence_state = Incidence)

  
    
  # 7 DAY INCIDENCE & CHANGE ON COUNTRY LVL: NUTS-1
  # 7 DAY INC
  i7_country <- INCIDENCE7(persons_sormasdata = persons_sormasdata,
                     population_data = population_data,
                     daterange = daterange_week,
                     level = "country")
  
  # YESTERDAY'S 7 DAY INC
  yi7_country <- INCIDENCE7(persons_sormasdata = persons_sormasdata,
                      population_data = population_data,
                      daterange = y_daterange_week,
                      level = "country") %>% 
    dplyr::rename(y_Incidence = Incidence)
  
  # Join i7_country and ci7_country and calculate change since yesterday
  df_i7_country <- dplyr::bind_cols(i7_country, yi7_country) %>% 
    dplyr::mutate(Change_in_7_day_incidence_country = Incidence - y_Incidence) %>% 
    dplyr::select(-y_Incidence) %>% 
    dplyr::rename(Seven_Day_incidence_country = Incidence) %>% 
    dplyr::mutate(country = "Germany")
 
  
  #############################################################################
  
  ## JOINING INCIDENCES WITH m_table
  
  master_table <- dplyr::left_join(m_table, df_i7_county, by = "county") %>% 
    dplyr::left_join(., df_i7_state, by = "state") %>% 
    dplyr::mutate(country = "Germany") %>% 
    dplyr::left_join(., df_i7_country, by = "country")
  
   
  return(master_table)
}