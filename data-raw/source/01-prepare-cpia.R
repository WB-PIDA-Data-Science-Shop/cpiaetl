################################################################################
############# SCRIPT TO PREPARE AND LOAD CPIA DATA FOR ANALYTICS ###############
################################################################################

### load libraries
library(cliaretl)
library(readxl)
library(dplyr)
library(purrr)


### lets prepare the cpia data and raw that will eventually be exported

cpia_tbl <-
  lapply(X = list(cliaretl::closeness_to_frontier_dynamic,
                  aii_tbl,
                  prights_tbl,
                  q13b_tbl,
                  wdi_tbl,
                  vdem_data[, c("country_code", "year", "vdem_core_v2x_rule")]),
         FUN = function(x){

           cols_list <- intersect(cpia_indicators$indicator, colnames(x))

           if ("country_group" %in% colnames(x)) {

             y <- x |> dplyr::select(country_code,
                                     country_group, year, all_of(cols_list))

           } else {

             y <- x |> dplyr::select(country_code,
                                     year, all_of(cols_list))

           }

           return(y)

         }) |>
  Reduce(f = "full_join") |>
  dplyr::filter(country_group == 0)

# cpiameta_tbl <-
#   cpia_indicators |>
#   dplyr::filter(source %in% c("CLIAR", NA))
#
# ctfdynamic_tbl <-
#   cliaretl::closeness_to_frontier_dynamic |>
#   dplyr::select(country_code, country_name, income_group,
#                 region, country_group, year, cpiameta_tbl$indicator) |>
#   dplyr::filter(country_group == 0)
cpiameta_tbl <-
  cpia_indicators |>
  dplyr::filter(!indicator == "NA")

cpia_tbl <-
  cpia_tbl |>
  mutate(bs_bti_q15_1 = rescale_indicator(bs_bti_q15_1))


## cpia using africa integrity scores
aiicpia_tbl <-
  lapply(X = split(cpiameta_tbl, cpiameta_tbl$variable),
         FUN = function(x) {

           relcols <- unique(intersect(x$indicator, colnames(cpia_tbl)))

           if (length(relcols) >= 1) {

             df <- cpia_tbl %>%
               dplyr::select(country_code, year, all_of(relcols))

             if (length(relcols) > 1) {
               df <- df %>%
                 dplyr::mutate(
                   q = apply(
                     dplyr::select(., all_of(relcols)),
                     MARGIN = 1,
                     FUN = convert_ctf_to_cpia
                   )
                 )
             } else {
               single_col <- relcols[1]
               df <- df %>%
                 dplyr::mutate(
                   q = sapply(.data[[single_col]], convert_ctf_to_cpia)
                 )
             }

             # ✅ Keep only the essential columns and deduplicate
             df <- df %>%
               dplyr::select(country_code, year, q) %>%
               dplyr::group_by(country_code, year) %>%
               dplyr::summarise(q = mean(q, na.rm = TRUE), .groups = "drop")

             # Rename q → variable name
             colnames(df)[colnames(df) == "q"] <- unique(x$variable)

             return(df)
           } else {
             return(NULL)
           }
         }) |>
  purrr::compact() |>
  purrr::reduce(.f = dplyr::full_join, by = c("country_code", "year"))

## the standard cpia without using the aii variables
basiccpia_tbl <-
  lapply(X = split(cpiameta_tbl |>
                     dplyr::filter(!source == "African Integrity Index"),
                   cpiameta_tbl$variable[!cpiameta_tbl$source == "African Integrity Index"]),
         FUN = function(x) {

           relcols <- unique(intersect(x$indicator, colnames(cpia_tbl)))

           if (length(relcols) >= 1) {

             df <- cpia_tbl %>%
               dplyr::select(country_code, year, all_of(relcols))

             if (length(relcols) > 1) {
               df <- df %>%
                 dplyr::mutate(
                   q = apply(
                     dplyr::select(., all_of(relcols)),
                     MARGIN = 1,
                     FUN = convert_ctf_to_cpia
                   )
                 )
             } else {
               single_col <- relcols[1]
               df <- df %>%
                 dplyr::mutate(
                   q = sapply(.data[[single_col]], convert_ctf_to_cpia)
                 )
             }

             # ✅ Keep only the essential columns and deduplicate
             df <- df %>%
               dplyr::select(country_code, year, q) %>%
               dplyr::group_by(country_code, year) %>%
               dplyr::summarise(q = mean(q, na.rm = TRUE), .groups = "drop")

             # Rename q → variable name
             colnames(df)[colnames(df) == "q"] <- unique(x$variable)

             return(df)
           } else {
             return(NULL)
           }
         }) |>
  purrr::compact() |>
  purrr::reduce(.f = dplyr::full_join, by = c("country_code", "year"))



