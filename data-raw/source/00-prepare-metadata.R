################################################################################
######### PREPARE THE CPIA METADATA FOR IMPLEMENTING THE ANALYTICS #############
################################################################################

library(readxl)
library(cliaretl)
library(dplyr)
library(stringr)

### read in the raw data

meta_df <-
  read_excel("data-raw/input/cpiadocumentation.xlsx") |>
  mutate(across(everything(), ~str_replace_all(.x, "[\r\n\t]", " "))) |>
  mutate(indicator =
           indicator |>
           str_replace_all("[\r\n\t]", "") |>
           str_squish() |>
           str_split("\\s*, \\s*")) |>
  tidyr::unnest(indicator)

### include the descriptions from the db_variables for the variables
meta_df <-
  meta_df |>
  merge(db_variables_final |>
          dplyr::select(variable, var_name, starts_with("description")),
        by.x = "indicator",
        by.y = "variable",
        all.x = TRUE) |>
  as_tibble()

cpia_indicators <- meta_df

rm(meta_df)

cpia_indicators <- cpia_indicators[cpia_indicators$indicator %in% colnames(cliaretl::closeness_to_frontier_dynamic),]

usethis::use_data(cpia_indicators, overwrite = TRUE)


