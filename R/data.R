#' CPIA Indicator Metadata
#'
#' A dataset providing metadata for the Country Policy and Institutional Assessment (CPIA)
#' indicators used in the Governance Department’s analytical framework. Each row corresponds
#' to a single indicator associated with one or more CPIA questions and subquestions.
#'
#' @format A tibble with 58 rows and 9 variables:
#' \describe{
#' \item{indicator}{Character. The short code identifying the underlying data indicator
#' (e.g., \code{"bs_bti_q15_1"}, \code{"ibp_obs_obi"}, \code{"vdem_core_v2clacjstm"}).}
#' \item{variable}{Character. CPIA variable code linking each indicator to the question in
#' the CPIA questionnaire (e.g., \code{"q15a"}, \code{"q12b"}).}
#' \item{question}{Character. The title of the CPIA question to which the indicator relates,
#' such as “Quality of Public Administration” or “Property Rights and Rule-based Governance.”}
#' \item{subquestion}{Character. The subcomponent of the question describing the specific
#' institutional or policy dimension being assessed.}
#' \item{Description}{Character. A longer textual description of the indicator or its
#' measurement focus, often referencing external sources.}
#' \item{source}{Character. The primary data source for the indicator (e.g., \code{"CLIAR"},
#' World Bank PEFA, V-Dem, or WJP Rule of Law).}
#' \item{var_name}{Character. A human-readable label summarizing the indicator concept,
#' such as “Efficient use of assets” or “Independent judiciary.”}
#' \item{description}{Character. A detailed narrative describing how the indicator is
#' conceptualized or assessed.}
#' \item{description_short}{Character. A concise summary of the indicator definition for
#' use in dashboards or reports.}
#' }
#'
#' @details
#' The \code{cpia_indicators} dataset maps each indicator to the CPIA structure used by the
#' Governance Department for objective scoring and analytical dashboards. It links quantitative
#' indicators from external data sources (such as V-Dem, BTI, PEFA, or WJP) to specific CPIA
#' criteria, enabling reproducible and transparent CPIA scoring.
#'
#' @source Compiled by the Governance Department's Institutional Capacity and Effectiveness Team
#' from the CLIAR and CPIA documentation files.
#'
#' @examples
#' data(cpia_indicators)
"cpia_indicators"


#' CPIA Question 13b Indicator: Government Spending as Share of Budget
#'
#' This dataset provides an empirical proxy for CPIA Question 13b, which assesses
#' the credibility of the government budget — specifically, the extent to which
#' actual government expenditures align with the approved budget. The indicator
#' is constructed using data on government spending as a share of the approved
#' budget, transformed to align with the 1–6 scale of the World Bank’s Country
#' Policy and Institutional Assessment (CPIA) framework.
#'
#' @details
#' The transformation follows these steps:
#' \enumerate{
#'   \item Compute the deviation of government spending from 100\% of the approved budget
#'         to capture the distance from perfect budget execution.
#'   \item Reverse the direction of the indicator so that higher values represent
#'         greater credibility (i.e., spending closer to 100\% of the budget).
#'   \item Rescale the indicator to lie between 0 and 1.
#'   \item Translate the rescaled indicator to the CPIA scale of 1 to 6 using
#'         the transformation \eqn{y = 5x + 1}.
#' }
#'
#' The resulting indicator can be interpreted as an approximation of the CPIA
#' 13b score, where higher values indicate greater budget credibility and stronger
#' alignment between planned and executed government expenditures.
#'
#' @format A tibble with 2,368 rows and 4 variables:
#' \describe{
#'   \item{country_code}{A three-letter ISO country code.}
#'   \item{year}{The reference year for the observation (as character).}
#'   \item{q13b_raw}{The raw value of the variable}
#'   \item{q13b}{The transformed indicator representing the estimated CPIA 13b score
#'               (numeric, ranging approximately from 1 to 6).}
#' }
#'
#' @source Constructed by the author using government spending as a share of
#' the approved budget, transformed to approximate the CPIA 13b methodology.
#'
#' @examples
#' \dontrun{
#' # Example: Visualize average CPIA 13b score by region
#' q13b_tbl |>
#'   dplyr::group_by(region) |>
#'   dplyr::summarize(mean_q13b = mean(q13b, na.rm = TRUE)) |>
#'   ggplot2::ggplot(ggplot2::aes(x = region, y = mean_q13b)) +
#'   ggplot2::geom_col() +
#'   ggplot2::theme_minimal() +
#'   ggplot2::labs(
#'     title = "Average CPIA 13b (Budget Credibility) by Region",
#'     y = "CPIA 13b Score (1–6)"
#'   )
#' }
"q13b_tbl"


