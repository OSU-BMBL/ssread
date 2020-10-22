[[toc]]



# Usage
----
The scREAD database includes six parts

- Home
  - Pie charts that reflect ratio distribution in 73 datasets for each of the four factors (species, condition, region, and gender)
  - Search differentially expressed genes
  - Dataset overview
- Dataset details
  - General overview of the dataset including dataset source, and other datasets from the same experiment
  - Interactive UMAP plot for cell types, subclusters, and specific gene expression
  - Differential expression and Gene set enrichment analysis
  - Cell-type-specific regulon inference
- Browse control atlas
  - 23 control atlases from different brain regions of human and mouse species
- Submit
  - Submit user's AD scRNA-Seq & snRNA-Seq datasets into scREAD to do the same analysis as shown in our database
- Help
  - Frequently asked questions
  - Usage
  - Contact
- Download 
  - Download raw and processed datasets
  - Steps to run scREAD backend workflow locally


## Home page
----

![Home](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/Home6.jpg)
 
1. General statistical information of all scRNA-Seq & snRNA-Seq datasets that are covered in scREAD. The pie charts represent four factors of distribution: species, control/disease condition, brain region, and gender.
2. Options to filter presented datasets.
3. Download the current presented table or reset all filters to display all datasets.
4. Each column is sortable by clicking column names.
5. A floating dialog for data set overview will pop up when users click on each row, users can then navigate to the details page.
6. Navigate to different pages or control how many queries on one page. 
7. scREAD will return all differential gene expression results queries for a gene.

