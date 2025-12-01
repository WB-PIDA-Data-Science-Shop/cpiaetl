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


#' Country Policy and Institutional Assessment (CPIA) Data
#'
#' A dataset containing CPIA-related governance indicators by country and year.
#' The data integrates country-level CPIA sub-criteria (questions 12, 15, and 16)
#' derived from the CPIA framework and associated static indicators used to
#' generate comparable scores across countries.
#'
#' @format A tibble with 2,808 rows and 17 variables:
#' \describe{
#' \item{country_code}{Three-letter ISO3 country code or regional aggregate code.}
#' \item{country_name}{Full name of the country or region.}
#' \item{country_group}{Numeric indicator for aggregation level:
#' \code{0} = country, \code{1} = regional aggregate.}
#' \item{income_group}{World Bank income classification (e.g., "Low income", "Upper middle income").}
#' \item{region}{World Bank regional classification.}
#' \item{orig_year}{Original year of the underlying static indicator source, if different from CPIA reference year.}
#' \item{year}{Reference year for the CPIA data. i.e. orig_year + 1}
#' \item{q12a}{CPIA criterion 12a score (Public sector management quality).}
#' \item{q12b}{CPIA criterion 12b score (Public administration effectiveness).}
#' \item{q12c}{CPIA criterion 12c score (Revenue mobilization).}
#' \item{q15a}{CPIA criterion 15a score (Transparency and accountability mechanisms).}
#' \item{q15b}{CPIA criterion 15b score (Public procurement systems).}
#' \item{q15c}{CPIA criterion 15c score (Audit and oversight institutions).}
#' \item{q16a}{CPIA criterion 16a score (Property rights and rule-based governance).}
#' \item{q16b}{CPIA criterion 16b score (Quality of legal and judicial systems).}
#' \item{q16c}{CPIA criterion 16c score (Corruption control).}
#' \item{q16d}{CPIA criterion 16d score (Conflict of interest and accountability in the executive).}
#' }
#'
#' @details
#' The CPIA dataset supports the generation of governance scores under the
#' World Bank’s Country Policy and Institutional Assessment framework. It combines
#' country-level and regional aggregates with derived indicator scores for the
#' Governance cluster (Questions 12, 15, and 16). Missing values (\code{NaN})
#' indicate unavailable data or country-years not assessed.
#'
#' @source
#' World Bank Governance Global Practice, Public Institutions Data and Analytics Program (2025).
#'
#' @examples
#' data(cpia)
"cpia"


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


