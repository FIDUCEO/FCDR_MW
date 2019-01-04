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



% qualitychecks on Earthcounts
%threshold_earth is set in the set_coeff.m script, i.e. it is read in from
%the .mat file. Like antenna pattern corr. coeffs. etc.
qualflag_badscanlinesEarth_pix=zeros(size(earthcounts));

if strcmp(sen,'ssmt2')
    pixnum=28;
else
    pixnum=90;
end

for channel=1:5


for pixel=1:pixnum
    earthcount_pixel=squeeze(earthcounts(channel,pixel,:));
    
    [goodline_before_jump_pix,badscanlines_pix]=filter_plateausANDpeaks_earth(earthcount_pixel,threshold_earth(channel));
    qualflag_badscanlinesEarth_pix(channel,pixel,badscanlines_pix)=1;
    
end



end

earthcounts_filtered=earthcounts;
% set earthcounts to NAN wherever the counts are zero
earthcounts_filtered(earthcounts==0)=nan;
% set earthcounts to NAN wherever the counts are negative
earthcounts_filtered(earthcounts<0)=nan;
% set earthcounts to NAN wherever there is a badline/pixel due to some
% jump/lpeak/plateau
earthcounts_filtered(qualflag_badscanlinesEarth_pix==1)=nan;

earthcounts_unfiltered=earthcounts; %store the unfilteres earthcounts
earthcounts=earthcounts_filtered; %replace the old earthcounts with the filtered ones
