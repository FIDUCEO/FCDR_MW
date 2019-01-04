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


%% build vector for correlation coefficients (structured effects)
% The correlation should decrease over 7 scan lines to zero because of the
% 7-scan line average. In D2.2.a, Emma Woolliams describes how the
% correlation drops off for this case of a weighted rolling average. The
% resulting shape is "Gaussian-like". So, it is suggested to approximate
% this shape with a Gaussian of width sigma=m/sqrt(3), with m=3 (from +-3 scan
% lines around specific scan line), truncated for a separation of scan
% lines of delta l>6.


sigma=3/sqrt(3);

x = [-6:1:6];
gaussian= normpdf(x,0,sigma)/max(normpdf(x,0,sigma));

corr_vector=gaussian(7:end);
