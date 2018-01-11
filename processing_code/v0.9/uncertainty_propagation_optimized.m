
% uncertainty_propagation
%
 % Copyright (C) 2017-04-12 Imke Hans
 % This code was developed for the EC project �Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)�. 
 % Grant Agreement: 638822
 %  <Version> Reviewed and approved by <name, instituton>, <date>
 %
 %
 %  V 0.1   Reviewed and approved by 
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
 
%% info
% ONLY USE this script via calling function generate_FCDR.m
% DO NOT use this script alone. It needs the output from preceeding
% functions/ scripts generate_FCDR and setup_fullFCDR_uncertproc, measurement_equation.

% Computing the uncertainties in the final brightness temperature due to
% all different sources of uncertainty ("effects")
% This script uses the quantities that are set up in the script
% setup_fullFCDR_uncertproc.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% setup
endofscanlines=scanlinenumbers(end);
nanmatrix_sizebtemps=nan*ones(5,90,endofscanlines);
nanmatrix_sizechsclin=nan*ones(5,endofscanlines);


% FIXME: need to set uncertainty for R_Eprime and Tb_Eprime here. Lets
% assume 0.002 at first
u_R_Eprime=0.002*R_Eprime;
u_Tb_Eprime=0.002*Tb_Eprime;
u_radiance_platform=0.1*mean(mean(R_E,3,'omitnan'),2,'omitnan'); % assume 10% of mean-Earth-Rad. (per channel) as uncertainty, i.e. about 10-20 K

% calculate u_C_E here, as explained in FIXME NoisePerf. Manuscript (need the scene Tb for this, therefore calculate it
% only at this stage)
% 
% reshape and rearrange needed quantities to match the 5x90x2400 dimensions.
quotient=(u_C_IWCT_0-u_C_S_0)./(bsxfun(@times,countIWCT_av,ones(5,1))-bsxfun(@times,countDSV_av,ones(1,size(countIWCT_av,2))));
quotientarr=bsxfun(@times,bsxfun(@times,quotient,ones(1,size(Tb,3))),ones(5,size(Tb,3),90));
quotientarr=permute(quotientarr,[1 3 2]);
TCMBarr=bsxfun(@times,bsxfun(@times,countDSV_av,ones(1,size(Tb,3))),ones(5,size(Tb,3),90));
TCMBarr=permute(TCMBarr,[1 3 2]);
uCSarr=bsxfun(@times,u_C_S_0,ones(5,length(Tb),90));
uCSarr=permute(uCSarr,[1 3 2]);
%actual computation of u_C_E
u_C_E=uCSarr+bsxfun(@times,(earthcounts-TCMBarr),quotientarr);

% Speed of light in a vacuum
c0 = 2.99792458*10.^8; 

%% the partial derivatives per effect

dummy_matrix=ones(size(btemps));