#' Property Rights Data
#'
#' A dataset containing yearly measures of property rights for various countries.
#' This dataset is used to analyze trends in property rights and governance quality.
#'
#' @format A tibble with 2,381 rows and 3 variables:
#' \describe{
#'   \item{country_code}{ISO 3166-3 country code (character).}
#'   \item{year}{Year of the observation (numeric).}
#'   \item{property_rights}{The transformed Measure of property rights on a numeric scale (numeric).}
#'   \item{property_rights_raw}{The raw property rights variable}
#' }
#'
#' @source Compiled from publicly available governance indicators (source details can be added here).
#'
#' @examples
#' # View the first few rows
#' head(prights_tbl)
#'
#' # Filter data for Afghanistan
#' dplyr::filter(prights_tbl, country_code == "AFG")
"prights_tbl"


#' African Integrity Indicators (AII) Dataset
#'
#' @description
#' The `aii_tbl` dataset contains scores from the *African Integrity Indicators (AII)* project,
#' compiled by Global Integrity, covering governance and accountability dimensions across African countries
#' for multiple years. The data provides country-year scores on 37 indicators assessing various dimensions
#' of public integrity, transparency, accountability, and citizen participation.
#'
#' @format
#' A tibble with 594 rows and 30 columns:
#' \describe{
#'   \item{country_code}{Character. Three-letter ISO3 country code.}
#'   \item{year}{Integer. Year of observation.}
#'   \item{gi_aii_1}{Numeric. Existence and effectiveness of laws promoting access to information.}
#'   \item{gi_aii_2}{Numeric. Implementation of access to information laws.}
#'   \item{gi_aii_3}{Numeric. Publication of government data and budget information.}
#'   \item{gi_aii_4}{Numeric. Transparency of government decision-making processes.}
#'   \item{gi_aii_5}{Numeric. Citizen participation in policy formulation.}
#'   \item{gi_aii_6}{Numeric. Civil society access to government information.}
#'   \item{gi_aii_7}{Numeric. Media freedom and independence.}
#'   \item{gi_aii_8}{Numeric. Freedom of expression protections.}
#'   \item{gi_aii_9}{Numeric. Government censorship practices.}
#'   \item{gi_aii_10}{Numeric. Effectiveness of anti-corruption institutions.}
#'   \item{gi_aii_11}{Numeric. Independence of oversight agencies.}
#'   \item{gi_aii_12}{Numeric. Transparency in public procurement processes.}
#'   \item{gi_aii_13}{Numeric. Whistleblower protection mechanisms.}
#'   \item{gi_aii_14}{Numeric. Conflict of interest regulations for public officials.}
#'   \item{gi_aii_15}{Numeric. Financial disclosure requirements for public officials.}
#'   \item{gi_aii_16}{Numeric. Public availability of asset declarations.}
#'   \item{gi_aii_26}{Numeric. Integrity of the judiciary system.}
#'   \item{gi_aii_27}{Numeric. Independence of the judiciary.}
#'   \item{gi_aii_28}{Numeric. Fairness and transparency of electoral processes.}
#'   \item{gi_aii_29}{Numeric. Political competition and openness.}
#'   \item{gi_aii_30}{Numeric. Effectiveness of electoral management bodies.}
#'   \item{gi_aii_31}{Numeric. Political participation rights.}
#'   \item{gi_aii_32}{Numeric. Gender equality in political participation.}
#'   \item{gi_aii_33}{Numeric. Citizen engagement and accountability mechanisms.}
#'   \item{gi_aii_34}{Numeric. Rule of law and enforcement of rights.}
#'   \item{gi_aii_35}{Numeric. Oversight of security sector operations.}
#'   \item{gi_aii_36}{Numeric. Accountability in the defense sector.}
#'   \item{gi_aii_37}{Numeric. Control of corruption in the public sector.}
#' }
#'
#' @details
#' Each indicator takes a value between 0 and 1, with higher scores indicating
#' stronger integrity or better performance on the measured dimension. The dataset
#' includes data for multiple African countries from 2014 to 2018.
#'
#' @source
#' Global Integrity. *African Integrity Indicators Project (AII)*.
#' Data available at: \url{https://www.globalintegrity.org/african-integrity-indicators/}
#'
#' @examples
#' data(aii_tbl)
#' dplyr::glimpse(aii_tbl)
"aii_tbl"


