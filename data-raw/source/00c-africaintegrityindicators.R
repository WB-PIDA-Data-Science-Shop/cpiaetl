################################################################################
################# GET THE AFRICA INTEGRITY INDICATORS CPIA DATA ################
################################################################################
library(dplyr)
library(rlang)
library(janitor)
library(cliaretl)

dataset_list <- rep("GI_AII", 4)

aiinum_list <- c(1:9, 10:16, 26:37)

ind_list <- paste0("GI_AII_", aiinum_list)

rawaii_tbl <- readxl::read_excel("data-raw/input/Africa-Integrity-Indicators.xlsx")

rawaii_tbl <-
  rawaii_tbl |>
  rename(tag = "...1",
         variable = "R10 FINAL Data") |>
  mutate(tag = as.integer(tag)) |>
  dplyr::filter(!is.na(tag)) |>
  dplyr::select(tag, variable)

vars <-
  rawaii_tbl |>
  filter(tag %in% c(1:9, 10:16, 26:37)) |>
  dplyr::select(variable) |>
  c() %>%
  .[[1]]


aii_tbl <-
  lapply(X = ind_list,
         FUN = function(x){

           y <- extract_data_from_api(dataset_id = "GI_AII",
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


         }) |>
  Reduce(f = "full_join") |>
  as_tibble()

## convert columns with numbers to character
aii_tbl <-
  aii_tbl %>%
  # 1. Create numeric raw versions
  mutate(across(
    starts_with("gi_aii_"),
    ~ as.numeric(.),
    .names = "{.col}_raw"
  )) %>%
  # 2. Rescale the numeric raw versions into the original columns
  mutate(across(
    ends_with("_raw"),
    ~ rescale_indicator(.),
    .names = "{sub('_raw$', '', .col)}"
  ))

var_list <- colnames(aii_tbl)[grepl("^gi_aii_.*_raw$", colnames(aii_tbl))]
var_list <- sub(pattern = "_raw", replacement = "", x = var_list)

aiimeta_tbl <-
  tibble(indicator = var_list,
         variable = c(rep("q12b", 4), rep("q16a", 5), rep("q16c", 7), "q16b", rep("q16c", 11)),
         source = rep("African Integrity Index", length(aiinum_list)),
         var_name = vars,
         var_description = vars,
         var_description_short = vars,
         theoretical_range = rep("c(0, 100)", length(aiinum_list)))

aii_tbl <-
  add_cpiametadata(df = aii_tbl,
                   indicator = aiimeta_tbl$indicator,
                   variable = aiimeta_tbl$variable,
                   source = aiimeta_tbl$source,
                   var_name = aiimeta_tbl$var_name,
                   var_description = aiimeta_tbl$var_description,
                   var_description_short = aiimeta_tbl$var_description_short,
                   theoretical_range = aiimeta_tbl$theoretical_range)

usethis::use_data(aii_tbl, overwrite = TRUE)















