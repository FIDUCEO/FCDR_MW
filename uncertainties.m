
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



% script for calculating uncertainties

% calls function to calculate uncertainty for each effect

%% info

% DO NOT RUN THIS SCRIPT SEPARATELY. USE THE process_uncertainty.m SCRIPT
% INSTEAD.

% This script takes the dataperorbit-variable that is delivered by the
% script matrixshape.m that has to be called before this uncertainty.m- script.

% This script calls function uncertainty_singleeffect.m to calculate 
% uncertainty for chosen effect.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load input



% CMB RADIANCE
radCMB=planck(f(selectchannel),2.72548); %% dep. on selected channel


% COUNTS OF RADIANCES
countICT=dataperorbit{selectorbit}.obctcounts; %per scanline, per scanviewpos, per channel
countDSV=dataperorbit{selectorbit}.dsvcounts; %per scanline, per scanviewpos, per channel
countEarth=dataperorbit{selectorbit}.earthcounts;

meancountICT=dataperorbit{orbit}.countsobctViewmean; %(scanline,channel)
meancountDSV=dataperorbit{orbit}.countsdsvViewmean;


% THEIR UNCERTAINTIES receiver noise, i.e. dsv-counts-allan-deviation
ucountICT=udsvcount;%per channel; use single value for all scanlines,views%dataperorbit{selectorbit}.uobctcounts; %per 300 scanline, per scanviewpos, per channel
ucountDSV=udsvcount;%dataperorbit{selectorbit}.udsvcounts; %per scanline, per scanviewpos, per channel
ucountEarth=udsvcount;%dataperorbit{selectorbit}.uearthcounts;

% THEIR CORRELATIONS
% concerning noise they are not correlated
%rcountICT %per scanline, per scanviewpos, per channel
%rcountDSV %per scanline, per scanviewpos, per channel
%rcountEarth

% COUNTS OF PRTs
PRT1count=dataperorbit{selectorbit}.PRT1counts;
PRT2count=dataperorbit{selectorbit}.PRT2counts;
PRT3count=dataperorbit{selectorbit}.PRT3counts;
PRT4count=dataperorbit{selectorbit}.PRT4counts;
PRT5count=dataperorbit{selectorbit}.PRT5counts;
PRT6count=dataperorbit{selectorbit}.PRT6counts;
PRT7count=dataperorbit{selectorbit}.PRT7counts;

% THEIR UNCERTAINTIES
    % PRT1ucount=dataperorbit{orbit}.uPRT1counts;
    % PRT2ucount=dataperorbit{orbit}.uPRT2counts;
    % PRT3ucount=dataperorbit{orbit}.uPRT3counts;
    % PRT4ucount=dataperorbit{orbit}.uPRT4counts;
    % PRT5ucount=dataperorbit{orbit}.uPRT5counts;
    % PRT6ucount=dataperorbit{orbit}.uPRT6counts;
    % PRT7ucount=dataperorbit{orbit}.uPRT7counts;

% THEIR CORRELATIONS
    % PRTrcount=diag(ones(7,1),0); % 7x7 matrix with zero entries; on the diagonal there are ones.
    %                              % Needs to be added to a matrix of equal shape
    %                              % containting the actual correlations
    %                              % Counts1,counts2 etc...

 
% ICT Temperature
ICTtemp=dataperorbit{orbit}.ICTtempmean; %ICT temperatrue per scanline, (=average over 5 PRT-temp of that scanline)
    
% its uncertainty
ICTutemp=0.1;%in K, un certainty of PRT temperature measurements. preliminary value, does not take into account the 2 averaging processes 

% COEFFICIENTS OF POLYNOMIAL FOR PRT-COUNT TO TEMP. CONVERSION

