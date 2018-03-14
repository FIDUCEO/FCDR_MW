

% setup_MHS_processing2l1c.m

%
 % Copyright (C) 2017-04-12 Imke Hans
 % This code was developed for the EC project �Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)�. 
 % Grant Agreement: 638822
 %  <Version> Reviewed and approved by <name, instituton>, <date>
 %
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
%
% ONLY USE this script via calling function generate_FCDR.m
% DO NOT use this script alone. It needs the output from preceeding
% functions generate_FCDR.

% Script for SET UP of fullFCDR processing including uncertatiny
% propagation.
% Script that reads in all l1b data and calibration coefficients from a certain
% orbit that are needed for the Measurement equation and its derivatives 
% and calculates the scanline-averaging for counts and the bias corrections
% and non-linearity via interpolations. It also calls the script
% calculate_AllanDeviation_onCounts.m to calculate the uncertainty on the
% DSV and IWCT counts.
% 


% output: all quantities needed for the measurement equation/ its derivatives. 
% They are stored in matrices/ vectors for all channels and scanlines of 
% the chosen orbit.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



 %%%%%%%%%%%%% START:   READ IN VARIABLES FROM EQUATOR to EQEQUATOR L1B-DATA FILE %%%%%%%%%%%%%% 
 


%% collect filenames of used l1b files
% needed also for mooncheck.m, since this routine looks for corresponding
% external files containing info on moon intrusion
% Here, a variable nameoffile is created (needed in mooncheck), containing only the filename (no
% path). This filename is save to hdrinfo.dataset_name.
if length(hdrinfo.dataset_name)>1
    for i=1:length(hdrinfo.dataset_name)
           
             if strcmp(hdrinfo.dataset_name{i}(end-3:end),'.bz2')
                   nameoffile{i}=hdrinfo.dataset_name{i}(cut:end-4);
                   ending='.bz2';
             elseif strcmp(hdrinfo.dataset_name{i}(end-2:end),'.gz')
                   nameoffile{i}=hdrinfo.dataset_name{i}(cut:end-3);
                   ending='.gz';
             else
                 disp(['Unknown ending of file name:',hdrinfo.dataset_name{i}(end-2:end)])
                 return
             end
        
        hdrinfo.dataset_name{i}=strcat(nameoffile{i},ending);
    end
else
           
         if strcmp(hdrinfo.dataset_name{:}(end-3:end),'.bz2')
               nameoffile=hdrinfo.dataset_name{:}(cut:end-4);
               ending='.bz2';
         elseif strcmp(hdrinfo.dataset_name{:}(end-2:end),'.gz')
               nameoffile=hdrinfo.dataset_name{:}(cut:end-3);
               ending='.gz';
         else
               disp(['Unknown ending of file name:',hdrinfo.dataset_name{:}(end-2:end)])
               return
         end
    
    hdrinfo.dataset_name={strcat(nameoffile,ending)};
end


            
                       %% READ AND CALCULATE
%%%%%%%%%%%%% BASICS %%%%%%%%%%%%%%%%%
                       number_of_fovs=90; %number of Field of Views of the Earth
                        
                       % add take only the 3rd and the 3rd to last line for
                       % the vectorstartdate: this is for the filename
                       datayearstart=double(data.scan_line_year(1+3));
                       datadoystart=double(data.scan_line_day_of_year(1+3));
                       datautcstart=double(data.scan_line_UTC_time(1+3));%in milliseconds
                       datayearend=double(data.scan_line_year(end-3));
                       datadoyend=double(data.scan_line_day_of_year(end-3));
                       datautcend=double(data.scan_line_UTC_time(end-3));%in milliseconds
                       
                       vectorstartdate=datevec(doy2date(datadoystart,datayearstart));
                       vectorenddate=datevec(doy2date(datadoyend,datayearend));


                       % convert from milliseconds to hours, minutes, seconds
                       [vectorstartdate(4),vectorstartdate(5),vectorstartdate(6)]=mills2hmsmill(datautcstart);
                       [vectorenddate(4),vectorenddate(5),vectorenddate(6)]=mills2hmsmill(datautcend);
                       
                       
                       scnlinyr=data.scan_line_year;
                       scnlindy=data.scan_line_day_of_year;
                       scnlintime=data.scan_line_UTC_time;
                       
                       scanlinenumbers=double(data.scan_line_number);
                      
                       scanlinenumbers_original=scanlinenumbers;
                      
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% Filling of missing scan lines %%%%%%%%%%%%%%%%%%%%%%%%%
% [scanlinenumbers,]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,)
% you have to do this for every variable! Especially also for
% data.scan_line_number, since it is used in many scripts/functions!

[scanlinenumbers,scnlinyr]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(scnlinyr));
data.scan_line_number=scanlinenumbers; %set the data.scan_line_number to the new scanlinenumbers (inlcuding missing scanlines)
[~,data.scan_line_year]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scan_line_year));

missing_scanlines=double(scanlinenumbers(find(isnan(scnlinyr))));
number_of_datagaps=length(missing_scanlines);

[scanlinenumbers,scnlindy]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(scnlindy));
[scanlinenumbers,scnlintime]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(scnlintime));

% creating a vector containing the original scanline numbers from l1b files
% per new scanlinenumber
[~,scnlin_original_l1bs]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.orig_scnlinnum));

