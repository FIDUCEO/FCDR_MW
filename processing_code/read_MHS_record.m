% READ_MHS_RECORD   Read all record entries of MHS data file.
%
% The function extracts record entries of an MHS 
% data file.
%
% FORMAT   data = read_MHS_record( record );
%
% IN    record 


function [data, quality_indicator_lines,quality_flags_0_lines,quality_flags_1_lines,quality_flags_2_lines,quality_flags_3_lines,quality_flags_lines ] = read_MHS_record( record, nlines_read, rlen ,startline)
% Extracting data fields
% read Calibration Quality Flags
% Index numbers correspond to start/end octet from the KLM User Guide, see above.

%nlines_read=endline;

for l = startline:nlines_read
data.scan_line_number(l-startline+1)                                                    = extract_uint16(record, rlen*(l-1)+1, rlen*(l-1)+2); 
data.scan_line_year(l-startline+1)                                                      = extract_uint16(record, rlen*(l-1)+3, rlen*(l-1)+4);
data.scan_line_day_of_year(l-startline+1)                                               = extract_uint16(record, rlen*(l-1)+5, rlen*(l-1)+6);
data.satellite_clock_drift_delta(l-startline+1)                                         = extract_int16(record, rlen*(l-1)+7, rlen*(l-1)+8);
data.scan_line_UTC_time(l-startline+1)                                                  = extract_uint32(record, rlen*(l-1)+9, rlen*(l-1)+12);

scan_line_correction                                                        		= dec2bin(extract_uint16(record, rlen*(l-1)+13, rlen*(l-1)+14),16);
data.scan_line_satellite_direction(l-startline+1)                                       = str2double(scan_line_correction(1));
data.scan_line_clock_drift_correction(l-startline+1)                                    = str2double(scan_line_correction(2));
data.major_frame_count(l-startline+1)                                                   = extract_uint16(record, rlen*(l-1)+15, rlen*(l-1)+16);
data.coarse_MHS_onboard_time(l-startline+1)                                             = extract_uint32(record, rlen*(l-1)+17, rlen*(l-1)+20);
data.fine_MHS_onboard_time(l-startline+1)                                               = extract_uint16(record, rlen*(l-1)+21, rlen*(l-1)+22);
data.MHS_mode_flag(l-startline+1)                                                       = extract_uint8(record, rlen*(l-1)+23, rlen*(l-1)+23); 

quality_indicator                                                          		= dec2bin(extract_uint32(record, rlen*(l-1)+25, rlen*(l-1)+28),32);
quality_indicator_lines(l-startline+1,:)                                    	= quality_indicator;
% data.quality_indicator_dont_use_for_product_generation(l-startline+1)                   = str2double(quality_indicator(1));
% data.quality_indicator_time_sequence_error_detected(l-startline+1)                      = str2double(quality_indicator(2));
% data.quality_indicator_data_gap_precedes_scan(l-startline+1)                            = str2double(quality_indicator(3));
% data.quality_indicator_insufficient_calibration_data(l-startline+1)                     = str2double(quality_indicator(4));
% data.quality_indicator_no_earth_location(l-startline+1)                                 = str2double(quality_indicator(5));
% data.quality_indicator_good_time_following_clockupdate(l-startline+1)                   = str2double(quality_indicator(6));
% data.quality_indicator_instrument_status_change(l-startline+1)                          = str2double(quality_indicator(7));
% data.quality_indicator_transmitter_status_change(l-startline+1)                         = str2double(quality_indicator(28));
% data.quality_indicator_AMSU_sync_error(l-startline+1)                                   = str2double(quality_indicator(29));
% data.quality_indicator_AMSU_minor_frame_error(l-startline+1)                            = str2double(quality_indicator(30));
% data.quality_indicator_AMSU_major_frame_error(l-startline+1)                            = str2double(quality_indicator(31));
% data.quality_indicator_AMSU_parity_error(l-startline+1)                                 = str2double(quality_indicator(32));

quality_flags_0                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+29, rlen*(l-1)+29),8);
quality_flags_1                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+30, rlen*(l-1)+30),8);
quality_flags_2                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+31, rlen*(l-1)+31),8);
quality_flags_3                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+32, rlen*(l-1)+32),8);

quality_flags_0_lines(l-startline+1,:)						    	=quality_flags_0;
quality_flags_1_lines(l-startline+1,:)						    	=quality_flags_1;
quality_flags_2_lines(l-startline+1,:)						    	=quality_flags_2;
quality_flags_3_lines(l-startline+1,:)						    	=quality_flags_3;

% data.scan_line_quality_flags_contains_lunar_contaminated_space_view(l-startline+1)      = str2double(quality_flags_1(7));
% data.scan_line_quality_flags_lunar_contaminated_line_was_calibrated(l-startline+1)      = str2double(quality_flags_1(8));
% data.scan_line_quality_flags_bad_time_field_but_inferable(l-startline+1)                = str2double(quality_flags_0(1));
% data.scan_line_quality_flags_bad_time_field(l-startline+1)                              = str2double(quality_flags_0(2));
% data.scan_line_quality_flags_inconsistent_with_previous_times(l-startline+1)            = str2double(quality_flags_0(3));
% data.scan_line_quality_flags_repeated_scan_times(l-startline+1)                         = str2double(quality_flags_0(4));
% data.scan_line_quality_flags_not_calibrated_bad_time(l-startline+1)                     = str2double(quality_flags_2(1));
% data.scan_line_quality_flags_calibrated_with_fewer_scanlines(l-startline+1)             = str2double(quality_flags_2(2));
% data.scan_line_quality_flags_not_calibrated_bad_PRT_data(l-startline+1)                 = str2double(quality_flags_2(3));
% data.scan_line_quality_flags_calibrated_marginal_PRT_data(l-startline+1)                = str2double(quality_flags_2(4));
% data.scan_line_quality_flags_some_uncalibrated_channels(l-startline+1)                  = str2double(quality_flags_2(5));
% data.scan_line_quality_flags_uncalibrated_instrument_mode(l-startline+1)                = str2double(quality_flags_2(6));
% data.scan_line_quality_flags_questionable_cal_ant_pos_er_space_view(l-startline+1)      = str2double(quality_flags_2(7));
% data.scan_line_quality_flags_questionable_cal_ant_pos_er_OBCT_view(l-startline+1)       = str2double(quality_flags_2(8));
% data.scan_line_quality_flags_not_earth_located_bad_time(l-startline+1)                  = str2double(quality_flags_3(1));
% data.scan_line_quality_flags_earth_location_questionable_time_code(l-startline+1)       = str2double(quality_flags_3(2));
% data.scan_line_quality_flags_earth_loc_check_marginal_agreement(l-startline+1)          = str2double(quality_flags_3(3));
% data.scan_line_quality_flags_earth_loc_check_fail(l-startline+1)                        = str2double(quality_flags_3(4));
% data.scan_line_quality_flags_earth_loc_questionable_position_check(l-startline+1)       = str2double(quality_flags_3(5));

