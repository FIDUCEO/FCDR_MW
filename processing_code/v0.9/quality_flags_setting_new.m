

% quality flags setting









%% original l1b data flags

% quality indicator bitfield
qualflag_QualInd_origl1bval_orig=bin2dec(quality_indicator_lines);


% Scanline Quality Flags
% Time Problem Code
qualflag_TimeProb_origl1bval_orig=bin2dec(quality_flags_0_lines);
% Calibration Problem Code
qualflag_CalibProb_origl1bval_orig=bin2dec(quality_flags_2_lines);
% Earth Location Problem code
qualflag_EarthLoc_origl1bval_orig=bin2dec(quality_flags_3_lines);

% Calibration Quality Flags per Channel
% ch1
qualflag_ch1_origl1bval_orig=bin2dec(quality_flags_lines{1}); 
% ch2
qualflag_ch2_origl1bval_orig=bin2dec(quality_flags_lines{2});
% ch3
qualflag_ch3_origl1bval_orig=bin2dec(quality_flags_lines{3});
% ch4
qualflag_ch4_origl1bval_orig=bin2dec(quality_flags_lines{4});
% ch5
qualflag_ch5_origl1bval_orig=bin2dec(quality_flags_lines{5});


% need to fill missing scanlines
% fill missing scanlines with zero (i.e. flag is not set). The "missing
% scanline!"-flag IS set of course.
timeline=double(data.scan_line_UTC_time);
[~,qualflag_QualInd_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_QualInd_origl1bval_orig,0);
[~,qualflag_TimeProb_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_TimeProb_origl1bval_orig,0);
[~,qualflag_CalibProb_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_CalibProb_origl1bval_orig,0);
[~,qualflag_EarthLoc_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_EarthLoc_origl1bval_orig,0);
[~,qualflag_ch1_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_ch1_origl1bval_orig,0);
[~,qualflag_ch2_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_ch2_origl1bval_orig,0);
[~,qualflag_ch3_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_ch3_origl1bval_orig,0);
[~,qualflag_ch4_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_ch4_origl1bval_orig,0);
[~,qualflag_ch5_origl1bval]=fill_missing_scanlines(timeline,scanlinenumbers_original,qualflag_ch5_origl1bval_orig,0);


%% FIDUCEO FULL quality flags
% these encompass the same as the l1b and some more.
% Contentwise: some l1b qualityflags are NOT set by us but copied over from
% l1b.

 
% % compile flags
% %for: qualbit_general_donotuse
% 
% compileflags_general_donotuse{1}=double(qualbit_do_not_use_l1bdata).';
% compileflags_general_donotuse{2}=qualflag_missing_scanline;
% %qualbit_general_noCalib_insuffdata=
% %qualbit_calib_glob_someUncalibChn






% general
% fill missing scanlines with zero (i.e. flag is not set). The "missing
% scanline!"-flag IS set of course.
[~,qualbit_do_not_use_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.quality_indicator_dont_use_for_product_generation,0);
[~,qualbit_general_timeseqErr_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_not_earth_located_bad_time,0);
[~,qualbit_general_datagap_bfline_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_location_questionable_time_code,0);
[~,qualbit_general_noCalib_insuffdata_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_marginal_agreement,0);
[~,qualbit_general_noEarthloc_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_fail,0);
[~,qualbit_general_1stgoodtime_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_not_earth_located_bad_time,0);
[~,qualbit_general_instrstatuschanged_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_location_questionable_time_code,0);
[~,qualbit_general_uncertnewbias_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_marginal_agreement,0);
[~,qualbit_general_newbias_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_fail,0);
[~,qualbit_general_transmitterchange_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_not_earth_located_bad_time,0);
[~,qualbit_general_AMSUsyncErr_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_location_questionable_time_code,0);
[~,qualbit_general_AMSUminorFrErr_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_marginal_agreement,0);
[~,qualbit_general_AMSUmajorFrErr_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_fail,0);
[~,qualbit_general_AMSUparityErr_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_fail,0);


