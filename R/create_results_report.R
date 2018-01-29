create_results_report <- function(results, Rmd.file, output.folder) {

  rmarkdown::render(Rmd.file, output_format = "all", output_dir = output.folder, envir = results)

}
