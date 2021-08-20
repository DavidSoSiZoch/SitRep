GET_SORMAS_DATA <- function(sormas_persons,
                            NEW = FALSE,
                            level = "county",
                            var1 = NULL,
                            var2 = NULL,
                            var3 = NULL){
  
  # This funciton is written based on the packages tidyverse, tidyr and dplyr.
  
  # This function allows to get a table on either new or total number of
  # occurrences for up to three variables of interest (typically cases,
  # hospitalizations and deaths). This can be done on county, state or country
  # level.
  
  #############################################################################
  
  lvl <- enexpr(level)
  vec <- c(enexpr(var1), enexpr(var2), enexpr(var3))

  if (!NEW){

      tables <- list()

      for(i in vec){

        tables[[i]] <- sormas_persons %>%
          dplyr::group_by( .data[[lvl]], .data[[i]]) %>%
          dplyr::count()  %>%
          tidyr::pivot_wider(names_from = .data[[i]],
                             names_prefix =  paste0(i, "_"),
                             values_from = n)  %>%
          dplyr::arrange( .data[[lvl]])
        
        # colnames(tables[[ i ]])[2:4] <- paste0(.data[[ i ]], colnames(tables[[ i ]][,c(2:4)]))
        }

  } else if (NEW){

    #setting the date
    #last reporting date of death is 20 of March 2021
    #last hospitalization date in testdata is 30 of May 2021
    #last reporting date in testdata is 15 of April 2021
    today = as.Date("2021-04-15")

    # in real application instead:
    # today = Sys.Date()

    tables <- list()

    #case_category <- reporting_date
    #hospitalized <- hospitalization_date
    #died <- reporting_date_death

    # building dataframe that assingns right date type to each variable of interest
    dt_vec <-vector(mode = "character",length = length(vec))
    df <- data.frame(variables = vec,
                     date_type = dt_vec)
    
    for (i in 1:nrow(df)){
      if(df$variables[i] == "case_category" ){
        df$date_type[i] <- "reporting_date"
      } else if (df$variables[i] == "hospitalized"){
        df$date_type[i] <- "hospitalization_date"
      } else if (df$variables[i] == "died"){
        df$date_type[i] <- "reporting_date_death"
      }
      
    }
      
    x <- 1
      for (i in df$variables){
      tables[[i]] <- sormas_persons %>%
        dplyr::filter( .data[[ df$date_type[x] ]] == {{ today }} )%>%
        dplyr::group_by( .data[[ lvl ]] ) %>%
        dplyr::count(.data[[ i ]] ) %>%
        tidyr::pivot_wider(names_from = .data[[ i ]],
                           names_prefix =  paste0("new_",i, "_"),
                           values_from = n) %>%
        dplyr::arrange( .data[[lvl]] )
      
      x <- x + 1
      }
    

  }
  return(tables)
}
