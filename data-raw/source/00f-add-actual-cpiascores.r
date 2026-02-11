################################################################################################
################## ADD THE ACTUAL HISTORICAL CPIA SCORES TO THE PIPELINE #######################
################################################################################################

### load libraries
library(dplyr)
library(tidyr)

### pull the cpia data from data 360

dt <- extract_data_from_api(dataset_id = "WB_CPIA",
                            indicator_ids = "",
                            source = "d360",
                            verbose = TRUE)[[2]]


### Create mapping from World Bank CPIA indicator codes to variable names

wb_cpia_mapping <- tibble::tribble(
  ~INDICATOR, ~variable,
  "WB_CPIA_IQ_CPA_FISP_XQ", "cpia_fisp",  # Financial Sector
  "WB_CPIA_IQ_CPA_ENVR_XQ", "cpia_envr",  # Environmental
  "WB_CPIA_IQ_CPA_GNDR_XQ", "cpia_gndr",  # Gender
  "WB_CPIA_IQ_CPA_HRES_XQ", "cpia_hres",  # Human Resources
  "WB_CPIA_IQ_CPA_BREG_XQ", "cpia_breg",  # Business Regulatory
  "WB_CPIA_IQ_CPA_IRAI_XQ", "cpia_irai",  # IDA Resource Allocation Index
  "WB_CPIA_IQ_CPA_FINS_XQ", "cpia_fins",  # Financial Stability
  "WB_CPIA_IQ_CPA_DEBT_XQ", "cpia_debt",  # Debt Policy
  "WB_CPIA_IQ_CPA_ECON_XQ", "cpia_econ",  # Economic Management
  "WB_CPIA_IQ_CPA_PRES_XQ", "cpia_pres",  # Social Protection
  "WB_CPIA_IQ_CPA_PROP_XQ", "cpia_prop",  # Property Rights
  "WB_CPIA_IQ_CPA_PROT_XQ", "cpia_prot",  # Social Protection Rating
  "WB_CPIA_IQ_CPA_PADM_XQ", "cpia_padm",  # Public Administration
  "WB_CPIA_IQ_CPA_FINQ_XQ", "cpia_finq",  # Financial Management
  "WB_CPIA_IQ_CPA_MACR_XQ", "cpia_macr",  # Macroeconomic
  "WB_CPIA_IQ_CPA_SOCI_XQ", "cpia_soci",  # Social Inclusion
  "WB_CPIA_IQ_CPA_PUBS_XQ", "cpia_pubs",  # Public Sector Management
  "WB_CPIA_IQ_CPA_STRC_XQ", "cpia_strc",  # Structural Policies
  "WB_CPIA_IQ_CPA_TRAN_XQ", "cpia_tran",  # Transparency
  "WB_CPIA_IQ_CPA_TRAD_XQ", "cpia_trad",  # Trade
  "WB_CPIA_IQ_CPA_REVN_XQ", "cpia_revn"   # Revenue
)


### Transform dt to match standard_cpia format

actual_cpia <- dt |>
  # Select relevant columns
  select(INDICATOR, REF_AREA, TIME_PERIOD, OBS_VALUE) |>
  # Join with mapping
  left_join(wb_cpia_mapping, by = "INDICATOR") |>
  # Convert types
  mutate(
    country_code = REF_AREA,
    year = as.integer(TIME_PERIOD),
    value = as.numeric(OBS_VALUE),
    cpia_year = year + 1  # Add one year lag like in standard_cpia
  ) |>
  select(country_code, year, variable, value, cpia_year) |>
  # Pivot to wide format
  pivot_wider(
    names_from = variable,
    values_from = value
  ) |>
  # Merge with country metadata
  left_join(wbcountries, by = "country_code") |>
  # Reorder columns to match standard_cpia
  select(country_code, year, starts_with("cpia_"), cpia_year, 
         economy, income_group, lending_category, region_code, region)


### Save to package data

usethis::use_data(actual_cpia, overwrite = TRUE)

