% READ_AMSUB_RECORD   Read all record entries of AMSUB data file.
%
% The function extracts record entries of an AMSUB 
% data file.
%
% OLE: quality_flags_lines changed data type from
% quality_flags_lines{channel}(nlines, bit) to
% quality_flags_lines(channel, nlines, bit)
%
% FORMAT   data = read_AMSUB_record( record );
%
% IN    record 


function [data, quality_indicator_lines,quality_flags_0_lines,quality_flags_1_lines,quality_flags_2_lines,quality_flags_3_lines,quality_flags_lines ] = read_AMSUB_record( record, nlines_read, rlen ,startline)
% Extracting data fields
% read Calibration Quality Flags
% Index numbers correspond to start/end octet from the KLM User Guide, see above.

% Number of field of views
nfov = 90;

%nlines_read=endline;
nlines = nlines_read - startline + 1;

% Nested function to extract and convert byte data from the data record
% Accesses the local variables record, startline, nlines and rlen directly
function data = get_vector_from_bytearray(startbyte, endbyte, dtype)
    data = swapbytes(typecast(uint8(record(create_selection(startbyte, endbyte, startline, nlines, rlen))), dtype));
end

%for l = startline:nlines_read
%dindex = l-startline+1;
%
% OLE: old code that was already commented out in the original function
%
%data.coarse_MHS_onboard_time(dindex)                                             = extract_uint32(record, rlen*(l-1)+17, rlen*(l-1)+20);
%data.fine_MHS_onboard_time(dindex)                                               = extract_uint16(record, rlen*(l-1)+21, rlen*(l-1)+22);
%data.MHS_mode_flag(dindex)                                                       = extract_uint8(record, rlen*(l-1)+23, rlen*(l-1)+23); 
%
%data.computed_yaw_steering_1(dindex)                                             = extract_int16(record, rlen*(l-1)+185, rlen*(l-1)+186);
%data.computed_yaw_steering_2(dindex)                                             = extract_int16(record, rlen*(l-1)+187, rlen*(l-1)+188);
%data.computed_yaw_steering_3(dindex)                                             = extract_int16(record, rlen*(l-1)+189, rlen*(l-1)+190);
%data.total_applied_attitude_correction_roll(dindex)                              = double(extract_int16(record, rlen*(l-1)+191, rlen*(l-1)+192))*1e-3;
%data.total_applied_attitude_correction_pitch(dindex)                             = double(extract_int16(record, rlen*(l-1)+193, rlen*(l-1)+194))*1e-3;
%data.total_applied_attitude_correction_yaw(dindex)                               = double(extract_int16(record, rlen*(l-1)+195, rlen*(l-1)+196))*1e-3;
%
%data.lunar_angles_moon_spaceview1_angle(dindex)                                  = double(extract_uint16(record, rlen*(l-1)+1473, rlen*(l-1)+1474))*1e-2;
%data.lunar_angles_moon_spaceview2_angle(dindex)                                  = double(extract_uint16(record, rlen*(l-1)+1475, rlen*(l-1)+1476))*1e-2;
%data.lunar_angles_moon_spaceview3_angle(dindex)                                  = double(extract_uint16(record, rlen*(l-1)+1477, rlen*(l-1)+1478))*1e-2;
%data.lunar_angles_moon_spaceview4_angle(dindex)                                  = double(extract_uint16(record, rlen*(l-1)+1479, rlen*(l-1)+1480))*1e-2;
%
%end


scan_data = get_vector_from_bytearray(1, 6, 'uint16');
scan_data = reshape(scan_data, 3, nlines);
data.scan_line_number(1, :)      = scan_data(1, :);
data.scan_line_year(1, :)        = scan_data(2, :);
data.scan_line_day_of_year(1, :) = scan_data(3, :);


data.satellite_clock_drift_delta(1, :) = get_vector_from_bytearray(7, 8, 'int16');
data.scan_line_UTC_time(1, :) = get_vector_from_bytearray(9, 12, 'uint32');


scan_line_correction = get_vector_from_bytearray(13, 14, 'uint16');
scan_line_correction = dec2bin(scan_line_correction, 16) - '0';
data.scan_line_satellite_direction(1, :)    = scan_line_correction(:, 1);
data.scan_line_clock_drift_correction(1, :) = scan_line_correction(:, 2);


