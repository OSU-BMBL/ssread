# Goal
# This document aims to filter out control-like cells in disease stage dataset 

# Why use Harmony for integration? 
# 1. Fast and best performances among 14 tools: A benchmark of batch-effect correction methods for single-cell RNA sequencing data
# 2. Seurat cannot handle 500k+ cells.

# Why use PCA+PCA for label transfering?
# 1. PCA results are better: https://docs.google.com/spreadsheets/d/1IJBT95FGIXBP05bNOUlFtKlM95aWaVUStCE9EpZ0rgA/edit
# 2. Seurat recommendation: FindTransferAnchors: We recommend using PCA when reference and query datasets are from scRNA-seq
# https://www.rdocumentation.org/packages/Seurat/versions/3.1.4/topics/FindTransferAnchors
# 3. PCA is much faster since it is already calculated.


options(future.globals.maxSize = 8000 * 1024^2)
suppressPackageStartupMessages(library(fst))
suppressPackageStartupMessages(library(Seurat))
suppressPackageStartupMessages(library(RColorBrewer))
suppressPackageStartupMessages(library(Polychrome))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(harmony))
suppressPackageStartupMessages(library(cowplot))
suppressPackageStartupMessages(library(future))
suppressPackageStartupMessages(library(clusterProfiler))
suppressPackageStartupMessages(library(org.Mm.eg.db))



## Do not use it, not working in OSC clusters
## Set multi-thread for Seurat
#plan("multiprocess", workers = 16)
#plan()


args <- commandArgs(TRUE)
wd <- args[1] # working directory
control_filename <- args[2] # rds seurat object
disease_filename <- args[3] # raw filename
disease_data_id <- args[4] # disease data ID

load_test_data <- function(){
  # This function is used for testing, set wd to your working directory
  rm(list = ls(all = TRUE))
  wd <- 'C:/Users/flyku/Desktop/script'
  control_filename <- "control_example.rds"
  disease_filename <- "example_disease.fst"
  disease_data_id <- "disease_example"
}


setwd(wd)
source("functions.R")

####### Load raw files
health.obj <- read_rds(control_filename)
disease_matrix <- read.fst(disease_filename)
rownames(disease_matrix) <- NULL

get_rowname_type <- function (l, db){
  res1 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "SYMBOL")),error = function(e) 0)
  res2 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "ENSEMBL")),error = function(e) 0)
  res3 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "ENTREZID")),error = function(e) 0)
  res4 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "ENSEMBLTRANS")),error = function(e) 0)
  result <- c("error","SYMBOL","ENSEMBL","ENTREZID","ENSEMBLTRANS")
  result_vec <- c(1,res1,res2,res3,res4)
  return(c(result[which.max(result_vec)],result_vec[which.max(result_vec)]))
  #write("No matched gene identifier found, please check your data.",file=paste(jobid,"_error.txt",sep=""),append=TRUE)
}

disease_gene_type <- get_rowname_type(disease_matrix$X1, org.Mm.eg.db)[1]

# Detect gene ID type, most dataset use gene symbols, in case some dataset use Ensembl IDs
if(disease_gene_type == "ENSEMBL") {
  all_match <- bitr(disease_matrix$X1, fromType="ENSEMBL", toType="SYMBOL", OrgDb="org.Mm.eg.db")
  expFile <- merge(disease_matrix,all_match,by.x=1,by.y=1)
  expFile <- na.omit(expFile)
  rownames(expFile) <- NULL
  expFile <- expFile[,-1]
  expFile <- aggregate(. ~ SYMBOL, expFile, sum)
  expFile <- column_to_rownames(expFile, var = "SYMBOL")
  disease.obj <- CreateSeuratObject(expFile, project = "all", min.cells = 5)
} else {
  disease_matrix <- column_to_rownames(disease_matrix, var = "X1")
  disease.obj <- CreateSeuratObject(disease_matrix, project = "all", min.cells = 5)
}

# Preview control object cell types
#Idents(health.obj) <- health.obj$predicted.id
#Plot.cluster2D(health.obj,reduction.method = "umap",pt_size = 0.1, txt = "Predicted.id")

####### Load dataset to Seurat object
all.obj <- merge(health.obj, disease.obj)
#all.obj <- CreateSeuratObject(counts = cbind(health.obj, disease_matrix), project = "all", min.cells = 5, meta.data = this_meta)
all.obj <- NormalizeData(all.obj, verbose = T)
all.obj <- FindVariableFeatures(all.obj, selection.method = "vst", nfeatures = 2000) 
all.obj <- ScaleData(all.obj, verbose = FALSE) 
all.obj <- RunPCA(all.obj, pc.genes = all.obj@var.genes, npcs = 25, verbose = T)
all.obj@meta.data$group <- c(rep("control", ncol(health.obj)), rep("disease", ncol(disease.obj)))
all.obj <- RunHarmony(all.obj, "group", plot_convergence = F)
all.obj <- RunUMAP(all.obj, reduction = "harmony", dims = 1:25)
all.obj <- FindNeighbors(all.obj, reduction = "harmony", dims = 1:25)
all.obj <- FindClusters(all.obj, resolution = 4)