%fill missing lines in vector containing 0,1,.. for indicating number of the use file (to
%be related to global attribute "source" listing the filenames)
[~,map_line2l1bfile]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.map_line2l1bfile));


% fill latitude and longitude
lat_data=nan*zeros(90,scanlinenumbers(end));
long_data=nan*zeros(90,scanlinenumbers(end));
rel_az_ang_data=nan*zeros(90,scanlinenumbers(end));
sat_zen_ang_data=nan*zeros(90,scanlinenumbers(end));
sol_zen_ang_data=nan*zeros(90,scanlinenumbers(end));

for view=1:90
[~,lat_data(view,:)]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.earth_location_latitude_FOVXX(view,:)));
[~,long_data(view,:)]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.earth_location_longitude_FOVXX(view,:)));
[~,rel_az_ang_data(view,:)]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.angular_relationships_relative_azimuth_angle_FOVXX(view,:)));
[~,sat_zen_ang_data(view,:)]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.angular_relationships_satellite_zenith_angle_FOVXX(view,:)));
[~,sol_zen_ang_data(view,:)]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.angular_relationships_solar_zenith_angle_FOVXX(view,:)));

end



% introduce flag to flag filled up (i.e. missing) scanlines
qualflag_missing_scanline=zeros(length(scanlinenumbers),1);
qualflag_missing_scanline(missing_scanlines)=1;
%set flag for scan that follows data gap
qualflag_datagapbeforethisscan=zeros(length(scanlinenumbers),1);
if ~isempty(missing_scanlines)
qualflag_datagapbeforethisscan(missing_scanlines+ones(size(missing_scanlines)))=1;
end
%fill up scanlines for every variable now:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                       
                     

%%%%%%%%%% Convert time to seconds scine 1970
vectordate=datevec(doy2date(scnlindy,scnlinyr));
[vectordate(:,4),vectordate(:,5),vectordate(:,6)]=mills2hmsmill(scnlintime);

InputDate=datenum(vectordate);
UnixOrigin=datenum('19700101 000000','yyyymmdd HHMMSS');

time_EpochSecond=round((InputDate-UnixOrigin)*86400);
%%%%%%%%%%%%%

% direction of satellite: 1=southbound 0=northbound
[~,sat_dir]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scan_line_satellite_direction));


% calculate solar and satellite azimuth angles from time and latitude per
% pixel
calculate_solarAndsatellite_azimuth_angle

%%%%%%%%%%%%% SPECTRAL RESPONSE FUNCTION %%%%%%%%%%%%%%%%
% read spectral response function from set_coeffs file for LOA and LOB (local oscillator A and B)
% read which LO is in use
LO_in_use=hdrinfo.instrument_status_PIE_ID;
% choose corresponding SRF values
if LO_in_use==0
    % Local oscillator A is used
    srf_weights=srf_weight_a;
    srf_frequencies=srf_frequency_a;
    
else 
    % Local oscillator B is used
    srf_weights=srf_weight_b;
    srf_frequencies=srf_frequency_b;
