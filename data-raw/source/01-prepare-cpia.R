################################################################################
############# SCRIPT TO PREPARE AND LOAD CPIA DATA FOR ANALYTICS ###############
################################################################################

### load libraries
library(cliaretl)
library(readxl)
library(dplyr)


### select the data we need from cliaretl pipeline

ctfdynamic_tbl <-
  cliaretl::closeness_to_frontier_dynamic |>
  dplyr::select(country_code, country_name, income_group,
                region, country_group, year, cpia_indicators$indicator)

cpia_tbl <-
  lapply(X = split(cpia_indicators, cpia_indicators$variable),
         FUN = function(x){

           y <- tibble(ctfdynamic_tbl |>
                         dplyr::select(country_code, country_name,
                                       country_group, income_group,
                                       region, year),
                       q = ctfdynamic_tbl |>
                         dplyr::select(x$indicator) %>%
                         apply(X = .,
                               1,
                               convert_ctf_to_cpia))

           colnames(y)[colnames(y) == "q"] <- unique(x$variable)

           return(y)

         }) |>
  Reduce(f = "merge") |>
  as_tibble()

cpia_tbl <-
  cpia_tbl |>
  mutate(orig_year = year,
         year = year + 1)









