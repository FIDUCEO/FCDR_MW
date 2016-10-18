
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



% function to calculate uncertainty associated with one effect


%% info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% effectID.......... identity number of effect you want to consider
% scanline.......... current scanline
% scanposview....... current view (1-4 for ICT and DSV, 1-90 for earth
% view)
% inpuforcal.........ALL other quantities that need to be fed into formula
% of derivative, i.e. radiances counts and conversion coefficients, and 
% uncertainty matrix u containing value of uncertainty for
% each variable of the chosen effect u(variable), and correlation matirx r
%
% all variables in inputforcal are values for the chosen scanline,
% scanviewpos and channel!!!!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% uncertainty...... value of uncertainty for the earth radiance at chosen scanline
% and scanviewpos at chosen channel for a chosen effect.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% called functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% measurement equation f, to be evaluated at each pixel (scanline, scanangl.view-number)
% partial derivative of measurement equation for chosen effect







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function


function [uncertainty]=uncertainty_singleeffect(effectID,numterms,scanline,scanposview,inputforcal)


derivative=PartialDerivativesOfEffect(effectID,inputforcal);
u=inputforcal.uncertainty;
r=inputforcal.correlation;

for ii=1:numterms
    
    for jj=1:numterms
        
        product(ii,jj)=derivative(ii)*derivative(jj)*u(ii)*u(jj)*r(ii,jj);

    end
end


uncertainty=sqrt(sum(sum(product,1)));



