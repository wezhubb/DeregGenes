# Purpose: run shinny function
# Author: Wenzhu Ye
# Date: 12.07.2022
# Version: 1.0.0
# Bugs and Issues: N/A

#' Launch Shiny App for DeregGenes
#'
#' A function that launches the Shiny app for DeregGenes.
#' The shiny app permit to plot heatmap, and visualized analysis result of the
#' package.
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#' runDeregGenes()
#' }
#'
#' @export
#' @importFrom shiny runApp

runDeregGenes <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "DeregGenes")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
# [END]
