[[toc]]

# Background information

Short description about the primary functions of the server, including peaks classification, motif finding and motif analyses.

## Introduction for DESSO server

One of the most fundamental questions in biology is how to understand the transcription factor binding and regulated mechanism. Larger-scale chip-seq sequencing and biology experiment studies are now rapidly opening up new ways to track this question by this binding mode from transcription faactor. Here, we developed the DESSO databases, aiming to provide a service for users to find and analysis motifs from their data.

## Overview for DESSO server

By manually curating several the state-of-art models, which is used to find motifs. we collected 185 transcription factors related to 20 cancer types, to evaluate deep learning models. In the light of the experimental results, DESSO model obtained the best result on finding motifs, Basset model obtained the best performance on peaks classification. Based on the published paper, the DESSO model also obtained the best performance on 690 chips-seq datas. In this server, we installed these two model to performan two kinds of tasks, and we also published the found motifs of the DESSO, the trained model for each transcription factor. regarding to the Basset mode, we also deployed the trained model for peaks classification, because of its best perfomance. Meanwhile, the single-cell chip-seq experiment is a challenge for people, because of the limitted technology. We collect the single-cell chips-seq data to finding motifs by using deep learning models.

## What is DNA motif

Gene regulation mechanism is an important biological field, the gene expression is controlled by transcription factors, which is regulatory protein and bind to DNA. Each transcription factor (TF) has a specific binding site (TFBS), and each kind of TFBS also has a unique binding model, named motif.
A DNA motif is a region of DNA that regulates the expression of downstream genes located on that same molecule of DNA, i.e., a chromosome. This concept is equivalent to a DNA cis-regulatory element or cis-element. It contains the transcription factor binding sites (TFBSs) and other conserved functional elements in the 5 intergenic regions of genes.

## What can this server do in motif analyses.

> **Our server has a number of novel capabilities:**  
> (i) find TFs are related to cancer types  
> (ii) identifying the binding sites  
> (iii) finding DNA motifs from chip-seq peaks  
> (iv) match denovo motifs to the existed motifs  
> (v) motif scanning  
> (vi) annotation genes to TFs binding sites
> (vii) finding motifs from the single-cell schip-seq dataset

## Why we deploy the Basset model on this server.

Before developing this server, we applied the main top deep learning model to find motif on the 185 chip-seq datasets. In our experiments, we evaluate the performance of all deep learning models from two aspects including find motifs and peaks classification. About the first aspect we compare all deep learning models' performance by computing the P-value, E-value, and Q-value of motifs. with regarding to the second one, we select eight criterions to evaluate the capacities that identify the peaks is TFs binding site or not, finally we summary eight criterions as the area of octagon.  
Accoding to the area of each deep learning model shown as figure1, the Basset model obtainded the best performance about peaks classification and the DESSO model obtainded the best performance about finding motifs.
![Figure1](/docs/figures/background_figure1.png)
Figure 1. A characterization of the 20 methods evaluated in this study and their overall evaluation results

## What kinds of formats of input sequences are suitable for this server to find motifs.

Currently we accept three kinds of motif formats, shown as follows,  
(i) bed file

(ii) fasta file

(iii) sequences

## What kinds of formats of motifs can be used to analysis.

Currently we accept three kinds of motif formats, shown as follows,  
(i)bed file

(ii) meme

(iii) fasta

(vi) pwm

## Cite us.

[1][2]

---

---
