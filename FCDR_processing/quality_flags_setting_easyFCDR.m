

% quality flags setting

% Collect needed flags from l1b files/ from processing:
% qualbit_earth_notEarthloc
% qualbit_earth_questTimecode
% qualbit_earth_margagree
% qualbit_earth_fail
% qualbit_earth_posCheck
% qualflag_TimeProb_origl1bval
% qualbit_SARRB_status
% qualbit_SARRA_status
% qualbit_STX4_status
% qualbit_STX3_status
% qualbit_STX2_status
% qualbit_STX1_status

% Compile them for use as components of easyFCDR bitmasks

% Geolocation problems (from l1b)
combined_earth=logical(qualbit_earth_notEarthloc) | logical(qualbit_earth_questTimecode) | logical(qualbit_earth_margagree) | logical(qualbit_earth_fail) | logical(qualbit_earth_posCheck);
% Time Problem Code (copied from l1b)
combined_time=logical(qualbit_badtimefieldbutinferrable)| logical (qualbit_badtimefield) | logical(qualbit_inconstisttime) | logical(qualbit_repeatedscantimes);


% Calibration Problem Moon Intrusion
qualbit_calib_Moon_checkfail=moon_global_donotuse; 
qualbit_calib_Moon_noCalib=moonflagAllViewsBad; 
qualbit_calib_Moon_useGoodviews=moonflagOneViewOk;

% Calibration Quality Flags per Channel

