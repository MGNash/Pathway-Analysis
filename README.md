# Pathway-Analysis
Data cleaning/reconciliation and KEGG pathway analysis for proteins collected from biological samples coming from multiple sources in a simulated experiment.

This repository contains the following files:

pathway_ps.pdf - A document describing the methods and results of the data cleaning/reconciliation and pathway analysis I performed. If you are not interested in reproducing the analysis or viewing the code, go straight to this document and skip all the others.

	Source files:
make_new_sheets.R - Generates the simulated data to be analyzed.  
pathway_ps.RMD - Generates 'pathway_ps.pdf'. Invokes 'make_new_sheets.R'.

	Simulated data files (these are what I use for data cleaning/reconciliation and pathway analysis):
muscle.xlsx, serum_assoc2.xlsx, serum.xlsx

protein_names_sim.txt - A list of protein names created by running 'make_new_sheets.R'. Submitted to the web-based DAVID pathway analysis tool (https://david.ncifcrf.gov/) in order to obtain pathway analysis results.

	Output from DAVID
unmapped_sim.txt, gene_list_report_sim.txt, not_in_output_sim.txt, all_genes_chart_sim.txt
Obtained by submitting protein_names_sim.txt, requesting chart for KEGG Pathway and selecting Count = 1 and EASE = 1 under Options - Threshold.

prot_path.csv - a table of protein names, where to find them, and the biological pathways in which they are found - clean data created by running 'make_new_sheets.R'


	In order to run 'make_new_sheets.R':
1) Download this supplemental data file: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5489383/bin/NIHMS860664-supplement-Supp_info.xlsx,
which comes from  the following journal article: Nielson, C. M., Wiedrick, J., Shen, J., Jacobs, J., Baker, E. S., Baraff, A., . . . Orwoll, E. S. (2017). Identification of Hip BMD Loss and Fracture Risk Markers Through Population-Based Serum Proteomics. Journal of Bone and Mineral Research, 32(7), 1559-1567. doi:10.1002/jbmr.3125. 
2) Change the working directory in the very first line to the directory in which the supplemental data file is located.

	In order to run 'pathway_ps.RMD':
1) Download all files in this repository plus the supplemental data file mentioned above into a single directory. 
2) Change the working directory set in line 1 of 'make_new_sheets.R' and lines 55 and 63 of 'pathway_ps.RMD' into the directory containing the files mentioned above
