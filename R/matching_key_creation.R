#loading packages
library(dplyr)
library(tidyr)
library(flextable)
library(ggplot2)
library(ggspatial)
library(gridExtra)
library(sormasdatagen)
library(cowplot)
library(stringr)
library(sp)
library(sf)
library(geojsonio)
library(broom)
library(fuzzyjoin)
library(rio)
library(Rcpp)
library(writexl)
library(readxl)
library(viridis)
library(readtext)
library(XML)

#load raw population data
load("population_data.rda")

#load raw sormas test data file and create persons dataframe
load("sormas_testdata.rda")
persons <- sormas_testdata$persons

#get list of health_authorities in sormas data
health_authorities <- persons %>% 
  dplyr::group_by(health_authority) %>% 
  dplyr::count() %>% 
  dplyr::select(health_authority)

# make SORMAS data and POPULATION data same length
while (nrow(health_authorities) < nrow(population_data_county)){
  df <- data.frame(health_authority = NA)
  health_authorities <- rbind(health_authorities, df)
}

#create matching table
matching_table <- dplyr::bind_cols(health_authorities, population_data_county$county)

# write xlsx matching table
writexl::write_xlsx(matching_table, "matching_table.xlsx")

#################################################################
# do manual matching in excel creating "matching_key.xlsx" file #
#################################################################

#import matching key
matching_key <- readxl::read_xlsx("matching_key.xlsx")

#matching_key now contains only 2 variables, county and health_authority, NO STATES

# get table with list of counties corresponding states from pop_data
a <- pop_data %>% 
  dplyr::group_by(state, county) %>% 
  dplyr::tally() %>% 
  dplyr::select(county, state)

# join matching key with table, wich contains STATES
matching_key <- dplyr::left_join(matching_key, a)

#matching_key now contains health_authority, county and state for each row

#save final matching key to xlsx file
writexl::write_xlsx(matching_key, "matching_key.xlsx")
