################################################################################
######################### PREPARE THE RAW SOURCE DATA ##########################
################################################################################

library(cliaretl)
library(dplyr)
library(tidyr)

#### prepare the indicators

minmax_tbl <- read.csv("data-raw/output/cpia_minmax.csv") |> as_tibble()

raw_dt <-
  lapply(X = list(aspire, d360_efi_data, debt_transparency,
                  epl, fraser, gfdb, heritage, pefa_assessments,
                  pmr, romelli, vdem_data, wdi_indicators),
         FUN = function(x){

           name_list <- colnames(x)[colnames(x) %in% cpia_indicators$indicator]

           y <- x |>
             dplyr::select(country_code, year, all_of(name_list))

           return(y)

         }) |>
  Reduce(f = dplyr::full_join)

# summary_tbl <-
# raw_dt |>
#   select(-country_code, -year) |>
#   summarise(across(everything(), list(min = \(x) min(x, na.rm = TRUE),
#                                       max = \(x) max(x, na.rm = TRUE)))) |>
#   pivot_longer(
#     everything(),
#     names_to = c("variable", ".value"),
#     names_pattern = "^(.*)_(min|max)$"
#   )
#
# write.csv(summary_tbl, "data-raw/output/cpia_minmax.csv")

check_tbl <-
  cpia_indicators |>
  merge(minmax_tbl, by.x = "indicator", by.y = "variable", all = TRUE) |>
  as_tibble()



saveRDS(raw_dt, "data-raw/output/cpiasource_raw.rds")
saveRDS(check_tbl, "data-raw/output/cpiaindicators_minmax.rds")