%expand all quantities to this btemps-size to be able to multiply/divide/... all
%quantities. Some time you have to bring them into the chn x fov x scnln
%shape. This does permute(). It includes extra singleton dimension were
%needed.
Antenna_corrcoeff_earthcontribution_mat=bsxfun(@times,Antenna_corrcoeff_earthcontribution,dummy_matrix);
g_Sat_mat=bsxfun(@times,gSAT,dummy_matrix);
R_IWCT_mat=bsxfun(@times,permute(R_IWCT,[1 3 2]),dummy_matrix);
R_E_mat=R_E;
countIWCT_av_mat=bsxfun(@times,permute(countIWCT_av,[1 3 2]),dummy_matrix);
countDSV_av_mat=bsxfun(@times,permute(countDSV_av,[1 3 2]),dummy_matrix);
earthcounts_mat=earthcounts;
nonlincoeff_mat=bsxfun(@times,permute(nonlincoeff,[1 3 2]),dummy_matrix);
R_CMB_mat=bsxfun(@times,permute(R_CMB,[1 3 2]),dummy_matrix);
R_CMB0_mat=bsxfun(@times,permute(R_CMB0,[1 3 2]),dummy_matrix);
T_CMB0_mat=bsxfun(@times,permute(T_CMB0,[1 3 2]),dummy_matrix);
R_Sat_mat=bsxfun(@times,permute(R_Sat,[1 3 2]),dummy_matrix);
alpha_mat=bsxfun(@times,permute(alpha,[2 1 3]),dummy_matrix);
Antenna_position_earthview_mat=bsxfun(@times,permute(Antenna_position_earthview,[3 1 2]),dummy_matrix);
Antenna_position_spaceview_mat=bsxfun(@times,permute(Antenna_position_spaceview,[1 3 2]),dummy_matrix);
R_Eprime_mat=R_Eprime;
IWCTtemp_av_mat=bsxfun(@times,permute(IWCTtemp_av,[1 3 2]),dummy_matrix);
dT_w_mat=bsxfun(@times,permute(dT_w,[1 3 2]),dummy_matrix);
dT_c_mat=bsxfun(@times,permute(dT_c,[1 3 2]),dummy_matrix);
bandcorr_a_mat=bsxfun(@times,permute(bandcorr_a,[1 3 2]),dummy_matrix);
bandcorr_b_mat=bsxfun(@times,permute(bandcorr_b,[1 3 2]),dummy_matrix);
wavenumber_central_mat=bsxfun(@times,permute(wavenumber_central,[1 3 2]),dummy_matrix);
Tb_Eprime_mat=Tb_Eprime;

%expand uncertainties of effects
  u_chnfreq_mat=bsxfun(@times,permute(u_chnfreq,[1 3 2]),dummy_matrix);
  u_bandcorr_a_mat=bsxfun(@times,permute(u_bandcorr_a,[1 3 2]),dummy_matrix);
  u_bandcorr_b_mat=bsxfun(@times,permute(u_bandcorr_b,[1 3 2]),dummy_matrix);
  u_T_IWCT_mat=bsxfun(@times,permute(u_T_IWCT,[1 3 2]),dummy_matrix);
  u_T_IWCT_noise_mat=bsxfun(@times,permute(u_T_IWCT_noise,[1 3 2]),dummy_matrix);
  u_dT_w_mat=bsxfun(@times,permute(u_dT_w,[1 3 2]),dummy_matrix);
  u_T_CMB0_mat=bsxfun(@times,permute(u_T_CMB0,[1 3 2]),dummy_matrix);
  u_dT_c_mat=bsxfun(@times,permute(u_dT_c,[1 3 2]),dummy_matrix);
  u_C_E_mat=u_C_E;
  u_C_IWCT_mat=bsxfun(@times,permute(u_C_IWCT,[1 3 2]),dummy_matrix);
  u_C_S_mat=bsxfun(@times,permute(u_C_S,[1 3 2]),dummy_matrix);
  u_nonlincoeff_mat=bsxfun(@times,permute(u_nonlincoeff,[1 3 2]),dummy_matrix);
  u_alpha_mat=bsxfun(@times,permute(u_alpha,[2 3 1]),dummy_matrix);
  u_Tb_Eprime_mat=u_Tb_Eprime;
  u_Antenna_position_earthview_mat=bsxfun(@times,permute(u_Antenna_position_earthview,[3 1 2]),dummy_matrix);
  u_Antenna_position_spaceview_mat=bsxfun(@times,permute(u_Antenna_position_spaceview,[1 3 2]),dummy_matrix);
  u_Antenna_corrcoeff_earthcontribution_mat=bsxfun(@times,permute(u_Antenna_corrcoeff_earthcontribution,[1 2 3]),dummy_matrix);
  u_Antenna_corrcoeff_spacecontribution_mat=bsxfun(@times,permute(u_Antenna_corrcoeff_spacecontribution,[1 2 3]),dummy_matrix);
  u_Antenna_corrcoeff_platformcontribution_mat=bsxfun(@times,permute(u_Antenna_corrcoeff_platformcontribution,[1 2 3]),dummy_matrix);
  u_radiance_platform_mat=bsxfun(@times,permute(u_radiance_platform,[1 3 2]),dummy_matrix);

    
    % Channel frequency
    % intermediate steps: 
    dRIWCT_df= DplanckDf(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(IWCTtemp_av_mat+dT_w_mat));
    dRCMB_df= DplanckDf(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat+dT_c_mat));
    dRCMB0_df= DplanckDf(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat));

    % bandcorrection a
    % intermediate steps:
    dRIWCT_da= DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(IWCTtemp_av_mat+dT_w_mat));
    dRCMB_da= DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat+dT_c_mat));
    dRCMB0_da= DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat));

    % bandcorrection b
    % intermediate steps:
    dRIWCT_db= (IWCTtemp_av_mat+dT_w_mat).*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(IWCTtemp_av_mat+dT_w_mat));
    dRCMB_db= (T_CMB0_mat+dT_c_mat).*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat+dT_c_mat));
    dRCMB0_db= (T_CMB0_mat).*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat));

   

