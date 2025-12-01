#' Add CPIA Variable Metadata to a Dataset
#'
#' Attaches standardized CPIA metadata attributes to a dataset.
#' This function is designed to tag each CPIA-related dataset with descriptive information
#' such as the question, subquestion, variable source, and indicator definitions.
#' It ensures that all datasets contributing to the CPIA composite data system
#' carry consistent metadata attributes for traceability and documentation.
#'
#' @param df A `data.frame` to which metadata attributes will be added.
#' @param indicator A `character` string identifying the indicator code
#'   (e.g., `"bs_bti_q15_1"` or `"vdem_core_v2clacjstm"`).
#' @param variable the cpia criteria specific question (e.g, 12a-c, 15b, 16a etc)
#' @param source A `character` string indicating the data source
#'   (e.g., `"CLIAR"`, `"V-Dem"`, `"IBP"`).
#' @param var_name A `character` string providing the variable’s short name
#'   (e.g., `"Efficient use of assets"`, `"Open budget index"`).
#' @param var_description A `character` string giving a detailed explanation
#'   of what the variable measures.
#' @param var_description_short A concise summary of the variable’s meaning
#'   suitable for dashboards or reports.
#' @param theoretical_range the theoretical range for the dataset e.g (c(0, 100))
#'
#' @return The input `data.frame` with the following additional attributes:
#' \describe{
#'   \item{`indicator`}{Indicator code used to identify the data source.}
#'   \item{`variable`}{CPIA variable code corresponding to a question or subquestion.}
#'   \item{`source`}{Source organization or dataset from which the variable is derived.}
#'   \item{`var_name`}{Short variable label.}
#'   \item{`var_description`}{Full variable definition or interpretation.}
#'   \item{`var_description_short`}{Concise summary of the variable meaning.}
#'   \item{`theoretical_range`}{The range of the raw}
#' }
#'
#' @examples
#' df <- data.frame(value = rnorm(5))
#' df_meta <- add_cpiametadata(
#'   df,
#'   indicator = "bs_bti_q15_1",
#'   variable = "q15a",
#'   source = "CLIAR",
#'   var_name = "Efficient use of assets",
#'   var_description = "To what extent does the government make efficient use of assets?",
#'   var_description_short = "Measures the extent to which the government makes efficient use of assets."
#'   theoretical_range = c(0, 1)
#' )
#' attributes(df_meta)
#'
#' @export
add_cpiametadata <- function(df,
                             indicator,
                             variable,
                             source,
                             var_name,
                             var_description,
                             var_description_short,
                             theoretical_range) {

  attr(df, "indicator") <- indicator
  attr(df, "variable") <- variable
  attr(df, "source") <- source
  attr(df, "var_name") <- var_name
  attr(df, "var_description") <- var_description
  attr(df, "var_description_short") <- var_description_short
  attr(df, "theoretical_range") <- theoretical_range

  return(df)

}

#' Combine dataset metadata attributes into a tibble
#'
#' @description
#' Extracts key metadata attributes stored in a data frame (such as variable names,
#' sources, descriptions, and theoretical ranges) and combines them into a structured
#' tibble. This function is useful for datasets that store variable-level metadata
#' as attributes, enabling easy inspection, export, or documentation.
#'
#' @param df A data frame or tibble that contains metadata attributes.
#'   The following attributes are expected (if present):
#'   - `indicator`: Unique indicator codes or variable identifiers.
#'   - `variable`: Internal variable mappings or CPIA question codes.
#'   - `source`: Data source(s) for each indicator.
#'   - `var_name`: Full descriptive name of each indicator.
#'   - `var_description`: Detailed description of the indicator.
#'   - `var_description_short`: Shortened description for compact presentation.
#'   - `theoretical_range`: Theoretical range of indicator values.
#'
#' @return A tibble with one row per indicator and seven columns:
#'   `indicator`, `variable`, `source`, `var_name`,
#'   `var_description`, `var_description_short`, and `theoretical_range`.
#'   If some attributes are missing, the corresponding columns may contain `NA`.
#'
#' @examples
#' # Example: Create a dummy data frame with metadata attributes
#' df <- tibble::tibble(x = 1:3)
#' attr(df, "indicator") <- c("ind_1", "ind_2", "ind_3")
#' attr(df, "variable") <- c("q12b", "q16a", "q16c")
#' attr(df, "source") <- rep("World Governance Indicators", 3)
#' attr(df, "var_name") <- c("Regulatory Quality", "Control of Corruption", "Voice and Accountability")
#' attr(df, "var_description") <- c(
#'   "Ability of government to implement sound policies",
#'   "Extent to which public power is exercised for private gain",
#'   "Extent of citizen participation and freedom of expression"
#' )
#' attr(df, "var_description_short") <- c(
#'   "Quality of government regulation",
#'   "Control of corruption",
#'   "Voice and accountability"
#' )
#' attr(df, "theoretical_range") <- rep("c(-2.5, 2.5)", 3)
#'
#' # Combine metadata attributes into a tibble
#' combine_metadata(df)
#'
#' @seealso [attributes()], [tibble::as_tibble()], [purrr::map()]
#'
#' @export
combine_metadata <- function(df) {
  attr_obj <- attributes(df)

  meta_tbl <-
    attr_obj[c(
      "indicator",
      "variable",
      "source",
      "var_name",
      "var_description",
      "var_description_short",
      "theoretical_range"
    )] |>
    purrr::map(~as.character(.x)) |>
    tibble::as_tibble()

  return(meta_tbl)
}














