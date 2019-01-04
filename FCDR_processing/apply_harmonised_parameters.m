
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

% apply_harmonised_parameters.m

%% WARNING WARNING WARNING
% This script is NOT YET used in the processing of the FCDR. It would be
% used in the setup_XX_2l1c., scripts, once it is ready. The analysis on
% harmonisation is NOT yet accomplished, i.e. there are NO consolidated
% harmonisation parameters to be filled in non-linearity, polarisation
% correction etc in this script. So far, this script ONLY contains trial
% parameter values. There parameters MUST NOT  be used for reasonable
% processing and calibration.

%% info
% This script sets the new, optimised values for the harmonisation
% parameters (in cluding their uncertainties)

% This script is called after the nominal setup, i.e. old values for the
% parameters are overwritten by this script.

% choose for which parameters you want to use harmonised values.
% 1= use harmonised
% 0= use operational, i.e. this script is without effect on this parameter.

% Then make sure you include the actual values in the respective lines below!
non_lin=0;
warm_target=0;
cold_target=0;
polarisation=0;
   

%-------------------------------------------------------------------------%
% Nonlinearity q_nl
if non_lin==1
%HARMONISED PARAMETER
  if strcmp(sat,'noaa18')
      %do nothing. N18 is reference 
  else
      % divide by 1000 since the ch3_a_1 is put into
      % the vector non_lin_min, etc, below which is
      % multiplied by 1000 (to get all other channels
      % right), hence 1000/1000 leaves the ch3_a_1 as
      % its numerator says.
      if strcmp(sat,'noaa19')
          ch3_a_1=2473.15/1000;
      elseif strcmp(sat,'metopa')
          ch3_a_1=1744.7/1000;%-121.92/1000;%2209.03/1000;%-1340.73/1000;%256.04/1000;
      elseif strcmp(sat,'metopb')
          ch3_a_1=-481.92/1000;
      end
      
      non_lin_min=double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_min_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_min_temperature;ch3_a_1;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_min_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_min_temperature])*1000;
      non_lin_nominal=double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_nominal_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_nominal_temperature;ch3_a_1;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_nominal_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_nominal_temperature])*1000;
      non_lin_max=double([hdrinfo.LO_A_CH_H1_nonlinearity_coeff_max_temperature; hdrinfo.LO_A_CH_H2_nonlinearity_coeff_max_temperature;ch3_a_1;hdrinfo.LO_A_CH_H4_nonlinearity_coeff_max_temperature;hdrinfo.LO_A_CH_H5_nonlinearity_coeff_max_temperature])*1000;

      % calculate interpolation parameters (slope, offset)
                      clear mA nA mB nB m n
                        for channel=1:5
                        mA=(non_lin_min(channel)-non_lin_nominal(channel))/(T1-T2);
                        nA=non_lin_nominal(channel)-mA*T2;

                        mB=(non_lin_nominal(channel)-non_lin_max(channel))/(T2-T3);
                        nB=(non_lin_max(channel)-mB*T3);

                        m(:,channel)=[mA mB];
                        n(:,channel)=[nA nB];
                        end

                            %check if instrtemp smaller than ref.Temp for lin interpol. --> take first
                            %interploation:
                            % repmat only for expansion to use elementwise
                            % multiplication
                            m_used=repmat(logical(instrtemp<T2),[5 1]).*repmat(m(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(m(2,:),[length(instrtemp) 1]).';
                            n_used=repmat(logical(instrtemp<T2),[5 1]).*repmat(n(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(n(2,:),[length(instrtemp) 1]).';
                            
                            % calc nonlincoeff by interpolation
                            nonlincoeff=m_used.*repmat(instrtemp,[5 1])+n_used;
      
      % UNCERTAINTY 
    if strcmp(sat,'noaa19')
          u_nonlincoeff(3,:)=126.48/1000;
    elseif strcmp(sat,'metopa')
          u_nonlincoeff(3,:)=8.12/1000;%302.62/1000;%832.07/1000;%45.44/1000;
    elseif strcmp(sat,'metopb')
          u_nonlincoeff(3,:)=53.46/1000;
    end
    disp(['Harmonised: non-linearity ',num2str(nonlincoeff(3,3)*1000)]) 
  end
                     

end

%-------------------------------------------------------------------------%
% Warm target correction dT_w
if warm_target==1
%HARMONISED PARAMETER

    if strcmp(sat,'noaa18')
      %do nothing. N18 is reference % we estimate 100% uncertainty since we do not know why all channels get the same value...
    else

      if strcmp(sat,'noaa19')
          ch3_dT_w=7.76;
      elseif strcmp(sat,'metopa')
          ch3_dT_w=0.07;%-0.34;%-1.0;%-0.9;
      elseif strcmp(sat,'metopb')
          ch3_dT_w=-1.55;
      end
      
        dT_w_min=double([hdrinfo.Ch_H1_warm_load_correction_factor_min_temperature; hdrinfo.Ch_H2_warm_load_correction_factor_min_temperature;ch3_dT_w;hdrinfo.Ch_H4_warm_load_correction_factor_min_temperature;hdrinfo.Ch_H5_warm_load_correction_factor_min_temperature]);
        dT_w_nom=double([hdrinfo.Ch_H1_warm_load_correction_factor_nominal_temperature; hdrinfo.Ch_H2_warm_load_correction_factor_nominal_temperature; ch3_dT_w; hdrinfo.Ch_H4_warm_load_correction_factor_nominal_temperature; hdrinfo.Ch_H5_warm_load_correction_factor_nominal_temperature]);
        dT_w_max=double([hdrinfo.Ch_H1_warm_load_correction_factor_max_temperature;hdrinfo.Ch_H2_warm_load_correction_factor_max_temperature;ch3_dT_w;hdrinfo.Ch_H4_warm_load_correction_factor_max_temperature;hdrinfo.Ch_H5_warm_load_correction_factor_max_temperature]);

     % calculate interpolation parameters (slope, offset)
                        for channel=1:5
                        mA=(dT_w_min(channel)-dT_w_nom(channel))/(T1-T2);
                        nA=dT_w_nom(channel)-mA*T2;

                        mB=(dT_w_nom(channel)-dT_w_max(channel))/(T2-T3);
                        nB=(dT_w_max(channel)-mB*T3);

                        m(:,channel)=[mA mB];
                        n(:,channel)=[nA nB];
                        end

                            %check if instrtemp smaller than ref.Temp for lin interpol. --> take first
                            %interploation:
                            % repmat only for expansion to use elementwise
                            % multiplication
                            m_used_dT_w=repmat(logical(instrtemp<T2),[5 1]).*repmat(m(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(m(2,:),[length(instrtemp) 1]).';
                            n_used_dT_w=repmat(logical(instrtemp<T2),[5 1]).*repmat(n(1,:),[length(instrtemp) 1]).'+repmat(logical(instrtemp>=T2),[5 1]).*repmat(n(2,:),[length(instrtemp) 1]).';
                            
                            % calc nonlincoeff by interpolation
                            dT_w=m_used_dT_w.*repmat(instrtemp,[5 1])+n_used_dT_w;
                        
     % UNCERTAINTY
        if strcmp(sat,'noaa19')
              u_dT_w(3,:)=0.52;
        elseif strcmp(sat,'metopa')
              u_dT_w(3,:)=0.02;%0.29;%0.16;
        elseif strcmp(sat,'metopb')
              u_dT_w(3,:)=0.17;
        end                        
        disp(['Harmonised: warm target ',num2str(dT_w(3,3))])                 
    end
    
end
%-------------------------------------------------------------------------%
% cold target correction dT_c

if cold_target==1
% HARMONISED PARAMETER

if strcmp(sat,'noaa18')
      %do nothing. N18 is reference % we estimate 100% uncertainty since we do not know why all channels get the same value...
else
        
      if strcmp(sat,'noaa19')
          %ch3_dT_c=0;
      elseif strcmp(sat,'metopa')
          ch3_dT_c=0.71+13.30;%13.9+0.71;%-1.0;%-0.9;
          
      elseif strcmp(sat,'metopb')
          %ch3_dT_c=0;
      end
      dT_c(3)=ch3_dT_c;
      
      % UNCERTAINTY
      if strcmp(sat,'noaa19')
          %ch3_dT_c=0;
      elseif strcmp(sat,'metopa')
          u_ch3_dT_c=6.4;
          %u_dT_c_vec(3)=u_ch3_dT_c;
      elseif strcmp(sat,'metopb')
          %ch3_dT_c=0;
      end
      
    %replace the value for channel 3 in the u_dT_c array (covering all
    %scanlines)
    u_dT_c(3,:)=u_ch3_dT_c;
    
    disp(['Harmonised: cold target ',num2str(ch3_dT_c)]) 
      
end

end

%-------------------------------------------------------------------------%
% polarisation correction alpha

if polarisation ==1
% HARMONISED PARAMETER
if strcmp(sat,'noaa18')
      %do nothing. N18 is reference % we estimate 100% uncertainty since we do not know why all channels get the same value...
else
        % Watch out! You have to use precise values! 
      if strcmp(sat,'noaa19')
          %ch3_alpha=0;
      elseif strcmp(sat,'metopa')
          ch3_alpha=0.0774;%0.1;
      elseif strcmp(sat,'metopb')
          %ch3_alpha=0;
      end
      alpha(3)=ch3_alpha;
      
      % UNCERTAINTY
      if strcmp(sat,'noaa19')
          %u_ch3_alpha=0;
      elseif strcmp(sat,'metopa')
          u_ch3_alpha=0.02;
      elseif strcmp(sat,'metopb')
          %u_ch3_alpha=0;
      end
      
    %replace the value for channel 3 in the u_dT_c array (covering all
    %scanlines)
    u_alpha(3)=u_ch3_alpha;
    
    disp(['Harmonised: polarisation ',num2str(ch3_alpha)]) 
      
end

end


