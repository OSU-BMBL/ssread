#########
# Load useful functions, do not print in the final report
#########
quiet <- function(x) {
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 
# point size function from test datasets
x <- c(0,90,124,317,1000,2368,3005,4816,8298,50000,500000,5000000)
y <- c(1,1,0.89,0.33,0.30,0.25,0.235,0.205,0.18,0.1,0.1,0.1)
get_point_size <- approxfun(x, y)

Plot.GeneUMAP<-function(object=my.object,gene.name=NULL,pt_size=0.5){
  tmp.gene.expression<- GetAssayData(object)
  tmp.dim<-as.data.frame(object@reductions$umap@cell.embeddings)
  tmp.MatchIndex<- match(colnames(tmp.gene.expression),rownames(tmp.dim))
  tmp.dim<-tmp.dim[tmp.MatchIndex,]
  tmp.gene.name<-paste0("^",gene.name,"$")
  tmp.One.gene.value<-tmp.gene.expression[grep(tmp.gene.name,rownames(tmp.gene.expression)),]
  tmp.dim.df<-cbind.data.frame(tmp.dim,Gene=tmp.One.gene.value)
  g<-ggplot(tmp.dim.df,aes(x=UMAP_1,y=UMAP_2,color=Gene))
  g<-g+geom_point(stroke=pt_size,size=pt_size) + scale_color_gradient(low="grey",high = "red")
  g<-g+theme_classic()+labs(color=paste0(gene.name,"\nexpression\nvalue")) + coord_fixed(1)
  g
}

Plot.GeneTSNE<-function(object=my.object,gene.name=NULL,pt_size=0.5){
  tmp.gene.expression<- object@assays$SCT@data
  tmp.dim<-as.data.frame(object@reductions$tsne@cell.embeddings)
  tmp.MatchIndex<- match(colnames(tmp.gene.expression),rownames(tmp.dim))
  tmp.dim<-tmp.dim[tmp.MatchIndex,]
  tmp.gene.name<-paste0("^",gene.name,"$")
  tmp.One.gene.value<-tmp.gene.expression[grep(tmp.gene.name,rownames(tmp.gene.expression)),]
  tmp.dim.df<-cbind.data.frame(tmp.dim,Gene=tmp.One.gene.value)
  g<-ggplot(tmp.dim.df,aes(x=tSNE_1,y=tSNE_2,color=Gene))
  g<-g+geom_point(stroke=pt_size,size=pt_size)+scale_color_gradient(low="grey",high = "red")
  g<-g+theme_classic()+labs(color=paste0(gene.name,"\nexpression\nvalue")) + coord_fixed(1)
  g
}


Plot.cluster2D<-function(object=combined,reduction.method="umap",customized=T,pt_size=1,txt="Cell type",...){
  
  my.plot.all.source<-cbind.data.frame(Embeddings(object,reduction = reduction.method),
                                       Cell_type=Idents(object))
  
  tmp.celltype <- levels(unique(my.plot.all.source$Cell_type))
  p.cluster <- ggplot(my.plot.all.source,
                      aes(x=my.plot.all.source[,1],y=my.plot.all.source[,2]))+xlab(colnames(my.plot.all.source)[1])+ylab(colnames(my.plot.all.source)[2])
  p.cluster <- p.cluster+geom_point(stroke=pt_size,size=pt_size,aes(col=my.plot.all.source[,"Cell_type"])) 
  
  p.cluster <- p.cluster + guides(colour = guide_legend(override.aes = list(size=5)))
  
  if (length(tmp.celltype) >= 5){
    p.cluster <- p.cluster + scale_colour_manual(name  =paste(txt,":(Cells)",sep = ""),values  = as.character(palette36.colors(36)[-2][1:length(tmp.celltype)]),
                                                 breaks=tmp.celltype,
                                                 labels=paste0(tmp.celltype,":(",as.character(summary(my.plot.all.source$Cell_type)),")"))
  } else if (length(tmp.celltype) < 5){
    p.cluster <- p.cluster + scale_colour_manual(name  =paste(txt,":(Cells)",sep = ""),values  = brewer.pal(4,"Spectral")[c(2,1,3,4)],
                                                 breaks=tmp.celltype,
                                                 labels=paste0(tmp.celltype,":(",as.character(summary(my.plot.all.source$Cell_type)),")"))
  } else{
    p.cluster <- p.cluster + scale_colour_manual(name  =paste(txt,":(Cells)",sep = ""),values  = brewer.pal(5,"Spectral")[c(1,5)],
                                                 breaks=tmp.celltype,
                                                 labels=paste0(tmp.celltype,":(",as.character(summary(my.plot.all.source$Cell_type)),")"))
    
  }
  
  
  # + labs(col="cell type")           
  p.cluster <- p.cluster + theme_classic() 
  p.cluster <- p.cluster + coord_fixed(ratio=1)
  p.cluster
}


##############################
# define a fucntion for reading in 10X hd5f data and cell gene matrix by input (TenX) or (CellGene)
read_data<-function(x=NULL,read.method=NULL,sep="\t",...){
  if(!is.null(x)){
    if(!is.null(read.method)){
      if(read.method !="TenX.h5"&&read.method!="CellGene"&&read.method!="TenX.folder"){
        stop("wrong 'read.method' argument, please choose 'TenX.h5','TenX.folder', or 'CellGene'!")}
      if(read.method == "TenX.h5"){
        tmp_x<-Read10X_h5(x)
        return(tmp_x)
      }else if(read.method =="TenX.folder"){
        
        all_files <- list.files(getwd())
        barcode_file <- grep("barcodes",all_files)
        matrix_file <- grep("matrix",all_files)
        gene_file <- grep("genes",all_files)
        feature_file <- grep("features",all_files)
        
        #Check users upload single zipped file, by counting detected filename, if less than 3 we think users uploads zipped file
        if((length(barcode_file) + length(matrix_file) + length(gene_file) + length(feature_file)) < 3) {
          dir.create("tmp",showWarnings = F)
          if (file_ext(x) == "7z") {
            try(system(paste("7za x", x, "-aoa -otmp")),silent = T)
          }
          try(system(paste("unzip -o", x, "-d tmp")),silent = T)
          try(system(paste("tar xzvf", x, "--directory tmp")),silent = T)
          
          # check if the file is gz instead of tar.gz
          max_file <- which.max(file.info(list.files("tmp",full.names = T,recursive = T))[,1])
          this_files <- list.files("tmp",full.names = T,recursive = T)[max_file]
          if(is.na(this_files) || file_ext(this_files) == "tar" || length(this_files) == 0) {
            system("rm -R tmp/*")
            this_filename <- gsub(".gz","",basename(x))
            try(system(paste("gunzip -c ", x, " > tmp/",this_filename,sep="")),silent = T)
            max_file <- which.max(file.info(list.files("tmp",full.names = T,recursive = T))[,1])
            this_files <- list.files("tmp",full.names = T,recursive = T)[max_file]
            this_delim <- reader::get.delim(this_files)
            tmp_z <- tryCatch(read.delim(paste0(this_files),header = T,row.names = NULL,check.names = F,sep=this_delim),error = function(e) 0)
            upload_type <<- "CellGene"
            return(tmp_z)
          }
          
          max_file <- which.max(file.info(list.files("tmp",full.names = T,recursive = T))[,1])
          this_files <- list.files("tmp",full.names = T,recursive = T)[max_file]
          
          
          # incase folder contains 10X files
          tmp_x <- tryCatch(Read10X(gsub(basename(this_files),"",this_files)),error = function(e) 0)
          
          if (typeof(tmp_x) == "S4") {
            system("rm -R tmp/*")
            return(tmp_x)
          } else if(file_ext(this_files) == "h5" || file_ext(this_files) == "hdf5") {
            tmp_y <- tryCatch(Read10X_h5(this_files),error = function(e) 0)
            upload_type <<- "TenX.h5"
            system("rm -R tmp/*")
            return(tmp_y)
          } else {
            this_delim <- reader::get.delim(this_files)
            tmp_z <- tryCatch(read.delim(paste0(this_files),header = T,row.names = NULL,check.names = F,sep=this_delim),error = function(e) 0)
            upload_type <<- "CellGene"
            system("rm -R tmp/*")
            return(tmp_z)
          }
          
        }
        
        tryCatch(file.rename(all_files[barcode_file],paste("barcodes",gsub(".*barcodes","",all_files[barcode_file]),sep = "")),error = function(e) 0)
        tryCatch(file.rename(all_files[matrix_file],paste("matrix",gsub(".*matrix","",all_files[matrix_file]),sep = "")),error = function(e) 0)
        tryCatch(file.rename(all_files[gene_file],paste("genes",gsub(".*genes","",all_files[gene_file]),sep = "")),error = function(e) 0)
        tryCatch(file.rename(all_files[feature_file],paste("features",gsub(".*features","",all_files[features]),sep = "")),error = function(e) 0)
        
        tmp_x<-tryCatch(Read10X(getwd()),error = function(e) {
          all_files <- list.files(getwd())
          barcode_file <- grep("barcodes",all_files)
          matrix_file <- grep("matrix",all_files)
          gene_file <- grep("genes",all_files)
          feature_file <- grep("features",all_files)
          try(system(paste("gunzip",(all_files[barcode_file]))),silent = T)
          try(system(paste("gunzip",(all_files[matrix_file]))),silent = T)
          try(system(paste("gunzip",(all_files[gene_file]))),silent = T)
          try(system(paste("gunzip",(all_files[feature_file]))),silent = T)
          try(system(paste("unzip",(all_files[barcode_file]))),silent = T)
          try(system(paste("unzip",(all_files[matrix_file]))),silent = T)
          try(system(paste("unzip",(all_files[gene_file]))),silent = T)
          try(system(paste("unzip",(all_files[feature_file]))),silent = T)
        })
        tmp_x<-tryCatch(Read10X(getwd()),error = function(e){
          0
        })
        return(tmp_x)
      } else if(read.method == "CellGene"){# read in cell * gene matrix, if there is error report, back to 18 line to run again.
        tmp_x<-read.delim(x,header = T,row.names = NULL,check.names = F,sep=sep,...)
        
        return(tmp_x)
      }
    }
  }else {stop("Missing 'x' argument, please input correct data")}
}


