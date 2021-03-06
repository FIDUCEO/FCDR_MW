
% write_easyFCDR_orbitfile

%
 % Copyright (C) 2017-04-12 Imke Hans
 % This code was developed for the EC project �Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)�. 
 % Grant Agreement: 638822
 %  <Version> Reviewed and approved by <name, instituton>, <date>
 %
 %  V 0.1   Reviewed and approved by Imke Hans, Univ. Hamburg, 2017-04-20
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
 
%% info
% ONLY USE this script via calling function generate_FCDR.m
% DO NOT use this script alone. It needs the output from preceeding
% functions/ scripts generate_FCDR and setup_fullFCDR_uncertproc, 
% measurement_equation, uncertainty_propagation

% This script writes the brigthness temperature, and ancillary variables
% to a nc-file. Moreover, it also writes the total uncertainty
% in the brightness temperature, the uncertainty emerging from random
% uncertainties and the uncertainties emerging from structured
% uncertainties.

% YOU HAVE TO specify the output path for the file in "filenamenew".

% This script writes all variables that have been used in the calibration
% (measurement equation) to a nc-file along with their corresponding uncertainties. 


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
%%filenamenew=['/scratch/uni/u237/user_data/ihans/FCDR/v0.3/easy/',sat,'/',num2str( vectorstartdate(1), '%02i'),'/',num2str( vectorstartdate(2), '%02i'),'/',num2str( vectorstartdate(3), '%02i'),'/','FIDUCEO_FCDR_L1C_',upper(sen),'_',upper(sat),'_',ymdhms_start,'_',ymdhms_end,'_EASY_v00.3_fv00.3','.nc'];
%%filenamenew=['/scratch/uni/u237/user_data/ihans/FCDR/metopb_mhs_forGaiaClim/easy/',sat,'/',num2str( vectorstartdate(1), '%02i'),'/',num2str( vectorstartdate(2), '%02i'),'/',num2str( vectorstartdate(3), '%02i'),'/','FIDUCEO_FCDR_L1C_',upper(sen),'_',upper(sat),'_',ymdhms_start,'_',ymdhms_end,'_EASY_v00.3_fv00.3','.nc'];
% filename for FCDR generation
%filenamenew=['/scratch/uni/u237/users/ihans/FIDUCEO_testdata/',selectsatellite,'/','FIDUCEO_FCDR_L1C_',upper(sen),'_',upper(sat),'_',ymdhms_start,'_',ymdhms_end,'_EASY_v0.9_fv0.8_lessdefl_5','.nc'];
filenamenew=['/scratch/uni/u237/user_data/ihans/FCDR/',selectsatellite,'/',num2str(year),'/','FIDUCEO_FCDR_L1C_',upper(sen),'_',upper(sat),'_',ymdhms_start,'_',ymdhms_end,'_EASY_v0.9_fv0.8','.nc'];
%filenamenew=['/scratch/uni/u237/users/ihans/FIDUCEO_testdata/sensitivity_study/',effect,'/',selectsatellite,'/','FIDUCEO_FCDR_L1C_',upper(sen),'_',upper(sat),'_',ymdhms_start,'_',ymdhms_end,'_EASY_v0.8_fv0.6_',effect,'_',value,'.nc'];

 % 
 
%% store the data from true equator crossing to the next

% For all data based on calibration, i.e. Tb and uncertainties:
% set the 3 lines before and after the crossing (that were used for
% processing) to NAN and flag them as "calibrated data contained in
% next/prev. file"

btemps(:,:,1:3)=nan;
btemps(:,:,end-3:end)=nan;

u_random_btemps(:,:,1:3)=nan;
u_random_btemps(:,:,end-3:end)=nan;

u_nonrandom_btemps(:,:,1:3)=nan;
u_nonrandom_btemps(:,:,end-3:end)=nan;

 
 
 
 
