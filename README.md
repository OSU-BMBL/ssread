# scREAD

Main server (version 1 archive): https://bmbls.bmi.osumc.edu/scread

Alternative server (version 1 archive): http://osubmi.com/scread

Dev server (still processing datasets): https://bmblx.bmi.osumc.edu/scread/

---
This repository serves as the front end part of scREAD, it also contains scREAD workflow in the /script folder.

[scREAD](https://bmblx.bmi.osumc.edu/scread/) (A single-cell and spatial RNA-seq database for Alzheimer’s Disease) is the first database dedicated to collect all existing Human and Mouse Alzheimer's Disease scRNA-Seq, snRNA-seq, and spatially resovled transcriptomics data, and provide comprehensive interpretations.

If you have any questions, suggestions, or found a new AD paper generated scRNA-seq datasets, please let us know via email: [qin.ma@osumc.edu](qin.ma@osumc.edu).

## Citation

Jiang, Jing, Cankun Wang, Ren Qi, Hongjun Fu, and Qin Ma. “ScREAD: A Single-Cell RNA-Seq Database for Alzheimer’s Disease.” IScience 23, no. 11 (November 20, 2020): 101769. https://doi.org/10.1016/j.isci.2020.101769.


## Code tutorials

Please check the following GitHub link for full tutorials, including: 
1. Calculating overlapping DEGs from the same cell type across datasets
2. Running backend analysis workflow locally

https://github.com/OSU-BMBL/scread-protocol 

## Local development

First, install [Node.js](https://nodejs.org/en/) (v12+)

### Add configuration file

```bash
git clone git@github.com:OSU-BMBL/scread.git
cd scread
```

Create a `.env` file in project root and put API URL in the env file:

```env
#Alternatively use:
#API_URL=http://osubmi.com/api/scread
```

Next,
```bash
npm install
npm run dev
```
