% READ_AMSUB_HEADER   Read ALL header entries of AMSUB data file.
%
% The function extracts header information of an AMSUB 
% data file.
%
% FORMAT   hdr = read_AMSUB_header( header );
%
% IN   header   Name of an AMSUB data file.


function hdr = read_AMSUB_header( header )
% Extracting header fields.
% Index numbers correspond to start/end octet from the KLM User Guide.
% http://www1.ncdc.noaa.gov/pub/data/satellite/publications/podguides/N-15%20thru%20N-19/pdf/0.0%20NOAA%20KLM%20Users%20Guide.pdf

hdr.dataset_creation_site_ID                                                = char(header(1:3)');
hdr.level1b_format_version_number                                           = char(header(5:6)');
hdr.level1b_format_version_year                                             = extract_uint16(header, 7, 8);
hdr.level1b_format_version_day_of_year                                      = extract_uint16(header, 9, 10);
hdr.dataset_header_records_count                                            = extract_uint16(header, 15, 16);
hdr.dataset_name                                                            = char(header(23:64)');
hdr.processing_block_identification                                         = char(header(65:72)');
hdr.spacecraft_identification_code                                          = extract_uint16(header, 73, 74);
hdr.instrument_ID                                                           = extract_uint16(header, 75, 76);
hdr.data_type_code                                                          = extract_uint16(header, 77, 78);
hdr.TIP_source_code                                                         = extract_uint16(header, 79, 80);
hdr.dataset_start_day_count                                                 = extract_uint32(header, 81, 84);
hdr.dataset_start_year                                                      = extract_uint16(header, 85, 86);
hdr.dataset_start_day_of_year                                               = extract_uint16(header, 87, 88);
hdr.dataset_start_time_UTC                                                  = extract_uint32(header, 89, 92);
hdr.dataset_end_day_count                                                   = extract_uint32(header, 93, 96);
hdr.dataset_end_year                                                        = extract_uint16(header, 97, 98);
hdr.dataset_end_day_of_year                                                 = extract_uint16(header, 99, 100);
hdr.dataset_end_time_UTC                                                    = extract_uint32(header, 101, 104);
hdr.last_CPIDS_update_year                                                  = extract_uint16(header, 105, 106);
hdr.last_CPIDS_update_day_of_year                                           = extract_uint16(header, 107, 108);
%hdr.scan_start_firstFOVcenter_time_offset                                   = extract_int16(header, 109, 110); %does not exist for AMSUB

instrument_status                                                           = dec2bin(extract_uint32(header, 121, 124),32);
%hdr.instrument_status_notdefined                                           = bin2dec(instrument_status(1:3));
hdr.instrument_status_processor_check_flag                                  = str2double(instrument_status(4));
hdr.instrument_status_scan_control_status                                   = str2double(instrument_status(5));
hdr.instrument_status_pixel_data_invalid_flag                               = str2double(instrument_status(6));
hdr.instrument_status_scan_synchronization                                  = str2double(instrument_status(7));
hdr.instrument_status_mode_transition_flag		                    = str2double(instrument_status(8));
hdr.instrument_status_module_ID_msb		                            = str2double(instrument_status(9));
hdr.instrument_status_module_ID				                    = str2double(instrument_status(10:15));
hdr.instrument_status_module_ID_lsb	                                    = str2double(instrument_status(16));
hdr.instrument_status_RAM_check_flag			                    = str2double(instrument_status(17));
hdr.instrument_status_ROM_check_flag	                                    = str2double(instrument_status(18));
hdr.instrument_status_memory_checks_status                                  = str2double(instrument_status(19));
hdr.instrument_status_space_view_select_lsb	                            = str2double(instrument_status(20));
hdr.instrument_status_space_view_select_msb             	            = str2double(instrument_status(21));
hdr.instrument_status_ch18_19_20_on_off			                    = str2double(instrument_status(22));
hdr.instrument_status_ch17_on_off		                            = str2double(instrument_status(23));
hdr.instrument_status_ch16_on_off                                           = str2double(instrument_status(24));
hdr.instrument_status_stepped_mode			                    = str2double(instrument_status(25));
hdr.instrument_status_investigation_mode                                    = str2double(instrument_status(26));
hdr.instrument_status_parked_in_space_view_mode	                            = str2double(instrument_status(27));
hdr.instrument_status_parked_in_nadir_view_mode                             = str2double(instrument_status(28));
hdr.instrument_status_parked_in_target_view_mode                            = str2double(instrument_status(29));
hdr.instrument_status_scan_normal_mode                                      = str2double(instrument_status(30));
hdr.instrument_status_survival_heater_on_off                                = str2double(instrument_status(31));
hdr.instrument_status_power_on_off                                          = str2double(instrument_status(32));


hdr.status_change_record_number                                             = extract_uint16(header, 127, 128);
hdr.second_instrument_status                                                = extract_uint32(header, 129, 132);
hdr.data_records_count                                                      = extract_uint16(header, 133, 134);
hdr.calibrated_earth_located_scan_lines_count                               = extract_uint16(header, 135, 136);
hdr.nlines                                                                  = hdr.calibrated_earth_located_scan_lines_count;
hdr.missing_scan_lines_count                                                = extract_uint16(header, 137, 138);
hdr.data_gaps_count                                                         = extract_uint16(header, 139, 140);
%hdr.scans_containing_lunar_contaminated_space_views_count                   = extract_int16(header, 141, 142);
hdr.data_frames_without_frame_synch_word_errors_count                       = extract_uint16(header, 141, 142);
hdr.PACS_detected_TIP_parity_errors_count                                   = extract_uint16(header, 143, 144);
hdr.input_data_auxiliary_sync_errors_sum                                    = extract_uint16(header, 145, 146);
hdr.time_sequence_error                                                     = extract_uint16(header, 147, 148);

time_sequence_error_code                                                    = dec2bin(extract_uint16(header, 149, 150),16);
hdr.time_sequence_error_code_bad_time_field_but_inferable                   = str2double(time_sequence_error_code(9));
hdr.time_sequence_error_code_bad_time_field                                 = str2double(time_sequence_error_code(10));
hdr.time_sequence_error_code_inconsistent_with_previous_times               = str2double(time_sequence_error_code(11));
hdr.time_sequence_error_code_repeated_scan_times                            = str2double(time_sequence_error_code(12));

hdr.SOCC_clock_update_indicator                                             = extract_uint16(header, 151, 152);
hdr.earth_location_error_indicator                                          = extract_uint16(header, 153, 154);

earth_location_error_code                                                   = dec2bin(extract_uint16(header, 155, 156),16);
hdr.earth_location_error_code_not_earth_located_bad_time                    = str2double(earth_location_error_code(9));
hdr.earth_location_error_code_questionable_time_code                        = str2double(earth_location_error_code(10));
hdr.earth_location_error_code_reasonableness_check_margin_agreement         = str2double(earth_location_error_code(11));
hdr.earth_location_error_code_reasonableness_check_fail                     = str2double(earth_location_error_code(12));
hdr.earth_location_error_code_antenna_position_check                        = str2double(earth_location_error_code(13));

PACS_status                                                                 = dec2bin(extract_uint16(header, 157, 158),16);
hdr.PACS_status_pseudonoise                                                 = str2double(PACS_status(14));
hdr.PACS_status_tape_direction                                              = str2double(PACS_status(15));
hdr.PACS_status_data_mode                                                   = str2double(PACS_status(16));

hdr.PACS_data_source                                                        = extract_uint16(header, 159, 160);
hdr.instrument_temperature_sensor_ID                                        = extract_int16(header, 193, 194);
hdr.reference_temperature_MixCh18_20_min                                    = double(extract_int16(header, 197, 198))*1e-2;
hdr.reference_temperature_MixCh18_20_nominal                                = double(extract_int16(header, 199, 200))*1e-2;
hdr.reference_temperature_MixCh18_20_max                                    = double(extract_int16(header, 201, 202))*1e-2;
hdr.reference_temperature_MixCh16_min                                       = double(extract_int16(header, 203, 204))*1e-2;
hdr.reference_temperature_MixCh16_nominal                                   = double(extract_int16(header, 205, 206))*1e-2;
hdr.reference_temperature_MixCh16_max                                       = double(extract_int16(header, 207, 208))*1e-2;

hdr.Ch_16_warm_target_fixed_bias_correction_min_temp   	                    = double(extract_int16(header, 209, 210))*1e-3;
hdr.Ch_16_warm_target_fixed_bias_correction_nom_temp      	            = double(extract_int16(header, 211, 212))*1e-3;
hdr.Ch_16_warm_target_fixed_bias_correction_max_temp           	            = double(extract_int16(header, 213, 214))*1e-3;
hdr.Ch_16_cold_space_fixed_bias_correction                                  = double(extract_int16(header, 215, 216))*1e-3;
hdr.Ch_17_warm_target_fixed_bias_correction_min_temp                        = double(extract_int16(header, 217, 218))*1e-3;
hdr.Ch_17_warm_target_fixed_bias_correction_nom_temp                        = double(extract_int16(header, 219, 220))*1e-3;
hdr.Ch_17_warm_target_fixed_bias_correction_max_temp                        = double(extract_int16(header, 221, 222))*1e-3;
hdr.Ch_17_cold_space_fixed_bias_correction	                            = double(extract_int16(header, 223, 224))*1e-3;
hdr.Ch_18_warm_target_fixed_bias_correction_min_temp   	                    = double(extract_int16(header, 225, 226))*1e-3;
hdr.Ch_18_warm_target_fixed_bias_correction_nom_temp      	            = double(extract_int16(header, 227, 228))*1e-3;
hdr.Ch_18_warm_target_fixed_bias_correction_max_temp           	            = double(extract_int16(header, 229, 230))*1e-3;
hdr.Ch_18_cold_space_fixed_bias_correction                                  = double(extract_int16(header, 231, 232))*1e-3;
hdr.Ch_19_warm_target_fixed_bias_correction_min_temp                        = double(extract_int16(header, 233, 234))*1e-3;
hdr.Ch_19_warm_target_fixed_bias_correction_nom_temp                        = double(extract_int16(header, 235, 236))*1e-3;
hdr.Ch_19_warm_target_fixed_bias_correction_max_temp                        = double(extract_int16(header, 237, 238))*1e-3;
hdr.Ch_19_cold_space_fixed_bias_correction	                            = double(extract_int16(header, 239, 240))*1e-3;
hdr.Ch_20_warm_target_fixed_bias_correction_min_temp                        = double(extract_int16(header, 241, 242))*1e-3;
hdr.Ch_20_warm_target_fixed_bias_correction_nom_temp                        = double(extract_int16(header, 243, 244))*1e-3;
hdr.Ch_20_warm_target_fixed_bias_correction_max_temp                        = double(extract_int16(header, 245, 246))*1e-3;
hdr.Ch_20_cold_space_fixed_bias_correction	                            = double(extract_int16(header, 247, 248))*1e-3;
hdr.Ch_16_nonlinearity_coeff_min_temperature                         	    = double(extract_int32(header, 249, 252))*1e-3; %was *1e-8 for MHS
hdr.Ch_16_nonlinearity_coeff_nominal_temperature                            = double(extract_int32(header, 253, 256))*1e-3;
hdr.Ch_16_nonlinearity_coeff_max_temperature                                = double(extract_int32(header, 257, 260))*1e-3;
hdr.Ch_17_nonlinearity_coeff_min_temperature                                = double(extract_int32(header, 261, 264))*1e-3;
hdr.Ch_17_nonlinearity_coeff_nominal_temperature                            = double(extract_int32(header, 265, 268))*1e-3;
hdr.Ch_17_nonlinearity_coeff_max_temperature                                = double(extract_int32(header, 269, 272))*1e-3;
hdr.Ch_18_nonlinearity_coeff_min_temperature                                = double(extract_int32(header, 273, 276))*1e-3;
hdr.Ch_18_nonlinearity_coeff_nominal_temperature                            = double(extract_int32(header, 277, 280))*1e-3;
hdr.Ch_18_nonlinearity_coeff_max_temperature                                = double(extract_int32(header, 281, 284))*1e-3;
hdr.Ch_19_nonlinearity_coeff_min_temperature                          	    = double(extract_int32(header, 285, 288))*1e-3;
hdr.Ch_19_nonlinearity_coeff_nominal_temperature                      	    = double(extract_int32(header, 289, 292))*1e-3;
hdr.Ch_19_nonlinearity_coeff_max_temperature                         	    = double(extract_int32(header, 293, 296))*1e-3;
hdr.Ch_20_nonlinearity_coeff_min_temperature                         	    = double(extract_int32(header, 297, 300))*1e-3;
hdr.Ch_20_nonlinearity_coeff_nominal_temperature                     	    = double(extract_int32(header, 301, 304))*1e-3;
hdr.Ch_20_nonlinearity_coeff_max_temperature                        	    = double(extract_int32(header, 305, 308))*1e-3;

hdr.temperature_radiance_Ch_16_central_wavenumber                           = double(extract_int32(header, 325, 328))*1e-6;
hdr.temperature_radiance_Ch_16_constant1                                    = double(extract_int32(header, 329, 332))*1e-6;
hdr.temperature_radiance_Ch_16_constant2                                    = double(extract_int32(header, 333, 336))*1e-6;
hdr.temperature_radiance_Ch_17_central_wavenumber                           = double(extract_int32(header, 337, 340))*1e-6;
hdr.temperature_radiance_Ch_17_constant1                                    = double(extract_int32(header, 341, 344))*1e-6;
hdr.temperature_radiance_Ch_17_constant2                                    = double(extract_int32(header, 345, 348))*1e-6;
hdr.temperature_radiance_Ch_18_central_wavenumber                           = double(extract_int32(header, 349, 352))*1e-6;
hdr.temperature_radiance_Ch_18_constant1                                    = double(extract_int32(header, 353, 356))*1e-6;
hdr.temperature_radiance_Ch_18_constant2                                    = double(extract_int32(header, 357, 360))*1e-6;
hdr.temperature_radiance_Ch_19_central_wavenumber                           = double(extract_int32(header, 361, 364))*1e-6;
hdr.temperature_radiance_Ch_19_constant1                                    = double(extract_int32(header, 365, 368))*1e-6;
hdr.temperature_radiance_Ch_19_constant2                                    = double(extract_int32(header, 369, 372))*1e-6;
hdr.temperature_radiance_Ch_20_central_wavenumber                           = double(extract_int32(header, 373, 376))*1e-6;
hdr.temperature_radiance_Ch_20_constant1                                    = double(extract_int32(header, 377, 380))*1e-6;
hdr.temperature_radiance_Ch_20_constant2                                    = double(extract_int32(header, 381, 384))*1e-6;

hdr.reference_ellipsoid_model_ID                                            = char(header(401:408)');
hdr.nadir_earth_location_tolerance                                          = extract_uint16(header, 409, 410)*1e-1;

earth_location                                                              = dec2bin(extract_uint16(header, 411, 412),16);
hdr.earth_location_reasonableness_test                                      = str2double(earth_location(15));
hdr.earth_location_attitude_error_correction                      	    = str2double(earth_location(16));

hdr.constant_roll_attitude_error                                            = double(extract_int16(header, 415, 416))*1e-3;
hdr.constant_pitch_attitude_error                                           = double(extract_int16(header, 417, 418))*1e-3;
hdr.constant_yaw_attitude_error                                             = double(extract_int16(header, 419, 420))*1e-3;
hdr.orbit_vector_epoch_year                                                 = extract_int16(header, 421, 422);
hdr.orbit_vector_day_of_epoch_year                                          = extract_int16(header, 423, 424);
hdr.orbit_vector_epoch_UTC_time                                             = extract_int32(header, 425, 428);
hdr.semi_major_axis_at_epoch_time                                           = double(extract_int32(header, 429, 432))*1e-5;
hdr.eccentricity_at_orbit_vector_epoch_time                                 = double(extract_int32(header, 433, 436))*1e-8;
hdr.inclination_at_orbit_vector_epoch_time                                  = double(extract_int32(header, 437, 440))*1e-5;
hdr.argument_of_perigee_at_orbit_vector_epoch_time                          = double(extract_int32(header, 441, 444))*1e-5;
hdr.right_ascension_of_ascending_node_at_orbit_vector_epoch_time            = double(extract_int32(header, 445, 448))*1e-5;
hdr.mean_anomaly_at_orbit_vector_epoch_time                                 = double(extract_int32(header, 449, 452))*1e-5;
hdr.position_vector_X_at_orbit_vector_epoch_time                            = double(extract_int32(header, 453, 456))*1e-5;
hdr.position_vector_Y_at_orbit_vector_epoch_time                            = double(extract_int32(header, 457, 460))*1e-5;
hdr.position_vector_Z_at_orbit_vector_epoch_time                            = double(extract_int32(header, 461, 464))*1e-5;
hdr.velocity_vector_Xdot_at_orbit_vector_epoch_time                         = double(extract_int32(header, 465, 468))*1e-8;
hdr.velocity_vector_Ydot_at_orbit_vector_epoch_time                         = double(extract_int32(header, 469, 472))*1e-8;
hdr.velocity_vector_Zdot_at_orbit_vector_epoch_time                         = double(extract_int32(header, 473, 476))*1e-8;
hdr.earth_sun_distance_ratio_at_orbit_vector_epoch_time                     = double(extract_uint32(header, 477, 480))*1e-6;

hdr.mixer_ch16_temp_coeff0					            = double(extract_int16(header, 497, 498))*1e-2;
hdr.mixer_ch16_temp_coeff1         					    = double(extract_int16(header, 499, 500))*1e-7;
hdr.mixer_ch16_temp_coeff2         					    = double(extract_int16(header, 501, 502))*1e-12;
hdr.mixer_ch16_temp_coeff3 					            = double(extract_int16(header, 503, 504))*1e-18;
hdr.mixer_ch17_temp_coeff0        					    = double(extract_int16(header, 505, 506))*1e-2;
hdr.mixer_ch17_temp_coeff1                                   	            = double(extract_int16(header, 507, 508))*1e-7;
hdr.mixer_ch17_temp_coeff2                                        	    = double(extract_int16(header, 509, 510))*1e-12;
hdr.mixer_ch17_temp_coeff3                                          	    = double(extract_int16(header, 511, 512))*1e-18;
hdr.mixer_ch18_19_20_temp_coeff0                                            = double(extract_int16(header, 513, 514))*1e-2;
hdr.mixer_ch18_19_20_temp_coeff1                                            = double(extract_int16(header, 515, 516))*1e-7;
hdr.mixer_ch18_19_20_temp_coeff2                                            = double(extract_int16(header, 517, 518))*1e-12;
hdr.mixer_ch18_19_20_temp_coeff3                                            = double(extract_int16(header, 519, 520))*1e-18;
hdr.FET_Amplif_16_temp_coeff0                                               = double(extract_int16(header, 521, 522))*1e-2;
hdr.FET_Amplif_16_temp_coeff1                                               = double(extract_int16(header, 523, 524))*1e-7;
hdr.FET_Amplif_16_temp_coeff2                                               = double(extract_int16(header, 525, 526))*1e-12;
hdr.FET_Amplif_16_temp_coeff3                                               = double(extract_int16(header, 527, 528))*1e-18;
hdr.FET_Amplif_17_temp_coeff0                                               = double(extract_int16(header, 529, 530))*1e-2;
hdr.FET_Amplif_17_temp_coeff1                                               = double(extract_int16(header, 531, 532))*1e-7;
hdr.FET_Amplif_17_temp_coeff2                                               = double(extract_int16(header, 533, 534))*1e-12;
hdr.FET_Amplif_17_temp_coeff3                                               = double(extract_int16(header, 535, 536))*1e-18;
hdr.FET_Amplif_18_temp_coeff0                                               = double(extract_int16(header, 537, 538))*1e-2;
hdr.FET_Amplif_18_temp_coeff1                                               = double(extract_int16(header, 539, 540))*1e-7;
hdr.FET_Amplif_18_temp_coeff2                                               = double(extract_int16(header, 541, 542))*1e-12;
hdr.FET_Amplif_18_temp_coeff3                                               = double(extract_int16(header, 543, 544))*1e-18;
hdr.FET_Amplif_19_temp_coeff0                                               = double(extract_int16(header, 545, 546))*1e-2;
hdr.FET_Amplif_19_temp_coeff1                                               = double(extract_int16(header, 547, 548))*1e-7;
hdr.FET_Amplif_19_temp_coeff2                                               = double(extract_int16(header, 549, 550))*1e-12;
hdr.FET_Amplif_19_temp_coeff3                                               = double(extract_int16(header, 551, 552))*1e-18;
hdr.FET_Amplif_20_temp_coeff0                                               = double(extract_int16(header, 553, 554))*1e-2;
hdr.FET_Amplif_20_temp_coeff1                                               = double(extract_int16(header, 555, 556))*1e-7;
hdr.FET_Amplif_20_temp_coeff2                                               = double(extract_int16(header, 557, 558))*1e-12;
hdr.FET_Amplif_20_temp_coeff3                                               = double(extract_int16(header, 559, 560))*1e-18;

%4 conversion coeffs for 7 PRTs on IWCT
hdr.caltargettempcoeff(1)                                            	    = double(extract_int16(header, 561, 562))*1e-2;
hdr.caltargettempcoeff(2)                                             	    = double(extract_int16(header, 563, 564))*1e-7;
hdr.caltargettempcoeff(3)                                            	    = double(extract_int16(header, 565, 566))*1e-12;
hdr.caltargettempcoeff(4)                                                   = double(extract_int16(header, 567, 568))*1e-18;
hdr.caltargettempcoeff(5)                                                   = double(extract_int16(header, 569, 570))*1e-2;
hdr.caltargettempcoeff(6)                                                   = double(extract_int16(header, 571, 572))*1e-7;
hdr.caltargettempcoeff(7)                                                   = double(extract_int16(header, 573, 574))*1e-12;
hdr.caltargettempcoeff(8)                                                   = double(extract_int16(header, 575, 576))*1e-18;
hdr.caltargettempcoeff(9)                                                   = double(extract_int16(header, 577, 578))*1e-2;
hdr.caltargettempcoeff(10)                                                  = double(extract_int16(header, 579, 580))*1e-7;
hdr.caltargettempcoeff(11)                                                  = double(extract_int16(header, 581, 582))*1e-12;
hdr.caltargettempcoeff(12)                                                  = double(extract_int16(header, 583, 584))*1e-18;
hdr.caltargettempcoeff(13)                                                  = double(extract_int16(header, 585, 586))*1e-2;
hdr.caltargettempcoeff(14)                                                  = double(extract_int16(header, 587, 588))*1e-7;
hdr.caltargettempcoeff(15)                                                  = double(extract_int16(header, 589, 590))*1e-12;
hdr.caltargettempcoeff(16)                                                  = double(extract_int16(header, 591, 592))*1e-18;
hdr.caltargettempcoeff(17)                                                  = double(extract_int16(header, 593, 594))*1e-2;
hdr.caltargettempcoeff(18)                                                  = double(extract_int16(header, 595, 596))*1e-7;
hdr.caltargettempcoeff(19)                                                  = double(extract_int16(header, 597, 598))*1e-12;
hdr.caltargettempcoeff(20)                                                  = double(extract_int16(header, 599, 600))*1e-18;
hdr.caltargettempcoeff(21)                                                  = double(extract_int16(header, 601, 602))*1e-2;
hdr.caltargettempcoeff(22)                                                  = double(extract_int16(header, 603, 604))*1e-7;
hdr.caltargettempcoeff(23)                                                  = double(extract_int16(header, 605, 606))*1e-12;
hdr.caltargettempcoeff(24)                                                  = double(extract_int16(header, 607, 608))*1e-18;
hdr.caltargettempcoeff(25)                                                  = double(extract_int16(header, 609, 610))*1e-2;
hdr.caltargettempcoeff(26)                                                  = double(extract_int16(header, 611, 612))*1e-7;
hdr.caltargettempcoeff(27)                                                  = double(extract_int16(header, 613, 614))*1e-12;
hdr.caltargettempcoeff(28)                                                  = double(extract_int16(header, 615, 616))*1e-18;

hdr.subreflector_temp_1_coeff0                                              = double(extract_int16(header, 617, 618))*1e-2;
hdr.subreflector_temp_1_coeff1                                              = double(extract_int16(header, 619, 620))*1e-7;
hdr.subreflector_temp_1_coeff2                                              = double(extract_int16(header, 621, 622))*1e-12;
hdr.subreflector_temp_1_coeff3                                              = double(extract_int16(header, 623, 624))*1e-18;

hdr.LO_monitor_current_Ch_16_coeff0                                         = double(extract_int16(header, 625, 626))*1e-3;
hdr.LO_monitor_current_Ch_16_coeff1                                         = double(extract_int16(header, 627, 628))*1e-5;
hdr.LO_monitor_current_Ch_16_coeff2                                         = double(extract_int16(header, 629, 630))*1e-0;
hdr.LO_monitor_current_Ch_16_coeff3                                         = double(extract_int16(header, 631, 632))*1e-0;
hdr.LO_monitor_current_Ch_17_coeff0                                         = double(extract_int16(header, 633, 634))*1e-3;
hdr.LO_monitor_current_Ch_17_coeff1                                         = double(extract_int16(header, 635, 636))*1e-5;
hdr.LO_monitor_current_Ch_17_coeff2                                         = double(extract_int16(header, 637, 638))*1e-0;
hdr.LO_monitor_current_Ch_17_coeff3                                         = double(extract_int16(header, 639, 640))*1e-0;
hdr.LO_monitor_current_Ch_18_19_20_coeff0                                   = double(extract_int16(header, 641, 642))*1e-3;
hdr.LO_monitor_current_Ch_18_19_20_coeff1                                   = double(extract_int16(header, 643, 644))*1e-5;
hdr.LO_monitor_current_Ch_18_19_20_coeff2                                   = double(extract_int16(header, 645, 646))*1e-0;
hdr.LO_monitor_current_Ch_18_19_20_coeff3                                   = double(extract_int16(header, 647, 648))*1e-0;
hdr.LO_Ch_16_temp_coeff0	                                            = double(extract_int16(header, 649, 650))*1e-2;
hdr.LO_Ch_16_temp_coeff1	                                            = double(extract_int16(header, 651, 652))*1e-7;
hdr.LO_Ch_16_temp_coeff2	                                            = double(extract_int16(header, 653, 654))*1e-12;
hdr.LO_Ch_16_temp_coeff3	                                            = double(extract_int16(header, 655, 656))*1e-18;
hdr.LO_Ch_17_temp_coeff0                                                    = double(extract_int16(header, 657, 658))*1e-2;
hdr.LO_Ch_17_temp_coeff1                                                    = double(extract_int16(header, 659, 660))*1e-7;
hdr.LO_Ch_17_temp_coeff2                                                    = double(extract_int16(header, 661, 662))*1e-12;
hdr.LO_Ch_17_temp_coeff3                                                    = double(extract_int16(header, 663, 664))*1e-18;
hdr.LO_Ch_18_19_20_temp_coeff0                                              = double(extract_int16(header, 665, 666))*1e-2;
hdr.LO_Ch_18_19_20_temp_coeff1                                              = double(extract_int16(header, 667, 668))*1e-7;
hdr.LO_Ch_18_19_20_temp_coeff2                                              = double(extract_int16(header, 669, 670))*1e-12;
hdr.LO_Ch_18_19_20_temp_coeff3                                              = double(extract_int16(header, 671, 672))*1e-18;
hdr.PRT_bridge_voltage_coeff0                                               = double(extract_int16(header, 673, 674))*1e-0;
hdr.PRT_bridge_voltage_coeff1                                               = double(extract_int16(header, 675, 676))*1e-5;
hdr.PRT_bridge_voltage_coeff2                                               = double(extract_int16(header, 677, 678))*1e-0;
hdr.PRT_bridge_voltage_coeff3                                               = double(extract_int16(header, 679, 680))*1e-0;
hdr.PRT_board_temp_coeff0                                              	    = double(extract_int16(header, 681, 682))*1e-1;
hdr.PRT_board_temp_coeff1                                              	    = double(extract_int16(header, 683, 684))*1e-6;
hdr.PRT_board_temp_coeff2                                              	    = double(extract_int16(header, 685, 686))*1e-10;
hdr.PRT_board_temp_coeff3                                              	    = double(extract_int16(header, 687, 688))*1e-15;


hdr.plus12V_A_secnd_conv_coeff0                                             = double(extract_int32(header, 705, 708))*1e-6;
hdr.plus12V_A_secnd_conv_coeff1                                             = double(extract_int32(header, 709, 712))*1e-6;
hdr.plus12V_A_secnd_conv_coeff2                                             = double(extract_int32(header, 713, 716))*1e-6;
hdr.plus12V_A_secnd_conv_coeff3                                             = double(extract_int32(header, 717, 720))*1e-6;
hdr.minus12V_A_secnd_conv_coeff0                                            = double(extract_int32(header, 721, 724))*1e-6;
hdr.minus12V_A_secnd_conv_coeff1                                            = double(extract_int32(header, 725, 728))*1e-6;
hdr.minus12V_A_secnd_conv_coeff2                                            = double(extract_int32(header, 729, 732))*1e-6;
hdr.minus12V_A_secnd_conv_coeff3                                            = double(extract_int32(header, 733, 736))*1e-6;
hdr.plus15V_A_secnd_conv_coeff0                                             = double(extract_int32(header, 737, 740))*1e-6;
hdr.plus15V_A_secnd_conv_coeff1                                             = double(extract_int32(header, 741, 744))*1e-6;
hdr.plus15V_A_secnd_conv_coeff2                                             = double(extract_int32(header, 745, 748))*1e-6;
hdr.plus15V_A_secnd_conv_coeff3                                             = double(extract_int32(header, 749, 752))*1e-6;
hdr.minus15V_A_secnd_conv_coeff0                                            = double(extract_int32(header, 753, 756))*1e-6;
hdr.minus15V_A_secnd_conv_coeff1                                            = double(extract_int32(header, 757, 760))*1e-6;
hdr.minus15V_A_secnd_conv_coeff2                                            = double(extract_int32(header, 761, 764))*1e-6;
hdr.minus15V_A_secnd_conv_coeff3                                            = double(extract_int32(header, 765, 768))*1e-6;
hdr.plus8v_A_secnd_conv_coeff0                                              = double(extract_int32(header, 769, 772))*1e-6;
hdr.plus8v_A_secnd_conv_coeff1                                              = double(extract_int32(header, 773, 776))*1e-6;
hdr.plus8v_A_secnd_conv_coeff2                                              = double(extract_int32(header, 777, 780))*1e-6;
hdr.plus8v_A_secnd_conv_coeff3                                              = double(extract_int32(header, 781, 784))*1e-6;
hdr.plus5V_D_secnd_conv_coeff0                                              = double(extract_int32(header, 785, 788))*1e-6;
hdr.plus5V_D_secnd_conv_coeff1                                              = double(extract_int32(header, 789, 792))*1e-6;
hdr.plus5V_D_secnd_conv_coeff2                                              = double(extract_int32(header, 793, 796))*1e-6;
hdr.plus5V_D_secnd_conv_coeff3                                              = double(extract_int32(header, 797, 800))*1e-6;
hdr.plus5V_A_secnd_conv_coeff0                                              = double(extract_int32(header, 801, 804))*1e-6;
hdr.plus5V_A_secnd_conv_coeff1                                              = double(extract_int32(header, 805, 808))*1e-6;
hdr.plus5V_A_secnd_conv_coeff2                                              = double(extract_int32(header, 809, 812))*1e-6;
hdr.plus5V_A_secnd_conv_coeff3                                              = double(extract_int32(header, 813, 816))*1e-6;
hdr.minus5V_A_secnd_conv_coeff0                                             = double(extract_int32(header, 817, 820))*1e-6;
hdr.minus5V_A_secnd_conv_coeff1                                             = double(extract_int32(header, 821, 824))*1e-6;
hdr.minus5V_A_secnd_conv_coeff2                                             = double(extract_int32(header, 825, 828))*1e-6;
hdr.minus5V_A_secnd_conv_coeff3                                             = double(extract_int32(header, 829, 832))*1e-6;
hdr.plus5V_Ref_secnd_conv_coeff0                                            = double(extract_int32(header, 833, 836))*1e-6;
hdr.plus5V_Ref_secnd_conv_coeff1                                            = double(extract_int32(header, 837, 840))*1e-6;
hdr.plus5V_Ref_secnd_conv_coeff2                                            = double(extract_int32(header, 841, 844))*1e-6;
hdr.plus5V_Ref_secnd_conv_coeff3                                            = double(extract_int32(header, 845, 848))*1e-6;
hdr.ICE_temp_conv_coeff0                                                    = double(extract_int32(header, 849, 852))*1e-6;
hdr.ICE_temp_conv_coeff1                                                    = double(extract_int32(header, 853, 856))*1e-6;
hdr.ICE_temp_conv_coeff2                                                    = double(extract_int32(header, 857, 860))*1e-6;
hdr.ICE_temp_conv_coeff3                                                    = double(extract_int32(header, 861, 864))*1e-6;
hdr.MDE_temp_conv_coeff0                                                    = double(extract_int32(header, 865, 868))*1e-6;
hdr.MDE_temp_conv_coeff1                                                    = double(extract_int32(header, 869, 872))*1e-6;
hdr.MDE_temp_conv_coeff2                                                    = double(extract_int32(header, 873, 876))*1e-6;
hdr.MDE_temp_conv_coeff3                                                    = double(extract_int32(header, 877, 880))*1e-6;
hdr.PEU_temp_conv_coeff0                                                    = double(extract_int32(header, 881, 884))*1e-6;
hdr.PEU_temp_conv_coeff1                                                    = double(extract_int32(header, 885, 888))*1e-6;
hdr.PEU_temp_conv_coeff2                                                    = double(extract_int32(header, 889, 892))*1e-6;
hdr.PEU_temp_conv_coeff3                                                    = double(extract_int32(header, 893, 896))*1e-6;
hdr.PSU_temp_conv_coeff0                                                    = double(extract_int32(header, 897, 900))*1e-6;
hdr.PSU_temp_conv_coeff1                                                    = double(extract_int32(header, 901, 904))*1e-6;
hdr.PSU_temp_conv_coeff2                                                    = double(extract_int32(header, 905, 908))*1e-6;
hdr.PSU_temp_conv_coeff3                                                    = double(extract_int32(header, 909, 912))*1e-6;
hdr.scanmotor_temp_conv_coeff0                                              = double(extract_int32(header, 913, 916))*1e-6;
hdr.scanmotor_temp_conv_coeff1                                              = double(extract_int32(header, 917, 920))*1e-6;
hdr.scanmotor_temp_conv_coeff2                                              = double(extract_int32(header, 921, 924))*1e-6;
hdr.scanmotor_temp_conv_coeff3                                              = double(extract_int32(header, 925, 928))*1e-6;
hdr.scanmotor_current_conv_coeff0                                           = double(extract_int32(header, 929, 932))*1e-6;
hdr.scanmotor_current_conv_coeff1                                           = double(extract_int32(header, 933, 936))*1e-6;
hdr.scanmotor_current_conv_coeff2                                           = double(extract_int32(header, 937, 940))*1e-6;
hdr.scanmotor_current_conv_coeff3                                           = double(extract_int32(header, 941, 944))*1e-6;
hdr.Ch16_LO_temp_conv_coeff0                                                = double(extract_int32(header, 945, 948))*1e-6;
hdr.Ch16_LO_temp_conv_coeff1                                                = double(extract_int32(header, 949, 952))*1e-6;
hdr.Ch16_LO_temp_conv_coeff2                                                = double(extract_int32(header, 953, 956))*1e-6;
hdr.Ch16_LO_temp_conv_coeff3                                                = double(extract_int32(header, 957, 960))*1e-6;
hdr.Ch17_LO_temp_conv_coeff0                                                = double(extract_int32(header, 961, 964))*1e-6;
hdr.Ch17_LO_temp_conv_coeff1                                                = double(extract_int32(header, 965, 968))*1e-6;
hdr.Ch17_LO_temp_conv_coeff2                                                = double(extract_int32(header, 969, 972))*1e-6;
hdr.Ch17_LO_temp_conv_coeff3                                                = double(extract_int32(header, 973, 976))*1e-6;
hdr.Ch18_19_20_LO_temp_conv_coeff0                                          = double(extract_int32(header, 977, 980))*1e-6;
hdr.Ch18_19_20_LO_temp_conv_coeff1                                          = double(extract_int32(header, 981, 984))*1e-6;
hdr.Ch18_19_20_LO_temp_conv_coeff2                                          = double(extract_int32(header, 985, 988))*1e-6;
hdr.Ch18_19_20_LO_temp_conv_coeff3                                          = double(extract_int32(header, 989, 992))*1e-6;



% bias correction values are only available for every fifth field of view,
% the values for the remaining field of views are set to NaN. 
hdr.bias_correction_values_Ch_16_STX1                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_17_STX1                                       = NaN(1,90);
hdr.bias_correction_values_Ch_18_STX1                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_19_STX1                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_20_STX1                                       = NaN(1,90);
hdr.bias_correction_values_Ch_16_STX2                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_17_STX2                                       = NaN(1,90);
hdr.bias_correction_values_Ch_18_STX2                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_19_STX2                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_20_STX2                                       = NaN(1,90);
hdr.bias_correction_values_Ch_16_STX3                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_17_STX3                                       = NaN(1,90);
hdr.bias_correction_values_Ch_18_STX3                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_19_STX3                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_20_STX3                                       = NaN(1,90);
hdr.bias_correction_values_Ch_16_SARR                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_17_SARR                                       = NaN(1,90);
hdr.bias_correction_values_Ch_18_SARR                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_19_SARR                                       = NaN(1,90);
hdr.bias_coorection_values_Ch_20_SARR                                       = NaN(1,90);

c = 1;
for fov=[1,5:5:90]
    hdr.bias_correction_values_Ch_16_STX1(fov)                              = extract_int16(header, 1001+(c-1)*10, 1002+(c-1)*10);
    hdr.bias_coorection_values_Ch_17_STX1(fov)                              = extract_int16(header, 1003+(c-1)*10, 1004+(c-1)*10);
    hdr.bias_correction_values_Ch_18_STX1(fov)                              = extract_int16(header, 1005+(c-1)*10, 1006+(c-1)*10);
    hdr.bias_coorection_values_Ch_19_STX1(fov)                              = extract_int16(header, 1007+(c-1)*10, 1008+(c-1)*10);
    hdr.bias_coorection_values_Ch_20_STX1(fov)                              = extract_int16(header, 1009+(c-1)*10, 1010+(c-1)*10);
    hdr.bias_correction_values_Ch_16_STX2(fov)                              = extract_int16(header, 1211+(c-1)*10, 1212+(c-1)*10);
    hdr.bias_coorection_values_Ch_17_STX2(fov)                              = extract_int16(header, 1213+(c-1)*10, 1214+(c-1)*10);
    hdr.bias_correction_values_Ch_18_STX2(fov)                              = extract_int16(header, 1215+(c-1)*10, 1216+(c-1)*10);
    hdr.bias_coorection_values_Ch_19_STX2(fov)                              = extract_int16(header, 1217+(c-1)*10, 1218+(c-1)*10);
    hdr.bias_coorection_values_Ch_20_STX2(fov)                              = extract_int16(header, 1219+(c-1)*10, 1220+(c-1)*10);
    hdr.bias_correction_values_Ch_16_STX3(fov)                              = extract_int16(header, 1421+(c-1)*10, 1422+(c-1)*10);
    hdr.bias_coorection_values_Ch_17_STX3(fov)                              = extract_int16(header, 1423+(c-1)*10, 1424+(c-1)*10);
    hdr.bias_correction_values_Ch_18_STX3(fov)                              = extract_int16(header, 1425+(c-1)*10, 1426+(c-1)*10);
    hdr.bias_coorection_values_Ch_19_STX3(fov)                              = extract_int16(header, 1427+(c-1)*10, 1428+(c-1)*10);
    hdr.bias_coorection_values_Ch_20_STX3(fov)                              = extract_int16(header, 1429+(c-1)*10, 1430+(c-1)*10);
    hdr.bias_correction_values_Ch_16_SARR(fov)                              = extract_int16(header, 1631+(c-1)*10, 1632+(c-1)*10);
    hdr.bias_coorection_values_Ch_17_SARR(fov)                              = extract_int16(header, 1633+(c-1)*10, 1634+(c-1)*10);
    hdr.bias_correction_values_Ch_18_SARR(fov)                              = extract_int16(header, 1635+(c-1)*10, 1636+(c-1)*10);
    hdr.bias_coorection_values_Ch_19_SARR(fov)                              = extract_int16(header, 1637+(c-1)*10, 1638+(c-1)*10);
    hdr.bias_coorection_values_Ch_20_SARR(fov)                              = extract_int16(header, 1639+(c-1)*10, 1640+(c-1)*10);
    c = c+1;
end

hdr.bias_correction_values_Ch_16_space_view_STX1                            = extract_int16(header, 1191, 1192);
hdr.bias_correction_values_Ch_17_space_view_STX1                            = extract_int16(header, 1193, 1194);
hdr.bias_correction_values_Ch_18_space_view_STX1                            = extract_int16(header, 1195, 1196);
hdr.bias_correction_values_Ch_19_space_view_STX1                            = extract_int16(header, 1197, 1198);
hdr.bias_correction_values_Ch_20_space_view_STX1                            = extract_int16(header, 1199, 1200);
hdr.bias_correction_values_Ch_16_OBCT_view_STX1                             = extract_int16(header, 1201, 1202);
hdr.bias_correction_values_Ch_17_OBCT_view_STX1                             = extract_int16(header, 1203, 1204);
hdr.bias_correction_values_Ch_18_OBCT_view_STX1                             = extract_int16(header, 1205, 1206);
hdr.bias_correction_values_Ch_19_OBCT_view_STX1                             = extract_int16(header, 1207, 1208);
hdr.bias_correction_values_Ch_20_OBCT_view_STX1                             = extract_int16(header, 1209, 1210);
hdr.bias_correction_values_Ch_16_space_view_STX2                            = extract_int16(header, 1401, 1402);
hdr.bias_correction_values_Ch_17_space_view_STX2                            = extract_int16(header, 1403, 1404);
hdr.bias_correction_values_Ch_18_space_view_STX2                            = extract_int16(header, 1405, 1406);
hdr.bias_correction_values_Ch_19_space_view_STX2                            = extract_int16(header, 1407, 1408);
hdr.bias_correction_values_Ch_20_space_view_STX2                            = extract_int16(header, 1409, 1410);
hdr.bias_correction_values_Ch_16_OBCT_view_STX2                             = extract_int16(header, 1411, 1412);
hdr.bias_correction_values_Ch_17_OBCT_view_STX2                             = extract_int16(header, 1413, 1414);
hdr.bias_correction_values_Ch_18_OBCT_view_STX2                             = extract_int16(header, 1415, 1416);
hdr.bias_correction_values_Ch_19_OBCT_view_STX2                             = extract_int16(header, 1417, 1418);
hdr.bias_correction_values_Ch_20_OBCT_view_STX2                             = extract_int16(header, 1419, 1420);
hdr.bias_correction_values_Ch_16_space_view_STX3                            = extract_int16(header, 1611, 1612);
hdr.bias_correction_values_Ch_17_space_view_STX3                            = extract_int16(header, 1613, 1614);
hdr.bias_correction_values_Ch_18_space_view_STX3                            = extract_int16(header, 1615, 1616);
hdr.bias_correction_values_Ch_19_space_view_STX3                            = extract_int16(header, 1617, 1618);
hdr.bias_correction_values_Ch_20_space_view_STX3                            = extract_int16(header, 1619, 1620);
hdr.bias_correction_values_Ch_16_OBCT_view_STX3                             = extract_int16(header, 1621, 1622);
hdr.bias_correction_values_Ch_17_OBCT_view_STX3                             = extract_int16(header, 1623, 1624);
hdr.bias_correction_values_Ch_18_OBCT_view_STX3                             = extract_int16(header, 1625, 1526);
hdr.bias_correction_values_Ch_19_OBCT_view_STX3                             = extract_int16(header, 1627, 1628);
hdr.bias_correction_values_Ch_20_OBCT_view_STX3                             = extract_int16(header, 1629, 1630);
hdr.bias_correction_values_Ch_16_space_view_SARR                            = extract_int16(header, 1821, 1822);
hdr.bias_correction_values_Ch_17_space_view_SARR                            = extract_int16(header, 1823, 1824);
hdr.bias_correction_values_Ch_18_space_view_SARR                            = extract_int16(header, 1825, 1826);
hdr.bias_correction_values_Ch_19_space_view_SARR                            = extract_int16(header, 1827, 1828);
hdr.bias_correction_values_Ch_20_space_view_SARR                            = extract_int16(header, 1829, 1830);
hdr.bias_correction_values_Ch_16_OBCT_view_SARR                             = extract_int16(header, 1831, 1832);
hdr.bias_correction_values_Ch_17_OBCT_view_SARR                             = extract_int16(header, 1833, 1834);
hdr.bias_correction_values_Ch_18_OBCT_view_SARR                             = extract_int16(header, 1835, 1836);
hdr.bias_correction_values_Ch_19_OBCT_view_SARR                             = extract_int16(header, 1837, 1838);
hdr.bias_correction_values_Ch_20_OBCT_view_SARR                             = extract_int16(header, 1839, 1840);
hdr.transmitter_reference_power_STX1                                        = extract_int16(header, 1849, 1850)*1e-1; %scaling really correct? User guide says so
hdr.transmitter_reference_power_STX2                                        = extract_int16(header, 1851, 1852)*1e-1;
hdr.transmitter_reference_power_STX3                                        = extract_int16(header, 1853, 1854)*1e-1;
hdr.transmitter_reference_power_SARR                                        = extract_int16(header, 1855, 1856)*1e-1;
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