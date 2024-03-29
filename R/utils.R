#' @importFrom magrittr %>%
#' @importFrom stringr str_replace_all
#' @importFrom stringi stri_trans_general
#' @importFrom purrr
#' @import dplyr
#' @import RSelenium

#' @title Format name to url's pattern
#' @param name Name to format
#' @return Formated name
.format_name <- function(name) {
  name <- name %>%
    tolower() %>%
    str_replace_all("!", "exclamationmark") %>%
    str_replace_all("\\&", "and") %>%
    str_replace_all("[:punct:]", "") %>%
    str_replace_all("exclamationmark", "!") %>%
    str_replace_all(" ", "-") %>%
    stri_trans_general("Latin-ASCII")
  return(name)
}