#' World Governance Indicators (WDI) Dataset
#'
#' @description
#' The `wdi_tbl` dataset contains governance indicator data from the *World Governance Indicators (WGI)* project,
#' published by the World Bank. The data provides standardized measures of regulatory quality, control of corruption,
#' and voice and accountability across countries and years. These indicators are widely used in governance diagnostics
#' and complement the CPIA governance cluster dimensions.
#'
#' @format
#' A tibble with 2,255 rows and 5 columns:
#' \describe{
#'   \item{country_code}{Character. Three-letter ISO3 country code.}
#'   \item{year}{Integer. Year of observation.}
#'   \item{wb_wdi_rq_per_rnk}{Numeric. \strong{Index of Regulatory Quality} — captures perceptions of the ability of the government
#'   to formulate and implement sound policies and regulations that permit and promote private sector development.
#'   Theoretical range: \code{c(0, 100)}. (Corresponds to CPIA question 12b).}
#'   \item{wb_wdi_cc_est}{Numeric. \strong{Control of Corruption Index} — captures perceptions of the extent to which public power
#'   is exercised for private gain, including both petty and grand forms of corruption, as well as state capture by elites
#'   and private interests. Theoretical range: \code{c(-2.5, 2.5)}. (Corresponds to CPIA question 16c).}
#'   \item{wb_wdi_va_est}{Numeric. \strong{Voice and Accountability Index} — captures perceptions of the extent to which a country's
#'   citizens are able to participate in selecting their government, as well as freedom of expression, association, and media.
#'   Theoretical range: \code{c(-2.5, 2.5)}. (Corresponds to CPIA question 16c).}
#' }
#'
#' @details
#' The World Governance Indicators (WGI) are compiled by the World Bank and represent composite indices based on
#' multiple underlying data sources. They are standardized annually, allowing cross-country comparisons in governance
#' performance and trends over time. Higher values denote better governance performance on the respective dimension.
#'
#' This dataset is part of the proxy data assembled for the CPIA governance cluster and covers all available countries
#' and years from the WGI database used in the CPIA data harmonization exercise.
#'
#' @source
#' Kaufmann, Daniel, Aart Kraay, and Massimo Mastruzzi (2010).
#' *The Worldwide Governance Indicators: Methodology and Analytical Issues.*
#' World Bank Policy Research Working Paper No. 5430.
#' Data available at: \url{https://info.worldbank.org/governance/wgi/}
#'
#' @examples
#' data(wdi_tbl)
#' dplyr::glimpse(wdi_tbl)
"wdi_tbl"





#' World Bank Country Classifications
#'
#' A dataset containing the World Bank's official country classifications including
#' economy names, country codes, income groups, lending categories, and regional
#' assignments. This dataset uses the World Bank's updated regional classification
#' that splits Sub-Saharan Africa into Eastern/Southern and Western/Central regions.
#'
#' @format A tibble with 218 rows and 6 variables:
#' \describe{
#' \item{economy}{Full name of the economy or territory.}
#' \item{country_code}{Three-letter ISO3 country code.}
#' \item{income_group}{World Bank income classification: "Low income",
#' "Lower middle income", "Upper middle income", or "High income".}
#' \item{lending_category}{World Bank lending category: "IDA" (International Development Association),
#' "IBRD" (International Bank for Reconstruction and Development), "Blend" (IDA and IBRD),
#' or \code{NA} for high-income countries not eligible for lending.}
#' \item{region_code}{Three-letter code for the World Bank region:
#' \itemize{
#'   \item AFE - Africa Eastern and Southern
#'   \item AFW - Africa Western and Central
#'   \item EAP - East Asia & Pacific
#'   \item ECA - Europe & Central Asia
#'   \item LAC - Latin America & Caribbean
#'   \item MENAAP - Middle East, North Africa, Afghanistan & Pakistan
#'   \item SAR - South Asia
#'   \item NAC - North America
#' }}
#' \item{region}{Full name of the World Bank region corresponding to the region_code.}
#' }
#'
#' @details
#' This dataset reflects the World Bank's current operational classification of countries
#' and territories. The regional classification follows the World Bank's updated structure
#' that divides Sub-Saharan Africa into two regions: Africa Eastern and Southern (AFE)
#' and Africa Western and Central (AFW). This provides more granular regional analysis
#' for governance and development indicators.
#'
#' The lending categories reflect eligibility for different World Bank financing instruments:
#' \itemize{
#'   \item IDA countries are eligible for concessional financing
#'   \item IBRD countries can borrow at market-based terms
#'   \item Blend countries are eligible for both IDA and IBRD financing
#'   \item High-income countries typically have \code{NA} for lending category
#' }
#'
#' @source
#' World Bank Country and Lending Groups Classification (October 2025).
#' File: CLASS_2025_10_07.xlsx
#'
#' @examples
#' data(wbcountries)
#' # View all Africa Eastern and Southern countries
#' dplyr::filter(wbcountries, region_code == "AFE")
#'
#' # View all low-income IDA countries
#' dplyr::filter(wbcountries, income_group == "Low income", lending_category == "IDA")
#'
#' # Count countries by region
#' dplyr::count(wbcountries, region)
"wbcountries"


