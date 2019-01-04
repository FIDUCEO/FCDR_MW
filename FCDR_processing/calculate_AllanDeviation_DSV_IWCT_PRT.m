
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

% compute the Allan Deviation for DSV, IWCT, PRT



% Note: the rolling 7-scanlin average is applied in the
% calculate_rolling_average routine to get the final valid Noise estimate
% per scanline.


% initialize the counts from the 4 views for DSV, to have
% dimension: channel x  scanlin X view
countsdsv=[dsv1ch1; dsv2ch1; dsv3ch1; dsv4ch1;];
countsdsv(:,:,2)=[dsv1ch2; dsv2ch2; dsv3ch2; dsv4ch2;];               
countsdsv(:,:,3)=[dsv1ch3; dsv2ch3; dsv3ch3; dsv4ch3;];         
countsdsv(:,:,4)=[dsv1ch4; dsv2ch4; dsv3ch4; dsv4ch4;];                  
countsdsv(:,:,5)=[dsv1ch5; dsv2ch5; dsv3ch5; dsv4ch5;];

countsdsv=double(permute(countsdsv,[3 2 1]));


% initialize the counts from the 4 views for DSV, to have
% dimension: channel x  scanlin X view
countsiwct=[iwct1ch1; iwct2ch1; iwct3ch1; iwct4ch1;];
countsiwct(:,:,2)=[iwct1ch2; iwct2ch2; iwct3ch2; iwct4ch2;];               
countsiwct(:,:,3)=[iwct1ch3; iwct2ch3; iwct3ch3; iwct4ch3;];         
countsiwct(:,:,4)=[iwct1ch4; iwct2ch4; iwct3ch4; iwct4ch4;];                  
countsiwct(:,:,5)=[iwct1ch5; iwct2ch5; iwct3ch5; iwct4ch5;];

countsiwct=double(permute(countsiwct,[3 2 1]));

% initialize and the temperature from the 7 PRT sensors, to have
% dimension:   scanlin X sensor
tempPRT=PRTtemps.';

% fill lines that had been identified as bad in the quality checks (and
% FULLY Moon contaminated lines!) with NAN: set to nan also the views that
% are contaminated by the Moon and leave those, that are not contaminated.
% These enter normal processing. 
% (calculating the Allan Var will generate
% NAN also for the predecessor line of a badline)
countsdsv_badviewsNan=countsdsv;
countsdsv_badviewsNan(qualflag_DSVview_bad_checks==1)=nan;
countsdsv_badviewsNan(permute(repmat(moonflagAllViewsBad,[1,4,5]),[3 1 2])==1)=nan;
countsdsv_badviewsNan(permute(repmat(moonflagOneViewOk,[1,4,5]),[3 1 2])==1)=countsdsv(permute(repmat(moonflagOneViewOk,[1,4,5]),[3 1 2])==1);
countsdsv_badviewsNan(moonflagwhichviewbad==1)=nan; %set to Nan all views that are contaminated. Those that are not enter normal calibration and normal Noise Estimationn
countsiwct_badviewsNan=countsiwct;
countsiwct_badviewsNan(qualflag_IWCTview_bad_checks==1)=nan;
tempPRT_badsenNan=tempPRT;
tempPRT_badsenNan(qualflag_PRTsen_bad_checks==1)=nan;

% calculate Allan Variance from scanline to scanline per view/sensor and channel
AllanVar_DSV_indivLines_indivViews=1/2*diff(countsdsv_badviewsNan,1,2).^2;
AllanVar_IWCT_indivLines_indivViews=1/2*diff(countsiwct_badviewsNan,1,2).^2;
AllanVar_PRT_indivLines_indivSens=1/2*diff(tempPRT_badsenNan,1,1).^2;

% calculate the mean per scanline (mean over the views/sensors) and omit NANs to
% get the correct inrease in AllanVar due to less usable views/sensors
AllanVar_DSV_indivLines=mean(AllanVar_DSV_indivLines_indivViews,3,'omitnan');
AllanVar_IWCT_indivLines=mean(AllanVar_IWCT_indivLines_indivViews,3,'omitnan');
AllanVar_PRT_indivLines=mean(AllanVar_PRT_indivLines_indivSens,2,'omitnan');

%calculate a rolling mean over 300 scanlines
AllanVar_DSV_300window=movmean(AllanVar_DSV_indivLines,300,2,'omitnan');
AllanVar_IWCT_300window=movmean(AllanVar_IWCT_indivLines,300,2,'omitnan');
AllanVar_PRT_300window=movmean(AllanVar_PRT_indivLines,300,1,'omitnan');

