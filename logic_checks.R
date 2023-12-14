##### Logic check functions

library(tidyverse)
library(openxlsx)

##### crosschecking categorical variables

get_logic_errors_categorical <- function(data, logic_frame, id_col, enum_col="complementary_col", date_col="complementary_col", enum_com_col="complementary_col", index_col="complementary_col"){
  
  data <- data |> 
    mutate(complementary_col = NA_character_)
  
  log_checks_issues <- data.frame(matrix(nrow = 0, ncol = 9))
  
  colnames(log_checks_issues) <- c(id_col, enum_col, date_col, enum_com_col, index_col, "issue", "comment", "variable_to_change", "correct_value")
  #names(log_checks_issues) <- names(log_checks_issues)[!duplicated(names(log_checks_issues))]
  
  for (i in 1:nrow(logic_frame)){
    var <- logic_frame$target_var[i]
    crvar <- logic_frame$cross_var[i]
    
    val <- logic_frame$target_val[i]
    crval <- logic_frame$cross_val[i]
    
    logic_temp <- data |> 
      filter(!!sym(var) == paste0(val) & !!sym(crvar) == paste0(crval)) |> 
      select(!!sym(id_col), !!sym(enum_col), !!sym(date_col), !!sym(enum_com_col), !!sym(index_col)) |> 
      mutate(issue = paste0("Inconsistent answers: ", val, " in ", var, " and ", crval, " in ", crvar), 
             comment = NA_character_,
             variable_to_change = NA_character_,
             correct_value = NA_character_)
    
    log_checks_issues <- rbind(log_checks_issues, logic_temp)
  }
  
  log_checks_issues <- log_checks_issues |> 
    mutate(across(everything(), ~as.character(.))) |> 
    select(-contains("complementary_col"))
  
  return(log_checks_issues)
}

##### crosschecking categorical vs numerical variables

get_logic_errors_categorical_numeric  <- function(data, logic_frame, id_col, enum_col="complementary_col", date_col="complementary_col", enum_com_col="complementary_col", index_col="complementary_col"){
  
  data <- data |> mutate(complementary_col = NA_character_)
  
  log_checks_issues_num <- data.frame(matrix(nrow = 0, ncol = 8))
  
  colnames(log_checks_issues_num) <- c(id_col, enum_col, date_col, enum_com_col, "issue", "comment", "variable_to_change", "correct_value") 
  names(log_checks_issues_num) <- names(log_checks_issues_num)[!duplicated(names(log_checks_issues_num))]
  
  data <- data |> 
    mutate(across(is.logical, as.numeric))
  
  for (i in 1:nrow(logic_checks)){
    var <- logic_checks$target_var[i]
    crvar <- logic_checks$cross_var[i]
    
    val <- logic_checks$target_val[i]
    crval <- logic_checks$cross_val[i]
    
    sign <- logic_checks$sign[i]
    
    `%.%` <- get(sign)
    
    logic_temp <- data |> 
      filter(!!sym(var) == paste0(val) & !!sym(crvar) %.% paste0(crval)) |> 
      select(!!sym(id_col), !!sym(enum_col), !!sym(date_col), !!sym(enum_com_col), !!sym(index_col)) |> 
      mutate(issue = paste0("Inconsistent answers: ", val, " in ", var, " and ", crval, " is ", sign, " ", crvar), comment = NA_character_)
    
    log_checks_issues_num <- rbind(log_checks_issues_num, logic_temp)
    log_checks_issues_num <- log_checks_issues_num |> 
      select(-contains("complementary_col"))
  }
  return(log_checks_issues_num)
}

##### Applying changes from the helper file

get_logic_applied <- function(data, logic_frame_issues, idvar){
  nam_ds <- names(data)
  nam_logic <- logic_frame_issues$variable_to_change
  id_logic <- logic_frame_issues[idvar]
  nam_ds <- setdiff(nam_ds, idvar)
  
  
  for(vi in nam_logic){
    id_logic_i <- logic_frame_issues[logic_frame_issues$variable_to_change == vi, idvar]
    
    for(id in id_logic_i){
      
      data[which(data[idvar] == id), vi] <- logic_frame_issues$correct_value[which(logic_frame_issues[idvar] == id & logic_frame_issues$variable_to_change == vi)]
      
    }
    
  }
  return(data)
}