% DSV counts
u_rad_C_S=-1/(Antenna_corrcoeff_earthcontribution_mat).* (R_IWCT_mat-R_CMB_mat).*(earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat).^2 .*(1+nonlincoeff_mat.*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).* (-2*earthcounts_mat+countIWCT_av_mat+countDSV_av_mat));

% IWCT Counts
u_rad_C_IWCT=-1/(Antenna_corrcoeff_earthcontribution_mat).* (R_IWCT_mat-R_CMB_mat).*(earthcounts_mat-countDSV_av_mat)./(countIWCT_av_mat-countDSV_av_mat).^2 .*(-1+nonlincoeff_mat.*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).* (-2*earthcounts_mat+countIWCT_av_mat+countDSV_av_mat));

% Earth Counts
u_rad_C_E=-1/(Antenna_corrcoeff_earthcontribution_mat).* (R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat) .*(-1+nonlincoeff_mat.*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).* (-2*earthcounts_mat+countIWCT_av_mat+countDSV_av_mat));


% Temperature of Blackbody (IWCT temperature)
u_rad_T_IWCT=1/(Antenna_corrcoeff_earthcontribution_mat).*bandcorr_b_mat.*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(IWCTtemp_av_mat+dT_w_mat)).*(1+(earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat)+2*nonlincoeff_mat.*(earthcounts_mat-countIWCT_av_mat).*(earthcounts_mat-countDSV_av_mat).*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).^2).*(1-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat))))+(alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)))).*bandcorr_b_mat.*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(IWCTtemp_av_mat+dT_w_mat));

% channel frequency
% this calculates derivative wrt frequency. it uses the intermediates steps
% performes outside the fov-loop
u_rad_chnfreq=1/(Antenna_corrcoeff_earthcontribution_mat).*(dRIWCT_df+(earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat).*(dRIWCT_df-dRCMB_df)+2*nonlincoeff_mat.*(earthcounts_mat-countIWCT_av_mat).*(earthcounts_mat-countDSV_av_mat).*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).^2 .*(dRIWCT_df-dRCMB_df)-(1-Antenna_corrcoeff_earthcontribution_mat).*dRCMB0_df).*(1-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat))))+(alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)))).*dRIWCT_df;
% FIXME the following two lines are wrong
% transform to dRe/df=dRe/dnu *dnu/df=dRe/dnu *1/c
%u_rad_chnfreq(channel,fov,:)=u_rad_chnnu(channel,fov,:).*1/c0;

% bandcorrection a
% it uses the intermediates steps
% performes outside the fov-loop
u_rad_bandcorr_a=1/(Antenna_corrcoeff_earthcontribution_mat).*(dRIWCT_da+(earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat).*(dRIWCT_da-dRCMB_da)+2*nonlincoeff_mat.*(earthcounts_mat-countIWCT_av_mat).*(earthcounts_mat-countDSV_av_mat).*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).^2 .*(dRIWCT_da-dRCMB_da)-(1-Antenna_corrcoeff_earthcontribution_mat).*dRCMB0_da).*(1-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat))))+(alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)))).*dRIWCT_da;