end
%%%%%%%%%%%%%   COUNTS  %%%%%%%%%%%%%%%%%%%%%
                      
                           % DSV COUNTS
                           % read DSV counts and fill missing scanlines with nan  
                                [~,dsv1ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view1_Ch_H1));
                                [~,dsv1ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view1_Ch_H2));
                                [~,dsv1ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view1_Ch_H3));
                                [~,dsv1ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view1_Ch_H4));
                                [~,dsv1ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view1_Ch_H5));
                                
                                [~,dsv2ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view2_Ch_H1));
                                [~,dsv2ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view2_Ch_H2));
                                [~,dsv2ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view2_Ch_H3));
                                [~,dsv2ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view2_Ch_H4));
                                [~,dsv2ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view2_Ch_H5));
                                
                                [~,dsv3ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view3_Ch_H1));
                                [~,dsv3ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view3_Ch_H2));
                                [~,dsv3ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view3_Ch_H3));
                                [~,dsv3ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view3_Ch_H4));
                                [~,dsv3ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view3_Ch_H5));
                                
                                [~,dsv4ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view4_Ch_H1));
                                [~,dsv4ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view4_Ch_H2));
                                [~,dsv4ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view4_Ch_H3));
                                [~,dsv4ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view4_Ch_H4));
                                [~,dsv4ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_counts_space_view4_Ch_H5));
                     
                              
                                
                                dsvch1=double([dsv1ch1;dsv2ch1;dsv3ch1;dsv4ch1]).';
                                dsvch2=double([dsv1ch2;dsv2ch2;dsv3ch2;dsv4ch2]).';
                                dsvch3=double([dsv1ch3;dsv2ch3;dsv3ch3;dsv4ch3]).';
                                dsvch4=double([dsv1ch4;dsv2ch4;dsv3ch4;dsv4ch4]).';
                                dsvch5=double([dsv1ch5;dsv2ch5;dsv3ch5;dsv4ch5]).';
                               
                               
                               
                               % DSV-mean per scanline
                               dsv_mean(:,1)=mean(double([dsv1ch1; dsv2ch1; dsv3ch1; dsv4ch1]),1);
                               dsv_mean(:,2)=mean(double([dsv1ch2; dsv2ch2; dsv3ch2; dsv4ch2]),1);
                               dsv_mean(:,3)=mean(double([dsv1ch3; dsv2ch3; dsv3ch3; dsv4ch3]),1);
                               dsv_mean(:,4)=mean(double([dsv1ch4; dsv2ch4; dsv3ch4; dsv4ch4]),1);
                               dsv_mean(:,5)=mean(double([dsv1ch5; dsv2ch5; dsv3ch5; dsv4ch5]),1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              
                               
                                                    
                                
                      % IWCT COUNTS
                      
                                [~,iwct1ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view1_Ch_H1));
                                [~,iwct1ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view1_Ch_H2));
                                [~,iwct1ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view1_Ch_H3));
                                [~,iwct1ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view1_Ch_H4));
                                [~,iwct1ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view1_Ch_H5));
                                
                                [~,iwct2ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view2_Ch_H1));
                                [~,iwct2ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view2_Ch_H2));
                                [~,iwct2ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view2_Ch_H3));
                                [~,iwct2ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view2_Ch_H4));
                                [~,iwct2ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view2_Ch_H5));
                                
                                [~,iwct3ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view3_Ch_H1));
                                [~,iwct3ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view3_Ch_H2));
                                [~,iwct3ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view3_Ch_H3));
                                [~,iwct3ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view3_Ch_H4));
                                [~,iwct3ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view3_Ch_H5));
                                
                                [~,iwct4ch1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view4_Ch_H1));
                                [~,iwct4ch2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view4_Ch_H2));
                                [~,iwct4ch3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view4_Ch_H3));
                                [~,iwct4ch4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view4_Ch_H4));
                                [~,iwct4ch5]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_counts_OBCT_view4_Ch_H5));
                                
                                %collect 4 views for each channel
                                iwctch1=double([iwct1ch1; iwct2ch1; iwct3ch1; iwct4ch1].');
                                iwctch2=double([iwct1ch2; iwct2ch2; iwct3ch2; iwct4ch2].');
                                iwctch3=double([iwct1ch3; iwct2ch3; iwct3ch3; iwct4ch3].');
                                iwctch4=double([iwct1ch4; iwct2ch4; iwct3ch4; iwct4ch4].');
                                iwctch5=double([iwct1ch5; iwct2ch5; iwct3ch5; iwct4ch5].');
                                
                              
                               
                               % IWCT-mean per scanline
                               iwct_mean(:,1)=mean(double([iwct1ch1; iwct2ch1; iwct3ch1; iwct4ch1]),1);
                               iwct_mean(:,2)=mean(double([iwct1ch2; iwct2ch2; iwct3ch2; iwct4ch2]),1);
                               iwct_mean(:,3)=mean(double([iwct1ch3; iwct2ch3; iwct3ch3; iwct4ch3]),1);
                               iwct_mean(:,4)=mean(double([iwct1ch4; iwct2ch4; iwct3ch4; iwct4ch4]),1);
                               iwct_mean(:,5)=mean(double([iwct1ch5; iwct2ch5; iwct3ch5; iwct4ch5]),1);
                               
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                            % calculate the PRELIMINARY noise on counts with Allan
                            % Deviation: median of the count noise within
                            % the orbit (per channel). Needed as input for quality checks
                            % that use the median-tests on IWCT and DSV counts
                                calculate_AllanDeviation_DSV_IWCT_withoutQualflags
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 
                               
    %%%%%%%%%%%%%%%%%%%        
                         % EARTH COUNTS       
                                
                                % iteration over 90 earth views
                                for view=1:number_of_fovs
                                    [~,earthcounts_ch1(view,:)]= fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H1(view,:)));
                                    [~,earthcounts_ch2(view,:)]= fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H2(view,:)));
                                    [~,earthcounts_ch3(view,:)]= fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H3(view,:)));
                                    [~,earthcounts_ch4(view,:)]= fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H4(view,:)));
                                    [~,earthcounts_ch5(view,:)]= fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scene_earth_view_data_scene_counts_FOV_XX_Ch_H5(view,:)));
                                end
                                
                                
                                earthcounts=earthcounts_ch1;
                                earthcounts(:,:,2)=earthcounts_ch2;
                                earthcounts(:,:,3)=earthcounts_ch3;
                                earthcounts(:,:,4)=earthcounts_ch4;
                                earthcounts(:,:,5)=earthcounts_ch5;
                                
                                earthcounts=permute(earthcounts,[3 1 2]);
                                
                               
                               