data.major_frame_count(1, :) = get_vector_from_bytearray(15, 16, 'uint16');

quality_indicator_lines = dec2bin(get_vector_from_bytearray(25, 28, 'uint32'), 32);
% Subtract the ASCII character '0' elementwise from the char array
% to create an integer array that contains 0s and 1s as numbers.
quality_indicator = quality_indicator_lines - '0';

data.quality_indicator_dont_use_for_product_generation(1, :) = quality_indicator(:, 1);
data.quality_indicator_time_sequence_error_detected(1, :)    = quality_indicator(:, 2);
data.quality_indicator_data_gap_precedes_scan(1, :)          = quality_indicator(:, 3);
data.quality_indicator_insufficient_calibration_data(1, :)   = quality_indicator(:, 4);
data.quality_indicator_no_earth_location(1, :)               = quality_indicator(:, 5);
data.quality_indicator_good_time_following_clockupdate(1, :) = quality_indicator(:, 6);
data.quality_indicator_instrument_status_change(1, :)        = quality_indicator(:, 7);
data.quality_indicator_new_bias_status_change(1, :)          = quality_indicator(:, 26);
data.quality_indicator_new_bias_status(1, :)                 = quality_indicator(:, 27);
data.quality_indicator_transmitter_status_change(1, :)       = quality_indicator(:, 28);
data.quality_indicator_AMSU_sync_error(1, :)                 = quality_indicator(:, 29);
data.quality_indicator_AMSU_minor_frame_error(1, :)          = quality_indicator(:, 30);
data.quality_indicator_AMSU_major_frame_error(1, :)          = quality_indicator(:, 31);
data.quality_indicator_AMSU_parity_error(1, :)               = quality_indicator(:, 32);


% 42 = 33 + 2*(5-1) - 1;
% Two uint16 values for each for the 5 channels
quality_flags_lines = dec2bin(get_vector_from_bytearray(33, 42, 'uint16'), 16);
quality_flags_lines = reshape(quality_flags_lines, 5, nlines, 16);
quality_flags = quality_flags_lines - '0';

%data.calibration_quality_flags_Ch_16_scanline_count_anomaly(1, :)    = quality_flags(1, :, 10);
%data.calibration_quality_flags_Ch_17_scanline_count_anomaly(1, :)    = quality_flags(2, :, 10);
%data.calibration_quality_flags_Ch_18_scanline_count_anomaly(1, :)    = quality_flags(3, :, 10);
%data.calibration_quality_flags_Ch_19_scanline_count_anomaly(1, :)    = quality_flags(4, :, 10);
%data.calibration_quality_flags_Ch_20_scanline_count_anomaly(1, :)    = quality_flags(5, :, 10);
data.calibration_quality_flags_Ch_16_all_bad_blackbody_counts(1, :)   = quality_flags(1, :, 11);
data.calibration_quality_flags_Ch_17_all_bad_blackbody_counts(1, :)   = quality_flags(2, :, 11);
data.calibration_quality_flags_Ch_18_all_bad_blackbody_counts(1, :)   = quality_flags(3, :, 11);
data.calibration_quality_flags_Ch_19_all_bad_blackbody_counts(1, :)   = quality_flags(4, :, 11);
data.calibration_quality_flags_Ch_20_all_bad_blackbody_counts(1, :)   = quality_flags(5, :, 11);
data.calibration_quality_flags_Ch_16_all_bad_spaceview_counts(1, :)   = quality_flags(1, :, 12);
data.calibration_quality_flags_Ch_17_all_bad_spaceview_counts(1, :)   = quality_flags(2, :, 12);
data.calibration_quality_flags_Ch_18_all_bad_spaceview_counts(1, :)   = quality_flags(3, :, 12);
data.calibration_quality_flags_Ch_19_all_bad_spaceview_counts(1, :)   = quality_flags(4, :, 12);
data.calibration_quality_flags_Ch_20_all_bad_spaceview_counts(1, :)   = quality_flags(5, :, 12);
data.calibration_quality_flags_Ch_16_all_bad_PRTs(1, :)               = quality_flags(1, :, 13);
data.calibration_quality_flags_Ch_17_all_bad_PRTs(1, :)               = quality_flags(2, :, 13);
data.calibration_quality_flags_Ch_18_all_bad_PRTs(1, :)               = quality_flags(3, :, 13);
data.calibration_quality_flags_Ch_19_all_bad_PRTs(1, :)               = quality_flags(4, :, 13);
data.calibration_quality_flags_Ch_20_all_bad_PRTs(1, :)               = quality_flags(5, :, 13);
data.calibration_quality_flags_Ch_16_marginal_OBCT_view_counts(1, :)  = quality_flags(1, :, 14);
data.calibration_quality_flags_Ch_17_marginal_OBCT_view_counts(1, :)  = quality_flags(2, :, 14);
data.calibration_quality_flags_Ch_18_marginal_OBCT_view_counts(1, :)  = quality_flags(3, :, 14);
data.calibration_quality_flags_Ch_19_marginal_OBCT_view_counts(1, :)  = quality_flags(4, :, 14);
data.calibration_quality_flags_Ch_20_marginal_OBCT_view_counts(1, :)  = quality_flags(5, :, 14);
data.calibration_quality_flags_Ch_16_marginal_space_view_counts(1, :) = quality_flags(1, :, 15);
data.calibration_quality_flags_Ch_17_marginal_space_view_counts(1, :) = quality_flags(2, :, 15);
data.calibration_quality_flags_Ch_18_marginal_space_view_counts(1, :) = quality_flags(3, :, 15);
data.calibration_quality_flags_Ch_19_marginal_space_view_counts(1, :) = quality_flags(4, :, 15);
data.calibration_quality_flags_Ch_20_marginal_space_view_counts(1, :) = quality_flags(5, :, 15);
data.calibration_quality_flags_Ch_16_marginal_PRT_temps(1, :)         = quality_flags(1, :, 16);
data.calibration_quality_flags_Ch_17_marginal_PRT_temps(1, :)         = quality_flags(2, :, 16);
data.calibration_quality_flags_Ch_18_marginal_PRT_temps(1, :)         = quality_flags(3, :, 16);
data.calibration_quality_flags_Ch_19_marginal_PRT_temps(1, :)         = quality_flags(4, :, 16);
data.calibration_quality_flags_Ch_20_marginal_PRT_temps(1, :)         = quality_flags(5, :, 16);


