#' A tidyUkBioBank function
#' Function output: table with the code/ string provided and information about the self_reported code selected
#' Outputs a print statment with information about the self reported code selected
#' 
#' @param diagnosis a number code or string describing the self reported disease of interest
#' @param ukb_data the originial phenotype dataframe containing all individuals in the ukbiobank (~500,000 cols x 18,000 rows as of 09/07/2021)
#' @keywords get self reported table
#' @export
#' @examples
#' get_self_reported_table()

get_self_reported_table <- function(diagnosis, ukb_data){
  coding <- parse_get_SR_table_input(diagnosis) 
  self_report <- select(ukb_data, eid, contains("noncancer_illness_code_selfreported"))
  diagnosis_long <- pivot_longer(self_report, -eid, names_to = "Diagnosis_Column", values_to = "diagnosis")
  eid_positive_list <- filter(diagnosis_long, diagnosis == coding) %>% pull("eid") %>% unique() 
  with_SR <- filter(ukb_data, is_in(eid, eid_positive_list)) %>% select(eid)
  with_SR$self_reported_col <- 1
  without_SR <- filter(ukb_data, !is_in(eid, eid_positive_list)) %>% select(eid)
  without_SR$self_reported_col <- 0
  self_reporting_table <- bind_rows(without_SR, with_SR)
  colnames(self_reporting_table) <- c("eid", coding)
  self_reporting_table
}