#' Standard CPIA Dataset (Without African Integrity Indicators)
#'
#' A comprehensive dataset containing Country Policy and Institutional Assessment (CPIA)
#' scores for the governance cluster (Questions 12, 13, 15, and 16) calculated using
#' standard global governance indicators, excluding the African Integrity Indicators.
#' This dataset provides objective, data-driven proxy scores for CPIA criteria based
#' on indicators from V-Dem, World Governance Indicators, CLIAR, PEFA, and other
#' internationally recognized sources.
#'
#' @format A tibble with 2,592 rows and 19 variables:
#' \describe{
#' \item{country_code}{Three-letter ISO3 country code.}
#' \item{year}{Original year of the underlying indicator data.}
#' \item{q12a}{CPIA criterion 12a: Property rights and rule-based governance (1-6 scale).}
#' \item{q12b}{CPIA criterion 12b: Quality of budgetary and financial management (1-6 scale).}
#' \item{q12c}{CPIA criterion 12c: Efficiency of revenue mobilization (1-6 scale).}
#' \item{q13b}{CPIA criterion 13b: Quality of public administration (1-6 scale).}
#' \item{q15a}{CPIA criterion 15a: Quality of public financial management (1-6 scale).}
#' \item{q15b}{CPIA criterion 15b: Quality of public procurement systems (1-6 scale).}
#' \item{q15c}{CPIA criterion 15c: Quality of audit and oversight institutions (1-6 scale).}
#' \item{q16a}{CPIA criterion 16a: Transparency, accountability, and corruption in the public sector (1-6 scale).}
#' \item{q16b}{CPIA criterion 16b: Quality of legal and judicial systems (1-6 scale).}
#' \item{q16c}{CPIA criterion 16c: Quality of anti-corruption framework (1-6 scale).}
#' \item{q16d}{CPIA criterion 16d: Accountability and transparency of public institutions (1-6 scale).}
#' \item{cpia_year}{Reference year for the CPIA assessment (year + 1), reflecting the
#' one-year lag in CPIA reporting.}
#' \item{economy}{Full name of the country/economy.}
#' \item{income_group}{World Bank income classification (Low income, Lower middle income,
#' Upper middle income, High income).}
#' \item{lending_category}{World Bank lending category (IDA, IBRD, Blend, or NA).}
#' \item{region_code}{Three-letter World Bank region code (AFE, AFW, EAP, ECA, LAC, MENAAP, SAR, NAC).}
#' \item{region}{Full name of the World Bank region.}
#' }
#'
#' @details
#' The World Bank's CPIA is an annual assessment of the quality of countries' policy and
#' institutional frameworks. This dataset provides objective proxy scores for the governance
#' cluster using quantitative indicators from multiple international data sources.
#'
#' **Methodology:**
#' Indicators from various sources (V-Dem, WGI, CLIAR, etc.) are mapped to specific CPIA
#' questions, normalized to 0-1 scale, and then transformed to the CPIA 1-6 scale using
#' the formula: CPIA_score = (normalized_value × 5) + 1. When multiple indicators map to
#' the same CPIA criterion, their scores are averaged.
#'
#' **Data Sources:**
#' This standard version uses governance indicators from V-Dem, World Governance Indicators,
#' CLIAR Closeness-to-Frontier metrics, PEFA assessments, and World Development Indicators,
#' but excludes African Integrity Indicators to maintain global consistency.
#'
#' Missing values indicate either unavailable underlying data or that a country was not
#' assessed for that criterion in that year.
#'
#' @source
#' Compiled by the World Bank Governance Global Practice from multiple governance data sources.
#' See \code{metadata_cpia} for detailed indicator mappings and source information.
#'
#' @seealso
#' \code{\link{africaii_cpia}} for CPIA scores including African Integrity Indicators
#' \code{\link{metadata_cpia}} for indicator metadata and source mappings
#' \code{\link{rawdata_cpia}} for underlying raw indicator values
#'
#' @examples
#' data(standard_cpia)
#' # View CPIA scores for a specific country
#' dplyr::filter(standard_cpia, country_code == "KEN")
#'
#' # Calculate average governance scores by year
#' standard_cpia |>
#'   dplyr::group_by(cpia_year) |>
#'   dplyr::summarise(across(q12a:q16d, ~mean(.x, na.rm = TRUE)))
#'
#' # Compare scores across regions
#' standard_cpia |>
#'   dplyr::group_by(region) |>
#'   dplyr::summarise(avg_q16c = mean(q16c, na.rm = TRUE))
"standard_cpia"


