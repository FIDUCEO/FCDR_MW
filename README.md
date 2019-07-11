# FCDR_MW
Development code for MW FCDR
  
    This code was developed for the EC project “Fidelity and Uncertainty in
    Climate Data Records from Earth Observations (FIDUCEO)”.
    Grant Agreement: 638822
    
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the Free
    Software Foundation; either version 3 of the License, or (at your option)
    any later version.
    This program is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
    more details.
    A copy of the GNU General Public License should have been supplied along
    with this program; if not, see http://www.gnu.org/licenses/
    
The folder FCDR_processing contains the MATLAB code to process the level1b MW humidity sounder data to new level 1c FIDUCEO FCDR, including all improvements presented in the Product User Guide v4.1.

Note that you will need additional code to execute the processing (namely the collection of the level1b data):
The FCDR-generator code makes use of the open source code "atmlab", available through http://www.radiativetransfer.org/tools/

Moreover, you need the amsubcl/mhscl subroutine of AAPP to perfom the checks on moon-intrusion.

An overview of the code and its usage is provided in overview_FCDR_processing.txt in /FCDR_processing.

The description of the FCDR processing chain can be found in 
Hans, Imke (2018) Towards a new fundamental climate data record for microwave humidity sounders based on metrological best practice, Dissertation, Universitaet Hamburg 
