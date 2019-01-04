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



% Quality Check: IWCT view Location
clear ideal_antpos
%setting values according to chosen instrument
if strcmp(selectinstrument,'mhs')
aFOV=1.1111;
a0FOV=(0+1.1111/2)-(3-1)*1.1111; %0 deg is the central position between pixel 2 an 3 of IWCT view (NOAA KLM user guide Fig 3.9.2.2-1); 
limit=0.8;
elseif strcmp(selectinstrument,'amsub')
aFOV=1;%1.1-0.1 since views overlap (only slot of 4 deg for IWCT views, therefore they must overlap)
a0FOV=(0+1.1/2)-(3-1)*1.1;
limit=0.5;
end



for viewind=1:4
ideal_antpos(viewind)=a0FOV+(viewind-1)*aFOV-180;%-180 to get nadir at zero.

position_iwct_ok(viewind,:)=(ideal_antpos(viewind)-limit)< Antenna_position_iwctview_4views(viewind,:) & Antenna_position_iwctview_4views(viewind,:)< (ideal_antpos(viewind)+limit);
end

IWCTLocProblem_perpixel=~position_iwct_ok;

% Check whether any of the 4 pixels has bad position ("find max")
% This sets flag for scan line to 1 if any pixel has bad position.
scanlin_IWCTLocProblem=max(IWCTLocProblem_perpixel(:,:));

qualflag_IWCTlocProblem=scanlin_IWCTLocProblem.';