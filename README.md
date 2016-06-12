# Helium-IP

This is a GUI I put together for analysis of images from an ultracold atoms experiment.  In particular, this GUI has been adapted for the study of ultracold metastable Helium-4 at the Institut d'Optique in Palaiseau, France.  Group webpage here:
https://www.lcf.institutoptique.fr/lcf-en/Research-groups/Atom-optics/Experiments/Lattice-Gases

This project has been coded in Matlab R2011a using GUIDE.  The project files consists firstly of the GUI layout "HeliumIP.fig" and corresponding script for callbacks "HeliumIP.m".  In addition, various functions have been developed to execute particular tasks in the image processing and analysis.  These functions have the prefix "IP_".  

The GUI can be launched by calling "HeliumIP" in the Matlab command window, or by launching "RUN.m".

A folder of sample data has been included for demonstration purposes.  The input data consists of sets of png images.  There are currently two imaging modes corresponding to the technique used to observe the atoms: fluoresence and absorption.  For demonstration purposes, only absorption images have been supplied.  Images are typically taken after a time-of-flight expansion from the trap, thereby revealing the atomic velocity distribution.

"Data\01 BEC transtion" contains sample data of the atom cloud as we cool across the transition from a thermal (classical) gas into a Bose-Einstein condensate.  At high temperatures, the atoms in our system act as particles -- like billiard balls bouncing around.  As we reduce their temperature, a new, wave-like, behavior begins to emerge.  This wave-like behavior we can characterize with a de Broglie wavelength.  As we cool the initially thermal atoms, the atoms come closer and closer together and their de Broglie wavelength becomes longer and longer.    We eventually reach the point where the deBroglie waves of each particle begin to overlap.  At this point, we can no longer think of our system classically as a collection of particles, but we must also account for their wave-like nature.  When we do this, what we find is that atoms will begin to fall into the same quantum mechanical state -- the ground state of the system.  The population in this lowest energy state is called a Bose-Einstein condensate (BEC).  For a much better explanation:

https://en.wikipedia.org/wiki/Bose%E2%80%93Einstein_condensate

