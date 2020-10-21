# Goal
# This document aims to run Seurat analysis workflow, and export tables in scREAD database format.

# Important!! Install MAST first
#BiocManager::install("MAST")

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
suppressPackageStartupMessages(library(MAST))

## Do not use it, not working in OSC clusters
## Set multi-thread for Seurat
#plan("multiprocess", workers = 16)
#plan()

args <- commandArgs(TRUE)
wd <- args[1] # working directory
a_data_id <- args[2] # raw user filename
b_data_id <- args[3] # raw user filename

load_test_data <- function(){
  # This function is used for testing, set wd to your working directory
  rm(list = ls(all = TRUE))
  wd <- 'C:/Users/flyku/Desktop/script'
  #A is usually disease object, B is healthy (control) object
  a_data_id <- "disease_example"
  b_data_id <- "control_example"
  
}

setwd(wd)
a_expr_file <- paste0(a_data_id,".rds")
b_expr_file <- paste0(b_data_id,".rds")

####### Load raw files
a.obj <- readRDS(a_expr_file)
b.obj <- readRDS(b_expr_file)

# Altough all objects should have already been normalized
a.obj <- NormalizeData(a.obj)
b.obj <- NormalizeData(b.obj)

a_total_ct <- length(levels(as.factor(a.obj$predicted.id)))
b_total_ct <- length(levels(as.factor(b.obj$predicted.id)))

dir.create("de",showWarnings = F)
dir.create("dimension",showWarnings = F)
dir.create("subcluster_dimension",showWarnings = F)
####### Find Cell-type-specific DE genes for data A and B (if result not exist)

## Cell type specific DE genes on A dataset
this_out_name <- paste0("de/",a_data_id,"_de_cts.csv")
if(!file.exists(this_out_name) && length(levels(as.factor(a.obj$predicted.id))) > 1) {
  Idents(a.obj) <- a.obj$predicted.id
  cts_markers <- FindAllMarkers(a.obj, test.use = "MAST")
  if(nrow(cts_markers) >1){
    cts_markers["a_data_id"] <- a_data_id
    cts_markers["b_data_id"] <- a_data_id
    tmp_cluster <- cts_markers$cluster
    levels(tmp_cluster)[levels(tmp_cluster)=="Oligodendrocyte precursor cells"] <- "opc"
    cts_markers["ct"] <- tolower(substr(tmp_cluster, 1, 3))
    cts_markers["type"] <- "cell_type_specific"
    write.csv(cts_markers,this_out_name, row.names = F)
  }
}


## Cell type specific DE genes on B dataset
this_out_name <- paste0("de/",b_data_id,"_de_cts.csv")
if(!file.exists(this_out_name) && length(levels(as.factor(b.obj$predicted.id))) > 1) {
  Idents(b.obj) <- b.obj$predicted.id
  cts_markers <- FindAllMarkers(b.obj, test.use = "MAST")
  if(nrow(cts_markers) >1){
    cts_markers["a_data_id"] <- b_data_id
    cts_markers["b_data_id"] <- b_data_id
    tmp_cluster <- cts_markers$cluster
    levels(tmp_cluster)[levels(tmp_cluster)=="Oligodendrocyte precursor cells"] <- "opc"
    cts_markers["ct"] <- tolower(substr(tmp_cluster, 1, 3))
    cts_markers["type"] <- "cell_type_specific"
    write.csv(cts_markers,this_out_name, row.names = F)
  }
}


## subcluster analysis - A data 

