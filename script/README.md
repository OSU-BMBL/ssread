# SCRIPT

This directory contains data processing script used in scREAD.

- custom_marker.csv. A manually created marker gene list file used for identified cell types.
- functions.R. Visualization functions used in R.

1. build_healthy_atlas.R: build healthy (control) cells atlas Seurat object from count matrix file.
2. transfer_cell_type.R: filter out healthy-like (control-like) cells in disease dataset
3. run_analysis.R: run analysis workflow, and export tables in scREAD database format.

More information about the pipeline can be found in [What is the scREAD overall pipeline?](https://bmbls.bmi.osumc.edu/scread/help/faq#what-is-the-scread-overall-pipeline%3F)
