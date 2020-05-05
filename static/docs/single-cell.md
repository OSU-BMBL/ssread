[[toc]]

# Single-cell

The case study about single-cell chip-seq

## The single-cell chip-seq topic

The three single-cell chip-seq datasets collected from the reference * named GSE117309 (H3k27me3) are used to finding motifs by ultilzing DESSO and BASST models. To the best of our knowledge, the deep learning models usually need thousands of training samples to train the model better. In this article, each dataset we used contains beyond one thousand of peaks with the length of 50k, all single-cell chip-seq are descripted as Table 1.
Next, we utilize the deep learning models to identify the binding sites from the chip-seq data of each cluster shown as in the Figure 2.
![figure 1.](/docs/figures/Consensus_cluster.png)
According to our experimental results, we find different motif sets from the different clusters,*ie\*, we find the unique motif on the each single-cell chip-seq dataset, and explores their properties, we use the FIMO tool to find possible binding sites of this unique motif, annotation the nearest gene to these binding sites by using the [GREAT](http://great.stanford.edu/). So we can obtain the gene set corresponding to each unique motif, and next, to obtain the significant pathway, the enrichr tool is used to enrich these gene sets. Finally, the pathway regulated by the motif is obtained shown as table 2. The pipeline of analyses the single-cell chip-seq data, shown as the following figure 1.  
Figure 1. the pipline of analyses the single-cell chip-seq data
![figure 1.](/docs/figures/pipeline.png)
Table 2. the enriched motifs
| Sample| Motif | Pathway |P-value|Adjusted p-value|
|-----------| ----------- | ----------- |-----------|-----------|
| Triple-negative breast tumor|ClusterB (H3k27me3_1990) | 0.0001879|0.02894|Cytokine-cytokine receptor interaction |
| Triple-negative breast tumor| ClusterB (H3k27me3_1792) | 0.00005203 | 0.01602 | Complement and coagulation cascades |
| Stromal cells | ClusterC (H3k27me3_2715) | 1.038E-4 | 0.031| cAMP signaling pathway |
In this server, we also published the trained model on the website to provide the predicted srevice for users. User can use the website to find motifs from our single-cell chip-seq dataset, and match your motifs to the known motifs. Meanwhile, we supply the pipline to explore motifs' properties, in the light of single-cell chip-seq dataset.