#' CPIA Dataset with African Integrity Indicators
#'
#' A comprehensive dataset containing Country Policy and Institutional Assessment (CPIA)
#' scores for the governance cluster (Questions 12, 13, 15, and 16) calculated using
#' global governance indicators supplemented with African Integrity Indicators (AII)
#' where available. This version provides enhanced coverage and granularity for African
#' countries by incorporating AII governance metrics.
#'
#' @format A tibble with 2,592 rows and 19 variables:
#' \describe{
#' \item{country_code}{Three-letter ISO3 country code.}
#' \item{year}{Original year of the underlying indicator data.}
#' \item{q12a}{CPIA criterion 12a: Property rights and rule-based governance (1-6 scale).}
#' \item{q12b}{CPIA criterion 12b: Quality of budgetary and financial management (1-6 scale).}
#' \item{q12c}{CPIA criterion 12c: Efficiency of revenue mobilization (1-6 scale).}
#' \item{q13b}{CPIA criterion 13b: Quality of public administration (1-6 scale).}
#' \item{q15a}{CPIA criterion 15a: Quality of public financial management (1-6 scale).}
#' \item{q15b}{CPIA criterion 15b: Quality of public procurement systems (1-6 scale).}
#' \item{q15c}{CPIA criterion 15c: Quality of audit and oversight institutions (1-6 scale).}
#' \item{q16a}{CPIA criterion 16a: Transparency, accountability, and corruption in the public sector (1-6 scale).}
#' \item{q16b}{CPIA criterion 16b: Quality of legal and judicial systems (1-6 scale).}
#' \item{q16c}{CPIA criterion 16c: Quality of anti-corruption framework (1-6 scale).}
#' \item{q16d}{CPIA criterion 16d: Accountability and transparency of public institutions (1-6 scale).}
#' \item{cpia_year}{Reference year for the CPIA assessment (year + 1), reflecting the
#' one-year lag in CPIA reporting.}
#' \item{economy}{Full name of the country/economy.}
#' \item{income_group}{World Bank income classification (Low income, Lower middle income,
#' Upper middle income, High income).}
#' \item{lending_category}{World Bank lending category (IDA, IBRD, Blend, or NA).}
#' \item{region_code}{Three-letter World Bank region code (AFE, AFW, EAP, ECA, LAC, MENAAP, SAR, NAC).}
#' \item{region}{Full name of the World Bank region.}
#' }
#'
#' @details
#' This dataset augments standard governance indicators with data from the African Integrity
#' Indicators (AII) project compiled by Global Integrity and includes World Bank country
#' classification metadata (region, income group, lending category). The AII provides detailed
#' assessments of governance, transparency, accountability, and anti-corruption mechanisms
#' specifically for African countries, offering more nuanced measurements than global
#' indicators alone.
#'
#' **Methodology:**
#' The scoring methodology is identical to \code{standard_cpia}, but includes AII indicators
#' in the aggregation process. When both global and AII indicators are available for the
#' same CPIA criterion, they are averaged together. This provides more robust estimates
#' for African countries while maintaining comparability with other regions.
#'
#' **Coverage:**
#' AII data is available for select African countries covering 2014-2018. For countries
#' and years without AII data, this dataset falls back to the same indicators used in
#' \code{standard_cpia}.
#'
#' @source
#' Compiled by the World Bank Governance Global Practice from multiple sources including
#' Global Integrity's African Integrity Indicators, V-Dem, WGI, CLIAR, and PEFA.
#' See \code{metadata_cpia} for detailed indicator mappings.
#'
#' @seealso
#' \code{\link{standard_cpia}} for CPIA scores without African Integrity Indicators
#' \code{\link{aii_tbl}} for raw African Integrity Indicators data
#' \code{\link{metadata_cpia}} for indicator metadata and source mappings
#'
#' @examples
#' data(africaii_cpia)
#' # View scores for African countries with AII data
#' africaii_cpia |>
#'   dplyr::filter(country_code %in% c("KEN", "GHA", "UGA"), year >= 2014)
#'
#' # Calculate average corruption control score by year
#' africaii_cpia |>
#'   dplyr::group_by(cpia_year) |>
#'   dplyr::summarise(avg_corruption = mean(q16c, na.rm = TRUE))
"africaii_cpia"


#' CPIA Raw Indicator Data
#'
#' A comprehensive dataset containing the underlying raw indicator values used to
#' construct CPIA governance cluster scores. This dataset provides the original,
#' untransformed indicator values from multiple international data sources, enabling
#' transparency, reproducibility, and alternative aggregation methods.
#'
#' @format A tibble with 3,408 rows and 83 columns:
#' \describe{
#' \item{country_code}{Three-letter ISO3 country code.}
#' \item{cpia_year}{Reference year for the CPIA assessment (original year + 1).}
#' \item{economy}{Full name of the country/economy.}
#' \item{income_group}{World Bank income classification.}
#' \item{lending_category}{World Bank lending category (IDA, IBRD, Blend, or NA).}
#' \item{region_code}{Three-letter World Bank region code.}
#' \item{region}{Full name of the World Bank region.}
#' \item{...}{Remaining 76 columns contain raw indicator values from various sources.
#' The first row contains the CPIA variable code (q12a, q12b, etc.) that each indicator
#' maps to. Column names are the indicator codes (e.g., \code{vdem_core_v2clacjstm},
#' \code{wb_wdi_cc_est}, \code{gi_aii_10}, etc.).}
#' }
#'
#' @details
#' This dataset serves as the foundation for CPIA score construction and contains raw
#' indicator values along with World Bank country classification metadata:
#'
#' **Structure:**
#' - Row 1: CPIA variable codes showing which CPIA question each indicator maps to
#' - Rows 2+: Country-year observations with raw indicator values and country metadata
#'
#' **Indicator Sources:**
#' Raw data is drawn from:
#' \itemize{
#'   \item V-Dem (Varieties of Democracy) indicators
#'   \item World Governance Indicators (WGI)
#'   \item African Integrity Indicators (AII)
#'   \item CLIAR Closeness-to-Frontier measures
#'   \item PEFA (Public Expenditure and Financial Accountability) assessments
#'   \item World Development Indicators (WDI)
#'   \item Heritage Foundation Economic Freedom Index
#'   \item World Justice Project Rule of Law Index
#'   \item BTI (Bertelsmann Transformation Index)
#' }
#'
#' **Use Cases:**
#' - Verify CPIA score calculations
#' - Perform custom aggregations or weighting schemes
#' - Analyze individual governance dimensions
#' - Research methodological variations
#' - Conduct sensitivity analyses
#'
#' Each indicator retains its original scale and interpretation. See \code{metadata_cpia}
#' for detailed information about each indicator including theoretical ranges, descriptions,
#' and transformation methods.
#'
#' @source
#' Compiled by the World Bank Governance Global Practice from multiple international
#' governance data sources. See \code{metadata_cpia} for source-specific citations.
#'
#' @seealso
#' \code{\link{metadata_cpia}} for indicator definitions and metadata
#' \code{\link{standard_cpia}} and \code{\link{africaii_cpia}} for aggregated CPIA scores
#'
#' @examples
#' data(rawdata_cpia)
#' # View the variable mapping row
#' rawdata_cpia[1, 1:10]
#'
#' # Extract raw V-Dem rule of law indicator
#' rawdata_cpia |>
#'   dplyr::select(country_code, cpia_year, vdem_core_v2x_rule) |>
#'   dplyr::slice(-1)  # Remove the variable name row
"rawdata_cpia"


