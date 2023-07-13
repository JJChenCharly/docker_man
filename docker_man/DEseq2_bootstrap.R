# parallel -j 50 time Rscript DEseq2_bootstrap.R {} 20 \
# ::: `seq 1 50` > boots_log.txt 2>&1

# installation ----
# options(repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
# install.packages("dplyr")


# if (!require("BiocManager", quietly = TRUE)){
#   install.packages("BiocManager")
# }

# apt-get install libpng-dev libxml2-dev libssl-dev libcurl4-openssl-dev

# BiocManager::install("DESeq2")

# preparation ----
library("DESeq2")

library(magrittr)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("No arguments provided.")
}

pid <- args[1]
boot_times <- args[2] %>% as.integer()

print(paste('pid --->', as.integer(pid)))
print(paste('Boot times ---->', boot_times))

base_path <- "/data/docker_qiime2_share_container_D/JH/"
save_path <- paste0(base_path, "boots/")

# Load your data ----
countdata_ <- read.csv(paste0(base_path, "table_to_use.csv"), 
                      header = TRUE, 
                      row.names = 1,
                      sep = '\t',
                      check.names=FALSE
                      )

coldata_ <- read.csv(paste0(base_path, "metadata_to_use.csv"),
                      header = TRUE,
                      # row.names = 1,
                      sep = '\t',
                      check.names=FALSE,
                     # stringsAsFactors = TRUE
                      )

# # grouping
coldata <- coldata_
colnames(coldata) <- c('sample','group')

for (x in rownames(coldata_)) {
  if (coldata_[x, "sample_type"] == 'Solid Tissue Normal') {
    coldata[x, "group"] <- 'control'
  } else {
    coldata[x, "group"] <- 'case'
  }
}

case_names <- coldata[coldata[, "group"] == 'case', "sample"]
control_names <- coldata[coldata[, "group"] == 'control', "sample"]

# up rounding ----
countdata <- apply(countdata_, 2, function(x) 2^x -1)
countdata <- countdata %>% round(0) %>% as.data.frame()

# filter 0 rows
countdata <- countdata[rowSums(countdata) != 0, ]

# random sampling for even comparison ----
colnames_to_rec <- c("baseMean", 
                     "log2FoldChange",
                     "lfcSE",
                     "stat",
                     "pvalue",
                     "padj"
                     )

res_rec <- matrix(nrow = length(rownames(countdata)
                                ),
                  ncol = length(colnames_to_rec)
                  ) %>% as_tibble()

res_rec <- res_rec %>% mutate_all(~ list(c()
                                         )
                                  )
  
# rownames(res_rec) <- rownames(countdata)
colnames(res_rec) <- colnames_to_rec
res_rec$sn <- rownames(countdata)


for (x in seq(1, boot_times)) {
  print(x)
  togo_names <- c(sample(case_names, 41), control_names)
  
  countdata_go <- countdata[, togo_names]
  # countdata_go <- countdata_go[rowSums(countdata_go) != 0, ]
  
  coldata_go <- coldata[coldata[, "sample"] %in% togo_names, ]
  
  dds <- DESeqDataSetFromMatrix(countData = countdata_go, 
                                colData = coldata_go, 
                                design = ~ group
                                )
  dds <- DESeq(dds)
  results <- results(dds, contrast = c("group", "case", "control")) %>% as.data.frame()
  results$sn <- rownames(results)
  
  for (y in rownames(res_rec)) {
    for (z in colnames_to_rec) {
      res_rec[y, z][[1]][[1]] <- c(res_rec[y, z][[1]][[1]], 
                                   results[res_rec[y, "sn"][[1]], z]
                                   )
    }
    
  }
}

saveRDS(res_rec, paste0(save_path, as.integer(pid), ".rds"))
