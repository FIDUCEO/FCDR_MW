% READ_MHS_RECORD   Read all record entries of MHS data file.
%
% The function extracts record entries of an MHS 
% data file.
%
% OLE: quality_flags_lines changed data type from
% quality_flags_lines{channel}(nlines, bit) to
% quality_flags_lines(channel, nlines, bit)
%
% FORMAT   data = read_MHS_record( record );
%
% IN    record 


function [data, quality_indicator_lines,quality_flags_0_lines,quality_flags_1_lines,quality_flags_2_lines,quality_flags_3_lines,quality_flags_lines ] = read_MHS_record( record, nlines_read, rlen ,startline)
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

data.coarse_MHS_onboard_time(1, :) = get_vector_from_bytearray(17, 20, 'uint32');

data.fine_MHS_onboard_time(1, :) = get_vector_from_bytearray(21, 22, 'uint16');

% MHS mode flag
% not yet read in
% IH: is uint8 acc. to KLM, but has 16 bits?

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
%data.quality_indicator_new_bias_status_change(1, :)          = quality_indicator(:, 8);
%data.quality_indicator_new_bias_status(1, :)                 = quality_indicator(:, 9);
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

%data.calibration_quality_flags_Ch_H1_scanline_count_anomaly(1, :)    = quality_flags(1, :, 10);
%data.calibration_quality_flags_Ch_H2_scanline_count_anomaly(1, :)    = quality_flags(2, :, 10);
%data.calibration_quality_flags_Ch_H3_scanline_count_anomaly(1, :)    = quality_flags(3, :, 10);
%data.calibration_quality_flags_Ch_H4_scanline_count_anomaly(1, :)    = quality_flags(4, :, 10);
%data.calibration_quality_flags_Ch_H5_scanline_count_anomaly(1, :)    = quality_flags(5, :, 10);
data.calibration_quality_flags_Ch_H1_scanline_before_jump(1, :)   	  = quality_flags(1, :, 10);
data.calibration_quality_flags_Ch_H2_scanline_before_jump(1, :)       = quality_flags(2, :, 10);
data.calibration_quality_flags_Ch_H3_scanline_before_jump(1, :)       = quality_flags(3, :, 10);
data.calibration_quality_flags_Ch_H4_scanline_before_jump(1, :)       = quality_flags(4, :, 10);
data.calibration_quality_flags_Ch_H5_scanline_before_jump(1, :)       = quality_flags(5, :, 10);
data.calibration_quality_flags_Ch_H1_all_bad_blackbody_counts(1, :)   = quality_flags(1, :, 11);
data.calibration_quality_flags_Ch_H2_all_bad_blackbody_counts(1, :)   = quality_flags(2, :, 11);
data.calibration_quality_flags_Ch_H3_all_bad_blackbody_counts(1, :)   = quality_flags(3, :, 11);
data.calibration_quality_flags_Ch_H4_all_bad_blackbody_counts(1, :)   = quality_flags(4, :, 11);
data.calibration_quality_flags_Ch_H5_all_bad_blackbody_counts(1, :)   = quality_flags(5, :, 11);
data.calibration_quality_flags_Ch_H1_all_bad_spaceview_counts(1, :)   = quality_flags(1, :, 12);
data.calibration_quality_flags_Ch_H2_all_bad_spaceview_counts(1, :)   = quality_flags(2, :, 12);
data.calibration_quality_flags_Ch_H3_all_bad_spaceview_counts(1, :)   = quality_flags(3, :, 12);
data.calibration_quality_flags_Ch_H4_all_bad_spaceview_counts(1, :)   = quality_flags(4, :, 12);
data.calibration_quality_flags_Ch_H5_all_bad_spaceview_counts(1, :)   = quality_flags(5, :, 12);
data.calibration_quality_flags_Ch_H1_all_bad_PRTs(1, :)               = quality_flags(1, :, 13);
data.calibration_quality_flags_Ch_H2_all_bad_PRTs(1, :)               = quality_flags(2, :, 13);
data.calibration_quality_flags_Ch_H3_all_bad_PRTs(1, :)               = quality_flags(3, :, 13);
data.calibration_quality_flags_Ch_H4_all_bad_PRTs(1, :)               = quality_flags(4, :, 13);
data.calibration_quality_flags_Ch_H5_all_bad_PRTs(1, :)               = quality_flags(5, :, 13);
data.calibration_quality_flags_Ch_H1_marginal_OBCT_view_counts(1, :)  = quality_flags(1, :, 14);
data.calibration_quality_flags_Ch_H2_marginal_OBCT_view_counts(1, :)  = quality_flags(2, :, 14);
data.calibration_quality_flags_Ch_H3_marginal_OBCT_view_counts(1, :)  = quality_flags(3, :, 14);
data.calibration_quality_flags_Ch_H4_marginal_OBCT_view_counts(1, :)  = quality_flags(4, :, 14);
data.calibration_quality_flags_Ch_H5_marginal_OBCT_view_counts(1, :)  = quality_flags(5, :, 14);
data.calibration_quality_flags_Ch_H1_marginal_space_view_counts(1, :) = quality_flags(1, :, 15);
data.calibration_quality_flags_Ch_H2_marginal_space_view_counts(1, :) = quality_flags(2, :, 15);
data.calibration_quality_flags_Ch_H3_marginal_space_view_counts(1, :) = quality_flags(3, :, 15);
data.calibration_quality_flags_Ch_H4_marginal_space_view_counts(1, :) = quality_flags(4, :, 15);
data.calibration_quality_flags_Ch_H5_marginal_space_view_counts(1, :) = quality_flags(5, :, 15);
data.calibration_quality_flags_Ch_H1_marginal_PRT_temps(1, :)         = quality_flags(1, :, 16);
data.calibration_quality_flags_Ch_H2_marginal_PRT_temps(1, :)         = quality_flags(2, :, 16);
data.calibration_quality_flags_Ch_H3_marginal_PRT_temps(1, :)         = quality_flags(3, :, 16);
data.calibration_quality_flags_Ch_H4_marginal_PRT_temps(1, :)         = quality_flags(4, :, 16);
data.calibration_quality_flags_Ch_H5_marginal_PRT_temps(1, :)         = quality_flags(5, :, 16);


