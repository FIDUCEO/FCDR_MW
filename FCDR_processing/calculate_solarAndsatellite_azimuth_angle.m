


% calculate solar and satellite azimuth angle


% calculate solar azimuth angle

% prepare timevector for every pixel

time_pix_year=repmat(vectordate(:,1),1,90).';
time_pix_month=repmat(vectordate(:,2),1,90).';
time_pix_day=repmat(vectordate(:,3),1,90).';
time_pix_hours=repmat(vectordate(:,4),1,90).';
time_pix_min=repmat(vectordate(:,5),1,90).';
time_pix_sec=repmat(vectordate(:,6),1,90).';


% transform date vector time_pix_XX to modified julian date with atmlab
% function 
mjd=date2mjd(time_pix_year,time_pix_month,time_pix_day,time_pix_hours,time_pix_min,time_pix_sec);

% calculate solar azimuth angle saa with atmlab function sun_angles

[~,sol_az_ang]=sun_angles(mjd, lat_data,long_data);

rel_az_ang_data(rel_az_ang_data==0)=nan;
% calculate satellite azimuth angle
%http://www.stcorp.nl/beat/documentation/harp/algorithms/derivations/relative_azimuth_angle.html
%use first formula and take into account 2nd:
%sat=sol-(rel+k*360) with k=1 if rel<0 and 0 otherwise
sat_az_ang=sol_az_ang-(rel_az_ang_data+0.5*(abs(ones(size(rel_az_ang_data)) - (rel_az_ang_data./abs(rel_az_ang_data)))).*360);