for ch = 1:5
    quality_flags{ch}                                                       		= dec2bin(extract_uint16(record, rlen*(l-1)+(ch-1)+33, rlen*(l-1)+(ch-1)+34),16);
    quality_flags_lines{ch}(l-startline+1,:)						=quality_flags{ch};
end 
% data.calibration_quality_flags_Ch_H1_scanline_count_anomaly(l-startline+1)              = str2double(quality_flags{1}(10));
% data.calibration_quality_flags_Ch_H2_scanline_count_anomaly(l-startline+1)              = str2double(quality_flags{2}(10));
% data.calibration_quality_flags_Ch_H3_scanline_count_anomaly(l-startline+1)              = str2double(quality_flags{3}(10));
% data.calibration_quality_flags_Ch_H4_scanline_count_anomaly(l-startline+1)              = str2double(quality_flags{4}(10));
% data.calibration_quality_flags_Ch_H5_scanline_count_anomaly(l-startline+1)              = str2double(quality_flags{5}(10));
% data.calibration_quality_flags_Ch_H1_all_bad_blackbody_counts(l-startline+1)            = str2double(quality_flags{1}(11));
% data.calibration_quality_flags_Ch_H2_all_bad_blackbody_counts(l-startline+1)            = str2double(quality_flags{2}(11));
% data.calibration_quality_flags_Ch_H3_all_bad_blackbody_counts(l-startline+1)            = str2double(quality_flags{3}(11));
% data.calibration_quality_flags_Ch_H4_all_bad_blackbody_counts(l-startline+1)            = str2double(quality_flags{4}(11));
% data.calibration_quality_flags_Ch_H5_all_bad_blackbody_counts(l-startline+1)            = str2double(quality_flags{5}(11));
% data.calibration_quality_flags_Ch_H1_all_bad_spaceview_counts(l-startline+1)            = str2double(quality_flags{1}(12));
% data.calibration_quality_flags_Ch_H2_all_bad_spaceview_counts(l-startline+1)            = str2double(quality_flags{2}(12));
% data.calibration_quality_flags_Ch_H3_all_bad_spaceview_counts(l-startline+1)            = str2double(quality_flags{3}(12));
% data.calibration_quality_flags_Ch_H4_all_bad_spaceview_counts(l-startline+1)            = str2double(quality_flags{4}(12));
% data.calibration_quality_flags_Ch_H5_all_bad_spaceview_counts(l-startline+1)            = str2double(quality_flags{5}(12));
% data.calibration_quality_flags_Ch_H1_all_bad_PRTs(l-startline+1)                        = str2double(quality_flags{1}(13));
% data.calibration_quality_flags_Ch_H2_all_bad_PRTs(l-startline+1)                        = str2double(quality_flags{2}(13));
% data.calibration_quality_flags_Ch_H3_all_bad_PRTs(l-startline+1)                        = str2double(quality_flags{3}(13));
% data.calibration_quality_flags_Ch_H4_all_bad_PRTs(l-startline+1)                        = str2double(quality_flags{4}(13));
% data.calibration_quality_flags_Ch_H5_all_bad_PRTs(l-startline+1)                        = str2double(quality_flags{5}(13));
% data.calibration_quality_flags_Ch_H1_marginal_OBCT_view_counts(l-startline+1)           = str2double(quality_flags{1}(14));
% data.calibration_quality_flags_Ch_H2_marginal_OBCT_view_counts(l-startline+1)           = str2double(quality_flags{2}(14));
% data.calibration_quality_flags_Ch_H3_marginal_OBCT_view_counts(l-startline+1)           = str2double(quality_flags{3}(14));
% data.calibration_quality_flags_Ch_H4_marginal_OBCT_view_counts(l-startline+1)           = str2double(quality_flags{4}(14));
% data.calibration_quality_flags_Ch_H5_marginal_OBCT_view_counts(l-startline+1)           = str2double(quality_flags{5}(14));
% data.calibration_quality_flags_Ch_H1_marginal_space_view_counts(l-startline+1)          = str2double(quality_flags{1}(15));
% data.calibration_quality_flags_Ch_H2_marginal_space_view_counts(l-startline+1)          = str2double(quality_flags{2}(15));
% data.calibration_quality_flags_Ch_H3_marginal_space_view_counts(l-startline+1)          = str2double(quality_flags{3}(15));
% data.calibration_quality_flags_Ch_H4_marginal_space_view_counts(l-startline+1)          = str2double(quality_flags{4}(15));
% data.calibration_quality_flags_Ch_H5_marginal_space_view_counts(l-startline+1)          = str2double(quality_flags{5}(15));
% data.calibration_quality_flags_Ch_H1_marginal_PRT_temps(l-startline+1)                  = str2double(quality_flags{1}(16));
% data.calibration_quality_flags_Ch_H2_marginal_PRT_temps(l-startline+1)                  = str2double(quality_flags{2}(16));
% data.calibration_quality_flags_Ch_H3_marginal_PRT_temps(l-startline+1)                  = str2double(quality_flags{3}(16));
% data.calibration_quality_flags_Ch_H4_marginal_PRT_temps(l-startline+1)                  = str2double(quality_flags{4}(16));
% data.calibration_quality_flags_Ch_H5_marginal_PRT_temps(l-startline+1)                  = str2double(quality_flags{5}(16));
% data.primary_calibration_Ch_H1_second_order_term_a2(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+61, rlen*(l-1)+64))*1e-16; 
% data.primary_calibration_Ch_H2_second_order_term_a2(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+73, rlen*(l-1)+76))*1e-16; 
% data.primary_calibration_Ch_H3_second_order_term_a2(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+85, rlen*(l-1)+88))*1e-16; 
% data.primary_calibration_Ch_H4_second_order_term_a2(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+97, rlen*(l-1)+100))*1e-16; 
% data.primary_calibration_Ch_H5_second_order_term_a2(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+109, rlen*(l-1)+112))*1e-16; 
% data.primary_calibration_Ch_H1_first_order_term_a1(l-startline+1)                       = double(extract_int32(record, rlen*(l-1)+65, rlen*(l-1)+68))*1e-10;
% data.primary_calibration_Ch_H2_first_order_term_a1(l-startline+1)                       = double(extract_int32(record, rlen*(l-1)+77, rlen*(l-1)+80))*1e-10;
% data.primary_calibration_Ch_H3_first_order_term_a1(l-startline+1)                       = double(extract_int32(record, rlen*(l-1)+89, rlen*(l-1)+92))*1e-10;
% data.primary_calibration_Ch_H4_first_order_term_a1(l-startline+1)                       = double(extract_int32(record, rlen*(l-1)+101, rlen*(l-1)+104))*1e-10;
% data.primary_calibration_Ch_H5_first_order_term_a1(l-startline+1)                       = double(extract_int32(record, rlen*(l-1)+113, rlen*(l-1)+116))*1e-10;
% data.primary_calibration_Ch_H1_zeroth_order_term_a0(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+69, rlen*(l-1)+72))*1e-6;
% data.primary_calibration_Ch_H2_zeroth_order_term_a0(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+81, rlen*(l-1)+84))*1e-6;
% data.primary_calibration_Ch_H3_zeroth_order_term_a0(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+93, rlen*(l-1)+96))*1e-6;
% data.primary_calibration_Ch_H4_zeroth_order_term_a0(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+105, rlen*(l-1)+108))*1e-6;
% data.primary_calibration_Ch_H5_zeroth_order_term_a0(l-startline+1)                      = double(extract_int32(record, rlen*(l-1)+117, rlen*(l-1)+120))*1e-16;
% data.secondary_calibration_Ch_H1_second_order_term_a2(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+121, rlen*(l-1)+124))*1e-16;
% data.secondary_calibration_Ch_H2_second_order_term_a2(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+133, rlen*(l-1)+136))*1e-16;
% data.secondary_calibration_Ch_H3_second_order_term_a2(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+145, rlen*(l-1)+148))*1e-16;
% data.secondary_calibration_Ch_H4_second_order_term_a2(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+157, rlen*(l-1)+160))*1e-16;
% data.secondary_calibration_Ch_H5_second_order_term_a2(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+169, rlen*(l-1)+172))*1e-16;
% data.secondary_calibration_Ch_H1_first_order_term_a1(l-startline+1)                     = double(extract_int32(record, rlen*(l-1)+125, rlen*(l-1)+128))*1e-10;
% data.secondary_calibration_Ch_H2_first_order_term_a1(l-startline+1)                     = double(extract_int32(record, rlen*(l-1)+137, rlen*(l-1)+140))*1e-10;
% data.secondary_calibration_Ch_H3_first_order_term_a1(l-startline+1)                     = double(extract_int32(record, rlen*(l-1)+149, rlen*(l-1)+152))*1e-10;
% data.secondary_calibration_Ch_H4_first_order_term_a1(l-startline+1)                     = double(extract_int32(record, rlen*(l-1)+161, rlen*(l-1)+164))*1e-10;
% data.secondary_calibration_Ch_H5_first_order_term_a1(l-startline+1)                     = double(extract_int32(record, rlen*(l-1)+173, rlen*(l-1)+176))*1e-10;
% data.secondary_calibration_Ch_H1_zeroth_order_term_a0(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+129, rlen*(l-1)+132))*1e-6;
% data.secondary_calibration_Ch_H2_zeroth_order_term_a0(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+141, rlen*(l-1)+144))*1e-6;
% data.secondary_calibration_Ch_H3_zeroth_order_term_a0(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+153, rlen*(l-1)+156))*1e-6;
% data.secondary_calibration_Ch_H4_zeroth_order_term_a0(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+165, rlen*(l-1)+168))*1e-6;
% data.secondary_calibration_Ch_H5_zeroth_order_term_a0(l-startline+1)                    = double(extract_int32(record, rlen*(l-1)+177, rlen*(l-1)+180))*1e-6;
% data.computed_yaw_steering_1(l-startline+1)                                             = extract_int16(record, rlen*(l-1)+185, rlen*(l-1)+186);
% data.computed_yaw_steering_2(l-startline+1)                                             = extract_int16(record, rlen*(l-1)+187, rlen*(l-1)+188);
% data.computed_yaw_steering_3(l-startline+1)                                             = extract_int16(record, rlen*(l-1)+189, rlen*(l-1)+190);
% data.total_applied_attitude_correction_roll(l-startline+1)                              = double(extract_int16(record, rlen*(l-1)+191, rlen*(l-1)+192))*1e-3;
% data.total_applied_attitude_correction_pitch(l-startline+1)                             = double(extract_int16(record, rlen*(l-1)+193, rlen*(l-1)+194))*1e-3;
% data.total_applied_attitude_correction_yaw(l-startline+1)                               = double(extract_int16(record, rlen*(l-1)+195, rlen*(l-1)+196))*1e-3;

