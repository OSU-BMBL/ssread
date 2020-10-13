# Goal
# This document aims to build healthy cells atlas Seurat object from count matrix file, 
options(check.names=FALSE)
options(future.globals.maxSize = 8000 * 1024^2)
suppressPackageStartupMessages(library(fst))
suppressPackageStartupMessages(library(Seurat))
suppressPackageStartupMessages(library(RColorBrewer))
suppressPackageStartupMessages(library(Polychrome))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(future))
suppressPackageStartupMessages(library(SCINA))
suppressPackageStartupMessages(library(preprocessCore))
suppressPackageStartupMessages(library(cowplot))


## Do not use it, not working in OSC clusters
## Set multi-thread for Seurat
#plan("multiprocess", workers = 16)
#plan()


args <- commandArgs(TRUE)
wd <- args[1] # working directory
expr_file <- args[2] # raw user filename
data_id <- args[3] # unique data id

load_test_data <- function(){
  # This function is used for testing
  rm(list = ls(all = TRUE))
  wd <- "/fs/scratch/PAS1475/ad/input"
  expr_file = "M-H-subventricular_zone_and_hippocampus-Female-7m_001.fst"
  data_id <- 'AD01001'
}

source("/fs/scratch/PAS1475/ad/code/functions.R")
signatures  <- preprocess.signatures('/fs/scratch/PAS1475/ad/code/custom_marker.csv')
cell_type_name <- c('Astrocytes', 'Endothelial cells','Excitatory neurons','Inhibitory neurons','Microglia','Oligodendrocytes','Oligodendrocyte precursor cells','Pericytes')
names(signatures) <- cell_type_name

setwd(wd)
expr_matrix <- read.fst(expr_file)
rownames(expr_matrix) <- NULL
expr_matrix <- column_to_rownames(expr_matrix, var = "X1")

health.obj <- CreateSeuratObject(counts = expr_matrix, project = "healthy", min.cells = 3, min.features = 200)
health.obj <- FindVariableFeatures(health.obj, selection.method = "vst", nfeatures = 2000)
health.all.genes <- rownames(health.obj)
health.obj <- ScaleData(health.obj, features = health.all.genes)
health.obj <- RunPCA(health.obj, features = VariableFeatures(object = health.obj))

health.obj <- FindNeighbors(health.obj, dims = 1:25)
health.obj <- Seurat::RunUMAP(health.obj, dims = 1:25)
if(ncol(health.obj) < 2000){
  health.obj <- Seurat::FindClusters(health.obj, resolution = 1.5)
} else if (ncol(health.obj) < 6000){
  health.obj <- Seurat::FindClusters(health.obj, resolution = 1.2)
} else {
  health.obj <- Seurat::FindClusters(health.obj, resolution = 0.8)
}

Idents(health.obj) <- health.obj$seurat_clusters
health_markers <- FindAllMarkers(health.obj, return.thresh = 0.05, only.pos = T)

cell_type_result <- data.frame()
for (i in 1:length(levels(Idents(health.obj)))) {
  this_cell_type <- data.frame()
  for (j in 1:8) {
    this_marker <-  health_markers[health_markers$cluster == (i-1) & health_markers$p_val_adj < 0.05,7]
    this_overlap <- length(which(tolower(unlist(signatures[j])) %in% tolower(this_marker)))
    
    tmp_cell_type <- data.frame(ct = names(signatures[j]),overlap = this_overlap)
    this_cell_type <- rbind(this_cell_type, tmp_cell_type)
  }
  cell_type_result <- rbind(cell_type_result,this_cell_type[which.max(this_cell_type$overlap),])
}

marker_cell_type <- health.obj$seurat_clusters
levels(marker_cell_type) <- cell_type_result$ct
health.obj <- AddMetaData(health.obj, marker_cell_type, col.name = 'marker_cell_type')

Idents(health.obj) <- health.obj$marker_cell_type
p1 <- Plot.cluster2D(health.obj,reduction.method = "umap",pt_size = 0.5, txt = "marker_cell_type")


exp <- as.matrix(GetAssayData(object = health.obj[['RNA']],slot="data"))
exp <- log1p(exp)
exp[] <- normalize.quantiles(exp)
rownames(exp) <- toupper(rownames(exp))

keep_scina_cell_type <- as.numeric(which(!sapply(signatures, function(x){
  all(!x %in% rownames(exp))
})))
signatures <- signatures[keep_scina_cell_type]