quality_flags = dec2bin(get_vector_from_bytearray(29, 32, 'uint8'), 8);
quality_flags = reshape(quality_flags, 4, nlines, 8);
quality_flags_0_lines = squeeze(quality_flags(1, :, :));
quality_flags_1_lines = squeeze(quality_flags(2, :, :));
quality_flags_2_lines = squeeze(quality_flags(3, :, :));
quality_flags_3_lines = squeeze(quality_flags(4, :, :));
quality_flags = quality_flags -'0';

data.scan_line_quality_flags_contains_lunar_contaminated_space_view(1, :) = quality_flags(2, :, 7); 
data.scan_line_quality_flags_lunar_contaminated_line_was_calibrated(1, :) = quality_flags(2, :, 8); 
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

data.primary_calibration_Ch_H1_second_order_term_a2(1, :)   = calibration((61-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_H2_second_order_term_a2(1, :)   = calibration((73-offset)/4+1, :)*1e-16;
data.primary_calibration_Ch_H3_second_order_term_a2(1, :)   = calibration((85-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_H4_second_order_term_a2(1, :)   = calibration((97-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_H5_second_order_term_a2(1, :)   = calibration((109-offset)/4+1, :)*1e-16; 
data.primary_calibration_Ch_H1_first_order_term_a1(1, :)    = calibration((65-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_H2_first_order_term_a1(1, :)    = calibration((77-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_H3_first_order_term_a1(1, :)    = calibration((89-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_H4_first_order_term_a1(1, :)    = calibration((101-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_H5_first_order_term_a1(1, :)    = calibration((113-offset)/4+1, :)*1e-10;
data.primary_calibration_Ch_H1_zeroth_order_term_a0(1, :)   = calibration((69-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_H2_zeroth_order_term_a0(1, :)   = calibration((81-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_H3_zeroth_order_term_a0(1, :)   = calibration((93-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_H4_zeroth_order_term_a0(1, :)   = calibration((105-offset)/4+1, :)*1e-6;
data.primary_calibration_Ch_H5_zeroth_order_term_a0(1, :)   = calibration((117-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_H1_second_order_term_a2(1, :) = calibration((121-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_H2_second_order_term_a2(1, :) = calibration((133-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_H3_second_order_term_a2(1, :) = calibration((145-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_H4_second_order_term_a2(1, :) = calibration((157-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_H5_second_order_term_a2(1, :) = calibration((169-offset)/4+1, :)*1e-16;
data.secondary_calibration_Ch_H1_first_order_term_a1(1, :)  = calibration((125-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_H2_first_order_term_a1(1, :)  = calibration((137-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_H3_first_order_term_a1(1, :)  = calibration((149-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_H4_first_order_term_a1(1, :)  = calibration((161-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_H5_first_order_term_a1(1, :)  = calibration((173-offset)/4+1, :)*1e-10;
data.secondary_calibration_Ch_H1_zeroth_order_term_a0(1, :) = calibration((129-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_H2_zeroth_order_term_a0(1, :) = calibration((141-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_H3_zeroth_order_term_a0(1, :) = calibration((153-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_H4_zeroth_order_term_a0(1, :) = calibration((165-offset)/4+1, :)*1e-6;
data.secondary_calibration_Ch_H5_zeroth_order_term_a0(1, :) = calibration((177-offset)/4+1, :)*1e-6;


navigation_status_lines = dec2bin(get_vector_from_bytearray(197, 200, 'int32'), 32);
navigation_status = navigation_status_lines - '0';
%data.navigation_status_earth_loc_at_satellite_subpoint_reasonable(1, :)   = navigation_status(:, 15);
data.navigation_status_attitude_earth_loc_corrected_for_Euler_angles(1, :) = navigation_status(:, 16);
data.navigation_status_attitude_earth_location_indicator(1, :)             = bin2dec(navigation_status_lines(:, 17:21));
data.navigation_status_spacecraft_attitude_control(1, :)                   = bin2dec(navigation_status_lines(:, 22:25)); 
data.navigation_status_attitude_SMODE(1, :)                                = bin2dec(navigation_status_lines(:, 26:29));
data.navigation_status_attitude_PWTIP_AC(1, :)                             = bin2dec(navigation_status_lines(:, 30:32));


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

% Lunar Angles
offset = 1473;
moon_ang = double(get_vector_from_bytearray(offset, 1480, 'uint16'))';
moon_ang = reshape(moon_ang, (1480-offset+1)/2, nlines);
data.moonangle_spaceview1(1, :)  = moon_ang((1473-offset)/2+1, :)*1e-2;
data.moonangle_spaceview2(1, :)  = moon_ang((1475-offset)/2+1, :)*1e-2;
data.moonangle_spaceview3(1, :)  = moon_ang((1477-offset)/2+1, :)*1e-2;
data.moonangle_spaceview4(1, :)  = moon_ang((1479-offset)/2+1, :)*1e-2;



scene_earth_view_data = get_vector_from_bytearray(1481, (nfov-1)*12+1492, 'uint16');
data.scene_earth_view_data_mid_pixel_position_FOV_XX(:,:) = reshape(scene_earth_view_data(1:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H1(:,:) = reshape(scene_earth_view_data(2:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H2(:,:) = reshape(scene_earth_view_data(3:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H3(:,:) = reshape(scene_earth_view_data(4:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H4(:,:) = reshape(scene_earth_view_data(5:6:end), nfov, nlines);
data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H5(:,:) = reshape(scene_earth_view_data(6:6:end), nfov, nlines);


offset = 2569;
view_data = get_vector_from_bytearray(offset, 2664, 'uint16')';
view_data = reshape(view_data, (2664-offset+1)/2, nlines);

data.space_view_data_mid_pixel_position_space_view1(1, :) = view_data((2569-offset)/2+1, :);
data.space_view_data_mid_pixel_position_space_view2(1, :) = view_data((2581-offset)/2+1, :);
data.space_view_data_mid_pixel_position_space_view3(1, :) = view_data((2593-offset)/2+1, :);
data.space_view_data_mid_pixel_position_space_view4(1, :) = view_data((2605-offset)/2+1, :);

data.space_view_data_counts_space_view1_Ch_H1(1, :)       = view_data((2571-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_H2(1, :)       = view_data((2573-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_H3(1, :)       = view_data((2575-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_H4(1, :)       = view_data((2577-offset)/2+1, :);
data.space_view_data_counts_space_view1_Ch_H5(1, :)       = view_data((2579-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_H1(1, :)       = view_data((2583-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_H2(1, :)       = view_data((2585-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_H3(1, :)       = view_data((2587-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_H4(1, :)       = view_data((2589-offset)/2+1, :);
data.space_view_data_counts_space_view2_Ch_H5(1, :)       = view_data((2591-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_H1(1, :)       = view_data((2595-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_H2(1, :)       = view_data((2597-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_H3(1, :)       = view_data((2599-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_H4(1, :)       = view_data((2601-offset)/2+1, :);
data.space_view_data_counts_space_view3_Ch_H5(1, :)       = view_data((2603-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_H1(1, :)       = view_data((2607-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_H2(1, :)       = view_data((2609-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_H3(1, :)       = view_data((2611-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_H4(1, :)       = view_data((2613-offset)/2+1, :);
data.space_view_data_counts_space_view4_Ch_H5(1, :)       = view_data((2615-offset)/2+1, :);

data.OBCT_view_data_mid_pixel_position_OBCT_view1(1, :)   = view_data((2617-offset)/2+1, :);
data.OBCT_view_data_mid_pixel_position_OBCT_view2(1, :)   = view_data((2629-offset)/2+1, :);
data.OBCT_view_data_mid_pixel_position_OBCT_view3(1, :)   = view_data((2641-offset)/2+1, :);
data.OBCT_view_data_mid_pixel_position_OBCT_view4(1, :)   = view_data((2653-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_H1(1, :)         = view_data((2619-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_H2(1, :)         = view_data((2621-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_H3(1, :)         = view_data((2623-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_H4(1, :)         = view_data((2625-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view1_Ch_H5(1, :)         = view_data((2627-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_H1(1, :)         = view_data((2631-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_H2(1, :)         = view_data((2633-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_H3(1, :)         = view_data((2635-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_H4(1, :)         = view_data((2637-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view2_Ch_H5(1, :)         = view_data((2639-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_H1(1, :)         = view_data((2643-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_H2(1, :)         = view_data((2645-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_H3(1, :)         = view_data((2647-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_H4(1, :)         = view_data((2649-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view3_Ch_H5(1, :)         = view_data((2651-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_H1(1, :)         = view_data((2655-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_H2(1, :)         = view_data((2657-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_H3(1, :)         = view_data((2659-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_H4(1, :)         = view_data((2661-offset)/2+1, :);
data.OBCT_view_data_counts_OBCT_view4_Ch_H5(1, :)         = view_data((2663-offset)/2+1, :);

% FIXME: the position validity flags ARE NOT yet correct! dimension mismatch....
%position validity flags 
%pos_valid_flags = dec2bin(get_vector_from_bytearray(2673, 2686, 'uint8'), 8);
%pos_valid_flags = reshape(pos_valid_flags, 14, nlines, 8);
%pos_valid_flags = pos_valid_flags -'0';
 
%data.position_valid_flag_FOVXX(1:8, :)           						= pos_valid_flags(1, :, 1:8);
%data.position_valid_flag_FOVXX(9:16, :)           						= pos_valid_flags(2, :, 1:8);
%data.position_valid_flag_FOVXX(17:24, :)           						= pos_valid_flags(3, :, 1:8);
%data.position_valid_flag_FOVXX(25:32, :)           						= pos_valid_flags(4, :, 1:8);
%data.position_valid_flag_FOVXX(33:40, :)           						= pos_valid_flags(5, :, 1:8);
%data.position_valid_flag_FOVXX(41:48, :)           						= pos_valid_flags(6, :, 1:8);
%data.position_valid_flag_FOVXX(49:56, :)           						= pos_valid_flags(7, :, 1:8);
%data.position_valid_flag_FOVXX(57:64, :)           						= pos_valid_flags(8, :, 1:8);
%data.position_valid_flag_FOVXX(65:72, :)           						= pos_valid_flags(9, :, 1:8);
%data.position_valid_flag_FOVXX(73:80, :)           						= pos_valid_flags(10, :, 1:8);
%data.position_valid_flag_FOVXX(81:88, :)           						= pos_valid_flags(11, :, 1:8);
%data.position_valid_flag_FOVXX(89:90, :)           						= pos_valid_flags(12, :, 1:2);
%%for spaceviews
%data.position_valid_flag_spaceview1(1, :)           						= pos_valid_flags(13, :, 5);
%data.position_valid_flag_spaceview2(1, :)           						= pos_valid_flags(13, :, 6);
%data.position_valid_flag_spaceview3(1, :)           						= pos_valid_flags(13, :, 7);
%data.position_valid_flag_spaceview4(1, :)           						= pos_valid_flags(13, :, 8);
%% for obct views
%data.position_valid_flag_obctview1(1, :)           						= pos_valid_flags(14, :, 5);
%data.position_valid_flag_obctview2(1, :)           						= pos_valid_flags(14, :, 6);
%data.position_valid_flag_obctview3(1, :)           						= pos_valid_flags(14, :, 7);
%data.position_valid_flag_obctview4(1, :)           						= pos_valid_flags(14, :, 8);

%Full housekeeping data
% mode and Sub-commutation Code
mode_submode_comm_code = dec2bin(get_vector_from_bytearray(2687, 2687, 'uint8'), 8);
mode_submode_comm_code = reshape(mode_submode_comm_code, 1, nlines, 8);
mode_submode_comm_code = mode_submode_comm_code -'0';
data.mode_code(1, :)           					= dec2bin(mode_submode_comm_code(1, :, 1:4));
data.PIE_ID(1, :)           					= mode_submode_comm_code(1, :, 5);
data.subcommutation_code(1, :)           		= dec2bin(mode_submode_comm_code(1, :, 6:8));


%Telecommand Acknowledgement and Fault code
telecommand_fault_code = dec2bin(get_vector_from_bytearray(2688, 2692, 'uint8'), 8);
telecommand_fault_code = reshape(telecommand_fault_code, 5, nlines, 8);
telecommand_fault_code = telecommand_fault_code -'0';
 

data.TC_clean(1, :)           						= telecommand_fault_code(1, :, 1);
data.TC_conforms(1, :)           					= telecommand_fault_code(1, :, 2);  
data.TC_recognized(1, :)           					= telecommand_fault_code(1, :, 3);  
data.TC_legal(1, :)           						= telecommand_fault_code(1, :, 4);  
data.FDM_motor_current_trip_status(1, :)        			= telecommand_fault_code(1, :, 5);  
% these lines do not work: dimensions concatenated are not consistent
%data.TC_applic_ID(1, :)        						= [telecommand_fault_code(1, :, 6:8) telecommand_fault_code(2, :, 1:8)];  
%data.TC_packet_seq_count(1, :)        				= [telecommand_fault_code(3, :, 1:8) telecommand_fault_code(4, :, 1:6)];  
% this line does not work: subscripted assignment dimension mismatch
%data.TC_received_count(1, :)        				= telecommand_fault_code(4, :, 7:8);
data.current_monitor_fault(1, :)        			= telecommand_fault_code(5, :, 1);
data.thermistor_monitor_fault(1, :)        			= telecommand_fault_code(5, :, 2);
data.switch_fault(1, :)        						= telecommand_fault_code(5, :, 3);
data.processor_fault(1, :)        					= telecommand_fault_code(5, :, 4);
data.RDM_motor_current_trip_status(1, :)        			= telecommand_fault_code(5, :, 5);
data.DC_offset_error(1, :)        					= telecommand_fault_code(5, :, 6);
data.scan_control_error(1, :)        					= telecommand_fault_code(5, :, 7);
data.REF_CK_error(1, :)        						= telecommand_fault_code(5, :, 8);



%Switch Status
switch_status = dec2bin(get_vector_from_bytearray(2693, 2695, 'uint8'), 8);
switch_status = reshape(switch_status, 3, nlines, 8);
switch_status = switch_status -'0';
 
data.receiver_Ch_H4_backend(1, :)           						= switch_status(1, :, 1);
data.receiver_Ch_H3_backend(1, :)                        		    = switch_status(1, :, 2);
data.receiver_Ch_H3_H4_localoscillator_select(1, :)      		    = switch_status(1, :, 3);
data.receiver_Ch_H3_H4_frontend(1, :)                    			= switch_status(1, :, 4);
data.receiver_Ch_H2_localoscillator_select(1, :) 					= switch_status(1, :, 5); 
data.receiver_Ch_H2(1, :) 											= switch_status(1, :, 6);
data.receiver_Ch_H1_localoscillator_select(1, :)               	    = switch_status(1, :, 7);
data.receiver_Ch_H1(1, :)        									= switch_status(1, :, 8);
data.PROM(1, :)            											= switch_status(2, :, 1);
data.signal_proc_electr_scancontrl_electr(1, :)           			= switch_status(2, :, 2);
data.aux_operational_heaters(1, :)           						= switch_status(2, :, 3);
data.scan_mechanism_operational_heaters(1, :) 						= switch_status(2, :, 4);
data.receiver_operational_heaters(1, :)  							= switch_status(2, :, 5);
data.RxCV(1, :)             										= switch_status(2, :, 6);
data.receiver_Ch_H5_localoscillator_select(1, :)  					= switch_status(2, :, 7);
data.receiver_Ch_H5(1, :)     										= switch_status(2, :, 8);
data.FDM_motor_current_trip_status(1, :)         					= switch_status(3, :, 1);
data.RDM_motor_current_trip_status(1, :)          		 			= switch_status(3, :, 2);
data.FDM_motor_supply(1, :)           								= switch_status(3, :, 3);
data.RDM_motor_supply(1, :) 										= switch_status(3, :, 4);
data.FDM_motor_sensors_selected(1, :)  								= switch_status(3, :, 5);
data.RDM_motor_sensors_selected(1, :)             					= switch_status(3, :, 6);
data.FDM_zero_positiion_sensors(1, :)  								= switch_status(3, :, 7);
data.RDM_zero_positiion_sensors(1, :)     							= switch_status(3, :, 8);

% Temperature data
offset = 2696;
temp_data = double(get_vector_from_bytearray(offset, 2719, 'uint8'))';
temp_data = reshape(temp_data, (2719-offset+1), nlines);
data.temperature_data_LO_H1_temperature(1, :)  					= temp_data((2696-offset)+1, :);
data.temperature_data_LO_H2_temperature(1, :)  					= temp_data((2697-offset)+1, :);
data.temperature_data_LO_H3_H4_temperature(1, :)  				= temp_data((2698-offset)+1, :);
data.temperature_data_LO_H5_temperature(1, :)  					= temp_data((2699-offset)+1, :);
data.temperature_data_Mixer_LNA_multipl_H1_temperature(1, :)	= temp_data((2700-offset)+1, :);
data.temperature_data_Mixer_LNA_multipl_H2_temperature(1, :)	= temp_data((2701-offset)+1, :);
data.temperature_data_Mixer_LNA_multipl_H3_H4_temperature(1, :) = temp_data((2702-offset)+1, :);
data.temperature_data_Mixer_LNA_multipl_H5_temperature(1, :)	= temp_data((2703-offset)+1, :);
data.temperature_data_QuasiOptbaseplate_temperature1(1, :)		= temp_data((2704-offset)+1, :);
data.temperature_data_QuasiOptbaseplate_temperature2(1, :)		= temp_data((2705-offset)+1, :);
data.temperature_data_IFbaseplate_temperature1(1, :)			= temp_data((2706-offset)+1, :);
data.temperature_data_IFbaseplate_temperature2(1, :)			= temp_data((2707-offset)+1, :);
data.temperature_data_Scan_mech_core_temperature(1, :)			= temp_data((2708-offset)+1, :);
data.temperature_data_Scan_mech_housing_temperature(1, :)		= temp_data((2709-offset)+1, :);
data.temperature_data_RDM_SSHM_temperature(1, :)				= temp_data((2710-offset)+1, :);
data.temperature_data_FDM_SSHM_temperature(1, :)				= temp_data((2711-offset)+1, :);
data.temperature_data_structure1_temperature(1, :)				= temp_data((2712-offset)+1, :);
data.temperature_data_structure2_temperature(1, :)				= temp_data((2713-offset)+1, :);
data.temperature_data_structure3_temperature(1, :)				= temp_data((2714-offset)+1, :);
data.temperature_data_processor_module_temperature(1, :)		= temp_data((2715-offset)+1, :);
data.temperature_data_Main_DCDC_conv_temperature(1, :)			= temp_data((2716-offset)+1, :);
data.temperature_data_SCE_RDM_module_temperature(1, :)			= temp_data((2717-offset)+1, :);
data.temperature_data_SCE_FDM_module_temperature(1, :)			= temp_data((2718-offset)+1, :);
data.temperature_data_RF_DCDC_conv_temperature(1, :)			= temp_data((2719-offset)+1, :);

% Raw current consumption data
offset = 2720;
curr_data = double(get_vector_from_bytearray(offset, 2725, 'uint8'))';
curr_data = reshape(curr_data, (2725-offset+1), nlines);
data.raw_current_consumption_data_EE_SM_p5Vcurr(1, :)  						= curr_data((2720-offset)+1, :);
data.raw_current_consumption_data_receiver_p8Vcurr(1, :)  					= curr_data((2721-offset)+1, :);
data.raw_current_consumption_data_receiver_p15Vcurr(1, :)  					= curr_data((2722-offset)+1, :);
data.raw_current_consumption_data_receiver_m15Vcurr(1, :)  					= curr_data((2723-offset)+1, :);
data.raw_current_consumption_data_RDM_motor_current(1, :)					= curr_data((2724-offset)+1, :);
data.raw_current_consumption_data_FDM_motor_current(1, :)					= curr_data((2725-offset)+1, :);


%Status Word
status_word = dec2bin(get_vector_from_bytearray(2727, 2727, 'uint8'), 8);
status_word = status_word -'0';
data.status_word_DC_offset_valid(1, :)           			= status_word(:, 1);
data.status_word_scan_control_valid(1, :)                   		= status_word(:, 2);
data.status_word_profile(1, :)      		   			= bin2dec(num2str(status_word(:, 3:4)));


% DC offset words change
offset = 2735;
dc_offset_word = double(get_vector_from_bytearray(offset, 2739, 'uint8'))';
dc_offset_word = reshape(dc_offset_word, (2739-offset+1), nlines);
data.Ch_H1_DC_offsetword(1, :)  					= dc_offset_word((2735-offset)+1, :);
data.Ch_H2_DC_offsetword(1, :)  					= dc_offset_word((2736-offset)+1, :);
data.Ch_H3_DC_offsetword(1, :)  					= dc_offset_word((2737-offset)+1, :);
data.Ch_H4_DC_offsetword(1, :)  					= dc_offset_word((2738-offset)+1, :);
data.Ch_H5_DC_offsetword(1, :)						= dc_offset_word((2739-offset)+1, :);

%Channel valid Flags
ch_valid_flags = dec2bin(get_vector_from_bytearray(2740, 2740, 'uint8'), 8);
ch_valid_flags = ch_valid_flags -'0';
data.flags_Ch_H1_valid(1, :)           			= ch_valid_flags( :, 1);
data.flags_Ch_H2_valid(1, :)                   	= ch_valid_flags( :, 2);
data.flags_Ch_H3_valid(1, :)           			= ch_valid_flags( :, 3);
data.flags_Ch_H4_valid(1, :)                   	= ch_valid_flags( :, 4);   	
data.flags_Ch_H5_valid(1, :)                  	= ch_valid_flags( :, 5); 
data.flags_SPE_MUX_code(1, :)                   = bin2dec(num2str(ch_valid_flags( :, 6:8))); 


% FIXME does not yet work!
%%Channel Gain
%channel_gain = dec2bin(get_vector_from_bytearray(2741, 2743, 'uint8'), 8);
%channel_gain = reshape(channel_gain, 3, nlines, 8);
%channel_gain = channel_gain -'0';
 
%data.channel_gain_ch_H1_gain(1, :)           					= bin2dec(channel_gain(1, :, 1:3));
%data.channel_gain_ch_H2_gain(1, :)                       	    		= bin2dec(channel_gain(2, :, 4:6));
%data.channel_gain_ch_H3_gain(1, :)           					= bin2dec(channel_gain(3, :, 1:3));
%data.channel_gain_ch_H4_gain(1, :)                       	    		= bin2dec(channel_gain(4, :, 4:6));
%data.channel_gain_ch_H5_gain(1, :)           					= bin2dec(channel_gain(5, :, 1:3));

% OBCT temperature Data
offset = 2751;
obct_readings_prt_calibchn = double(get_vector_from_bytearray(offset, 2766, 'uint16'))';
obct_readings_prt_calibchn = reshape(obct_readings_prt_calibchn, (2766-offset+1)/2, nlines);
data.OBCT_PRT_readings_PRT1(1, :)  		= obct_readings_prt_calibchn((2751-offset)/2+1, :);
data.OBCT_PRT_readings_PRT2(1, :) 			= obct_readings_prt_calibchn((2753-offset)/2+1, :);
data.OBCT_PRT_readings_PRT3(1, :)  		= obct_readings_prt_calibchn((2755-offset)/2+1, :);
data.OBCT_PRT_readings_PRT4(1, :)   		= obct_readings_prt_calibchn((2757-offset)/2+1, :);
data.OBCT_PRT_readings_PRT5(1, :)   		= obct_readings_prt_calibchn((2759-offset)/2+1, :);
data.PRTcalib_chn1(1, :)  			= obct_readings_prt_calibchn((2761-offset)/2+1, :);
data.PRTcalib_chn2(1, :)   		= obct_readings_prt_calibchn((2763-offset)/2+1, :);
data.PRTcalib_chn3(1, :)   		= obct_readings_prt_calibchn((2765-offset)/2+1, :);

% Computed OBCT temperatures
offset = 2769;
comp_obct_temp = double(get_vector_from_bytearray(offset, 2788, 'uint32'))';
comp_obct_temp = reshape(comp_obct_temp, (2788-offset+1)/4, nlines);
data.computed_OBCT_temperature1_PRT1_based(1, :)  		= comp_obct_temp((2769-offset)/4+1, :)*1e-3;
data.computed_OBCT_temperature2_PRT2_based(1, :) 		= comp_obct_temp((2773-offset)/4+1, :)*1e-3;
data.computed_OBCT_temperature3_PRT3_based(1, :)  		= comp_obct_temp((2777-offset)/4+1, :)*1e-3;
data.computed_OBCT_temperature4_PRT4_based(1, :)   		= comp_obct_temp((2781-offset)/4+1, :)*1e-3;
data.computed_OBCT_temperature5_PRT5_based(1, :)   		= comp_obct_temp((2785-offset)/4+1, :)*1e-3;


% Discrete telemetry
% equivalent to digital B and analog housekeeping telemetry in other instruments
offset = 2835;
tel_part1 = double(get_vector_from_bytearray(offset, 2840, 'uint8'))';
tel_part1 = reshape(tel_part1, (2840-offset+1), nlines);
data.MainBus_SelectStatus(1, :)  					= tel_part1((2835-offset)+1, :);
data.MHS_survival_heater(1, :)  					= tel_part1((2836-offset)+1, :);
data.RF_conv_protect_disable(1, :)  				= tel_part1((2837-offset)+1, :);
data.MHS_powerA(1, :)  								= tel_part1((2838-offset)+1, :);
data.MHS_powerB(1, :)  								= tel_part1((2839-offset)+1, :);
data.Main_conv_protect_disable(1, :)  				= tel_part1((2840-offset)+1, :);

%Survival Temperatures and Transmitter Telemetry
offset = 2841;
surv_temp_trans_tel = double(get_vector_from_bytearray(offset, 2864, 'uint16'))';
surv_temp_trans_tel = reshape(surv_temp_trans_tel, (2864-offset+1)/2, nlines);
data.receiver_temperature(1, :)  			= surv_temp_trans_tel((2841-offset)/2+1, :);
data.electr_equip_temperature(1, :)  		= surv_temp_trans_tel((2843-offset)/2+1, :);
data.scan_mech_temperature(1, :)  			= surv_temp_trans_tel((2845-offset)/2+1, :);
data.STX_1_status(1, :)  					= surv_temp_trans_tel((2847-offset)/2+1, :);
data.STX_2_status(1, :)  					= surv_temp_trans_tel((2849-offset)/2+1, :);
data.STX_3_status(1, :)  					= surv_temp_trans_tel((2851-offset)/2+1, :);
data.STX_4_status(1, :)  					= surv_temp_trans_tel((2853-offset)/2+1, :);
data.STX_1_power(1, :)  					= surv_temp_trans_tel((2855-offset)/2+1, :);
data.STX_2_power(1, :)  					= surv_temp_trans_tel((2857-offset)/2+1, :);
data.STX_3_power(1, :)  					= surv_temp_trans_tel((2859-offset)/2+1, :);
data.SARR_A_power(1, :)  					= surv_temp_trans_tel((2861-offset)/2+1, :);
data.SARR_B_power(1, :)  					= surv_temp_trans_tel((2863-offset)/2+1, :);


%Discrete Telemetry update Flags
discrete_telem_update_flags = dec2bin(get_vector_from_bytearray(2865, 2868, 'uint32'), 32);
discrete_telem_update_flags = discrete_telem_update_flags - '0';
data.updateflag_SARR_B_power(1, :) 					= discrete_telem_update_flags(:, 14);
data.updateflag_SARR_A_power(1, :)				 	= discrete_telem_update_flags(:, 15);
data.updateflag_STX_3_power(1, :) 					= discrete_telem_update_flags(:, 16);
data.updateflag_STX_2_power(1, :) 					= discrete_telem_update_flags(:, 17);
data.updateflag_STX_1_power(1, :) 					= discrete_telem_update_flags(:, 18);
data.updateflag_STX_4_status(1, :)				 	= discrete_telem_update_flags(:, 19);
data.updateflag_STX_3_status(1, :) 					= discrete_telem_update_flags(:, 20);
data.updateflag_STX_2_status(1, :)				 	= discrete_telem_update_flags(:, 21);
data.updateflag_STX_1_status(1, :) 					= discrete_telem_update_flags(:, 23);
data.updateflag_scan_mech_temp(1, :) 				= discrete_telem_update_flags(:, 24);
data.updateflag_electr_equip_temp(1, :) 			= discrete_telem_update_flags(:, 25);
data.updateflag_receiver_temp(1, :) 				= discrete_telem_update_flags(:, 26);
data.updateflag_main_conv_protect_disable(1, :) 	= discrete_telem_update_flags(:, 27);
data.updateflag_MHS_power_B(1, :) 					= discrete_telem_update_flags(:, 28);
data.updateflag_MHS_power_A(1, :) 					= discrete_telem_update_flags(:, 29);
data.updateflag_RF_conv_protect_disable(1, :) 		= discrete_telem_update_flags(:, 30);
data.updateflag_MHS_survival_heater(1, :) 			= discrete_telem_update_flags(:, 31);
data.updateflag_Main_bus_select_status(1, :) 		= discrete_telem_update_flags(:, 32);


% why this end?
end


function logical_array = create_selection(startbyte, endbyte, startline, nlines, rlen)
    logical_array = false(1, rlen * (startline - 1));
    initial_array = false(1, rlen);
    initial_array(startbyte:endbyte) = true;
    logical_array = [logical_array, repmat(initial_array, 1, nlines)];
end
