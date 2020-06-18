[[toc]]

# FAQ
---
This is the FAQ of scREAD. This list of questions is not exhaustive. If you have any other questions you can’t find the answer to please email any author in the Contact]() page to ask.

## What is Alzheimer's disease?
Alzheimer's disease (AD) is the most common cause of dementia, accounting for an estimated 60% to 80% of cases. Currently, there are an estimated 5.8 million Americans age 65 or older suffering from AD. Difficulty in remembering recent conversations, names or events is often an early clinical symptom. The hallmark pathologies of Alzheimer’s disease are the accumulation of the protein fragment beta-amyloid (plaques) outside neurons in the brain and twisted strands of the protein tau (tangles) inside neurons. These changes are accompanied by the death of neurons and damage to brain tissue. Alzheimer's is a slowly progressive brain disease that begins many years before symptoms emerge. Unfortunately, there are no effective therapeutics for the prevention and treatment of the disease. (2020 Alzheimer’s Disease Facts and Figures)

## What is single-cell RNA sequencing?
Single-cell RNA sequencing (scRNA-Seq) examines the dynamic transcriptomic profile of individual cells with next-generation sequencing technologies, hence, provide a higher resolution of cellular differences and a better understanding of the function of an individual cell in the context of its microenvironment. The scRNA-Seq can reveal complex and rare cell populations, uncover regulatory relationships between genes, and track the trajectories of distinct cell lineages in development. The scRNA-Seq is becoming widely used across biological disciplines including neuroscience. More recently, scRNA-Seq has been used in the field of AD and significantly improves our understanding of the pathogenesis of AD at the single-cell level.