% bandcorrection b
% it uses the intermediates steps
% performes outside the fov-loop
u_rad_bandcorr_b=1/(Antenna_corrcoeff_earthcontribution_mat).*(dRIWCT_db+(earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat).*(dRIWCT_db-dRCMB_db)+2*nonlincoeff_mat.*(earthcounts_mat-countIWCT_av_mat).*(earthcounts_mat-countDSV_av_mat).*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).^2 .*(dRIWCT_db-dRCMB_db)-(1-Antenna_corrcoeff_earthcontribution_mat).*dRCMB0_db).*(1-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat))))+(alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)))).*dRIWCT_db;


% warm bias correction (derivative is the same as for T_IWCT)
u_rad_dT_w=1/(Antenna_corrcoeff_earthcontribution_mat).*bandcorr_b_mat.*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(IWCTtemp_av_mat+dT_w_mat)).*(1+(earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat)+2*nonlincoeff_mat.*(earthcounts_mat-countIWCT_av_mat).*(earthcounts_mat-countDSV_av_mat).*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat).^2).*(1-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat))))+(alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)))).*bandcorr_b_mat.*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(IWCTtemp_av_mat+dT_w_mat));

% cold bias correction
u_rad_dT_c=-1/(Antenna_corrcoeff_earthcontribution_mat).* (earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat) .*(1+2*nonlincoeff_mat.*(earthcounts_mat-countDSV_av_mat).*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat)).*(1-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)))).*bandcorr_b_mat.*DplanckDT(invcm2hz(wavenumber_central_mat), T_CMB0_mat);

% non-linearity coefficient
u_rad_nonlincoeff=1/(Antenna_corrcoeff_earthcontribution_mat).*(earthcounts_mat-countDSV_av_mat).*(earthcounts_mat-countIWCT_av_mat).*(R_IWCT_mat-R_CMB_mat).^2./(countIWCT_av_mat-countDSV_av_mat).^2;

% CMB0 temperature
u_rad_T_CMB0=((-1/(Antenna_corrcoeff_earthcontribution_mat).* (earthcounts_mat-countIWCT_av_mat)./(countIWCT_av_mat-countDSV_av_mat).*bandcorr_b_mat.*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat+dT_c_mat)) .*(1+2*nonlincoeff_mat.*(earthcounts_mat-countDSV_av_mat).*(R_IWCT_mat-R_CMB_mat)./(countIWCT_av_mat-countDSV_av_mat))-(1-Antenna_corrcoeff_earthcontribution_mat)./Antenna_corrcoeff_earthcontribution_mat).*bandcorr_b_mat.*DplanckDT(invcm2hz(wavenumber_central_mat), bandcorr_a_mat+bandcorr_b_mat.*(T_CMB0_mat))).*(1-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat))));

% alpha Quotient of reflectivities 
u_rad_alpha=1/(2*Antenna_corrcoeff_earthcontribution_mat).*(R_IWCT_mat-R_Eprime_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)));

% Radiance of Earth scene in main beam, calculated without polarisation correction
u_rad_R_Eprime=-alpha_mat./(2*Antenna_corrcoeff_earthcontribution_mat).*(cos(deg2rad(2*Antenna_position_earthview_mat))-cos(deg2rad(2*Antenna_position_spaceview_mat)));

% Antenna position Space views
u_rad_Antenna_position_spaceview=alpha_mat./Antenna_corrcoeff_earthcontribution_mat .* (R_IWCT_mat-R_Eprime_mat).* sin(deg2rad(2*Antenna_position_spaceview_mat));

% Antenna position Earth views
u_rad_Antenna_position_earthview=-alpha_mat./Antenna_corrcoeff_earthcontribution_mat .* (R_IWCT_mat-R_Eprime_mat).* sin(deg2rad(2*Antenna_position_earthview_mat));

