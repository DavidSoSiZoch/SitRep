GET_TABLE_KEYS <- function(){
  
  # This function generates the table keys for dynamic values in the text.
  
  #############################################################################
  
  # OVERVIEW TABLE
  
  pattern <- c("#Otc",
                   "#Onc",
                   "#Oth",
                   "#Onh",
                   "#Otd",
                   "#Ond",
                   "#Oi7",
                   "#Oc7"
  )
  
  replacement <- c(expr(overview_table$`Total cases`),
                       expr(overview_table$`New cases`),
                       expr(overview_table$`Total hospitalizations`),
                       expr(overview_table$`New hospitalizations`),
                       expr(overview_table$`Total deaths`),
                       expr(overview_table$`New deaths`),
                       expr(overview_table$`7 day Incidence`),
                       expr(overview_table$`Change since yesterday`)
  )
  
  x <- list(pattern, replacement)
  
  return(x)
}