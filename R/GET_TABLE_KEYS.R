GET_TABLE_KEYS <- function(overview_table, state_table){

  # This function generates the table keys of the overview and
  # state table for dynamic values in the text.
  
  # This function depends on the overview_table and state_table output of the 
  # 'GET_OVERVIEW_TABLE.R' and 'GET_STATE_TABLE.R' functions.
  
  #############################################################################
  
  pattern <- c(
               # overview_table keys
               
               "#Otc",
               "#Onc",
               "#Oth",
               "#Onh",
               "#Otd",
               "#Ond",
               "#Oi7",
               "#Oc7",
               
               # state_table keys
               
               "#BWtc",
               "#BWnc",
               "#BWth",
               "#BWnh",
               "#BWtd",
               "#BWnd",
               "#BWi7",
               "#BWc7",
               
               "#BYtc",
               "#BYnc",
               "#BYth",
               "#BYnh",
               "#BYtd",
               "#BYnd",
               "#BYi7",
               "#BYc7",
               
               "#BEtc",
               "#BEnc",
               "#BEth",
               "#BEnh",
               "#BEtd",
               "#BEnd",
               "#BEi7",
               "#BEc7",
               
               "#BBtc",
               "#BBnc",
               "#BBth",
               "#BBnh",
               "#BBtd",
               "#BBnd",
               "#BBi7",
               "#BBc7",
               
               "#HBtc",
               "#HBnc",
               "#HBth",
               "#HBnh",
               "#HBtd",
               "#HBnd",
               "#HBi7",
               "#HBc7",
               
               "#HHtc",
               "#HHnc",
               "#HHth",
               "#HHnh",
               "#HHtd",
               "#HHnd",
               "#HHi7",
               "#HHc7",
               
               "#HEtc",
               "#HEnc",
               "#HEth",
               "#HEnh",
               "#HEtd",
               "#HEnd",
               "#HEi7",
               "#HEc7",
               
               "#MVtc",
               "#MVnc",
               "#MVth",
               "#MVnh",
               "#MVtd",
               "#MVnd",
               "#MVi7",
               "#MVc7",
               
               "#NItc",
               "#NInc",
               "#NIth",
               "#NInh",
               "#NItd",
               "#NInd",
               "#NIi7",
               "#NIc7",
               
               "#NWtc",
               "#NWnc",
               "#NWth",
               "#NWnh",
               "#NWtd",
               "#NWnd",
               "#NWi7",
               "#NWc7",
               
               "#RPtc",
               "#RPnc",
               "#RPth",
               "#RPnh",
               "#RPtd",
               "#RPnd",
               "#RPi7",
               "#RPc7",
               
               "#SLtc",
               "#SLnc",
               "#SLth",
               "#SLnh",
               "#SLtd",
               "#SLnd",
               "#SLi7",
               "#SLc7",
               
               "#SNtc",
               "#SNnc",
               "#SNth",
               "#SNnh",
               "#SNtd",
               "#SNnd",
               "#SNi7",
               "#SNc7",
               
               "#STtc",
               "#STnc",
               "#STth",
               "#STnh",
               "#STtd",
               "#STnd",
               "#STi7",
               "#STc7",
               
               "#SHtc",
               "#SHnc",
               "#SHth",
               "#SHnh",
               "#SHtd",
               "#SHnd",
               "#SHi7",
               "#SHc7",
               
               "#THtc",
               "#THnc",
               "#THth",
               "#THnh",
               "#THtd",
               "#THnd",
               "#THi7",
               "#THc7"
  )
  
  
  
  vec_list <- list()
  
  for (i in 1:16){
    vec_name <- paste0("vec_",i)
    
    vec_name <- c(state_table[['Total cases']][i],
                  state_table[['New cases']][i],
                  state_table[['Total hospitalizations']][i],
                  state_table[['New hospitalizations']][i],
                  state_table[['Total deaths']][i],
                  state_table[['New deaths']][i],
                  state_table[['7 Day Incidence']][i],
                  state_table[['Change in 7 day incidence since yesterday']][i]  
    ) 
    vec_list[[i]] <- vec_name
    
  }
  
  state_values <- Reduce(c, vec_list)
  
  replacement <- c(
                   #overview_table keys
                   
                   overview_table$`Total cases`,
                   overview_table$`New cases`,
                   overview_table$`Total hospitalizations`,
                   overview_table$`New hospitalizations`,
                   overview_table$`Total deaths`,
                   overview_table$`New deaths`,
                   overview_table$`7 Day Incidence`,
                   overview_table$`Change in 7 day incidence since yesterday`,
                   
                   #state_table keys
                   state_values
  )
  
  
  
  x <- list(pattern, replacement)
  
  return(x)
}