

% Equator-to-Equator files: PRE PROCESSING
% 
% This function searches the dirchoice=ascending/descending (i.e. northbound/ southbound) equator crossings in two consecutive
% files.
% INPUT: two data l1b data files (as structures), corresponding two AAPP
% files (structures) fot the geolocation, flag whether only one file was
% used in the previous iteration.
% OUTPUT: scanlines for which the virtual centre pixel is closest to the
% equator, flag whether only one file was used in THIS iteration


function [eq_scnlin_vcp1,eq_scnlin_vcp2,onlysinglefile,no_crossing_found]=get_equator_crossing_l1b(data1,data2,onlysinglefile_before,sat)

no_crossing_found=0;
% open two consecutive files and read the satellite direction, latitude and time
sat_dir1=data1.scan_line_satellite_direction;
lat1=data1.earth_location_latitude_FOVXX;%AAPP1.lat;



sat_dir2=data2.scan_line_satellite_direction;
lat2=data2.earth_location_latitude_FOVXX;%AAPP2.lat;


% transform time of day into seconds since 1970
vectordate_foreqcr1=datevec(doy2date(double(data1.scan_line_day_of_year),double(data1.scan_line_year)));
[vectordate_foreqcr1(:,4),vectordate_foreqcr1(:,5),vectordate_foreqcr1(:,6)]=mills2hmsmill(double(data1.scan_line_UTC_time));
InputDate_foreqcr1=datenum(vectordate_foreqcr1);
UnixOrigin=datenum('19700101 000000','yyyymmdd HHMMSS');
time_EpochSecond_foreqcr1=round((InputDate_foreqcr1-UnixOrigin)*86400);
time1=time_EpochSecond_foreqcr1;

vectordate_foreqcr2=datevec(doy2date(double(data2.scan_line_day_of_year),double(data2.scan_line_year)));
[vectordate_foreqcr2(:,4),vectordate_foreqcr2(:,5),vectordate_foreqcr2(:,6)]=mills2hmsmill(double(data2.scan_line_UTC_time));
InputDate_foreqcr2=datenum(vectordate_foreqcr2);
UnixOrigin=datenum('19700101 000000','yyyymmdd HHMMSS');
time_EpochSecond_foreqcr2=round((InputDate_foreqcr2-UnixOrigin)*86400);
time2=time_EpochSecond_foreqcr2;

% for two files:
% find the scan line (and time) whose centre pixel is closest to the
% equator (going north, i.e. sat_dir=0).

% file1
% calculate latitude of virtual centre pixel
virtual_centre_pixel_lat1=mean(lat1(45:46,:),1);
% find northbound scanlines (sat_dir=0) OR find southbound (sat_dir=1) scanlines (choice of north/ south depends on
% satellite; due to AVHRR issues and harmony across FIDUCEO sensors)
%daytime Eq-crossing happens in ... branch
% all F11 to F15 descending
% noaa15 descending
% noaa16 ascending
% noaa17 descending
% noaa18 ascending
% noaa19 ascending
% metopa descending
% metopb descending
if strcmp(sat,'noaa16')||strcmp(sat,'noaa18')||strcmp(sat,'noaa19')
scl_dirchoice1=find(~sat_dir1); % finds zero elements, i.e. ascending or north bound
else
scl_dirchoice1=find(sat_dir1); % finds non-zero elements, i.e. descending or south bound
end
        % old procedure
        % % find minimum of latitude and corresponding elementnumber k
        % [lat_val1,k1]=min(abs(virtual_centre_pixel_lat1(scl_dirchoice1)));
        % % get actual scanline number by using the entry in scl_dirchoice
        % % corresponding to the i-th element
        % eq_scnlin_vcp1=scl_dirchoice1(k1);


% sort the abs(latitude(dirchoicebranch))
[sortedlat1,ind1]=sort(abs(virtual_centre_pixel_lat1(scl_dirchoice1)));
% write out smallest latitude value and its scanline
lat_val1_1=sortedlat1(1);
k1_1=ind1(1);

%%%%%%%
% Check, whether there is one EQcrossing at all.
%  check whether the smallest latitude value is close to Eq at all.
if abs(lat_val1_1)<=0.5
    
    %yes, the virtual centre pixel comes closer than 0.02deg to the Eq.
    %This is close enough to call it a crossing.
    % Do the normal Eq-processing.
    
    
else
    % No, the virtual centre pixel comes not close enough to the equator.
    % I.e., this file has NO EQ crossing. Probably because it is too
    % short. But since the check_which_file_to_use routine wants us to use
    % this file (i.e. its data is needed, because not doubled in next
    % file), we have to use more than 2 files to get the Eq to Eq files.
    % FIXME: this case needs to be implemented.
    
    % but also another case is possible: the file has already been used as
    % 2nd part for the previous file. Threfore its data has been used and
    % we should go to the next iteration.
    disp('There is no Eq crossing in this file. This case cannot be handled yet by the code. Therefore, we skip this file.')
    no_crossing_found=1;
    eq_scnlin_vcp1=0;
    eq_scnlin_vcp2=0;
    onlysinglefile=0;
    %at first I simply return to generate_Eq2Eq_FCDR and go to next
    %iteration
    return
