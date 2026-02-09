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


### include the meta data from the other datasets
attr_tbl <-
  lapply(X = list(aii_tbl, prights_tbl, wdi_tbl, q13b_tbl),
         FUN = combine_metadata) |>
  Reduce(f = "bind_rows")

meta_df <-
  meta_df |>
  rename(var_description = "description",
         var_description_short = "description_short") |>
  merge(read.csv("data-raw/output/cpia_minmax.csv") |>
          as_tibble() |>
          mutate(theoretical_range = paste0("c(", min, ",", max, ")")) |>
          dplyr::select(variable, theoretical_range),
        by.x = "indicator",
        by.y = "variable",
        all = TRUE) |>
  as_tibble() |>
  dplyr::select(colnames(attr_tbl))

meta_df <- bind_rows(meta_df, attr_tbl)

cpia_indicators <- meta_df |> arrange(variable)

rm(meta_df)

usethis::use_data(cpia_indicators, overwrite = TRUE)


