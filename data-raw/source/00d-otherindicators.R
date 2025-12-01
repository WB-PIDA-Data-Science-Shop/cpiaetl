################################################################################
#################### PULLING THE OTHER INDICATORS TOGETHER #####################
################################################################################

library(dplyr)
library(cliaretl)

### setting up the remaining variables to be pulled

dataset_list <- rep("WB_WDI", 3)
var_list <- c("WB_WDI_RQ_PER_RNK", "WB_WDI_CC_EST", "WB_WDI_VA_EST")


wdi_tbl <-
  lapply(X = var_list,
         FUN = function(x){

           y <- extract_data_from_api(dataset_id = "WB_WDI",
                                      indicator_ids = x,
                                      source = "d360",
                                      verbose = TRUE)[[2]] |>
             dplyr::select(OBS_VALUE, REF_AREA, TIME_PERIOD) |>
             dplyr::rename(!!x := "OBS_VALUE",
                           country_code = "REF_AREA",
                           year = "TIME_PERIOD") |>
             mutate(year = as.integer(year)) |>
             dplyr::filter(year >= 2013) |>
             janitor::clean_names()

           return(y)


         }) |>
  Reduce(f = "full_join") |>
  as_tibble()

wdi_tbl <-
  wdi_tbl %>%
  mutate(across(starts_with("wb_wdi_"), ~ as.numeric(.), .names = "{.col}_raw")) %>%
  mutate(across(
    ends_with("_raw"),
    ~ rescale_indicator(.),
    .names = "{sub('_raw$', '', .col)}"
  ))

var_list <- colnames(wdi_tbl)[grepl("^wb_wdi_.*_raw$", colnames(wdi_tbl))]
var_list <- sub("_raw", "", var_list)

wdi_tbl <-
  add_cpiametadata(df = wdi_tbl,
                   indicator = var_list,
                   variable = c("q12b", "q16c", "q16c"),
                   source = rep("World Governance Indicators", length(var_list)),
                   var_name = c("Index of Regulatory Quality",
                                "Control of Corruption Index",
                                "Voice and Accountability Index"),
                   var_description = c("Regulatory Quality captures perceptions of the ability of the government to formulate and implement sound policies and regulations that permit and promote private sector development",
                                       "Control of Corruption captures perceptions of the extent to which public power is exercised for private gain, including both petty and grand forms of corruption, as well as capture of the state by elites and private interests",
                                       "Voice and Accountability captures perceptions of the extent to which a country's citizens are able to participate in selecting their government, as well as freedom of expression, freedom of association, and a free media"),
                   var_description_short = c("Ability of the government to formulate and implement sound policies and regulations",
                                             "Ability of the government to limit corruption",
                                             "Captures perceptions of citizen participation in selecting the government"),
                   theoretical_range = c("c(0, 100)", "c(-2,5, 2.5)" , "c(-2.5, 2.5)"))



usethis::use_data(wdi_tbl, overwrite = TRUE)



