navigation_status                                                           		= dec2bin(extract_int32(record, rlen*(l-1)+197, rlen*(l-1)+200),32);
% data.navigation_status_earth_loc_at_satellite_subpoint_reasonable(l-startline+1)        = str2double(navigation_status(15));
% data.navigation_status_attitude_earth_loc_corrected_for_Euler_angles(l-startline+1)     = str2double(navigation_status(16));
% data.navigation_status_attitude_earth_location_indicator(l-startline+1)                 = bin2dec(navigation_status(17:21));
% data.navigation_status_spacecraft_attitude_control(l-startline+1)                       = bin2dec(navigation_status(22:25)); 
% data.navigation_status_attitude_SMODE(l-startline+1)                                    = bin2dec(navigation_status(26:29));
% data.navigation_status_attitude_PWTIP_AC(l-startline+1)                                 = bin2dec(navigation_status(30:32));

% data.Time_associated_with_euler_angles(l-startline+1)                                   = extract_int32(record, rlen*(l-1)+201, rlen*(l-1)+204);
% data.Euler_angles_roll(l-startline+1)                                                   = double(extract_int16(record, rlen*(l-1)+205, rlen*(l-1)+206))*1e-3;
% data.Euler_angles_pitch(l-startline+1)                                                  = double(extract_int16(record, rlen*(l-1)+207, rlen*(l-1)+208))*1e-3;
% data.Euler_angles_yaw(l-startline+1)                                                    = double(extract_int16(record, rlen*(l-1)+209, rlen*(l-1)+210))*1e-3;
% data.spacecraft_altitude_above_reference_ellipsoid(l-startline+1)                       = double(extract_uint16(record, rlen*(l-1)+211, rlen*(l-1)+212))*1e-1;

for fov=1:90
    data.angular_relationships_solar_zenith_angle_VOVXX(fov,l-startline+1)              = double(extract_int16(record, rlen*(l-1)+(fov-1)*6+213, rlen*(l-1)+(fov-1)*6+214))*1e-2;
    data.angular_relationships_satellite_zenith_angle_FOVXX(fov,l-startline+1)          = double(extract_int16(record, rlen*(l-1)+(fov-1)*6+215, rlen*(l-1)+(fov-1)*6+216))*1e-2;
    data.angular_relationships_relative_azimuth_angle_FOVXX(fov,l-startline+1)          = double(extract_int16(record, rlen*(l-1)+(fov-1)*6+217, rlen*(l-1)+(fov-1)*6+218))*1e-2;
    data.earth_location_latitude_FOVXX(fov,l-startline+1)                               = double(extract_int16(record, rlen*(l-1)+(fov-1)*4+753, rlen*(l-1)+(fov-1)*4+754))*1e-4;
    data.earth_location_longitude_FOVXX(fov,l-startline+1)                              = double(extract_int16(record, rlen*(l-1)+(fov-1)*4+755, rlen*(l-1)+(fov-1)*4+756))*1e-4;