quality_flags = dec2bin(get_vector_from_bytearray(29, 32, 'uint8'), 8);
quality_flags = reshape(quality_flags, 4, nlines, 8);
quality_flags_0_lines = squeeze(quality_flags(1, :, :));
quality_flags_1_lines = squeeze(quality_flags(2, :, :));
quality_flags_2_lines = squeeze(quality_flags(3, :, :));
quality_flags_3_lines = squeeze(quality_flags(4, :, :));
quality_flags = quality_flags -'0';

data.scan_line_quality_flags_contains_lunar_contaminated_space_view(1, :) = quality_flags(2, :, 7); %zero fill for AMSUB
data.scan_line_quality_flags_lunar_contaminated_line_was_calibrated(1, :) = quality_flags(2, :, 8); %zero fill for AMSUB
data.scan_line_quality_flags_bad_time_field_but_inferable(1, :)           = quality_flags(1, :, 1);
data.scan_line_quality_flags_bad_time_field(1, :)                         = quality_flags(1, :, 2);
data.scan_line_quality_flags_inconsistent_with_previous_times(1, :)       = quality_flags(1, :, 3);
data.scan_line_quality_flags_repeated_scan_times(1, :)                    = quality_flags(1, :, 4);
data.scan_line_quality_flags_not_calibrated_bad_time(1, :)                = quality_flags(3, :, 1);
data.scan_line_quality_flags_calibrated_with_fewer_scanlines(1, :)        = quality_flags(3, :, 2);
data.scan_line_quality_flags_not_calibrated_bad_PRT_data(1, :)            = quality_flags(3, :, 3);
data.scan_line_quality_flags_calibrated_marginal_PRT_data(1, :)           = quality_flags(3, :, 4);
data.scan_line_quality_flags_some_uncalibrated_channels(1, :)             = quality_flags(3, :, 5);
data.scan_line_quality_flags_uncalibrated_instrument_mode(1, :)           = quality_flags(3, :, 6);
data.scan_line_quality_flags_questionable_cal_ant_pos_er_space_view(1, :) = quality_flags(3, :, 7);
data.scan_line_quality_flags_questionable_cal_ant_pos_er_OBCT_view(1, :)  = quality_flags(3, :, 8);
data.scan_line_quality_flags_not_earth_located_bad_time(1, :)             = quality_flags(4, :, 1);
data.scan_line_quality_flags_earth_location_questionable_time_code(1, :)  = quality_flags(4, :, 2);
data.scan_line_quality_flags_earth_loc_check_marginal_agreement(1, :)     = quality_flags(4, :, 3);
data.scan_line_quality_flags_earth_loc_check_fail(1, :)                   = quality_flags(4, :, 4);
data.scan_line_quality_flags_earth_loc_questionable_position_check(1, :)  = quality_flags(4, :, 5);


