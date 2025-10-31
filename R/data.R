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