qualbit_general_missline=qualflag_missing_scanline;
qualbit_general_donotuse=logical(qualbit_do_not_use_l1bdata.')|logical(qualflag_missing_scanline); 
qualbit_general_timeseqErr=qualbit_general_timeseqErr_l1bdata.';
qualbit_general_datagap_bfline=qualbit_general_datagap_bfline_l1bdata.';
qualbit_general_noCalib_insuffdata=logical(qualflag_PRT_badline_furtherthan5lines.')|logical(qualbit_general_noCalib_insuffdata_l1bdata.');
qualbit_general_noEarthloc=qualbit_general_noEarthloc_l1bdata.';
qualbit_general_1stgoodtime=qualbit_general_1stgoodtime_l1bdata.';
qualbit_general_instrstatuschanged=qualbit_general_instrstatuschanged_l1bdata.';
qualbit_general_uncertnewbias=qualbit_general_uncertnewbias_l1bdata.';
qualbit_general_newbias=qualbit_general_newbias_l1bdata.';
qualbit_general_transmitterchange=qualbit_general_transmitterchange_l1bdata.';
qualbit_general_AMSUsyncErr=qualbit_general_AMSUsyncErr_l1bdata.';
qualbit_general_AMSUminorFrErr=qualbit_general_AMSUminorFrErr_l1bdata.';
qualbit_general_AMSUmajorFrErr=qualbit_general_AMSUmajorFrErr_l1bdata.';
qualbit_general_AMSUparityErr=qualbit_general_AMSUparityErr_l1bdata.';

general_mat=[qualbit_general_missline,...
    qualbit_general_donotuse,...
    qualbit_general_timeseqErr,...
    qualbit_general_datagap_bfline,...
    qualbit_general_noCalib_insuffdata,...
    qualbit_general_noEarthloc,...
    qualbit_general_1stgoodtime,...
    qualbit_general_instrstatuschanged,...
    qualbit_general_uncertnewbias,...
    qualbit_general_transmitterchange,...
    qualbit_general_AMSUsyncErr,...
    qualbit_general_AMSUminorFrErr,...
    qualbit_general_AMSUmajorFrErr,...
    qualbit_general_AMSUparityErr];
% this transforms each row of zeros and ones into decimal number by
% calculating the 2^x for each position.
qualflag_general=sum(bsxfun(@pow2,general_mat,size(general_mat,2)-1:-1:0),2);



% Scanline Quality Flags
% Time Problem Code (copied from l1b)
qualflag_TimeProb_origl1bval_orig=qualflag_TimeProb_origl1bval;

% Earth Location Problem code (all but the 1st bit  copied from l1b)
    %fill missing scanlines
[~,qualbit_earth_notEarthloc_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_not_earth_located_bad_time,0);
[~,qualbit_earth_questTimecode_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_location_questionable_time_code,0);
[~,qualbit_earth_margagree_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_marginal_agreement,0);
[~,qualbit_earth_fail_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_earth_loc_check_fail,0);

qualbit_earth_notEarthloc=qualbit_earth_notEarthloc_l1bdata.';
qualbit_earth_questTimecode=qualbit_earth_questTimecode_l1bdata.';
qualbit_earth_margagree=qualbit_earth_margagree_l1bdata.';
qualbit_earth_fail=qualbit_earth_fail_l1bdata.';
qualbit_earth_posCheck=qualflag_EarthlocProblem;%data.scan_line_quality_flags_earth_loc_questionable_position_check.';

%needed for later easy-FCDR flags:
combined_earth=logical(qualbit_earth_notEarthloc) | logical(qualbit_earth_questTimecode) | logical(qualbit_earth_margagree) | logical(qualbit_earth_fail) | logical(qualbit_earth_posCheck);

earth_mat=[qualbit_earth_notEarthloc,...
    qualbit_earth_questTimecode,...
    qualbit_earth_margagree,...
    qualbit_earth_fail,...
    qualbit_earth_posCheck];

qualflag_earth=sum(bsxfun(@pow2,earth_mat,size(earth_mat,2)-1:-1:0),2);

% Calibration Problem Code (the 5th and 6th copied over from l1b)
    %fill missing scanlines
[~,qualbit_calib_glob_badtime_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_not_calibrated_bad_time,0);
[~,qualbit_calib_glob_nocalibinstrmode_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_uncalibrated_instrument_mode,0);

qualbit_calib_glob_badtime=qualbit_calib_glob_badtime_l1bdata.';
qualbit_calib_glob_nocalibinstrmode=qualbit_calib_glob_nocalibinstrmode_l1bdata.';
% this flag should not be needed for us, if we process the 3 before the
% file and after. Then the true startingline (the Eqcrossing line) is
% correctly calibrated and no flag is necessary. It is necessary only to
% flag missing lines due to data gap:
qualbit_calib_glob_fewerlines_startend_datagap=logical(qualflag_PRT_fewerlines_used.'); 
qualbit_calib_glob_IWCTposErr=qualflag_IWCTlocProblem;
qualbit_calib_glob_DSVposErr=qualflag_DSVlocProblem;
% some intermed. steps:
    % expand moonflagOneViewOk to whole chn x scnlin dimension
    qualflag_moononeviewok=repmat(moonflagOneViewOk,[1 5]).';
    intermedstep=(logical(qualflag_DSV_badline_furtherthan5lines) & ~logical(qualflag_moononeviewok)).';
qualbit_calib_glob_someUncalibChn=logical(max(qualflag_IWCT_badline_furtherthan5lines.',[],2))|...
    logical(max(intermedstep,[],2)) | logical(qualflag_PRT_badline_furtherthan5lines.');

calib_glob_mat=[qualbit_calib_glob_badtime,...
    qualbit_calib_glob_nocalibinstrmode,...
    qualbit_calib_glob_fewerlines_startend_datagap,...
    qualbit_calib_glob_IWCTposErr,...
    qualbit_calib_glob_DSVposErr,...
    qualbit_calib_glob_someUncalibChn];

qualflag_calib_glob=sum(bsxfun(@pow2,calib_glob_mat,size(calib_glob_mat,2)-1:-1:0),2);

% Calibration Problem PRT

qualbit_calib_PRT_allSenbad=qualflag_allbadPRT.';
qualbit_calib_PRT_notcalib=qualflag_PRT_badline_furtherthan5lines.';
qualbit_calib_PRT_calib5closest=qualflag_PRT_badline_furtherthan5lines.';
qualbit_calib_PRT_margPRT=qualflag_PRTline_lessfullNumSen.';
qualbit_calib_PRT_increasedUncert= logical(qualflag_PRTline_lessfullNumSen.') | logical(qualflag_PRT_fewerlines_used.');
qualbit_calib_PRT_fewerlines=qualflag_PRT_fewerlines_used.';
qualbit_calib_PRT_bfjump=qualflag_PRTline_good_bef_jump.';

prt_calib_mat=[qualbit_calib_PRT_allSenbad,...
    qualbit_calib_PRT_notcalib,...
    qualbit_calib_PRT_calib5closest,...
    qualbit_calib_PRT_margPRT,...
    qualbit_calib_PRT_increasedUncert,...
    qualbit_calib_PRT_fewerlines,...
    qualbit_calib_PRT_bfjump];

qualflag_calib_PRT=sum(bsxfun(@pow2,prt_calib_mat,size(prt_calib_mat,2)-1:-1:0),2);


% Calibration Problem Moon Intrusion
qualbit_calib_Moon_checkfail=moon_global_donotuse; %PLACEHOLDERmoon_global_donotuse;
qualbit_calib_Moon_noCalib=moonflagAllViewsBad; %needs crosscheck with scnlin av. flags
%qualbit_calib_Moon_calib5closest= %probably to be deleted!
qualbit_calib_Moon_useGoodviews=moonflagOneViewOk;
qualbit_calib_Moon_increasedUncert=moonflagOneViewOk;
qualbit_calib_Moon_noImpact=moonflagMoonCloserButNotSignificant;

moon_mat=[qualbit_calib_Moon_checkfail,...
    qualbit_calib_Moon_noCalib,...
    qualbit_calib_Moon_useGoodviews,...
    qualbit_calib_Moon_increasedUncert,...
    qualbit_calib_Moon_noImpact];

qualflag_calib_Moon=sum(bsxfun(@pow2,moon_mat,size(moon_mat,2)-1:-1:0),2);


% Calibration Quality Flags per Channel

% prepare for all channels:
% expand moonflagOneViewOk to whole chn x scnlin dimension
qualflag_moononeviewok=repmat(moonflagOneViewOk,[1 5]).';

qualbit_IWCT_allViewsbad=qualflag_allbadIWCT.';
qualbit_DSV_allViewsbad=qualflag_allbadDSV.';
qualbit_IWCT_nocalib=qualflag_IWCT_badline_furtherthan5lines.';
qualbit_DSV_nocalib=(logical(qualflag_DSV_badline_furtherthan5lines) & ~logical(qualflag_moononeviewok)).'; %remove the moonokview-lines! since they got overwritten with the goodview-counts: "furtheraway-case AND NOT Moonokview-case"
qualbit_IWCT_calib5closest=qualflag_IWCT_badline_5closest_TRUE.';
qualbit_DSV_calib5closest=qualflag_DSV_badline_5closest_TRUE.'; %the TRUE stands for: the moonokview cases are already taken out (in the qualitychecksDSV_allchn routine)
qualbit_IWCT_less4Views=qualflag_IWCTline_less4views.';
qualbit_DSV_less4Views=(logical(qualflag_DSVline_less4views)& logical(qualflag_moononeviewok)).'; % include the cases where less views haven been used due to Moon intrusion
qualbit_IWCT_increasedUncert= logical(qualflag_IWCTline_less4views.') | logical(qualflag_IWCT_fewerlines_used.');
qualbit_DSV_increasedUncert= logical(qualflag_DSVline_less4views.') | logical(qualflag_DSV_fewerlines_used.');
qualbit_IWCT_fewerlines=qualflag_IWCT_fewerlines_used.';
qualbit_DSV_fewerlines=qualflag_DSV_fewerlines_used.';
qualbit_IWCT_bfjump=qualflag_IWCTline_good_bef_jump.';
qualbit_DSV_bfjump=qualflag_DSVline_good_bef_jump.';

% ch1
% %%old way to get the decimal number. Too slow due to num2str
% qualflag_ch1=bin2dec(num2str([qualbit_IWCT_allViewsbad(:,1), ...
%     qualbit_DSV_allViewsbad(:,1),...
%     qualbit_IWCT_nocalib(:,1),...
%     qualbit_DSV_nocalib(:,1),...
%     qualbit_IWCT_calib5closest(:,1),...
%     qualbit_DSV_calib5closest(:,1),...
%     qualbit_IWCT_less4Views(:,1),...
%     qualbit_DSV_less4Views(:,1),...
%     qualbit_IWCT_increasedUncert(:,1),...
%     qualbit_DSV_increasedUncert(:,1),...
%     qualbit_IWCT_fewerlines(:,1),...
%     qualbit_DSV_fewerlines(:,1),...
%     qualbit_IWCT_bfjump(:,1),...
%     qualbit_DSV_bfjump(:,1)]));

% faster way
ch1_mat=[qualbit_IWCT_allViewsbad(:,1), ...
    qualbit_DSV_allViewsbad(:,1),...
    qualbit_IWCT_nocalib(:,1),...
    qualbit_DSV_nocalib(:,1),...
    qualbit_IWCT_calib5closest(:,1),...
    qualbit_DSV_calib5closest(:,1),...
    qualbit_IWCT_less4Views(:,1),...
    qualbit_DSV_less4Views(:,1),...
    qualbit_IWCT_increasedUncert(:,1),...
    qualbit_DSV_increasedUncert(:,1),...
    qualbit_IWCT_fewerlines(:,1),...
    qualbit_DSV_fewerlines(:,1),...
    qualbit_IWCT_bfjump(:,1),...
    qualbit_DSV_bfjump(:,1)];

qualflag_ch1=sum(bsxfun(@pow2,ch1_mat,size(ch1_mat,2)-1:-1:0),2);

% ch2
ch2_mat=[qualbit_IWCT_allViewsbad(:,2), ...
    qualbit_DSV_allViewsbad(:,2),...
    qualbit_IWCT_nocalib(:,2),...
    qualbit_DSV_nocalib(:,2),...
    qualbit_IWCT_calib5closest(:,2),...
    qualbit_DSV_calib5closest(:,2),...
    qualbit_IWCT_less4Views(:,2),...
    qualbit_DSV_less4Views(:,2),...
    qualbit_IWCT_increasedUncert(:,2),...
    qualbit_DSV_increasedUncert(:,2),...
    qualbit_IWCT_fewerlines(:,2),...
    qualbit_DSV_fewerlines(:,2),...
    qualbit_IWCT_bfjump(:,2),...
    qualbit_DSV_bfjump(:,2)];

qualflag_ch2=sum(bsxfun(@pow2,ch2_mat,size(ch2_mat,2)-1:-1:0),2);

% ch3
ch3_mat=[qualbit_IWCT_allViewsbad(:,3), ...
    qualbit_DSV_allViewsbad(:,3),...
    qualbit_IWCT_nocalib(:,3),...
    qualbit_DSV_nocalib(:,3),...
    qualbit_IWCT_calib5closest(:,3),...
    qualbit_DSV_calib5closest(:,3),...
    qualbit_IWCT_less4Views(:,3),...
    qualbit_DSV_less4Views(:,3),...
    qualbit_IWCT_increasedUncert(:,3),...
    qualbit_DSV_increasedUncert(:,3),...
    qualbit_IWCT_fewerlines(:,3),...
    qualbit_DSV_fewerlines(:,3),...
    qualbit_IWCT_bfjump(:,3),...
    qualbit_DSV_bfjump(:,3)];

qualflag_ch3=sum(bsxfun(@pow2,ch3_mat,size(ch3_mat,2)-1:-1:0),2);

% ch4
ch4_mat=[qualbit_IWCT_allViewsbad(:,4), ...
    qualbit_DSV_allViewsbad(:,4),...
    qualbit_IWCT_nocalib(:,4),...
    qualbit_DSV_nocalib(:,4),...
    qualbit_IWCT_calib5closest(:,4),...
    qualbit_DSV_calib5closest(:,4),...
    qualbit_IWCT_less4Views(:,4),...
    qualbit_DSV_less4Views(:,4),...
    qualbit_IWCT_increasedUncert(:,4),...
    qualbit_DSV_increasedUncert(:,4),...
    qualbit_IWCT_fewerlines(:,4),...
    qualbit_DSV_fewerlines(:,4),...
    qualbit_IWCT_bfjump(:,4),...
    qualbit_DSV_bfjump(:,4)];

qualflag_ch4=sum(bsxfun(@pow2,ch4_mat,size(ch4_mat,2)-1:-1:0),2);

% ch5
ch5_mat=[qualbit_IWCT_allViewsbad(:,5), ...
    qualbit_DSV_allViewsbad(:,5),...
    qualbit_IWCT_nocalib(:,5),...
    qualbit_DSV_nocalib(:,5),...
    qualbit_IWCT_calib5closest(:,5),...
    qualbit_DSV_calib5closest(:,5),...
    qualbit_IWCT_less4Views(:,5),...
    qualbit_DSV_less4Views(:,5),...
    qualbit_IWCT_increasedUncert(:,5),...
    qualbit_DSV_increasedUncert(:,5),...
    qualbit_IWCT_fewerlines(:,5),...
    qualbit_DSV_fewerlines(:,5),...
    qualbit_IWCT_bfjump(:,5),...
    qualbit_DSV_bfjump(:,5)];

qualflag_ch5=sum(bsxfun(@pow2,ch5_mat,size(ch5_mat,2)-1:-1:0),2);

% Earth counts Problem

% ch1
qualbit_ch1_Earthcountbad=squeeze(qualflag_badscanlinesEarth_pix(1,:,:));

qualflag_ch1_Earthcountbad=uint8(qualbit_ch1_Earthcountbad); %does not need bin2dec, since it is 0 or 1 only.

% ch2
qualbit_ch2_Earthcountbad=squeeze(qualflag_badscanlinesEarth_pix(2,:,:));

qualflag_ch2_Earthcountbad=uint8(qualbit_ch2_Earthcountbad); %does not neeed bin2dec, since it is 0 or 1 only.

% ch3
qualbit_ch3_Earthcountbad=squeeze(qualflag_badscanlinesEarth_pix(3,:,:));

qualflag_ch3_Earthcountbad=uint8(qualbit_ch3_Earthcountbad); %does not neeed bin2dec, since it is 0 or 1 only.

% ch4
qualbit_ch4_Earthcountbad=squeeze(qualflag_badscanlinesEarth_pix(4,:,:));

qualflag_ch4_Earthcountbad=uint8(qualbit_ch4_Earthcountbad); %does not neeed bin2dec, since it is 0 or 1 only.

% ch5
qualbit_ch5_Earthcountbad=squeeze(qualflag_badscanlinesEarth_pix(5,:,:));

qualflag_ch5_Earthcountbad=uint8(qualbit_ch5_Earthcountbad); %does not neeed bin2dec, since it is 0 or 1 only.



%% FIDUCEO EASY quality flags

% compile the individual flag bit for easy FCDR


%% General issues: quality_issue_scnlin_bitmask

qualbit_missing_scanline=qualflag_missing_scanline;
qualbit_suspect_geolocation=logical(qualbit_general_noEarthloc)| logical(combined_earth);
qualbit_suspect_timing=logical(qualbit_general_timeseqErr)| logical(qualflag_TimeProb_origl1bval_orig);
qualbit_no_calibration_prt=qualflag_PRT_badline_furtherthan5lines.';

    qualbit_PRT_calib5closest=qualflag_PRT_badline_5closest_TRUE; 
    qualbit_PRT_lessfullNumSen=qualflag_PRTline_lessfullNumSen.';
qualbit_suspect_calibration_prt= logical(qualbit_PRT_calib5closest) | logical(qualbit_PRT_lessfullNumSen); %|include also logical(qualbit_PRT_fewerlines)


scnlin_bitmask_mat=[qualbit_missing_scanline,...
    qualbit_suspect_geolocation,...
    qualbit_suspect_timing,...
    qualbit_no_calibration_prt,...
    qualbit_suspect_calibration_prt];

quality_issue_scnlin_bitmask=sum(bsxfun(@pow2,scnlin_bitmask_mat,size(scnlin_bitmask_mat,2)-1:-1:0),2);


%% Channel specific issues: quality_issue_pixel_ChX_bitmask

%qualflag_chX_Earthcountbad= from full set of flags

% for the no-calibration flag, compile

% qualbit_calib_Moon_noCalib
% qualbit_IWCT_nocalib DONE
% qualbit_DSV_nocalib DONE

qualbit_no_calibration_IWCT_or_DSV=logical(qualbit_IWCT_nocalib) | logical(qualbit_DSV_nocalib); %FIXME!!! include the following:| logical(qualbit_calib_Moon_checkfail) | logical(qualbit_calib_Moon_noCalib);


%expand to match chn X pixel x scnlin 
expand_qualbit_no_calibration_IWCT_or_DSV=permute(repmat(qualbit_no_calibration_IWCT_or_DSV,[1 1 90]),[2 3 1]);


%for the suspect calibration flag, compile (for each DSV and IWCT)
% qualbit_IWCT_calib5closest
% qualbit_IWCT_less4Views
% qualbit_IWCT_fewerlines  NEEDS TO BE DETERMINED
% qualbit_DSV_calib5closest
% qualbit_DSV_less4Views
% qualbit_DSV_fewerlines NEEDS TO BE DETERMINED
% qualflag_moononeviewok (it is the qualbit_calib_Moon_useGoodviews expanded to chn x scnlin)

qualbit_suspect_calibration_IWCT_or_DSV=logical(qualbit_IWCT_calib5closest) | logical(qualbit_DSV_calib5closest) ...
    | logical(qualbit_IWCT_less4Views) | logical(qualbit_DSV_less4Views) ;% FIXME include the following| logical(qualbit_IWCT_fewerlines) | logical(qualbit_DSV_fewerlines) ...
%    | logical(qualflag_moononeviewok.');

%expand to match  channel x pixel x scnlin 
expand_qualbit_suspect_calibration_IWCT_or_DSV=permute(repmat(qualbit_suspect_calibration_IWCT_or_DSV,[1 1 90]),[2 3 1]);



% 3rdbit*2^2+2ndbit*2^1+1stbit*2^0;
quality_issue_pixel_bitmask=qualflag_badscanlinesEarth_pix.*2^2+expand_qualbit_no_calibration_IWCT_or_DSV.*2+expand_qualbit_suspect_calibration_IWCT_or_DSV;
quality_issue_pixel_Ch1_bitmask=squeeze(quality_issue_pixel_bitmask(1,:,:));
quality_issue_pixel_Ch2_bitmask=squeeze(quality_issue_pixel_bitmask(2,:,:));
quality_issue_pixel_Ch3_bitmask=squeeze(quality_issue_pixel_bitmask(3,:,:));
quality_issue_pixel_Ch4_bitmask=squeeze(quality_issue_pixel_bitmask(4,:,:));
quality_issue_pixel_Ch5_bitmask=squeeze(quality_issue_pixel_bitmask(5,:,:));


%% Summary flags: quality_pixel_ChX_bitmask
% WATCHOUT I am doing this per channel, although asked for differently by
% project
%qualbit_donotuse_fiduceo
%qualbit_donotuse_sensor_failure
%qualbit_use_withcaution



% for the qualbit_donotuse_fiduceo flag, compile
% qualbit_calib_Moon_checkfail
% incomplete uncertainty (no Allan Dev. was calculated?)
% 

not_expanded_qualbit_donotuse_fiduceo=logical(qualbit_calib_Moon_checkfail); % MORE TO INCLUDE?

%expand to match chn X pixel x scnlin 
qualbit_donotuse_fiduceo=permute(repmat(not_expanded_qualbit_donotuse_fiduceo,[1 5 90]),[2 3 1]);


%for the qualbit_donotuse_sensor_failure flag, compile 
% ???
% qualbit_missing_scanline
% qualbit_no_calibration_prt
% qualbit_no_calibration_IWCT_or_DSV
% further flag that asks whether any Tb is out of range 90 to 310 K?:
% qualbit_tb_badrange

%expand single flags to match  channel x pixel x scnlin 
expand_qualbit_missing_scanline=permute(repmat(qualbit_missing_scanline,[1 5 90]),[2 3 1]);
expand_qualbit_no_calibration_prt=permute(repmat(qualbit_no_calibration_prt,[1 5 90]),[2 3 1]);
%done already above: expand_qualbit_no_calibration_IWCT_or_DSV=permute(repmat(qualbit_no_calibration_IWCT_or_DSV,[1 1 90]),[2 3 1]);


qualbit_donotuse_sensor_failure=logical(expand_qualbit_missing_scanline) | logical(expand_qualbit_no_calibration_prt) |...
    logical(expand_qualbit_no_calibration_IWCT_or_DSV) | logical(qualbit_tb_badrange);



%for the qualbit_use_withcaution flag, compile 

% qualbit_suspect_calibration_prt=
% qualbit_suspect_calibration_IWCT_or_DSV

%expand single flags to match  channel x pixel x scnlin 
expand_qualbit_suspect_calibration_prt=permute(repmat(qualbit_suspect_calibration_prt,[1 5 90]),[2 3 1]);
%done already above: expand_qualbit_suspect_calibration_IWCT_or_DSV=permute(repmat(qualbit_suspect_calibration_IWCT_or_DSV,[1 1 90]),[2 3 1]);

%include only suspect-prt for now, since the quality checks on prt might
%wrongly kick out prts that indicate an actual gradient. This would then be
%an un accounted-for error. The IWCT and DSV are probably not so important.
%(unless, the scan dir and gradient are aligned and certain IWCT views are
%kicked out wrongly).
qualbit_use_withcaution=logical(expand_qualbit_suspect_calibration_prt); %| logical(expand_qualbit_suspect_calibration_IWCT_or_DSV);

% for the FULL FCDR
% maybe this should be included in this quality pixel -bitmask
% qualbit: "data for this line is store in previous/ next file. In case of
% a data gap larger than one orbit, the data for this line could not be
% calibrated correctly and was rejected "

qualbit_prev_next_file=zeros(size(btemps));
qualbit_prev_next_file(:,:,1:3)=1;
qualbit_prev_next_file(:,:,end-3:end)=1;


% Workaround to get bitmask without using bin2dec and num2str that do not
% work on matrices.
% use all qualbits_ on pixel x scnlin dimension:
% multiply them by *2^y with y being the bitposition (0=1st pos...).
% Then add the matrices and you have the quality_pixel_ChX_bitmask:
% 3rdbit*2^2+2ndbit*2^1+1stbit*2^0;
quality_pixel_perchn_bitmask=qualbit_prev_next_file.*2^3+qualbit_donotuse_fiduceo.*2^2+qualbit_donotuse_sensor_failure.*2+qualbit_use_withcaution;
quality_pixel_Ch1_bitmask=squeeze(quality_pixel_perchn_bitmask(1,:,:));
quality_pixel_Ch2_bitmask=squeeze(quality_pixel_perchn_bitmask(2,:,:));
quality_pixel_Ch3_bitmask=squeeze(quality_pixel_perchn_bitmask(3,:,:));
quality_pixel_Ch4_bitmask=squeeze(quality_pixel_perchn_bitmask(4,:,:));
quality_pixel_Ch5_bitmask=squeeze(quality_pixel_perchn_bitmask(5,:,:));




%% outdated
% get qualflag on pixel level (bin2dec does not work on matrix)
% Do this: 1.compile a normal "per-scanline flag" (without pixel dim) and use bin2dec on it. 2. Then
% expand it to pixel dim. 3. Then add it to the earthcount-flag (that really
% has pixel dim but is only 1 or 0 and needs no bin2dec).

% % 1.
% intermed_quality_issue_pixel_Ch1_bitmask=bin2dec(num2str([qualbit_no_calibration_IWCT_or_DSV(:,1),...
%     qualbit_suspect_calibration_IWCT_or_DSV(:,1)]));
% % 2.
% expand_intermed_quality_issue_pixel_Ch1_bitmask=repmat(intermed_quality_issue_pixel_Ch1_bitmask,[1 90]).';
% % 3.
% quality_issue_pixel_Ch1_bitmask=expand_intermed_quality_issue_pixel_Ch1_bitmask+qualbit_ch1_Earthcountbad;
% 
% 
% % 1.
% intermed_quality_issue_pixel_Ch2_bitmask=bin2dec(num2str([qualbit_no_calibration_IWCT_or_DSV(:,2),...
%     qualbit_suspect_calibration_IWCT_or_DSV(:,2)]));
% % 2.
% expand_intermed_quality_issue_pixel_Ch2_bitmask=repmat(intermed_quality_issue_pixel_Ch2_bitmask,[1 90]).';
% % 3.
% quality_issue_pixel_Ch2_bitmask=expand_intermed_quality_issue_pixel_Ch2_bitmask+qualbit_ch2_Earthcountbad;
% 
% 
% % 1.
% intermed_quality_issue_pixel_Ch3_bitmask=bin2dec(num2str([qualbit_no_calibration_IWCT_or_DSV(:,3),...
%     qualbit_suspect_calibration_IWCT_or_DSV(:,3)]));
% % 2.
% expand_intermed_quality_issue_pixel_Ch3_bitmask=repmat(intermed_quality_issue_pixel_Ch3_bitmask,[1 90]).';
% % 3.
% quality_issue_pixel_Ch3_bitmask=expand_intermed_quality_issue_pixel_Ch3_bitmask+qualbit_ch3_Earthcountbad;
% 
% 
% % 1.
% intermed_quality_issue_pixel_Ch4_bitmask=bin2dec(num2str([qualbit_no_calibration_IWCT_or_DSV(:,4),...
%     qualbit_suspect_calibration_IWCT_or_DSV(:,4)]));
% % 2.
% expand_intermed_quality_issue_pixel_Ch4_bitmask=repmat(intermed_quality_issue_pixel_Ch4_bitmask,[1 90]).';
% % 3.
% quality_issue_pixel_Ch4_bitmask=expand_intermed_quality_issue_pixel_Ch4_bitmask+qualbit_ch4_Earthcountbad;
% 
% 
% % 1.
% intermed_quality_issue_pixel_Ch5_bitmask=bin2dec(num2str([qualbit_no_calibration_IWCT_or_DSV(:,5),...
%     qualbit_suspect_calibration_IWCT_or_DSV(:,5)]));
% % 2.
% expand_intermed_quality_issue_pixel_Ch5_bitmask=repmat(intermed_quality_issue_pixel_Ch5_bitmask,[1 90]).';
% % 3.
% quality_issue_pixel_Ch5_bitmask=expand_intermed_quality_issue_pixel_Ch5_bitmask+qualbit_ch5_Earthcountbad;





%%%%%%% outdated: 

% % General (on scan line level)
% qualbit_general_easy_missline=qualflag_missing_scanline;
% qualbit_general_easy_donotuse=zeros(size(data.scan_line_quality_flags_uncalibrated_instrument_mode.')); %PLACEHOLDER
% qualbit_general_easy_suspGeoloc=zeros(size(data.scan_line_quality_flags_uncalibrated_instrument_mode.')); %PLACEHOLDER
% qualbit_general_easy_suspTime=zeros(size(data.scan_line_quality_flags_uncalibrated_instrument_mode.')); %PLACEHOLDER
% qualbit_general_easy_suspCalib=zeros(size(data.scan_line_quality_flags_uncalibrated_instrument_mode.')); %PLACEHOLDER
% 
% qualflag_general_easy=bin2dec(num2str([qualbit_general_easy_missline,...
%     qualbit_general_easy_donotuse,...
%     qualbit_general_easy_suspGeoloc,...
%     qualbit_general_easy_suspTime,...
%     qualbit_general_easy_suspCalib]));
% 
% % Channel specific (on scanline level per channel)
% 
% % ch1
% qualbit_ch1_easy_donotuse=zeros(size(data.scan_line_quality_flags_uncalibrated_instrument_mode.')); %PLACEHOLDER
% qualbit_ch1_easy_suspCalib=zeros(size(data.scan_line_quality_flags_uncalibrated_instrument_mode.')); %PLACEHOLDER
% qualbit_ch1_easy_noComplUncert=zeros(size(data.scan_line_quality_flags_uncalibrated_instrument_mode.')); %PLACEHOLDER
% 
% qualflag_ch1_easy=bin2dec(num2str([qualbit_ch1_easy_donotuse,...
%     qualbit_ch1_easy_suspCalib,...
%     qualbit_ch1_easy_noComplUncert]));
% 
% % ch2
% 
% % ch3
% 
% % ch4
% 
% % ch5
% 
% % Channel specific for earth counts (on scanline x pixel level per channel)
% % use exactly the same as for Full FCDR, see above
% %variable name: qualflag_chX_Earthcountbad; should be named quality_pixel_bitmask


