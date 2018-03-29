


% read SSMT2 level 1b and reshape for FCDR processing


function [hdrinfo, data, err]= read_SSMT2_allvar( filename )
err=0;

try
S=ssmt2_read( filename,0 ); %zero for "do not apply calibration"
catch ME
    err=1;
    data=[];
    hdrinfo=[];
    return
end
hdrinfo.dataset_name=strcat(S.dsname, '.gz');
hdrinfo.nlines=S.nscan;
hdrinfo.Ch_1_cold_space_temperature_correction=S.precal(45)/100;
hdrinfo.Ch_2_cold_space_temperature_correction=S.precal(46)/100;
hdrinfo.Ch_3_cold_space_temperature_correction=S.precal(47)/100;
hdrinfo.Ch_4_cold_space_temperature_correction=S.precal(48)/100;
hdrinfo.Ch_5_cold_space_temperature_correction=S.precal(49)/100;

hdrinfo.Ch_1_warm_load_correction_factor=S.precal(50)/100;
hdrinfo.Ch_2_warm_load_correction_factor=S.precal(51)/100;
hdrinfo.Ch_3_warm_load_correction_factor=S.precal(52)/100;
hdrinfo.Ch_4_warm_load_correction_factor=S.precal(53)/100;
hdrinfo.Ch_5_warm_load_correction_factor=S.precal(54)/100;

hdrinfo.Ch_1_apc=S.apc(:,1);
hdrinfo.Ch_2_apc=S.apc(:,2);
hdrinfo.Ch_3_apc=S.apc(:,3);
hdrinfo.Ch_4_apc=S.apc(:,4);
hdrinfo.Ch_5_apc=S.apc(:,5);

