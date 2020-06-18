[[toc]]


# Tutorial
----
The scREAD database includes modules of Home, Browse healthy atlas, Submit, Help, and Download. The 'Home' page contains four statistical pie charts reflect ratio distribution in 55 files for each of the four factors, and a table that contains all the information of 55 files. The 'Browse healthy atlas' page contains the 15 healthy atlas from different brain regions for human and mouse species. The 'Submit' page provides an interface that can let users can submit their AD scRNA-Seq dataset into scREAD to do the same analysis as our database showed. The 'Help' page contains three modules, e.g., "FAQ", "Tutorial", and "Contact", users can find the corresponding information for each of these three modules. The 'Download' page provides the datasets that can be downloaded which are storing in scREAD.

## Home page
----

![Home](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/Home.jpg)
 
1. The name of our database is scREAD, which is short for the 'Single-cell RNA-Seq database for Alzheimer's Disease'.
2. The five modules of scREAD, which are 'Home' page, 'Browse healthy atlas' page, 'Submit' page, 'Help' page, and 'Download' page.
3. Here is the general statistical information of all datasets that covered in scREAD. scREAD contains a total of 55 files across human and mouse species under different factors.
4. This is the pie chart of the species information across 55 files. scREAD only contains two species, human and mouse. There are 19 human species files across 55 files, and 36 mouse species files across 55 files. Each color represents each species, and the number represents the ratio for each of the two species for 55 files.
5. This is the pie chart of the condition information across 55 files. There are two conditions for each species. For the human control condition, it contains five files across 55 files. For human disease conditions, it contains 14 files across 55 files. For the mouse control condition, it contains 10 files across 55 files. For mouse disease conditions, it contains 26 files across 55 files. Each color represents one condition, and the number is the ratio for each condition across 55 files.
6. This is the pie chart of the brain region information across 55 files. There are a total of eight different brain regions for each species. For the human entorhinal cortex region, it contains six files across 55 files. For the human prefrontal cortex region, it contains 10 files across 55 files. For the human superior frontal gyrus region, it contains three files across 55 files. For the mouse cortex region, it contains nine files across 55 files. For the mouse cerebellum region, it contains two files across 55 files. For the mouse cerebral cortex region, it contains five files across 55 files. For the mouse hippocampus region, it contains 16 files across 55 files. For the mouse prefrontal cortex region, it contains four files across 55 files. Each color represents each region of the eight brain regions, and the number is the file ratio distribution for the eight brain regions across 55 files.
7. This is the pie chart of the gender information across 55 files. There are two genders for each species. For the human male gender, it contains 12 files across 55 files. For the human female gender, it contains seven files across 55 files. For the mouse male gender, it contains 29 files across 55 files. For the mouse female gender, it contains seven files across 55 files. Each color represents one gender, and the number is the ratio for each gender across 55 files.
8. Here are all the options for the species factor. Users can select the 'All' option, then it will return searching results contain both human and mouse species. Users can select the 'Human' option, then it will return searching results contain only human species. Users can select the 'Mouse' option, then it will return searching results contain only mouse species.
9. Here are all the options for the condition factor. Users can select the 'All' option, then it will return searching results contain both control and disease conditions. Users can select the 'Control' option, then it will return searching results contain only control condition. Users can select the 'Disease' option, then it will return searching results contain only disease condition.
10. Here are all the options for the brain region factor. Users can select the 'All' option, then it will return searching results contain all brain regions. Users can select each of these options, then it will return searching results contain only one brain region. 
11. Here are all the options for the gender factor. Users can select the 'All' option, then it will return searching results contain both males and females. Users can select the 'Female' option, then it will return searching results contain only the female gender. Users can select the 'Male' option, then it will return searching results contain only the male gender.

Note: When users choose one of these factors, the corresponding searching result will be changed based on the factors that the users chose.

12. This is the 'scREAD data ID' column in the whole table, which is a unique identification in scREAD. Each data_ID corresponds to one file of the 55 files. 
13. This is the 'Species' column in the whole table, which contains human and mouse these two species in all 55 files stored in scREAD. 
14. This is the 'Gender' column in the whole table, which contains male and female these two genders in all 55 files stored in scREAD. 
15. This is the 'Condition' column in the whole table, which contains control and disease these two conditions in all 55 files stored in scREAD. 
16. This is the 'Region' column in the whole table, which contains eight different brain regions in two species in all 55 files stored in scREAD.
17. This is the 'Braak stage' column in the whole table, which contains one to six Braak stages for humans in all 55 files stored in scREAD. Braak staging refers to a method used to classify the degree of pathology in  AD. The staging system that contains six different stages, with each stage being attributed to abnormal pathology in particular neurological structures. The more poor condition the patient is, the higher the corresponding Braak stage is.
18. This is the 'Age' column in the whole table, which contains the age information for human and mouse species in all 55 files stored in scREAD.
19. This is the 'Mice model' column in the whole table, which contains the different mice model information used in 11 AD studies for all 55 files stored in scREAD. And NA means the species it's not mouse species.
20. This is the 'GEO/synapse ID' column in the whole table, which is the dataset ID that is used in the GEO and Synapse database.
21. This is the '#Cells' column in the whole table, which presents the number of cells for each of 55 files stored in scREAD.
22. This is how many rows of the whole table that will show on the home page. The default value is 15, but users can choose another value but no less than 15.


## Browse healthy atlas page
----
The 'Browse healthy atlas' page contains all the 15 healthy atlas that was stored in the scREAD based on different brain regions for different species and different mice ages.

## Submit page
-------
The submission of new entry is welcome, and it can be done on the “submit” page. One scRNA-Seq file of AD disease should be uploaded, and one scRNA-Seq file of control can be uploaded or not.

![Home](https://raw.githubusercontent.com/Crystal-JJ/scREAD/master/submit.jpg)

1. Upload your AD scRNA-Seq expression matrix file by selecting the file stored on your computer.
Note: This file is required if you want to analyze new data.
Note: You can upload a zip format file if the size of your upload file is too large, like the 10X Genomics file.
2. You can select one of the control datasets as a reference healthy atlas to do the following analysis, e.g., identification of cell types, identification of cell-type-specific biomarkers, identification of differentially expressed genes, and identification of cell-type-specific regulons. You can also upload your control dataset if you have one to do the comparison within your own paired dataset.
3. These are all the 15 control files that are stored in scREAD to produce all healthy atlas. For the human control files, the first column is the species, the second column is the condition, the third column is the brain region, the last column is the gender. For the mouse control files, the first column is the species, the second column is the condition, the third column is the brain region, the fourth column is the gender, and the last column is the age of the mouse.
4. An email is required to submit the job. Because the data you uploaded will be processed by our analyst manually. So you will be noticed by email when the job is done.
5. Submit the job once everything is ready.
6. You can reset all the input information by clicking this button and restart over again.



## Help page
-------
Help module provides an easy way to help you understand and know how to use scREAD quickly. Here we provide three pages: FAQ, Tutorial, and Contact. 


## Download page
-----
Not all the datasets in scREAD are available to download for users.  On the “Download” page, datasets that downloaded from the GEO database are available to download, but datasets downloaded from Synapse are not available to download.









