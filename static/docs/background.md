[[toc]]

# The Basics of scREAD

## Pipeline Overview

![pipeline](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/1590522837804.jpg)

scREAD (A single-cell RNA-Seq database for Alzheimer's Disease) is a database that contains all existing Human and Mouse Alzheimer's Disease (AD) Single-cell RNA-Seq (scRNA-Seq) data as of June 1st.

## Input

1. scRNA-Seq gene expression matrix (Optional):
   The required input is gene expression data with two acceptable formats, compressed files are encouraged to decrease the uploading time. 1. A single txt, tsv or csv formatted gene expression matrix. The compressed format (gzip) is accepted 2. A single fst formatted gene expression matrix.

Identifiers can be represented as Gene Symbols (e.g., HSPA9), Ensembl Gene IDs (e.g., ENSG00000113013). Human and mouse genes are annotated with respect to the reference genome using the org.HS.eg.db R package and org.Mn.eg.db package, respectively.

2. Cell label file (Optional):a two-column matrix with the first column as the cell names exactly matching the gene expression file, and the second column as ground-truth cell clusters. The cluster indicator could either be terms (e.g. Excitatory neurons, Microglia) or numbers (e.g. 1,2). The cell label file will be used to evaluate the predicted cell types (evaluation omitted otherwise) and cell types inference (or use the predicted cell type instead).

## The overall pipeline includes four modules:

Our database organically integrates multiple state-of-the-art tools, including IRIS3, scran, Seurat, and IRIS-EDA. These tools are either reputed or have been justified with the best performance in the analytical area.

### Module 1: Human and Mouse healthy atlas

---

The AD scRNA-Seq data of Human and Mouse healthy atlas is downloaded from Gene Expression Omnibus (GEO) database and Synapse. Cell types are predicted in Seurat (version 3.1).

### Module 2: Prediction of Human and Mouse disease-associated cell clusters

Identify AD-associated cells. AD associated cells are projected into the healthy atlas using principal components analysis method in Seurat.

### Module 3: Identification of differentially expressed genes

Differentially expressed genes (DGEs) analysis in scREAD is performed using DESeq2. The DGEs can be sent to perform the enrichment analysis against different functional annotation databases to identify the enriched GO functionalities, biological pathways, etc. The enrichment test is performed by Enrichr.

### Module 4: Identification of cell cluster specific regulons

For each regulon, the regulon activity score (RAS) in a cell is calculated based on the rank of the expression value in the cell for all the involved genes. The regulon specificity score (RSS) for a cell type can then be calculated according to the entropy of RAS of cells inside the cell type compared to outside the cell type. An RSS ranges from 0 to 1, with a higher value representing a more significant specificity of this regulon in the cell type. An empirical p-value of a regulon’s RSS can be estimated by comparing it with the RSSs of randomly selected gene sets (having the same number of genes in this regulon through a bootstrap method) in the same cell type for 10,000 times. Regulon p-values will be Bonferroni-adjusted by multiplying the number of all the identified regulons in the exact cell type. Regulons with adjusted p-values less than 0.05 were considered as cell cluster specific regulons.
