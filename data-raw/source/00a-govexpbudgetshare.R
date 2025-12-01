################################################################################
### ADD PRIMARY GOV EXPENDITURE AS A PROPORTION OF ORIGINAL APPROVED BUDGET ####
################################################################################

library(cliaretl)
library(dplyr)

dt <- extract_data_from_api(dataset_id = "WB_WDI",
                                      indicator_ids = "WB_WDI_GF_XPD_BUDG_ZS",
                                      source = "d360",
                                      verbose = TRUE)[[2]]

dt <-
  dt |>
  dplyr::select(OBS_VALUE, REF_AREA, TIME_PERIOD) |>
  dplyr::rename(q13b = "OBS_VALUE",
                country_code = "REF_AREA",
                year = "TIME_PERIOD") |>
  mutate(year = as.integer(year)) |>
  dplyr::filter(year >= 2013) |>
  mutate(q13b_raw = q13b) |>
  mutate(q13b = abs((as.numeric(q13b) - 100) / 100)) |>
  mutate(q13b = cap_outliers(q13b, k = 1.5)) %>%
  mutate(q13b = reverse_indicator(q13b,
                                  min = min(.$q13b, na.rm = T),
                                  max = max(.$q13b, na.rm = T))) |>
  mutate(q13b = rescale_indicator(q13b))

# dt <-
#   dt |>
#   mutate(q13b = sapply(q13b, convert_ctf_to_cpia))

q13b_tbl <- dt

rm(dt)

q13b_tbl <-
  add_cpiametadata(df = q13b_tbl,
                   indicator = "q13b",
                   variable = "q13b",
                   source = "World Development Indicators",
                   var_name = "Primary government expenditures as a percentage of original approved budget",
                   var_description = "Primary government expenditures as a proportion of original approved budget measures the extent to which aggregate budget expenditure outturn reflects the amount originally approved, as defined in government budget documentation and fiscal reports. The coverage is budgetary central government (BCG) and the time period covered is the last three completed fiscal years.",
                   var_description_short = "Primary government expenditures as a percentage of original approved budget",
                   theoretical_range = "c(0, Inf)")


usethis::use_data(q13b_tbl, overwrite = T)