PRT1coeff=dataperorbit{selectorbit}.PRT1coeff;%[coeff1 coeff2 coeff3 coeff4; coeff1 coeff2 ....]; valid For all scanlines of one orbit
PRT2coeff=dataperorbit{selectorbit}.PRT2coeff;%[coeff1 coeff2 coeff3 coeff4];
PRT3coeff=dataperorbit{selectorbit}.PRT3coeff;%[coeff1 coeff2 coeff3 coeff4];
PRT4coeff=dataperorbit{selectorbit}.PRT4coeff;%[coeff1 coeff2 coeff3 coeff4];
PRT5coeff=dataperorbit{selectorbit}.PRT5coeff;%[coeff1 coeff2 coeff3 coeff4];
PRT6coeff=dataperorbit{selectorbit}.PRT6coeff;%[coeff1 coeff2 coeff3 coeff4];
PRT7coeff=dataperorbit{selectorbit}.PRT7coeff;%[coeff1 coeff2 coeff3 coeff4];

% THEIR UNCERTAINTIES
    % PRT1ucoeff=dataperorbit{orbit}.uPRT1coeff;%[coeff1 coeff2 coeff3 coeff4; coeff1 coeff2 ....]; For all scanlines
    % PRT2ucoeff=dataperorbit{orbit}.uPRT1coeff;%[coeff1 coeff2 coeff3 coeff4];
    % PRT3ucoeff=dataperorbit{orbit}.uPRT1coeff;%[coeff1 coeff2 coeff3 coeff4];
    % PRT4ucoeff=dataperorbit{orbit}.uPRT1coeff;%[coeff1 coeff2 coeff3 coeff4];
    % PRT5ucoeff=dataperorbit{orbit}.uPRT1coeff;%[coeff1 coeff2 coeff3 coeff4];
    % PRT6ucoeff=dataperorbit{orbit}.uPRT1coeff;%[coeff1 coeff2 coeff3 coeff4];
    % PRT7ucoeff=dataperorbit{orbit}.uPRT1coeff;%[coeff1 coeff2 coeff3 coeff4];
    % 
    % % their correlations
    % PRTrcoeff=diag(ones(28,1),0); % scanlinesx28x28 matrix with zero entries; on the diagonal there are ones.
    %                              % Needs to be added to a matrix of equal shape
    %                              % containing the actual correlations
    %                              % Counts1,counts2 etc...; multidim array of
    %                              % #scanlines layers each of it containtin28x28
    %                              % matix.

    
% CONTAMINATION RADIANCES

CMBPL1corrC0=CMBPL1correctionfracC0; %perscanline (?),per scanposview, per channel; for angular correction of earth radiance
CMBPL1corrC1=CMBPL1correctionfracC1;
CMBPL1corrC2=CMBPL1correctionfracC2;
PL2temp(selectchannel)=mean(PL2corr(selectchannel,:)); % per DSVview, per channel
PL2rad(selectchannel)=DplanckDT(f(selectchannel),2.72548)*PL2temp(selectchannel); %transform to radiance
SHcorr=0;  % per ICTview, per channel

% THEIR UNCERTAINTIES
CMBPL1ucorr= uCMBPL1correctionfrac(selectchannel);%DplanckDT(f(selectchannel),230)*uPL2corr; % NEED CORRECT VALUES %perscanline (?),per scanposview, per channel; estimated from tables
uPL2meancorr=sqrt(sum((uPL2corr(selectchannel,:).^2)))/4;
PL2urad=DplanckDT(f(selectchannel),2.72548)*uPL2meancorr;  % NEED TO tranform to rad? per channel
% SHurad  % per ICTview, per channel

% THEIR CORRELATIONS




% NONLINEARTITY COEFFICIENT
LOtemp=dataperorbit{selectorbit}.LO5temp;
%check if LOtemp smaller than ref.Temp for lin interpol. --> take first
%interploation
if LOtemp<T2
    no=1;
else
    no=2;
end
% calc anl from linear interpolation
anl= (m(no,selectchannel)*LOtemp+n(no,selectchannel));
    
    
%% set parameters






%set elements of vecnumterms for each effect
vecnumterms(1)=3; 
vecnumterms(2)=2;
vecnumterms(3)=1;%28+7; %7*4=28 coefficients used for conv. to Temp conversion, plus 7 PRTsensor counts





%% prepare input variable for uncertainty calculation function

% build matrix with variables;  only take values for chosen pixel and
% selectchannel

