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



% measurement_equation.m

 
%% info
% ONLY USE this script via calling function process_FCDR.m.
% DO NOT use this script alone. It needs the output from preceeding
% functions/ scripts.


% this script evaluates the measurement equation, i.e. it executes the
% calibration. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize Tb,Tb_EPrime,R_Eprime,...
R_IWCT=nan*ones(5,scanlinenumbers(end));
R_CMB0=nan*ones(5,scanlinenumbers(end));
R_CMB=nan*ones(5,scanlinenumbers(end));
R_Sat=nan*ones(5,scanlinenumbers(end));
%R_MEprime=nan*ones(5,number_of_fovs,scanlinenumbers(end));
R_ME=nan*ones(5,number_of_fovs,scanlinenumbers(end));
delta_R_pol=nan*ones(5,number_of_fovs,scanlinenumbers(end));
R_Eprime=nan*ones(5,number_of_fovs,scanlinenumbers(end));
Tb_Eprime=nan*ones(5,number_of_fovs,scanlinenumbers(end));
R_E=nan*ones(5,number_of_fovs,scanlinenumbers(end));
Tb=nan*ones(5,number_of_fovs,scanlinenumbers(end));

%% setup evaluation of equation
%the following line was for calculating R_IWCT for all channel at once. But the
%function "planck" cannot handle this, yet.
%R_IWCT(channel,:)=planck(wavenumber_central(channel),bandcorr_a(channel)*ones(1,length(IWCTtemp_av))+bsxfun(@times,bandcorr_b(channel),(IWCTtemp_av(channel)+dT_w(channel))));

% calculate radiances for Blackbody and space

for index=1:length(channelset)
    channel=channelset(index);
R_IWCT(channel,:)=planck(invcm2hz(wavenumber_central(channel)),bandcorr_a(channel)+bandcorr_b(channel)*(IWCTtemp_av(channel,:)+dT_w(channel,:)));
R_CMB0(channel,:)=planck(invcm2hz(wavenumber_central(channel)),bandcorr_a_s(channel)+bandcorr_b_s(channel)*(2.72548));
R_CMB(channel,:)=planck(invcm2hz(wavenumber_central(channel)),bandcorr_a_s(channel)+bandcorr_b_s(channel)*(2.72548+dT_c(channel)));
%assume R_sat (i.e. R_pl)
R_Sat(channel,:)=planck(invcm2hz(wavenumber_central(channel)),bandcorr_a(channel)+bandcorr_b(channel)*0*250);%*2.72548 *instrtemp
end

%% EVALUATE MEASUREMENT EQUATION
%measurement equation without polarization correction


for index=1:length(channelset)
    channel=channelset(index);
for fov=1:number_of_fovs
    Antenna_corrcoeff_earthcontribution_pix=Antenna_corrcoeff_earthcontribution(channel,fov);
    
    g_S_pix=gS(channel,fov);
    g_Sat_pix=gSAT(channel,fov);
    R_Sat_pix=R_Sat(channel);
    
    R_IWCT_pix=R_IWCT(channel,:);
    countIWCT_av_pix=countIWCT_av(channel,:);
    countDSV_av_pix=countDSV_av(channel,:);
    earthcounts_pix=squeeze(earthcounts(channel,fov,:)).';
    nonlincoeff_pix=nonlincoeff(channel,:);
    R_CMB_pix=R_CMB(channel);
    R_CMB0_pix=R_CMB0(channel);
    
    alpha_pix=alpha(channel);
    Antenna_position_earthview_pix=Antenna_position_earthview(fov,:);
    Antenna_position_spaceview_pix=Antenna_position_spaceview;
    
R_ME(channel,fov,:)=R_IWCT_pix+(R_IWCT_pix-R_CMB_pix*ones(1,length(R_IWCT_pix)))./(countIWCT_av_pix-countDSV_av_pix).*(earthcounts_pix-countIWCT_av_pix)+nonlincoeff_pix.*(earthcounts_pix-countDSV_av_pix).*(earthcounts_pix-countIWCT_av_pix).*(R_IWCT_pix-R_CMB_pix*ones(1,length(R_IWCT_pix))).^2./(countIWCT_av_pix-countDSV_av_pix).^2;    
R_ME_pix=squeeze(R_ME(channel,fov,:)).';

% apply antenna pattern correction
% compute REprime as radiance WITHOUT polaris. corr.
R_Eprime(channel,fov,:)=1/Antenna_corrcoeff_earthcontribution_pix*(R_ME_pix-(1-Antenna_corrcoeff_earthcontribution_pix-(1-assumption)*g_Sat_pix)*R_CMB0_pix-(1-assumption)*g_Sat_pix*R_Sat_pix);%%%(1-Antenna_corrcoeff_earthview_pix) the variable assumption allows for switching between "using AAPP assumption R_pl=R_e" and "not using it, assume different R_pl".)
R_Eprime_pix=squeeze(R_Eprime(channel,fov,:)).';

%polarisation correction
delta_R_pol(channel,fov,:)=(alpha_pix.*(R_IWCT_pix-R_Eprime_pix)).*0.5.*(cos(deg2rad(2*Antenna_position_earthview_pix))-cos(deg2rad(2*Antenna_position_spaceview_pix)));
delta_R_pol_pix=squeeze(delta_R_pol(channel,fov,:)).';

R_E(channel,fov,:)=R_Eprime_pix+delta_R_pol_pix;

% apply bandcorrection factors for inversion as well
% (AAPP seems to do this in AAPP7AAPP/src/preproc/libatovin/inbprc.F) 
Tb(channel,fov,:)=1/bandcorr_b(channel)*(invplanck(invcm2hz(wavenumber_central(channel)),R_E(channel,fov,:))-bandcorr_a(channel));
Tb_Eprime(channel,fov,:)=1/bandcorr_b(channel)*(invplanck(invcm2hz(wavenumber_central(channel)),R_Eprime(channel,fov,:))-bandcorr_a(channel));




end
end


btemps=Tb;

% set quality flag for TB values out of range
qualbit_tb_badrange=zeros(size(btemps));
qualbit_tb_badrange(btemps<90 | btemps>320)=1;
