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

% script that sets all variables to  NAN (so that they are filled with
% FILLVALUE in the writing routine)

% this script is called if
% 1. no good PRT measurements are available

%if onlybadPRTmeasurements==1 
    btemps=nan*ones(5,number_of_fovs,scanlinenumbers(end));
    u_random_btemps=nan*ones(5,number_of_fovs,scanlinenumbers(end));
    u_nonrandom_btemps=nan*ones(5,number_of_fovs,scanlinenumbers(end));
    u_common_btemps=nan*ones(5,number_of_fovs,scanlinenumbers(end));
    u_RFI_btemps=nan*ones(5,number_of_fovs,scanlinenumbers(end));
    
    quality_pixel_bitmask=33*ones(number_of_fovs,scanlinenumbers(end)); %33, i.e. Invalid; sensor_error
    data_quality_bitmask=0*ones(number_of_fovs,scanlinenumbers(end));
%     quality_pixel_Ch2_bitmask=2*ones(90,scanlinenumbers(end));
%     quality_pixel_Ch3_bitmask=2*ones(90,scanlinenumbers(end));
%     quality_pixel_Ch4_bitmask=2*ones(90,scanlinenumbers(end));
%     quality_pixel_Ch5_bitmask=2*ones(90,scanlinenumbers(end));
%     
%    quality_issue_scnlin_bitmask=2*ones(scanlinenumbers(end),1);
    
    quality_scanline_bitmask=0*ones(1,scanlinenumbers(end));

    quality_issue_pixel_Ch1_bitmask=0*ones(number_of_fovs,scanlinenumbers(end));
    quality_issue_pixel_Ch2_bitmask=0*ones(number_of_fovs,scanlinenumbers(end));
    quality_issue_pixel_Ch3_bitmask=0*ones(number_of_fovs,scanlinenumbers(end));
    quality_issue_pixel_Ch4_bitmask=0*ones(number_of_fovs,scanlinenumbers(end));
    quality_issue_pixel_Ch5_bitmask=0*ones(number_of_fovs,scanlinenumbers(end));
    
    R_c_i=-32768*ones(5,5); %-32768=fillvalint16
    R_c_s=-32768*ones(5,5);
    R_c_co=-32768*ones(5,5);
 
    
    
    % for fullFCDR
%     qual_scnlin_indicator_bit_field
%     qual_scnlin_CalibrationProblem
%     qual_scnlin_CalibrationProblem_Lunar
%     qual_scnlin_EarthLocationProblem
%     qual_scnlin_TimeProblem
%    
%     qual_scnlin_Ch1_CalibrQualFlags
%     qual_scnlin_Ch2_CalibrQualFlags
%     qual_scnlin_Ch3_CalibrQualFlags
%     qual_scnlin_Ch4_CalibrQualFlags
%     qual_scnlin_Ch5_CalibrQualFlags


%end

