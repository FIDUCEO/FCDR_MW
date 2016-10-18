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


% function for partial derivatives

%% info
% function of following structure: out = func(in,..,effectID)
% if effectID==X
%    out= do derivative of f with respect to effect-X-relevant-quantities
% else if effectID==Y
%    out= derivative of f with respect to effect-Y-relevant-quantities   
% end

% out= PartialDerivativeOfEffect[effectID,scanline,scanposview,inputforcal]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% effectID.......... identity number of effect you want to consider
% scanline.......... current scanline 
% scanposview....... current view (1-4 for ICT and DSV, 1-90 for earth view)
% inpuforcal.........ALL other quantities that need to be fed into formula
% of derivative, i.e. radiances counts and conversion coefficients




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% derivative.......vector containing the values of the derivative of
% measurement equation f with respect to each variable in f that is
% influenced by the chosen effect (effectID) evaluated at scanline and
% scanposview: derivative(i)=df/dxi |scanline , scanposview that have been
% set in calling script uncertainty.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% function

function [derivative]=PartialDerivativesOfEffect(effectID,inputforcal)

Cict=inputforcal.countsict;
Cs=inputforcal.countsdsv;
Ce=inputforcal.countsearth;


Rsh=inputforcal.SHrad;
Rcmbpl1=inputforcal.CMBPL1rad;
Repl2=inputforcal.EarthPL2rad;


Rcmb=inputforcal.CMBrad;
Rict=inputforcal.ICTrad;

anl=inputforcal.anl;
invG=inputforcal.invgain;

sumRad=Rict+Rsh-Rcmb-Repl2;
Cictdiffs=Cict-Cs;
Csdiffe=Cs-Ce;
Cictdiffe=Cict-Ce;

if effectID==1
    
    % deriv(1)= dRE/dCe
    % deriv(2)= dRE/dCict
    % deriv(3)= dRE/dCs
    
        derivative(1)=sumRad/Cictdiffs+ anl*(2*Ce-Cict-Cs)*(invG^2);
        derivative(2)=Csdiffe*sumRad/Cictdiffs^2 + sumRad^2 *anl*Csdiffe*Cictdiffs^2/Cictdiffs^4 - 2*Cictdiffs*sumRad^2 *anl*(Ce-Cict)*(Ce-Cs)/Cictdiffs^4;
        derivative(3)=Cictdiffe*sumRad/Cictdiffs^2 + sumRad^2 *anl*Cictdiffe*Cictdiffs^2/Cictdiffs^4 +  2*Cictdiffs*sumRad^2 *anl*(Ce-Cict)*(Ce-Cs)/Cictdiffs^4;
   
    
 elseif effectID==2
     
         derivative(1)=-1;
         derivative(2)=-1;
         
         
 elseif effectID==3
%     
         derivative(1)=-Csdiffe/Cictdiffs + 1 + 2*anl*sumRad/Cictdiffs^2 *(-Cictdiffe)*(-Csdiffe); %IS THIS CORRECT?? Do i understand this correct in martins doc?
         
%         derivative(1)=
%         derivative(2)=
%         derivative(3)=
%         derivative(4)=
%         derivative(5)=
%         derivative(6)=
%         derivative(7)=
%         derivative(8)=
%         derivative(9)=
%         derivative(10)=
%         derivative(11)=
%         derivative(12)=
%         derivative(13)=
%         derivative(14)=
%         derivative(15)=
%         derivative(16)=
%         derivative(17)=
%         derivative(18)=
%         derivative(19)=
%         derivative(20)=
%         derivative(21)=
%         derivative(22)=
%         derivative(23)=
%         derivative(24)=
%         derivative(25)=
%         derivative(26)=
%         derivative(27)=
%         derivative(28)=
        
        
    
end