## What is scREAD?
scREAD (**s**ingle-**c**ell **R**NA-S**e**q database for **A**lzheimer's **D**isease), as far as we know, is the first database dedicated to the management of all existing scRNA-Seq and single-nucleus RNA-sequencing (snRNA-Seq) datasets from human postmortem brain tissue with AD and mouse models with AD pathology. By manually curating 11 AD related studies, five scRNA-Seq datasets and seven snRNA-Seq datasets were retrieved with the following factors well annotated, i.e., organism, gender, brain region, disease/control, and age information. scREAD re-defines the 12 scRNA-Seq & snRNA-Seq datasets into 55 datasets (in total 579,392 cells and eight cell types), each of which corresponds to a specific organism (human or mouse), gender (male or female), brain region (entorhinal cortex, prefrontal cortex, superior frontal gyrus, cortex, cerebellum, cerebral cortex, or hippocampus), disease or control, and age stage (7 months, 15 months, or 20 months). These datasets have been published and freely accessible in the public domain as of June 1st, 2020. Furthermore, scREAD provides comprehensive analysis results and interactive visualizations based on all the collected AD datasets. Moreover, scREAD allows users to submit a new dataset to reproduce all the analyses results showcased in scREAD in support of their AD research. 

## Which species are covered in scREAD?
Human and Mouse.

## Which brain regions are covered in scREAD?
For human species, the scREAD covers three regions. For mouse species, the scREAD covers five regions. The detailed information is shown in the following table:

| Species | Region                 | Braak stage |
| ------- | ---------------------- | ----------- |
| Human   | Entorhinal Cortex      | 0, 2, 4 - 6 |
| Human   | Prefrontal cortex      | 1 - 6       |
| Human   | Superior frontal gyrus | 0, 2, 6     |
| Mouse   | Cortex                 | NA          |
| Mouse   | Cerebellum             | NA          |
| Mouse   | Cerebral cortex        | NA          |
| Mouse   | Hippocampus            | NA          |
| Mouse   | Prefrontal cortex      | NA          |

## Which type of data are covered in scREAD?
The scREAD contains four human and eight mouse AD scRNA-Seq & snRNA-Seq datasets that are collected from [GEO](https://www.ncbi.nlm.nih.gov/geo/) and [Synapse](https://www.synapse.org/#) databases as of June 1st, 2020. The detail information is shown in the following table

| Species | Data_ID     | Pubmed_ID      | Publication                                                                                                                                                                                                                       |
| ------- | ----------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Human   | GSE138852   | PMID: 31768052 | Grubman A, Chew G, Ouyang JF, Sun G et al. A single-cell atlas of entorhinal cortex from individuals with Alzheimer's disease reveals cell-type-specific gene expression regulation. Nat Neurosci 2019 Dec;22(12):2087-2097.      |
| Human   | syn18485175 | PMID: 31042697 | Mathys, H., Davila-Velderrain, J., Peng, Z. et al. Single-cell transcriptomic analysis of Alzheimer’s disease. Nature 570, 332–337 (2019). https://doi.org/10.1038/s41586-019-1195-2                                              |
| Human   | GSE147528   | NA             | Leng K, Li E, Eser R, et al. Molecular characterization of selectively vulnerable neurons in Alzheimer’s Disease. bioRxiv; 2020. DOI: 10.1101/2020.04.04.025825.                                                                  |
| Human   | syn21125841 | PMID: 31932797 | Zhou Y, Song WM, Andhey PS, Swain A et al. Human and mouse single-nucleus transcriptomics reveal TREM2-dependent and TREM2-independent cellular responses in Alzheimer's disease. Nat Med 2020 Jan;26(1):131-142.                 |
| Mouse   | GSE98969    | PMID: 28602351 | Keren-Shaul H, Spinrad A, Weiner A, Matcovitch-Natan O et al. A Unique Microglia Type Associated with Restricting Development of Alzheimer's Disease. Cell 2017 Jun 15;169(7):1276-1290.e17.                                      |
| Mouse   | GSE103334   | PMID: 29020624 | Mathys H, Adaikkan C, Gao F, Young JZ et al. Temporal Tracking of Microglia Activation in Neurodegeneration at Single-Cell Resolution. Cell Rep 2017 Oct 10;21(2):366-380.                                                        |
| Mouse   | GSE130626   | PMID: 31902528 | Nugent AA, Lin K, van Lengerich B, Lianoglou S et al. TREM2 Regulates Microglial Cholesterol Metabolism upon Chronic Phagocytic Challenge. Neuron 2020 Mar 4;105(5):837-854.e9.                                                   |
| Mouse   | GSE141044   | PMID: 31928331 | Zhong S, Wang M, Zhan Y, Zhang J et al. Single-nucleus RNA sequencing reveals transcriptional changes of hippocampal neurons in APP23 mouse model of Alzheimer's disease. Biosci Biotechnol Biochem 2020 May;84(5):919-926.       |
| Mouse   | GSE140510   | PMID: 31932797 | Zhou Y, Song WM, Andhey PS, Swain A et al. Human and mouse single-nucleus transcriptomics reveal TREM2-dependent and TREM2-independent cellular responses in Alzheimer's disease. Nat Med 2020 Jan;26(1):131-142.                 |
| Mouse   | GSE140399   | PMID: 31932797 | Zhou Y, Song WM, Andhey PS, Swain A et al. Human and mouse single-nucleus transcriptomics reveal TREM2-dependent and TREM2-independent cellular responses in Alzheimer's disease. Nat Med 2020 Jan;26(1):131-142.                 |
| Mouse   | GSE143758   | PMID: 32341542 | Habib, N., McCabe, C., Medina, S. et al. Disease-associated astrocytes in Alzheimer’s disease and aging. Nat Neurosci (2020). https://doi.org/10.1038/s41593-020-0624-8                                                           |
| Mouse   | GSE147495   | PMID: 32320664 | Lau SF, Chen C, Fu WY, et al. IL-33-PU.1 Transcriptome Reprogramming Drives Functional State Transition and Clearance Activity of Microglia in Alzheimer's Disease. Cell Rep. 2020;31(3):107530. doi:10.1016/j.celrep.2020.107530 |

## How many data files are covered?
The scREAD contains 55 files in total, which are redefined from 12 existing human and mouse AD scRNA-Seq & snRNA-Seq datasets from the public domain.  These files are redefined according to species, gender, brain region, disease or control, and age. The number of cells in each of these 55 files is shown in the following figure. The x-axis represents the number of cells of each file, and the y-axis represents the file names of these 55 files. The color intensity of the bar stands for the number of cells, i.e. the lighter of the color represents the more cell numbers in the corresponding file.

![barplot](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/barplot.jpg)

The following figure represents the distribution of the species, gender, condition, and brain region for these 55 files.
 - For the top left panel in this figure, the x-axis represents the species are covered in the 55 files, and the y-axis represents the numbers of files for human and mouse species. The color of the bar stands for the number of files, the lighter the color is the more files in the corresponding factor.
 - For the top right panel in this figure, the x-axis represents the gender information is covered in the 55 files, and the y-axis represents the numbers of files for each element. The color of the bar stands for the number of files, the lighter the color is the more files in the corresponding factor.
 - For the bottom left panel in this figure, the x-axis represents the condition information is covered in the 55 files, and the y-axis represents the numbers of files for each element. The color of the bar stands for the number of files, the lighter the color is the more files in the corresponding factor.
 - For the bottom right panel in this figure, the x-axis represents the numbers of files for each element, and the y-axis represents the brain regions that are covered in the 55 files. The color of the bar stands for the number of files, the lighter the color is the more files in the corresponding factor.

![barplot](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/markdown.jpg)


## How can we define different mouse age stages?
The choice of rodent age should be given more consideration, as it improves the quality and relevance of the data obtained, and reduces variability. As for the age of mice used, it depends on the development or senescence of the system being studied. For example, [Flurkey et al.](https://www.elsevier.com/books/the-mouse-in-biomedical-research/fox/978-0-12-369457-7) defined a mature adult C57BL6/J mouse as 3–6 months (equivalent in this analysis to 20–30 human years), a middle-aged mouse as 10–14 months (equivalent to 38–47 human years) and an old mouse as 18–24 months (equivalent to 56–69 human years). We therefore define the different mouse age stages in our database as shown in the following table:

| Age_Stage | Ranger of ages |
| --------- | -------------- |
| 2 months  | 1-2 months     |
| 7 months  | 4-8 months     |
| 15 months | 10-15 months   |
| 20 months | 20 months      |

## What is healthy atlas?
We constructed 15 healthy cell atlas of human and mouse based on the 12 datasets, which cover eight brain regions, two genders, and three different mouse age stages. Cell types of this 15 healthy atlas were clustered using Seurat and SCINA based on known cell type markers that collected from literature and [PanglaoDB](https://panglaodb.se).

## Which cell types are covered in scREAD?
There are eight cell types covered in our database. They are Astrocytes, Endothelial cells, Excitatory neurons, Inhibitory neurons, Microglia, Oligodendrocytes, Oligodendrocyte precursor cells, and Pericytes.

## What is differential expression?
We categorized the experiments for differential expression as one of the following conditions: control versus AD and AD versus AD in the same species under same gender and age. The differential expression analysis under each condition can be accessed through the Seurat FindMarkers function. All results were scaled by cell types and presented in the tables, allowing users to explore the expression of interesting genes in different conditions.
The cases how to achieve differential expressed genes bewteen different conditions (Condition 1 v.s. Condition 2) for diverse cell types in scREAD are showed in the following table:
| Species | If in the same region | Condition 1 | Condition 2 |
| ------- | --------------------- | ----------- | ----------- |
| Human   | Yes                   | Control     | Disease     |
| Mouse   | Yes                   | Control     | Disease     |
| Human   | Yes                   | Disease     | Disease     |
| Mouse   | Yes                   | Disease     | Disease     |
| Human   | No                    | Disease     | Disease     |
| Mouse   | No                    | Disease     | Disease     |

Note: The comparisions are all in the same gender and age.

## What is enrichment analysis?
Enrichment analysis is a computational method for inferring knowledge about an input gene set by comparing it to annotated gene sets representing prior biological knowledge. Enrichment analysis checks whether an input set of genes significantly overlaps with annotated gene sets. For more information, you can read this excellent review about enrichment analysis [here](https://pubmed.ncbi.nlm.nih.gov/19033363/).

## What are regulons and cell-type-specific regulons (CTSRs) and why are they important?
The term regulon was first introduced by Maas et al. in 1964, intended to name a maximal group of co-regulated genes, which may be scattered in a genome without apparent patterns in terms of their genomic locations. Based on that, cell-type-specific regulon was defined as a group of genes, receiving similar regulatory signals in a specific cell type, hence tend to have similar expression patterns and share conserved motifs in this cell type. A successful elucidation of CTSRs will substantially improve the identification of transcriptionally co-regulated gene modules, realistically allowing reliable prediction of global transcription regulation networks encoded in a specific cell type.

## What is IRIS3?
IRIS3 (Integrated Cell-type-specific Regulon Inference Server from Single-cell RNA-Seq) is an easy-to-use server empowered by over 20 functionalities to support comprehensive interpretations and graphical visualizations of identified CTSRs. CTSR data can be used to reliably characterize and distinguish the corresponding cell type from others and can be combined with other computational or experimental analyses for biomedical studies. CTSRs can, therefore, aid in the discovery of major regulatory mechanisms and allow reliable constructions of global transcriptional regulation networks encoded in a specific cell type. The broader impact of IRIS3 includes, but is not limited to, investigation of complex diseases hierarchies and heterogeneity, causal gene regulatory network construction, and drug development. IRIS3 is freely accessible from [https://bmbl.bmi.osumc.edu/iris3/](https://bmbl.bmi.osumc.edu/iris3/) with no login requirement. More information about this paper can be found [here](https://academic.oup.com/nar/advance-article/doi/10.1093/nar/gkaa394/5838867).

## What are the input files of the scREAD?
The required input file is a gene expression matrix with two acceptable formats, compressed files are encouraged to decrease the uploading time.
- A single txt, tsv or csv formatted gene expression matrix. The compressed format (gzip) is accepted
- An [hdf5 feature barcode matrix](https://support.10xgenomics.com/single-cell-atac/software/pipelines/latest/advanced/h5_matrices).
- The [three gzipped files](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/output/matrices) recording information of barcodes, features, and gene expressions in the 10X genomics output folder.

Identifiers can be represented as Gene Symbols (e.g., HSPA9), Ensembl Gene IDs (e.g., ENSG00000113013), or Transcript IDs (e.g., ENSMUST00000074805). Human and mouse genes are annotated with respect to the reference genome using the org.HS.eg.db R package and org.Mn.eg.db package, respectively.

## How to interpret the file names?
The file name is composed of six parts, they are species, condition, region, gender, age, and code numbers based on the string order of the file_name. Here are two examples showing how to read the file_name column:

| file_name                         | species | condition | region            | gender | age      | code_numbers |
| --------------------------------- | ------- | --------- | ----------------- | ------ | -------- | ------------ |
| M-H-Cerebellum-Male-7m            | Mouse   | Control   | Cerebellum        | Male   | 7 months | NA           |
| H-AD-Prefrontal cortex-Female_001 | Human   | Disease   | Prefrontal cortex | Female | NA       | 001          |

## How to interpret the data_id?
The data_id name is composed of three parts, they are Alzheimer's disease (the two letters), the region of different species (the first three numbers), and code numbers (the last two numbers). Here are two examples showing how to read data_id:

| data_id | Alzheimer's disease | Region                | code_number |
| ------- | ------------------- | --------------------- | ----------- |
| AD00101 | AD                  | region of mouse (001) | 01          |
| AD00402 | AD                  | region of human (004) | 02          |

## What is fst format?
Multithreaded serialization of compressed data frames using the 'fst' format. The 'fst' format allows for random access of stored data and compression with the LZ4 and ZSTD compressors created by Yann Collet.
You can see more information about Package ‘fst’ [here](https://cran.r-project.org/web/packages/fst/fst.pdf).

## Where the scREAD store the data uploaded by users?
We will ask for your permission when we want to store the data uploaded by you into our database. Then we will store the data in the background of our database.

## How can I submit my AD scRNA-Seq data to scREAD to do an analysis?
The users can submit their AD scRNA-Seq data as well as corresponded control data to scREAD to do all the analysis through Submit]() page.

## Where can I find the source code?
The source code of scREAD can be accessed on GitHub](http://).

## How can I download the datasets in scREAD?
The datasets of scREAD can be downloaded from Download](http://) page.

## What are the future plans of scREAD?
  - Collect more AD scRNA-Seq data from more brain regions, and build up healthy atlas in diverse brain regions of human, mouse and extend to other species.
  - Collect AD single-cell omics data, such as scATAC-seq data, and achieve more comprehensive analysis results based on single-cell multiple omics data.

## What computational tools are used in scREAD?
| Tools      | Publication                                                                                                                                                                                                                                                                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| IRIS3      | Anjun Ma, Cankun Wang, Yuzhou Chang, Faith H Brennan, Adam McDermaid, Bingqiang Liu, Chi Zhang, Phillip G Popovich, Qin Ma, IRIS3: integrated cell-type-specific regulon inference server from single-cell RNA-Seq, Nucleic Acids Research, , gkaa394, https://doi.org/10.1093/nar/gkaa394                                                        |
| Seurat     | Stuart T*, Butler A*, Hoffman P, Hafemeister C, Papalexi E, Mauck WM, Hao Y, Stoeckius M, Smibert P, Satija R. Comprehensive Integration of Single-Cell Data  Cell. 2019. DOI:https://doi.org/10.1016/j.cell.2019.05.031                                                                                                                          |
| Harmony    | Korsunsky, I., Millard, N., Fan, J. et al. Fast, sensitive and accurate integration of single-cell data with Harmony. Nat Methods 16, 1289–1296 (2019). https://doi.org/10.1038/s41592-019-0619-0                                                                                                                                                 |
| Polychrome | Coombes, K., Brock, G., Abrams, Z., & Abruzzo, L. (2019). Polychrome: Creating and Assessing Qualitative Palettes with Many Colors. Journal of Statistical Software, 90(Code Snippet 1), 1 - 23. doi:http://dx.doi.org/10.18637/jss.v090.c01                                                                                                      |
| Destiny    | Angerer P, Haghverdi L, Büttner M, Theis F, Marr C, Büttner F (2015). “destiny: diffusion maps for large-scale single-cell data in R.” Bioinformatics, 32(8), 1241 1242 1243. doi: 10.1093/bioinformatics/btv715, More information at <http://www.helmholtz-muenchen.de/icb/destiny>, http://bioinformatics.oxfordjournals.org/content/32/8/1241. |
| SCINA      | Zhang, Z., Luo, D., Zhong, X., Choi, J. H., Ma, Y., Wang, S., Mahrt, E., Guo, W., Stawiski, E. W., Modrusan, Z., Seshagiri, S., Kapur, P., Hon, G. C., Brugarolas, J., & Wang, T. (2019). Scina: Semi-supervised analysis of single cells in silico. Genes, 10(7), [531]. https://doi.org/10.3390/genes10070531                                   |

## What is the ...?
PCA + PCA

## What is the scREAD overall pipeline?
Our database organically integrates multiple state-of-the-art tools, including IRIS3, scran, Seurat, and IRIS-EDA. These tools are either reputed or have been justified with the best performance in the analytical area.

### 1. Construction of Human and Mouse healthy atlas
The scRNA-Seq datasets of Human and Mouse healthy atlas come from the 12 single-cell/nucleus RNA-seq datasets. Cell types of each atlas are predicted by using Seurat (version 3.1). The visualization of the healthy atlas is used is a manifold learning technique for dimension reduction method called [UMAP](https://github.com/lmcinnes/umap) (short for Uniform Manifold Approximation and Projection).

### 2. Identification of Human and Mouse disease cell types based on the healthy atlas
Not all cells collected from AD patient samples are malignant, there are heterogeneous cells within individual patients, that is, normal healthy cells are included. These healthy cells maintain distinct regulatory mechanisms and gene expression patterns compared to AD cells and will disturb the accurate identification of AD cell types. Thus, the removal of healthy cells from AD data is critical to identify real AD-associated cells. Using the Human and Mouse healthy atlas, we sought to project AD-associated cells onto the healthy atlas at single-cell resolution to identify Human and Mouse disease cell types. The AD disease cell types were then visualized using UMAP.

### 3. Identification of differentially expressed genes
Differentially expressed genes (DGEs) analysis in scREAD is performed using Seurat. The DGEs can be sent to perform the enrichment analysis against different functional annotation databases to identify the enriched GO functionalities, biological pathways, etc. The enrichment test is performed by Enrichr.

### 4. Identification of CTSRs
The CTSRs analysis in scREAD is performed using IRIS3. For each regulon, the regulon activity score (RAS) in a cell is calculated based on the rank of the expression value in the cell for all the involved genes. The regulon specificity score (RSS) for a cell type can then be calculated according to the entropy of RAS of cells inside the cell type compared to outside the cell type. An RSS ranges from 0 to 1, with a higher value representing a more significant specificity of this regulon in the cell type. An empirical p-value of a regulon’s RSS can be estimated by comparing it with the RSSs of randomly selected gene sets (having the same number of genes in this regulon through a bootstrap method) in the same cell type for 10,000 times. Regulon p-values will be Bonferroni-adjusted by multiplying the number of all the identified regulons in the exact cell type. Regulons with adjusted p-values less than 0.05 were considered as cell type-specific regulons. 