end

data.lunar_angles_moon_spaceview1_angle(l-startline+1)                                  = double(extract_uint16(record, rlen*(l-1)+1473, rlen*(l-1)+1474))*1e-2;
data.lunar_angles_moon_spaceview2_angle(l-startline+1)                                  = double(extract_uint16(record, rlen*(l-1)+1475, rlen*(l-1)+1476))*1e-2;
data.lunar_angles_moon_spaceview3_angle(l-startline+1)                                  = double(extract_uint16(record, rlen*(l-1)+1477, rlen*(l-1)+1478))*1e-2;
data.lunar_angles_moon_spaceview4_angle(l-startline+1)                                  = double(extract_uint16(record, rlen*(l-1)+1479, rlen*(l-1)+1480))*1e-2;

for fov=1:90
    data.scene_earth_view_data_mid_pixel_position_FOV_XX(fov,l-startline+1)             = extract_uint16(record, rlen*(l-1)+(fov-1)*12+1481, rlen*(l-1)+(fov-1)*12+1482);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H1(fov,l-startline+1)             = extract_uint16(record, rlen*(l-1)+(fov-1)*12+1483, rlen*(l-1)+(fov-1)*12+1484);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H2(fov,l-startline+1)             = extract_uint16(record, rlen*(l-1)+(fov-1)*12+1485, rlen*(l-1)+(fov-1)*12+1486);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H3(fov,l-startline+1)             = extract_uint16(record, rlen*(l-1)+(fov-1)*12+1487, rlen*(l-1)+(fov-1)*12+1488);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H4(fov,l-startline+1)             = extract_uint16(record, rlen*(l-1)+(fov-1)*12+1489, rlen*(l-1)+(fov-1)*12+1490);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H5(fov,l-startline+1)             = extract_uint16(record, rlen*(l-1)+(fov-1)*12+1491, rlen*(l-1)+(fov-1)*12+1492);
end

data.space_view_data_mid_pixel_position_space_view1(l-startline+1)                      = extract_uint16(record, rlen*(l-1)+2569, rlen*(l-1)+2570);
data.space_view_data_mid_pixel_position_space_view2(l-startline+1)                      = extract_uint16(record, rlen*(l-1)+2581, rlen*(l-1)+2582);
data.space_view_data_mid_pixel_position_space_view3(l-startline+1)                      = extract_uint16(record, rlen*(l-1)+2593, rlen*(l-1)+2594);
data.space_view_data_mid_pixel_position_space_view4(l-startline+1)                      = extract_uint16(record, rlen*(l-1)+2605, rlen*(l-1)+2606);

data.space_view_data_counts_space_view1_Ch_H1(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2571, rlen*(l-1)+2572);
data.space_view_data_counts_space_view1_Ch_H2(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2573, rlen*(l-1)+2574);
data.space_view_data_counts_space_view1_Ch_H3(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2575, rlen*(l-1)+2576);
data.space_view_data_counts_space_view1_Ch_H4(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2577, rlen*(l-1)+2578);
data.space_view_data_counts_space_view1_Ch_H5(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2579, rlen*(l-1)+2580);
data.space_view_data_counts_space_view2_Ch_H1(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2583, rlen*(l-1)+2584);
data.space_view_data_counts_space_view2_Ch_H2(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2585, rlen*(l-1)+2586);
data.space_view_data_counts_space_view2_Ch_H3(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2587, rlen*(l-1)+2588);
data.space_view_data_counts_space_view2_Ch_H4(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2589, rlen*(l-1)+2590);
data.space_view_data_counts_space_view2_Ch_H5(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2591, rlen*(l-1)+2592);
data.space_view_data_counts_space_view3_Ch_H1(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2595, rlen*(l-1)+2596);
data.space_view_data_counts_space_view3_Ch_H2(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2597, rlen*(l-1)+2598);
data.space_view_data_counts_space_view3_Ch_H3(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2599, rlen*(l-1)+2600);
data.space_view_data_counts_space_view3_Ch_H4(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2601, rlen*(l-1)+2602);
data.space_view_data_counts_space_view3_Ch_H5(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2603, rlen*(l-1)+2604);
data.space_view_data_counts_space_view4_Ch_H1(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2607, rlen*(l-1)+2608);
data.space_view_data_counts_space_view4_Ch_H2(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2609, rlen*(l-1)+2610);
data.space_view_data_counts_space_view4_Ch_H3(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2611, rlen*(l-1)+2612); 
data.space_view_data_counts_space_view4_Ch_H4(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2613, rlen*(l-1)+2614);
data.space_view_data_counts_space_view4_Ch_H5(l-startline+1)                            = extract_uint16(record, rlen*(l-1)+2615, rlen*(l-1)+2616);

