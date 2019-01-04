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

% RFI_correction_LUT

% applies RFI correction to Earth counts. Called in setup_XXX_2l1c.m script

function earthcounts_new=RFI_correction_LUT(selectyear, chosen_month, earthcounts, sat,sen)

if strcmp(sat,'noaa15') || strcmp(sat,'noaa16') || strcmp(sat,'noaa17') || strcmp(sat,'noaa19') 
    
  try   
  filenamestring=['RFI_corr_FromTb_',sat,sen,'.mat'];
  load(filenamestring)
  catch
      disp('No RFI correction LUT file found. Carry on without RFI correction.')
  return;
  end
    % search for index for current month
    ind_LUT=find(LUT.monthinfo==selectyear*100+chosen_month);

    if isempty(ind_LUT)
        earthcounts_new=earthcounts;
        disp('No RFI correction for this period.')
    else
        % set corrections for ch1 and ch2 to zero.
        LUT.corr(:,1,:)=0;
        LUT.corr(:,2,:)=0;
        if strcmp(sat,'noaa19')
            LUT.corr(:,5,:)=0; %do not correct chn5 for N19 
        end
        % check out LUT at the found index, expand it to match the current scan
        % line number and add it to the old earthcounts. This gives the RFI
        % corrected earthcounts.
        earthcounts=permute(earthcounts,[3 1 2]); %permute to get order of LUT
        earthcounts_new=earthcounts+double(repmat(int32(LUT.corr(ind_LUT,:,:)),[size(earthcounts,1) 1 1]));
        earthcounts_new=permute(earthcounts_new,[2 3 1]); % permute to get original order back
    end
else
    earthcounts_new=earthcounts;
    disp('No RFI correction applicable.')
    
end