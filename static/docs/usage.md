[[toc]]

# Tutorial

---

The scREAD database includes five pages, they are Home, Browse healthy atlas, Submit, Help, and Download. The 'Home' page contains four statistical pie charts reflect ratio distribution in 55 files for each of the four factors, and a table that contains all the information of 55 files. The 'Browse healthy atlas' page contains the 15 healthy atlases from different brain regions for human and mouse species. The 'Submit' page provides an interface that can let users can submit their AD scRNA-Seq & snRNA-Seq dataset into scREAD to do the same analysis as our database showed. The 'Help' page contains three modules, e.g., "FAQ", "Tutorial", and "Contact", users can find the corresponding information for each of these three modules. The 'Download' page provides the datasets that can be downloaded which are storing in scREAD.

## Home page

---

![Home](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/Home2.jpg)

1. Here is the general statistical information of all scRNA-Seq & snRNA-Seq datasets that are covered in scREAD. This is the pie charts of the species, control/disease condition, brain region, and gender information these four factors across 55 datasets from the left side to the right side, respectively. Each color in each pie chart represents each element, and the number represents the ratio for each element under each factor for 55 datasets. The scREAD contains a total of 579,392 cells across human and mouse species in eight different brain regions.

- For the pie chart of the species, there are 19 human species datasets across 55 datasets, and 36 mouse species datasets across 55 datasets.
- For the pie chart of the control/disease condition, there are five, 14, 10, and 26 datasets across 55 datasets for human control, human disease, mouse control, and mouse disease, respectively.
- For the pie chart of the brain region, there are six, 10, three, nine, two, five, 16, and four datasets across 55 datasets for human entorhinal cortex, human prefrontal cortex, human superior frontal gyrus, mouse cortex, mouse cerebellum, mouse cerebral cortex, mouse hippocampus, and mouse prefrontal cortex regions, respectively.
- For the pie chart of the gender, there are 12, seven, 29, and seven datasets across 55 datasets for the human male, human female, mouse male, and mouse female, respectively.

2. Here are all the options for the species, control/disease condition, brain region, and gender factors. The following table is the whole table of 55 datasets general information, the default show is the whole table and the human datasets information appears on the top, and it will show the searching result table based on users' choice. Users can select the 'All' option, then it will return searching results contain all elements. Users can select a single element option, then it will return searching results contain the single option that you choose.

Note: When users choose one of these factors, the corresponding searching result will be changed based on the factors that the users chose. And users can choose different factors at the same time, and the return result is the intersection of all the options that you choose.

3. When you click each row in this whole table, a floating window will show up. In this floating window, there is overview information of this dataset and you can click the "DETAILS" button and scREAD will jump into the analysis result page to browse the analysis results of this dataset, and you can also click "CANCEL" button to exit and choose another dataset to browse.

4. This is how many rows of the whole table that will show on the home page. The default number is 15, but users can choose another number that showed in the options bar.

## Example result illustration

---