%%%%%%%%%%%%%%%%%%%%
                           
                         % PRT TEMPERATURE
                         
                          % PRT temperatures (only for MHS there are these calculated Temp in the record)                         
                            [~,PRT1temp]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.computed_OBCT_temperature1_PRT1_based));
                            [~,PRT2temp]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.computed_OBCT_temperature2_PRT2_based));
                            [~,PRT3temp]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.computed_OBCT_temperature3_PRT3_based));
                            [~,PRT4temp]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.computed_OBCT_temperature4_PRT4_based));
                            [~,PRT5temp]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.computed_OBCT_temperature5_PRT5_based));
                            
                            PRTtemps=[PRT1temp;PRT2temp;PRT3temp;PRT4temp;PRT5temp];
                            
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%    END calibration counts %%%%%%%%%%%                         
                            
                            
 %%%%%%%%%%%%%%%%%%%%%%% PERPARING FOR CALIBRATION  %%%%%%%%%%%%%%%%%%%%%%                       
 % Moonintrusion-check
 % Qualitychecks
 % Noise estimation
 % 7-scanline average
 % Uncertainties of calibr. quantities
 % Usable channels
 % Calibration Coefficients
                            
                            %%%%%%%%%% MOONINTRUSION -CHECK %%%%%%%%%%%%%%%
                            
                            % Mooncheck for DSV
                            
                            % initialize moon flags with zero

                            moonflagMoonCloserButNotSignificant=zeros(length(scnlinyr),1);
                            moonflagSignificantMoonIntrusion=moonflagMoonCloserButNotSignificant;       % not appearing in final set of flags, since redundant
                            moonflagOneViewOk=moonflagMoonCloserButNotSignificant;                      % this flag may be only set if "SignificantMoonIntrusion" is set to 1
                            moonflagAllViewsBad=moonflagMoonCloserButNotSignificant;                    % this flag may be only set if "SignificantMoonIntrusion" is set to 1
                            moonflagwhichviewbad=zeros(length(scnlinyr),4);                             % 4 for four DSV views


                            
                            mooncheck_processing
                            
                            %%%%%%%%%%%%%%% QUALITYCHECKS %%%%%%%%%%%%%%%%
                            % Quality checks on DSV, IWCT, PRT, Earthcounts
                            
                                % DSV
                                qualitychecksDSV_allchn

                                % IWCT
                                qualitychecksIWCT_allchn

                                % PRT
                                qualitychecksPRT_allsensors
                                
                                if onlybadPRTmeasurements==1
                                    return
                                end
                            
                                % earthcounts
                                qualitychecksEarthview
                                
                            %%%%%%%%%%%%% NOISE ESTIMATION %%%%%%%%%%%%%% 
                                                      
                            % Noise estimation on DSV, IWCT, PRT
                            
                                % calculate Allan Deviation    
                                 calculate_AllanDeviation_DSV_IWCT_PRT
                                 
                                 
                            %%%%%%%%%%%% 7- SCANLINE AVERAGE %%%%%%%%%%%%%    
                                
                            % 7-Scan-line average
                            % for DSV, IWCT, PRT and their noise estimates
                            % (Allan Dev.)
                            
                            % setup the average procedure, i.e identify
                            % lines to use (based on quality checks and
                            % missing lines). For DSV: reset the dsv_mean
                            % to the appropriate mean according to
                            % mooncheck (i.e. e.g. remove any
                            % 5-closest-estimate where there is at least 1
                            % DSV ok).
                            setup_roll_average
                            
                            % calculate the average
                            calculate_roll_average
                            
                            % list of variables containing the averaged
                            % values:
%                             countDSV_av
%                             countIWCT_av
%                             IWCTtemp_av
%                             AllanDev_countDSV_av
%                             AllanDev_countIWCT_av
%                             AllanDev_IWCTtemp_av
                            % There are further variables provided by
                            % calculate_roll_average: AllanDev without roll
                            % average but replaced values for the
                            % 5-closest-lines case:
%                             AllanDev_countDSV_NOav
%                             AllanDev_countIWCT_NOav
                            
                            
                        %%%%%%%%%%%%%%% UNCERTAINTY %%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%% Main calibration quantities %%%%%%%%%%%%%
                        
                            % assign the input uncertainties
                            
                            % for DSV
                                % with rolling average applied
                                u_C_S=AllanDev_countDSV_av;
                                % without (needed for eartchcounts noise
                                % estimation (earthcounts are NOT
                                % scanline-averaged)
                                u_C_S_0=AllanDev_countDSV_NOav;
                            
                            % for IWCT
                                % with rolling average applied
                                u_C_IWCT=AllanDev_countIWCT_av;
                                % without (needed for eartchcounts noise
                                % estimation (earthcounts are NOT
                                % scanline-averaged)
                                u_C_IWCT_0=AllanDev_countIWCT_NOav;
                                
                            % for PRT
                            % take value of 0.1K (uncertainty of one individual PRT
                            % sensor). Propagating through this value to the scanline-av-Temp (including 21111-weighting)
                            % by using the linear addition of uncertainties
                            % one obtains 0.1K for the overall uncertainty.
                            % We use the linear addition since the 0.1K per
                            % PRT sensor is a systematic uncertainty and
                            % all 5 PRT sensors could have the same
                            % deviation at the same time.
                            % systematic uncertainty (maybe add
                            % uncertainty due to possible gradient?)
                                u_T_IWCT=0.1*ones(size(IWCTtemp_av));
                            % random contribution    
                                u_T_IWCT_noise=AllanDev_IWCTtemp_av;
                                
                                
                            % for Earthcounts
                           % estimate uncertainty from u_C_S and
                           % u_C_IWCT: the uncertainty will be close to
                           % u_C_IWCT
                           % We estimate the uncertainty in earth
                           % counts like I indicate in the
                           % manuscript. This can only be done AFTER
                           % evaluation of the measurement Eq. since we
                           % need Tb. It is therefore done in
                           % uncertainty_propagation.m.

                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
                            
                            % USABLE CHANNELS
                            % Define which channels will actually be
                            % processed (some might be excluded if they
                            % have bad counts for the whole orbit).
                            % The qualitychecksXXX routines have identified
                            % the channels that need exclusion, and have
                            % prepared a channelset_iwct and _dsv defining
                            % usable channels. Hence we only use the
                            % channels that are common to these sets:
                            
                            channelset=intersect(channelset_iwct,channelset_dsv);   
                            
                            % note that IWCTtemp_av artificially has the
                            % channel dimension. This is needed for the
                            % measurement equation.
                            
                            % now, the variables IWCTtemp_av, countIWCT_av
                            % and countDSV_av can enter the measurement
                            % equation. 
                            
                            
                         %%%%%%%%%%%  CALIBRATION COEFFICIENTS %%%%%%%%%%%
      %%%%%%%%%%%%%%%%%   
       
                         % Temperature to radiance conversion
                         wavenumber_central=double([hdrinfo.temperature_radiance_Ch_H1_central_wavenumber; hdrinfo.temperature_radiance_Ch_H2_central_wavenumber; hdrinfo.temperature_radiance_Ch_H3_central_wavenumber; hdrinfo.temperature_radiance_Ch_H4_central_wavenumber; hdrinfo.temperature_radiance_Ch_H5_central_wavenumber]);
                         chnfreq=invcm2hz(wavenumber_central);
                         bandcorr_a=double([hdrinfo.temperature_radiance_Ch_H1_constant1; hdrinfo.temperature_radiance_Ch_H2_constant1; hdrinfo.temperature_radiance_Ch_H3_constant1; hdrinfo.temperature_radiance_Ch_H4_constant1; hdrinfo.temperature_radiance_Ch_H5_constant1]);
                         bandcorr_b=double([hdrinfo.temperature_radiance_Ch_H1_constant2; hdrinfo.temperature_radiance_Ch_H2_constant2; hdrinfo.temperature_radiance_Ch_H3_constant2; hdrinfo.temperature_radiance_Ch_H4_constant2; hdrinfo.temperature_radiance_Ch_H5_constant2]);
                         
                         % FIXME: so far, I follow EUMETSAT MHS prod. gen.
                         % spec.: they say: use a and b for both IWCT
                         % radiance and DSV radiance! This is not really
                         % the truth: a and b should differ for DSV.
                         
                         % or manually from clparams.dat file 
                         %bandcorr_a=[0.000 0.000 0.000 -0.0031 0.000];
                         %bandcorr_b=[1.0 1.0 1.0 1.00027 1.0 ];
                         
                         % UNCERTAINTY
                         u_chnfreq=bsxfun(@times,ones(size(countDSV_av)),1e7*ones(size(chnfreq))); %1e7*ones(size(chnfreq)); %just a guess!! this uncertainty represents 0.01GHz difference in frequency. 28.8.2017: Martin says in D2.2 that stability is between +-35 and 92 MHz. I should therefore assume 0.06GHz as mean value for channels?
                         u_bandcorr_a=abs(bsxfun(@times,ones(size(countDSV_av)),0.0001));%bandcorr_a; %estimate of 100% uncertainty on the last digit of a for channel 4, a=-0.0031(use this uncertainty for all channels)
                         u_bandcorr_b=bsxfun(@times,ones(size(countDSV_av)),0.0003);%bandcorr_b; %estimate of 100% uncertainty (based on deviation of corr. between channels: all channels have b=1 except ch4: b=1.0003
      %%%%%%%%%%%%%%%%%                   
                         % Local Oscillator temperature (as measure for
                         % "instrument temperature" for LO-B (EUM MHS product format specifications)
                         
                         [~,LO5tempcounts]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.temperature_data_LO_H5_temperature));
                         
                         % count to temp. conversion coefficients
                         thermcoeff0=hdrinfo.counts_to_temperature_conversion_thermistor_temperature_coeff0;
                         thermcoeff1=hdrinfo.counts_to_temperature_conversion_thermistor_temperature_coeff1;
                         thermcoeff2=hdrinfo.counts_to_temperature_conversion_thermistor_temperature_coeff2;
                         thermcoeff3=hdrinfo.counts_to_temperature_conversion_thermistor_temperature_coeff3;
                         thermcoeff4=hdrinfo.counts_to_temperature_conversion_thermistor_temperature_coeff4;
                         
                         %manually from clparams.dat or NOAA KLM user guide appendix
%                          thermcoeff0=355.9982;%double(extract_int32(header, 589, 592))/10000;
%                          thermcoeff1=-0.239278;%double(extract_int32(header, 593, 596))/10^7;
%                          thermcoeff2=-4.85712E-03;%double(extract_int32(header, 597, 600))/10^10;
%                          thermcoeff3=3.59838E-05;%double(extract_int32(header, 601, 604))/10^12;
%                          thermcoeff4=-8.02652E-08;%double(extract_int32(header, 605, 608))/10^15;
                         
                         %take absolute value to account for events where
                         %the counts jump to their negative value
                         LO5tempcountsabs=abs(LO5tempcounts);
                         
                         LO5temp=thermcoeff0+thermcoeff1*LO5tempcountsabs+thermcoeff2*LO5tempcountsabs.^2+thermcoeff3*LO5tempcountsabs.^3+thermcoeff4*LO5tempcountsabs.^4;
    
                        % taking LocalOscillator-Channel 5- temperature as instrument temperature
                         instrtemp=LO5temp; 
                         
                         
                         %reference temperature of LocalOscillator5 (LO5 or QBS5)
                        T1=double(hdrinfo.primary_reference_temperature_QBS5_min);
                        T2=double(hdrinfo.primary_reference_temperature_QBS5_nominal);
                        T3=double(hdrinfo.primary_reference_temperature_QBS5_max);
                         
                         
       %%%%%%%%%%%%%                  
                        % warm temperature bias correction dT_w:
                        % determined by
                        % linear interpolation from values for 3 reference
                        % temperatures
                        
                        
                        
                        % values for dT_w for the 3 reference temperatures for each
                        % channel (probably always zero)
                        dT_w_min=double([hdrinfo.Ch_H1_warm_load_correction_factor_min_temperature; hdrinfo.Ch_H2_warm_load_correction_factor_min_temperature;hdrinfo.Ch_H3_warm_load_correction_factor_min_temperature;hdrinfo.Ch_H4_warm_load_correction_factor_min_temperature;hdrinfo.Ch_H5_warm_load_correction_factor_min_temperature]);
                        dT_w_nom=double([hdrinfo.Ch_H1_warm_load_correction_factor_nominal_temperature; hdrinfo.Ch_H2_warm_load_correction_factor_nominal_temperature; hdrinfo.Ch_H3_warm_load_correction_factor_nominal_temperature; hdrinfo.Ch_H4_warm_load_correction_factor_nominal_temperature; hdrinfo.Ch_H5_warm_load_correction_factor_nominal_temperature]);
                        dT_w_max=double([hdrinfo.Ch_H1_warm_load_correction_factor_max_temperature;hdrinfo.Ch_H2_warm_load_correction_factor_max_temperature;hdrinfo.Ch_H3_warm_load_correction_factor_max_temperature;hdrinfo.Ch_H4_warm_load_correction_factor_max_temperature;hdrinfo.Ch_H5_warm_load_correction_factor_max_temperature]);
                         
                        % calculate interpolation parameters (slope, offset)
                        for channel=1:5
                        mA=(dT_w_min(channel)-dT_w_nom(channel))/(T1-T2);
                        nA=dT_w_nom(channel)-mA*T2;

                        mB=(dT_w_nom(channel)-dT_w_max(channel))/(T2-T3);
                        nB=(dT_w_max(channel)-mB*T3);

                        m(:,channel)=[mA mB];
                        n(:,channel)=[nA nB];
                        end

                            %check if instrtemp smaller than ref.Temp for lin interpol. --> take first
                            %interploation:
                            % repmat only for expansion to use elementwise
                            % multiplication
                            m_used_dT_w=repmat(logical(instrtemp<T2),[5 1]).*repmat(m(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(m(2,:),[length(instrtemp) 1]).';
                            n_used_dT_w=repmat(logical(instrtemp<T2),[5 1]).*repmat(n(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(n(2,:),[length(instrtemp) 1]).';
                            
                            % calc nonlincoeff by interpolation
                            dT_w=m_used_dT_w.*repmat(instrtemp,[5 1])+n_used_dT_w;
                            % FIXME: in AAPP for AMSUB, they use bbtemp instead of instrtemp!!
                        
                        % UNCERTAINTY
                        %u_dT_w=abs(dT_w); %estimate uncertainty of 100% %FIXME: this is zero so far!
                        u_dT_w=bsxfun(@times,ones(size(dT_w)),0.16); %estimate of 0.16K uncertainty in dT_w correction, which is zero so far.
     
      %%%%%%%%%%%%%                
                      % cold temp. bias correction
                      % FIXME: take values for profile which was chosen. profile 3
                      % for AMSUB; for MHS need Bonsignori paper (dummy:I
                      % choose profile0, but I think EUMETSAT says the same in productspecs)
                      [~,profile_read]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.status_word_profile)); % info on profile from header! CHECK!
                      
                      dT_c=double([hdrinfo.Ch_H1_cold_space_temperature_correction_profile0; hdrinfo.Ch_H2_cold_space_temperature_correction_profile0; hdrinfo.Ch_H3_cold_space_temperature_correction_profile0; hdrinfo.Ch_H4_cold_space_temperature_correction_profile0; hdrinfo.Ch_H5_cold_space_temperature_correction_profile0]);
                      % add  this to 2.73K and convert by planck %[0.24 0.24 0.24 0.24 0.24].';
                      
                      % UNCERTAINTY
                      %maybe another estimate: from stdev between different
                      %profiles (for Metop-B at least):ch1-5:
                      %0.27,0.04,0.06, 0.06, 0.03 . Definitely to small
                      %when thinking of the discrepancy to AAPP results
                      % maybe take stdev over all values (since assignment
                      % to channels unclear): then it's 0.6
                      u_dT_c=bsxfun(@times,ones(size(countDSV_av)),0.6*ones(size(dT_c)));%0.6*ones(size(dT_c)); %estimate of 0.6K from stdev in these corrections for the different space view profiles over all channels
                      
      %%%%%%%%%%%%%                      
                      % radiance of COSMIC MICROWAVE BACKGROUND for each
                      % channel
                      % apply cold bias correction (dT_c) and
                      % bandcorrection (bandcorr_a,bandcorr_b)
                      T_CMB0=2.72548*ones(5,1); % the pure CMB
                      T_CMB=bandcorr_a+bandcorr_b.*(T_CMB0+dT_c);
                      %radCMB=planck(invcm2hz(wavenumber_central),T_CMB);
                      %the conversion to radiance is done later
                     
                      % UNCERTAINTY of pure CMB
                      u_T_CMB0=bsxfun(@times,ones(size(countDSV_av)),0.004*ones(size(T_CMB0)));%0.004*ones(size(T_CMB0)); %estimate of 0.004K from Martins uncertainty-doc.
                     
                      
    %%%%%%%%%%%%%%%%                        
                      % non-linearity 
                      
                      % values for non-lin for the 3 reference temperatures for each
                        % channel
                        % multiply by 1000 to go from 1/mW (this is in l1b
                        % file and clparams) to 1/W what I use in this
                        % code.
                      non_lin_min=double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_min_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_min_temperature;hdrinfo.LO_A_CH_H3_nonlinearity_coeff_min_temperature;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_min_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_min_temperature])*1000;
                      non_lin_nominal=double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_nominal_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_nominal_temperature;hdrinfo.LO_A_CH_H3_nonlinearity_coeff_nominal_temperature;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_nominal_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_nominal_temperature])*1000;
                      non_lin_max=double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_max_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_max_temperature;hdrinfo.LO_A_CH_H3_nonlinearity_coeff_max_temperature;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_max_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_max_temperature])*1000;
                      