data.OBCT_view_data_mid_pixel_position_OBCT_view1(l-startline+1)                        = extract_uint16(record, rlen*(l-1)+2617, rlen*(l-1)+2618);
data.OBCT_view_data_mid_pixel_position_OBCT_view2(l-startline+1)                        = extract_uint16(record, rlen*(l-1)+2629, rlen*(l-1)+2630);
data.OBCT_view_data_mid_pixel_position_OBCT_view3(l-startline+1)                        = extract_uint16(record, rlen*(l-1)+2641, rlen*(l-1)+2642);
data.OBCT_view_data_mid_pixel_position_OBCT_view4(l-startline+1)                        = extract_uint16(record, rlen*(l-1)+2653, rlen*(l-1)+2654);
data.OBCT_view_data_counts_OBCT_view1_Ch_H1(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2619, rlen*(l-1)+2620);
data.OBCT_view_data_counts_OBCT_view1_Ch_H2(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2621, rlen*(l-1)+2622);
data.OBCT_view_data_counts_OBCT_view1_Ch_H3(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2623, rlen*(l-1)+2624);
data.OBCT_view_data_counts_OBCT_view1_Ch_H4(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2625, rlen*(l-1)+2626);
data.OBCT_view_data_counts_OBCT_view1_Ch_H5(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2627, rlen*(l-1)+2628);
data.OBCT_view_data_counts_OBCT_view2_Ch_H1(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2631, rlen*(l-1)+2632);
data.OBCT_view_data_counts_OBCT_view2_Ch_H2(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2633, rlen*(l-1)+2634);
data.OBCT_view_data_counts_OBCT_view2_Ch_H3(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2635, rlen*(l-1)+2636);
data.OBCT_view_data_counts_OBCT_view2_Ch_H4(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2637, rlen*(l-1)+2638);
data.OBCT_view_data_counts_OBCT_view2_Ch_H5(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2639, rlen*(l-1)+2640);
data.OBCT_view_data_counts_OBCT_view3_Ch_H1(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2643, rlen*(l-1)+2644);
data.OBCT_view_data_counts_OBCT_view3_Ch_H2(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2645, rlen*(l-1)+2646);
data.OBCT_view_data_counts_OBCT_view3_Ch_H3(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2647, rlen*(l-1)+2648);
data.OBCT_view_data_counts_OBCT_view3_Ch_H4(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2649, rlen*(l-1)+2650);
data.OBCT_view_data_counts_OBCT_view3_Ch_H5(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2651, rlen*(l-1)+2652);
data.OBCT_view_data_counts_OBCT_view4_Ch_H1(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2655, rlen*(l-1)+2656);
data.OBCT_view_data_counts_OBCT_view4_Ch_H2(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2657, rlen*(l-1)+2658);
data.OBCT_view_data_counts_OBCT_view4_Ch_H3(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2659, rlen*(l-1)+2660);
data.OBCT_view_data_counts_OBCT_view4_Ch_H4(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2661, rlen*(l-1)+2662);
data.OBCT_view_data_counts_OBCT_view4_Ch_H5(l-startline+1)                              = extract_uint16(record, rlen*(l-1)+2663, rlen*(l-1)+2664);
% data.earth_view_position_validity_flag_FOVs_01to08{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2673, rlen*(l-1)+2673),8);
% data.earth_view_position_validity_flag_FOVs_09to16{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2674, rlen*(l-1)+2674),8);
% data.earth_view_position_validity_flag_FOVs_17to24{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2675, rlen*(l-1)+2675),8);
% data.earth_view_position_validity_flag_FOVs_25to32{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2676, rlen*(l-1)+2676),8);
% data.earth_view_position_validity_flag_FOVs_33to40{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2677, rlen*(l-1)+2677),8);
% data.earth_view_position_validity_flag_FOVs_41to48{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2678, rlen*(l-1)+2678),8);
% data.earth_view_position_validity_flag_FOVs_49to56{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2679, rlen*(l-1)+2679),8);
% data.earth_view_position_validity_flag_FOVs_57to64{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2680, rlen*(l-1)+2680),8);
% data.earth_view_position_validity_flag_FOVs_65to72{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2681, rlen*(l-1)+2681),8);
% data.earth_view_position_validity_flag_FOVs_73to80{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2682, rlen*(l-1)+2682),8);
% data.earth_view_position_validity_flag_FOVs_81to88{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2683, rlen*(l-1)+2683),8);
% data.earth_view_position_validity_flag_FOVs_89to90{l-startline+1}                       = dec2bin(extract_uint8(record, rlen*(l-1)+2684, rlen*(l-1)+2684),8);

space_view_pos_quality_flag                                                 		= dec2bin(extract_uint8(record, rlen*(l-1)+2685, rlen*(l-1)+2685),8);
% data.space_view_position_validity_flag_space_view4(l-startline+1)                       = str2double(space_view_pos_quality_flag(5));
% data.space_view_position_validity_flag_space_view3(l-startline+1)                       = str2double(space_view_pos_quality_flag(6));
% data.space_view_position_validity_flag_space_view2(l-startline+1)                       = str2double(space_view_pos_quality_flag(7));
% data.space_view_position_validity_flag_space_view1(l-startline+1)                       = str2double(space_view_pos_quality_flag(8));

OBCT_view_pos_quality_flag                                                  		= dec2bin(extract_uint8(record, rlen*(l-1)+2686, rlen*(l-1)+2686),8);
% data.OBCT_view_position_validity_flag_space_view4(l-startline+1)                        = str2double(OBCT_view_pos_quality_flag(5));
% data.OBCT_view_position_validity_flag_space_view3(l-startline+1)                        = str2double(OBCT_view_pos_quality_flag(6));
% data.OBCT_view_position_validity_flag_space_view2(l-startline+1)                        = str2double(OBCT_view_pos_quality_flag(7));
% data.OBCT_view_position_validity_flag_space_view1(l-startline+1)                        = str2double(OBCT_view_pos_quality_flag(8));

mode_code                                                                   		= dec2bin(extract_uint8(record, rlen*(l-1)+2687, rlen*(l-1)+2687),8);                                                                 
% data.mode_code(l-startline+1)                                                           = bin2dec(mode_code(1:4));
% data.PIE_ID(l-startline+1)                                                              = str2double(mode_code(5));
% data.sub_commutation_code(l-startline+1)                                                = bin2dec(mode_code(6:8));

telecomm_code_1                                                             		= dec2bin(extract_uint16(record, rlen*(l-1)+2688, rlen*(l-1)+2689),16);
telecomm_code_2                                                             		= dec2bin(extract_uint16(record, rlen*(l-1)+2690, rlen*(l-1)+2691),16);
telecomm_code_3                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+2692, rlen*(l-1)+2692),8);
% data.telecommand_acknoledgement_and_fault_code_TC_clean(l-startline+1)                  = str2double(telecomm_code_1(1));
% data.telecommand_acknoledgement_and_fault_code_TC_conforms(l-startline+1)               = str2double(telecomm_code_1(2));
% data.telecommand_acknoledgement_and_fault_code_TC_recognized(l-startline+1)             = str2double(telecomm_code_1(3));
% data.telecommand_acknoledgement_and_fault_code_TC_legal(l-startline+1)                  = str2double(telecomm_code_1(4));
% data.telecommand_acknoledgement_and_fault_code_FDM_motor_trip_status(l-startline+1)     = str2double(telecomm_code_1(5));
% data.telecommand_acknoledgement_and_fault_code_TC_application_ID(l-startline+1)         = bin2dec(telecomm_code_1(6:16));
% data.telecommand_acknoledgement_and_fault_code_TC_packet_seq_count(l-startline+1)       = bin2dec(telecomm_code_2(1:14));
% data.telecommand_acknoledgement_and_fault_code_TC_received_count(l-startline+1)         = bin2dec(telecomm_code_2(15:16));
% data.telecommand_acknoledgement_and_fault_code_current_monitor_fault(l-startline+1)     = str2double(telecomm_code_3(1));
% data.telecommand_acknoledgement_and_fault_code_therm_monitor_fault(l-startline+1)       = str2double(telecomm_code_3(2));
% data.telecommand_acknoledgement_and_fault_code_switch_fault(l-startline+1)              = str2double(telecomm_code_3(3));
% data.telecommand_acknoledgement_and_fault_code_processor_fault(l-startline+1)           = str2double(telecomm_code_3(4));
% data.telecommand_acknoledgement_and_fault_code_RDM_motor_trip_status(l-startline+1)     = str2double(telecomm_code_3(5));
% data.telecommand_acknoledgement_and_fault_code_DC_offset_error(l-startline+1)           = str2double(telecomm_code_3(6));
% data.telecommand_acknoledgement_and_fault_code_scan_control_error(l-startline+1)        = str2double(telecomm_code_3(7));
% data.telecommand_acknoledgement_and_fault_code_REF_CK_error(l-startline+1)              = str2double(telecomm_code_3(8));

