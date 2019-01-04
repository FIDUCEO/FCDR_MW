%
 % Copyright (C) 2019-01-04 Imke Hans
 % This code was developed for the EC project ?Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)?. 
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

