

%
 % Copyright (C) 2019-01-04 Imke Hans
 % This code was developed for the EC project �Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)�. 
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

% write_easyFCDR_orbitfile_AMSUB
 
 
%% info
% ONLY USE this script via calling function FCDR_generator.m
% DO NOT use this script alone. It needs the output from preceeding
% functions/ scripts such as setup_XXX, 
% measurement_equation, uncertainty_propagation

% This script writes the brigthness temperature, and ancillary variables
% to a nc-file. Moreover, it also writes the three uncertainties components
% of the brightness temperature.

% YOU HAVE TO specify the output path for the file in "filenamenew".



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% 
%%%%%%%%                      %%%%%%%%%%%%%%%
%%%%%%%% CREATE NEW FCDR FILE %%%%%%%%%%%%%%%

disp('write new file')
%format start- and endtime 
ymdhms_start=[num2str( vectorstartdate(1), '%02i'),num2str( vectorstartdate(2), '%02i'),num2str( vectorstartdate(3), '%02i'),num2str( vectorstartdate(4), '%02i'),num2str( vectorstartdate(5), '%02i'),num2str( vectorstartdate(6), '%02i')];
ymdhms_end=[num2str( vectorenddate(1), '%02i'),num2str( vectorenddate(2), '%02i'),num2str( vectorenddate(3), '%02i'),num2str( vectorenddate(4), '%02i'),num2str( vectorenddate(5), '%02i'),num2str( vectorenddate(6), '%02i')];


% %set the filename of the created new data file
filenamenew=['/scratch/uni/u237/user_data/ihans/FCDR/easy/v4_1fv2_0_1/',selectsatellite,'/',num2str( vectorstartdate(1), '%02i'),'/',num2str( vectorstartdate(2), '%02i'),'/',num2str( vectorstartdate(3), '%02i'),'/','FIDUCEO_FCDR_L1C_',upper(sen),'_',upper(sat),'_',ymdhms_start,'_',ymdhms_end,'_EASY_v4.1_fv2.0.1','.nc'];

 % 
%% store the data from true equator crossing to the next

% For all data based on calibration, i.e. Tb and uncertainties:
% set the 3 lines before and after the crossing (that were used for
% processing) to NAN and flag them as "calibrated data contained in
% next/prev. file"

btemps(:,:,1:3)=nan;
btemps(:,:,end-2:end)=nan;

%u_random is u_independent! (only change of naming)
u_random_btemps(:,:,1:3)=nan;
u_random_btemps(:,:,end-2:end)=nan;

%u_nonrandom is u_structured! (only change of naming)
u_nonrandom_btemps(:,:,1:3)=nan;
u_nonrandom_btemps(:,:,end-2:end)=nan;

u_common_btemps(:,:,1:3)=nan;
u_common_btemps(:,:,end-2:end)=nan;

 
 defl_level=5;
 n_frequencies=length(srf_frequencies);%MAXIMUM NUMBER OF FREQ
 
  scanlinedimension=Inf;%length(btemps); 
  % use Inf to get unlimited dimension. This is helpful for concatenating
  % the netcdf files afterwards along this dimension. See Email from Gerrit
  % Holl 17.01.2018.
 chunkpix=90;
 chunkline=100; % I obtained this value of 100 empirically: tradeoff between
 %runtime of writing process and output file size...
   
