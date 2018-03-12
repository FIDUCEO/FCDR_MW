
%
 % Copyright (C) 2016-10-17 Imke Hans
 % This code was developed for the EC project �Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)�. 
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




function M = DplanckDf(f, T)
%PLANCK Calculates the derivative of plack's law wrt. frequency f.
%     
%     spectral radiant exitance
%     based on Max Planck's law based on a given temperature (T, in Kelvin) 
%     and frequency (f in Hz) 
%  
%     
%  
%     
%  
% %-----------------------------------------------------------------------%

% Speed of light in a vacuum
c0 = 2.99792458*10.^8; 
%
% Planck's constant
h = 6.626176*10.^-34; 
%
% Boltzman constant
k = 1.380662*10.^-23; 
%
% Refravtive index of the medium.
n = 1;
%
% Defining two new constants
%
% c3 = 2*h/c0^2; 
  c3=1.4745e-50; %in J*s^3/m^2
%
% c4 = h/k 
  c4 = 4.7993e-11; % in s*K
%
%   
%
%-------------------------------------------------------------------------%
term1=-c3.*f.^2;
term2=c4.*f./T;
term3=exp(term2);

% Calculate the deviation of spectral radiant exitance 
M = term1.*(term3.*(term2-3)+3)./(term3).^2;
%in full terms M = term1.*(exp(c4.*f./T).*(c4.*f./T-3)+3)./(exp(c4.*f./T)).^2;