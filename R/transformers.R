#' @export
epoxy_style_wrap <- function(before = "**", after = "**") {
  function(text, envir) {
    paste0(before, glue::identity_transformer(text, envir), after)
  }
}

#' @export
epoxy_style_bold <- function() {
  epoxy_style_wrap("**", "**")
}

#' @export
epoxy_style_italic <- function() {
  epoxy_style_wrap("_", "_")
}

#' @export
epoxy_style_code <- function() {
  epoxy_style_wrap("`", "`")
}

#' @export
epoxy_style_collapse <- function() {
  function(text, envir) {
    collapse_fn <-
      switch(
        str_extract(text, "[*&|]$"),
        "*" = collapse("[*]$", sep = ", ", last = ""),
        "&" = collapse("[&]$", sep = ", ", last = " and "),
        "|" = collapse("[|]$", sep = ", ", last = " or "),
        glue::identity_transformer
      )
    collapse_fn(text, envir)
  }
}

collapse <- function(regexp = "[*]$", sep = ", ", width = Inf, last = "") {
  opts <- knitr::opts_current$get("glue_collapse") %||% list()
  opts$sep <- opts$sep %||% sep
  opts$width <- opts$width %||% width
  opts$last <- opts$last %||% last
  function(text, envir) {
    text <- sub(regexp, "", text)
    res <- glue::identity_transformer(text, envir)
    glue_collapse(res, sep = opts$sep, width = opts$width, last = opts$last)
  }
}