% sensitivity study
%                       non_lin_min=4*double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_min_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_min_temperature;hdrinfo.LO_A_CH_H3_nonlinearity_coeff_min_temperature;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_min_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_min_temperature]);
%                       non_lin_nominal=4*double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_nominal_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_nominal_temperature;hdrinfo.LO_A_CH_H3_nonlinearity_coeff_nominal_temperature;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_nominal_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_nominal_temperature]);
%                       non_lin_max=4*double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_max_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_max_temperature;hdrinfo.LO_A_CH_H3_nonlinearity_coeff_max_temperature;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_max_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_max_temperature]);
%                       
                      
                      
                      % calculate interpolation parameters (slope, offset)
                      clear mA nA mB nB m n
                        for channel=1:5
                        mA=(non_lin_min(channel)-non_lin_nominal(channel))/(T1-T2);
                        nA=non_lin_nominal(channel)-mA*T2;

                        mB=(non_lin_nominal(channel)-non_lin_max(channel))/(T2-T3);
                        nB=(non_lin_max(channel)-mB*T3);

                        m(:,channel)=[mA mB];
                        n(:,channel)=[nA nB];
                        end

                            %check if instrtemp smaller than ref.Temp for lin interpol. --> take first
                            %interploation:
                            % repmat only for expansion to use elementwise
                            % multiplication
                            m_used=repmat(logical(instrtemp<T2),[5 1]).*repmat(m(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(m(2,:),[length(instrtemp) 1]).';
                            n_used=repmat(logical(instrtemp<T2),[5 1]).*repmat(n(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(n(2,:),[length(instrtemp) 1]).';
                            
                            % calc nonlincoeff by interpolation
                            nonlincoeff=m_used.*repmat(instrtemp,[5 1])+n_used;
                            
                            % UNCERTAINTY
                            u_nonlincoeff=abs(nonlincoeff);% estimate of 100% uncertainty
                            
      %%%%%%%%%%%%%%%%
%                         % quotient of reflectivities per channel

                           % already loaded into variable alpha
                           % outside loop over orbits!
                           % (could be even outside loop over years)
                           
                        %for sensitivity study:
                           %alpha=0*[0.0002 0.0015 0.0022 0.0022 0.0021];
                           
%                         % from fdf.dat-file
%                         % alpha= 1-quotient of reflectivities
%                         alpha=[0.0002 0.0015 -0.0022 -0.0022 0.0021];
                          alphaMHSN18=[0.0002 0.0015 -0.0022 -0.0022 0.0021];
                        % UNCERTAINTY
                        
                        u_alpha=abs(alphaMHSN18); % estimate of 100% uncertainty (rel. to values for N18. 
                                                  % No other MHS instrument gets these values. But why not?
                                                  % We represent this fact by 100% uncertainty)
      
      
      %%%%%%%%%%%%%%%%
                           %Antenna_position_earthview
                           
                           for view=1:90
                           [~,theta_E_counts(view,:)]= fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.scene_earth_view_data_mid_pixel_position_FOV_XX(view,:)));
                           end
                           
                           %convert to degrees
                           Antenna_position_earthview=double(hdrinfo.antenna_position_conversion_factor*theta_E_counts)-180;%-180 to get nadir at zero
                           
                           % Quality Checks Earth Location
                           qualitychecksEarthLocation
                           
                           
                           % UNCERTAINTY
                           u_Antenna_position_earthview=0.04*ones(size(Antenna_position_earthview)); %degree. stdev is about 0.0353 for one view in an orbit of METOPB
                           u_Antenna_position_earthview_syst=0.1*ones(size(Antenna_position_earthview)); %degree; systematic uncertainty estimated from pointing errors along A axis acc. to pre-launch test MatraMarconi
                           
                           %Antenna_position_spaceview
                           [~,theta_S_counts_view1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_mid_pixel_position_space_view1));
                           [~,theta_S_counts_view2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_mid_pixel_position_space_view2));
                           [~,theta_S_counts_view3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_mid_pixel_position_space_view3));
                           [~,theta_S_counts_view4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.space_view_data_mid_pixel_position_space_view4));
                           
                           theta_S_counts=[theta_S_counts_view1; theta_S_counts_view2; theta_S_counts_view3; theta_S_counts_view4];
                           
                           %convert to degrees
                           Antenna_position_spaceview_4views=hdrinfo.antenna_position_conversion_factor*(theta_S_counts)-180;%-180 to get nadir at zero
                           
                           %convert to degrees, FIXME: HERE we take mean of the 4
                           %space views' positions. What does AAPP do for
                           %reflection correction??? alpha is zero for
                           %Metops anyway...
                           %Antenna_position_spaceview=hdrinfo.antenna_position_conversion_factor*mean(theta_S_counts,1);
                           Antenna_position_spaceview=mean(Antenna_position_spaceview_4views,1);
     
                           % Quality Checks Space View
                           qualitychecksSpaceViewLocation
                           
                           
                           % UNCERTAINTY
                           u_Antenna_position_spaceview=0.02*ones(size(Antenna_position_spaceview)); %degree. 0.2 deg as uncertainty is quite large! stdev is about 0.0225 for one view in an orbit of METOPB
                           u_Antenna_position_spaceview_syst=0.1*ones(size(Antenna_position_spaceview));%degree; systematic uncertainty estimated from pointing errors along A axis acc. to pre-launch test MatraMarconi
                           
                           
                           
                           
                           %Antenna_position_IWCTview
                           %only needed for quality flag setting
                           [~,theta_IWCT_counts_view1]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_mid_pixel_position_OBCT_view1));
                           [~,theta_IWCT_counts_view2]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_mid_pixel_position_OBCT_view2));
                           [~,theta_IWCT_counts_view3]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_mid_pixel_position_OBCT_view3));
                           [~,theta_IWCT_counts_view4]=fill_missing_scanlines(double(data.time_EpochSecond)*1000,scanlinenumbers_original,double(data.OBCT_view_data_mid_pixel_position_OBCT_view4));
                           
                           theta_IWCT_counts=[theta_IWCT_counts_view1; theta_IWCT_counts_view2; theta_IWCT_counts_view3; theta_IWCT_counts_view4];
                           
                           
                           %convert to degrees
                           Antenna_position_iwctview_4views=hdrinfo.antenna_position_conversion_factor*(theta_IWCT_counts);
                           Antenna_position_iwctview_4views(1:2,:)=Antenna_position_iwctview_4views(1:2,:)-360-180;%-180 to get nadir at zero; -360 since view 1,2 are at 360+, whereas 3,4 are at 0+
                           Antenna_position_iwctview_4views(3:4,:)=Antenna_position_iwctview_4views(3:4,:)-180;%-180 to get nadir at zero
                           
                           % Quality Checks IWCT View
                           qualitychecksIWCTViewLocation
                           
                           
      %%%%%%%%%%%%%%%%
                           %Antenna_corrcoeff_earthview
                           % indicating the fraction of the earth signal/ space/ platform of the total signal 
                           % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                           % instrument per satellite.
                           % Already loaded into variables gE,gS,gSAT
                           % at start of process_FCDR.m
                           % (from file "sensor_antcorr_alpha.mat")
                           
                           