% counts of radiances
%calculating the average over 7 scanlines for the centre scanline
if scanline < 4   %FIX make variable that conatins all scanlines of orbit
   ns=scanline-1;
elseif scanline > length(data.year)-3
    ns=length(data.year)-scanline;
else
    ns=3;
end

countICTchapix= scanlineavCounts(meancountICT(scanline-ns:1:scanline+ns,selectchannel),scanline,ns);
countDSVchapix= scanlineavCounts(meancountDSV(scanline-ns:1:scanline+ns,selectchannel),scanline,ns);

countEARTHchapix= countEarth(scanline,scanposview,selectchannel);

% counts of PRTs
PRT1countchapix=PRT1count(scanline);
PRT2countchapix=PRT2count(scanline);
PRT3countchapix=PRT3count(scanline);
PRT4countchapix=PRT4count(scanline);
PRT5countchapix=PRT5count(scanline);
PRT6countchapix=PRT6count(scanline);
PRT7countchapix=PRT7count(scanline);

PRTcountchapix=[PRT1countchapix;PRT2countchapix;PRT3countchapix;PRT4countchapix;PRT5countchapix;PRT6countchapix;PRT7countchapix];

% coefficients of polynomial for PRT-count -Temp. conversion
PRT1coeffchapix=PRT1coeff;
PRT2coeffchapix=PRT2coeff;
PRT3coeffchapix=PRT3coeff;
PRT4coeffchapix=PRT4coeff;
PRT5coeffchapix=PRT5coeff;
PRT6coeffchapix=PRT6coeff;
PRT7coeffchapix=PRT7coeff;

PRTcoeffchapix=[PRT1coeffchapix; PRT2coeffchapix;PRT3coeffchapix; PRT4coeffchapix;PRT5coeffchapix; PRT6coeffchapix;PRT7coeffchapix];


% ICT temperature (FOR HIGH LEVEL MEASUREMENT EQ. DIRECTLY TAKING
% TEMPERATURES FROM DATA RECORD)
ICTtemppix=scanlineavPRTTemp(ICTtempmean,scanline,ns); %average over 7 scanlines

% correcting ICT temp with band correction factors (bcf)
TempofICTcorr=bcfa(selectchannel)+bcfb(selectchannel)*ICTtemppix;

% ICT radiance
radICTchapix= planck(f(selectchannel),TempofICTcorr);%average over 7 scanlines of average of 7 PRT Temperatures obtained from polynomial
% its uncertainty:
radICTuchapix=DplanckDT(f(selectchannel),TempofICTcorr)*bcfb(selectchannel)*ICTutemp;%uncertainty ICTutemp=0.1K form PRT sensors propagated through bandcorrection and planckfunction



% contamination radiances
 CMBPL1corrchapixC0=CMBPL1corrC0(selectchannel,scanposview);%CMBPL1rad(selectchannel,scanposview);
 CMBPL1corrchapixC1=CMBPL1corrC1(selectchannel,scanposview);
 CMBPL1corrchapixC2=CMBPL1corrC2(selectchannel,scanposview);
 PL2radchapix= PL2rad(selectchannel);%DplanckDT(f(selectchannel),2.72548)*PL2temp(selectchannel);%planck(f(selectchannel),PL2corr);%PL2temp(scanline,scanposview,selectchannel);
 SHradchapix=SHcorr;


 % input for calculation
inputforcal.CMBrad=radCMB;
inputforcal.ICTrad=radICTchapix;

inputforcal.countsict=countICTchapix;
inputforcal.countsdsv=countDSVchapix;
inputforcal.countsearth=countEARTHchapix;
inputforcal.PRTcount=PRTcountchapix;
inputforcal.PRTcoeff=PRTcoeffchapix;

inputforcal.invgain=(radICTchapix+SHradchapix-radCMB-PL2radchapix)/(countICTchapix-countDSVchapix);
inputforcal.anl=anl(scanline);

inputforcal.SHrad=SHradchapix;
inputforcal.CMBPL1rad=CMBPL1corrchapixC1*radCMB;%CMBPL1corrchapixC0*countEARTHchapix*inputforcal.invgain;
inputforcal.EarthPL2rad=PL2radchapix;

