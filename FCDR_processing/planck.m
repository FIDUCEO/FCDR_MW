


 %
 % %%% based on MATLAB function specexitance.m 
 %    Created by Jaap de Vries, 8/20/2012
 %     jpdvrs@yahoo.com 
% adapted to FIDUCEO needs by Imke Hans


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
% c1 = 2*h*c0^2 =1.191 *10^-16 W*m^2
c1 =1.191042e-8 ; % in W/(m^2 cm^-4)= 10^-8 W *m^2
%
% c2 = h*c/k = 1.438 *10^-2 m * K
c2 = 1.4387752; % K* cm
%
%   
%
%-------------------------------------------------------------------------%

% frequency to wavenumber conversion in 1/m
nu=(f/c0);
nu=nu/100; %conversion to 1/cm

% Calculate the spectral radiant exitance in(W/(m^2cm^-1))
M = (c1*nu.^3) ./ (exp(c2*nu./T)-1);
