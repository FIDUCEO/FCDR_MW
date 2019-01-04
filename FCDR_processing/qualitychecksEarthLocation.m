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


% Quality Check: Earth Location
clear ideal_antpos
%setting values according to chosen instrument
if strcmp(selectinstrument,'mhs')
aFOV=1.1111;
a0FOV=130.5561; %calculated from (180+1.1111/2)-(46-1)*1.1111
limit=0.25;  %from clparams file
elseif strcmp(selectinstrument,'amsub')
aFOV=1.1; %FOVs do not overlap. therefore take full fov size 1.1deg
a0FOV=131.05; %calculated from (180+1.1/2)-(46-1)*1.1
limit=0.11; %from clparams file
end


for i=1:90
ideal_antpos(i)=a0FOV+(i-1)*aFOV-180;%-180 to get nadir at zero.;

position_earth_ok(i,:)=(ideal_antpos(i)-limit)< Antenna_position_earthview(i,:) & Antenna_position_earthview(i,:)< (ideal_antpos(i)+limit);
end

EarthLocProblem_perpixel=~position_earth_ok;

% Check whether any of the 90 pixels has bad position ("find max")
% This sets flag for scan line to 1 if any pixel has bad position.
scanlin_EarthLocProblem=max(EarthLocProblem_perpixel(:,:));


qualflag_EarthlocProblem=scanlin_EarthLocProblem.';