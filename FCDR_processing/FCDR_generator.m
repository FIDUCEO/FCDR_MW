%
 % Copyright (C) 2019-01-04 Imke Hans
 % This code was developed for the EC project ?Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)?. 
 % Grant Agreement: 638822
 %  <Version> Reviewed and approved by <name, instituton>, <date>
 %
 %  V 4.1   Reviewed and approved by Imke Hans, Univ. Hamburg, 2019-01-04
 %
 % This program is free software; you can redistribute it and/or modify it
 % under the terms of the GNU General Public License as published by the Free
 % Software Foundation; either version 3 of the License, or (at your option)
 % any later version.
 % This program is distributed in the hope that it will be useful, but WITHOUT
 % ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 % FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 % more details.
 % 
 % A copy of the GNU General Public License should have been supplied along
 % with this program; if not, see http://www.gnu.org/licenses/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FCDR generator

% This is the main function to produce the FCDR. It takes the chosen
% satellite, sensor, year and month and produces orbit-files in NetCDF
% format with calibrated brightness temperatures.

% FCDR_generator.m defines the orbit-frames and hands over to
% process_FCDR.m which executes the chopping into Equator-to-Equator chunks
% and prepares and executes the calibration procedure.

% If used together with run_batch_mission.m FCDR_generator.m can be used to
% process a whole mission by sending sbatch jobs to a queue. Each month
% will then be processed independently.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FCDR_generator(sat,sen,year,chosen_month)

% Choose satellite, sensor, year and month
% sat='noaa15';
% sen='amsub';
% year=1999;
% chosen_month=6;



selectinstrument=sen;
selectsatellite=sat;
selectyear=year;
satsenyear=strcat(selectsatellite,'_',selectinstrument,'_',num2str(selectyear));

%% Read all level 1b data for this month
disp(['Read all data for month ',num2str(chosen_month),'...'])
[monthly_data_record,monthly_data_header,file_list] = MW_l1b_read_monthly(sat,sen,year,chosen_month);


%% Remove duplicate date (according to time)
disp('Remove duplicate data...')
remove_duplicated_l1bdata

%% Prepare start and end lines for each file
% Determine Equator crossings
disp('Determine equator crossings...')
equator_crossings=determine_EQcrossings(sat,sen,monthly_data_record);

% Determine data gaps larger than 1/2 orbit (to get start/ end of file correct in this case)
[scnlin_before_datagap,equator_crossings_cleaned]=determine_data_gaps(sat,sen,monthly_data_record,equator_crossings);



% Combine equator crossings and "scanlines before found gaps" 
crossings_and_gap_withoffsets=[equator_crossings_cleaned scnlin_before_datagap; 3*ones(1,length(equator_crossings_cleaned)) -1*ones(1,length(scnlin_before_datagap)) ; 3*ones(1,length(equator_crossings_cleaned)) zeros(1,length(scnlin_before_datagap)) ];

% Combine equator crossings and scanlines before found gaps
crossings_and_gap=sortrows(crossings_and_gap_withoffsets.').';

%% Process every Eq2Eq file
disp('Produce EQ-to-EQ files and start processing:')
process_FCDR

disp(['Month ', num2str(chosen_month), ' has been processed sucessfully.'] )