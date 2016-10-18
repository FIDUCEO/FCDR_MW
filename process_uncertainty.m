%

%
 % Copyright (C) 2016-10-17 Imke Hans
 % This code was developed for the EC project ÒFidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)Ó. 
 % Grant Agreement: 638822
 %  <Version> Reviewed and approved by <name, instituton>, <date>
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
%


%%%%%%%%%% PROCESS UNCERTAINTY %%%%%%%%

% script to execute all scripts/ functions to process uncertainty

% to display uncertainty histograms use the script uncertaintyHist.m
% after running this script.


%%% WARNING %%%
% This code and all functions or scripts that it executes are draft versions of the uncertainty calculation.
% This code is incomplete in the sense that there are many effects
% that are not considered here in the processing for uncertainty or in the reading of
% the data (although they might be known and already described in the latest version of the measurement equation.
% We only consider 3 effects here (effect1: receiver noise, effect2: antenna correction (scan angle), effect3: PRT accuracy)
%  
%  
% 
% 
% 
% 
%%%%%%%%%%%%%%% 


% YOU have to choose:
% 1.the satellite-intrument-year
% 2.the orbit
% 3.specify the correct "instrumentalvaluesXXX" script for your chosen
% instrument (in first if-statement)


writeh5=1;

% select instrument, satellite and year
satsenyear='noaa18_mhs_2006';
% select one orbit 
selectorbit=202;


tic
%run instrument specific matrixshape script:
chararr=char(satsenyear);
comp=strcmp(chararr(8:10),'mhs'); %check whether mhs is in satellite-instrument-spec. satsenyear

if comp==1
    matrixshapeMHS
    % HERE you need to specify the correct script for setting the
    % instrumental values
    instrumentalvaluesMHSnoaa18
    
else
    matrixshapeAMSUB
    
end
%

% total number of scanlines
totalsclines=length(data.year);

% select scanlines
scanlinevec=[1:totalsclines];
% select scanposview
scanposviewvec=[1:90];
% select ictview
ictview=1;
%select dsvview
dsvview=1;


disp('All parameters set.')

for selectchannel=1:1:5


uncertaintyeff1Value=zeros(scanlinevec(end),scanposviewvec(end));

disp('Calculate uncertainty...')
for scanline=[scanlinevec(1):scanlinevec(end)]
    disp(['processing scanline ', num2str(scanline)])
    for scanposview=[scanposviewvec(1):scanposviewvec(end)]
        
        uncertainties
        
        countEarthValue(selectchannel,scanposview,scanline)=countEARTHchapix;
        radianceValue(selectchannel,scanposview,scanline)=rad;
        TbValue(selectchannel,scanposview,scanline)=Tb;
        TbdiffValue(selectchannel,scanposview,scanline)=Tbdiff;
        
        for effectindex=1:1:3
                uTbValue{effectindex}.Value(selectchannel,scanposview,scanline)=uTb(effectindex);
        end
        
        uTbtotal(selectchannel,scanposview,scanline)=sqrt(uTbValue{1}.Value(selectchannel,scanposview,scanline)^2+uTbValue{2}.Value(selectchannel,scanposview,scanline)^2+uTbValue{3}.Value(selectchannel,scanposview,scanline)^2);
    end
end



end
toc
disp(['Done. Uncertainty values for all chosen scanlines and scanposviews ',char(10),'are stored in uncertaintyValue'])
disp(['The corresponding radiance values are stored in radianceValue.'])




if writeh5==1

% %% writing hdf5 file


% rescale MHS/AMSUB data in h5 format such that panoply can display them

%set the filename of the original data file 
locname=char(that_file(selectorbit));
name=locname(1:end-3);
h5filename=['/scratch/uni/u237/data/amsub_mhs_l1c/',name,'.h5'];


%read data that needs rescaling
datalon=h5read(h5filename,'/Geolocation/Longitude');
datalat=h5read(h5filename,'/Geolocation/Latitude');
databtemps=h5read(h5filename,'/Data/btemps');


%rescaling and transformation to double
lon=double(datalon).%10^(-4);
lat=double(datalat).%10^(-4);
btempsK=double(databtemps).%10^(-2);


% %set the filename of the created new data file
 filenamenew=['/scratch/uni/u237/users/ihans/FIDUCEO_testdata/',satsenyear,'_uncertainty_multich_multieff_incldiff_newscancorr_orbit202.h5'];
% 
% %create new subgroups in the h5 file where you later store the rescaled
% %data
  h5create(filenamenew,'/Geolocation/Latitude',size(lat))
  h5create(filenamenew,'/Geolocation/Longitude',size(lon))
  h5create(filenamenew,'/Data/btemps',size(btempsK))
  h5create(filenamenew,'/Data/AAPPdiffFID',size(btempsK))
  h5create(filenamenew,'/Data/EarthCounts',size(countEarthValue))
  h5create(filenamenew,'/Data/Radiance',size(radianceValue))
  h5create(filenamenew,'/Data/Tb',size(TbValue))
  h5create(filenamenew,'/Data/Tbdiff',size(TbdiffValue))
  h5create(filenamenew,'/Data/UTbeff1',size(uTbValue{1}.Value))
  h5create(filenamenew,'/Data/UTbeff2',size(uTbValue{2}.Value))
  h5create(filenamenew,'/Data/UTbeff3',size(uTbValue{3}.Value))
  h5create(filenamenew,'/Data/UTbtotal',size(uTbtotal))
  
% 
% % write them into new subgroups of  file
 h5write(filenamenew,'/Geolocation/Latitude',lat)
 h5write(filenamenew,'/Geolocation/Longitude',lon)
 h5write(filenamenew,'/Data/btemps',btempsK)
 h5write(filenamenew,'/Data/AAPPdiffFID',btempsK-TbValue)
 h5write(filenamenew,'/Data/EarthCounts',countEarthValue)
 h5write(filenamenew,'/Data/Radiance',radianceValue)
 h5write(filenamenew,'/Data/Tb',TbValue)
 h5write(filenamenew,'/Data/Tbdiff',TbdiffValue)
 h5write(filenamenew,'/Data/UTbeff1',uTbValue{1}.Value)
 h5write(filenamenew,'/Data/UTbeff2',uTbValue{2}.Value)
 h5write(filenamenew,'/Data/UTbeff3',uTbValue{3}.Value)
 h5write(filenamenew,'/Data/UTbtotal',uTbtotal)
 
 disp('Done. H5 file located in')
 disp(filenamenew)
 
end 