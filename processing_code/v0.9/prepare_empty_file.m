

% script that sets all variables to  NAN (so that they are filled with
% FILLVALUE in the wrtiting routine)

% this script is called if
% 1. no good PRT measurements are available

if onlybadPRTmeasurements==1 
    btemps=nan*ones(5,90,scanlinenumbers(end));
    u_random_btemps=nan*ones(5,90,scanlinenumbers(end));
    u_nonrandom_btemps=nan*ones(5,90,scanlinenumbers(end));
    
    quality_pixel_Ch1_bitmask=2*ones(90,scanlinenumbers(end)); %set first bit to one --> 2 (i.e. "do not use this pixel: sensor failure")
    quality_pixel_Ch2_bitmask=2*ones(90,scanlinenumbers(end));
    quality_pixel_Ch3_bitmask=2*ones(90,scanlinenumbers(end));
    quality_pixel_Ch4_bitmask=2*ones(90,scanlinenumbers(end));
    quality_pixel_Ch5_bitmask=2*ones(90,scanlinenumbers(end));
    
    quality_issue_scnlin_bitmask=2*ones(scanlinenumbers(end),1);

    quality_issue_pixel_Ch1_bitmask=0*ones(90,scanlinenumbers(end));
    quality_issue_pixel_Ch2_bitmask=0*ones(90,scanlinenumbers(end));
    quality_issue_pixel_Ch3_bitmask=0*ones(90,scanlinenumbers(end));
    quality_issue_pixel_Ch4_bitmask=0*ones(90,scanlinenumbers(end));
    quality_issue_pixel_Ch5_bitmask=0*ones(90,scanlinenumbers(end));
  
 
    
    
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


end

