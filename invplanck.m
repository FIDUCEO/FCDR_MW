
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




function M = invplanck(f, B)
%PLANCK Calculates the derivative of plack's law wrt. Temperature T.
%     
%     spectral radiant exitance
%     based on Max Planck's law based on a given radiance (B, W/(m^2cm^-1 K)) 
%     and frequency (f in Hz) THE FREQUENCY IS CONVERTED TO WAVENUMBER!
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
% c1 = 2*h*c0^2 
c1 =1.191042e-8 ; %W/(m^2 cm^-4)
%
% c2 = h*c/k 
c2 = 1.4387752; %K cm
%
%   
%
%-------------------------------------------------------------------------%

% frequency to wavernumber conversion in 1/m
nu=(f/c0);
nu=nu/100; %conversion to 1/cm

% Calculate the brightness temperature

M = c2*nu ./ (log((c1*nu.^3 ./B)+1));