We used AD00103 this data, which is consisting of 6,629 cells comes from the human AD female prefrontal cortex region in [Mathys, et al.](https://pubmed.ncbi.nlm.nih.gov/31042697/) paper, to showcase.

This tutorial will guide you through the analysis result page of scREAD in detail.

### General information

---

![General information](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/General_information.jpg)

The general information of this dataset is shown in the first section in the analysis result page. This section includes four-part, they are Overview, Dataset information, Dataset source, and Datasets from the same experiment.

1. The "Overview" part is the overall detail information of this dataset. It includes 'scREAD Data ID', 'Species', 'Region', 'Condition', 'Braak Stage', 'Gender', and 'Age' there seven information of current dataset. Here's the overview information of 'AD00103' this dataset.
2. The "Dataset information" part contains three entries, which are the number of cell types that are identified in this dataset, how many healthy-like cells, and how many AD-associated cells.
3. The "Dataset source" part is the general information for the corresponding paper of this dataset. It includes the title of this paper, the scRNA-Seq/snRNA-Seq technique is used in this paper, protocol, GEO/syn ID, Pubmed_ID, and how to cite this paper.
4. In the "Datasets from the same experiment" part, it lists all the datasets that are in the same experiment. All the datasets that are shown here come from the same paper, and usually, they contain control and disease datasets.
5. When users click the name of the scREAD Data ID, a floating window that includes the overview of this dataset that you choose will show up. Then you can click the 'DETAILS' button to jump into the analysis result page of the corresponding dataset. And you can also click the 'CANCEL' button, then the floating window will disappear.

### Cell clustering

---

![Cell clustering](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/Cell_clustering1.jpg)

Two high-resolution UMAP plots show the predicted cell types and the expression of cell type-specific differentially expressed genes, respectively.

1. There are seven predicted cell types which are shown in the drop-down bar. If you choose one of these cell types, then the following UMAP will change to the UMAP of predicted subclusters for this cell type.
2. The ARI score is used to evaluate the performance of our predicted cell types compared with the original cell labels from the original paper. The higher the score is, the more consistency between our predicted cell labels with the original cell labels.
3. A sliding bar is used for controlling the size of each point in the following UMAP. It ranges from 1 to 10, the bigger the number is, the larger the point size is.
4. This function bar contains several quick buttons for graphic operations. For example, the first button is 'Download plot as a png', you can click this button and this UMAP figure will be downloaded to your local computer automatically. For the 'Zoom in' and 'Zoom out' button, you can zoom in or zoom out this figure by clicking these two buttons. Furthermore, after you applied zoom in or zoom out in this figure if you want to back to the default figure, then you can click the 'Reset axes' button to let this figure back to the default status.
5. A floating window will show up when move your cursor on cells, indicating the belonging cell type, cell name, and the UMAP coordinate.
6. This is the legend of this UMAP figure.
7. All the cell type-specific differentially expressed genes are showed in the drop-down bar. The darker the color is in this UMAP, the expression value of this gene is higher. It also has a functional bar here, you can do the same thing in this UMAP as the cell type UMAP.

![General information](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/front_size1.jpg)

It is a UMAP of the predicted subclusters for microglia cell type. There are two predicted subclusters for microglia, e.g., microglia_0 and microglia_1. The point size of this UMAP can be adjusted by sliding left and right through the sliding bar. The default point size is 4. For the left panel, it shows the UMAP when the point size is 3, and for the right panel, it shows the UMAP when the point size is 10. The subclusters information is more clear after you increase the point size.

![General information](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/sub_cluster_genes.png)
All the genes in the drop-down bar are cell type-specific differentially expressed genes and are ranked based on the adjusted p-value that is calculated by Seurat on decreasing order.

### Differential expression (DE) / Gene set enrichment

---

![Home](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/DE.jpg)

1. There are five groups here. The default is 'Cell type specific group'. And the following choice will be changed as you choose different groups. For the current dataset, we can achieve the cell type-specific differentially expressed genes for each predicted cell type, and we can also achieve the specific differentially expressed genes for each predicted subcluster. We can also achieve the cell type-specific differentially expressed genes across different datasets.
2. Here you can choose all the cell types that are predicted by the "Cell Clustering" section. There are seven predicted cell types in the drop-down bar, you can choose one cell type to achieve the cell type-specific differentially expressed genes.
3. The Log2 fold-change cutoff ranges from 0 to 5.
4. The Adjusted p-value cutoff ranges from 10^-6 to 1.
5. The DE detection contains three options, all, up, and down.
6. You can search for the exact genes that you are interested, then the following table will return the matching result.
7. You can use this download button to download the current table.
8. [Genecards](https://www.genecards.org) database is linked to each gene in the table.
9. This is how many rows of the table that will show. The default number is 15, but users can choose another number in the options bar, e.g. 5, 10, 15, and all.
10. KEGG pathway enrichment analysis result table of the DEGs will show up when you click the inverted triangle, and this table can be downloaded when you click the 'Download' button.
11. GO biological process analysis result table of the DEGs will show up when you click the inverted triangle, and this table can be downloaded when you click the 'Download' button.
12. GO molecular function analysis result table of the DEGs will show up when you click the inverted triangle, and this table can be downloaded when you click the 'Download' button.
13. GO cellular component analysis result table of the DEGs will show up when you click the inverted triangle, and this table can be downloaded when you click the 'Download' button.
14. Cell-type-specific regulon analysis result table of this dataset will show up when you click the inverted triangle, and this result only shows up when you choose the 'Cell type specific genes' in the 'Group' drop-down bar.
    A. This is the cell-type-specific regulon result table for each cell type, and this table can be downloaded when you click the 'Download' button.

- Regulon heatmap
  C. A table summarizes the clusters shows the overall cell number and regulon number in each cluster. In the table, index number will be given to represent CTSRs. A cell-gene-regulon heatmap will be displayed for each cell type by clicking on the CT# tab. See figure details below.
  D. The heatmap, empowered by Clustergrammer, showcases the expression pattern of genes from the top ten regulons in the corresponding cell type. To explore details about Clustergrammer, please read the [Clustergrammer documentation](https://clustergrammer.readthedocs.io). - Both gene compositions of regulons and their expression values across different cell types can be intuitively displayed in such a heatmap. Regulons are ranked in increasing order of the empirical p-values of regulon specificity scores (RSS) as described above, and a regulon is named as CT-Rm with CT representing the name of cell type and m represents the regulon rank. Due to the space limitation, only the top ten regulons and their corresponding genes are showcased in the heatmap, and the component genes of each regulon are indicated as green rectangles. The heatmap records the log-transformed expression level of each top-ten-regulon-covered gene across all cells. - Cell names, original cell type labels, and cell types labels predicted by Seurat are shown on the heatmap. This heatmap can also be sorted by gene and cell by double-clicking on the appropriate area on the image. Conveniently, a series of gene enrichment tests can be directly performed on the heatmap using the integrated Enrichr function in the Clustergrammer framework. - This heatmap can be downloaded by clicking on the top left buttons above the heatmap and choosing the 'Take a snapshot' option.
- Regulon details
  E. Regulon results are seperately showcased in each cell type. Click on the "CT#" button to switch to see results in other cell types. A scatter plot shows the distribution of RSS of each regulon. CTSRs are marked as blue dots with their representative TF names beside, and insignificant regulons are marked as grey dots. Detailed information of each regulon can be found in [IRIS3](https://bmbl.bmi.osumc.edu/iris3/index.php).

## Browse healthy atlas page

---

The 'Browse healthy atlas' page contains all the 15 healthy atlases that were stored in the scREAD based on different brain regions for different species and different mice ages.

## Submit page

---

The submission of new entry is welcome, and it can be done on the “submit” page. One scRNA-Seq file of AD disease should be uploaded, and one scRNA-Seq file of control can be uploaded or not.

![Home](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/submit1.jpg)

1. Upload your AD scRNA-Seq expression matrix file by selecting the file stored on your computer.
   Note: This file is required if you want to analyze new data.
   Note: You can upload a zip format file if the size of your upload file is too large, like the 10X Genomics file.
2. You can provide species, gender, brain region, and Braak stage these four types of information of your input gene expression file to scREAD.
3. You can select one of the control datasets as a reference healthy atlas to do the following analysis by choosing 'Select from scREAD controls' option, e.g., identification of cell types, identification of cell-type-specific biomarkers, identification of differentially expressed genes, and identification of cell-type-specific regulons.
4. These are all the 15 control files that are stored in scREAD to produce all healthy atlas. For the human control files, the first column is the species, the second column is the condition, the third column is the brain region, the last column is the gender. For the mouse control files, the first column is the species, the second column is the condition, the third column is the brain region, the fourth column is the gender, and the last column is the age of the mouse.
5. You can also upload your control dataset if you have one to do the comparison within your own paired dataset by selecting 'Upload control data' and then click the bar.
6. If you have any comments about scREAD, we will be appreciative that you can write your comments here.
7. An email is not required to submit the job; however, we strongly suggest you provide your email because the data you uploaded will be processed by our analyst manually. So you will be noticed by email when the job is done.
8. Submit the job once everything is ready.
9. You can reset all the input information by clicking this button and restart over again.

## Download page

---

Not all the datasets in scREAD are available to download for users. On the “Download” page, datasets that downloaded from the GEO database are available to download, but datasets downloaded from Synapse are not available to download.