%% create subgroups in the nc file where you store the old and new data
% 
  fillvalint32=-2147483648;
  fillvalint16=-32768;
  fillvalint8=-128;
  fillvaluint32=4294967295;
  fillvaluint16=65535;
  fillvaluint8=255;
  
  
  defl_level=5;
  scanlinedimension=length(btemps);
  %%%%%% data %%%%%%

  nccreate(filenamenew,'/latitude','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/longitude','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/Satellite_azimuth_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/Satellite_zenith_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/Solar_azimuth_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/Solar_zenith_angle','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level)
  
  nccreate(filenamenew,'/Ch1_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level) %WATCH OUT replace this by databtemps for real FCDR
  nccreate(filenamenew,'/Ch2_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/Ch3_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level) 
  nccreate(filenamenew,'/Ch4_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level) 
  nccreate(filenamenew,'/Ch5_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level) 
  
      
  %nccreate(filenamenew,'/chanqual','Dimensions',{'channel',5,'y',length(datachanqual)},...
  %        'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',9)
  %nccreate(filenamenew,'/instrtempAAPP','Dimensions',{'y',length(datainstrtemp)},...
  %        'Datatype','int32','Format','netcdf4')
  %nccreate(filenamenew,'/instrtemp','Dimensions',{'y',length(datainstrtemp)},...
  %        'Datatype','int32','Format','netcdf4','FillValue',fillvalint32)
  %nccreate(filenamenew,'/qualind','Dimensions',{'y',length(dataqualind)},...
  %        'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',9)
  %nccreate(filenamenew,'/scanqual','Dimensions',{'y',length(datascanqual)},...
  %        'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',9)
  
%   %%%%%%% old quality flags
%   nccreate(filenamenew,'/qual_scnlin_bitmask','Dimensions',{'y',scanlinedimension},...
%           'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',9) % I used fillvalue -1 since this means fillvaluint8 in uint8 and therefore all 8 bit to "on" which is not very likely to happen in reality
%   nccreate(filenamenew,'/qual_scnlin_Ch1_bitmask','Dimensions',{'y',scanlinedimension},...
%           'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',9)
%   nccreate(filenamenew,'/qual_scnlin_Ch2_bitmask','Dimensions',{'y',scanlinedimension},...
%           'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',9)
%   nccreate(filenamenew,'/qual_scnlin_Ch3_bitmask','Dimensions',{'y',scanlinedimension},...
%           'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',9)
%   nccreate(filenamenew,'/qual_scnlin_Ch4_bitmask','Dimensions',{'y',scanlinedimension},...
%           'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',9)
%   nccreate(filenamenew,'/qual_scnlin_Ch5_bitmask','Dimensions',{'y',scanlinedimension},...
%           'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',9)    
%   %%%%%%%%


  nccreate(filenamenew,'/quality_pixel_Ch1_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level) % I used fillvalue -1 since this means fillvaluint8 in uint8 and therefore all 8 bit to "on" which is not very likely to happen in reality
  nccreate(filenamenew,'/quality_pixel_Ch2_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/quality_pixel_Ch3_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/quality_pixel_Ch4_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/quality_pixel_Ch5_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)
  
  nccreate(filenamenew,'/quality_issue_scnlin_bitmask','Dimensions',{'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',9)    

      
  nccreate(filenamenew,'/quality_issue_pixel_Ch1_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level) % I used fillvalue -1 since this means fillvaluint8 in uint8 and therefore all 8 bit to "on" which is not very likely to happen in reality
  nccreate(filenamenew,'/quality_issue_pixel_Ch2_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/quality_issue_pixel_Ch3_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/quality_issue_pixel_Ch4_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/quality_issue_pixel_Ch5_bitmask','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','uint8','Format','netcdf4','FillValue',fillvaluint8,'DeflateLevel',defl_level)    

 % nccreate(filenamenew,'/scnlin','Dimensions',{'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9)
 % nccreate(filenamenew,'/scnlindy','Dimensions',{'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9)
  nccreate(filenamenew,'/scnlintime','Dimensions',{'y',scanlinedimension},...
           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32,'DeflateLevel',defl_level)
 % nccreate(filenamenew,'/scnlinyr','Dimensions',{'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9)
  nccreate(filenamenew,'/scnlin_origl1b','Dimensions',{'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  
  
  %%%%%%% uncertainties %%%%%%%
  
  %in GEOLOCATION
%   nccreate(filenamenew,'/u_latitude','Dimensions',{'x',90,'y',length(lat)},...
%           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32)
%   nccreate(filenamenew,'/u_longitude','Dimensions',{'x',90,'y',length(lon)},...
%           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32)
%   nccreate(filenamenew,'/u_Satellite_azimuth_angle','Dimensions',{'x',90,'y',length(datasatazang)},...
%           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32)
%   nccreate(filenamenew,'/u_Satellite_zenith_angle','Dimensions',{'x',90,'y',length(datasatzenang)},...
%           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32)
%   nccreate(filenamenew,'/u_Solar_azimuth_angle','Dimensions',{'x',90,'y',length(datasolazang)},...
%           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32)
%   nccreate(filenamenew,'/u_Solar_zenith_angle','Dimensions',{'x',90,'y',length(datasolzenang)},...
%           'Datatype','int32','Format','netcdf4','FillValue',fillvalint32)
%   
  % in BRIGHTNESS TEMPERATURE
 % nccreate(filenamenew,'/u_total_Ch1_BT','Dimensions',{'x',90,'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9) %WATCH OUT replace this by databtemps for real FCDR
 % nccreate(filenamenew,'/u_total_Ch2_BT','Dimensions',{'x',90,'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9)
 % nccreate(filenamenew,'/u_total_Ch3_BT','Dimensions',{'x',90,'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9)
 % nccreate(filenamenew,'/u_total_Ch4_BT','Dimensions',{'x',90,'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9)
 % nccreate(filenamenew,'/u_total_Ch5_BT','Dimensions',{'x',90,'y',scanlinedimension},...
 %         'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',9)    
      
  %for easy FCDR
  nccreate(filenamenew,'/u_independent_Ch1_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/u_independent_Ch2_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/u_independent_Ch3_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)   
  nccreate(filenamenew,'/u_independent_Ch4_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/u_independent_Ch5_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
      

  nccreate(filenamenew,'/u_structured_Ch1_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/u_structured_Ch2_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/u_structured_Ch3_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)   
  nccreate(filenamenew,'/u_structured_Ch4_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  nccreate(filenamenew,'/u_structured_Ch5_BT','Dimensions',{'x',90,'y',scanlinedimension},...
          'Datatype','int16','Format','netcdf4','FillValue',fillvalint16,'DeflateLevel',defl_level)
  %nccreate(filenamenew,'/u_structuredrandom_btemps',size(btempsK))
  
  
%%  write data into  subgroups of  file
  

  %%%%%%%%%%% write data %%%%%%%
  lastscnline=scanlinedimension; %take the last scanline from l1b file; AAPP file might have extra scanline...
  firstscnline=scanlinenumbers(1);
  
   % adapt AAPP-lat/lon etc. to new size (due to filling of missing
  % scanlines)
%   lat_orig=lat(:,firstscnline:length(scanlinenumbers_original));
%   lon_orig=lon(:,firstscnline:length(scanlinenumbers_original));
%   datasatazang_orig=datasatazang(:,firstscnline:length(scanlinenumbers_original));
%   datasatzenang_orig=datasatzenang(:,firstscnline:length(scanlinenumbers_original));
%   datasolazang_orig=datasolazang(:,firstscnline:length(scanlinenumbers_original));
%   datasolzenang_orig=datasolzenang(:,firstscnline:length(scanlinenumbers_original));
%   
%   lat_orig=lat(:,firstscnline:length(scanlinenumbers_original));
%   lon_orig=lon(:,firstscnline:length(scanlinenumbers_original));
%   datasatazang_orig=datasatazang(:,firstscnline:length(scanlinenumbers_original));
%   datasatzenang_orig=datasatzenang(:,firstscnline:length(scanlinenumbers_original));
%   datasolazang_orig=datasolazang(:,firstscnline:length(scanlinenumbers_original));
%   datasolzenang_orig=datasolzenang(:,firstscnline:length(scanlinenumbers_original));
%   
%   lat_new=zeros(90,length(scanlinenumbers));
%   lon_new=zeros(90,length(scanlinenumbers));
%   datasatazang_new=zeros(90,length(scanlinenumbers));
%   datasatzenang_new=zeros(90,length(scanlinenumbers));
%   datasolazang_new=zeros(90,length(scanlinenumbers));
%   datasolzenang_new=zeros(90,length(scanlinenumbers));
%   
%   for view=1:90
%       lat_orig_view=lat_orig(view,:);
%       lon_orig_view=lon_orig(view,:);
%       datasatazang_orig_view=datasatazang_orig(view,:);
%       datasatzenang_orig_view=datasatzenang_orig(view,:);
%       datasolazang_orig_view=datasolazang_orig(view,:);
%       datasolzenang_orig_view=datasolzenang_orig(view,:);
%       
%   [~,latview]=fill_missing_scanlines(double(AAPP.time),scanlinenumbers_original,lat_orig_view,fillvalint32/100); 
%   [~,lonview]=fill_missing_scanlines(double(AAPP.time),scanlinenumbers_original,lon_orig_view,fillvalint32/100);
%   [~,datasatazangview]=fill_missing_scanlines(double(AAPP.time),scanlinenumbers_original,datasatazang_orig_view,fillvalint32);%/100 to get the scaling correct
%   [~,datasatzenangview]=fill_missing_scanlines(double(AAPP.time),scanlinenumbers_original,datasatzenang_orig_view,fillvalint32);
%   [~,datasolazangview]=fill_missing_scanlines(double(AAPP.time),scanlinenumbers_original,datasolazang_orig_view,fillvalint32);
%   [~,datasolzenangview]=fill_missing_scanlines(double(AAPP.time),scanlinenumbers_original,datasolzenang_orig_view,fillvalint32);
%   lat_new(view,:)=latview(1:end-shift);
%   lon_new(view,:)=lonview(1:end-shift);
%   datasatazang_new(view,:)=datasatazangview(1:end-shift);
%   datasatzenang_new(view,:)=datasatzenangview(1:end-shift);
%   datasolazang_new(view,:)=datasolazangview(1:end-shift);
%   datasolzenang_new(view,:)=datasolzenangview(1:end-shift);
%   end

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
  ncwrite(filenamenew,'/Ch1_BT',change_type_zero_nan('int32',squeeze(btemps(1,:,:))*invscfac_bt)) %WATCH OUT replace this by databtemps for real FCDR
  ncwrite(filenamenew,'/Ch2_BT',change_type_zero_nan('int32',squeeze(btemps(2,:,:))*invscfac_bt))
  ncwrite(filenamenew,'/Ch3_BT',change_type_zero_nan('int32',squeeze(btemps(3,:,:))*invscfac_bt))
  ncwrite(filenamenew,'/Ch4_BT',change_type_zero_nan('int32',squeeze(btemps(4,:,:))*invscfac_bt))
  ncwrite(filenamenew,'/Ch5_BT',change_type_zero_nan('int32',squeeze(btemps(5,:,:))*invscfac_bt))
  
  %ncwrite(filenamenew,'/chanqual',datachanqual)
  %ncwrite(filenamenew,'/instrtempAAPP',datainstrtemp)
  %ncwrite(filenamenew,'/instrtemp',instrtemp*100)
  %ncwrite(filenamenew,'/qualind',dataqualind)
  %ncwrite(filenamenew,'/scanqual',datascanqual)
  
  
  ncwrite(filenamenew,'/quality_pixel_Ch1_bitmask',uint8(quality_pixel_Ch1_bitmask))
  ncwrite(filenamenew,'/quality_pixel_Ch2_bitmask',uint8(quality_pixel_Ch2_bitmask))
  ncwrite(filenamenew,'/quality_pixel_Ch3_bitmask',uint8(quality_pixel_Ch3_bitmask))
  ncwrite(filenamenew,'/quality_pixel_Ch4_bitmask',uint8(quality_pixel_Ch4_bitmask))
  ncwrite(filenamenew,'/quality_pixel_Ch5_bitmask',uint8(quality_pixel_Ch5_bitmask))

  ncwrite(filenamenew,'/quality_issue_scnlin_bitmask',uint8(quality_issue_scnlin_bitmask))
  
  ncwrite(filenamenew,'/quality_issue_pixel_Ch1_bitmask',uint8(quality_issue_pixel_Ch1_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch2_bitmask',uint8(quality_issue_pixel_Ch2_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch3_bitmask',uint8(quality_issue_pixel_Ch3_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch4_bitmask',uint8(quality_issue_pixel_Ch4_bitmask))
  ncwrite(filenamenew,'/quality_issue_pixel_Ch5_bitmask',uint8(quality_issue_pixel_Ch5_bitmask))
  
%   ncwrite(filenamenew,'/qual_scnlin_bitmask',quality_scanline_bitmask)
%   ncwrite(filenamenew,'/qual_scnlin_Ch1_bitmask',quality_scanline_Ch1_bitmask)
%   ncwrite(filenamenew,'/qual_scnlin_Ch2_bitmask',quality_scanline_Ch2_bitmask)
%   ncwrite(filenamenew,'/qual_scnlin_Ch3_bitmask',quality_scanline_Ch3_bitmask)
%   ncwrite(filenamenew,'/qual_scnlin_Ch4_bitmask',quality_scanline_Ch4_bitmask)
%   ncwrite(filenamenew,'/qual_scnlin_Ch5_bitmask',quality_scanline_Ch5_bitmask)
%   
%   

  
  
  %ncwrite(filenamenew,'/scnlin',int16(scanlinenumbers))
  %ncwrite(filenamenew,'/scnlindy',int16(scnlindy))
  ncwrite(filenamenew,'/scnlintime',change_type_zero_nan('int32',time_EpochSecond))
  %ncwrite(filenamenew,'/scnlinyr',int16(scnlinyr))
  ncwrite(filenamenew,'/scnlin_origl1b',change_type_zero_nan('int16',scnlin_original_l1bs))
  
  
  %%%%%%%%%%%%%% write uncertainties %%%%%%%%%%%%
  
  %in GEOLOCATION
%   ncwrite(filenamenew,'/u_latitude',u_lat*invscfac_latlon)
%   ncwrite(filenamenew,'/u_longitude',u_lon*invscfac_latlon)
%   ncwrite(filenamenew,'/u_Satellite_azimuth_angle',u_datasatazang*invscfac_latlon)
%   ncwrite(filenamenew,'/u_Satellite_zenith_angle',u_datasatzenang*invscfac_latlon)
%   ncwrite(filenamenew,'/u_Solar_azimuth_angle',u_datasolazang*invscfac_latlon)
%   ncwrite(filenamenew,'/u_Solar_zenith_angle',u_datasolzenang*invscfac_latlon)
%   
  % in BRIGHTNESS TEMPERATURE
  invscfac_u=1e3;
  scfac_u=1/invscfac_u;
  %ncwrite(filenamenew,'/u_total_Ch1_BT',change_type('int16',squeeze(u_total_btemps(1,:,:))*invscfac_u)) %WATCH OUT replace this by databtemps for real FCDR
  %ncwrite(filenamenew,'/u_total_Ch2_BT',change_type('int16',squeeze(u_total_btemps(2,:,:))*invscfac_u))
  %ncwrite(filenamenew,'/u_total_Ch3_BT',change_type('int16',squeeze(u_total_btemps(3,:,:))*invscfac_u))
  %ncwrite(filenamenew,'/u_total_Ch4_BT',change_type('int16',squeeze(u_total_btemps(4,:,:))*invscfac_u))
  %ncwrite(filenamenew,'/u_total_Ch5_BT',change_type('int16',squeeze(u_total_btemps(5,:,:))*invscfac_u))
  
  %for easy FCDR
  invscfac_ur=1e4;
  scfac_ur=1/invscfac_ur;
  ncwrite(filenamenew,'/u_independent_Ch1_BT',change_type_zero_nan('int16',squeeze(u_random_btemps(1,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch2_BT',change_type_zero_nan('int16',squeeze(u_random_btemps(2,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch3_BT',change_type_zero_nan('int16',squeeze(u_random_btemps(3,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch4_BT',change_type_zero_nan('int16',squeeze(u_random_btemps(4,:,:))*invscfac_ur))
  ncwrite(filenamenew,'/u_independent_Ch5_BT',change_type_zero_nan('int16',squeeze(u_random_btemps(5,:,:))*invscfac_ur))
  
  invscfac_unr=1e4;
  scfac_unr=1/invscfac_unr;
  ncwrite(filenamenew,'/u_structured_Ch1_BT',change_type_zero_nan('int16',squeeze(u_nonrandom_btemps(1,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch2_BT',change_type_zero_nan('int16',squeeze(u_nonrandom_btemps(2,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch3_BT',change_type_zero_nan('int16',squeeze(u_nonrandom_btemps(3,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch4_BT',change_type_zero_nan('int16',squeeze(u_nonrandom_btemps(4,:,:))*invscfac_unr))
  ncwrite(filenamenew,'/u_structured_Ch5_BT',change_type_zero_nan('int16',squeeze(u_nonrandom_btemps(5,:,:))*invscfac_unr))
  
  %ncwrite(filenamenew,'/u_structuredrandom_btemps',size(btempsK))
  
  
  
  %% write attributes
 ncwriteatt(filenamenew,'/','Conventions',['tbd']); %setting these conventions to CF-1.6 makes geolocation for Panoply impossible. Probably since CF conventions require a certain array for Lat and Lon: lat(lat), lon(lon), not 2dimensional!
 ncwriteatt(filenamenew,'/','institution',['Universitaet Hamburg']);
 if length(hdrinfo.dataset_name)==2
 ncwriteatt(filenamenew,'/','source',['original l1b-filename (downloaded from NOAA-CLASS): ',char(hdrinfo.dataset_name{1}),' ', char(hdrinfo.dataset_name{2} )]);%cell2mat(that_file(selectorbit))
 else
 ncwriteatt(filenamenew,'/','source',['original l1b-filename (downloaded from NOAA-CLASS): ',char(hdrinfo.dataset_name{1})]);%cell2mat(that_file(selectorbit))
 end
 ncwriteatt(filenamenew,'/','title',['Microwave humidity sounder Easy-Fundamental Climate Data Record (MW-Easy-FCDR)']);
 ncwriteatt(filenamenew,'/','history',[]);
 ncwriteatt(filenamenew,'/','references',[]);
 ncwriteatt(filenamenew,'/','id',['product doi will be placed here']);
 ncwriteatt(filenamenew,'/','naming_authority',['Institution that published the doi']);
 ncwriteatt(filenamenew,'/','licence',['This dataset is released for use under CC-BY licence (https://creativecommons.org/licenses/by/4.0/) and was developed in the EC \n', ...
                                   'FIDUCEO project Fidelity and Uncertainty in Climate Data Records from Earth Observations. Grant Agreement: 638822.']);
 ncwriteatt(filenamenew,'/','writer_version',['MATLAB script write_easyFCDR_orbitfile.m']);
 
% further flags added by IHans 
ncwriteatt(filenamenew,'/','satellite',[sat]);
ncwriteatt(filenamenew,'/','instrument',[sen]);
%ncwriteatt(filenamenew,'/','satellite_instrument_date',[satsenyear,'/',ymdhms_start(5:6),'/',ymdhms_start(7:8),'/']);
 ncwriteatt(filenamenew,'/','comment',['WARNING: This is an early pre-beta version. ']);
 %ncwriteatt(filenamenew,'/','comment',['The AAPP-7-13 geolocation is used.']);
 %ncwriteatt(filenamenew,'/','creation_date',datestr(now));
 %ncwriteatt(filenamenew,'/','original_l1bfilename',cell2mat(that_file(selectorbit)));
 %ncwriteatt(filenamenew,'/','ProcessingCode',['MATLAB function generate_FCDR.m']);
 %ncwriteatt(filenamenew,'/','Author',['Imke Hans']);
 
 ncwriteatt(filenamenew,'/','StartTimeOfOrbit',datestr(vectorstartdate));
 ncwriteatt(filenamenew,'/','EndTimeOfOrbit',datestr(vectorenddate));

 

 
 
 
 %ncwriteatt(filenamenew,'/scnlin','long_name',['Scan_line']);
 %ncwriteatt(filenamenew,'/scnlin','description',['scan line number. To remove overlap with next file, the end has been cut: Last scan line in original l1b file: ',num2str(length(scnlinetime_of_record))]);

 %ncwriteatt(filenamenew,'/scnlindy','long_name',['Day_of_Scan_line']);
 %ncwriteatt(filenamenew,'/scnlindy','description',['Acquisition day of the scan line as Day-of-Year.']);

 ncwriteatt(filenamenew,'/scnlintime','long_name',['Time_of_Scan_line']);
 ncwriteatt(filenamenew,'/scnlintime','units',['s']);
 ncwriteatt(filenamenew,'/scnlintime','description',['Acquisition time of the scan line in seconds since 1970-01-01 00:00:00.']);

 %ncwriteatt(filenamenew,'/scnlinyr','long_name',['Year_of_Scan_line']);
 %ncwriteatt(filenamenew,'/scnlinyr','description',['Acquisition year of the scan line.']);

 ncwriteatt(filenamenew,'/scnlin_origl1b','long_name',['Original_Scan_line_number']);
 ncwriteatt(filenamenew,'/scnlin_origl1b','description',['Original scan line numbers from corresponding l1b records.']);
 %It might occur that both scan line \n',...
 %    'number and recorded time show a jump. Apparently some scans were not executed while time recording continued.\n'...
 %    'The resulting jump in scan line number is corrected in this FCDR: The scnlin variable contains continuous numbering.  ']);

 % QUALITY FLAGS
 % Summary: quality_pixel_ChX_bitmask
 ncwriteatt(filenamenew,'/quality_pixel_Ch1_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch1_bitmask','long_name',['Bitmask for quality per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch1_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit5-8: zero_fill\n',...
     'bit4: DATA_IN_NEXT_OR_PREV_FILE \n',...
     'bit3: DO_NOT_USE_INVALID_UNCERTAINTY \n',...
     'bit2: DO_NOT_USE_SENSOR_FAILURE \n',...
     'bit1: USE_WITH_CAUTION \n']);
 
 ncwriteatt(filenamenew,'/quality_pixel_Ch2_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch2_bitmask','long_name',['Bitmask for quality per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch2_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit5-8: zero_fill\n',...
     'bit4: DATA_IN_NEXT_OR_PREV_FILE \n',...
     'bit3: DO_NOT_USE_INVALID_UNCERTAINTY \n',...
     'bit2: DO_NOT_USE_SENSOR_FAILURE \n',...
     'bit1: USE_WITH_CAUTION \n']);
 
 ncwriteatt(filenamenew,'/quality_pixel_Ch3_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch3_bitmask','long_name',['Bitmask for quality per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch3_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit5-8: zero_fill\n',...
     'bit4: DATA_IN_NEXT_OR_PREV_FILE \n',...
     'bit3: DO_NOT_USE_INVALID_UNCERTAINTY \n',...
     'bit2: DO_NOT_USE_SENSOR_FAILURE \n',...
     'bit1: USE_WITH_CAUTION \n']);
 
 ncwriteatt(filenamenew,'/quality_pixel_Ch4_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch4_bitmask','long_name',['Bitmask for quality per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch4_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit5-8: zero_fill\n',...
     'bit4: DATA_IN_NEXT_OR_PREV_FILE \n',...
     'bit3: DO_NOT_USE_INVALID_UNCERTAINTY \n',...
     'bit2: DO_NOT_USE_SENSOR_FAILURE \n',...
     'bit1: USE_WITH_CAUTION \n']);
 
 ncwriteatt(filenamenew,'/quality_pixel_Ch5_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch5_bitmask','long_name',['Bitmask for quality per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_pixel_Ch5_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit5-8: zero_fill\n',...
     'bit4: DATA_IN_NEXT_OR_PREV_FILE \n',...
     'bit3: DO_NOT_USE_INVALID_UNCERTAINTY \n',...
     'bit2: DO_NOT_USE_SENSOR_FAILURE \n',...
     'bit1: USE_WITH_CAUTION \n']);
 
 
 % General issues: quality_issue_scnlin_bitmask
 ncwriteatt(filenamenew,'/quality_issue_scnlin_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_scnlin_bitmask','long_name',['Bitmask for quality issues per scanline']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_scnlin_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit6-8: zero_fill\n',...
     'bit5: MISSING_SCANLINE \n',...
     'bit4: SUSPECT_GEOLOCATION \n',...
     'bit3: SUSPECT_TIMING \n',...
     'bit2: NO_CALIB_BAD_PRT \n',...
     'bit1: SUSPECT_CALIB_PRT \n']);
 
 % Channel specific issues: quality_issue_pixel_ChX_bitmask
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch1_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch1_bitmask','long_name',['Bitmask for quality issues per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch1_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit4-8: zero_fill\n',...
     'bit3: BAD_DATA_EARTHVIEW \n',...
     'bit2: NO_CALIB_BAD_IWCT_DSV \n',...
     'bit1: SUSPECT_CALIB_IWCT_DSV\n']);
 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch2_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch2_bitmask','long_name',['Bitmask for quality issues per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch2_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit4-8: zero_fill\n',...
     'bit3: BAD_DATA_EARTHVIEW \n',...
     'bit2: NO_CALIB_BAD_IWCT_DSV \n',...
     'bit1: SUSPECT_CALIB_IWCT_DSV\n']);
 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch3_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch3_bitmask','long_name',['Bitmask for quality issues per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch3_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit4-8: zero_fill\n',...
     'bit3: BAD_DATA_EARTHVIEW \n',...
     'bit2: NO_CALIB_BAD_IWCT_DSV \n',...
     'bit1: SUSPECT_CALIB_IWCT_DSV\n']);
 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch4_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch4_bitmask','long_name',['Bitmask for quality issues per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch4_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit4-8: zero_fill\n',...
     'bit3: BAD_DATA_EARTHVIEW \n',...
     'bit2: NO_CALIB_BAD_IWCT_DSV \n',...
     'bit1: SUSPECT_CALIB_IWCT_DSV\n']);
 
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch5_bitmask','standard_name',['status_flag']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch5_bitmask','long_name',['Bitmask for quality issues per pixel']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
 ncwriteatt(filenamenew,'/quality_issue_pixel_Ch5_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
     'bit4-8: zero_fill\n',...
     'bit3: BAD_DATA_EARTHVIEW \n',...
     'bit2: NO_CALIB_BAD_IWCT_DSV \n',...
     'bit1: SUSPECT_CALIB_IWCT_DSV\n']);
 
 % GEOLOCATION

 ncwriteatt(filenamenew,'/latitude','standard_name',['latitude']);
 ncwriteatt(filenamenew,'/latitude','long_name',['latitude']);
 ncwriteatt(filenamenew,'/latitude','units',['degree north']);
 ncwriteatt(filenamenew,'/latitude','scale_factor',scfac_latlon); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/latitude','description',['Latitude for each pixel in every scanline.']);
 

 ncwriteatt(filenamenew,'/longitude','standard_name',['longitude']);
 ncwriteatt(filenamenew,'/longitude','long_name',['longitude']);
 ncwriteatt(filenamenew,'/longitude','units',['degree east']);
 ncwriteatt(filenamenew,'/longitude','scale_factor',scfac_latlon); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/longitude','description',['Longitude for each pixel in every scanline.']);
 

 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','long_name',['Satellite_azimuth_angle']);
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Satellite_azimuth_angle','description',['Satellite azimuth angle for each pixel in every scanline.']);
 

 ncwriteatt(filenamenew,'/Satellite_zenith_angle','long_name',['Satellite_zenith_angle']);
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Satellite_zenith_angle','description',['Satellite zenith angle for each pixel in every scanline.']);
 

 ncwriteatt(filenamenew,'/Solar_azimuth_angle','standard_name',['solar_azimuth_angle']);
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','long_name',['Solar_azimuth_angle']);
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Solar_azimuth_angle','description',['Solar azimuth angle for each pixel in every scanline.']);
 

 ncwriteatt(filenamenew,'/Solar_zenith_angle','standard_name',['solar_zenith_angle']);
 ncwriteatt(filenamenew,'/Solar_zenith_angle','long_name',['Solar_zenith_angle']);
 ncwriteatt(filenamenew,'/Solar_zenith_angle','units',['degree']);
 ncwriteatt(filenamenew,'/Solar_zenith_angle','scale_factor',scfac_angles); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Solar_zenith_angle','description',['Solar zenith angle for each pixel in every scanline.']);
 
 
 % btemps

 ncwriteatt(filenamenew,'/Ch1_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch1_BT','long_name',['channel1-89.0pm0.9GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch1_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch1_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch1_BT','ancillary_variables',['chanqual, qualind, scanqual']);
 ncwriteatt(filenamenew,'/Ch1_BT','description',['channel 1 brightness temperature per scanline and view']);
 
 
 ncwriteatt(filenamenew,'/Ch2_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch2_BT','long_name',['channel2-150.0pm0.9GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch2_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch2_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch2_BT','ancillary_variables',['chanqual, qualind, scanqual']);
 ncwriteatt(filenamenew,'/Ch2_BT','description',['channel 2 brightness temperature per scanline and view']);
 
 
 ncwriteatt(filenamenew,'/Ch3_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch3_BT','long_name',['channel3-183.311pm1GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch3_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch3_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch3_BT','ancillary_variables',['chanqual, qualind, scanqual']);
 ncwriteatt(filenamenew,'/Ch3_BT','description',['channel 3 brightness temperature per scanline and view']);
 

 ncwriteatt(filenamenew,'/Ch4_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch4_BT','long_name',['channel4-183.311pm3GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch4_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch4_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch4_BT','ancillary_variables',['chanqual, qualind, scanqual']);
 ncwriteatt(filenamenew,'/Ch4_BT','description',['channel 4 brightness temperature per scanline and view']);
 
 
 ncwriteatt(filenamenew,'/Ch5_BT','standard_name',['toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch5_BT','long_name',['channel5-183.311pm7GHz_toa_brightness_temperature']);
 ncwriteatt(filenamenew,'/Ch5_BT','units',['K']);
 ncwriteatt(filenamenew,'/Ch5_BT','scale_factor',scfac_bt); %FIXME: need to adapt to smallest uncertainty!
 ncwriteatt(filenamenew,'/Ch5_BT','ancillary_variables',['chanqual, qualind, scanqual']);
 ncwriteatt(filenamenew,'/Ch5_BT','description',['channel 5 brightness temperature per scanline and view']);
 
 % UNCERTAINTIES
 

 ncwriteatt(filenamenew,'/u_independent_Ch1_BT','long_name',['uncertainty_of_channel1_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch1_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch1_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch1_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch2_BT','long_name',['uncertainty_of_channel2_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch2_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch2_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch2_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch3_BT','long_name',['uncertainty_of_channel3_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch3_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch3_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch3_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch4_BT','long_name',['uncertainty_of_channel4_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch4_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch4_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch4_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_independent_Ch5_BT','long_name',['uncertainty_of_channel5_toa_brightness_temperature_independent_effects']);
 ncwriteatt(filenamenew,'/u_independent_Ch5_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_independent_Ch5_BT','scale_factor',scfac_ur); 
 ncwriteatt(filenamenew,'/u_independent_Ch5_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered independent effects of uncertainty.']);
 
 

 ncwriteatt(filenamenew,'/u_structured_Ch1_BT','long_name',['uncertainty_of_channel1_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch1_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch1_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch1_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 
 
 ncwriteatt(filenamenew,'/u_structured_Ch2_BT','long_name',['uncertainty_of_channel2_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch2_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch2_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch2_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_structured_Ch3_BT','long_name',['uncertainty_of_channel3_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch3_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch3_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch3_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 

 ncwriteatt(filenamenew,'/u_structured_Ch4_BT','long_name',['uncertainty_of_channel4_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch4_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch4_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch4_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 
 
 ncwriteatt(filenamenew,'/u_structured_Ch5_BT','long_name',['uncertainty_of_channel5_toa_brightness_temperature_structured_effects']);
 ncwriteatt(filenamenew,'/u_structured_Ch5_BT','units',['K']);
 ncwriteatt(filenamenew,'/u_structured_Ch5_BT','scale_factor',scfac_unr); 
 ncwriteatt(filenamenew,'/u_structured_Ch5_BT','description',['Uncertainty of the TOA brightness temperature. Contains all considered structured effects of uncertainty.']);
 


%  ncwriteatt(filenamenew,'/u_total_Ch1_BT','long_name',['total_uncertainty_of_channel1_toa_brightness_temperature']);
%  ncwriteatt(filenamenew,'/u_total_Ch1_BT','units',['K']);
%  ncwriteatt(filenamenew,'/u_total_Ch1_BT','scale_factor',scfac_u); 
%  ncwriteatt(filenamenew,'/u_total_Ch1_BT','description',['Total uncertainty of the TOA brightness temperature. Contains all considered effects of uncertainty.']);
%  
% 
%  ncwriteatt(filenamenew,'/u_total_Ch2_BT','long_name',['total_uncertainty_of_channel2_toa_brightness_temperature']);
%  ncwriteatt(filenamenew,'/u_total_Ch2_BT','units',['K']);
%  ncwriteatt(filenamenew,'/u_total_Ch2_BT','scale_factor',scfac_u); 
%  ncwriteatt(filenamenew,'/u_total_Ch2_BT','description',['Total uncertainty of the TOA brightness temperature. Contains all considered effects of uncertainty.']);
%  
% 
%  ncwriteatt(filenamenew,'/u_total_Ch3_BT','long_name',['total_uncertainty_of_channel3_toa_brightness_temperature']);
%  ncwriteatt(filenamenew,'/u_total_Ch3_BT','units',['K']);
%  ncwriteatt(filenamenew,'/u_total_Ch3_BT','scale_factor',scfac_u); 
%  ncwriteatt(filenamenew,'/u_total_Ch3_BT','description',['Total uncertainty of the TOA brightness temperature. Contains all considered effects of uncertainty.']);
%  
% 
%  ncwriteatt(filenamenew,'/u_total_Ch4_BT','long_name',['total_uncertainty_of_channel4_toa_brightness_temperature']);
%  ncwriteatt(filenamenew,'/u_total_Ch4_BT','units',['K']);
%  ncwriteatt(filenamenew,'/u_total_Ch4_BT','scale_factor',scfac_u); 
%  ncwriteatt(filenamenew,'/u_total_Ch4_BT','description',['Total uncertainty of the TOA brightness temperature. Contains all considered effects of uncertainty.']);
%  
% 
%  ncwriteatt(filenamenew,'/u_total_Ch5_BT','long_name',['total_uncertainty_of_channel5_toa_brightness_temperature']);
%  ncwriteatt(filenamenew,'/u_total_Ch5_BT','units',['K']);
%  ncwriteatt(filenamenew,'/u_total_Ch5_BT','scale_factor',scfac_u); 
%  ncwriteatt(filenamenew,'/u_total_Ch5_BT','description',['Total uncertainty of the TOA brightness temperature. Contains all considered effects of uncertainty.']);
%  
%  
 
 disp('Done. NetCDF file located in')
 disp(filenamenew)
 
 
 
 %% outdated flags
 %  ncwriteatt(filenamenew,'/qual_scnlin_bitmask','long_name',['qualityflag_scanline_bitmask']); %read out as dec2bin(typecast(int8(qual_scnlin_bitmask),'uint8'),8)
%  ncwriteatt(filenamenew,'/qual_scnlin_bitmask','description',['Bitmask containing quality flags (1= statement is true):\n',...
%      'bit8: Do not use this scan line for product generation.\n',...
%      'bit7: Suspect geolocation for this scan line.\n',...
%      'bit6: Suspect timing for this scan line.\n',...
%      'bit5: Suspect calibration for this scan line.\n',...
%      'bit4: Moon is close to DSVs, but has no significant impact.\n',...
%      'bit3: MOON INTRUSION: At least one DSV is NOT contaminated by the moon. \n',...
%      'bit2: MOON INTRUSION: All 4 DSVs are contaminated. Last scan line before moon intrusion is used for calibration.\n',...
%      'bit1: Missing scan line (data gap). Filled with NaN or fill values. ']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch1_bitmask','long_name',['qualityflag_scanline_Ch1_bitmask']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch1_bitmask','description',['Bitmask containing quality flags for Channel 1 (1= statement is true):\n',...
%      'bit8: Do not use this channel for this scan line. Suspect calibration. OBCT, DSV or PRT data suspicious.\n',...
%      'bit7: No complete uncertainty information available. \n',...
%      'bit6-1:  zero fill ']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch2_bitmask','long_name',['qualityflag_scanline_Ch2_bitmask']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch2_bitmask','description',['Bitmask containing quality flags for Channel 2 (1= statement is true): \n',...
%      'bit8: Do not use this channel for this scan line. Suspect calibration. OBCT, DSV or PRT data suspicious.\n',...
%      'bit7: No complete uncertainty information available. \n',...
%      'bit6-1:  zero fill ']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch3_bitmask','long_name',['qualityflag_scanline_Ch3_bitmask']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch3_bitmask','description',['Bitmask containing quality flags for Channel 3 (1= statement is true): \n',...
%      'bit8: Do not use this channel for this scan line. Suspect calibration. OBCT, DSV or PRT data suspicious.\n',...
%      'bit7: No complete uncertainty information available. \n',...
%      'bit6-1:  zero fill ']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch4_bitmask','long_name',['qualityflag_scanline_Ch4_bitmask']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch4_bitmask','description',['Bitmask containing quality flags for Channel 4 (1= statement is true): \n',...
%      'bit8: Do not use this channel for this scan line. Suspect calibration. OBCT, DSV or PRT data suspicious.\n',...
%      'bit7: No complete uncertainty information available. \n',...
%      'bit6-1:  zero fill ']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch5_bitmask','long_name',['qualityflag_scanline_Ch5_bitmask']);
%  ncwriteatt(filenamenew,'/qual_scnlin_Ch5_bitmask','description',['Bitmask containing quality flags for Channel 5 (1= statement is true): \n',...
%      'bit8: Do not use this channel for this scan line. Suspect calibration. OBCT, DSV or PRT data suspicious.\n',...
%      'bit7: No complete uncertainty information available. \n',...
%      'bit6-1:  zero fill ']);
%  
%  