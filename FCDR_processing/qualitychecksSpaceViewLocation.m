


% Quality Check: Space View Location

clear ideal_antpos
%setting values according to chosen instrument
if strcmp(selectinstrument,'mhs')
aFOV=1.1111;
a0FOV=(253.6+1.1111/2)-(3-1)*1.1111;  %253.6 deg is the central position between pixel 2 an 3 of DSV (NOAA KLM user guide Fig 3.9.2.2-1). Therefore calculate -(3-1)*1.1111 to get the central pos. of the 1st view
limit=0.8;
elseif strcmp(selectinstrument,'amsub')
%ang_profile=READ OUT!
ang_profile=profile_read+1; %need to add 1 since value 0 corresponds to profile 1, i.e. angpos=155
angpos=[155 159 163 167];
aFOV=1;%=1.1-0.1 % the FieldofView is 1.1deg. But the space views must overlap, if they should fit in between 163 and 167. Therefore use only 1deg as multiplicator for viewnumber
a0FOV=angpos(ang_profile)+90+0.5;%(167+90+1.1/2)-(3-1)*1.1;%167deg is the  angle of the first view in the last space view config. (config 3).But this is only acc. to NOAA KLM J18.  Shaping this to MHS values requires adding +90deg. https://www1.ncdc.noaa.gov/pub/data/satellite/publications/podguides/N-15%20thru%20N-19/pdf/0.0%20NOAA%20KLM%20Users%20Guide.pdf in J18
limit=0.5;
end


for viewind=1:4
ideal_antpos(viewind)=a0FOV+(viewind-1)*aFOV-180; %-180 to get nadir at zero.

position_space_ok(viewind,:)=(ideal_antpos(viewind)-limit)< Antenna_position_spaceview_4views(viewind,:) & Antenna_position_spaceview_4views(viewind,:)< (ideal_antpos(viewind)+limit);
end

SpaceLocProblem_perpixel=~position_space_ok;

% Check whether any of the 4 pixels has bad position ("find max")
% This sets flag for scan line to 1 if any pixel has bad position.
scanlin_SpaceLocProblem=max(SpaceLocProblem_perpixel(:,:));

qualflag_DSVlocProblem=scanlin_SpaceLocProblem.';