####### Preview before integration
#options(repr.plot.height = 5, repr.plot.width = 12)
#p1 <- DimPlot(object = all.obj, reduction = "pca", pt.size = .1, group.by = "group")
#p2 <- VlnPlot(object = all.obj, features = "PC_1", group.by = "group", pt.size = .1)
#plot_grid(p1,p2)

####### Preview after integration
#options(repr.plot.height = 5, repr.plot.width = 12)
#p1 <- DimPlot(object = all.obj, reduction = "harmony", pt.size = .1, group.by = "group")
#p2 <- VlnPlot(object = all.obj, features = "harmony_1", group.by = "group", pt.size = .1)
#plot_grid(p1,p2)

####### Identify control atlas, control-like cells, and disease like cells (hypergeometric test)
clusters <- as.data.frame(all.obj$seurat_clusters)
clusters <- rownames_to_column(clusters, "cell")
colnames(clusters) <- c("cell","cluster")
groups <- as.data.frame(all.obj$group)
groups <- rownames_to_column(groups, "TAG")
colnames(groups) <- c("cell","group")

### five columns: cell name, seurat cluster,cell type, subcluster, condition
cluster_condition <- merge(clusters,groups, by = "cell", all = FALSE)   
#cluster_condition <- merge(cluster_condition,meta_file, by = "cell", all = FALSE)   

control_disease_like_result <- NULL
for (i in levels(all.obj$seurat_clusters)) {
  this_cluster <- cluster_condition[which(cluster_condition$cluster == i),]
  this_cluster_control <- this_cluster[which(this_cluster$group %in% "control"),]
  n_this_cluster_control <- length(this_cluster_control$cell)
  cluster_control.percentage <- n_this_cluster_control/length(this_cluster$cell)
  
  q = n_this_cluster_control - 1
  m = ncol(health.obj)
  n = ncol(disease.obj)
  k = length(this_cluster$cell)
  pval <- phyper(q,m,n,k,lower.tail=F)
  
  this_result <- data.frame(cluster=i, percent_control=cluster_control.percentage, pval=pval)
  control_disease_like_result <- rbind(control_disease_like_result,this_result)
  
} 

control_disease_like_result$pval <- p.adjust(control_disease_like_result$pval,"BH")
control_disease_like_result$group <- ifelse(control_disease_like_result$pval < 0.0001, "control_cluster", "disease_cluster")

### control_disease_like_result: cluster group table
#print(control_disease_like_result)  

####### Annotate control cluster, disease cluster
tmp_result_group <- all.obj$seurat_clusters
levels(tmp_result_group) <- control_disease_like_result$group
all.obj <- AddMetaData(all.obj,tmp_result_group, col.name = "cluster_group")

####### Annotate control cells percentage in each Seurat cluster
result_percent <- all.obj$seurat_clusters
levels(result_percent) <- paste(round(control_disease_like_result$percent_control, digits = 4), formatC(control_disease_like_result$pval, format = "e", digits = 4),sep = "-") 
all.obj <- AddMetaData(all.obj,result_percent, col.name = "healhy_cells_percent")


####### Annotate control cluster, disease cluster
combine_group_pathlogy <- paste(tmp_result_group,as.factor(all.obj$group))
names(combine_group_pathlogy) <- names(tmp_result_group)
combine_group_pathlogy <- as.factor(combine_group_pathlogy)
all.obj <- AddMetaData(all.obj,combine_group_pathlogy, col.name = "combine_group_pathlogy")

####### Annotate control-like, disease-like cells
associate_cells <- combine_group_pathlogy

#In most cases the cells split to these four groups:
#levels(associate_cells) <- c("control cells atlas","control cells atlas","control-like cells","control cells atlas")

# Sometimes the output don't have four levels, i.e, no cells are control-like, thus we need to iterate every case
new_levels <- vector()
for (i in levels(associate_cells)) {
  this_level <- ''
  if(i == "control_cluster control") {
    this_level <- "control cells atlas"
    new_levels <- append(new_levels, this_level)
    
  } else if (i == "control_cluster disease") {
    this_level <- "control-like cells"
    new_levels <- append(new_levels, this_level)
    
  } else if (i == "disease_cluster control") {
    this_level <- "control cells atlas"
    new_levels <- append(new_levels, this_level)
    
  } else if (i == "disease_cluster disease") {
    this_level <- "disease-like cells"
    new_levels <- append(new_levels, this_level)
    
  }
}

levels(associate_cells) <- new_levels

all.obj <- AddMetaData(all.obj,associate_cells, col.name = "associate_cells")