% build UNCERTAINTY and CORRELATION matrix according to chosen effect
for effectID=1:1:3

if effectID==1
    numterms=vecnumterms(1); 
    % remark: the counts themselves are averaged over 7 scanlines. For the
    % count uncertainties there is only one value for 300 scanlines (so far
    % only onevalue at all!!!). Therefore no averaging necessary.
    u(1)=ucountEarth(selectchannel);%ucountEarth(scanline,scanposview,selectchannel); 
    u(2)=ucountICT(selectchannel);%ucountICT(scanline,ictview,selectchannel);
    u(3)=ucountDSV(selectchannel);%ucountDSV(scanline,dsvview,selectchannel);
    
    r=diag(ones(numterms,1),0);
    
 elseif effectID==2
     numterms=vecnumterms(2);
     %WHAT do we assume here? for now: take 1% of correction. OR: assume
     %some uncertainty of antenna efficiency and propagate it.
     u(1)=inputforcal.CMBPL1rad*0.01;%countEARTHchapix*inputforcal.invgain*CMBPL1ucorr(selectchannel);
     u(2)=PL2urad;
     
     u(3)=0;
     
     r=diag(ones(numterms,1),0);
    
 elseif effectID==3
     numterms=vecnumterms(3);

     u(1)= radICTuchapix;
     
     u(2)=0;
     u(3)=0;
%         
%     for i=1:4
%     u(i)=PRT1ucoeff(scanline,i);
%     u(4+i)=PRT2ucoeff(scanline,i);
%     u(8+i)=PRT3ucoeff(scanline,i);
%     u(12+i)=PRT4ucoeff(scanline,i);
%     u(16+i)=PRT5ucoeff(scanline,i);
%     u(20+i)=PRT6ucoeff(scanline,i);
%     u(24+i)=PRT7ucoeff(scanline,i);
%     
%     
%     end
%    
%    r=PRTrcoeff(scanline,:);
    
    r=diag(ones(numterms,1),0);

end


inputforcal.uncertainty=u;
inputforcal.correlation=r;

%% calculation of uncertainty



% value of uncertainty for the earth radiance at chosen scanline
% and scanviewpos at chosen selectchannel for a chosen effect:
uncertainty(effectID)=uncertainty_singleeffect(effectID,numterms,scanline,scanposview,inputforcal);



%disp([char(10), 'Uncertainty for effectNo ',num2str(effectID), ' at orbit ' , num2str(selectorbit),  ', scanline ', num2str(scanline),', scanposview ', num2str(scanposview), char(10), 'and channel ', num2str(selectchannel), ' is ' num2str(uncertainty), '.'  ])




%% calculation of radiance (evaluate measurement equation)


% 
rad=1/(CMBPL1corrchapixC0+CMBPL1corrchapixC2)*(inputforcal.invgain*(countEARTHchapix-countICTchapix)+radICTchapix-inputforcal.CMBPL1rad+anl(scanline)*inputforcal.invgain^2 *(countEARTHchapix-countICTchapix)*(countEARTHchapix-countDSVchapix));


Tbeff=invplanck(f(selectchannel),rad);
uTbeff(effectID)=DinvplanckDrad(f(selectchannel),rad)*uncertainty(effectID);

% using inverse bandcorrection
Tb=(Tbeff-bcfa(selectchannel))/bcfb(selectchannel);
uTb(effectID)=DinvplanckDrad(f(selectchannel),rad)*(1/bcfb(selectchannel))*uncertainty(effectID);


% calculating Tb without scan angle correction; and calculating the
% difference
rad2=(inputforcal.invgain*(countEARTHchapix-countICTchapix)+radICTchapix+anl(scanline)*inputforcal.invgain^2 *(countEARTHchapix-countICTchapix)*(countEARTHchapix-countDSVchapix));
Tb2eff=invplanck(f(selectchannel),rad2);
Tb2=(Tb2eff-bcfa(selectchannel))/bcfb(selectchannel);
Tbdiff=Tb-Tb2;

end