offset = 61;
calibration = double(get_vector_from_bytearray(offset, 180, 'int32'));
calibration = reshape(calibration, (180-offset+1)/4, nlines);

data.primary_calibration_Ch_16_second_order_term_a2(1, :)   = calibration((61-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_17_second_order_term_a2(1, :)   = calibration((73-offset)/4+1, :)*1e-16;
data.primary_calibration_Ch_18_second_order_term_a2(1, :)   = calibration((85-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_19_second_order_term_a2(1, :)   = calibration((97-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_20_second_order_term_a2(1, :)   = calibration((109-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_16_first_order_term_a1(1, :)    = calibration((65-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_17_first_order_term_a1(1, :)    = calibration((77-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_18_first_order_term_a1(1, :)    = calibration((89-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_19_first_order_term_a1(1, :)    = calibration((101-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_20_first_order_term_a1(1, :)    = calibration((113-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_16_zeroth_order_term_a0(1, :)   = calibration((69-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_17_zeroth_order_term_a0(1, :)   = calibration((81-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_18_zeroth_order_term_a0(1, :)   = calibration((93-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_19_zeroth_order_term_a0(1, :)   = calibration((105-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_20_zeroth_order_term_a0(1, :)   = calibration((117-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_16_second_order_term_a2(1, :) = calibration((121-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_17_second_order_term_a2(1, :) = calibration((133-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_18_second_order_term_a2(1, :) = calibration((145-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_19_second_order_term_a2(1, :) = calibration((157-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_20_second_order_term_a2(1, :) = calibration((169-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_16_first_order_term_a1(1, :)  = calibration((125-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_17_first_order_term_a1(1, :)  = calibration((137-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_18_first_order_term_a1(1, :)  = calibration((149-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_19_first_order_term_a1(1, :)  = calibration((161-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_20_first_order_term_a1(1, :)  = calibration((173-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_16_zeroth_order_term_a0(1, :) = calibration((129-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_17_zeroth_order_term_a0(1, :) = calibration((141-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_18_zeroth_order_term_a0(1, :) = calibration((153-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_19_zeroth_order_term_a0(1, :) = calibration((165-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_20_zeroth_order_term_a0(1, :) = calibration((177-offset)/4+1, :)*1e-6;


%navigation_status_lines = dec2bin(get_vector_from_bytearray(197, 200, 'int32'), 32); 
	%this line above produces an error if get_vector_from_bytearray(197, 200, 'int32') is negative.
	%I don't know why its negative sometimes
%navigation_status = navigation_status_lines - '0';
%%data.navigation_status_earth_loc_at_satellite_subpoint_reasonable(1, :)   = navigation_status(:, 15);
%data.navigation_status_attitude_earth_loc_corrected_for_Euler_angles(1, :) = navigation_status(:, 16);
%data.navigation_status_attitude_earth_location_indicator(1, :)             = bin2dec(navigation_status_lines(:, 17:21));
%data.navigation_status_spacecraft_attitude_control(1, :)                   = bin2dec(navigation_status_lines(:, 22:25)); 
%data.navigation_status_attitude_SMODE(1, :)                                = bin2dec(navigation_status_lines(:, 26:29));
%data.navigation_status_attitude_PWTIP_AC(1, :)                             = bin2dec(navigation_status_lines(:, 30:32));


data.Time_associated_with_euler_angles(1, :) = get_vector_from_bytearray(201, 204, 'int32')';


offset = 205;
euler_ang = double(get_vector_from_bytearray(offset, 210, 'int16'))';
euler_ang = reshape(euler_ang, (210-offset+1)/2, nlines);
data.Euler_angles_roll(1, :)  = euler_ang((205-offset)/2+1, :)*1e-3;
data.Euler_angles_pitch(1, :) = euler_ang((207-offset)/2+1, :)*1e-3;
data.Euler_angles_yaw(1, :)   = euler_ang((209-offset)/2+1, :)*1e-3;


data.spacecraft_altitude_above_reference_ellipsoid(1, :) = ...
    double(get_vector_from_bytearray(211, 212, 'uint16'))'*1e-1;


angular_rel = double(get_vector_from_bytearray(213, (nfov-1)*6+218, 'int16'));
angular_rel = reshape(angular_rel, 3, nfov, nlines);
data.angular_relationships_solar_zenith_angle_FOVXX(:,:)     = angular_rel(1, :, :)*1e-2;
data.angular_relationships_satellite_zenith_angle_FOVXX(:,:) = angular_rel(2, :, :)*1e-2;
data.angular_relationships_relative_azimuth_angle_FOVXX(:,:) = angular_rel(3, :, :)*1e-2;


earth_location = double(get_vector_from_bytearray(753, (nfov-1)*8+760, 'int32'));
data.earth_location_latitude_FOVXX(:,:)  = reshape(earth_location(1:2:end), nfov, nlines)*1e-4;
data.earth_location_longitude_FOVXX(:,:) = reshape(earth_location(2:2:end), nfov, nlines)*1e-4;


scene_earth_view_data = get_vector_from_bytearray(1481, (nfov-1)*12+1492, 'uint16');
data.scene_earth_view_data_mid_pixel_position_FOV_XX(:,:) = reshape(scene_earth_view_data(1:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_16(:,:) = reshape(scene_earth_view_data(2:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_17(:,:) = reshape(scene_earth_view_data(3:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_18(:,:) = reshape(scene_earth_view_data(4:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_19(:,:) = reshape(scene_earth_view_data(5:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_20(:,:) = reshape(scene_earth_view_data(6:6:end), nfov, nlines);


offset = 2569;
view_data = get_vector_from_bytearray(offset, 2664, 'uint16')';
view_data = reshape(view_data, (2664-offset+1)/2, nlines);

data.space_view_data_mid_pixel_position_space_view1(1, :) = view_data((2569-offset)/2+1, :);
data.space_view_data_mid_pixel_position_space_view2(1, :) = view_data((2581-offset)/2+1, :);
data.space_view_data_mid_pixel_position_space_view3(1, :) = view_data((2593-offset)/2+1, :);
data.space_view_data_mid_pixel_position_space_view4(1, :) = view_data((2605-offset)/2+1, :);

data.space_view_data_counts_space_view1_Ch_16(1, :)       = view_data((2571-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_17(1, :)       = view_data((2573-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_18(1, :)       = view_data((2575-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_19(1, :)       = view_data((2577-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_20(1, :)       = view_data((2579-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_16(1, :)       = view_data((2583-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_17(1, :)       = view_data((2585-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_18(1, :)       = view_data((2587-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_19(1, :)       = view_data((2589-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_20(1, :)       = view_data((2591-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_16(1, :)       = view_data((2595-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_17(1, :)       = view_data((2597-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_18(1, :)       = view_data((2599-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_19(1, :)       = view_data((2601-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_20(1, :)       = view_data((2603-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_16(1, :)       = view_data((2607-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_17(1, :)       = view_data((2609-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_18(1, :)       = view_data((2611-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_19(1, :)       = view_data((2613-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_20(1, :)       = view_data((2615-offset)/2+1, :);

data.OBCT_view_data_mid_pixel_position_OBCT_view1(1, :)   = view_data((2617-offset)/2+1, :);
data.OBCT_view_data_mid_pixel_position_OBCT_view2(1, :)   = view_data((2629-offset)/2+1, :);
data.OBCT_view_data_mid_pixel_position_OBCT_view3(1, :)   = view_data((2641-offset)/2+1, :);
data.OBCT_view_data_mid_pixel_position_OBCT_view4(1, :)   = view_data((2653-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_16(1, :)         = view_data((2619-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_17(1, :)         = view_data((2621-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_18(1, :)         = view_data((2623-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_19(1, :)         = view_data((2625-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_20(1, :)         = view_data((2627-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_16(1, :)         = view_data((2631-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_17(1, :)         = view_data((2633-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_18(1, :)         = view_data((2635-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_19(1, :)         = view_data((2637-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_20(1, :)         = view_data((2639-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_16(1, :)         = view_data((2643-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_17(1, :)         = view_data((2645-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_18(1, :)         = view_data((2647-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_19(1, :)         = view_data((2649-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_20(1, :)         = view_data((2651-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_16(1, :)         = view_data((2655-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_17(1, :)         = view_data((2657-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_18(1, :)         = view_data((2659-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_19(1, :)         = view_data((2661-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_20(1, :)         = view_data((2663-offset)/2+1, :);


% digital A telemetry
invalid_databitflags_lines = dec2bin(get_vector_from_bytearray(2673, 2676, 'uint32'), 32);
invalid_databitflags = invalid_databitflags_lines - '0';
data.invalid_databitflags_digital_datawords_A01throughA26(1, :) = invalid_databitflags(:, 32);


%digital data words A01 A02
unitID_flags_A01_lines = dec2bin(get_vector_from_bytearray(2681, 2682, 'uint16'), 16);
unitID_flags_A01 = unitID_flags_A01_lines - '0';

data.unitID_flags_A01_processor_check_flag(1, :)    = unitID_flags_A01(:, 4);
data.unitID_flags_A01_scan_control_status(1, :)     = unitID_flags_A01(:, 5);
data.unitID_flags_A01_pixel_data_invalid_flag(1, :) = unitID_flags_A01(:, 6);
data.unitID_flags_A01_scan_synchronization(1, :)    = unitID_flags_A01(:, 7);
data.unitID_flags_A01_mode_transition_flag(1, :)    = unitID_flags_A01(:, 8);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 9);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 10);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 11);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 12);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 13);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 14);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 15);
data.unitID_flags_A01_moduleID(1, :)                = unitID_flags_A01(:, 16);


digital_B_telemetry_A02_lines = dec2bin(get_vector_from_bytearray(2683, 2684, 'uint16'), 16);
digital_B_telemetry_A02 = digital_B_telemetry_A02_lines - '0';

data.digital_B_telemetry_RAM_check_flag(1, :)         = digital_B_telemetry_A02(:, 1);
data.digital_B_telemetry_ROM_check_flag(1, :)         = digital_B_telemetry_A02(:, 2);
data.digital_B_telemetry_memory_checks_status(1, :)   = digital_B_telemetry_A02(:, 3);
data.digital_B_telemetry_space_view_select_lsb(1, :)  = digital_B_telemetry_A02(:, 4);
data.digital_B_telemetry_space_view_select_msb(1, :)  = digital_B_telemetry_A02(:, 5);
data.digital_B_telemetry_channel181920_onoff(1, :)    = digital_B_telemetry_A02(:, 6);
data.digital_B_telemetry_channel17_onoff(1, :)        = digital_B_telemetry_A02(:, 7);
data.digital_B_telemetry_channel16_onoff(1, :)        = digital_B_telemetry_A02(:, 8);
data.digital_B_telemetry_stepped_mode(1, :)           = digital_B_telemetry_A02(:, 9);
data.digital_B_telemetry_investigation_mode(1, :)     = digital_B_telemetry_A02(:, 10);
data.digital_B_telemetry_parked_spaceview_mode(1, :)  = digital_B_telemetry_A02(:, 11);
data.digital_B_telemetry_parked_nadirview_mode(1, :)  = digital_B_telemetry_A02(:, 12);
data.digital_B_telemetry_parked_targetview_mode(1, :) = digital_B_telemetry_A02(:, 13);
data.digital_B_telemetry_scan_normal_mode(1, :)       = digital_B_telemetry_A02(:, 14);
data.digital_B_telemetry_survival_heater_onoff(1, :)  = digital_B_telemetry_A02(:, 15);
data.digital_B_telemetry_power_onoff(1, :)            = digital_B_telemetry_A02(:, 16);


%digital data words A03 through A26
% OLE: Is this really int16, not uint16??? YES! uint16, IHans; changed to uint16
offset = 2685;
digital_data = get_vector_from_bytearray(offset, 2732, 'uint16')';
digital_data = reshape(digital_data, (2732-offset+1)/2, nlines);

data.mixer_16_temperature(1, :)                    = digital_data((2685-offset)/2+1, :);
data.mixer_17_temperature(1, :)                    = digital_data((2687-offset)/2+1, :);
data.mixer_18_19_20_temperature(1, :)              = digital_data((2689-offset)/2+1, :);
data.FET_amplifier_16_temperature(1, :)            = digital_data((2691-offset)/2+1, :);
data.FET_amplifier_17_temperature(1, :)            = digital_data((2693-offset)/2+1, :);
data.FET_amplifier_18_temperature(1, :)            = digital_data((2695-offset)/2+1, :);
data.FET_amplifier_19_temperature(1, :)            = digital_data((2697-offset)/2+1, :);
data.FET_amplifier_20_temperature(1, :)            = digital_data((2699-offset)/2+1, :);
data.calib_target_temperature_1(1, :)              = digital_data((2701-offset)/2+1, :);
data.calib_target_temperature_2(1, :)              = digital_data((2703-offset)/2+1, :);
data.calib_target_temperature_3(1, :)              = digital_data((2705-offset)/2+1, :);
data.calib_target_temperature_4(1, :)              = digital_data((2707-offset)/2+1, :);
data.calib_target_temperature_5(1, :)              = digital_data((2709-offset)/2+1, :);
data.calib_target_temperature_6(1, :)              = digital_data((2711-offset)/2+1, :);
data.calib_target_temperature_7(1, :)              = digital_data((2713-offset)/2+1, :);
data.subreflector_temperature_1(1, :)              = digital_data((2715-offset)/2+1, :);
data.local_oscillator_monitor_current_16(1, :)     = digital_data((2717-offset)/2+1, :);
data.local_oscillator_monitor_current_17(1, :)     = digital_data((2719-offset)/2+1, :);
data.local_oscillator_monitor_current_181920(1, :) = digital_data((2721-offset)/2+1, :);
data.local_oscillator_16_temperature(1, :)         = digital_data((2723-offset)/2+1, :);
data.local_oscillator_17_temperature(1, :)         = digital_data((2725-offset)/2+1, :);
data.local_oscillator_181920_temperature(1, :)     = digital_data((2727-offset)/2+1, :); %KLM guide says int16 but this seems wrong
data.PRT_bridge_voltage(1, :)                      = digital_data((2729-offset)/2+1, :);
data.PRT_board_temperature(1, :)                   = digital_data((2731-offset)/2+1, :);


% analog telemetry
analog_tel_invalid_data_bit_flags_lines = dec2bin(get_vector_from_bytearray(2745, 2748, 'uint32'), 32);
analog_tel_invalid_data_bit_flags = analog_tel_invalid_data_bit_flags_lines - '0';

data.analog_tel_SARR_B_power_status(1, :)             = analog_tel_invalid_data_bit_flags(:, 5);
data.analog_tel_SARR_A_power_status(1, :)             = analog_tel_invalid_data_bit_flags(:, 6);
data.analog_tel_STX_3_power_status(1, :)              = analog_tel_invalid_data_bit_flags(:, 7);
data.analog_tel_STX_2_power_status(1, :)              = analog_tel_invalid_data_bit_flags(:, 8);
data.analog_tel_STX_1_power_status(1, :)              = analog_tel_invalid_data_bit_flags(:, 9);
data.analog_tel_STX_4_status_status(1, :)             = analog_tel_invalid_data_bit_flags(:, 10);
data.analog_tel_STX_3_status_status(1, :)             = analog_tel_invalid_data_bit_flags(:, 11);
data.analog_tel_STX_2_status_status(1, :)             = analog_tel_invalid_data_bit_flags(:, 12);
data.analog_tel_STX_1_status_status(1, :)             = analog_tel_invalid_data_bit_flags(:, 13);
data.analog_tel_Ch_181920_LO_temperature_status(1, :) = analog_tel_invalid_data_bit_flags(:, 14);
data.analog_tel_Ch_17_LO_temperature_status(1, :)     = analog_tel_invalid_data_bit_flags(:, 15);
data.analog_tel_Ch_16_LO_temperature_status(1, :)     = analog_tel_invalid_data_bit_flags(:, 16);
data.analog_tel_scanmotorcurrent_status(1, :)         = analog_tel_invalid_data_bit_flags(:, 17);
data.analog_tel_scanmotortemperature_status(1, :)     = analog_tel_invalid_data_bit_flags(:, 18);
data.analog_tel_PSU_temperature_status(1, :)          = analog_tel_invalid_data_bit_flags(:, 19);
data.analog_tel_PEU_temperature_status(1, :)          = analog_tel_invalid_data_bit_flags(:, 20);
data.analog_tel_MDE_temperature_status(1, :)          = analog_tel_invalid_data_bit_flags(:, 21);
data.analog_tel_ICE_temperature_status(1, :)          = analog_tel_invalid_data_bit_flags(:, 22);
data.analog_tel_plus5V_ref_secondary_status(1, :)     = analog_tel_invalid_data_bit_flags(:, 23);
data.analog_tel_minus5VA_secondary_status(1, :)       = analog_tel_invalid_data_bit_flags(:, 24);
data.analog_tel_plus5VA_secondary_status(1, :)        = analog_tel_invalid_data_bit_flags(:, 25);
data.analog_tel_plus5VD_secondary_status(1, :)        = analog_tel_invalid_data_bit_flags(:, 26);
data.analog_tel_plus8VA_secondary_status(1, :)        = analog_tel_invalid_data_bit_flags(:, 27);
data.analog_tel_minus15VA_secondary_status(1, :)      = analog_tel_invalid_data_bit_flags(:, 28);
data.analog_tel_plus15VA_secondary_status(1, :)       = analog_tel_invalid_data_bit_flags(:, 29);
data.analog_tel_minus12VA_secondary_status(1, :)      = analog_tel_invalid_data_bit_flags(:, 30);
data.analog_tel_plus12VA_secondary_status(1, :)       = analog_tel_invalid_data_bit_flags(:, 31);


offset = 2749;
power_data = get_vector_from_bytearray(offset, 2802, 'int16')';
power_data = reshape(power_data, (2802-offset+1)/2, nlines);

data.plus12VA_secondary(1, :)       = power_data((2749-offset)/2+1, :);
data.minus12VA_secondary(1, :)      = power_data((2751-offset)/2+1, :);
data.plus15VA_secondary(1, :)       = power_data((2753-offset)/2+1, :);
data.minus15VA_secondary(1, :)      = power_data((2755-offset)/2+1, :);
data.plus8VA_secondary(1, :)        = power_data((2757-offset)/2+1, :);
data.plus5VD_secondary(1, :)        = power_data((2759-offset)/2+1, :);
data.plus5VA_secondary(1, :)        = power_data((2761-offset)/2+1, :);
data.minus5VA_secondary(1, :)       = power_data((2763-offset)/2+1, :);
data.plus5V_ref_secondary(1, :)     = power_data((2765-offset)/2+1, :);
data.ICE_temperature(1, :)          = power_data((2767-offset)/2+1, :);
data.MDE_temperature(1, :)          = power_data((2769-offset)/2+1, :);
data.PEU_temperature(1, :)          = power_data((2771-offset)/2+1, :);
data.PSU_temperature(1, :)          = power_data((2773-offset)/2+1, :);
data.scanmotortemperature(1, :)     = power_data((2775-offset)/2+1, :);
data.scanmotorcurrent(1, :)         = power_data((2777-offset)/2+1, :);
data.Ch_16_LO_temperature(1, :)     = power_data((2779-offset)/2+1, :);
data.Ch_17_LO_temperature(1, :)     = power_data((2781-offset)/2+1, :);
data.Ch_181920_LO_temperature(1, :) = power_data((2783-offset)/2+1, :);
data.STX_1_status(1, :)             = power_data((2785-offset)/2+1, :);
data.STX_2_status(1, :)             = power_data((2787-offset)/2+1, :);
data.STX_3_status(1, :)             = power_data((2789-offset)/2+1, :);
data.STX_4_status(1, :)             = power_data((2791-offset)/2+1, :);
data.STX_1_power(1, :)              = power_data((2793-offset)/2+1, :);
data.STX_2_power(1, :)              = power_data((2795-offset)/2+1, :);
data.STX_3_power(1, :)              = power_data((2797-offset)/2+1, :);
data.SARR_A_power(1, :)             = power_data((2799-offset)/2+1, :);
data.SARR_B_power(1, :)             = power_data((2801-offset)/2+1, :);

end


function logical_array = create_selection(startbyte, endbyte, startline, nlines, rlen)
    logical_array = false(1, rlen * (startline - 1));
    initial_array = false(1, rlen);
    initial_array(startbyte:endbyte) = true;
    logical_array = [logical_array, repmat(initial_array, 1, nlines)];
end
