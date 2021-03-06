#' A tidyUkBioBank function
#' Function output: dataframe containing counts data for icds of interest, self reported diseases (via codes or strings), and cause of death information (strings)
#' 
#' @param icd_list list of icds of interest
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords dx demographics
#' @export
#' @examples
#' dx_demographics()

dx_demographics <- function(icd_list, dataframe, ...){
  arguments <- list(...)
  
  icd_list_additional <- c(icd_list, list(icd_list))
  icd_labels <- c(icd_list, "Combined_ICD_Codes")
  
  icd_stats <- map(icd_list_additional, sex_age_stats, dataframe) %>% do.call(rbind, .) %>% mutate(dx_codes = icd_labels) 
  
  if(length(arguments$self_reported) > 0){
    sr_stats <- self_reported_counts(arguments$self_reported, dataframe) %>% mutate(dx_codes = paste("Self_Reported_", arguments$self_reported )) 
  } else { 
    sr_stats = data.frame() 
  }
  if (length(arguments$cause_of_death) > 0) {
    cod_stats <- cause_of_death_counts(arguments$cause_of_death, dataframe) %>% mutate(dx_codes = paste("Cause_of_Death_Included_", arguments$cause_of_death)) 
  } else {
    cod_stats = data.frame() 
  }
  
  final_stats_df <- bind_rows(icd_stats, sr_stats, cod_stats)
  final_stats_df
}