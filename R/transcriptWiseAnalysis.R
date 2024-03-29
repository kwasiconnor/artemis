#' Analysis of raw transcript abundance estimates.
#' 
#' @param kexp        a KallistoExperiment or SummarizedExperiment-like object 
#' @param design      a design matrix w/contrast or coefficient to test in col2
#' @param p.cutoff    where to set the p-value cutoff for plots, etc. (0.05)
#' @param fold.cutoff where to set the log2-FC cutoff for plots, etc. (1 == 2x)
#' @param coef        which column of the design matrix to test on (2nd)
#' @param tx_biotype  optionally restrict to one or more tx_biotype classes 
#' @param gene_biotype optionally restrict to one or more gene_biotype classes 
#' @param biotype_class optionally restrict to one or more biotype_class ...es
#'
#' @import edgeR 
#' @import limma
#'
#' @export
transcriptWiseAnalysis <- function(kexp, design, p.cutoff=0.05, fold.cutoff=1, 
                                   coef=2, tx_biotype=NULL, gene_biotype=NULL,
                                   biotype_class=NULL, ...){ 

  ## this is really only meant for a KallistoExperiment
  if (!is(kexp, "KallistoExperiment")) {
    message("This function is optimized for KallistoExperiment objects.")
    message("It may work for other classes, but we make no guarantees.")
  }
  
  if (all(sapply(c(tx_biotype, gene_biotype, biotype_class), is.null))) {
    res <- fitTranscripts(kexp, design, read.cutoff)
    top <- topTable(fit, coef=coef, p=p.cutoff, n=nrow(assay))
  } else {
    keep <- seq_len(nrow(kexp))
    if (!is.null(biotype_class)) {
      keep <- intersect(keep, which(mcols(kexp)$biotype_class == biotype_class))
    }
    if (!is.null(gene_biotype)) {
      keep <- intersect(keep, which(mcols(kexp)$gene_biotype == gene_biotype))
    }
    if (!is.null(tx_biotype)) {
      keep <- intersect(keep, which(mcols(kexp)$tx_biotype == tx_biotype))
    }
    res <- fitTranscripts(kexp[keep, ], design, read.cutoff)
    top <- topTable(fit, coef=coef, p=p.cutoff, n=length(keep))
  }
 
  res$top <- top[ abs(top$logFC) >= fold.cutoff, ] ## per SEQC recommendations
  res$biotype_class <- biotype_class
  res$gene_biotype <- gene_biotype
  res$tx_biotype <- tx_biotype
  return(res)

}