for k=1:1:S.nscan
    
    data.scan_line_number(k)=k;
    data.scan_line_year(k)=S.recs(k).year;
    data.scan_line_day_of_year(k)=S.recs(k).doy;
    data.scan_line_ols(k)=S.recs(k).ols;
    data.time_stamp(:,k)=S.recs(k).timestamp;
    [year,month,day,hh,mm,ss]=datevec(data.time_stamp(1,k));
    data.scan_line_UTC_time(k)=hh*60*60*1000+mm*60*1000+ss*1000;
    
    data.earth_location_latitude_FOVXX(:,k)=S.recs(k).lat;
    data.earth_location_longitude_FOVXX(:,k)=S.recs(k).lon;
    
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_1(:,k)=S.recs(k).count(1,:);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_2(:,k)=S.recs(k).count(2,:);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_3(:,k)=S.recs(k).count(3,:);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_4(:,k)=S.recs(k).count(4,:);
    data.scene_earth_view_data_scene_counts_FOV_XX_Ch_5(:,k)=S.recs(k).count(5,:);
    
    data.OBCT_view_data_counts_OBCT_view1_Ch_1(k)=S.recs(k).rawcal(1);
    data.OBCT_view_data_counts_OBCT_view2_Ch_1(k)=S.recs(k).rawcal(6);
    data.OBCT_view_data_counts_OBCT_view3_Ch_1(k)=S.recs(k).rawcal(11);
    data.OBCT_view_data_counts_OBCT_view4_Ch_1(k)=S.recs(k).rawcal(16);
    
    data.OBCT_view_data_counts_OBCT_view1_Ch_2(k)=S.recs(k).rawcal(2);
    data.OBCT_view_data_counts_OBCT_view2_Ch_2(k)=S.recs(k).rawcal(7);
    data.OBCT_view_data_counts_OBCT_view3_Ch_2(k)=S.recs(k).rawcal(12);
    data.OBCT_view_data_counts_OBCT_view4_Ch_2(k)=S.recs(k).rawcal(17);
    
    data.OBCT_view_data_counts_OBCT_view1_Ch_3(k)=S.recs(k).rawcal(3);
    data.OBCT_view_data_counts_OBCT_view2_Ch_3(k)=S.recs(k).rawcal(8);
    data.OBCT_view_data_counts_OBCT_view3_Ch_3(k)=S.recs(k).rawcal(13);
    data.OBCT_view_data_counts_OBCT_view4_Ch_3(k)=S.recs(k).rawcal(18);
    
    data.OBCT_view_data_counts_OBCT_view1_Ch_4(k)=S.recs(k).rawcal(4);
    data.OBCT_view_data_counts_OBCT_view2_Ch_4(k)=S.recs(k).rawcal(9);
    data.OBCT_view_data_counts_OBCT_view3_Ch_4(k)=S.recs(k).rawcal(14);
    data.OBCT_view_data_counts_OBCT_view4_Ch_4(k)=S.recs(k).rawcal(19);
    
    data.OBCT_view_data_counts_OBCT_view1_Ch_5(k)=S.recs(k).rawcal(5);
    data.OBCT_view_data_counts_OBCT_view2_Ch_5(k)=S.recs(k).rawcal(10);
    data.OBCT_view_data_counts_OBCT_view3_Ch_5(k)=S.recs(k).rawcal(15);
    data.OBCT_view_data_counts_OBCT_view4_Ch_5(k)=S.recs(k).rawcal(20);
    
    data.space_view_data_counts_space_view1_Ch_1(k)=S.recs(k).rawcal(21);
    data.space_view_data_counts_space_view2_Ch_1(k)=S.recs(k).rawcal(26);
    data.space_view_data_counts_space_view3_Ch_1(k)=S.recs(k).rawcal(31);
    data.space_view_data_counts_space_view4_Ch_1(k)=S.recs(k).rawcal(36);
    
    data.space_view_data_counts_space_view1_Ch_2(k)=S.recs(k).rawcal(22);
    data.space_view_data_counts_space_view2_Ch_2(k)=S.recs(k).rawcal(27);
    data.space_view_data_counts_space_view3_Ch_2(k)=S.recs(k).rawcal(32);
    data.space_view_data_counts_space_view4_Ch_2(k)=S.recs(k).rawcal(37);
    
    data.space_view_data_counts_space_view1_Ch_3(k)=S.recs(k).rawcal(23);
    data.space_view_data_counts_space_view2_Ch_3(k)=S.recs(k).rawcal(28);
    data.space_view_data_counts_space_view3_Ch_3(k)=S.recs(k).rawcal(33);
    data.space_view_data_counts_space_view4_Ch_3(k)=S.recs(k).rawcal(38);
    
    data.space_view_data_counts_space_view1_Ch_4(k)=S.recs(k).rawcal(24);
    data.space_view_data_counts_space_view2_Ch_4(k)=S.recs(k).rawcal(29);
    data.space_view_data_counts_space_view3_Ch_4(k)=S.recs(k).rawcal(34);
    data.space_view_data_counts_space_view4_Ch_4(k)=S.recs(k).rawcal(39);
    
    data.space_view_data_counts_space_view1_Ch_5(k)=S.recs(k).rawcal(25);
    data.space_view_data_counts_space_view2_Ch_5(k)=S.recs(k).rawcal(30);
    data.space_view_data_counts_space_view3_Ch_5(k)=S.recs(k).rawcal(35);
    data.space_view_data_counts_space_view4_Ch_5(k)=S.recs(k).rawcal(40);
    
    
    data.computed_OBCT_temperature1_PRT1_based(k)=S.recs(k).rawcal(65)/100;
    data.computed_OBCT_temperature2_PRT2_based(k)=S.recs(k).rawcal(66)/100;
    
    data.qualflag_earthloc(k)=S.recs(k).qc_earth;
    
    
    
end

% Make initial test on time:
% data.scan_line_UTC_time should not be zero or larger than 86400*1000. If
% it is, the line is flagged as bad time.
 data.bad_time_flag=zeros(S.nscan,1);
 data.bad_time_flag=data.scan_line_UTC_time==0 | data.scan_line_UTC_time>86400000;
 
 % create field scan_line_satellite_direction from derivative of latitude
 data.scan_line_satellite_direction=zeros(S.nscan,1);
 data.scan_line_satellite_direction=[diff(data.earth_location_latitude_FOVXX(14,:))<0 diff(data.earth_location_latitude_FOVXX(14,end-1:end))<0]; % set to one where latitude decreases (southbound, descending)
 
 
end
