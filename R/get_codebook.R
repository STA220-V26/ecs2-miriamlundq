
#gives us a codebook describing the datasets and their variables 
get_codebook <- function() {
  tabs <-
    "https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary" |>
    rvest::read_html() |>
    rvest::html_elements("table") |>
    rvest::html_table()

  tab_desc <- tabs[[1]]
  tab_vars <- setNames(tabs[-1], tab_desc$File)

  cb <-
    suppressMessages(
      dplyr::bind_rows(tab_vars, .id = "file") |>
        janitor::clean_names() |>
        dplyr::rename(key = x1) |>
        dplyr::mutate(dplyr::across(dplyr::where(is.character), \(x) {
          dplyr::na_if(x, "")
        })) |>
        dplyr::mutate(
          column_name = tolower(column_name), #makes the variables to lowercase
          required = as.logical(required),
          key = factor(key, c("🔑", "🗝️"), c("primary", "foreign"))
        ) |>
        data.table::setDT()
    )
  cb
}
