

## STOFAD R code

Download: https://bmbl.bmi.osumc.edu/downloadFiles/stofad/script/mannual_label_for_customized_intersectoin_spot.R
```{R}
setwd("d:/my_analysis/ChenShuo/2nd_sequencing/new_data_with_multi_channel/")
library(Seurat)
library(Spaniel)
library(ggplot2)
library(patchwork)
library(dplyr)
require(stats)
options(future.globals.maxSize = 4000 * 1024^2)
# read control 2-5

wd <- "./2-5/"
my.2_5.object<- Load10X_Spatial(data.dir =wd ,filename = "filtered_feature_bc_matrix.h5")
my.2_5.object$patient <- "control"
my.2_5.object$patientID <- "2_5"
my.2_5.object<- SCTransform(my.2_5.object, assay = "Spatial", verbose = FALSE)
my.2_5.object<- RunPCA(my.2_5.object, assay = "SCT", verbose = FALSE)
my.2_5.object<- FindNeighbors(my.2_5.object, reduction = "pca", dims = 1:10,k.param = 10)
my.2_5.object<- FindClusters(my.2_5.object, verbose = FALSE,resolution = 0.4)
my.2_5.object<- RunUMAP(my.2_5.object, reduction = "pca", dims = 1:10)
dim(my.2_5.object)
DimPlot(my.2_5.object, reduction = "umap", label = TRUE,pt.size = 2,label.size = 8)

# add layer label
my.2_5.label <- read.csv("New_layer_annotation/2-5 Layer.csv",header = T,row.names = 1)
identical(colnames(my.2_5.object),rownames(my.2_5.label))
my.2_5.label$Layer[my.2_5.label$Layer == ""]  <- "Noise"
# my.2_5.label <- my.2_5.label[match(colnames(my.2_5.object),rownames(my.2_5.label)),]
my.2_5.object <- AddMetaData(my.2_5.object,metadata = my.2_5.label)

# add other label 
# add Tau
Tau.2_5.label <- read.csv("New staining annotation/Tau46_TauC/2-5 Tau.csv",header = T,row.names = 1)
Tau.2_5.label$Tau46.TauC[Tau.2_5.label$Tau46.TauC == ""] <- "Not_defined" 
unique(Tau.2_5.label$Tau46.TauC)
# add WFS1
WFS1.2_5.label <- read.csv("New staining annotation/WFS1/2-5 WFS1.csv",header = T,row.names = 1)
WFS1.2_5.label$WFS1[WFS1.2_5.label$WFS1==""] <- "Not_defined"
unique(WFS1.2_5.label$WFS1)

# add label to object 
my.2_5.object <- AddMetaData(my.2_5.object,metadata = Tau.2_5.label)
my.2_5.object <- AddMetaData(my.2_5.object,metadata = WFS1.2_5.label)  

colnames(my.2_5.object@meta.data)

  
SpatialDimPlot(my.2_5.object, label = TRUE, label.size = 11,alpha = c(0,0.1))
my.2_5.object$number_gene <- as.numeric(my.2_5.object$nFeature_Spatial)
SpatialDimPlot(my.2_5.object, label = TRUE, label.size = 11,alpha = c(0,0.1),group.by = "number_gene")
SpatialDimPlot(my.2_5.object,group.by = "Layer", label = TRUE, label.size = 11,
               cols = c("Layer 1" = "#2E91E5",
                        "Layer 2"= "#E15F99",
                        "Layer 3"= "#1CA71C",
                        "Layer 4"= "#FB0D0D",
                        "Layer 5"= "#DA16FF",
                        "Layer 6"= "#B68100",
                        "White Matter"= "#222A2A",
                        "Noise"= "#750D86"
               )) 





#read patient 2-8
wd <- "./2-8/"
my.2_8.object<- Load10X_Spatial(data.dir =wd ,filename = "filtered_feature_bc_matrix.h5")
my.2_8.object$patient <- "AD"
my.2_8.object$patientID <- "2_8"
my.2_8.object<- SCTransform(my.2_8.object, assay = "Spatial", verbose = FALSE)
my.2_8.object<- RunPCA(my.2_8.object, assay = "SCT", verbose = FALSE)
my.2_8.object<- FindNeighbors(my.2_8.object, reduction = "pca", dims = 1:10,k.param = 10)
my.2_8.object<- FindClusters(my.2_8.object, verbose = FALSE,resolution = 0.4)
my.2_8.object<- RunUMAP(my.2_8.object, reduction = "pca", dims = 1:10)
dim(my.2_8.object)
DimPlot(my.2_8.object, reduction = "umap", label = TRUE,pt.size = 2,label.size = 8)

my.2_8.label <- read.csv("New_layer_annotation/2-8 Layer.csv",header = T,row.names = 1)
identical(colnames(my.2_8.object),rownames(my.2_8.label))
my.2_8.label$Layer[my.2_8.label$Layer == ""]  <- "Noise"
# my.2_8.label <- my.2_8.label[match(colnames(my.2_8.object),rownames(my.2_8.label)),]
# add other label 
# add Tau
Tau.2_8.label <- read.csv("New staining annotation/Tau46_TauC/2-8 Tau.csv",header = T,row.names = 1)
Tau.2_8.label$Tau46.TauC[Tau.2_8.label$Tau46.TauC == ""] <- "Not_defined" 
unique(Tau.2_8.label$Tau46.TauC)
# add WFS1
WFS1.2_8.label <- read.csv("New staining annotation/WFS1/2-8 WFS1.csv",header = T,row.names = 1)
WFS1.2_8.label$WFS1[WFS1.2_8.label$WFS1 == ""] <- "Not_defined" 
unique(WFS1.2_8.label$WFS1)
# add Abeta
Abeta.2_8.label <- read.csv("New staining annotation/Ab/2-8 Ab.csv",header = T,row.names = 1)
Abeta.2_8.label$Ab[Abeta.2_8.label$Ab ==""] <- "Not_defined"
Abeta.2_8.label$Ab[Abeta.2_8.label$Ab =="Ab "] <- "Ab"
unique(Abeta.2_8.label$Ab)
# add AT8
AT8.2_8.label <- read.csv("New staining annotation/AT8/2-8 AT8 .csv",header = T,row.names = 1)
AT8.2_8.label$AT8[AT8.2_8.label$AT8 ==""] <- "Not_defined"
unique(AT8.2_8.label$AT8)
# add meta to object 
my.2_8.object <- AddMetaData(my.2_8.object, metadata =Tau.2_8.label)
my.2_8.object <- AddMetaData(my.2_8.object, metadata =WFS1.2_8.label)
my.2_8.object <- AddMetaData(my.2_8.object, metadata =Abeta.2_8.label)
my.2_8.object <- AddMetaData(my.2_8.object, metadata =AT8.2_8.label)
my.2_8.object <- AddMetaData(my.2_8.object,metadata = my.2_8.label)
my.2_8.object$Layer[which(my.2_8.object$Layer == "White matter")] <- "White Matter"
SpatialDimPlot(my.2_8.object, label = TRUE, label.size = 11,alpha = c(0,0.1))
SpatialDimPlot(my.2_8.object,group.by = "AT8", label = TRUE, label.size = 11,alpha = c(0,0.1))
SpatialDimPlot(my.2_8.object,group.by = "Layer", label = TRUE, label.size = 11,
               cols = c("Layer 1" = "#2E91E5",
                        "Layer 2"= "#E15F99",
                        "Layer 3"= "#1CA71C",
                        "Layer 4"= "#FB0D0D",
                        "Layer 5"= "#DA16FF",
                        "Layer 6"= "#B68100",
                        "White Matter"= "#222A2A",
                        "Noise"= "#750D86"
               )) 


# read control 18-64
wd <- "./18-64/"
my.18_64.object<- Load10X_Spatial(data.dir =wd ,filename = "filtered_feature_bc_matrix.h5")
my.18_64.object$patient <- "control"
my.18_64.object$patientID <- "18_64"
my.18_64.object<- SCTransform(my.18_64.object, assay = "Spatial", verbose = FALSE)
my.18_64.object<- RunPCA(my.18_64.object, assay = "SCT", verbose = FALSE)
my.18_64.object<- FindNeighbors(my.18_64.object, reduction = "pca", dims = 1:10,k.param = 10)
my.18_64.object<- FindClusters(my.18_64.object, verbose = FALSE,resolution = 0.4)
my.18_64.object<- RunUMAP(my.18_64.object, reduction = "pca", dims = 1:10)
dim(my.18_64.object)
DimPlot(my.18_64.object, reduction = "umap", label = TRUE,pt.size = 2,label.size = 8)
my.18_64.label <- read.csv("New_layer_annotation/18-64 Layer.csv",header = T,row.names = 1)
identical(colnames(my.18_64.object),rownames(my.18_64.label))
my.18_64.label$Layer[my.18_64.label$Layer == ""]  <- "Noise"
# add other label 
# add Tau
Tau.18_64.label <- read.csv("New staining annotation/Tau46_TauC/18-64 Tau.csv",header = T,row.names = 1)
Tau.18_64.label$Tau46.TauC[Tau.18_64.label$Tau46.TauC == ""] <- "Not_defined" 
unique(Tau.18_64.label$Tau46.TauC)
# add WFS1
WFS1.18_64.label <- read.csv("New staining annotation/WFS1/18-64 WFS1.csv",header = T,row.names = 1)
WFS1.18_64.label$WFS1[WFS1.18_64.label$WFS1==""] <- "Not_defined"
unique(WFS1.18_64.label$WFS1)

# add label to object 
my.18_64.object <- AddMetaData(my.18_64.object,metadata = Tau.18_64.label)
my.18_64.object <- AddMetaData(my.18_64.object,metadata = WFS1.18_64.label)  

my.18_64.object <- AddMetaData(my.18_64.object,metadata = my.18_64.label)

# my.18_64.object$Layer[which(my.18_64.object$Layer == "White matter")] <- "White Matter"
SpatialDimPlot(my.18_64.object, label = TRUE, label.size = 11,alpha = c(0,0.1))
SpatialDimPlot(my.18_64.object,group.by = "Layer", label = TRUE, label.size = 11,
               cols = c("Layer 1" = "#2E91E5",
                        "Layer 2"= "#E15F99",
                        "Layer 3"= "#1CA71C",
                        "Layer 4"= "#FB0D0D",
                        "Layer 5"= "#DA16FF",
                        "Layer 6"= "#B68100",
                        "White Matter"= "#222A2A",
                        "Noise"= "#750D86"
               )) 



# read patient T4857
wd <- "./T4857/"
my.T4857.object<- Load10X_Spatial(data.dir =wd ,filename = "filtered_feature_bc_matrix.h5")
my.T4857.object$patient <- "AD"
my.T4857.object$patientID <- "T4857"
my.T4857.object<- SCTransform(my.T4857.object, assay = "Spatial", verbose = FALSE)
my.T4857.object<- RunPCA(my.T4857.object, assay = "SCT", verbose = FALSE)
my.T4857.object<- FindNeighbors(my.T4857.object, reduction = "pca", dims = 1:10,k.param = 10)
my.T4857.object<- FindClusters(my.T4857.object, verbose = FALSE,resolution = 0.4)
my.T4857.object<- RunUMAP(my.T4857.object, reduction = "pca", dims = 1:10)
dim(my.T4857.object)
DimPlot(my.T4857.object, reduction = "umap", label = TRUE,pt.size = 2,label.size = 8)
my.T4857.label <- read.csv("New_layer_annotation/T4857 Layers.csv",header = T,row.names = 1)
identical(colnames(my.T4857.object),rownames(my.T4857.label))
my.T4857.label$Layer[my.T4857.label$Layer == ""]  <- "Noise"
# my.T4857.label <- my.T4857.label[match(colnames(my.T4857.object),rownames(my.T4857.label)),]
my.T4857.object <- AddMetaData(my.T4857.object,metadata = my.T4857.label)

SpatialDimPlot(my.T4857.object, label = TRUE, label.size = 11,alpha = c(0,0.1))
# add other layer
# add Tau
Tau.T4857.label <- read.csv("New staining annotation/Tau46_TauC/T4857 Tau.csv",header = T,row.names = 1)
Tau.T4857.label$Tau46.TauC[Tau.T4857.label$Tau46.TauC == ""] <- "Not_defined" 
unique(Tau.T4857.label$Tau46.TauC)
# add WFS1
WFS1.T4857.label <- read.csv("New staining annotation/WFS1/T4857 WFS1.csv",header = T,row.names = 1)
WFS1.T4857.label$WFS1[WFS1.T4857.label$WFS1 == ""] <- "Not_defined" 
unique(WFS1.T4857.label$WFS1)
# add Abeta
Abeta.T4857.label <- read.csv("New staining annotation/Ab/T4857 Ab.csv",header = T,row.names = 1)
Abeta.T4857.label$Ab[Abeta.T4857.label$Ab ==""] <- "Not_defined"
unique(Abeta.T4857.label$Ab)
# add AT8
AT8.T4857.label <- read.csv("New staining annotation/AT8/2-8 AT8 .csv",header = T,row.names = 1)
AT8.T4857.label$AT8[AT8.T4857.label$AT8 ==""] <- "Not_defined"
unique(AT8.T4857.label$AT8)
# add regions 
regions.T4857.label <- read.csv("New staining annotation/T4857 Region.csv",header = T,row.names = 1)
unique(regions.T4857.label$Region)
regions.T4857.label$Region[regions.T4857.label$Region ==""] <- "Not_defined"

# add meta to object 
my.T4857.object <- AddMetaData(my.T4857.object, metadata =Tau.T4857.label)
my.T4857.object <- AddMetaData(my.T4857.object, metadata =WFS1.T4857.label)
my.T4857.object <- AddMetaData(my.T4857.object, metadata =Abeta.T4857.label)
my.T4857.object <- AddMetaData(my.T4857.object, metadata =AT8.T4857.label)
my.T4857.object <- AddMetaData(my.T4857.object,metadata = my.T4857.label)
my.T4857.object <- AddMetaData(my.T4857.object,metadata = regions.T4857.label)
my.T4857.object$Layer[which(my.T4857.object$Layer == "White matter")] <- "White Matter"
SpatialDimPlot(my.T4857.object,group.by = "Layer", label = TRUE, label.size = 11,
               cols = c("Layer 1" = "#2E91E5",
                        "Layer 2"= "#E15F99",
                        "Layer 3"= "#1CA71C",
                        "Layer 4"= "#FB0D0D",
                        "Layer 5"= "#DA16FF",
                        "Layer 6"= "#B68100",
                        "White Matter"= "#222A2A",
                        "Noise"= "#750D86"
               ))

Idents(my.T4857.object) <- "Layer"


# DEGs comparison 
# 1 vs 3: Tau region for each layer. 
# 2-5 control1 
# 18-64 control2
# 2-8 ad1
# T4857 ad2
require(openxlsx)
library(xlsx)
library(ComplexHeatmap)
`%notin%` <- Negate(`%in%`)

seurat.object.list <- list(C1 = my.2_5.object, C2 = my.18_64.object, AD1 = my.2_8.object, AD2 = my.T4857.object)
comparison_vec <- rbind(AD1_C1 = c(1,0,1,0),
                        AD2_C1 = c(1,0,0,1),
                        AD1_C2 = c(0,1,1,0),
                        AD2_C2 = c(0,1,0,1))
tmp.merge.object <- merge(seurat.object.list[[1]],y = c(seurat.object.list[[2]],seurat.object.list[[3]],seurat.object.list[[4]]))
tmp.layer.info <- unique(tmp.merge.object$Layer)
tmp.layer.info <- tmp.layer.info[c(-1,-8)]
list_of_datasets <- list()


for (j in seq_len(length(tmp.layer.info))){
  DEG_list <- list()
  cell_number <- list()
  for (i in 1:4){
    tmp.object.list.subset <- seurat.object.list[which(comparison_vec[i,]==1)]
    tmp.merge.object <- merge(tmp.object.list.subset[[1]],tmp.object.list.subset[[2]])
    tmp.layer <- tmp.layer.info[j]
    layer.spot <- names(tmp.merge.object$Layer)[tmp.merge.object$Layer ==tmp.layer ]
    Control.spots <- names(tmp.merge.object$patient)[tmp.merge.object$patient == "control"]
    AD.spots <- names(tmp.merge.object$patient)[tmp.merge.object$patient == "AD"]
    Tau.spots <- names(tmp.merge.object$Tau46.TauC)[tmp.merge.object$Tau46.TauC == "Tau"]
    cell.group1 <- intersect(layer.spot,intersect(AD.spots,Tau.spots))
    cell.group2 <- intersect(layer.spot,intersect(Control.spots, Tau.spots))
    tmp.DEG_list <- FindMarkers(tmp.merge.object, ident.1 =  cell.group1, ident.2 = cell.group2, logfc.threshold = 0.05 , min.pct = 0.25,min.cells.group = 1)
    tmp.DEG_list <- tmp.DEG_list[abs(tmp.DEG_list$avg_logFC) > 0.25,]
    DEG_list[[i]] <- tmp.DEG_list
    cell_number[[i]] <- c(length(cell.group1),length(cell.group2))
    cell.group1.name <- gsub("_[1,2,3,4,5,6]$","",cell.group1)
    cell.group2.name <- gsub("_[1,2,3,4,5,6]$","",cell.group2)
    AD.cell.name <- names(tmp.merge.object$patient)[ tmp.merge.object$patient == "AD"]
    AD.cell.name <- gsub("_[1,2,3,4,5,6]$","",AD.cell.name )
    control.cell.name <- names( tmp.merge.object$patient)[ tmp.merge.object$patient == "control"]
    control.cell.name <- gsub("_[1,2,3,4,5,6]$","",control.cell.name )
    AD_barcode <- as.data.frame(cbind(ID = AD.cell.name, barcode = "unselected"))
    control_barcode <- as.data.frame(cbind(ID = control.cell.name,barcode = "unselected"))
    vector.name <- unlist(strsplit(rownames(comparison_vec)[i],"_"))
    AD_barcode$barcode[AD_barcode$ID %in% cell.group1.name] <- paste0(rownames(comparison_vec)[i],
                                                                      "_layer_",tmp.layer.info[j],
                                                                      "_",vector.name[1]
                                                                      )
    control_barcode$barcode[control_barcode$ID %in% cell.group2.name] <- paste0(rownames(comparison_vec)[i],
                                                                      "_layer_",tmp.layer.info[j],
                                                                      "_",vector.name[2]
    )
    
    write.csv(AD_barcode,file = paste0("./1_vs_3_spot_csv_for_loupe/",rownames(comparison_vec)[i],
                                       "_layer_",tmp.layer.info[j],
                                       "_",vector.name[1],".csv"), quote = F,row.names = F)
    write.csv(control_barcode,file = paste0("./1_vs_3_spot_csv_for_loupe/",rownames(comparison_vec)[i],
                                            "_layer_",tmp.layer.info[j],
                                            "_",vector.name[2],".csv"),quote = F,row.names = F)
  }
  print(tmp.layer)
  names(DEG_list) <- rownames(comparison_vec)
  # up regulate gene 
  AD_up_gene_list <- sapply(DEG_list, function(x){
    tmp.up_name <- rownames(x)[x$avg_logFC >0]
    return(tmp.up_name)
  })
  AD_up_gene_df <- list_to_matrix(AD_up_gene_list)
  AD_up_gene_lgfc_df <- AD_up_gene_df
  colnames(AD_up_gene_lgfc_df) <- paste0(tmp.layer,"_up_logFC_", colnames(AD_up_gene_df),cell_number)
  for (n in 1:ncol(AD_up_gene_df)){
    for (m in 1:nrow(AD_up_gene_df)){
      if(AD_up_gene_df[m,n] ==1){
        tmp_AD_up_genename <- rownames(AD_up_gene_df)[m] 
        AD_up_gene_lgfc <- DEG_list[[n]][tmp_AD_up_genename,c("avg_logFC")]
        AD_up_gene_lgfc_df[m,n] <- AD_up_gene_lgfc
      } 
    }
  } 
  AD_up_gene_pval_df <- AD_up_gene_df
  colnames(AD_up_gene_pval_df) <- paste0(tmp.layer,"up_Adj.pval_", colnames(AD_up_gene_df),cell_number)
  for (n in 1:ncol(AD_up_gene_df)){
    for (m in 1:nrow(AD_up_gene_df)){
      if(AD_up_gene_df[m,n] ==1){
        tmp_AD_up_genename <- rownames(AD_up_gene_df)[m] 
        AD_up_gene_lgfc <- DEG_list[[n]][tmp_AD_up_genename,c("p_val_adj")]
        AD_up_gene_pval_df[m,n] <- AD_up_gene_lgfc
      } 
    }
  }
 # down regulated gene
  AD_down_gene_list <- sapply(DEG_list, function(x){
    tmp.down_name <- rownames(x)[x$avg_logFC <0]
    return(tmp.down_name)
  })
  AD_down_gene_df <- list_to_matrix(AD_down_gene_list)
  AD_down_gene_lgfc_df <- AD_down_gene_df
  colnames(AD_down_gene_lgfc_df) <- paste0(tmp.layer,"down_logFC_", colnames(AD_down_gene_df),cell_number)
  for (n in 1:ncol(AD_down_gene_df)){
    for (m in 1:nrow(AD_down_gene_df)){
      if(AD_down_gene_df[m,n] ==1){
        tmp_AD_down_genename <- rownames(AD_down_gene_df)[m] 
        AD_down_gene_lgfc <- DEG_list[[n]][tmp_AD_down_genename,c("avg_logFC")]
        AD_down_gene_lgfc_df[m,n] <- AD_down_gene_lgfc
      } 
    }
  } 
  AD_down_gene_pval_df <- AD_down_gene_df
  colnames(AD_down_gene_pval_df) <- paste0(tmp.layer,"down_Adj.pval_", colnames(AD_down_gene_df),cell_number)
  for (n in 1:ncol(AD_down_gene_df)){
    for (m in 1:nrow(AD_down_gene_df)){
      if(AD_down_gene_df[m,n] ==1){
        tmp_AD_down_genename <- rownames(AD_down_gene_df)[m] 
        AD_down_gene_lgfc <- DEG_list[[n]][tmp_AD_down_genename,c("p_val_adj")]
        AD_down_gene_pval_df[m,n] <- AD_down_gene_lgfc
      } 
    }
  }
 final_AD_up_matrix <- cbind(ID= rownames(AD_up_gene_df), 
                             overlap = rowSums(AD_up_gene_df),
                             AD_up_gene_df,
                             AD_up_gene_lgfc_df,
                             AD_up_gene_pval_df)
 final_AD_down_matrix <- cbind(ID= rownames(AD_down_gene_df),
                               overlap = rowSums(AD_down_gene_df),
                               AD_down_gene_df,
                               AD_down_gene_lgfc_df,
                               AD_down_gene_pval_df)
 # remove up and down gene in one comparison
 gene_for_up_and_down <- intersect(rownames(final_AD_up_matrix),rownames(final_AD_down_matrix))
 final_AD_up_matrix <- final_AD_up_matrix[rownames(final_AD_up_matrix) %notin%gene_for_up_and_down,]
 final_AD_down_matrix <- final_AD_down_matrix[rownames(final_AD_down_matrix) %notin% gene_for_up_and_down,]
 list_of_datasets[[2*j-1]] <-  final_AD_up_matrix
 names(list_of_datasets)[2*j-1] <- paste0(tmp.layer, "_AD_up_DEG")
 list_of_datasets[[2*j]] <-  final_AD_down_matrix
 names(list_of_datasets)[2*j] <- paste0(tmp.layer, "_AD_down_DEG")

}

library(org.Hs.eg.db)
library(clusterProfiler)
library(ReactomePA)
final.list <-list()
pathway.list <-list()
for (i in 1:length(list_of_datasets)){
  sorted.data <- as.data.frame(list_of_datasets[[i]])
  genes.use <- sorted.data$ID[sorted.data$overlap >= 2]
  GO_pathway <- enrichGO(gene = genes.use, OrgDb = org.Hs.eg.db, ont = "BP", keyType = "SYMBOL", pAdjustMethod = "BH", pvalueCutoff = 0.05, 
                         qvalueCutoff = 0.05)
  GO_res <- simplify(GO_pathway)
  GO_simplied_res <- GO_res@result[GO_res@result$p.adjust < 0.05,]
  dim(GO_simplied_res)
  if(dim(GO_simplied_res)[1]==0){
    GO_simplied_res <- as.data.frame(cbind(NO_results= "NO_result_for_GO"))
  }
  
  gene.convert <- bitr(genes.use, fromType = "SYMBOL", toType = c("ENSEMBL", "ENTREZID"), OrgDb = org.Hs.eg.db)
  reactome_analysis <-  enrichPathway(gene=gene.convert$ENTREZID, pvalueCutoff = 0.05, readable=TRUE)
  reactome_res <- reactome_analysis@result[reactome_analysis@result$p.adjust <0.05,]
  dim(reactome_res)
  if(dim(reactome_res)[1]==0){
    reactome_res <- as.data.frame(cbind(NO_results= "NO_result_for_reactome"))
  }
  KEGG_pathway <- enrichKEGG(gene = gene.convert$ENTREZID, organism = "hsa", keyType = "kegg", pAdjustMethod = "BH", pvalueCutoff = 0.05, 
                             qvalueCutoff = 0.05)
  
  KEGG_res <- KEGG_pathway@result[KEGG_pathway@result$p.adjust<0.05,]
  dim(KEGG_res)
  if(dim( KEGG_res)[1]==0){
    KEGG_res <- as.data.frame(cbind(NO_results= "NO_result_for_KEGG"))
  }else{
    for (j in 1:nrow(KEGG_res)){
      tmp_name <- KEGG_res$geneID[j]
      tmp_name <- unlist(strsplit(tmp_name,"/"))
      index_entizID <- gene.convert$ENTREZID %in% tmp_name
      converted_geneSymbol <- gene.convert$SYMBOL[index_entizID]
      final_name <- paste0(converted_geneSymbol,collapse = "/")
      KEGG_res$geneID[j] <- final_name
    }
  }

  Go_KEGG.bind <- gdata::cbindX(GO_simplied_res,KEGG_res,reactome_res)
  tmp.sorted.data <- as.data.frame(list_of_datasets[[i]])
  tmp.sorted.data <- tmp.sorted.data[order(tmp.sorted.data$overlap,decreasing = T),]
  pathway.list[[i]] <- gdata::cbindX(tmp.sorted.data,Go_KEGG.bind)
  names(pathway.list)[i] <- names(list_of_datasets)[i]
}

save(pathway.list,file = "pathway.list.Rdata")
save(list_of_datasets,file = "list_of_datasets.Rdata")
load("pathway.list.Rdata")
load("list_of_datasets.Rdata")
xlsx::write.xlsx(pathway.list[[1]], file = "1_vs_3_remove_overlap_with_cell_number_with_pathway_overlap2.xlsx",sheetName= names(pathway.list)[1],row.names = FALSE)
for (sheet.idx in 2:length(list_of_datasets)){
  xlsx::write.xlsx(pathway.list[[sheet.idx]], file = "1_vs_3_remove_overlap_with_cell_number_with_pathway_overlap2.xlsx",sheetName= names(pathway.list)[sheet.idx],append = T,row.names = FALSE)
}

xlsx::write.xlsx(pathway.list[[9]], file = "1_vs_3_remove_overlap_with_cell_number_with_pathway9_overlap2.xlsx",sheetName= names(pathway.list)[9],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[10]], file = "1_vs_3_remove_overlap_with_cell_number_with_pathway10_overlap2.xlsx",sheetName= names(pathway.list)[10],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[11]], file = "1_vs_3_remove_overlap_with_cell_number_with_pathway11_overlap2.xlsx",sheetName= names(pathway.list)[11],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[12]], file = "1_vs_3_remove_overlap_with_cell_number_with_pathway12_overlap2.xlsx",sheetName= names(pathway.list)[12],row.names = FALSE)

#################################################

#################################################
# AD: 19 (Layer AT8+/WFS1+) vs 20 (Layer AT8+/WFS1-) each layer

# 2-5 control1 
# 18-64 control2
# 2-8 ad1
# T4857 ad2
require(openxlsx)
library(xlsx)
library(ComplexHeatmap)
`%notin%` <- Negate(`%in%`)


seurat.object.list <- list(AD1 = my.2_8.object, AD2 = my.T4857.object)
tmp.merge.object <- merge(seurat.object.list[[1]],seurat.object.list[[2]])
tmp.layer.info <- unique(tmp.merge.object$Layer)
tmp.layer.info <- tmp.layer.info[c(-7,-8)]
list_of_datasets <- list()

for (j in seq_len(length(tmp.layer.info))){
  DEG_list <- list()
  cell_number <- list()
  for (i in 1:2){
    tmp.object <-seurat.object.list[[i]]
    tmp.layer <- tmp.layer.info[j]
    # subset spots
    layer.spot <- names(tmp.object$Layer)[tmp.object$Layer ==tmp.layer]
    AD.WFS1_pos.spot <- names(tmp.object$WFS1)[tmp.object$WFS1 == "WFS1"]
    AD.WFS1_neg.spot <- names(tmp.object$WFS1)[tmp.object$WFS1 == "Not_defined"]
    AD.Tau_pos.spot <- names(tmp.object$Tau46.TauC)[tmp.object$Tau46.TauC == "Tau"]
    AD.Tau_neg.spot <- names(tmp.object$Tau46.TauC)[tmp.object$Tau46.TauC == "Not_defined"]
    AD.AT8_pos.spot <- names(tmp.object$AT8)[tmp.object$AT8 == "AT8"]
    AD.AT8_neg.spot <- names(tmp.object$AT8)[tmp.object$AT8 == "Not_defined"]
    # select group 
    cell.group1 <- intersect(intersect(AD.WFS1_pos.spot,AD.AT8_pos.spot),layer.spot)
    cell.group2 <- intersect(intersect(AD.WFS1_neg.spot,AD.AT8_pos.spot),layer.spot)
    
    tmp.DEG_list <- FindMarkers(tmp.object, ident.1 =  cell.group1, ident.2 = cell.group2, logfc.threshold = 0.10 , min.pct = 0.25,min.cells.group = 1)
    tmp.DEG_list <- tmp.DEG_list[abs(tmp.DEG_list$avg_logFC) > 0.25,]
    DEG_list[[i]] <- tmp.DEG_list
    
    cell_number[[i]] <- c(length(cell.group1),length(cell.group2))
    cell.group1.name <- gsub("_[1,2,3,4,5,6]$","",cell.group1)
    cell.group2.name <- gsub("_[1,2,3,4,5,6]$","",cell.group2)
    tmp.AD.ID <- unique(tmp.object$patientID)
    AD.cell.name <- names(tmp.merge.object$patient)[ tmp.merge.object$patientID == tmp.AD.ID]
    AD.cell.name <- gsub("_[1,2,3,4,5,6]$","",AD.cell.name )
    
    AD_cellGroup1_barcode <- as.data.frame(cbind(ID = AD.cell.name, barcode = "unselected"))
    AD_cellGroup2_barcode <- as.data.frame(cbind(ID = AD.cell.name,barcode = "unselected"))
    AD_cellGroup1_barcode$barcode[AD_cellGroup1_barcode$ID %in% cell.group1.name] <- paste0("AD", i,": ",tmp.AD.ID,
                                                                      tmp.layer.info[j],
                                                                      "_","WFS1+/AT8+")
    AD_cellGroup2_barcode$barcode[AD_cellGroup2_barcode$ID %in% cell.group2.name] <- paste0("AD", i,": ",tmp.AD.ID,
                                                                         tmp.layer.info[j],
                                                                         "_","WFS1-/AT8+")
  
    write.csv(AD_cellGroup1_barcode,file = paste0("./19_vs_20_spot_csv_for_loupe/",paste0("AD", i,"_",tmp.AD.ID,"_combination_19_",
                                                                               tmp.layer.info[j],
                                                                               "_","WFS1+_AT8+.csv")), quote = F,row.names = F)
    write.csv(AD_cellGroup2_barcode,file = paste0("./19_vs_20_spot_csv_for_loupe/",paste0("AD", i,"_",tmp.AD.ID,"_combination_20_",
                                                                                  tmp.layer.info[j],
                                                                                  "_","WFS1-_AT8+.csv")),quote = F,row.names = F)
  }
  print(tmp.layer)
  names(DEG_list) <- c("AD1","AD2")
  if (dim(DEG_list[[1]])[1]==0 & dim(DEG_list[[2]])[1]==0){
    list_of_datasets[[2*j-1]] <-  c("no_result")
    names(list_of_datasets)[2*j-1] <- paste0(tmp.layer, "_19_up_DEG")
    list_of_datasets[[2*j]] <-  c("no_result")
    names(list_of_datasets)[2*j] <- paste0(tmp.layer, "_19_down_DEG")
    next()
  }
  # up regulate gene 
  AD_up_gene_list <- sapply(DEG_list, function(x){
    tmp.up_name <- rownames(x)[x$avg_logFC >0]
    return(tmp.up_name)
  })
  AD_up_gene_df <- list_to_matrix(AD_up_gene_list)
  AD_up_gene_lgfc_df <- AD_up_gene_df
  colnames(AD_up_gene_lgfc_df) <- paste0(tmp.layer,"up_logFC_", colnames(AD_up_gene_df),cell_number)
  for (n in 1:ncol(AD_up_gene_df)){
    if(length(AD_up_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_up_gene_df)){
      if(AD_up_gene_df[m,n] ==1){
        tmp_AD_up_genename <- rownames(AD_up_gene_df)[m] 
        AD_up_gene_lgfc <- DEG_list[[n]][tmp_AD_up_genename,c("avg_logFC")]
        AD_up_gene_lgfc_df[m,n] <- AD_up_gene_lgfc
      } 
    }
  } 
  AD_up_gene_pval_df <- AD_up_gene_df
  colnames(AD_up_gene_pval_df) <- paste0(tmp.layer,"up_Adj.pval_", colnames(AD_up_gene_df),cell_number)
  for (n in 1:ncol(AD_up_gene_df)){
    if(length(AD_up_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_up_gene_df)){
      if(AD_up_gene_df[m,n] ==1){
        tmp_AD_up_genename <- rownames(AD_up_gene_df)[m] 
        AD_up_gene_lgfc <- DEG_list[[n]][tmp_AD_up_genename,c("p_val_adj")]
        AD_up_gene_pval_df[m,n] <- AD_up_gene_lgfc
      } 
    }
  }
  # down regulated gene
  AD_down_gene_list <- sapply(DEG_list, function(x){
    tmp.down_name <- rownames(x)[x$avg_logFC <0]
    return(tmp.down_name)
  })
  AD_down_gene_df <- list_to_matrix(AD_down_gene_list)
  AD_down_gene_lgfc_df <- AD_down_gene_df
  colnames(AD_down_gene_lgfc_df) <- paste0(tmp.layer,"down_logFC_", colnames(AD_down_gene_df),cell_number)
  for (n in 1:ncol(AD_down_gene_df)){
    if(length(AD_down_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_down_gene_df)){
      if(AD_down_gene_df[m,n] ==1){
        tmp_AD_down_genename <- rownames(AD_down_gene_df)[m] 
        AD_down_gene_lgfc <- DEG_list[[n]][tmp_AD_down_genename,c("avg_logFC")]
        AD_down_gene_lgfc_df[m,n] <- AD_down_gene_lgfc
      } 
    }
  } 
  AD_down_gene_pval_df <- AD_down_gene_df
  colnames(AD_down_gene_pval_df) <- paste0(tmp.layer,"down_Adj.pval_", colnames(AD_down_gene_df),cell_number)
  for (n in 1:ncol(AD_down_gene_df)){
    if(length(AD_down_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_down_gene_df)){
      if(AD_down_gene_df[m,n] ==1){
        tmp_AD_down_genename <- rownames(AD_down_gene_df)[m] 
        AD_down_gene_lgfc <- DEG_list[[n]][tmp_AD_down_genename,c("p_val_adj")]
        AD_down_gene_pval_df[m,n] <- AD_down_gene_lgfc
      } 
    }
  }
  final_AD_up_matrix <- as.data.frame(cbind(ID= rownames(AD_up_gene_df), 
                                            overlap = rowSums(AD_up_gene_df),
                                            AD_up_gene_df,
                                            AD_up_gene_lgfc_df,
                                            AD_up_gene_pval_df))
  final_AD_down_matrix <- as.data.frame(cbind(ID= rownames(AD_down_gene_df),
                                              overlap = rowSums(AD_down_gene_df),
                                              AD_down_gene_df,
                                              AD_down_gene_lgfc_df,
                                              AD_down_gene_pval_df))
  # remove up and down gene in one comparison
  gene_for_up_and_down <- intersect(rownames(final_AD_up_matrix),rownames(final_AD_down_matrix))
  final_AD_up_matrix <- final_AD_up_matrix[rownames(final_AD_up_matrix) %notin%gene_for_up_and_down,]
  
  final_AD_down_matrix <- final_AD_down_matrix[rownames(final_AD_down_matrix) %notin% gene_for_up_and_down,]
  
  if(dim(final_AD_up_matrix)[1] == 0){
    final_AD_up_matrix <- as.data.frame(rbind(final_AD_up_matrix ,
                                              rep("no_result",ncol(final_AD_up_matrix))))
  }
  if(dim(final_AD_down_matrix)[1] == 0){
    final_AD_down_matrix <- as.data.frame(rbind(final_AD_down_matrix ,
                                                rep("no_result",ncol(final_AD_down_matrix))))
  }
  list_of_datasets[[2*j-1]] <-  final_AD_up_matrix
  names(list_of_datasets)[2*j-1] <- paste0(tmp.layer, "_19_up_DEG")
  list_of_datasets[[2*j]] <-  final_AD_down_matrix
  names(list_of_datasets)[2*j] <- paste0(tmp.layer, "_19_down_DEG")
  
  
}

library(org.Hs.eg.db)
library(clusterProfiler)
library(ReactomePA)
final.list <-list()
pathway.list <-list()
for (i in 1:length(list_of_datasets)){
  if(list_of_datasets[[i]]=="no_result"){
    next()
  }
  sorted.data <- as.data.frame(list_of_datasets[[i]])
  genes.use <- sorted.data$ID[sorted.data$overlap >= 1]
  GO_pathway <- enrichGO(gene = genes.use, OrgDb = org.Hs.eg.db, ont = "BP", keyType = "SYMBOL", pAdjustMethod = "BH", pvalueCutoff = 0.05, 
                         qvalueCutoff = 0.05)
  if(is.null(GO_pathway)){
    GO_simplied_res <- as.data.frame(cbind(NO_results= "NO_result_for_GO"))
  }else{
    GO_res <- simplify(GO_pathway)
    
    GO_simplied_res <- GO_res@result[GO_res@result$p.adjust < 0.05,]
    dim(GO_simplied_res)
    if(dim(GO_simplied_res)[1]==0){
      GO_simplied_res <- as.data.frame(cbind(NO_results= "NO_result_for_GO"))
    }
  }
  gene.convert <- bitr(genes.use, fromType = "SYMBOL", toType = c("ENSEMBL", "ENTREZID"), OrgDb = org.Hs.eg.db)
  reactome_analysis <-  enrichPathway(gene=gene.convert$ENTREZID, pvalueCutoff = 0.05, readable=TRUE)
  if(is.null(reactome_analysis)){
    reactome_res <- as.data.frame(cbind(NO_results= "NO_result_for_reactome"))
  }else{
    reactome_res <- reactome_analysis@result[reactome_analysis@result$p.adjust <0.05,]
    dim(reactome_res)
    if(dim(reactome_res)[1]==0){
      reactome_res <- as.data.frame(cbind(NO_results= "NO_result_for_reactome"))
    }
  }
  
  KEGG_pathway <- enrichKEGG(gene = gene.convert$ENTREZID, organism = "hsa", keyType = "kegg", pAdjustMethod = "BH", pvalueCutoff = 0.05, 
                             qvalueCutoff = 0.05)
  if(is.null(KEGG_pathway)){
    KEGG_res <- as.data.frame(cbind(NO_results= "NO_result_for_KEGG"))
  }else{
    KEGG_res <- KEGG_pathway@result[KEGG_pathway@result$p.adjust<0.05,]
    dim(KEGG_res)
    if(dim( KEGG_res)[1]==0){
      KEGG_res <- as.data.frame(cbind(NO_results= "NO_result_for_KEGG"))
    }else{
      for (j in 1:nrow(KEGG_res)){
        tmp_name <- KEGG_res$geneID[j]
        tmp_name <- unlist(strsplit(tmp_name,"/"))
        index_entizID <- gene.convert$ENTREZID %in% tmp_name
        converted_geneSymbol <- gene.convert$SYMBOL[index_entizID]
        final_name <- paste0(converted_geneSymbol,collapse = "/")
        KEGG_res$geneID[j] <- final_name
      }
    }
  }
  
  
  Go_KEGG.bind <- gdata::cbindX(GO_simplied_res,KEGG_res,reactome_res)
  tmp.sorted.data <- as.data.frame(list_of_datasets[[i]])
  tmp.sorted.data <- tmp.sorted.data[order(tmp.sorted.data$overlap,decreasing = T),]
  pathway.list[[i]] <- gdata::cbindX(tmp.sorted.data,Go_KEGG.bind)
  names(pathway.list)[i] <- names(list_of_datasets)[i]
}

for(i in 1:length(pathway.list)){
  if(is.null(pathway.list[[i]])){
    pathway.list[[i]]<- "no_result"
    names(pathway.list)[i] <- names(list_of_datasets)[i]
  }
}
xlsx::write.xlsx(pathway.list[[1]], file = "19_vs_20_remove_overlap_1.xlsx",sheetName= names(pathway.list)[1],row.names = FALSE)
for (sheet.idx in 2:length(pathway.list)){
  xlsx::write.xlsx(pathway.list[[sheet.idx]], file = "19_vs_20_remove_overlap_1.xlsx",sheetName= names(pathway.list)[sheet.idx],append = T,row.names = FALSE)
}
xlsx::write.xlsx(pathway.list[[7]], file = "19_vs_20_remove_overlap_1_7.xlsx",sheetName= names(pathway.list)[7],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[8]], file = "19_vs_20_remove_overlap_1_8.xlsx",sheetName= names(pathway.list)[8],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[9]], file = "19_vs_20_remove_overlap_1_9.xlsx",sheetName= names(pathway.list)[9],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[10]], file = "19_vs_20_remove_overlap_1_10.xlsx",sheetName= names(pathway.list)[10],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[11]], file = "19_vs_20_remove_overlap_1_11.xlsx",sheetName= names(pathway.list)[11],row.names = FALSE)
xlsx::write.xlsx(pathway.list[[12]], file = "19_vs_20_remove_overlap_1_12.xlsx",sheetName= names(pathway.list)[12],row.names = FALSE)

#################################################

# AD: 20 (Layer AT8+/WFS1-) vs (17-20) (17 Layer Tau+/WFS1- - Layer AT8+/WFS1-) each layer

# 2-5 control1 
# 18-64 control2
# 2-8 ad1
# T4857 ad2
require(openxlsx)
library(xlsx)
library(ComplexHeatmap)
`%notin%` <- Negate(`%in%`)


seurat.object.list <- list(AD1 = my.2_8.object, AD2 = my.T4857.object)
tmp.merge.object <- merge(seurat.object.list[[1]],seurat.object.list[[2]])
tmp.layer.info <- unique(tmp.merge.object$Layer)
tmp.layer.info <- tmp.layer.info[c(-7,-8)]
tmp.layer.info 
list_of_datasets <- list()

for (j in seq_len(length(tmp.layer.info))){
  DEG_list <- list()
  cell_number <- list()
  for (i in 1:2){
    tmp.object <-seurat.object.list[[i]]
    tmp.layer <- tmp.layer.info[j]
    # subset spots
    layer.spot <- names(tmp.object$Layer)[tmp.object$Layer ==tmp.layer]
    AD.WFS1_pos.spot <- names(tmp.object$WFS1)[tmp.object$WFS1 == "WFS1"]
    AD.WFS1_neg.spot <- names(tmp.object$WFS1)[tmp.object$WFS1 == "Not_defined"]
    AD.Tau_pos.spot <- names(tmp.object$Tau46.TauC)[tmp.object$Tau46.TauC == "Tau"]
    AD.Tau_neg.spot <- names(tmp.object$Tau46.TauC)[tmp.object$Tau46.TauC == "Not_defined"]
    AD.AT8_pos.spot <- names(tmp.object$AT8)[tmp.object$AT8 == "AT8"]
    AD.AT8_neg.spot <- names(tmp.object$AT8)[tmp.object$AT8 == "Not_defined"]
    # select group 
    # cell group 1: 19
    # cell group2: 17-20: 
    # 17 Layer Tau+/WFS1- 
    # 20 Layer AT8+/WFS1-
    cell.group1 <- intersect(intersect(AD.WFS1_neg.spot,AD.AT8_pos.spot),layer.spot)
    cell.group2.sub1 <- intersect(intersect(AD.WFS1_neg.spot,AD.Tau_pos.spot),layer.spot)
    cell.group2.sub2 <- intersect(intersect(AD.WFS1_neg.spot,AD.AT8_pos.spot),layer.spot)
    cell.group2 <- setdiff(cell.group2.sub1,cell.group2.sub2)
    
    tmp.DEG_list <- FindMarkers(tmp.object, ident.1 =  cell.group1, ident.2 = cell.group2, logfc.threshold = 0.10 , min.pct = 0.25,min.cells.group = 1)
    tmp.DEG_list <- tmp.DEG_list[abs(tmp.DEG_list$avg_logFC) > 0.25,]
    DEG_list[[i]] <- tmp.DEG_list
    
    cell_number[[i]] <- c(length(cell.group1),length(cell.group2))
    cell.group1.name <- gsub("_[1,2,3,4,5,6]$","",cell.group1)
    cell.group2.name <- gsub("_[1,2,3,4,5,6]$","",cell.group2)
    tmp.AD.ID <- unique(tmp.object$patientID)
    AD.cell.name <- names(tmp.merge.object$patient)[ tmp.merge.object$patientID == tmp.AD.ID]
    AD.cell.name <- gsub("_[1,2,3,4,5,6]$","",AD.cell.name )
    
    AD_cellGroup1_barcode <- as.data.frame(cbind(ID = AD.cell.name, barcode = "unselected"))
    AD_cellGroup2_barcode <- as.data.frame(cbind(ID = AD.cell.name,barcode = "unselected"))
    AD_cellGroup1_barcode$barcode[AD_cellGroup1_barcode$ID %in% cell.group1.name] <- paste0("AD", i,": ",tmp.AD.ID,
                                                                                            tmp.layer.info[j],
                                                                                            "_","WFS1+/AT8+")
    AD_cellGroup2_barcode$barcode[AD_cellGroup2_barcode$ID %in% cell.group2.name] <- paste0("AD", i,": ",tmp.AD.ID,
                                                                                            tmp.layer.info[j],
                                                                                            "_","Tau+/WFS1-/AT8-")
    
    write.csv(AD_cellGroup1_barcode,file = paste0("./20_vs_17M20_spot_csv_for_loupe/",paste0("AD", i,"_",tmp.AD.ID,"_combination_20_",
                                                                                          tmp.layer.info[j],
                                                                                          "_","WFS1-_AT8+.csv")), quote = F,row.names = F)
    write.csv(AD_cellGroup2_barcode,file = paste0("./20_vs_17M20_spot_csv_for_loupe/",paste0("AD", i,"_",tmp.AD.ID,"_combination_17M20_",
                                                                                          tmp.layer.info[j],
                                                                                          "_","Tau+_WFS1-_AT8-.csv")),quote = F,row.names = F)
  }
  print(tmp.layer)
  names(DEG_list) <- c("AD1","AD2")
  if (dim(DEG_list[[1]])[1]==0 & dim(DEG_list[[2]])[1]==0){
    list_of_datasets[[2*j-1]] <-  c("no_result")
    names(list_of_datasets)[2*j-1] <- paste0(tmp.layer, "_20_up_DEG")
    list_of_datasets[[2*j]] <-  c("no_result")
    names(list_of_datasets)[2*j] <- paste0(tmp.layer, "_20_down_DEG")
    next()
  }
  # up regulate gene 
  AD_up_gene_list <- sapply(DEG_list, function(x){
    tmp.up_name <- rownames(x)[x$avg_logFC >0]
    return(tmp.up_name)
  })
  AD_up_gene_df <- list_to_matrix(AD_up_gene_list)
  AD_up_gene_lgfc_df <- AD_up_gene_df
  colnames(AD_up_gene_lgfc_df) <- paste0(tmp.layer,"up_logFC_", colnames(AD_up_gene_df),cell_number)
  for (n in 1:ncol(AD_up_gene_df)){
    if(length(AD_up_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_up_gene_df)){
      if(AD_up_gene_df[m,n] ==1){
        tmp_AD_up_genename <- rownames(AD_up_gene_df)[m] 
        AD_up_gene_lgfc <- DEG_list[[n]][tmp_AD_up_genename,c("avg_logFC")]
        AD_up_gene_lgfc_df[m,n] <- AD_up_gene_lgfc
      } 
    }
  } 
  AD_up_gene_pval_df <- AD_up_gene_df
  colnames(AD_up_gene_pval_df) <- paste0(tmp.layer,"up_Adj.pval_", colnames(AD_up_gene_df),cell_number)
  for (n in 1:ncol(AD_up_gene_df)){
    if(length(AD_up_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_up_gene_df)){
      if(AD_up_gene_df[m,n] ==1){
        tmp_AD_up_genename <- rownames(AD_up_gene_df)[m] 
        AD_up_gene_lgfc <- DEG_list[[n]][tmp_AD_up_genename,c("p_val_adj")]
        AD_up_gene_pval_df[m,n] <- AD_up_gene_lgfc
      } 
    }
  }
  # down regulated gene
  AD_down_gene_list <- sapply(DEG_list, function(x){
    tmp.down_name <- rownames(x)[x$avg_logFC <0]
    return(tmp.down_name)
  })
  AD_down_gene_df <- list_to_matrix(AD_down_gene_list)
  AD_down_gene_lgfc_df <- AD_down_gene_df
  colnames(AD_down_gene_lgfc_df) <- paste0(tmp.layer,"down_logFC_", colnames(AD_down_gene_df),cell_number)
  for (n in 1:ncol(AD_down_gene_df)){
    if(length(AD_down_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_down_gene_df)){
      if(AD_down_gene_df[m,n] ==1){
        tmp_AD_down_genename <- rownames(AD_down_gene_df)[m] 
        AD_down_gene_lgfc <- DEG_list[[n]][tmp_AD_down_genename,c("avg_logFC")]
        AD_down_gene_lgfc_df[m,n] <- AD_down_gene_lgfc
      } 
    }
  } 
  AD_down_gene_pval_df <- AD_down_gene_df
  colnames(AD_down_gene_pval_df) <- paste0(tmp.layer,"down_Adj.pval_", colnames(AD_down_gene_df),cell_number)
  for (n in 1:ncol(AD_down_gene_df)){
    if(length(AD_down_gene_df[,n])==0){
      next()
    }
    for (m in 1:nrow(AD_down_gene_df)){
      if(AD_down_gene_df[m,n] ==1){
        tmp_AD_down_genename <- rownames(AD_down_gene_df)[m] 
        AD_down_gene_lgfc <- DEG_list[[n]][tmp_AD_down_genename,c("p_val_adj")]
        AD_down_gene_pval_df[m,n] <- AD_down_gene_lgfc
      } 
    }
  }
  final_AD_up_matrix <- as.data.frame(cbind(ID= rownames(AD_up_gene_df), 
                                            overlap = rowSums(AD_up_gene_df),
                                            AD_up_gene_df,
                                            AD_up_gene_lgfc_df,
                                            AD_up_gene_pval_df))
  final_AD_down_matrix <- as.data.frame(cbind(ID= rownames(AD_down_gene_df),
                                              overlap = rowSums(AD_down_gene_df),
                                              AD_down_gene_df,
                                              AD_down_gene_lgfc_df,
                                              AD_down_gene_pval_df))
  # remove up and down gene in one comparison
  gene_for_up_and_down <- intersect(rownames(final_AD_up_matrix),rownames(final_AD_down_matrix))
  final_AD_up_matrix <- final_AD_up_matrix[rownames(final_AD_up_matrix) %notin%gene_for_up_and_down,]
  
  final_AD_down_matrix <- final_AD_down_matrix[rownames(final_AD_down_matrix) %notin% gene_for_up_and_down,]
  
  if(dim(final_AD_up_matrix)[1] == 0){
    final_AD_up_matrix <- as.data.frame(rbind(final_AD_up_matrix ,
                                              rep("no_result",ncol(final_AD_up_matrix))))
  }
  if(dim(final_AD_down_matrix)[1] == 0){
    final_AD_down_matrix <- as.data.frame(rbind(final_AD_down_matrix ,
                                                rep("no_result",ncol(final_AD_down_matrix))))
  }
  list_of_datasets[[2*j-1]] <-  final_AD_up_matrix
  names(list_of_datasets)[2*j-1] <- paste0(tmp.layer, "_20_up_DEG")
  list_of_datasets[[2*j]] <-  final_AD_down_matrix
  names(list_of_datasets)[2*j] <- paste0(tmp.layer, "_20_down_DEG")
  
  
}

library(org.Hs.eg.db)
library(clusterProfiler)
library(ReactomePA)
final.list <-list()
pathway.list <-list()
for (i in 1:length(list_of_datasets)){
  if(list_of_datasets[[i]]=="no_result"){
    pathway.list[[i]] <- "no_result"
    names(pathway.list)[i] <- names(list_of_datasets)[i]
    next()
  }
  sorted.data <- as.data.frame(list_of_datasets[[i]])
  genes.use <- sorted.data$ID[sorted.data$overlap >= 1]
  GO_pathway <- enrichGO(gene = genes.use, OrgDb = org.Hs.eg.db, ont = "BP", keyType = "SYMBOL", pAdjustMethod = "BH", pvalueCutoff = 0.05, 
                         qvalueCutoff = 0.05)
  if(is.null(GO_pathway)){
    GO_simplied_res <- as.data.frame(cbind(NO_results= "NO_result_for_GO"))
  }else{
    GO_res <- simplify(GO_pathway)
    
    GO_simplied_res <- GO_res@result[GO_res@result$p.adjust < 0.05,]
    dim(GO_simplied_res)
    if(dim(GO_simplied_res)[1]==0){
      GO_simplied_res <- as.data.frame(cbind(NO_results= "NO_result_for_GO"))
    }
  }
  gene.convert <- bitr(genes.use, fromType = "SYMBOL", toType = c("ENSEMBL", "ENTREZID"), OrgDb = org.Hs.eg.db)
  reactome_analysis <-  enrichPathway(gene=gene.convert$ENTREZID, pvalueCutoff = 0.05, readable=TRUE)
  if(is.null(reactome_analysis)){
    reactome_res <- as.data.frame(cbind(NO_results= "NO_result_for_reactome"))
  }else{
    reactome_res <- reactome_analysis@result[reactome_analysis@result$p.adjust <0.05,]
    dim(reactome_res)
    if(dim(reactome_res)[1]==0){
      reactome_res <- as.data.frame(cbind(NO_results= "NO_result_for_reactome"))
    }
  }
  
  KEGG_pathway <- enrichKEGG(gene = gene.convert$ENTREZID, organism = "hsa", keyType = "kegg", pAdjustMethod = "BH", pvalueCutoff = 0.05, 
                             qvalueCutoff = 0.05)
  if(is.null(KEGG_pathway)){
    KEGG_res <- as.data.frame(cbind(NO_results= "NO_result_for_KEGG"))
  }else{
    KEGG_res <- KEGG_pathway@result[KEGG_pathway@result$p.adjust<0.05,]
    dim(KEGG_res)
    if(dim( KEGG_res)[1]==0){
      KEGG_res <- as.data.frame(cbind(NO_results= "NO_result_for_KEGG"))
    }else{
      for (j in 1:nrow(KEGG_res)){
        tmp_name <- KEGG_res$geneID[j]
        tmp_name <- unlist(strsplit(tmp_name,"/"))
        index_entizID <- gene.convert$ENTREZID %in% tmp_name
        converted_geneSymbol <- gene.convert$SYMBOL[index_entizID]
        final_name <- paste0(converted_geneSymbol,collapse = "/")
        KEGG_res$geneID[j] <- final_name
      }
    }
  }
  
  
  Go_KEGG.bind <- gdata::cbindX(GO_simplied_res,KEGG_res,reactome_res)
  tmp.sorted.data <- as.data.frame(list_of_datasets[[i]])
  tmp.sorted.data <- tmp.sorted.data[order(tmp.sorted.data$overlap,decreasing = T),]
  pathway.list[[i]] <- gdata::cbindX(tmp.sorted.data,Go_KEGG.bind)
  names(pathway.list)[i] <- names(list_of_datasets)[i]
}

for(i in 1:length(pathway.list)){
  if(is.null(pathway.list[[i]])){
    pathway.list[[i]]<- "no_result"
    names(pathway.list)[i] <- names(list_of_datasets)[i]
  }
}
#save(pathway.list,file = "pathway.list_19_vs_17M20_remove_overlap_1.RData")
#load("pathway.list_19_vs_17M20_remove_overlap_1.RData")
xlsx::write.xlsx(pathway.list[[1]], file = "20_vs_17M20_remove_overlap_1.xlsx",sheetName= names(pathway.list)[1],row.names = FALSE)
for (sheet.idx in 2:length(pathway.list)){
  print(sheet.idx)
  xlsx::write.xlsx(pathway.list[[sheet.idx]], file = "20_vs_17M20_remove_overlap_1.xlsx",sheetName= names(pathway.list)[sheet.idx],append = T,row.names = FALSE)
}








```