switch_status_1                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+2693, rlen*(l-1)+2693),8);
switch_status_2                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+2694, rlen*(l-1)+2694),8);
switch_status_3                                                             		= dec2bin(extract_uint8(record, rlen*(l-1)+2695, rlen*(l-1)+2695),8);
% data.switch_status_receiver_channel_H4_backend(l-startline+1)                           = str2double(switch_status_1(1));
% data.switch_status_receiver_channel_H3_backend(l-startline+1)                           = str2double(switch_status_1(2));
% data.switch_status_receiver_channel_H3_H4_local_oscillator(l-startline+1)               = str2double(switch_status_1(3));
% data.switch_status_receiver_channel_H3_H4_front_end(l-startline+1)                      = str2double(switch_status_1(4));
% data.switch_status_receiver_channel_H2_local_oscillator(l-startline+1)                  = str2double(switch_status_1(5));
% data.switch_status_receiver_channel_H2(l-startline+1)                                   = str2double(switch_status_1(6));
% data.switch_status_receiver_channel_H1_local_oscillator(l-startline+1)                  = str2double(switch_status_1(7));
% data.switch_status_receiver_channel_H1(l-startline+1)                                   = str2double(switch_status_1(8));
% data.switch_status_PROM(l-startline+1)                                                  = str2double(switch_status_2(1));
% data.switch_status_signal_processing_electronics(l-startline+1)                         = str2double(switch_status_2(2));
% data.switch_status_auxiliary_operational_heaters(l-startline+1)                         = str2double(switch_status_2(3));
% data.switch_status_scan_mechanism_operational_heaters(l-startline+1)                    = str2double(switch_status_2(4));
% data.switch_status_receiver_operational_heaters(l-startline+1)                          = str2double(switch_status_2(5));
% data.switch_status_Rx_CV(l-startline+1)                                                 = str2double(switch_status_2(6));
% data.switch_status_receiver_channel_H5_local_oscillator(l-startline+1)                  = str2double(switch_status_2(7));
% data.switch_status_receiver_channel_H5(l-startline+1)                                   = str2double(switch_status_2(8));
% data.switch_status_FDM_motor_current_trip_status(l-startline+1)                         = str2double(switch_status_3(1));
% data.switch_status_RDM_motor_current_trip_status(l-startline+1)                         = str2double(switch_status_3(2));
% data.switch_status_FDM_motor_supply(l-startline+1)                                      = str2double(switch_status_3(3));
% data.switch_status_RDM_motor_supply(l-startline+1)                                      = str2double(switch_status_3(4));
% data.switch_status_FDM_motor_sensors(l-startline+1)                                     = str2double(switch_status_3(5));
% data.switch_status_RDM_motor_sensors(l-startline+1)                                     = str2double(switch_status_3(6));
% data.switch_status_FDM_zero_position_sensors(l-startline+1)                             = str2double(switch_status_3(7));
% data.switch_status_RDM_zero_position_sensors(l-startline+1)                             = str2double(switch_status_3(8));
data.temperature_data_LO_H1_temperature(l-startline+1)                                  = extract_uint8(record, rlen*(l-1)+2696, rlen*(l-1)+2696);
data.temperature_data_LO_H2_temperature(l-startline+1)                                  = extract_uint8(record, rlen*(l-1)+2697, rlen*(l-1)+2697);
data.temperature_data_LO_H3_H4_temperature(l-startline+1)                               = extract_uint8(record, rlen*(l-1)+2698, rlen*(l-1)+2698);
data.temperature_data_LO_H5_temperature(l-startline+1)                                  = extract_uint8(record, rlen*(l-1)+2699, rlen*(l-1)+2699);
% data.temperature_data_mixer_LNA_multiplexer_H1_temperature(l-startline+1)               = extract_uint8(record, rlen*(l-1)+2700, rlen*(l-1)+2700);
% data.temperature_data_mixer_LNA_multiplexer_H2_temperature(l-startline+1)               = extract_uint8(record, rlen*(l-1)+2701, rlen*(l-1)+2701);
% data.temperature_data_mixer_LNA_multiplexer_H3_H4_temperature(l-startline+1)            = extract_uint8(record, rlen*(l-1)+2702, rlen*(l-1)+2702);
% data.temperature_data_mixer_LNA_multiplexer_H5_temperature(l-startline+1)               = extract_uint8(record, rlen*(l-1)+2703, rlen*(l-1)+2703);
% data.temperature_data_quasi_optics_baseplate_temperature_1(l-startline+1)               = extract_uint8(record, rlen*(l-1)+2704, rlen*(l-1)+2704);
% data.temperature_data_quasi_optics_baseplate_temperature_2(l-startline+1)               = extract_uint8(record, rlen*(l-1)+2705, rlen*(l-1)+2705);
% data.temperature_data_IF_baseplate_temperature_1(l-startline+1)                         = extract_uint8(record, rlen*(l-1)+2706, rlen*(l-1)+2706);
% data.temperature_data_IF_baseplate_temperature_2(l-startline+1)                         = extract_uint8(record, rlen*(l-1)+2707, rlen*(l-1)+2707);
% data.temperature_data_scan_mechanism_core_temperature(l-startline+1)                    = extract_uint8(record, rlen*(l-1)+2708, rlen*(l-1)+2708);
% data.temperature_data_scan_mechanism_housing_temperature(l-startline+1)                 = extract_uint8(record, rlen*(l-1)+2709, rlen*(l-1)+2709);
% data.temperature_data_RDM_SSHM_temperature(l-startline+1)                               = extract_uint8(record, rlen*(l-1)+2710, rlen*(l-1)+2710);
% data.temperature_data_FDM_SSHM_temperature(l-startline+1)                               = extract_uint8(record, rlen*(l-1)+2711, rlen*(l-1)+2711);
% data.temperature_data_structure_1_temperature(l-startline+1)                            = extract_uint8(record, rlen*(l-1)+2712, rlen*(l-1)+2712);
% data.temperature_data_structure_2_temperature(l-startline+1)                            = extract_uint8(record, rlen*(l-1)+2713, rlen*(l-1)+2713);
% data.temperature_data_structure_3_temperature(l-startline+1)                            = extract_uint8(record, rlen*(l-1)+2714, rlen*(l-1)+2714);
% data.temperature_data_processor_module_temperature(l-startline+1)                       = extract_uint8(record, rlen*(l-1)+2715, rlen*(l-1)+2715);
% data.temperature_data_main_DC_DC_converter_module_temperature(l-startline+1)            = extract_uint8(record, rlen*(l-1)+2716, rlen*(l-1)+2716);
% data.temperature_data_SCE_RDM_module_temperature(l-startline+1)                         = extract_uint8(record, rlen*(l-1)+2717, rlen*(l-1)+2717);
% data.temperature_data_SCE_FDM_module_temperature(l-startline+1)                         = extract_uint8(record, rlen*(l-1)+2718, rlen*(l-1)+2718);
% data.temperature_data_RF_DC_DC_converter_module_temperature(l-startline+1)              = extract_uint8(record, rlen*(l-1)+2719, rlen*(l-1)+2719);
% data.raw_current_consumption_data_EE_and_SM_plus5V_current(l-startline+1)               = extract_uint8(record, rlen*(l-1)+2720, rlen*(l-1)+2720);
% data.raw_current_consumption_data_receiver_plus8V_current(l-startline+1)                = extract_uint8(record, rlen*(l-1)+2721, rlen*(l-1)+2721);
% data.raw_current_consumption_data_receiver_plus15V_current(l-startline+1)               = extract_uint8(record, rlen*(l-1)+2722, rlen*(l-1)+2722);
% data.raw_current_consumption_data_receiver_minus15V_current(l-startline+1)              = extract_uint8(record, rlen*(l-1)+2723, rlen*(l-1)+2723);
% data.raw_current_consumption_data_RDM_motor_current(l-startline+1)                      = extract_uint8(record, rlen*(l-1)+2724, rlen*(l-1)+2724);
% data.raw_current_consumption_data_FDM_motor_current(l-startline+1)                      = extract_uint8(record, rlen*(l-1)+2725, rlen*(l-1)+2725);

