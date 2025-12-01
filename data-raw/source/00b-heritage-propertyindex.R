################################################################################
########## DOWNLOAD AND PROCESS HERITAGE'S INDEX OF FREEDOM DATA ###############
################################################################################

library(readr)
library(dplyr)
library(countrycode)
library(cliaretl)
library(janitor)

#### reading the data directly from the internet

urldata <- "https://www.heritage.org/index/assets/data/csv/ef-country-scores.csv"
heritage_df <- read_csv(urldata)

urlcountry <- "https://www.heritage.org/index/assets/data/csv/ef-country-names.csv"
country_df <- read_csv(urlcountry)

#### lets merge in country name and country code and remove
#### original "webname" in the raw data
heritage_df <- merge(heritage_df,
                     country_df[, c("name_web", "name_ISO3166_3")] |>
                       rename(country_code = "name_ISO3166_3"),
                     all.x = TRUE,
                     by = "name_web") |>
  mutate(country_code = case_when(
    country_code == "KOS" ~ "XKX",
    TRUE ~ country_code
  )) |>
  merge(wb_country_list[, c("country_code", "country_name")] |>
          unique() |>
          add_row(country_code = "XKX",
                  country_name = "Kosovo"),
        by = "country_code") |>
  clean_names() |>
  dplyr::select(-name_web) |>
  dplyr::select(country_code, year, property_rights) |>
  mutate(property_rights = as.numeric(property_rights)) |>
  mutate(property_rights_raw = property_rights) |>
  mutate(property_rights = rescale_indicator(property_rights)) |>
  filter(year >= 2013) |>
  as_tibble()



prights_tbl <- add_cpiametadata(df = heritage_df,
                             indicator = "property_rights",
                             variable = "q12a",
                             source = "Heritage Index of Economic Freedom",
                             var_name = "Property Rights",
                             var_description = "Assesses the extent to which a country’s laws protect private property rights and the degree to which its government enforces those laws. Evaluates judicial independence, corruption within the judiciary, and the ability to enforce contracts.",
                             var_description_short = "Measures the protection and enforcement of property rights through an independent and effective judiciary.",
                             theoretical_range = c(0, 100))

usethis::use_data(prights_tbl, overwrite = TRUE)