% calculate the Allan Deviation
AllanDev_DSV_300window=sqrt(AllanVar_DSV_300window);
AllanDev_IWCT_300window=sqrt(AllanVar_IWCT_300window);
AllanDev_PRT_300window=sqrt(AllanVar_PRT_300window);

% expand the Allan Deviation for the last scanline (repeat last value)
AllanDev_DSV_perline=AllanDev_DSV_300window;
AllanDev_DSV_perline(:,length(AllanDev_DSV_300window)+1)=AllanDev_DSV_300window(:,end);
AllanDev_IWCT_perline=AllanDev_IWCT_300window;
AllanDev_IWCT_perline(:,length(AllanDev_IWCT_300window)+1)=AllanDev_IWCT_300window(:,end);
AllanDev_PRT_perline=AllanDev_PRT_300window;
AllanDev_PRT_perline(length(AllanDev_PRT_300window)+1)=AllanDev_PRT_300window(end);


% set all badlines to NAN
AllanDev_DSV_perline_intermed=AllanDev_DSV_perline;
AllanDev_DSV_perline(qualflag_DSV_badline_furtherthan5lines==1)=nan; %the moon-one-view-ok case MUST NOT be set to NAN! 
AllanDev_DSV_perline(permute(repmat(moonflagOneViewOk,[1,5]),[2 1])==1)=AllanDev_DSV_perline_intermed(permute(repmat(moonflagOneViewOk,[1,5]),[2 1])==1);
AllanDev_IWCT_perline(qualflag_allbadIWCT)=nan;
AllanDev_PRT_perline(qualflag_allbadPRT)=nan;

AllanVar_DSV_perline=AllanDev_DSV_perline.^2;
AllanVar_IWCT_perline=AllanDev_IWCT_perline.^2;
AllanVar_PRT_perline=AllanDev_PRT_perline.^2;


% Noise estimate:
% set to special value the lines for the 5-closest case: mean of the AllanDevperline of the five
% closest lines
for chn=1:5
    
    for indexbadline= 1:length(scnlin_DSV_badline_5closest_TRUE{chn})
     
    dsvlines=squeeze(good_linesDSV_closeTobad(chn,scnlin_DSV_badline_5closest_TRUE{chn}(indexbadline),:));
    dsvlinetofill=scnlin_DSV_badline_5closest_TRUE{chn}(indexbadline);
    
    AllanDev_DSV_perline(chn,dsvlinetofill)=mean(AllanDev_DSV_perline(chn,dsvlines),2);
    AllanVar_DSV_perline(chn,dsvlinetofill)=mean(AllanVar_DSV_perline(chn,dsvlines),2);
%    AllanDev_countDSV_NOav(chn,dsvlinetofill)=mean(AllanDev_DSV_perline(chn,dsvlines),2);
     
    end
    
    for indexbadline= 1:length(scnlin_IWCT_badline_5closest_TRUE{chn})
     
    iwctlines=squeeze(good_linesIWCT_closeTobad(chn,scnlin_IWCT_badline_5closest_TRUE{chn}(indexbadline),:));
    iwctlinetofill=scnlin_IWCT_badline_5closest_TRUE{chn}(indexbadline);
    
    AllanDev_IWCT_perline(chn,iwctlinetofill)=mean(AllanDev_IWCT_perline(chn,iwctlines),2);
    AllanVar_IWCT_perline(chn,iwctlinetofill)=mean(AllanVar_IWCT_perline(chn,iwctlines),2);
%   AllanDev_countIWCT_NOav(chn,iwctlinetofill)=mean(AllanDev_IWCT_perline(chn,iwctlines),2);
    
   
    end
end

% Noise estimate:  lines for which NO rolling average should be
    % applied:
    % set to special value the lines for the 5-closest case: mean of the AllanDevperline of the five
    % closest lines
    for indexbadline= 1:length(scnlin_PRT_badline_5closest_TRUE{1})
     
    prtlines=squeeze(good_linesPRT_closeTobad(scnlin_PRT_badline_5closest_TRUE{1}(indexbadline),:));
    prtlinetofill=scnlin_PRT_badline_5closest_TRUE{1}(indexbadline);
    
    AllanDev_PRT_perline(prtlinetofill)=mean(AllanDev_PRT_perline(prtlines),1);
    AllanVar_PRT_perline(prtlinetofill)=mean(AllanVar_PRT_perline(prtlines),1);
    
    end

% this AllanDev_X_perline now enters 
% 1. the 7-scanlin-rolling average
% 2. is used for the estimation of earth count noise (DSV and IWCT)