#' CPIA Indicator Metadata
#'
#' A comprehensive metadata dataset documenting all indicators used in the construction
#' of CPIA governance cluster scores. Each row describes one indicator, including its
#' source, definition, theoretical range, and mapping to CPIA questions. This dataset
#' is essential for understanding CPIA score composition and ensuring methodological
#' transparency.
#'
#' @format A tibble with 80 rows and 7 variables:
#' \describe{
#' \item{indicator}{Character. The unique indicator code used in the raw data
#' (e.g., \code{"vdem_core_v2clacjstm"}, \code{"wb_wdi_cc_est"}, \code{"gi_aii_10"}).}
#' \item{variable}{Character. CPIA variable code indicating which CPIA question/criterion
#' the indicator maps to (e.g., \code{"q12a"}, \code{"q15b"}, \code{"q16c"}).}
#' \item{source}{Character. The primary data source or project providing the indicator:
#' \itemize{
#'   \item CLIAR - Closeness to Frontier indicators
#'   \item African Integrity Index - Global Integrity AII project
#'   \item World Governance Indicators - World Bank WGI
#'   \item V-Dem - Varieties of Democracy project
#'   \item PEFA - Public Expenditure and Financial Accountability
#'   \item Heritage Index of Economic Freedom
#'   \item World Justice Project
#'   \item World Development Indicators
#' }}
#' \item{var_name}{Character. Human-readable short label for the indicator
#' (e.g., "Control of Corruption", "Judicial Independence", "Budget Transparency").}
#' \item{var_description}{Character. Detailed description of what the indicator measures,
#' including methodology, coverage, and interpretation. This field contains the full
#' technical definition from the source documentation.}
#' \item{var_description_short}{Character. Concise one-sentence summary of the indicator
#' suitable for dashboards, charts, and reports.}
#' \item{theoretical_range}{Character. The theoretical minimum and maximum values for the
#' indicator in its original scale, expressed as R code (e.g., \code{"c(0,1)"},
#' \code{"c(-2.5, 2.5)"}, \code{"c(0, 100)"}).}
#' }
#'
#' @details
#' This metadata dataset provides complete documentation for the 80 indicators used in
#' CPIA score construction. It enables:
#'
#' **Transparency:**
#' - Full disclosure of all data sources and indicator definitions
#' - Clear mapping from indicators to CPIA questions
#' - Documentation of indicator scales and ranges
#'
#' **Reproducibility:**
#' - Enables replication of CPIA score calculations
#' - Supports verification and validation of methodology
#' - Facilitates sensitivity analyses
#'
#' **Research:**
#' - Understand which governance dimensions are captured by each CPIA criterion
#' - Compare measurement approaches across data sources
#' - Identify gaps or overlaps in indicator coverage
#'
#' Multiple indicators can map to the same CPIA variable code, reflecting the use of
#' multiple data sources to measure similar governance dimensions. These are averaged
#' in the final CPIA score calculation.
#'
#' @source
#' Compiled by the World Bank Governance Global Practice from source documentation
#' of V-Dem, WGI, AII, CLIAR, PEFA, and other governance data projects.
#'
#' @seealso
#' \code{\link{rawdata_cpia}} for the raw indicator values
#' \code{\link{standard_cpia}} and \code{\link{africaii_cpia}} for calculated CPIA scores
#' \code{\link{cpia_indicators}} for the original CPIA indicator metadata
#'
#' @examples
#' data(metadata_cpia)
#' # View all indicators for CPIA question 16c (corruption control)
#' dplyr::filter(metadata_cpia, variable == "q16c")
#'
#' # Count indicators by source
#' dplyr::count(metadata_cpia, source, sort = TRUE)
#'
#' # View indicators from African Integrity Index
#' dplyr::filter(metadata_cpia, source == "African Integrity Index")
"metadata_cpia"