%                       %sensitivity study
%                                 gEold=gE;
%                                 gSold=gS;
%                                 gSATold=gSAT;
%                                 
%                                 gS=4*gSold;
%                                 gSAT=4*gSATold;
%                                 gE=1-gS-gSAT;




                               %  FIXME: in AAPP they use the assumption that the
                               % radiance emitted by the platform is simply
                               % the radiance of the earth view ,i.e. "the
                               % platform reflects exactly the current
                               % earth view". At first, we stick to this
                               % assumption and therefore add the Earth 
                               % and platform contributions.
                               
                               % SWITCH to choose between using this AAPP
                               % assumption and not using the assumption
                               % but assuming sth else for R_pl (e.g.
                               % R_pl=R_CMB). If you choose NO here, you
                               % have to specify the R_Pl in
                               % measurement_equation.m (assume some
                               % temperature)
                               
                               % stick to assumption: YES (1) or NO (0)
                               assumption=1;
                               g_prime=gE+assumption*gSAT;
                               
                               
                               
                               % hence, the space contribution is only
                               %gS= 1-g_prime; 
                               
                               % in g_prime, all information is included for the
                               % antenna correction for earth views
                             
                               % Therefore, we name this g_prime the antenna correction
                               % coefficient for earth views:
                               Antenna_corrcoeff_earthcontribution=g_prime;
                               %Antenna_corrcoeff_earthview=gE;
                               Antenna_corrcoeff_spacecontribution=gS;
                               Antenna_corrcoeff_platformcontribution=gSAT;
                               
                               % UNCERTAINTY
                               u_Antenna_corrcoeff_earthcontribution=0.5*(1-Antenna_corrcoeff_earthcontribution); %estimate uncertainty of 50% of the correction to an efficiency of 1
                               u_Antenna_corrcoeff_spacecontribution=0.5*(Antenna_corrcoeff_spacecontribution);
                               u_Antenna_corrcoeff_platformcontribution=0.5*(Antenna_corrcoeff_platformcontribution);
        %%%%%%%%%%%%%%%% 
        
                                %R_Eprime Earth radiance without polarization
                                %correction

                                %need to evaluate measurement equation without
                                %polarization correction. Hence, R_Eprime
                                %and its uncertainty u_R_Eprime are set
                                %after the evaluation of the Measurement
                                %Eq.
                                
                                % UNCERTAINTY
                                %  is set after evaluation of measurement
                                %  equation; is set  in the
                                %  uncertainty_propagation script


   

%%%%%%%%%%%%% END:   READ IN VARIABLES FROM L1B-DATA FILE %%%%%%%%%%%%%%