% Antenna correction coefficients for Earth conntribution
u_rad_Antenna_corrcoeff_earthcontribution=-1/Antenna_corrcoeff_earthcontribution_mat.^2.*(R_E_mat-(1-Antenna_corrcoeff_earthcontribution_mat-(1-assumption).*g_Sat_mat).*R_CMB0_mat-(1-assumption).*g_Sat_mat.*R_Sat_mat);%-1/Antenna_corrcoeff_earthview_mat .*(R_E_mat-R_CMB0_mat);


% Antenna correction coefficients for Space contribution
u_rad_Antenna_corrcoeff_spacecontribution=-1/Antenna_corrcoeff_earthcontribution_mat.*R_CMB0_mat;

% Antenna correction coefficients for Platform contribution
u_rad_Antenna_corrcoeff_platformcontribution=-1/Antenna_corrcoeff_earthcontribution_mat.*((1-assumption).*R_Sat_mat);


% Radiance of platform
u_rad_radiance_platform=-g_Sat_mat./Antenna_corrcoeff_earthcontribution_mat;



%% convert to brightness temperature

% need derivative of inverse planck-function wrt R_E
dTb_dRE=DinvplanckDrad(invcm2hz(wavenumber_central_mat),R_E_mat);



% now calculate Delta T_b=dTb_dRE * u_rad_x *Delta x

  u_btemps_chnfreq=dTb_dRE.*u_rad_chnfreq.*u_chnfreq_mat;
  u_btemps_bandcorr_a=dTb_dRE.*u_rad_bandcorr_a.*u_bandcorr_a_mat;
  u_btemps_bandcorr_b=dTb_dRE.*u_rad_bandcorr_b.*u_bandcorr_b_mat;
  u_btemps_T_IWCT=dTb_dRE.*u_rad_T_IWCT.*u_T_IWCT_mat;
  u_btemps_T_IWCT_noise=dTb_dRE.*u_rad_T_IWCT.*u_T_IWCT_noise_mat;
  u_btemps_dT_w=dTb_dRE.*u_rad_dT_w.*u_dT_w_mat;
  u_btemps_T_CMB0=abs(dTb_dRE.*u_rad_T_CMB0.*u_T_CMB0_mat);
  u_btemps_dT_c=dTb_dRE.*u_rad_dT_c.*u_dT_c_mat;
  u_btemps_C_E=abs(dTb_dRE.*u_rad_C_E.*u_C_E_mat);
  u_btemps_C_IWCT=dTb_dRE.*u_rad_C_IWCT.*u_C_IWCT_mat;
  u_btemps_C_S=dTb_dRE.*u_rad_C_S.*u_C_S_mat;
  u_btemps_nonlincoeff=dTb_dRE.*u_rad_nonlincoeff.*u_nonlincoeff_mat;
  u_btemps_alpha=dTb_dRE.*u_rad_alpha.*u_alpha_mat;
  u_btemps_Tb_Eprime=abs(dTb_dRE.*u_rad_R_Eprime.*DplanckDT(invcm2hz(wavenumber_central_mat), Tb_Eprime_mat).*u_Tb_Eprime_mat);
  u_btemps_Antenna_position_earthview=dTb_dRE.*u_rad_Antenna_position_earthview.*u_Antenna_position_earthview_mat;
  u_btemps_Antenna_position_spaceview=dTb_dRE.*u_rad_Antenna_position_spaceview.*u_Antenna_position_spaceview_mat;
  u_btemps_Antenna_corrcoeff_earthcontribution=abs(dTb_dRE.*u_rad_Antenna_corrcoeff_earthcontribution.*u_Antenna_corrcoeff_earthcontribution_mat);
  u_btemps_Antenna_corrcoeff_spacecontribution=abs(dTb_dRE.*u_rad_Antenna_corrcoeff_spacecontribution.*u_Antenna_corrcoeff_spacecontribution_mat);
  u_btemps_Antenna_corrcoeff_platformcontribution=abs(dTb_dRE.*u_rad_Antenna_corrcoeff_platformcontribution.*u_Antenna_corrcoeff_platformcontribution_mat);
  u_btemps_radiance_of_platform=abs(dTb_dRE.*u_rad_radiance_platform.*u_radiance_platform_mat);
  
  
  
  
  
  u_lat=0*lat_data;%0*lat;
  u_lon=0*long_data;%0*lon;
  u_datasatazang=0*sat_az_ang;%0*datasatazang;
  u_datasatzenang=0*sat_zen_ang_data;%0*datasatzenang;
  u_datasolazang=0*sol_az_ang;%0*datasolazang;
  u_datasolzenang=0*sol_zen_ang_data;%0*datasolzenang;