### prepare the raw data
rawcpia_tbl <-
  lapply(X = list(aii_tbl,
                  prights_tbl,
                  q13b_tbl,
                  wdi_tbl),
         FUN = function(x){

           x <- x |>
             dplyr::select(country_code, year, ends_with("_raw"))

           return(x)

         }) |>
  purrr::compact() |>
  purrr::reduce(.f = dplyr::full_join, by = c("country_code", "year"))

### include the raw variables from CLIAR
varlist <- unique(cpiameta_tbl$indicator)
drop_list <- colnames(rawcpia_tbl)[!colnames(rawcpia_tbl) %in% c("country_code", "year")]
drop_list <- sub("_raw", "", x = drop_list)
varlist <- setdiff(varlist, drop_list)

# add_tbl <-
#   lapply(X = list(cliaretl::aspire,
#                   cliaretl::d360_efi_data,
#                   cliaretl::debt_transparency,
#                   cliaretl::epl,
#                   cliaretl::fraser,
#                   cliaretl::gfdb,
#                   cliaretl::heritage,
#                   cliaretl::pefa_assessments,
#                   cliaretl::pmr,
#                   cliaretl::romelli,
#                   cliaretl::vdem_data,
#                   cliaretl::wdi_indicators,
#                   cliaretl::wbl_data),
#          FUN = function(x){
#
#            y <- x |> dplyr::select(country_code,
#                                    year,
#                                    intersect(varlist, colnames(x)))
#
#            return(y)
#
#          }) |>
#   purrr::compact() |>
#   purrr::reduce(.f = dplyr::full_join, by = c("country_code", "year")) |>
#   # progressive join without duplicating columns
#   purrr::reduce(function(df1, df2) {
#     common_vars <- intersect(colnames(df1), colnames(df2))
#     # keep only the join keys in common
#     common_vars <- setdiff(common_vars, c("country_code", "year"))
#     df2 <- df2 |> select(-all_of(common_vars))
#     full_join(df1, df2, by = c("country_code", "year"))
#   }) |>
#   distinct() |>
#   filter(year >= 2013)

datasets <- list(
  cliaretl::aspire,
  cliaretl::d360_efi_data,
  cliaretl::debt_transparency,
  cliaretl::epl,
  cliaretl::fraser,
  cliaretl::gfdb,
  cliaretl::heritage,
  cliaretl::pefa_assessments,
  cliaretl::pmr,
  cliaretl::romelli,
  cliaretl::vdem_data,
  cliaretl::wdi_indicators,
  cliaretl::wbl_data
)

add_tbl <- datasets |>
  # 1️⃣ Only keep objects that are data.frames or tibbles
  purrr::keep(~ inherits(.x, c("data.frame", "tbl_df"))) |>

  # 2️⃣ Select only relevant columns
  lapply(function(x) {
    x |>
      dplyr::select(country_code,
                    year,
                    intersect(varlist, colnames(x)))
  }) |>

  # 3️⃣ Remove NULL or empty frames
  purrr::compact() |>

  # 4️⃣ Progressive full join without duplicating columns
  purrr::reduce(function(df1, df2) {
    common_vars <- intersect(colnames(df1), colnames(df2))
    common_vars <- setdiff(common_vars, c("country_code", "year"))
    df2 <- df2 |> select(-all_of(common_vars))
    full_join(df1, df2, by = c("country_code", "year"))
  }) |>

  # 5️⃣ Final clean-up
  distinct() |>
  filter(year >= 2013)

rawcpia_tbl <- full_join(rawcpia_tbl |> unique(),
                         add_tbl,
                         by = c("country_code", "year"))


rawcpia_tbl <-
  rawcpia_tbl |>
  dplyr::rename_with(~ sub("_raw$", "", .x))


### order the raw variables to match the cpia metadata
rawcpia_tbl <-
  rawcpia_tbl |>
  dplyr::select(c("country_code", "year", cpiameta_tbl$indicator))

# Create a named lookup vector: indicator -> variable
lookup <- cpiameta_tbl$variable
names(lookup) <- cpiameta_tbl$indicator

# For every column in rawcpia_tbl (except the first two), look up its variable name
variable_row <- map_chr(names(rawcpia_tbl), ~ lookup[.x] %||% NA_character_)

# Add "country_code" and "year" explicitly at the start
variable_row[1:2] <- c("country_code", "year")

# Convert to tibble and ensure same column names as rawcpia_tbl
header_tbl <- as_tibble(t(variable_row)) |>
  setNames(names(rawcpia_tbl))