for(i in 1:a_total_ct){
  # this_ct is the cell type name
  this_ct <- levels(as.factor(a.obj$predicted.id))[i]
  if(this_ct == "Oligodendrocyte precursor cells") {
    abbr_this_ct <- "opc"
  } else {
    abbr_this_ct <- tolower(substr(this_ct, 1, 3))
  }
  this_out_name <- paste0("de/",a_data_id,"_de_subcluster_",abbr_this_ct,".csv")
  this_subcluster_dimension_name <- paste0("subcluster_dimension/",a_data_id,"_dimension_subcluster_",abbr_this_ct,".csv")
  
  if(!file.exists(this_out_name) | !file.exists(this_subcluster_dimension_name)) {
    this_obj <- subset(a.obj, subset = predicted.id == this_ct)
    # If cells too few, PCA will fail
    
    if(ncol(this_obj) < 50) {
      dim_to_use <- ncol(this_obj) - 1
      pc_to_use <- ncol(this_obj) - 1
    } else {
      dim_to_use <- 25
      pc_to_use <- 50
    }
    if(ncol(this_obj) > 5) {
      this_obj <- NormalizeData(this_obj, normalization.method = "LogNormalize", scale.factor = 10000)
      this_obj <- Seurat::FindVariableFeatures(this_obj, selection.method = "vst", nfeatures = 2000)
      this_obj <- Seurat::ScaleData(this_obj, features = rownames(this_obj))
      this_obj <- Seurat::RunPCA(this_obj, features = Seurat::VariableFeatures(object = this_obj), npcs = pc_to_use)
      this_obj <- Seurat::FindNeighbors(this_obj, dims = 1:dim_to_use)
      this_obj <- tryCatch(Seurat::RunUMAP(this_obj, dims = 1:dim_to_use), error=function(e) this_obj)
      this_obj <- Seurat::FindClusters(this_obj, resolution = 0.8)
      
      # Try to increase resolution
      if (length(levels(this_obj$seurat_clusters)) <= 1) {
        this_obj <- Seurat::FindClusters(this_obj, resolution = 1)
      }
      
      # Only proceed if sub-cluster is found, else create an empty table (will be useful in MYSQL)
      if (length(levels(this_obj$seurat_clusters)) <= 1) {
        this_markers <- data.frame(p_val=1,avg_logFC=0,pct.1=0,pct.2=0,p_val_adj=1,cluster=0,gene=0)
      } else {
        this_markers <- Seurat::FindAllMarkers(this_obj, test.use = "MAST")
      }
      this_markers["a_data_id"] <- a_data_id
      this_markers["b_data_id"] <- a_data_id
      this_markers["ct"] <- abbr_this_ct
      this_markers["type"] <- "subcluster"
      write.csv(this_markers,this_out_name, row.names = F,quote = F)
      
      #DefaultAssay(this_obj)
      #FeaturePlot(this_obj, features = "LINC00982")
      #DimPlot(this_obj,reduction = "umap")
      
      this_umap_df <- Embeddings(object = this_obj[['umap']])
      this_pca_df <- Embeddings(object = this_obj[['pca']])[,1:3]
      this_sub_cluster_df <- as.matrix(paste0(this_obj$seurat_clusters))
      dimension_df <- as.data.frame(cbind(this_sub_cluster_df,this_umap_df,this_pca_df))
      dimension_df <- rownames_to_column(dimension_df, "cell_name")
      dimension_df['cell_type'] <- this_ct
      dimension_df['data_id'] <- a_data_id
      colnames(dimension_df)[2] <- "subcluster"
      write.csv(dimension_df,this_subcluster_dimension_name, row.names = F,quote = F)
    }
  }
}


## subcluster analysis - B data 
for(i in 1:b_total_ct){
  # this_ct is the cell type name
  this_ct <- levels(as.factor(b.obj$predicted.id))[i]
  if(this_ct == "Oligodendrocyte precursor cells") {
    abbr_this_ct <- "opc"
  } else {
    abbr_this_ct <- tolower(substr(this_ct, 1, 3))
  }
  this_out_name <- paste0("de/",b_data_id,"_de_subcluster_",abbr_this_ct,".csv")
  this_subcluster_dimension_name <- paste0("subcluster_dimension/",b_data_id,"_dimension_subcluster_",abbr_this_ct,".csv")
  
  if(!file.exists(this_out_name) || !file.exists(this_subcluster_dimension_name)) {
    this_obj <- subset(b.obj, subset = predicted.id == this_ct)
    # If cells too few, PCA will fail
    if(ncol(this_obj) < 50) {
      dim_to_use <- ncol(this_obj) - 1
      pc_to_use <- ncol(this_obj) - 1
    } else {
      dim_to_use <- 25
      pc_to_use <- 50
    }
    
    if(ncol(this_obj) > 5) {
      
      this_obj <- NormalizeData(this_obj, normalization.method = "LogNormalize", scale.factor = 10000)
      this_obj <- Seurat::FindVariableFeatures(this_obj, selection.method = "vst", nfeatures = 2000)
      this_obj <- Seurat::ScaleData(this_obj, features = rownames(this_obj))
      this_obj <- Seurat::RunPCA(this_obj, features = Seurat::VariableFeatures(object = this_obj), npcs = pc_to_use)
      this_obj <- Seurat::FindNeighbors(this_obj, dims = 1:dim_to_use)
      this_obj <- tryCatch(Seurat::RunUMAP(this_obj, dims = 1:dim_to_use), error=function(e) this_obj)
      this_obj <- Seurat::FindClusters(this_obj, resolution = 0.8)
      
      # Try to increase resolution
      if (length(levels(this_obj$seurat_clusters)) <= 1) {
        this_obj <- Seurat::FindClusters(this_obj, resolution = 1)
      }
      
      # Only proceed if sub-cluster is found, else create an empty table (will be useful in MYSQL)
      if (length(levels(this_obj$seurat_clusters)) <= 1) {
        this_markers <- data.frame(p_val=1,avg_logFC=0,pct.1=0,pct.2=0,p_val_adj=1,cluster=0,gene=0)
      } else {
        this_markers <- Seurat::FindAllMarkers(this_obj, test.use = "MAST")
      }
      this_markers["a_data_id"] <- b_data_id
      this_markers["b_data_id"] <- b_data_id
      this_markers["ct"] <- abbr_this_ct
      this_markers["type"] <- "subcluster"
      write.csv(this_markers,this_out_name, row.names = F,quote = F)
      
      #DefaultAssay(this_obj)
      #FeaturePlot(this_obj, features = "LINC00982")
      #DimPlot(this_obj,reduction = "umap")
      
      this_umap_df <- Embeddings(object = this_obj[['umap']])
      this_pca_df <- Embeddings(object = this_obj[['pca']])[,1:3]
      this_sub_cluster_df <- as.matrix(paste0(this_obj$seurat_clusters))
      dimension_df <- as.data.frame(cbind(this_sub_cluster_df,this_umap_df,this_pca_df))
      dimension_df <- rownames_to_column(dimension_df, "cell_name")
      dimension_df['cell_type'] <- this_ct
      dimension_df['data_id'] <- b_data_id
      colnames(dimension_df)[2] <- "subcluster"
      write.csv(dimension_df,this_subcluster_dimension_name, row.names = F,quote = F)
    } 
    
  }
}