#Idents(all.obj) <- all.obj$group
#Plot.cluster2D(all.obj,reduction.method = "umap",pt_size = 0.1, txt = "orig.ident")
#
####### Visualize disease-like cells
#Idents(all.obj) <- all.obj$cell_type
#p1 <- Plot.cluster2D(all.obj,reduction.method = "umap",pt_size = 0.1, txt = "Provided cell type")
#
#Idents(all.obj) <- all.obj$seurat_clusters
#p2 <- Plot.cluster2D(all.obj,reduction.method = "umap",pt_size = 0.1, txt = "Seurat cluster")
#
#
#Idents(all.obj) <- all.obj$healhy_cells_percent
#p3 <- Plot.cluster2D(all.obj,reduction.method = "umap",pt_size = 0.1, txt = "control cells percentage-pvalue")
#
#Idents(all.obj) <- all.obj$cluster_group
#p4 <- Plot.cluster2D(all.obj,reduction.method = "umap",pt_size = 0.1, txt = "Associate group")
#
#plot_grid(p1,p2,p3,p4)
#Idents(all.obj) <- all.obj$combine_group_pathlogy
#Plot.cluster2D(all.obj,reduction.method = "umap",pt_size = 0.1, txt = "Associated group + data source")
#
#Idents(all.obj) <- all.obj$associate_cells
#Plot.cluster2D(all.obj,reduction.method = "umap",pt_size = 0.1, txt = "Associated cells")


Idents(all.obj) <- all.obj$associate_cells
dstage.obj <- subset(all.obj,subset = associate_cells == "disease-like cells")

dstage.obj <- FindVariableFeatures(dstage.obj, selection.method = "vst", nfeatures = 2000)
dstage.obj.gene <- rownames(dstage.obj)
dstage.obj <- ScaleData(dstage.obj, features = dstage.obj.gene)
dstage.obj <- RunPCA(dstage.obj, features = VariableFeatures(object = dstage.obj))
#dstage.obj <- RunLSI(dstage.obj, n = 50, scale.max = NULL, verbose = TRUE)
dstage.obj <- RunUMAP(dstage.obj, reduction = "pca", dims = 1:25)

#gc()
## FindTransferAnchors: We recommend using PCA when reference and query datasets are from scRNA-seq
transfer.anchors <- FindTransferAnchors(reference = health.obj, query = dstage.obj, features = VariableFeatures(object = health.obj), reduction = "pcaproject",verbose = TRUE)

if(nrow(transfer.anchors@anchors) > 30) {
  celltype.predictions <- TransferData(anchorset = transfer.anchors, refdata = health.obj$predicted.id, weight.reduction = dstage.obj[["pca"]],l2.norm = FALSE,dims = 1:25, k.weight = 30)
} else{
  celltype.predictions <- TransferData(anchorset = transfer.anchors, refdata = health.obj$predicted.id, weight.reduction = dstage.obj[["pca"]],l2.norm = FALSE,dims = 1:25, k.weight = (nrow(transfer.anchors@anchors)-1))
}

#celltype.predictions <- as.factor(dstage.obj$orig.ident)
#levels(celltype.predictions) <- 'Excitatory neurons'
#dstage.obj <- AddMetaData(dstage.obj, metadata = celltype.predictions, col.name = 'predicted.id')

dstage.obj <- AddMetaData(dstage.obj, metadata = celltype.predictions)

####### Visualize LSI predicted cell types (works for Mathy's data)
#Idents(dstage.obj) <- dstage.obj$cell_type
#p1 <- Plot.cluster2D(dstage.obj, reduction.method = "umap",pt_size = 0.2,txt = "Provided cell type")
#
#Idents(dstage.obj) <- dstage.obj$predicted.id
#p2 <- Plot.cluster2D(dstage.obj, reduction.method = "umap",pt_size = 0.2,txt = "Predicted cell type")
#library(igraph)
#igraph::compare(as.factor(dstage.obj$cell_type),as.factor(dstage.obj$predicted.id),method="adjusted.rand")
#plot_grid(p1,p2)

Idents(health.obj) <- health.obj$predicted.id
p1 <- Plot.cluster2D(health.obj, reduction.method = "umap",pt_size = 0.4,txt = "Control cell type")

Idents(dstage.obj) <- dstage.obj$predicted.id
p2 <- Plot.cluster2D(dstage.obj, reduction.method = "umap",pt_size = 0.4,txt = "Disease cell type")

png(paste(disease_data_id,"_transfer_umap.png",sep = ""),width=4000, height=2000,res=300)
plot_grid(p1,p2)
dev.off()

# Save Seurat object
Idents(dstage.obj) <- dstage.obj$predicted.id
saveRDS(dstage.obj, paste0(disease_data_id,".rds"))

# Save raw counts rather than normalized values
exp_data <- GetAssayData(object = dstage.obj,slot = "counts")

write.table(data.frame("Gene"=rownames(exp_data),exp_data,check.names = F),paste(disease_data_id,"_expr.txt",sep = ""), row.names = F,sep="\t",quote=FALSE)

# Save cell type labels
cell_info <- dstage.obj$predicted.id
cell_label <- cbind(colnames(dstage.obj),as.character(cell_info))
colnames(cell_label) <- c("cell_name","label")
cell_label <- cell_label[order(cell_label[,1]),]
write.table(cell_label,paste(disease_data_id,"_cell_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")


# Session Infomation
#sessionInfo()

