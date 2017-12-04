



% Quality Check: IWCT view Location
clear ideal_antpos
%setting values according to chosen instrument
if strcmp(selectinstrument,'mhs')
aFOV=1.1111;
a0FOV=(0+1.1111/2)-(3-1)*1.1111; %0 deg is the central position between pixel 2 an 3 of IWCT view (NOAA KLM user guide Fig 3.9.2.2-1)
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