% 
  fillvalint32=-2147483648;
  fillvalint16=-32768;
  fillvalint8=-128;
  fillvaluint32=4294967295;
  fillvaluint16=65535;
  fillvaluint8=255;
  %%%%%% data %%%%%%

  nccreate(filenamenew,'/latitude','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/longitude','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/Satellite_azimuth_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/Satellite_zenith_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/Solar_azimuth_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/Solar_zenith_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  
  nccreate(filenamenew,'/Ch16_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline]) %WATCH OUT replace this by databtemps for real FCDR
  nccreate(filenamenew,'/Ch17_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/Ch18_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline]) 
  nccreate(filenamenew,'/Ch19_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline]) 
  nccreate(filenamenew,'/Ch20_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline]) 
  
      


  nccreate(filenamenew,'/quality_pixel_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline]) % I used fillvalue -1 since this means fillvaluint8 in uint8 and therefore all 8 bit to "on" which is not very likely to happen in reality
  nccreate(filenamenew,'/data_quality_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline]) % I used fillvalue -1 since this means fillvaluint8 in uint8 and therefore all 8 bit to "on" which is not very likely to happen in reality

      
      

  nccreate(filenamenew,'/quality_scanline_bitmask','Dimensions',{'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkline])    


  nccreate(filenamenew,'/quality_issue_pixel_Ch16_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline]) % I used fillvalue -1 since this means fillvaluint8 in uint8 and therefore all 8 bit to "on" which is not very likely to happen in reality
  nccreate(filenamenew,'/quality_issue_pixel_Ch17_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/quality_issue_pixel_Ch18_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/quality_issue_pixel_Ch19_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/quality_issue_pixel_Ch20_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])    

  nccreate(filenamenew,'/Time','Dimensions',{'y',scanlinedimension},...
           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level,'ChunkSize',[ chunkline])
  nccreate(filenamenew,'/scanline_origl1b','Dimensions',{'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level,'ChunkSize',[ chunkline])
  
  nccreate(filenamenew,'/scanline_map_to_origl1bfile','Dimensions',{'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level,'ChunkSize',[ chunkline])
  
  
  %%%% correlations    
  nccreate(filenamenew,'/channel_correlation_matrix_independent','Dimensions',{'channel',5,'channel',5},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/channel_correlation_matrix_structured','Dimensions',{'channel',5,'channel',5},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/channel_correlation_matrix_common','Dimensions',{'channel',5,'channel',5},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  

     
    % correlation vectors
    nccreate(filenamenew,'/cross_line_correlation_coefficients','Dimensions',{'channel',5,'delta_y',7},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level)
    nccreate(filenamenew,'/cross_element_correlation_coefficients','Dimensions',{'channel',5,'delta_x',90},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level)
 

    %%% Spectral response function variables
    % frequencies, dim: numbers of frequencies x channels
    nccreate(filenamenew,'/SRF_frequencies','Dimensions',{'n_frequency',n_frequencies,'channel',5},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level)
  
    % weights, dim: numbers of frequencies x channels
    nccreate(filenamenew,'/SRF_weights','Dimensions',{'n_frequency',n_frequencies,'channel',5},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  
      
  %%%%%%% uncertainties %%%%%%%
  
  
  %for easy FCDR
  nccreate(filenamenew,'/u_independent_Ch16_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_independent_Ch17_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_independent_Ch18_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])   
  nccreate(filenamenew,'/u_independent_Ch19_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_independent_Ch20_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
      

  nccreate(filenamenew,'/u_structured_Ch16_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_structured_Ch17_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_structured_Ch18_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])   
  nccreate(filenamenew,'/u_structured_Ch19_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_structured_Ch20_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint16','Format','netcdf4','FillValue',fillvaluint16,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
      
  nccreate(filenamenew,'/u_common_Ch16_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint32','Format','netcdf4','FillValue',fillvaluint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_common_Ch17_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint32','Format','netcdf4','FillValue',fillvaluint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_common_Ch18_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint32','Format','netcdf4','FillValue',fillvaluint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])   
  nccreate(filenamenew,'/u_common_Ch19_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint32','Format','netcdf4','FillValue',fillvaluint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])
  nccreate(filenamenew,'/u_common_Ch20_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint32','Format','netcdf4','FillValue',fillvaluint32,'DeflateLevel',defl_level,'ChunkSize',[chunkpix chunkline])    
 
  
%%  write data into  subgroups of  file
  

  %%%%%%%%%%% write data %%%%%%%
  lastscnline=scanlinedimension; %take the last scanline from l1b file; AAPP file might have extra scanline...
  firstscnline=scanlinenumbers(1);
  


% use own calulated angles and l1b lat lon
  lat_new=lat_data;
  lon_new=long_data;
  datasatazang_new=sat_az_ang;
  datasatzenang_new=sat_zen_ang_data;
  datasolazang_new=sol_az_ang;
  datasolzenang_new=sol_zen_ang_data;
  
  invscfac_latlon=100;
  scfac_latlon=1/invscfac_latlon;
  invscfac_angles=100;
  scfac_angles=1/invscfac_angles;
  ncwrite(filenamenew,'/latitude',change_type_zero_nan('int16',lat_new*invscfac_latlon))
  ncwrite(filenamenew,'/longitude',change_type_zero_nan('int16',lon_new*invscfac_latlon))
  ncwrite(filenamenew,'/Satellite_azimuth_angle',change_type_zero_nan('int32',datasatazang_new.*invscfac_angles))%Watch out! here, IF we take the angles as given by AAPP. These values are already multiplied by 100, i.e. 5678 instead of 56.78. then we do not need the invsclfactor 
  ncwrite(filenamenew,'/Satellite_zenith_angle',change_type_zero_nan('int32',datasatzenang_new.*invscfac_angles))
  ncwrite(filenamenew,'/Solar_azimuth_angle',change_type_zero_nan('int32',datasolazang_new.*invscfac_angles))
  ncwrite(filenamenew,'/Solar_zenith_angle',change_type_zero_nan('int32',datasolzenang_new.*invscfac_angles))
  
  invscfac_bt=100;
  scfac_bt=1/invscfac_bt;
  ncwrite(filenamenew,'/Ch16_BT',change_type_zero_nan('uint16',squeeze(btemps(1,:,:))*invscfac_bt)) %WATCH OUT replace this by databtemps for real FCDR
  ncwrite(filenamenew,'/Ch17_BT',change_type_zero_nan('uint16',squeeze(btemps(2,:,:))*invscfac_bt))
  ncwrite(filenamenew,'/Ch18_BT',change_type_zero_nan('uint16',squeeze(btemps(3,:,:))*invscfac_bt))
  ncwrite(filenamenew,'/Ch19_BT',change_type_zero_nan('uint16',squeeze(btemps(4,:,:))*invscfac_bt))
  ncwrite(filenamenew,'/Ch20_BT',change_type_zero_nan('uint16',squeeze(btemps(5,:,:))*invscfac_bt))
  
 
  
  ncwrite(filenamenew,'/quality_pixel_bitmask',uint16(quality_pixel_bitmask))
  
  ncwrite(filenamenew,'/data_quality_bitmask',uint16(data_quality_bitmask))
  
  

   ncwrite(filenamenew,'/quality_scanline_bitmask',uint8(quality_scanline_bitmask))

  ncwrite(filenamenew,'/quality_issue_pixel_Ch16_bitmask',uint8(quality_issue_pixel_Ch1_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch17_bitmask',uint8(quality_issue_pixel_Ch2_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch18_bitmask',uint8(quality_issue_pixel_Ch3_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch19_bitmask',uint8(quality_issue_pixel_Ch4_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch20_bitmask',uint8(quality_issue_pixel_Ch5_bitmask))
  
  

  
  
  ncwrite(filenamenew,'/Time',change_type_zero_nan('int32',time_EpochSecond))
 ncwrite(filenamenew,'/scanline_origl1b',change_type_zero_nan('int16',scnlin_original_l1bs))
  
  ncwrite(filenamenew,'/scanline_map_to_origl1bfile',uint8(map_line2l1bfile))
  
  invscfac_srffreq=100;
  scfac_srffreq=1/invscfac_srffreq;
  ncwrite(filenamenew,'/SRF_frequencies',change_type('int32',srf_frequencies*invscfac_srffreq))
  invscfac_srfweight=1000;
  scfac_srfweight=1/invscfac_srfweight;
  ncwrite(filenamenew,'/SRF_weights',change_type('int16',srf_weights*invscfac_srfweight))
  
  
  %%%%%%%%%%%%%% write uncertainties %%%%%%%%%%%%
  
  
  % in BRIGHTNESS TEMPERATURE
  invscfac_u=1e3;
  scfac_u=1/invscfac_u;
   
  %for easy FCDR
  invscfac_ur=1e4;
  scfac_ur=1/invscfac_ur;
  ncwrite(filenamenew,'/u_independent_Ch16_BT',change_type_zero_nan('uint16',squeeze(u_random_btemps(1,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch17_BT',change_type_zero_nan('uint16',squeeze(u_random_btemps(2,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch18_BT',change_type_zero_nan('uint16',squeeze(u_random_btemps(3,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch19_BT',change_type_zero_nan('uint16',squeeze(u_random_btemps(4,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch20_BT',change_type_zero_nan('uint16',squeeze(u_random_btemps(5,:,:))*invscfac_ur))
  
  invscfac_unr=1e4;
  scfac_unr=1/invscfac_unr;
  ncwrite(filenamenew,'/u_structured_Ch16_BT',change_type_zero_nan('uint16',squeeze(u_nonrandom_btemps(1,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch17_BT',change_type_zero_nan('uint16',squeeze(u_nonrandom_btemps(2,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch18_BT',change_type_zero_nan('uint16',squeeze(u_nonrandom_btemps(3,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch19_BT',change_type_zero_nan('uint16',squeeze(u_nonrandom_btemps(4,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch20_BT',change_type_zero_nan('uint16',squeeze(u_nonrandom_btemps(5,:,:))*invscfac_unr))
  
  
  
  invscfac_unr=1e4;
  scfac_unr=1/invscfac_unr;
  ncwrite(filenamenew,'/u_common_Ch16_BT',change_type_zero_nan('uint32',squeeze(u_common_btemps(1,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_common_Ch17_BT',change_type_zero_nan('uint32',squeeze(u_common_btemps(2,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_common_Ch18_BT',change_type_zero_nan('uint32',squeeze(u_common_btemps(3,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_common_Ch19_BT',change_type_zero_nan('uint32',squeeze(u_common_btemps(4,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_common_Ch20_BT',change_type_zero_nan('uint32',squeeze(u_common_btemps(5,:,:))*invscfac_unr))
  
  
  
    invscfac_corr_mat=1e2;
   scfac_corr_mat=1/invscfac_corr_mat;
  channel_correlation_matrix_independent=R_c_i;
  ncwrite(filenamenew,'/channel_correlation_matrix_independent',int16(channel_correlation_matrix_independent.*invscfac_corr_mat))
  channel_correlation_matrix_structured=R_c_s;
  ncwrite(filenamenew,'/channel_correlation_matrix_structured',int16(channel_correlation_matrix_structured.*invscfac_corr_mat))
  channel_correlation_matrix_common=R_c_co;
  ncwrite(filenamenew,'/channel_correlation_matrix_common',int16(channel_correlation_matrix_common.*invscfac_corr_mat))
  
  
  % correlation vectors
  % cross lines
  % obtained from Gaussian with sigma=3/sqrt(3), and truncated at delta l >6 (see FIDUCEO D2.2.a)
    corr_vector_singlechn=[1.0000    0.8465    0.5134    0.2231    0.0695    0.0155    0.0025];
    corr_vector_lines=repmat(corr_vector_singlechn,[5 1]);
    invscfac_corr_vec_lines=1e4;
    scfac_corr_vec_lines=1/invscfac_corr_vec_lines;
    ncwrite(filenamenew,'/cross_line_correlation_coefficients',uint16(corr_vector_lines.*invscfac_corr_vec_lines))

  % corr vector cross elements: assumed to be 1 everywhere: is true for
  % structured effects. Not independent (=0) and common (=variable) effects.
    corr_vector_elem=1.0*ones(5,90);
    invscfac_corr_vec=1e2;
    scfac_corr_vec=1/invscfac_corr_vec;
    ncwrite(filenamenew,'/cross_element_correlation_coefficients',uint16(corr_vector_elem.*invscfac_corr_vec))

  
  
  %% write attributes
 ncwriteatt(filenamenew,'/','Conventions',['CF-1.6']); %'tbd' %setting these conventions to CF-1.6 makes geolocation for Panoply impossible (MUST include _CoordinateAxisType Lat in attributes, then it works). Probably since CF conventions require a certain array for Lat and Lon: lat(lat), lon(lon), not 2dimensional!
 ncwriteatt(filenamenew,'/','institution',['Universitaet Hamburg']);
 stringname='';
for kfile=1:length(hdrinfo.dataset_name)
    stringname=[stringname,char(hdrinfo.dataset_name{kfile}),' '];
end
 ncwriteatt(filenamenew,'/','source',stringname);
 ncwriteatt(filenamenew,'/','title',['Microwave humidity sounder Easy-Fundamental Climate Data Record (MW-Easy-FCDR)']);
 ncwriteatt(filenamenew,'/','history',[]);
 ncwriteatt(filenamenew,'/','references',[]);
 ncwriteatt(filenamenew,'/','id',['product doi will be placed here']);
 ncwriteatt(filenamenew,'/','naming_authority',['Institution that published the doi']);
 ncwriteatt(filenamenew,'/','licence',['This dataset is released for use under CC-BY licence (https://creativecommons.org/licenses/by/4.0/) and was developed in the EC \n', ...
                                   'FIDUCEO project Fidelity and Uncertainty in Climate Data Records from Earth Observations. Grant Agreement: 638822.']);
 ncwriteatt(filenamenew,'/','writer_version',['MATLAB script write_easyFCDR_orbitfile_AMSUB.m']);
 
% further flags added by IHans 
ncwriteatt(filenamenew,'/','satellite',[sat]);
ncwriteatt(filenamenew,'/','instrument',[sen]);
 ncwriteatt(filenamenew,'/','comment',['This version is based on consistent, improved calibration (see Product User Guide v4.1).']);
 
 ncwriteatt(filenamenew,'/','StartTimeOfOrbit',datestr(vectorstartdate));
 ncwriteatt(filenamenew,'/','EndTimeOfOrbit',datestr(vectorenddate));

 

 
 
 
 
 ncwriteatt(filenamenew,'/Time','long_name',['Time_of_Scan_line']);
 ncwriteatt(filenamenew,'/Time','units',['s']);
 ncwriteatt(filenamenew,'/Time','description',['Acquisition time of the scan line in seconds since 1970-01-01 00:00:00.']);

 
 ncwriteatt(filenamenew,'/scanline_origl1b','long_name',['Original_Scan_line_number']);
 ncwriteatt(filenamenew,'/scanline_origl1b','description',['Original scan line numbers from corresponding l1b records.']);
 
 ncwriteatt(filenamenew,'/scanline_map_to_origl1bfile','long_name',['Indicator of original file']);
 ncwriteatt(filenamenew,'/scanline_map_to_origl1bfile','description',['Indicator for mapping each line to its corresponding original level 1b file.\n'... 
     'See global attribute "source" for the filenames. 0 corresponds to 1st listed file, 1 to 2nd file.']);
 
 
 ncwriteatt(filenamenew,'/SRF_frequencies','long_name',['Spectral Response Function frequencies']);
 ncwriteatt(filenamenew,'/SRF_frequencies','units',['MHz']);
 ncwriteatt(filenamenew,'/SRF_frequencies','scale_factor',scfac_srffreq);
 ncwriteatt(filenamenew,'/SRF_frequencies','description',['Per channel: frequencies for the relative spectral response function.']);
 
 ncwriteatt(filenamenew,'/SRF_weights','long_name',['Spectral Response Function weights']);
 ncwriteatt(filenamenew,'/SRF_weights','units',['dB']);
 ncwriteatt(filenamenew,'/SRF_weights','scale_factor',scfac_srfweight);
 ncwriteatt(filenamenew,'/SRF_weights','description',['Per channel: weights for the relative spectral response function.']);
 
 
 % QUALITY FLAGS
 
 
  % Global flags
 ncwriteatt(filenamenew,'/quality_pixel_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_bitmask','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/quality_pixel_bitmask','long_name',['Bitmask for quality per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_bitmask','flag_masks',['1, 2, 4, 8, 16, 32, 64, 128']); 
 ncwriteatt(filenamenew,'/quality_pixel_bitmask','flag_meanings',['invalid use_with_caution invalid_input invalid_geoloc '...
     'invalid_time sensor_error padded_data incomplete_channel_data ']);

% Sensor Specific flags

 ncwriteatt(filenamenew,'/data_quality_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/data_quality_bitmask','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/data_quality_bitmask','long_name',['Sensor specific bitmask for quality per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/data_quality_bitmask','flag_masks',['1, 2, 4, 8, 16, 32']); 
 ncwriteatt(filenamenew,'/data_quality_bitmask','flag_meanings',['moon_check_fails no_calib_bad_prt no_calib_moon_intrusion susp_calib_bb_temp '...
    'susp_calib_prt susp_calib_moon_intrusion ']);

% scanline specific
 ncwriteatt(filenamenew,'/quality_scanline_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_scanline_bitmask','long_name',['Bitmask for quality per scanline']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_scanline_bitmask','flag_masks',['1, 2, 4, 8, 16, 32']); 
 ncwriteatt(filenamenew,'/quality_scanline_bitmask','flag_meanings',['STX1_transmitter_on STX2_transmitter_on STX3_transmitter_on '...
     'STX4_transmitter_on SARR_A_transmitter_on SARR_B_transmitter_on']);


 
 % Channel specific issues: quality_issue_pixel_ChX_bitmask
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch16_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch16_bitmask','long_name',['Bitmask for quality issues in Ch16 per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch16_bitmask','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch16_bitmask','flag_masks',['1,2,4,8,16']); 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch16_bitmask','flag_meanings',['susp_calib_DSV susp_calib_IWCT no_calib_bad_DSV no_calib_bad_IWCT bad_data_earthview']);

 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch17_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch17_bitmask','long_name',['Bitmask for quality issues in Ch17 per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch17_bitmask','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch17_bitmask','flag_masks',['1,2,4,8,16']); 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch17_bitmask','flag_meanings',['susp_calib_DSV susp_calib_IWCT no_calib_bad_DSV no_calib_bad_IWCT bad_data_earthview']);

 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch18_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch18_bitmask','long_name',['Bitmask for quality issues in Ch18 per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch18_bitmask','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch18_bitmask','flag_masks',['1,2,4,8,16']); 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch18_bitmask','flag_meanings',['susp_calib_DSV susp_calib_IWCT no_calib_bad_DSV no_calib_bad_IWCT bad_data_earthview']);

 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch19_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch19_bitmask','long_name',['Bitmask for quality issues in Ch19 per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch19_bitmask','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch19_bitmask','flag_masks',['1,2,4,8,16']); 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch19_bitmask','flag_meanings',['susp_calib_DSV susp_calib_IWCT no_calib_bad_DSV no_calib_bad_IWCT bad_data_earthview']);

 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch20_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch20_bitmask','long_name',['Bitmask for quality issues in Ch20 per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch20_bitmask','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch20_bitmask','flag_masks',['1,2,4,8,16']); 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch20_bitmask','flag_meanings',['susp_calib_DSV susp_calib_IWCT no_calib_bad_DSV no_calib_bad_IWCT bad_data_earthview']);

 
 % GEOLOCATION

 
 ncwriteatt(filenamenew,'/latitude','standard_name',['latitude']);
 ncwriteatt(filenamenew,'/latitude','long_name',['latitude']);
 ncwriteatt(filenamenew,'/latitude','units',['degree north']);
 ncwriteatt(filenamenew,'/latitude','scale_factor',scfac_latlon); 
 ncwriteatt(filenamenew,'/latitude','description',['Latitude for each pixel in every scanline.']);
 

 ncwriteatt(filenamenew,'/longitude','standard_name',['longitude']);
 ncwriteatt(filenamenew,'/longitude','long_name',['longitude']);
 ncwriteatt(filenamenew,'/longitude','units',['degree east']); 
 ncwriteatt(filenamenew,'/longitude','scale_factor',scfac_latlon); 
 ncwriteatt(filenamenew,'/longitude','description',['Longitude for each pixel in every scanline.']);
 

 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','long_name',['Satellite_azimuth_angle']);
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','standard_name',['sensor_azimuth_angle']);
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','description',['Satellite azimuth angle for each view (x) in every scanline (y).']);
 

 ncwriteatt(filenamenew,'/Satellite_zenith_angle','long_name',['Satellite_zenith_angle']);
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','standard_name',['sensor_zenith_angle']);
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','description',['Satellite zenith angle for each view (x) in every scanline (y).']);
 

 ncwriteatt(filenamenew,'/Solar_azimuth_angle','standard_name',['solar_azimuth_angle']);
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','long_name',['Solar_azimuth_angle']);
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','description',['Solar azimuth angle for each view (x) in every scanline (y).']);
 

 ncwriteatt(filenamenew,'/Solar_zenith_angle','standard_name',['solar_zenith_angle']);
 ncwriteatt(filenamenew,'/Solar_zenith_angle','long_name',['Solar_zenith_angle']);
 ncwriteatt(filenamenew,'/Solar_zenith_angle','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Solar_zenith_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Solar_zenith_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Solar_zenith_angle','description',['Solar zenith angle for each each view (x) in every scanline (y).']);
 
 
 % btemps

 ncwriteatt(filenamenew,'/Ch16_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch16_BT','long_name',['channel16-89.0GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch16_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Ch16_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch16_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch16_BT','description',['channel 16 brightness temperature per view (x) and scanline (y)']);
 
 
 ncwriteatt(filenamenew,'/Ch17_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch17_BT','long_name',['channel17-150.0GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch17_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Ch17_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch17_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch17_BT','description',['channel 17 brightness temperature per view (x) and scanline (y)']);
 
 
 ncwriteatt(filenamenew,'/Ch18_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch18_BT','long_name',['channel18-183.31pm1GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch18_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Ch18_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch18_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch18_BT','description',['channel 18 brightness temperature per view (x) and scanline (y)']);
 

 ncwriteatt(filenamenew,'/Ch19_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch19_BT','long_name',['channel19-183.31pm3GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch19_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Ch19_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch19_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch19_BT','description',['channel 19 brightness temperature per view (x) and scanline (y)']);
 
 
 ncwriteatt(filenamenew,'/Ch20_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch20_BT','long_name',['channel20-183.31pm7GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch20_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/Ch20_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch20_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch20_BT','description',['channel 20 brightness temperature per view (x) and scanline (y)']);
 
 % UNCERTAINTIES
 

 ncwriteatt(filenamenew,'/u_independent_Ch16_BT','long_name',['uncertainty_of_channel16_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch16_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_independent_Ch16_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch16_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch16_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch17_BT','long_name',['uncertainty_of_channel17_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch17_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_independent_Ch17_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch17_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch17_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch18_BT','long_name',['uncertainty_of_channel18_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch18_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_independent_Ch18_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch18_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch18_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch19_BT','long_name',['uncertainty_of_channel19_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch19_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_independent_Ch19_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch19_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch19_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch20_BT','long_name',['uncertainty_of_channel20_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch20_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_independent_Ch20_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch20_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch20_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 
 

 ncwriteatt(filenamenew,'/u_structured_Ch16_BT','long_name',['uncertainty_of_channel16_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch16_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_structured_Ch16_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch16_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch16_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 
 
 ncwriteatt(filenamenew,'/u_structured_Ch17_BT','long_name',['uncertainty_of_channel17_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch17_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_structured_Ch17_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch17_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch17_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_structured_Ch18_BT','long_name',['uncertainty_of_channel18_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch18_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_structured_Ch18_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch18_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch18_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_structured_Ch19_BT','long_name',['uncertainty_of_channel19_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch19_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_structured_Ch19_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch19_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch19_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 
 
 ncwriteatt(filenamenew,'/u_structured_Ch20_BT','long_name',['uncertainty_of_channel20_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch20_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_structured_Ch20_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch20_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch20_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 
 
 ncwriteatt(filenamenew,'/u_common_Ch16_BT','long_name',['uncertainty_of_channel16_toa_brightness_temperature_common_effects']);
 ncwriteatt(filenamenew,'/u_common_Ch16_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_common_Ch16_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_common_Ch16_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_common_Ch16_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered common effects of uncertainty.']);
 
 
 ncwriteatt(filenamenew,'/u_common_Ch17_BT','long_name',['uncertainty_of_channel17_toa_brightness_temperature_common_effects']);
 ncwriteatt(filenamenew,'/u_common_Ch17_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_common_Ch17_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_common_Ch17_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_common_Ch17_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered common effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_common_Ch18_BT','long_name',['uncertainty_of_channel18_toa_brightness_temperature_common_effects']);
 ncwriteatt(filenamenew,'/u_common_Ch18_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_common_Ch18_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_common_Ch18_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_common_Ch18_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered common effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_common_Ch19_BT','long_name',['uncertainty_of_channel19_toa_brightness_temperature_common_effects']);
 ncwriteatt(filenamenew,'/u_common_Ch19_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_common_Ch19_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_common_Ch19_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_common_Ch19_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered common effects of uncertainty.']);
 
 
 ncwriteatt(filenamenew,'/u_common_Ch20_BT','long_name',['uncertainty_of_channel20_toa_brightness_temperature_common_effects']);
 ncwriteatt(filenamenew,'/u_common_Ch20_BT','coordinates',['latitude longitude']);
 ncwriteatt(filenamenew,'/u_common_Ch20_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_common_Ch20_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_common_Ch20_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered common effects of uncertainty.']);
 
 

 
 %%% correlations
 
 
 ncwriteatt(filenamenew,'/channel_correlation_matrix_independent','long_name',['Channel_error_correlation_matrix_independent_effects']);
 ncwriteatt(filenamenew,'/channel_correlation_matrix_independent','units',['1']);
 ncwriteatt(filenamenew,'/channel_correlation_matrix_independent','scale_factor',scfac_corr_mat); 
 ncwriteatt(filenamenew,'/channel_correlation_matrix_independent','description',['Cross-Channel error correlation matrix for independent effects. ']);
 
 ncwriteatt(filenamenew,'/channel_correlation_matrix_structured','long_name',['Channel_error_correlation_matrix_structured_effects']);
 ncwriteatt(filenamenew,'/channel_correlation_matrix_structured','units',['1']);
 ncwriteatt(filenamenew,'/channel_correlation_matrix_structured','scale_factor',scfac_corr_mat); 
 ncwriteatt(filenamenew,'/channel_correlation_matrix_structured','description',['Cross-Channel error correlation matrix for structured effects. ']);
 
 ncwriteatt(filenamenew,'/channel_correlation_matrix_common','long_name',['Channel_error_correlation_matrix_common_effects']);
 ncwriteatt(filenamenew,'/channel_correlation_matrix_common','units',['1']);
 ncwriteatt(filenamenew,'/channel_correlation_matrix_common','scale_factor',scfac_corr_mat); 
 ncwriteatt(filenamenew,'/channel_correlation_matrix_common','description',['Cross-Channel error correlation matrix for common effects.']);

 
 ncwriteatt(filenamenew,'/cross_line_correlation_coefficients','long_name',['cross_line_correlation_coefficients']);
 ncwriteatt(filenamenew,'/cross_line_correlation_coefficients','units',['1']);
 ncwriteatt(filenamenew,'/cross_line_correlation_coefficients','scale_factor',scfac_corr_vec_lines); 
 ncwriteatt(filenamenew,'/cross_line_correlation_coefficients','description',['Correlation coefficients per channel for scanline correlation. Note that  only the structured effects are taken into account. The correlation for the independent effects is zero by definition and the correlation for the common effects is 1 for all scan lines and orbits.']);
 
 ncwriteatt(filenamenew,'/cross_element_correlation_coefficients','long_name',['cross_element_correlation_coefficients']);
 ncwriteatt(filenamenew,'/cross_element_correlation_coefficients','units',['1']);
 ncwriteatt(filenamenew,'/cross_element_correlation_coefficients','scale_factor',scfac_corr_vec); 
 ncwriteatt(filenamenew,'/cross_element_correlation_coefficients','description',['Correlation coefficients per channel for correlation within a scanline. Note that this is a rough estimation as only the structured effects are taken into account. The correlation for the independent effects is zero by definition and the correlation for the common effects is probably variable within one scan line.']);
 
 
 

 
 disp('Done. NetCDF file located in')
 disp(filenamenew)
 
 
 
