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

 
 
% XX_measurement_equation_singlepixel.m


%% info
% This script IS NOT part of the processing chain of the FCDR_generator. It
% only evaluates the measurement equation for a single pixel. 
% The purpose is only for investigation of the calibration behaviour if
% changing certain aspects in the measurement equation/ its parameters.

% The input values for this pixel can be set in this script or read from 
% any loaded suitable data source containing level1b data.

% For example: "data" is a stucture entry that was filled previously
% with data from a matchup data set.
% However, the input values can be hard coded as explicit numbers as well.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% setup evaluation of equation

% make sure you choose the correct coeffs_XX.mat file for your sensor.



load 'coeffs_metopamhs_antcorr_alpha.mat'

channel=3; %choose channel
assumption=1; %AAPP assumption gPL=gE


wavenumber_central=6.1145634290773252;
bandcorr_a=0;%0.00298;%-0.0167;%-0.0031;
bandcorr_b=1;%1.00138;%1.00145;%1.00027;
A_s=0;%0.00392;%0.00397;
b_s=1;%0.99811;%0.99857;

% dT_w=0;%0.1;%0;
% dT_c=0.71;%13.99+0.71;%0.71;%0.91;
% nonlincoeff=-15.155;%2209;%-15.155;%-15.154999999999999;%-2.9537E+01;%-15.154999999999999;%5.0565*10;%-2.9537E+01;%5.0565*10;%-15.154999999999999;
% alpha(channel)=-0.0022;%0.1;%-0.0022;%-0.0022;

% data_nom or data_harm takes the parameters [dT_w dT_c nonlin alpha]
data_nom=[0 0.71 -15.155 0];
data_harm=[0.07 0.71+13.30 1744.7 0.0774];%[0.1 0.71+13.99 2209 0.1];[0.063 0.52 1701 0.1266]

data_coef=data_harm;

dT_w=data_coef(1);
dT_c=data_coef(2);
nonlincoeff=data_coef(3);
alpha(channel)=data_coef(4);

fov_vec=data.fov;
IWCTtemp_av=data.iwct_temp_mean;%mean([282.4326875 282.4351250 282.4325625 282.4398125 282.5183125]);%
countIWCT_av= data.iwctmean;%47979.78125;%48380.7;%26189.7+50; %48398.8125 %48409.1250;
countDSV_av= data.dsvmean;%8624.203125;%10787.2;%22353.2-250; %10720.8906; %10728.2656 %10801.2969;
earthcounts= data.earth;%45690.0;%41755.0;%[25000:0.1:26300];%42624.0000;%42648.0000 %41333.0000;
Antenna_position_earthview(fov_vec)=1.111*(fov_vec-45.5);%48.3329 ;%0.5;%180-48.8;



Antenna_position_spaceview=73.6;%253.6;


Antenna_corrcoeff_earthcontribution=gE+gSAT;




R_IWCT=planck(invcm2hz(wavenumber_central),bandcorr_a+bandcorr_b*(IWCTtemp_av+dT_w));
R_CMB0=planck(invcm2hz(wavenumber_central),A_s+b_s*(2.72548));
R_CMB=planck(invcm2hz(wavenumber_central),A_s+b_s*(2.72548+dT_c));
%assume R_sat (i.e. R_pl)
R_Sat=planck(invcm2hz(wavenumber_central),bandcorr_a+bandcorr_b*0*250);%*2.72548 *instrtemp


%% EVALUATE MEASUREMENT EQUATION
%measurement equation without polarization correction


for iline=1:length(earthcounts)-1
    fov=fov_vec(iline);
    Antenna_corrcoeff_earthcontribution_pix=Antenna_corrcoeff_earthcontribution(channel,fov);
    
    g_S_pix=gS(channel,fov);
    g_Sat_pix=gSAT(channel,fov);
    
    R_Sat_pix=R_Sat;
    
    R_IWCT_pix=R_IWCT(iline);
    countIWCT_av_pix=countIWCT_av(iline);
    countDSV_av_pix=countDSV_av(iline);
    earthcounts_pix=squeeze(earthcounts(iline)).';
    nonlincoeff_pix=nonlincoeff;
    R_CMB_pix=R_CMB;
    R_CMB0_pix=R_CMB0;
    
    alpha_pix=alpha(channel);
    Antenna_position_earthview_pix=Antenna_position_earthview(fov);
    Antenna_position_spaceview_pix=Antenna_position_spaceview;
    
R_ME(channel,fov,iline)=R_IWCT_pix+(R_IWCT_pix-R_CMB_pix*ones(1,length(R_IWCT_pix)))./(countIWCT_av_pix-countDSV_av_pix).*(earthcounts_pix-countIWCT_av_pix)+nonlincoeff_pix.*(earthcounts_pix-countDSV_av_pix).*(earthcounts_pix-countIWCT_av_pix).*(R_IWCT_pix-R_CMB_pix*ones(1,length(R_IWCT_pix))).^2./(countIWCT_av_pix-countDSV_av_pix).^2;    
R_ME_pix=squeeze(R_ME(channel,fov,iline)).';

% apply antenna pattern correction
% compute REprime as radiance WITHOUT polaris. corr.
R_Eprime(channel,fov,iline)=1/Antenna_corrcoeff_earthcontribution_pix*(R_ME_pix-(1-Antenna_corrcoeff_earthcontribution_pix-(1-assumption)*g_Sat_pix)*R_CMB0_pix-(1-assumption)*g_Sat_pix*R_Sat_pix);%%%(1-Antenna_corrcoeff_earthview_pix) the variable assumption allows for switching between "using AAPP assumption R_pl=R_e" and "not using it, assume different R_pl".)
R_Eprime_pix=squeeze(R_Eprime(channel,fov,iline)).';

%polarisation correction
delta_R_pol(channel,fov,iline)=(alpha_pix.*(R_IWCT_pix-R_Eprime_pix)).*0.5.*(cos(deg2rad(2*Antenna_position_earthview_pix))-cos(deg2rad(2*Antenna_position_spaceview_pix)));
delta_R_pol_pix=squeeze(delta_R_pol(channel,fov,iline)).';

R_E(channel,fov,iline)=R_Eprime_pix+delta_R_pol_pix;

% apply bandcorrection factors for inversion as well
% (AAPP seems to do this in AAPP7AAPP/src/preproc/libatovin/inbprc.F) 
Tb(channel,fov,iline)=1/bandcorr_b*(invplanck(invcm2hz(wavenumber_central),R_E(channel,fov,iline))-bandcorr_a);

Tb_Eprime(channel,fov,iline)=1/bandcorr_b*(invplanck(invcm2hz(wavenumber_central),R_Eprime(channel,fov,iline))-bandcorr_a);

% delta_T_pol(channel,fov,:)=(alpha_pix.*(IWCTtemp_av+dT_w-Tb_Eprime(channel,fov,iline))).*0.5.*(cos(deg2rad(2*Antenna_position_earthview_pix))-cos(deg2rad(2*Antenna_position_spaceview_pix)));
% delta_T_pol_pix=squeeze(delta_T_pol(channel,fov,:)).';
% Tb(channel,fov,iline)=Tb_Eprime(channel,fov,iline)+delta_T_pol_pix;
matchup_Tb(iline)=Tb(channel,fov,iline);
end





btemps=Tb;