status_word                                                                 		= dec2bin(extract_uint8(record, rlen*(l-1)+2727, rlen*(l-1)+2727),8);
% data.status_word_DC_offset_valid(l-startline+1)                                         = str2double(status_word(1));
% data.status_word_scan_control_valid(l-startline+1)                                      = str2double(status_word(2));
 data.status_word_profile(l-startline+1)                                                 = bin2dec(status_word(3:4));
% data.DC_offset_words_Ch_H1_DC_offset(l-startline+1)                                     = extract_uint8(record, rlen*(l-1)+2735, rlen*(l-1)+2735);
% data.DC_offset_words_Ch_H2_DC_offset(l-startline+1)                                     = extract_uint8(record, rlen*(l-1)+2736, rlen*(l-1)+2736);
% data.DC_offset_words_Ch_H3_DC_offset(l-startline+1)                                     = extract_uint8(record, rlen*(l-1)+2737, rlen*(l-1)+2737);
% data.DC_offset_words_Ch_H4_DC_offset(l-startline+1)                                     = extract_uint8(record, rlen*(l-1)+2738, rlen*(l-1)+2738);
% data.DC_offset_words_Ch_H5_DC_offset(l-startline+1)                                     = extract_uint8(record, rlen*(l-1)+2739, rlen*(l-1)+2739);

valid                                                                       		= dec2bin(extract_uint8(record, rlen*(l-1)+2740, rlen*(l-1)+2740),8);
% data.channel_valid_flag_H1_valid(l-startline+1)                                         = str2double(valid(1));
% data.channel_valid_flag_H2_valid(l-startline+1)                                         = str2double(valid(2));
% data.channel_valid_flag_H3_valid(l-startline+1)                                         = str2double(valid(3));
% data.channel_valid_flag_H4_valid(l-startline+1)                                         = str2double(valid(4));
% data.channel_valid_flag_H5_valid(l-startline+1)                                         = str2double(valid(5));
% data.channel_valid_flag_SPE_MUX_code(l-startline+1)                                     = bin2dec(valid(6:7));