# Bind to top of the dataset (convert all to character to avoid type mismatch)
rawcpia_tbl_with_varrow <- bind_rows(
  header_tbl,
  rawcpia_tbl |> mutate(across(everything(), as.character))
)

rawcpia_tbl_with_varrow <-
 rawcpia_tbl_with_varrow |>
 dplyr::select(c("country_code", "year", cpiameta_tbl$indicator[!(cpiameta_tbl$indicator == 0 &
                                                                    cpiameta_tbl$indicator == "property_rights")]))

### add additional year
aiicpia_tbl <-
  aiicpia_tbl |>
  mutate(cpia_year = year + 1)

basiccpia_tbl <-
  basiccpia_tbl |>
  mutate(cpia_year = year + 1)

raw <- rawcpia_tbl_with_varrow

# produce safe numeric conversion (NAs if non-numeric)
numeric_years <- suppressWarnings(as.numeric(raw$year))

# build cpia_year vector: first row is "cpia_year", others are numeric+1 (or NA)
cpia_year_vec <- ifelse(
  seq_along(raw$year) == 1,
  "cpia_year",
  ifelse(is.na(numeric_years), NA_character_, as.character(numeric_years + 1))
)

# add cpia_year and drop the old year (optional) — keep column order sensible
raw <- raw %>%
  mutate(cpia_year = cpia_year_vec) %>%
  select(country_code, cpia_year, everything(), -year)

# assign back
rawcpia_tbl_with_varrow <- raw


#### lets include country information prepare the data for lazy loading 
standard_cpia <- 
  basiccpia_tbl |> 
  merge(wbcountries, by = "country_code", all = TRUE) |>
  as_tibble()

africaii_cpia <- 
  aiicpia_tbl |>
  merge(wbcountries, by = "country_code", all = TRUE) |>
  as_tibble()

rawdata_cpia <- 
  rawcpia_tbl_with_varrow |>
  merge(wbcountries, by = "country_code", all = TRUE) |>
  as_tibble() |> 
  mutate(cpia_year = as.integer(cpia_year))

metadata_cpia <- cpiameta_tbl 

#### lets actually create regional and income group summaries
group_standard_cpia <- 
  bind_rows(
  standard_cpia |>
    group_by(income_group, cpia_year) |>
    summarise(across(q12a:q16d, ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
    rename(group = income_group) |>
    mutate(group_type = "Income Group"),
  
  standard_cpia |>
    group_by(region, cpia_year) |>
    summarise(across(q12a:q16d, ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
    rename(group = region) |>
    mutate(group_type = "Region")
)

group_africaii_cpia <- 
  bind_rows(
  africaii_cpia |>
    group_by(income_group, cpia_year) |>
    summarise(across(q12a:q16d, ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
    rename(group = income_group) |>
    mutate(group_type = "Income Group"),
  
  africaii_cpia |>
    group_by(region, cpia_year) |>
    summarise(across(q12a:q16d, ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
    rename(group = region) |>
    mutate(group_type = "Region")
)

group_rawdata_cpia <- 
  bind_rows(
  rawcpia_tbl |>
    merge(wbcountries, by = "country_code", all = TRUE) |>
    as_tibble() |>
    mutate(year = as.integer(year)) |>
    group_by(income_group, year) |>
    summarise(across(where(is.numeric), ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
    rename(group = income_group) |>
    mutate(group_type = "Income Group"),
  
  rawcpia_tbl |>
    merge(wbcountries, by = "country_code", all = TRUE) |>
    as_tibble() |>
    mutate(year = as.integer(year)) |>
    group_by(region, year) |>
    summarise(across(where(is.numeric), ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
    rename(group = region) |>
    mutate(group_type = "Region")
)



# Save datasets to package data
usethis::use_data(standard_cpia, overwrite = TRUE)
usethis::use_data(africaii_cpia, overwrite = TRUE)
usethis::use_data(rawdata_cpia, overwrite = TRUE)
usethis::use_data(metadata_cpia, overwrite = TRUE)
usethis::use_data(group_standard_cpia, overwrite = TRUE)
usethis::use_data(group_africaii_cpia, overwrite = TRUE)
usethis::use_data(group_rawdata_cpia, overwrite = TRUE)

list(cpia_with_aii = aiicpia_tbl |> arrange(country_code, year),
     cpia_basic = basiccpia_tbl |> arrange(country_code, year),
     cpia_raw = rawcpia_tbl_with_varrow,
     cpia_metadata = cpiameta_tbl |> arrange(variable)) |>
  writexl::write_xlsx("data-raw/output/cpia.xlsx")