end
%%%%%%%

% It may happen that there are two dirchoice crossings within one file!
% Therefore do the following:

% find second smallest latitude value, which is more than 100 scan line
% away from first smallest value (to assure that it is not from the same
% crossing), and its ascending/descending-scanline-number
k1_2=ind1(find(abs(ind1(1)-ind1)>100,1,'first'));
rank_k1_2=find(ind1==k1_2);
% capture whether 2nd smallest value really is a crossing (i.e. must be placed at least 3rd in ranking)
if rank_k1_2>3
    k1_2=[];
end
% get actual scanline numbers by using the entry in scl_dirchoice
% corresponding to the k_x-th element
eq_scnlin_vcp1_1=scl_dirchoice1(k1_1);
eq_scnlin_vcp1=eq_scnlin_vcp1_1; %set first crossing as start of new file. Watchout! it is  overwritten in "elseif" case

if ~isempty(k1_2) && onlysinglefile_before==0 %file has 2 crossings and has been used only as 2nd part for the previous file
    
    eq_scnlin_vcp1_2=scl_dirchoice1(k1_2);
    eq_scnlin_vcp2=eq_scnlin_vcp1_2; % set end of file (eq_scnlin_vcp2) that is currently built. It is composed of only one original file since this had 2 crossings.

    % check order of EQcrossings (time), and flip the order if necessary
    if time1(eq_scnlin_vcp1)>time1(eq_scnlin_vcp2)
        tmpline=eq_scnlin_vcp1;
        eq_scnlin_vcp1=eq_scnlin_vcp2;
        eq_scnlin_vcp2=tmpline;
    end
    onlysinglefile=1; %set marker that only one file needs to be used

elseif ~isempty(k1_2) && onlysinglefile_before==1 %file has 2 crossings and has been used alone for the previous file
    
    
    
    eq_scnlin_vcp1_2=scl_dirchoice1(k1_2);
    %eq_scnlin_vcp1=eq_scnlin_vcp1_2; % set the start of current file (eq_scnlin_vcp1) to its 2nd crossing (eq_scnlin_vcp1_2) to get the rest of the file.
    
    eq_scnlin_vcp2=eq_scnlin_vcp1_2;
    
    % check order of EQcrossings (time), and flip the order if necessary
    if time1(eq_scnlin_vcp1)>time1(eq_scnlin_vcp2)
        tmpline=eq_scnlin_vcp1;
        eq_scnlin_vcp1=eq_scnlin_vcp2;
        eq_scnlin_vcp2=tmpline;
    end
    eq_scnlin_vcp1=eq_scnlin_vcp2;
    
    % continue as normal with file 2:
    % file2
    % calculate latitude of virtual centre pixel
    virtual_centre_pixel_lat2=mean(lat2(45:46,:),1);
    % find northbound scanlines (sat_dir=0) OR find southbound (sat_dir=1) scanlines (choice of north/ south depends on
    % satellite; due to AVHRR issues and harmony across FIDUCEO sensors)
    if strcmp(sat,'noaa16')||strcmp(sat,'noaa18')||strcmp(sat,'noaa19')
    scl_dirchoice2=find(~sat_dir2); % finds zero elements, i.e. ascending or north bound
    else
    scl_dirchoice2=find(sat_dir2); % finds non-zero elements, i.e. descending or south bound
    end
    % find minimum of latitude and corresponding elementnumber k
    [lat_val2,k2]=min(abs(virtual_centre_pixel_lat2(scl_dirchoice2)));
    
    %check whether this is an equator crossing at all
    if abs(virtual_centre_pixel_lat2(k2))<=0.5
    %if yes:
    % get actual scanline number by using the entry in scl_dirchoice
    % corresponding to the i-th element
    eq_scnlin_vcp2=scl_dirchoice2(k2);
    else
    %if not: the file has no eq. crossing. Take the file until its end.
    eq_scnlin_vcp2=size(lat2,2);
    end
    
    onlysinglefile=0; 

else

    % in case there is only one dirchoice crossing, we need the subsequent
    % file and look for the first crossing in there to get the end of our
    % file that is currently built.

    % file2
    % calculate latitude of virtual centre pixel
    virtual_centre_pixel_lat2=mean(lat2(45:46,:),1);
    % find northbound scanlines (sat_dir=0) OR find southbound (sat_dir=1) scanlines (choice of north/ south depends on
    % satellite; due to AVHRR issues and harmony across FIDUCEO sensors)
    if strcmp(sat,'noaa16')||strcmp(sat,'noaa18')||strcmp(sat,'noaa19')
    scl_dirchoice2=find(~sat_dir2); % finds zero elements, i.e. ascending or north bound
    else
    scl_dirchoice2=find(sat_dir2); % finds non-zero elements, i.e. descending or south bound
    end
    % find minimum of latitude and corresponding elementnumber k
    [lat_val2,k2]=min(abs(virtual_centre_pixel_lat2(scl_dirchoice2)));
    % get actual scanline number by using the entry in scl_dirchoice
    % corresponding to the i-th element
    eq_scnlin_vcp2=scl_dirchoice2(k2);

    onlysinglefile=0; 

    
end


% return the found scanlines and times