% channel_gain_1                                                              		= dec2bin(extract_uint8(record, rlen*(l-1)+2741, rlen*(l-1)+2741),8);
% channel_gain_2                                                              		= dec2bin(extract_uint8(record, rlen*(l-1)+2742, rlen*(l-1)+2742),8);
% channel_gain_3                                                              		= dec2bin(extract_uint8(record, rlen*(l-1)+2743, rlen*(l-1)+2743),8);
% data.channel_gain_channel_H1_gain(l-startline+1)                                        = bin2dec(channel_gain_1(1:3));
% data.channel_gain_channel_H2_gain(l-startline+1)                                        = bin2dec(channel_gain_1(4:6));
% data.channel_gain_channel_H3_gain(l-startline+1)                                        = bin2dec(channel_gain_2(1:3));
% data.channel_gain_channel_H4_gain(l-startline+1)                                        = bin2dec(channel_gain_2(4:6));
% data.channel_gain_channel_H5_gain(l-startline+1)                                        = bin2dec(channel_gain_3(1:3));
% data.OBCT_PRT_readings_PRT1(l-startline+1)                                              = extract_uint16(record, rlen*(l-1)+2751, rlen*(l-1)+2752);
% data.OBCT_PRT_readings_PRT2(l-startline+1)                                              = extract_uint16(record, rlen*(l-1)+2753, rlen*(l-1)+2754);
% data.OBCT_PRT_readings_PRT3(l-startline+1)                                              = extract_uint16(record, rlen*(l-1)+2755, rlen*(l-1)+2756);
% data.OBCT_PRT_readings_PRT4(l-startline+1)                                              = extract_uint16(record, rlen*(l-1)+2757, rlen*(l-1)+2758);
% data.OBCT_PRT_readings_PRT5(l-startline+1)                                              = extract_uint16(record, rlen*(l-1)+2759, rlen*(l-1)+2760);
% data.PRT_calibration_channel1(l-startline+1)                                            = extract_uint16(record, rlen*(l-1)+2761, rlen*(l-1)+2762);
% data.PRT_calibration_channel2(l-startline+1)                                            = extract_uint16(record, rlen*(l-1)+2763, rlen*(l-1)+2764);
% data.PRT_calibration_channel3(l-startline+1)                                            = extract_uint16(record, rlen*(l-1)+2765, rlen*(l-1)+2766);
data.computed_OBCT_temperature1_PRT1_based(l-startline+1)                               = double(extract_uint32(record, rlen*(l-1)+2769, rlen*(l-1)+2772))*1e-3;
data.computed_OBCT_temperature2_PRT2_based(l-startline+1)                               = double(extract_uint32(record, rlen*(l-1)+2773, rlen*(l-1)+2776))*1e-3;
data.computed_OBCT_temperature3_PRT3_based(l-startline+1)                               = double(extract_uint32(record, rlen*(l-1)+2777, rlen*(l-1)+2780))*1e-3;
data.computed_OBCT_temperature4_PRT4_based(l-startline+1)                               = double(extract_uint32(record, rlen*(l-1)+2781, rlen*(l-1)+2784))*1e-3;
data.computed_OBCT_temperature5_PRT5_based(l-startline+1)                               = double(extract_uint32(record, rlen*(l-1)+2785, rlen*(l-1)+2788))*1e-3;
% data.main_bus_select_status(l-startline+1)                                              = extract_uint8(record, rlen*(l-1)+2835, rlen*(l-1)+2835);
% data.MHS_survival_heater(l-startline+1)                                                 = extract_uint8(record, rlen*(l-1)+2836, rlen*(l-1)+2836);
% data.RF_converter_protect_disable(l-startline+1)                                        = extract_uint8(record, rlen*(l-1)+2837, rlen*(l-1)+2837);
% data.MHS_power_A(l-startline+1)                                                         = extract_uint8(record, rlen*(l-1)+2838, rlen*(l-1)+2838);
% data.MHS_power_B(l-startline+1)                                                         = extract_uint8(record, rlen*(l-1)+2839, rlen*(l-1)+2839);
% data.main_converter_protect_disable(l-startline+1)                                      = extract_uint8(record, rlen*(l-1)+2840, rlen*(l-1)+2840);
% data.survival_temperatures_receiver_temperature(l-startline+1)                          = extract_uint16(record, rlen*(l-1)+2841, rlen*(l-1)+2842);
% data.survival_temperatures_electronics_equipment_temperature(l-startline+1)             = extract_uint16(record, rlen*(l-1)+2843, rlen*(l-1)+2844);
% data.survival_temperatures_scan_mechanism_temperature(l-startline+1)                    = extract_uint16(record, rlen*(l-1)+2845, rlen*(l-1)+2846);
% data.transmitter_telemetry_STX1_status(l-startline+1)                                   = extract_uint16(record, rlen*(l-1)+2847, rlen*(l-1)+2848);
% data.transmitter_telemetry_STX2_status(l-startline+1)                                   = extract_uint16(record, rlen*(l-1)+2849, rlen*(l-1)+2850);
% data.transmitter_telemetry_STX3_status(l-startline+1)                                   = extract_uint16(record, rlen*(l-1)+2851, rlen*(l-1)+2852);
% data.transmitter_telemetry_STX4_status(l-startline+1)                                   = extract_uint16(record, rlen*(l-1)+2853, rlen*(l-1)+2854);
% data.transmitter_telemetry_STX1_power(l-startline+1)                                    = extract_uint16(record, rlen*(l-1)+2855, rlen*(l-1)+2856);
% data.transmitter_telemetry_STX2_power(l-startline+1)                                    = extract_uint16(record, rlen*(l-1)+2857, rlen*(l-1)+2858);
% data.transmitter_telemetry_STX3_power(l-startline+1)                                    = extract_uint16(record, rlen*(l-1)+2859, rlen*(l-1)+2860);
% data.transmitter_telemetry_STX4_power(l-startline+1)                                    = extract_uint16(record, rlen*(l-1)+2861, rlen*(l-1)+2862);
% data.transmitter_telemetry_SARR_A_power(l-startline+1)                                  = extract_uint16(record, rlen*(l-1)+2863, rlen*(l-1)+2864);
% data.transmitter_telemetry_SARR_B_power(l-startline+1)                                  = extract_uint16(record, rlen*(l-1)+2865, rlen*(l-1)+2866);

discrete_telemetry_update_flags                                             		= dec2bin(extract_uint32(record, rlen*(l-1)+2865, rlen*(l-1)+2868),32);
% data.discrete_telemetry_update_flags_SARR_B_power(l-startline+1)                        = str2double(discrete_telemetry_update_flags(15));
% data.discrete_telemetry_update_flags_SARR_A_power(l-startline+1)                        = str2double(discrete_telemetry_update_flags(16));
% data.discrete_telemetry_update_flags_STX3_power(l-startline+1)                          = str2double(discrete_telemetry_update_flags(17));
% data.discrete_telemetry_update_flags_STX2_power(l-startline+1)                          = str2double(discrete_telemetry_update_flags(18));
% data.discrete_telemetry_update_flags_STX1_power(l-startline+1)                          = str2double(discrete_telemetry_update_flags(19));
% data.discrete_telemetry_update_flags_STX4_status(l-startline+1)                         = str2double(discrete_telemetry_update_flags(20));
% data.discrete_telemetry_update_flags_STX3_status(l-startline+1)                         = str2double(discrete_telemetry_update_flags(21));
% data.discrete_telemetry_update_flags_STX2_status(l-startline+1)                         = str2double(discrete_telemetry_update_flags(22));
% data.discrete_telemetry_update_flags_STX1_status(l-startline+1)                         = str2double(discrete_telemetry_update_flags(23));
% data.discrete_telemetry_update_flags_scan_mechanism_temperature(l-startline+1)          = str2double(discrete_telemetry_update_flags(24));
% data.discrete_telemetry_update_flags_electr_equipment_temperature(l-startline+1)        = str2double(discrete_telemetry_update_flags(25));
% data.discrete_telemetry_update_flags_receiver_temperature(l-startline+1)                = str2double(discrete_telemetry_update_flags(26));
% data.discrete_telemetry_update_flags_main_converter_protect_disable(l-startline+1)      = str2double(discrete_telemetry_update_flags(27));
% data.discrete_telemetry_update_flags_MHS_power_B(l-startline+1)                         = str2double(discrete_telemetry_update_flags(28));
% data.discrete_telemetry_update_flags_MHS_power_A(l-startline+1)                         = str2double(discrete_telemetry_update_flags(29));
% data.discrete_telemetry_update_flags_RF_converter_protect_disable(l-startline+1)        = str2double(discrete_telemetry_update_flags(30));
% data.discrete_telemetry_update_flags_MHS_survival_heater(l-startline+1)                 = str2double(discrete_telemetry_update_flags(31));
% data.discrete_telemetry_update_flags_main_bus_select_status(l-startline+1)              = str2double(discrete_telemetry_update_flags(32));

end 
end 


function value = extract_uint8(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'uint8');
end

function value = extract_uint16(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'uint16');
end

function value = extract_int16(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'int16');
end

function value = extract_int32(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'int32');
end

function value = extract_uint32(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'uint32');
end