results <- SCINA(exp, signatures, max_iter = 1000, convergence_n = 20, 
                convergence_rate = 0.99, sensitivity_cutoff = 0.9, rm_overlap=F, allow_unknown=T, log_file='SCINA.log')
health.obj <- AddMetaData(health.obj, as.factor(results$cell_labels), col.name = 'scina_cell_type')

Idents(health.obj) <- health.obj$seurat_clusters
annotate_cell_type <- as.factor(health.obj$seurat_clusters)
annotate_cell_type_name <- vector()
# iterate i as all seurat cell clusters index
for (i in 1:length(levels(Idents(health.obj)))) {
  this_cluster_cells <- WhichCells(health.obj, idents = levels(Idents(health.obj))[i])
  this_scina_obj <- health.obj[,this_cluster_cells]
  Idents(this_scina_obj) <- this_scina_obj$scina_cell_type
  # select the largest overlapped cell type name as annotation of this seurat cluster, the unknown is ignored
  if('unknown' %in% levels(Idents(this_scina_obj))) {
    scina_obj_ident_length <- length(levels(Idents(this_scina_obj))) - 1
    max_ct <- names(which.max(table(Idents(this_scina_obj))[1:scina_obj_ident_length]))
  } else {
    scina_obj_ident_length <- length(levels(Idents(this_scina_obj)))
    max_ct <- names(which.max(table(Idents(this_scina_obj))[1:scina_obj_ident_length]))
  }
  annotate_cell_type_name <- c(annotate_cell_type_name,max_ct)
}


Idents(health.obj) <- health.obj$seurat_clusters
p2 <- Plot.cluster2D(health.obj,reduction.method = "umap",pt_size = 0.5, txt = "Predict cluster")
Idents(health.obj) <- health.obj$scina_cell_type
p3 <- Plot.cluster2D(health.obj,reduction.method = "umap",pt_size = 0.5, txt = "scina_cell_type")

levels(annotate_cell_type) <- annotate_cell_type_name
health.obj <- AddMetaData(health.obj, as.factor(annotate_cell_type), col.name = 'predicted.id')
Idents(health.obj) <- health.obj$predicted.id
p4 <- Plot.cluster2D(health.obj,reduction.method = "umap",pt_size = 0.5, txt = "predicted.id")

png(paste(data_id,"_umap.png",sep = ""),width=3000, height=1500,res = 300)
plot_grid(p4)
dev.off()

saveRDS(health.obj, file = paste0(data_id,'.rds'))
exp_data <- GetAssayData(object = health.obj,slot = "data")

write.table(data.frame("Gene"=rownames(exp_data),exp_data,check.names = F),paste(data_id,"_expr.txt",sep = ""), row.names = F,sep="\t",quote=FALSE)

cell_info <- health.obj$predicted.id
cell_label <- cbind(colnames(health.obj),as.character(cell_info))
colnames(cell_label) <- c("cell_name","label")
cell_label <- cell_label[order(cell_label[,1]),]
write.table(cell_label,paste(data_id,"_cell_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")

# Session Infomation
sessionInfo()

################# Visualize results

#Idents(health.obj) <- health.obj$annotate_cell_type
#p3 <- Plot.cluster2D(health.obj,reduction.method = "umap",pt_size = 0.1, txt = "predicted.id")

#meta_file <- read.fst(label_file)
#rownames(meta_file) <- NULL
#meta_file <- column_to_rownames(meta_file, var = "cell")
#this_meta <- meta_file[colnames(health.obj),]
#healthy_meta <- meta_file[colnames(health.obj),]
#
#sub.obj <- health.obj[,rownames(na.omit(this_meta))]
#Idents(sub.obj) <- sub.obj$annotate_cell_type
#pr2 <- Plot.cluster2D(sub.obj,reduction.method = "umap",pt_size = 0.1, txt = "annotate_cell_type")
#sub.obj <- AddMetaData(sub.obj, as.factor(this_meta[colnames(sub.obj),1]), col.name = 'ref_cell_type')
#Idents(sub.obj) <- sub.obj$ref_cell_type
#pr1 <- Plot.cluster2D(sub.obj,reduction.method = "umap",pt_size = 0.1, txt = "reference_cell_type")
#plot_grid(pr1,pr2)


