[[toc]]

# Usage 

- Home
  
  - Flow diagram of available spatial and scRNA-seq datasets.
  
  - Bar graph of datasets available from each brain region.
  
  - Pie cart of available study types and conditions.
  
  - Interactive plot for visualizing cell types and spatial layers.

- Browse
  
  - scRNA-seq datasets: 172 datasets, 34 studies, 18 brain regions, and 2,194,144 cells.
  
  - Spatial Transcriptomics datasets: 300 spatial datasets, 10 studies, and 17 brain regions.
  
  - Sort by species, brain region, and experimental factors.

- Query
  
  - Search differentially expressed genes.
  
  - Find overlapping differentially expressed genes from multiple comparisons from a cell type of interest in a specific brain region and set your own parameters.

- Help
  
  - Usage
  
  - Frequently asked questions
  
  - Contact
  
  - News: updates on ssREAD

- Download
  
  - Download raw and processed datasets.
  
  - Steps to run ssREAD backend workflow locally.

- Version 1 (Archived)
  
  - Explore ssREAD version 1.

# scRNA-seq Result Illustration

We used [AD00103](https://bmblx.bmi.osumc.edu/ssread/AD00103) this dataset to showcase, it consists of 6,629 cells comes from the human AD female prefrontal cortex region in [Mathys, et al.](https://pubmed.ncbi.nlm.nih.gov/31042697/) research.

This tutorial will guide you through the analysis result page of ssREAD in detail.

### General information

The general information of this dataset is shown in the first section of the analysis result page. This section includes four parts: Overview, Dataset information, Dataset source, and Datasets from the same experiment.

![General information](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/General_information2.jpg)

1. Overview of current dataset: 'ssREAD Data ID', 'Species', 'Region', 'Condition', 'Braak Stage', 'Gender', and 'Age'.
2. The number of identified cell types, control-like cells, and AD-associated cells.
3. General information of the corresponding research paper for this dataset.
4. All other datasets that are included in the same experiment or publication.
5. A dialog will appear when users click on the ssREAD Data ID, then users can click the 'DETAILS' button to go to the analysis result page of the corresponding dataset.

### Cell clustering

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

10. KEGG pathway enrichment analysis result table of the DEGs will appear when users click the inverted triangle, and this table can be downloaded when they click the 'Download' button. When users click the reversed triangle at the end of each row in this table, it shows the genes that are enriched on this pathway, and this table can be downloaded when they click the 'Download' button. Users can also search for a specific item by entering the content they want to search in the search box.  
     ![DE2](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/DE3.jpg)
    ![KEGG](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/KEGG.jpg)

11. GO biological process analysis result of the DEGs. Please see entry 10 to know how to use it.
12. GO molecular function analysis result of the DEGs. Please see entry 10 to know how to use it.
13. GO cellular component analysis result of the DEGs. Please see entry 10 to know how to use it.
14. Cell-type-specific regulon analysis result table of this dataset will appear when users click the inverted triangle, and this result only shows up when they choose the 'Cell type specific genes' in the 'Group' drop-down bar.
    ![DE3](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/DE4.png)
    This is the cell-type-specific regulon result table for each cell type, and this table can be downloaded when you click the 'Download' button.

# Spatial Transcriptomics Result Illustration

---

We used the dataset [ST00109](https://bmblx.bmi.osumc.edu/scread/spatial/ST001) to showcase the functions of the database. It comes from the dorsolateral prefrontal cortex region of a 30-year-old, caucasian female in a non-diseased state in [Maynard, et al.](https://urldefense.com/v3/__https://www.nature.com/articles/s41593-020-00787-0__;!!AU3bcTlGKuA!HID7VJHq0bXFFkn14kCZH6wF3KzbE46Ik0TMhiwrVypDUObnlvF952rZdr6zjJMkm5gW4UF06apnILhAbCndhr2Q_HeFA91V$ ) research. 

This tutorial will guide you through the analysis result page of ssREAD in detail.

## General Information

The summary of this dataset is shown in the first section of the analysis result page. This section includes two parts: (1) Publication and (2) Study design.

   ![](./docs/images/Summary.png#center)

1. **Publication Overview:** 'Title', 'Date published', 'Date added', 'Abstract', 'Protocol', and 'Data'.

2. **Study Design:** 'Species', 'Number of Samples', 'Region', 'Experimental factors', 'Description', and 'Figure: Spatial transcriptomics in DLPFC using Visium'.

## Spot-level data

The 'Spot-level data' section allows users to select specific samples from the dataset and manipulate interactive UMAP plots that show predicted cell types, the expression and distribution of genes, and the number of  spots of each cell type.

   ![](./docs/images/spot_level.png#center)


1. Users select their desired sample from the dataset. For this example, ST00109 was used. The following UMAP will change to the UMAP of predicted subclusters for this specific sample.

2. Choose to plot by layer or cluster.

3. View the processed or raw image.

4. A sliding bar is used to control the size of each point in the UMAP. It ranges from 1 (smallest) to 10 (largest).

5. This function bar contains several quick buttons for graphic operations.

6. A sliding bar is used to control the opacity of the underlying raw image and the plotted points. It ranges from 1 (translucent) to 10 (completely opaque) for both functions.

7. Hover the cursor on cell points to display cell type, cell name, and UMAP coordinates.

8. Hover the cursor on cell points to display cell type, cell name, and UMAP coordinates.

9. The legend of this UMAP plot.

10. Hover the cursor on a bar to display the number of spots and cell type.

11. Select or search a gene of interest to plot the gene expression value on the UMAP plot. A darker point will indicate a higher expression value.

## Spatially variable genes

   ![](./docs/images/Spatially_variable_gene.png#center)

1. Users select their desired sample from the dataset. For this example, ST00109 was used.

2. A sliding bar is used to change the Log2 fold-change cutoff. This ranges from 0 to 5.

3. A sliding bar is used to vary the adjusted p-value from 10^-6 to 1.

4. The foldchange direction can be filtered by all spatially variable genes, only up-regulated genes, or only down-regulated genes.

5. Users can search for genes that they are interested in, and then the following table will return the matching result.

6. Download or copy the currently listed table.

7. [Genecards](https://urldefense.com/v3/__https://www.genecards.org/__;!!AU3bcTlGKuA!HID7VJHq0bXFFkn14kCZH6wF3KzbE46Ik0TMhiwrVypDUObnlvF952rZdr6zjJMkm5gW4UF06apnILhAbCndhr2Q_KyeIINe$ ) database is linked to each gene in the table.

8. Set how many rows the table shows.

## Differential expression (DE)/ Gene set enrichment

   ![](./docs/images/DE.png#center)

1. Users select their desired sample from the dataset. For this example, ST00109 was used.

2. Users select to either cluster specific genes or layer specific genes between two sets of cells.

3. Users select the cell type to perform differential analysis.
   
      ![](./docs/images/group_DE.png#center)

4. The Log2 fold-change ranges from 0 to 5.

5. The Adjusted p-value ranges from 10^-6 to 1.

6. Users can search for genes that they are interested in, and the table will return matching results.

7. Users can download or copy the table.

8. [Genecards](https://urldefense.com/v3/__https://www.genecards.org/__;!!AU3bcTlGKuA!HID7VJHq0bXFFkn14kCZH6wF3KzbE46Ik0TMhiwrVypDUObnlvF952rZdr6zjJMkm5gW4UF06apnILhAbCndhr2Q_KyeIINe$ ) database is linked to each gene in the table.

9. Users can set how many rows are shown in the table.

10. The DE direction can be filtered by all DE genes, only up-regulated genes, or only down-regulated genes.

11. KEGG pathway enrichment analysis result table **B** of the DEGs will appear when the user clicks the drop-down arrow **(a)**. This table can be downloaded or copied when the user clicks on the 'Download' or 'Copy DEG' button **(b)**. If the user clicks on the drop-down arrow **(c)** in table **B**, they can see the genes that are enriched on this pathway. This table can also be copied or downloaded by clicking 'Download' or 'Copy DEG'. Users can click on the links to [UNIPROT](https://urldefense.com/v3/__https://www.uniprot.org/__;!!AU3bcTlGKuA!HID7VJHq0bXFFkn14kCZH6wF3KzbE46Ik0TMhiwrVypDUObnlvF952rZdr6zjJMkm5gW4UF06apnILhAbCndhr2Q_FVxZVER$ ) or [GENECARDS]([https://urldefense.com/v3/__https://www.genecards.org/*(https:/*www.genecards.org/)__;XS8!!AU3bcTlGKuA!HID7VJHq0bXFFkn14kCZH6wF3KzbE46Ik0TMhiwrVypDUObnlvF952rZdr6zjJMkm5gW4UF06apnILhAbCndhr2Q_P8Rstk_$ ) to view the results for each gene in these databases **(d)**.

![](./docs/images/kegg_pathway.png#center)

1.  GO Biological Process analysis result of the DEGs. Entry 11 above can be used to navigate this feature.

2.  GO Molecular Function analysis result of the DEGs. Entry 11 above can be used to navigate this feature.

3.  GO Cellular Component analysis result of the DEGs. Entry 11 above can be used to navigate this feature.

## Deconvolution

   ![](./docs/images/deconvolution.png#center)

1. Users select desired spatial transcriptomics sample from the dataset. For this example, ST00109 was used.

2. Users select desired scRNA-seq dataset to compare to the spatial sample and perform cell-type deconvolution.

3. Average gene expression (scaled 0-1) for each spot from a mixture of cells of potentially heterogeneous cell types. The outputs are the estimated cell-type composition across spatial locations for the corresponding scRNA-seq dataset.

4. Correlations in proportions of cell-types across spatial locations between cell-type pairs, where correlations range from -1 (dark sage green) to 1 (burgundy).
# Query

---

The 'Query' page allows users to search for specific DEGs by using different filters. Users can also find overlapping DEGs from multiple comparisons.

   ![](./docs/images/query.png#center)

1. Users can search for a differentially expressed gene of their choice. For this example, GPR98 was used.

2. Users can click the drop-down arrow to filter by species: human or mouse.
   
   ![](./docs/images/humanvmouse.png#center)

3. Users can click the drop-down arrow to filter by experimental condition: control or disease.
   
   ![](./docs/images/controlvdis.png#center)


4. Users can click the drop-down arrow to filter by comparison type: cell type specific, subcluster specific, or cross dataset comparison.
   
   ![](./docs/images/comparisontype.png#center)

5. Users can click the drop-down arrow to filter by subject sex.
   ![](./docs/images/sex.png#center)

6. Users can click the drop-down arrow to filter by cell type.
   
   ![](./docs/images/celltype.png#center)
   

7. Users can click the drop-down arrow to filter by brain region.
   
   ![](./docs/images/brainregion.png#center)

8. Users can click the 'Download Current Table' button to download the produced table.

9. Users can click the 'Reset Filter' button to erase their selected filters and return to default.

10. Users can select from the drop-down menu what species (mouse or human) they want to search for when finding overlapping DEGs from multiple comparisons.

11. Users can select from the drop-down menu what brain region they want to search for when finding overlapping DEGs from multiple comparisons.

12. Users can input the number of comparisons threshold for their overlapping DEGs search.

13. Users can input the number of top DEGs they want to see in their overlapping DEGs search.

14. The DE direction can be filtered by all DE genes, only up-regulated genes, or only down-regulated genes.

15. Click the 'Search' button to produce results of overlapping DEGs from multiple comparisons.

