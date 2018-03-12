

% find Equator crossings for whole month

function equator_crossings=determine_EQcrossings(sat,sen,monthly_data_record)

% find Equator crossings as change of sign of latitude of virtual centre
% pixel. Virtual centre pixel is the mean position between pixel 45 and 46
% for MHS and AMSUB or 14 and 15 for SSMT2.

if strcmp(sen,'ssmt2')
    centre_pix=14;
else
    centre_pix=45;
end

virtual_centre_pixel_lat=mean(monthly_data_record.earth_location_latitude_FOVXX(centre_pix:centre_pix+1,:),1);


% find changes of sign per node
% by taking difference of lat-val/abs(lat-val)
scanline_latitude_sign_change_Desc=find(diff(virtual_centre_pixel_lat./abs(virtual_centre_pixel_lat))==-2);        
scanline_latitude_sign_change_Asc=find(diff(virtual_centre_pixel_lat./abs(virtual_centre_pixel_lat))==2);        

% make choice of ascending or descending node depending on satellite
if strcmp(sat,'noaa16')||strcmp(sat,'noaa18')||strcmp(sat,'noaa19')
    
    equator_crossings=scanline_latitude_sign_change_Asc;
else
    
    equator_crossings=scanline_latitude_sign_change_Desc;
    
end