#' Grouped Standard CPIA by Region and Income Group
#'
#' A dataset containing average Country Policy and Institutional Assessment (CPIA)
#' scores aggregated by World Bank region and income group. This dataset provides
#' regional and income-level benchmarks for governance performance using standard
#' CPIA indicators (excluding African Integrity Indicators).
#'
#' @format A tibble with aggregated CPIA scores and 16 variables:
#' \describe{
#' \item{group}{Character. The name of the region or income group (e.g., "Africa Eastern
#' and Southern", "Low income", "High income").}
#' \item{year}{Integer. Original year of the underlying indicator data.}
#' \item{q12a}{Numeric. Average CPIA criterion 12a score for the group (1-6 scale).}
#' \item{q12b}{Numeric. Average CPIA criterion 12b score for the group (1-6 scale).}
#' \item{q12c}{Numeric. Average CPIA criterion 12c score for the group (1-6 scale).}
#' \item{q13b}{Numeric. Average CPIA criterion 13b score for the group (1-6 scale).}
#' \item{q15a}{Numeric. Average CPIA criterion 15a score for the group (1-6 scale).}
#' \item{q15b}{Numeric. Average CPIA criterion 15b score for the group (1-6 scale).}
#' \item{q15c}{Numeric. Average CPIA criterion 15c score for the group (1-6 scale).}
#' \item{q16a}{Numeric. Average CPIA criterion 16a score for the group (1-6 scale).}
#' \item{q16b}{Numeric. Average CPIA criterion 16b score for the group (1-6 scale).}
#' \item{q16c}{Numeric. Average CPIA criterion 16c score for the group (1-6 scale).}
#' \item{q16d}{Numeric. Average CPIA criterion 16d score for the group (1-6 scale).}
#' \item{cpia_year}{Integer. Reference year for the CPIA assessment (year + 1).}
#' \item{group_type}{Character. Indicates whether the group represents an "Income Group"
#' or "Region" classification.}
#' }
#'
#' @details
#' This dataset aggregates country-level CPIA scores from \code{standard_cpia} by calculating
#' mean scores for each CPIA criterion within regions and income groups. It enables:
#'
#' **Regional Comparisons:**
#' Compare governance performance across World Bank regions (Africa Eastern and Southern,
#' Africa Western and Central, East Asia & Pacific, etc.).
#'
#' **Income Group Benchmarking:**
#' Analyze how governance quality varies by income level (Low income, Lower middle income,
#' Upper middle income, High income).
#'
#' **Trend Analysis:**
#' Track changes in regional and income group governance performance over time.
#'
#' The aggregation uses simple means with \code{na.rm = TRUE}, so groups with more
#' countries or better data coverage may have more reliable averages. Missing values
#' (\code{NaN}) indicate that no countries in that group had data for that criterion
#' in that year.
#'
#' @source
#' Derived from \code{standard_cpia} by the World Bank Governance Global Practice.
#'
#' @seealso
#' \code{\link{standard_cpia}} for country-level CPIA scores
#' \code{\link{group_africaii_cpia}} for grouped scores including African Integrity Indicators
#' \code{\link{wbcountries}} for country classification information
#'
#' @examples
#' data(group_standard_cpia)
#' # Compare corruption control scores across regions
#' group_standard_cpia |>
#'   dplyr::filter(group_type == "Region", cpia_year == 2020) |>
#'   dplyr::select(group, q16c)
#'
#' # Track low-income countries' governance trends
#' group_standard_cpia |>
#'   dplyr::filter(group == "Low income") |>
#'   dplyr::select(cpia_year, q12a, q15a, q16a)
#'
#' # Compare income groups on public administration quality
#' group_standard_cpia |>
#'   dplyr::filter(group_type == "Income Group", cpia_year == 2020) |>
#'   dplyr::arrange(desc(q13b))
"group_standard_cpia"


