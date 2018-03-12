
% compile flags from Level1b file per sensor/ add information for SSMT2

% required output:
% qualbit_do_not_use_l1bdata
% qualbit_earth_notEarthloc
% qualbit_earth_questTimecode
% qualbit_earth_margagree
% qualbit_earth_fail
% qualbit_earth_posCheck
% qualbit_SARRB_status
% qualbit_SARRA_status
% qualbit_STX4_status
% qualbit_STX3_status
% qualbit_STX2_status
% qualbit_STX1_status


if strcmp(sen,'mhs') || strcmp(sen,'amsub')

    
            %% original l1b data flags for MHS and AMSUB


            timeline=double(data.time_EpochSecond)*1000;

            % read out general flags
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

            % compile flags (maybe for full FCDR)
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

            
            

            %%% Flags for Transponders' status
            [~,STX1_status]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.STX_1_status,0);
            [~,STX2_status]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.STX_2_status,0);
            [~,STX3_status]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.STX_3_status,0);
            [~,STX4_status]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.STX_4_status,0);
            [~,SARRA_power]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.SARR_A_power,0);
            [~,SARRB_power]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.SARR_B_power,0);

            % make flags with 0 and 1 out of status/ power info: whereever it is >0 we
            % set the flag to 1, meaning ON. Else it is zero.
            qualbit_STX1_status=logical(STX1_status);
            qualbit_STX2_status=logical(STX2_status);
            qualbit_STX3_status=logical(STX3_status);
            qualbit_STX4_status=logical(STX4_status);
            qualbit_SARRA_status=logical(SARRA_power);
            qualbit_SARRB_status=logical(SARRB_power);

            % Time Problem code 
                %fill missing scanlines
            [~,qualbit_badtimefieldbutinferrable_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_bad_time_field_but_inferable,0);
            [~,qualbit_badtimefield_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_bad_time_field,0);
            [~,qualbit_inconstisttime_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_inconsistent_with_previous_times,0);
            [~,qualbit_repeatedscantimes_l1bdata]=fill_missing_scanlines(timeline,scanlinenumbers_original,data.scan_line_quality_flags_repeated_scan_times,0);
            
            qualbit_badtimefieldbutinferrable=qualbit_badtimefieldbutinferrable_l1bdata.';
            qualbit_badtimefield=qualbit_badtimefield_l1bdata.';
            qualbit_inconstisttime=qualbit_inconstisttime_l1bdata.';
            qualbit_repeatedscantimes=qualbit_repeatedscantimes_l1bdata.';

            

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




else
            %% SSMT2 case
            
            % the following flags need to be set per scanline:
            % qualbit_do_not_use_l1bdata
            % qualbit_earth_notEarthloc
            % qualbit_earth_questTimecode
            % qualbit_earth_margagree
            % qualbit_earth_fail
            % qualbit_earth_posCheck
            % qualbit_SARRB_status
            % qualbit_SARRA_status
            % qualbit_STX4_status
            % qualbit_STX3_status
            % qualbit_STX2_status
            % qualbit_STX1_status
            
            % SSMT2 does not have the full information required here.
            % Therefore, we have to create this information or set flags to
            % zero (so that processing works) and delete flag info from
            % writer.
            timeline=double(data.time_EpochSecond)*1000;
            
            % Earthlocation quality info
            [~,qualbit_earth_notEarthloc]=fill_missing_scanlines_SSMT2(timeline,scanlinenumbers_original,data.qualflag_earthloc,0);
            qualbit_earth_notEarthloc=qualbit_earth_notEarthloc.';
            % no further geoloc. availabe. Hence, set all other flags to
            % zero.
            qualbit_earth_questTimecode=0*qualbit_earth_notEarthloc;
            qualbit_earth_margagree=0*qualbit_earth_notEarthloc;
            qualbit_earth_fail=0*qualbit_earth_notEarthloc;
            qualbit_earth_posCheck=0*qualbit_earth_notEarthloc;
            
            qualbit_general_noEarthloc=qualbit_earth_notEarthloc;
            
            % Time problem info
            [~,qualflag_TimeProb_origl1bval]=fill_missing_scanlines_SSMT2(timeline,scanlinenumbers_original,data.bad_time_flag,0);
            qualbit_general_timeseqErr=qualflag_TimeProb_origl1bval.';
            % no further time info availabe. Hence, set all other flags to
            % zero.
            qualbit_badtimefieldbutinferrable=0*qualbit_general_timeseqErr;
            qualbit_badtimefield=0*qualbit_general_timeseqErr;
            qualbit_inconstisttime=0*qualbit_general_timeseqErr;
            qualbit_repeatedscantimes=0*qualbit_general_timeseqErr;
            
            % Transponder status: not available for SSMT2.
            % fill with zeros to enable processing. But no transponder info
            % will be in FCDR.
            qualbit_SARRB_status=0*qualbit_earth_notEarthloc.';
            qualbit_SARRA_status=0*qualbit_earth_notEarthloc.';
            qualbit_STX4_status=0*qualbit_earth_notEarthloc.';
            qualbit_STX3_status=0*qualbit_earth_notEarthloc.';
            qualbit_STX2_status=0*qualbit_earth_notEarthloc.';
            qualbit_STX1_status=0*qualbit_earth_notEarthloc.';
            
            % there is no overall information. Ther is only one calibFlag
            % referring to calculated slope and intercept which we do not
            % use anyway.
            qualbit_do_not_use_l1bdata=0*qualbit_earth_notEarthloc;

    
end