%% calculate random/systematic/structured random and total uncertainty in btemps

u_random_btemps=sqrt(u_btemps_C_E.^2+u_btemps_Antenna_position_earthview.^2);

u_nonrandom_btemps=sqrt(u_btemps_C_S.^2+u_btemps_C_IWCT.^2+u_btemps_Antenna_position_spaceview.^2+u_btemps_T_IWCT_noise.^2+u_btemps_chnfreq.^2+u_btemps_bandcorr_a.^2+u_btemps_bandcorr_b.^2+u_btemps_T_IWCT.^2+u_btemps_dT_w.^2+u_btemps_T_CMB0.^2+u_btemps_dT_c.^2+u_btemps_nonlincoeff.^2+u_btemps_alpha.^2+u_btemps_Tb_Eprime.^2+u_btemps_Antenna_corrcoeff_earthcontribution.^2+u_btemps_Antenna_corrcoeff_spacecontribution.^2+u_btemps_Antenna_corrcoeff_platformcontribution.^2+u_btemps_radiance_of_platform.^2);



u_total_btemps=sqrt(u_btemps_C_S.^2+u_btemps_C_IWCT.^2+u_btemps_C_E.^2+u_btemps_chnfreq.^2+u_btemps_bandcorr_a.^2+u_btemps_bandcorr_b.^2+u_btemps_T_IWCT.^2+u_btemps_T_IWCT_noise.^2+u_btemps_dT_w.^2+u_btemps_T_CMB0.^2+u_btemps_dT_c.^2+u_btemps_nonlincoeff.^2+u_btemps_alpha.^2+u_btemps_Tb_Eprime.^2+u_btemps_Antenna_position_earthview.^2+u_btemps_Antenna_position_spaceview.^2+u_btemps_Antenna_corrcoeff_earthcontribution.^2+u_btemps_Antenna_corrcoeff_spacecontribution.^2+u_btemps_Antenna_corrcoeff_platformcontribution.^2+u_btemps_radiance_of_platform.^2);

%FIXME: introduce flag that is set if any of the (during processing evaluated) uncertainties is exactly
%zero. Then, "the uncertainty information is not complete since the uncertainty information for at least
%one variable is missing"
% u_btemps_C_S(isnan(u_btemps_C_S))=0;
% u_btemps_C_IWCT(isnan(u_btemps_C_IWCT))=0;
% u_btemps_C_E(isnan(u_btemps_C_E))=0;
% u_btemps_T_IWCT(isnan(u_btemps_T_IWCT))=0;
% u_btemps_T_IWCT_noise (isnan(u_btemps_T_IWCT_noise))=0;
% u_btemps_dT_w(isnan(u_btemps_dT_w))=0;
% u_btemps_nonlincoeff(isnan(u_btemps_nonlincoeff))=0;
% 
% qualflag_allchn_uncert_incomplete= ~u_btemps_C_S | ~u_btemps_C_IWCT | ~u_btemps_C_E  |~u_btemps_T_IWCT |~u_btemps_T_IWCT_noise |~u_btemps_dT_w |~u_btemps_nonlincoeff;
qualflag_allchn_uncert_incomplete=1*ones(5,90,scanlinenumbers(end));
qualflag_allchn_uncert_incomplete= isnan(u_btemps_C_S) | isnan(u_btemps_C_IWCT) | isnan(u_btemps_C_E) | isnan(u_btemps_T_IWCT) | isnan(u_btemps_T_IWCT_noise) |isnan(u_btemps_dT_w) |isnan(u_btemps_nonlincoeff);


% all but u_btemps_nonlincoeff are significant (not negligible small)