% prepare for all channels:
% expand moonflagOneViewOk to whole chn x scnlin dimension
qualflag_moononeviewok=repmat(moonflagOneViewOk,[1 5]).';
qualflag_IWCT_badorbit=~ismember([1 2 3 4 5].',channelset_iwct);
qualflag_DSV_badorbit=~ismember([1 2 3 4 5].',channelset_dsv);
expand_qualflag_IWCT_badorbit=permute(repmat(qualflag_IWCT_badorbit,[1 size(qualflag_moononeviewok,2)]),[1 2]);
expand_qualflag_DSV_badorbit=permute(repmat(qualflag_DSV_badorbit,[1 size(qualflag_moononeviewok,2)]),[1 2]);


qualbit_IWCT_allViewsbad=qualflag_allbadIWCT.';
qualbit_DSV_allViewsbad=qualflag_allbadDSV.';
qualbit_IWCT_nocalib=(logical(qualflag_IWCT_badline_furtherthan5lines) | expand_qualflag_IWCT_badorbit).';
qualbit_DSV_nocalib=((logical(qualflag_DSV_badline_furtherthan5lines) | expand_qualflag_DSV_badorbit) & ~logical(qualflag_moononeviewok)).'; %remove the moonokview-lines! since they got overwritten with the goodview-counts: "furtheraway-case AND NOT Moonokview-case"
qualbit_IWCT_calib5closest=qualflag_IWCT_badline_5closest_TRUE.';
qualbit_DSV_calib5closest=qualflag_DSV_badline_5closest_TRUE.'; %the TRUE stands for: the moonokview cases are already taken out (in the qualitychecksDSV_allchn routine)
qualbit_IWCT_less4Views=qualflag_IWCTline_less4views.';
qualbit_DSV_less4Views=(logical(qualflag_DSVline_less4views)| logical(qualflag_moononeviewok)).'; % include the cases where less views haven been used due to Moon intrusion
qualbit_IWCT_increasedUncert= logical(qualflag_IWCTline_less4views.') | logical(qualflag_IWCT_fewerlines_used.');
qualbit_DSV_increasedUncert= logical(qualflag_DSVline_less4views.') | logical(qualflag_DSV_fewerlines_used.');
qualbit_IWCT_fewerlines=qualflag_IWCT_fewerlines_used.';
qualbit_DSV_fewerlines=qualflag_DSV_fewerlines_used.';
qualbit_IWCT_bfjump=qualflag_IWCTline_good_bef_jump.';
qualbit_DSV_bfjump=qualflag_DSVline_good_bef_jump.';



%% FIDUCEO EASY quality flags

% compile the individual flag bits for easy FCDR
% We have
% quality_scanline_bitmask (flag per transmitter, dim: line)
% quality_issue_pixel_ChX_bitmask   (further sensor flags, dim: view x line)
% quality_pixel_bitmask   (General and sensor specific global flags, dim: view x line)
% as bitmasks.

%% Scanline quality flag: quality_scanline_bitmask
quality_scanline_bitmask=qualbit_SARRB_status.*2^5+qualbit_SARRA_status.*2^4+qualbit_STX4_status.*2^3 ...
    +qualbit_STX3_status.*2^2+qualbit_STX2_status.*2+qualbit_STX1_status;


%% Channel specific issues: quality_issue_pixel_ChX_bitmask 

%qualflag_chX_Earthcountbad= from full set of flags

% for the no-calibration flag, compile

% qualbit_calib_Moon_noCalib
% qualbit_IWCT_nocalib DONE
% qualbit_DSV_nocalib DONE

qualbit_no_calibration_DSV= logical(qualbit_DSV_nocalib);%I do not include the following, since they imply already a major sensor error. | logical(qualbit_calib_Moon_checkfail) | logical(qualbit_calib_Moon_noCalib);
qualbit_no_calibration_IWCT=logical(qualbit_IWCT_nocalib);

%expand to match chn X pixel x scnlin 
expand_qualbit_no_calibration_DSV=permute(repmat(qualbit_no_calibration_DSV,[1 1 number_of_fovs]),[2 3 1]);
expand_qualbit_no_calibration_IWCT=permute(repmat(qualbit_no_calibration_IWCT,[1 1 number_of_fovs]),[2 3 1]);


%for the suspect calibration flag, compile (for DSV and IWCT separately)
% qualbit_IWCT_calib5closest
% qualbit_IWCT_less4Views
% qualbit_IWCT_fewerlines  
% qualbit_DSV_calib5closest
% qualbit_DSV_less4Views
% qualbit_DSV_fewerlines 
% qualflag_moononeviewok (it is the qualbit_calib_Moon_useGoodviews expanded to chn x scnlin)

qualbit_suspect_calibration_DSV= logical(qualbit_DSV_calib5closest) | logical(qualbit_DSV_less4Views) |logical(qualbit_DSV_fewerlines);
qualbit_suspect_calibration_IWCT= logical(qualbit_IWCT_calib5closest) | logical(qualbit_IWCT_less4Views) |logical(qualbit_IWCT_fewerlines);


%expand to match  channel x pixel x scnlin 
expand_qualbit_suspect_calibration_DSV=permute(repmat(qualbit_suspect_calibration_DSV,[1 1 number_of_fovs]),[2 3 1]);
expand_qualbit_suspect_calibration_IWCT=permute(repmat(qualbit_suspect_calibration_IWCT,[1 1 number_of_fovs]),[2 3 1]);

% for the bad earthpixel-flag compile bad-earth-pix and pixels with bad Tb
% range
bad_earthpixel=logical(qualflag_badscanlinesEarth_pix)|logical(qualbit_tb_badrange);

%compile bitmask and split into channels 
% ...+2ndbit*2^2+2stbit*2^1+0thbit*2^0;
quality_issue_pixel_bitmask=bad_earthpixel.*2^4+expand_qualbit_no_calibration_IWCT.*2^3+expand_qualbit_no_calibration_DSV.*2^2+expand_qualbit_suspect_calibration_IWCT.*2+expand_qualbit_suspect_calibration_DSV;
quality_issue_pixel_Ch1_bitmask=squeeze(quality_issue_pixel_bitmask(1,:,:));
quality_issue_pixel_Ch2_bitmask=squeeze(quality_issue_pixel_bitmask(2,:,:));
quality_issue_pixel_Ch3_bitmask=squeeze(quality_issue_pixel_bitmask(3,:,:));
quality_issue_pixel_Ch4_bitmask=squeeze(quality_issue_pixel_bitmask(4,:,:));
quality_issue_pixel_Ch5_bitmask=squeeze(quality_issue_pixel_bitmask(5,:,:));

%% General bitmask: quality_pixel_bitmask 

%-----------------------------------------------------------------------%
% Padded data flag
%
% flag for missing scanlines
qualbit_missing_scanline_unexp=qualflag_missing_scanline;
exp_qualbit_missing_scanline=permute(repmat(qualbit_missing_scanline_unexp,[1  number_of_fovs]),[2  1]);
    % qualbit: "data for this line is store in previous/ next file. In case of
    % a data gap larger than one orbit, the data for this line could not be
    % calibrated correctly and was rejected "
    qualbit_prev_next_file=zeros(size(squeeze(btemps(1,:,:))));
    qualbit_prev_next_file(:,1:3)=1;
    qualbit_prev_next_file(:,end-3:end)=1;

% set flag for padded data
qualbit_padded_data=exp_qualbit_missing_scanline | qualbit_prev_next_file;

%-----------------------------------------------------------------------%
% Sensor part
% & ~logical(qualbit_padded_data); is for supressing the setting of any
% flags if the scanline is marked as missing.
qualbit_no_calibration_prt=qualflag_PRT_badline_furtherthan5lines.'& ~logical(qualbit_padded_data(1,:).');

qualbit_no_calibration_moon_intrus= logical(qualbit_calib_Moon_noCalib)& ~logical(qualbit_padded_data(1,:).');
qualbit_exp_calib_Moon_checkfail=permute(repmat(qualbit_calib_Moon_checkfail,[1  number_of_fovs]),[2  1]);
     
    qualbit_calib_PRT_fewerlines=qualflag_PRT_fewerlines_used.';
    qualbit_PRT_lessfullNumSen=qualflag_PRTline_lessfullNumSen.';
qualbit_suspect_calibration_BB_temp=  logical(qualbit_PRT_lessfullNumSen)& ~logical(qualbit_padded_data(1,:).');
    
    qualbit_PRT_calib5closest=qualflag_PRT_badline_5closest_TRUE; 
qualbit_suspect_calibration_prt= (logical(qualbit_PRT_calib5closest)|  logical(qualbit_PRT_lessfullNumSen)| logical(qualbit_calib_PRT_fewerlines)) & ~logical(qualbit_padded_data(1,:).');
  
qualbit_suspect_calibration_moon_intrus= (logical(qualbit_calib_Moon_useGoodviews)& ~logical(qualbit_padded_data(1,:).'));

%expand variables to match view x line dimension
exp_qualbit_no_calibration_prt=permute(repmat(qualbit_no_calibration_prt,[1  number_of_fovs]),[2  1]); 
exp_qualbit_no_calibration_moon_intrus=permute(repmat(qualbit_no_calibration_moon_intrus,[1  number_of_fovs]),[2  1]); 
exp_qualbit_suspect_calibration_moon_intrus=permute(repmat(qualbit_suspect_calibration_moon_intrus,[1  number_of_fovs]),[2  1]); 
exp_qualbit_suspect_calibration_BB_temp=permute(repmat(qualbit_suspect_calibration_BB_temp,[1  number_of_fovs]),[2  1]); 
exp_qualbit_suspect_calibration_prt=permute(repmat(qualbit_suspect_calibration_prt,[1  number_of_fovs]),[2  1]); 

% not used so far:
%exp_qualbit_do_not_use_l1bdata=permute(repmat(qualbit_do_not_use_l1bdata,[1  number_of_fovs]),[2  1]); 


%-----------------------------------------------------------------------%
% General part
% uses information from sensor part

%expand variables to match view x line dimension
exp_qualbit_general_noEarthloc=permute(repmat(qualbit_general_noEarthloc,[1  number_of_fovs]),[2  1]);    
exp_combined_earth=permute(repmat(combined_earth,[1  number_of_fovs]),[2  1]);     
exp_qualbit_general_timeseqErr=permute(repmat(qualbit_general_timeseqErr,[1  number_of_fovs]),[2  1]); 
exp_combined_time=permute(repmat(combined_time,[1  number_of_fovs]),[2  1]); 


% compile General flags
% & ~logical(qualbit_padded_data); is for supressing the setting of any
% flags if the scanline is marked as missing.

% qualbit_padded_data is set already above, before "sensor part"
%qualbit_padded_data=exp_qualbit_missing_scanline | qualbit_prev_next_file;
qualbit_invalid_geolocation=(logical(exp_qualbit_general_noEarthloc)| logical(exp_combined_earth)) & ~logical(qualbit_padded_data);
qualbit_invalid_time=(logical(exp_qualbit_general_timeseqErr)| logical(exp_combined_time))& ~logical(qualbit_padded_data);
qualbit_channels_incomplete= (logical(quality_issue_pixel_Ch1_bitmask>3) |logical(quality_issue_pixel_Ch2_bitmask>3) |logical(quality_issue_pixel_Ch3_bitmask>3) |logical(quality_issue_pixel_Ch4_bitmask>3) | logical(quality_issue_pixel_Ch5_bitmask>3)) & ~logical(qualbit_padded_data);
qualbit_sensor_error=(  exp_qualbit_no_calibration_prt | exp_qualbit_no_calibration_moon_intrus) & ~logical(qualbit_padded_data);
qualbit_invalid_input= ( exp_qualbit_no_calibration_moon_intrus |qualbit_exp_calib_Moon_checkfail ) & ~logical(qualbit_padded_data); %FIXME: what shall I include here?
qualbit_use_with_caution=(logical(qualbit_channels_incomplete) | logical(exp_qualbit_suspect_calibration_moon_intrus) | logical(exp_qualbit_suspect_calibration_BB_temp)) & ~logical(qualbit_padded_data);
qualbit_invalid=logical(qualbit_invalid_input)| logical(qualbit_padded_data)| logical(qualbit_sensor_error)| logical(qualbit_invalid_geolocation) | logical(qualbit_invalid_time);


%qualbit_use_with_caution: include suspect-prt for now, since the quality checks on prt might
%wrongly kick out prts that indicate an actual gradient. This would then be
%an un accounted-for error. The IWCT and DSV are probably not so important.
%(unless, the scan dir and gradient are aligned and certain IWCT views are
%kicked out wrongly). Inlcude also a case of suspect_calib_moon_intrus (in
%this case only a sinlge uncontaminated view has been used).

% make "invalid" and "use with caution consistent in the sense that "invalid"
% overrules "use with caution"
% set "use with caution" everywhere, where it applies acc. to its
% definition, BUT NOT where "invalid" is set at the same time
qualbit_use_with_caution_final= qualbit_use_with_caution & ~logical(qualbit_invalid);

%-----------------------------------------------------------------------%
% build bitmask 
quality_pixel_bitmask=exp_qualbit_suspect_calibration_moon_intrus.*2^13+exp_qualbit_suspect_calibration_prt.*2^12 ...
    +exp_qualbit_suspect_calibration_BB_temp.*2^11+exp_qualbit_no_calibration_moon_intrus.*2^10+exp_qualbit_no_calibration_prt.*2^9 + qualbit_exp_calib_Moon_checkfail.*2^8  ...
    +qualbit_channels_incomplete.*2^7+qualbit_padded_data.*2^6+qualbit_sensor_error.*2^5+qualbit_invalid_time.*2^4 ...
    +qualbit_invalid_geolocation.*2^3+qualbit_invalid_input.*2^2+qualbit_use_with_caution_final.*2+qualbit_invalid;


%% summary:
% variables going into writer (all have dimension view x line):
% quality_pixel_bitmask dimension  
% quality_issue_pixel_Ch1_bitmask
% quality_issue_pixel_Ch2_bitmask
% quality_issue_pixel_Ch3_bitmask
% quality_issue_pixel_Ch4_bitmask
% quality_issue_pixel_Ch5_bitmask
% quality_scanline_bitmask (dim: line)


