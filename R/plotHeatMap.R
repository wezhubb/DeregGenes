#'
#'
#'
#' @import pheatmap


plotHeatMap <- function(up, down, n = 20) {

  hminput = newTab[c(as.vector(up[1:n,1]), as.vector(down[1:n,1])),]
  tiff(file = "logFC_v2.tiff",
       width = 15,
       height = 20,
       units = "cm",
       compression = "lzw",
       bg = "white",
       res = 400)
  HM <- pheatmap(hminput,
                 display_numbers = TRUE,
                 fontsize_row = 10,
                 fontsize_col = 12,
                 color = colorRampPalette(c("green", "white","red"))(50),
                 cluster_cols = FALSE,
                 cluster_rows = FALSE, )
  return(HM)
}