## Example result illustration
-------
We used [AD00103](https://bmbls.bmi.osumc.edu/scread/AD00103) this dataset to showcase, it consists of 6,629 cells comes from the human AD female prefrontal cortex region in [Mathys, et al.](https://pubmed.ncbi.nlm.nih.gov/31042697/) research.

This tutorial will guide you through the analysis result page of scREAD in detail.

### General information
----
The general information of this dataset is shown in the first section of the analysis result page. This section includes four parts: Overview, Dataset information, Dataset source, and Datasets from the same experiment.

![General information](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/General_information2.jpg)

1. Overview of current dataset: 'scREAD Data ID', 'Species', 'Region', 'Condition', 'Braak Stage', 'Gender', and 'Age'. 
2. The number of identified cell types, control-like cells, and AD-associated cells.
3. General information of the corresponding research paper for this dataset. 
4. All other datasets that are included in the same experiment or publication. 
5. A dialog will appear when users click on the scREAD Data ID, then users can click the 'DETAILS' button to go to the analysis result page of the corresponding dataset. 


### Cell clustering
----
Two high-resolution UMAP plots show the predicted cell types and the expression distribution of all genes in this dataset, respectively.

![Cell clustering](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/Cell_clustering4.jpg)

1. Users choose one of these cell types, the following UMAP will change to the UMAP of predicted subclusters for this specific cell type.
2. The ARI score is used to evaluate the performance of our predicted cell types compared with the original cell labels from the original paper. Note: If we don't have the ARI score, it will show a silhouette score instead.
3. A sliding bar is used for controlling the size of each point in the following UMAP. It ranges from 1 to 10, the bigger the number is, the larger the point size is.
4. This function bar contains several quick buttons for graphic operations.
5. Hover cursor on cell points will display cell type, cell name, and the UMAP coordinates.
6. The legend of this UMAP plot.
7. The genes in the drop-down bar are all genes expressed in this dataset, and users can also input the name of genes that they're interested in. The darker the color is in this UMAP, the higher the expression value of the gene. 


### Differential expression (DE) / Gene set enrichment
-----
![DE1](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/DE1022.jpg)

1. DE testing groups for browsing cell type specific genes, subcluster specific genes, and DE genes from the cross-dataset comparison.
    ![DE2](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/DE2.jpg)

2. Choose the cell type of interest in DE testing..
3. The Log2 fold-change ranges from 0 to 5.
4. The Adjusted p-value ranges from 10^-6 to 1.
5. The DE direction can be filtered by all DE genes, only up-regulated genes, or only down-regulated genes.
6. Users can search for genes that they are interested in, and then the following table will return the matching result.
7. Download the currently listed table.
8. [Genecards](https://www.genecards.org) database is linked to each gene in the table.
9. Set how many rows should the table show. 
 
10.   KEGG pathway enrichment analysis result table of the DEGs will appear when users click the inverted triangle, and this table can be downloaded when they click the 'Download' button. When users click the reversed triangle at the end of each row in this table, it shows the genes that are enriched on this pathway, and this table can be downloaded when they click the 'Download' button. Users can also search for a specific item by entering the content they want to search in the search box.  
 ![DE2](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/DE3.jpg)
![KEGG](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/KEGG.jpg)

11.   GO biological process analysis result of the DEGs. Please see entry 10 to know how to use it. 
12.   GO molecular function analysis result of the DEGs. Please see entry 10 to know how to use it. 
13.   GO cellular component analysis result of the DEGs. Please see entry 10 to know how to use it. 
14.   Cell-type-specific regulon analysis result table of this dataset will appear when users click the inverted triangle, and this result only shows up when they choose the 'Cell type specific genes' in the 'Group' drop-down bar.
 ![DE3](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/DE4.png)
    This is the cell-type-specific regulon result table for each cell type, and this table can be downloaded when you click the 'Download' button.
  
    

   


## Browse control atlas page
----
The 'Browse control atlas' page contains all the 23 control atlases that were stored in the scREAD based on different brain regions for different species and different mice ages.

![Healthy atlas](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/B1.jpg)

These are 23 control atlases entries. The default pattern is all the UMAP of control atlases are folded, however, users can click the reverses triangle to unfold the UMAP of each control atlas. The top five control and bottom five atlases are human control atlases, and the rest control atlases are mouse control atlases. 

## Submit page
-------
The submission of a new entry is welcome, and it can be done on the “submit” page. One scRNA-Seq file of AD disease should be uploaded, and one scRNA-Seq file of control can be uploaded or not.

![Submit](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/submit3.jpg)

1. Upload your AD scRNA-Seq expression matrix file by selecting the file stored on your computer.
Note: This file is required if you want to analyze new data.
Note: The format of your uploaded file should be a text format.
2. You can provide species, gender, brain region, and Braak stage these four types of information of your input gene expression dataset to scREAD.
3. You can select one of the control datasets as a reference control atlas to do the downstream analysis by choosing 'Select from scREAD controls' option.
4. These are all the 23 control files that are stored in scREAD to produce all control atlas.
5. You can also upload your control dataset if you have one to do the comparison within your own paired dataset by selecting 'Upload control data' and then click the bar.
6. If you have any comments about scREAD, we will be appreciative that you can write your comments here.
7. Clicking this option, it means you allow us to store your data in scREAD (both datasets and results) for future database construction. Be cautious if your data have not been published.
8. An email is not required to submit the job; however, we strongly suggest you provide your email because the data you uploaded will be processed by our analyst manually. So you will be noticed by email when the job is done.
9. Submit the job once everything is ready.  If you have provided your email to us you will receive an email after you submit your job successfully. The job ID is in the showed up floating window, which can be used to retrieve the results.
    ![Submit](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/jobid.png)

10. You can reset all the input information by clicking this button and restart over again.
11. You can input the job ID here and retrieve the analysis result after the work is done.


## Download page
-----
Not all the datasets in scREAD are available to download for users.  On the “Download” page, datasets that downloaded from the GEO database are available to download, but datasets downloaded from Synapse are not available to download.

![Download](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/Download1.jpg)

It provides three formats of files for users to download. For the gene expression matrix file, it provides two formats, that is fst format and txt format, for users to download. For the Seurat read in a file, it provides the processed Seurat object format, that is rds format file, for users to download.








