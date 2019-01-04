
 %
 % %%% based on MATLAB function specexitance.m 
 %    Created by Jaap de Vries, 8/20/2012
 %     jpdvrs@yahoo.com 
% adapted to FIDUCEO needs by Imke Hans



function M = invplanck(f, B)
%PLANCK Calculates the brightness temperature M from a radiance B.
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


