

%
 % Copyright (C) 2016-10-17 Imke Hans
 % This code was developed for the EC project �Fidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)�. 
 % Grant Agreement: 638822
 %  <Version> Reviewed and approved by <name, instituton>, <date>
 %
 %
 %  V 0.1   Reviewed and approved by Imke Hans, Univ. Hamburg, 2017-04-20
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
 % %%% based on MATLAB function specexitance.m 
 %    Created by Jaap de Vries, 8/20/2012
 %     jpdvrs@yahoo.com 



function M = planck(f, T)
%PLANCK Calculates the spectral radiant exitance for a black body
%based on Max Planck's law (W/(m^2cm^-1))
%     M = planck(f, T) computes the spectral radiant exitance
%     based on Max Planck's law based on a given temperature (T, in Kelvin) 
%     and frequency (f in Hz) THE FREQUENCY IS CONVERTED TO WAVENUMBER!
%  
%     
% %%% based on specexitance.m 
%    Created by Jaap de Vries, 8/20/2012
%     jpdvrs@yahoo.com 
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
% Refractive index of the medium.
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

% frequency to wavenumber conversion in 1/m
nu=(f/c0);
nu=nu/100; %conversion to 1/cm

% Calculate the spectral radiant exitance in(W/(m^2cm^-1))
M = (c1*nu.^3) ./ (exp(c2*nu./T)-1);
