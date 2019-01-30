# FCDR_MW
Development code for MW FCDR

The folder FCDR_processing contains the MATLAB code to process the level1b MW humidity sounder data to new level 1c FIDUCEO FCDR, including all improvements presented in the Product User Guide v4.1.

Note that you will need additional code to execute the processing (namely the collection of the level1b data):
The FCDR-generator code makes use of the open source code "atmlab", available through http://www.radiativetransfer.org/tools/

Moreover, you need the amsubcl/mhscl subroutine of AAPP to perfom the checks on moon-intrusion.

An overview of the code and its usage is provided in overview_FCDR_processing.txt in /FCDR_processing.

The description of the FCDR processing chain can be found in 
Hans, Imke (2018) Towards a new fundamental climate data record for microwave humidity sounders based on metrological best practice, Dissertation, Universitaet Hamburg 