####### Compare A data cell type with B data cell type
# Compare disease vs. control,
for(i in 1:b_total_ct){
  # this_ct is the cell type name
  this_ct <- levels(as.factor(b.obj$predicted.id))[i]
  if(this_ct == "Oligodendrocyte precursor cells") {
    abbr_this_ct <- "opc"
  } else {
    abbr_this_ct <- tolower(substr(this_ct, 1, 3))
  }
  this_out_name <- paste0("de/",a_data_id,"_vs_",b_data_id,"_de_",abbr_this_ct,".csv")
  
  # Make sure both datasets have same cell type
  if(!file.exists(this_out_name) && this_ct %in% levels(as.factor(a.obj$predicted.id))) {
    this_a_obj <- subset(a.obj, subset = predicted.id == this_ct)
    this_a_obj[['condition']] <- 1
    this_b_obj <- subset(b.obj, subset = predicted.id == this_ct)
    this_b_obj[['condition']] <- 2
    if(ncol(this_a_obj) > 3 && ncol(this_b_obj) > 3) {
      this_combined <- merge(this_a_obj, y = this_b_obj, add.cell.ids = c("a", "b"), project = "combined")
      this_combined <- NormalizeData(this_combined)
      
      Idents(this_combined) <- this_combined$condition
      this_markers <- FindMarkers(this_combined, ident.1 = 1, ident.2 = 2, test.use = "MAST", latent.vars = 'condition')
      
      this_markers["cluster"] <- this_ct
      this_markers["gene"] <- rownames(this_markers)
      this_markers["a_data_id"] <- a_data_id
      this_markers["b_data_id"] <- b_data_id
      this_markers["ct"] <- abbr_this_ct
      this_markers["type"] <- "a_vs_b"
      write.csv(this_markers,this_out_name, row.names = F,quote = F)
    }
  }
}


####### Export dimension reduction table, A data
this_out_name <- paste0("dimension/",a_data_id,"_dimension_reduction.csv")
if(!file.exists(this_out_name)) {
  if(class(a.obj[['umap']])[1] != "DimReduc") {
    a.obj <- Seurat::RunUMAP(a.obj, dims = 1:25)
  }
  umap_df <- Embeddings(object = a.obj[['umap']])
  pca_df <- Embeddings(object = a.obj[['pca']])[,1:3]
  cell_type_df <- as.matrix(a.obj$predicted.id)
  dimension_df <- as.data.frame(cbind(cell_type_df,umap_df,pca_df))
  dimension_df <- rownames_to_column(dimension_df, "cell_name")
  colnames(dimension_df) <- c("cell_name","cell_type","umap_1","umap_2","pca_1","pca2","pca3")
  dimension_df['data_id'] <- a_data_id
  write.csv(dimension_df,this_out_name, row.names = F,quote = F)
}

####### Export dimension reduction table, B data
this_out_name <- paste0("dimension/",b_data_id,"_dimension_reduction.csv")
if(!file.exists(this_out_name)) {
  if(class(b.obj[['umap']])[1] != "DimReduc") {
    b.obj <- Seurat::RunUMAP(b.obj, dims = 1:25)
  }
  umap_df <- Embeddings(object = b.obj[['umap']])
  pca_df <- Embeddings(object = b.obj[['pca']])[,1:3]
  cell_type_df <- as.matrix(b.obj$predicted.id)
  dimension_df <- as.data.frame(cbind(cell_type_df,umap_df,pca_df))
  dimension_df <- rownames_to_column(dimension_df, "cell_name")
  colnames(dimension_df) <- c("cell_name","cell_type","umap_1","umap_2","pca_1","pca2","pca3")
  dimension_df['data_id'] <- b_data_id
  write.csv(dimension_df,this_out_name, row.names = F,quote = F)
}


#Session Infomation
#sessionInfo()

