#' Saves one or multiple data.frame objects in an Excel sheet (one sheet per data.frame)
#'
#' Uses the package openxlsx to create the Excel file.
#'
#' @param sheets.data a single or list of data.frame objects to be written into the Excel file in separate sheets.
#'                    The name of the list element will be used as the sheet name.
#' @param file.name   file name of the Excel file to be created
#'
#' @return A openxlsx workbook object to allow further manipulations of the created Excel file
#'
save.raw.results.as.xlsx <- function(sheets.data, file.name) {

  nb_sheets <- length(sheets.data)

  stopifnot(nb_sheets >= 1)



  wb <- openxlsx::write.xlsx(sheets.data,
                             file.name,
                             asTable     = rep(TRUE, nb_sheets),
                             # sheetName   = c("Summary", "Details"),
                             withFilter  = rep(TRUE, nb_sheets),
                             colWidths   = "auto",
                             firstRow    = rep(TRUE, nb_sheets))

  # saveWorkbook(wb, file.name, overwrite = TRUE)   # wb could be used to modify the Excel sheets even more...

  return(wb)

}
