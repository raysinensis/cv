# =================================================================================
# This code uses google sheets to store the position info
if(using_googlesheets){
  
  library(googlesheets4)
  
  if(sheet_is_publicly_readable){
    # This tells google sheets to not try and authenticate. Note that this will only
    # work if your sheet has sharing set to "anyone with link can view"
    gs4_deauth()
  } else {
    # My info is in a public sheet so there's no need to do authentication but if you want
    # to use a private sheet, then this is the way you need to do it.
    # designate project-specific cache so we can render Rmd without problems
    options(gargle_oauth_cache = ".secrets")
    
    # Need to run this once before knitting to cache an authentication token
    # googlesheets4::gs4_auth()
  }
  
  
  position_data <- read_sheet(positions_sheet_loc, sheet = "positions")
  skills        <- read_sheet(positions_sheet_loc, sheet = "language_skills")
  text_blocks   <- read_sheet(positions_sheet_loc, sheet = "text_blocks")
  contact_info  <- read_sheet(positions_sheet_loc, sheet = "contact_info", skip = 1)
  
} else {
  
  # Want to go oldschool with just a csv?
  position_data <- read_csv("csvs/positions.csv")
  skills        <- read_csv("csvs/language_skills.csv")
  text_blocks   <- read_csv("csvs/text_blocks.csv")
  contact_info  <- read_csv("csvs/contact_info.csv", skip = 1)
  
}

if (do_resume) {
  position_data <- position_data %>% filter(in_resume) %>% 
    mutate(description_1 = ifelse(section == "academic_articles1", NA, description_1)) %>% 
    mutate(loc = ifelse(section == "academic_articles1", str_c(title, loc, sep = ". "), loc)) %>% 
    mutate(title = ifelse(section == "academic_articles1", NA, title))
}