# Helium-IP

This is GUI I put together for quick analysis of images.  The code has been adapted to the study of ultracold atoms, and in particular for the study of ultracold metastable Helium-4 at the Institut d'Optique in Palaiseau, France.  

This project has been coded in Matlab R2011a using GUIDE.  The project files consists firstly of the GUI layout "HeliumIP.fig" and corresponding script for callbacks "HeliumIP.m".  In addition, various functions have been developed to execute particular tasks in the image processing and analysis.  These functions have the prefix "IP_".  

The GUI can be launched by calling "HeliumIP" in the Matlab command window, or by launching "RUN.m".

A folder of sample data has been included for demonstration purposes.  The input data consists of sets of png images.  There are currently two imaging modes corresponding to the technique used to observe the atoms: fluoresence and absorption.  For demonstration purposes, only absorption images have been supplied.
