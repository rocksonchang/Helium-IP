# Helium-IP

This is a GUI I put together for analysis of images from an ultracold atoms experiment.  In particular, this GUI has been adapted for the study of ultracold metastable Helium-4 at the Institut d'Optique in Palaiseau, France.  Group webpage here:
https://www.lcf.institutoptique.fr/lcf-en/Research-groups/Atom-optics/Experiments/Lattice-Gases

This project has been coded in Matlab R2011a using GUIDE.  The project files consists firstly of the GUI layout "HeliumIP.fig" and corresponding script for callbacks "HeliumIP.m".  In addition, various functions have been developed to execute particular tasks in the image processing and analysis.  These functions have the prefix "IP_".  

The GUI can be launched by calling "HeliumIP" in the Matlab command window, or by launching "RUN.m".

A folder of sample data has been included for demonstration purposes.  The input data consists of sets of png images.  There are currently two imaging modes corresponding to the technique used to observe the atoms: fluoresence and absorption.  For demonstration purposes, only absorption images have been supplied.  Images are typically taken after a time-of-flight expansion from the trap, thereby revealing the atomic velocity distribution.

"Data\01 BEC transtion" contains sample data of the atom cloud as we cool across the transition from a thermal (classical) gas into a Bose-Einstein condensate (BEC).  This transition is clearly seen in the velocity distribution with the formation of a narrow central peak on top of the broad thermal distribution.  See wikipedia for more info:
https://en.wikipedia.org/wiki/Bose%E2%80%93Einstein_condensate

"Data\02 2D diffraction" contains sample data of the diffraction of a BEC from an optical lattice.  This phenomenon, known as matter-wave diffraction and is analogous to the diffraction of light from a multiple slit pattern.  Here, atom trajectories 'passing' through different nodes and anti-nodes of the optical lattice can interfere with each other giving rise to a rich interference pattern, in this case a series of distinct diffraction peaks.  See wikipedia for more info:
https://en.wikipedia.org/wiki/Matter_wave

