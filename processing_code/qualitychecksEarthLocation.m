


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