#' Grouped CPIA with African Integrity Indicators by Region and Income Group
#'
#' A dataset containing average Country Policy and Institutional Assessment (CPIA)
#' scores aggregated by World Bank region and income group. This version includes
#' African Integrity Indicators where available, providing enhanced regional
#' benchmarks particularly for African countries.
#'
#' @format A tibble with aggregated CPIA scores and 16 variables:
#' \describe{
#' \item{group}{Character. The name of the region or income group.}
#' \item{year}{Integer. Original year of the underlying indicator data.}
#' \item{q12a}{Numeric. Average CPIA criterion 12a score for the group (1-6 scale).}
#' \item{q12b}{Numeric. Average CPIA criterion 12b score for the group (1-6 scale).}
#' \item{q12c}{Numeric. Average CPIA criterion 12c score for the group (1-6 scale).}
#' \item{q13b}{Numeric. Average CPIA criterion 13b score for the group (1-6 scale).}
#' \item{q15a}{Numeric. Average CPIA criterion 15a score for the group (1-6 scale).}
#' \item{q15b}{Numeric. Average CPIA criterion 15b score for the group (1-6 scale).}
#' \item{q15c}{Numeric. Average CPIA criterion 15c score for the group (1-6 scale).}
#' \item{q16a}{Numeric. Average CPIA criterion 16a score for the group (1-6 scale).}
#' \item{q16b}{Numeric. Average CPIA criterion 16b score for the group (1-6 scale).}
#' \item{q16c}{Numeric. Average CPIA criterion 16c score for the group (1-6 scale).}
#' \item{q16d}{Numeric. Average CPIA criterion 16d score for the group (1-6 scale).}
#' \item{cpia_year}{Integer. Reference year for the CPIA assessment (year + 1).}
#' \item{group_type}{Character. Indicates whether the group represents an "Income Group"
#' or "Region" classification.}
#' }
#'
#' @details
#' This dataset aggregates country-level CPIA scores from \code{africaii_cpia}, which
#' includes African Integrity Indicators. For African regions (Africa Eastern and Southern,
#' Africa Western and Central), the averages incorporate AII data where available,
#' potentially providing more granular governance assessments than global indicators alone.
#'
#' The methodology is identical to \code{group_standard_cpia}, but uses the AII-enhanced
#' country scores as inputs. This provides more nuanced regional benchmarks for African
#' countries while maintaining consistency with global indicators for other regions.
#'
#' @source
#' Derived from \code{africaii_cpia} by the World Bank Governance Global Practice.
#'
#' @seealso
#' \code{\link{africaii_cpia}} for country-level scores with African Integrity Indicators
#' \code{\link{group_standard_cpia}} for grouped scores without AII
#' \code{\link{aii_tbl}} for raw African Integrity Indicators
#'
#' @examples
#' data(group_africaii_cpia)
#' # Compare African regions
#' group_africaii_cpia |>
#'   dplyr::filter(group_type == "Region",
#'                 grepl("Africa", group),
#'                 cpia_year == 2018)
#'
#' # Contrast with standard version for African regions
#' dplyr::bind_rows(
#'   group_standard_cpia |> dplyr::mutate(version = "Standard"),
#'   group_africaii_cpia |> dplyr::mutate(version = "With AII")
#' ) |>
#'   dplyr::filter(grepl("Africa", group), cpia_year == 2018)
"group_africaii_cpia"


#' Grouped Raw CPIA Indicator Data by Region and Income Group
#'
#' A dataset containing average raw governance indicator values aggregated by World Bank
#' region and income group. This dataset provides regional and income-level benchmarks
#' for the underlying indicators used to construct CPIA scores, enabling analysis of
#' specific governance dimensions before transformation to the CPIA scale.
#'
#' @format A tibble with aggregated raw indicator values and 78+ variables:
#' \describe{
#' \item{group}{Character. The name of the region or income group.}
#' \item{year}{Integer. Reference year for the indicators.}
#' \item{...}{Remaining columns contain average raw indicator values for various governance
#' measures from V-Dem, WGI, AII, CLIAR, PEFA, and other sources. Each numeric column
#' represents the mean value of that indicator across all countries in the group.}
#' \item{group_type}{Character. Indicates whether the group represents an "Income Group"
#' or "Region" classification.}
#' }
#'
#' @details
#' This dataset aggregates raw indicator values from \code{rawcpia_tbl} (the clean numeric
#' version without the header row) by calculating means within regions and income groups.
#' It provides:
#'
#' **Indicator-Level Benchmarks:**
#' Compare specific governance dimensions (e.g., judicial independence, budget transparency,
#' corruption control) across regions and income levels using original indicator scales.
#'
#' **Pre-Transformation Analysis:**
#' Examine raw indicator patterns before they are normalized and transformed to CPIA scores,
#' useful for understanding the underlying data distributions.
#'
#' **Methodological Flexibility:**
#' Apply custom aggregation methods, weighting schemes, or transformations to raw indicators
#' for specialized governance analyses.
#'
#' Each indicator retains its original scale and interpretation. Indicators are averaged
#' with \code{na.rm = TRUE}, so groups with more countries or better indicator coverage
#' will have more reliable averages.
#'
#' @source
#' Derived from raw governance indicator data compiled by the World Bank Governance
#' Global Practice. See \code{metadata_cpia} for indicator-specific sources.
#'
#' @seealso
#' \code{\link{rawdata_cpia}} for country-level raw indicator values
#' \code{\link{group_standard_cpia}} for grouped CPIA scores
#' \code{\link{metadata_cpia}} for indicator definitions and metadata
#'
#' @examples
#' data(group_rawdata_cpia)
#' # Compare V-Dem rule of law scores across regions
#' group_rawdata_cpia |>
#'   dplyr::filter(group_type == "Region", year == 2020) |>
#'   dplyr::select(group, vdem_core_v2x_rule)
#'
#' # Track WGI Control of Corruption by income group over time
#' group_rawdata_cpia |>
#'   dplyr::filter(group_type == "Income Group", year >= 2015) |>
#'   dplyr::select(group, year, wb_wdi_cc_est) |>
#'   dplyr::arrange(year, group)
"group_rawdata_cpia"



