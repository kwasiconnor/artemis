#' run kallisto with fastq.gz files on a freshly generated or existing index
#' 
#' @param sampleDir   character, subdirectory for sample's FASTQ files 
#' @param indexName   character or NULL, optional name of the index
#' @param fastaPath   character, where FASTA files are underneath (".")
#' @param fastaFiles  character vector of FASTA transcriptomes, or NULL
#' @param fastqPath   character, where sampleDir is located under (".")
#' @param outputPath  character, output in outputPath/sampleDir (".")
#' @param bootstraps  integer, how many bootstrap replicates to run? (100)
#' @param threads     integer, how many threads to use for boot/quant? (4)
#' @param bias        boolean, perform bias correction? (TRUE)
#' @param pseudobam   boolean, produce pseudoBAM output? (FALSE)
#' @param singleEnd   boolean, produce single end quantification, mean and std.dev required
#' @param lengthMean  integer, length mean used only for single end quantification
#' @param lengthDev   integer, length std used only for single end quantification
#' @param collapse    string to name multi-FASTA indices ("_mergedWith_")
#' @param extension   string,  to pass the extension into pairFastqFiles()
#' @export
runKallisto <- function(sampleDir, 
                        indexName=NULL, 
                        fastaPath=".",
                        fastaFiles=NULL,
                        fastqPath=".",
                        outputPath=".",
                        bootstraps=100,
                        threads=4,
                        bias=TRUE,
                        pseudobam=FALSE,
                        singleEnd=FALSE,
                        lengthMean=150,
                        lengthDev=0.001,
                        collapse="_mergedWith_",
                        extension=".fastq.gz", 
                        ...) {

  if (is.null(indexName) && is.null(fastaFiles)) {
    stop("Exactly one of indexName or fastaFiles must be non-null to run.")
  }
  if (is.list(indexName) && "indexName" %in% names(indexName)) {
    fastaPath <- indexName$fastaPath
    indexName <- indexName$indexName
  }
  if (is.null(outputPath)) {
    outputPath <- sampleDir
  }

  ## create an index if needed 
  if (is.null(indexName)) {
    message("Creating index from ", paste(fastaFiles, collapse=" & "), "...")
    res <- indexKallisto(fastaFiles, fastaPath=fastaPath, collapse=collapse)
    message("Created index ", res$indexName, " in ", res$fastaPath, "...")
    indexFile <- paste0(fastaPath, "/", res$indexName)
  } else { 
    indexFile <- paste0(fastaPath, "/", indexName)
  }
  
  ## rack up all the paired FASTQ files for a sample 
  samplePath <- paste0(fastqPath, "/", sampleDir)
  if(singleEnd==FALSE){
  sampleFiles <- paste(pairFastqFiles(samplePath, extension=extension), collapse=" ")
   }#pair the fastq for paired end only
  if(singleEnd==TRUE){
  sampleFiles<-paste0(samplePath,"/",dir(samplePath))
  }
  outputDir <- paste0(outputPath, "/", sampleDir)
  if (!dir.exists(outputPath)) dir.create(outputPath)

  ## run kallisto quant without pseudoBAM output
  command <- paste("kallisto quant", 
                   "-i", indexFile, 
                   "-o", outputDir, 
                   "-b", bootstraps, 
                   "-t", threads, 
                   ifelse(bias, "--bias", ""), 
                   ifelse(pseudobam, paste0("--pseudobam ",sampleFiles," | samtools view -Sb - > ",outputPath,"/",sampleDir,".bam"),sampleFiles),
                    ifelse(singleEnd,paste0("--single -l ", lengthMean," -s ", lengthDev," ",sampleFiles),"" ))
  retval <- system(command)
  res <- list(command=command, outputPath=outputPath, bootstraps=bootstraps)
  if (retval == 0 && file.exists(paste0(outputDir, "/abundance.h5"))) {
    return(res)
  } else { 
    stop(paste("Quantification failed; command",command,"did not produce bam file"))
  }
   


}#}}} main 
