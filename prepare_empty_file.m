

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
    
    quality_pixel_bitmask=545*ones(number_of_fovs,scanlinenumbers(end)); %545, i.e. Invalid; sensor_error; no_calib_bad_PRT
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

