% calculate_Allan_Deviation_onCounts
%
 % Copyright (C) 2017-04-12 Imke Hans
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
 
%% info
%
% ONLY USE this script via calling function generate_FCDR.m
% DO NOT use this script alone. It needs the output from preceeding
% functions generate_FCDR.

% This script calculates the Allan Deviation for IWCT and DSV counts


 %% settings for considered lines 
 counterskiporbit=0;
                %(needed for noise characterization: window definition etc)
                %allows for preallocating space
                Nviews=4;
                startsellines=1;
                sellinesspacing=300;
                if floor(length(scanlinenumbers) < sellinesspacing)
                    counterskiporbit=counterskiporbit+1;
                    skippedorbits(counterskiporbit)=orbit;
                    disp('This orbit is skipped: too few scanlines! FIXME: WHAT SHALL WE DO? errorcode 2')                    
                    % will set all fields to NAN                   
                    errorbit=1;
                    
                    NumberMultiples=1;
                else
                    NumberMultiples=floor(length(scanlinenumbers_original)/sellinesspacing);                % compute largest multiple sellinesspacing that fits into length(scanlinenumberss)
                    errorbit=0;
                end
                endsellines=sellinesspacing*floor(length(scanlinenumbers_original)/sellinesspacing);    % the total number of lines in that orbit
                Msellines=endsellines-startsellines+1;



if strcmp(selectinstrument,'mhs')
countsobct=[data.OBCT_view_data_counts_OBCT_view1_Ch_H1; data.OBCT_view_data_counts_OBCT_view2_Ch_H1; data.OBCT_view_data_counts_OBCT_view3_Ch_H1; data.OBCT_view_data_counts_OBCT_view4_Ch_H1;];
countsobct(:,:,2)=[data.OBCT_view_data_counts_OBCT_view1_Ch_H2; data.OBCT_view_data_counts_OBCT_view2_Ch_H2; data.OBCT_view_data_counts_OBCT_view3_Ch_H2; data.OBCT_view_data_counts_OBCT_view4_Ch_H2;];               
countsobct(:,:,3)=[data.OBCT_view_data_counts_OBCT_view1_Ch_H3; data.OBCT_view_data_counts_OBCT_view2_Ch_H3; data.OBCT_view_data_counts_OBCT_view3_Ch_H3; data.OBCT_view_data_counts_OBCT_view4_Ch_H3;];        
countsobct(:,:,4)=[data.OBCT_view_data_counts_OBCT_view1_Ch_H4; data.OBCT_view_data_counts_OBCT_view2_Ch_H4; data.OBCT_view_data_counts_OBCT_view3_Ch_H4; data.OBCT_view_data_counts_OBCT_view4_Ch_H4;];                  
countsobct(:,:,5)=[data.OBCT_view_data_counts_OBCT_view1_Ch_H5; data.OBCT_view_data_counts_OBCT_view2_Ch_H5; data.OBCT_view_data_counts_OBCT_view3_Ch_H5; data.OBCT_view_data_counts_OBCT_view4_Ch_H5;];

countsdsv=[data.space_view_data_counts_space_view1_Ch_H1; data.space_view_data_counts_space_view2_Ch_H1; data.space_view_data_counts_space_view3_Ch_H1; data.space_view_data_counts_space_view4_Ch_H1;];
countsdsv(:,:,2)=[data.space_view_data_counts_space_view1_Ch_H2; data.space_view_data_counts_space_view2_Ch_H2; data.space_view_data_counts_space_view3_Ch_H2; data.space_view_data_counts_space_view4_Ch_H2;];               
countsdsv(:,:,3)=[data.space_view_data_counts_space_view1_Ch_H3; data.space_view_data_counts_space_view2_Ch_H3; data.space_view_data_counts_space_view3_Ch_H3; data.space_view_data_counts_space_view4_Ch_H3;];        
countsdsv(:,:,4)=[data.space_view_data_counts_space_view1_Ch_H4; data.space_view_data_counts_space_view2_Ch_H4; data.space_view_data_counts_space_view3_Ch_H4; data.space_view_data_counts_space_view4_Ch_H4;];                  
countsdsv(:,:,5)=[data.space_view_data_counts_space_view1_Ch_H5; data.space_view_data_counts_space_view2_Ch_H5; data.space_view_data_counts_space_view3_Ch_H5; data.space_view_data_counts_space_view4_Ch_H5;];



elseif strcmp(selectinstrument,'amsub')
countsobct=[data.OBCT_view_data_counts_OBCT_view1_Ch_16; data.OBCT_view_data_counts_OBCT_view2_Ch_16; data.OBCT_view_data_counts_OBCT_view3_Ch_16; data.OBCT_view_data_counts_OBCT_view4_Ch_16;];
countsobct(:,:,2)=[data.OBCT_view_data_counts_OBCT_view1_Ch_17; data.OBCT_view_data_counts_OBCT_view2_Ch_17; data.OBCT_view_data_counts_OBCT_view3_Ch_17; data.OBCT_view_data_counts_OBCT_view4_Ch_17;];               
countsobct(:,:,3)=[data.OBCT_view_data_counts_OBCT_view1_Ch_18; data.OBCT_view_data_counts_OBCT_view2_Ch_18; data.OBCT_view_data_counts_OBCT_view3_Ch_18; data.OBCT_view_data_counts_OBCT_view4_Ch_18;];        
countsobct(:,:,4)=[data.OBCT_view_data_counts_OBCT_view1_Ch_19; data.OBCT_view_data_counts_OBCT_view2_Ch_19; data.OBCT_view_data_counts_OBCT_view3_Ch_19; data.OBCT_view_data_counts_OBCT_view4_Ch_19;];                  
countsobct(:,:,5)=[data.OBCT_view_data_counts_OBCT_view1_Ch_20; data.OBCT_view_data_counts_OBCT_view2_Ch_20; data.OBCT_view_data_counts_OBCT_view3_Ch_20; data.OBCT_view_data_counts_OBCT_view4_Ch_20;];

countsdsv=[data.space_view_data_counts_space_view1_Ch_16; data.space_view_data_counts_space_view2_Ch_16; data.space_view_data_counts_space_view3_Ch_16; data.space_view_data_counts_space_view4_Ch_16;];
countsdsv(:,:,2)=[data.space_view_data_counts_space_view1_Ch_17; data.space_view_data_counts_space_view2_Ch_17; data.space_view_data_counts_space_view3_Ch_17; data.space_view_data_counts_space_view4_Ch_17;];               
countsdsv(:,:,3)=[data.space_view_data_counts_space_view1_Ch_18; data.space_view_data_counts_space_view2_Ch_18; data.space_view_data_counts_space_view3_Ch_18; data.space_view_data_counts_space_view4_Ch_18;];        
countsdsv(:,:,4)=[data.space_view_data_counts_space_view1_Ch_19; data.space_view_data_counts_space_view2_Ch_19; data.space_view_data_counts_space_view3_Ch_19; data.space_view_data_counts_space_view4_Ch_19;];                  
countsdsv(:,:,5)=[data.space_view_data_counts_space_view1_Ch_20; data.space_view_data_counts_space_view2_Ch_20; data.space_view_data_counts_space_view3_Ch_20; data.space_view_data_counts_space_view4_Ch_20;];

end
countsobct=double(permute(countsobct,[1 3 2]));


countsdsv=double(permute(countsdsv,[1 3 2]));


for channel =1:5
                    
                    for line= startsellines:1:endsellines%  (endsellines-1) % this loop is needed to create matrix datasamplechannel
                                                                                      % for each line (for current channel), in order to be able 
                                                                                      % to apply sum and mean functions afterwards. There might be
                                                                                      % a more elegant way though....
                    
                    dataobctsamplechannel(:,line)=double(countsobct(:,channel,line));
                    datadsvsamplechannel(:,line)=double(countsdsv(:,channel,line));
                    
                    
                    end
                    
                    % use Msamplevariance with M=2 to calculate the allan
                    % variance
                    for line= startsellines:1:(endsellines-1)
                        
                        
                        % on count level using Msamplevariance
                         %using OBCT
                        CountobctTwosamplevar(:,channel,line)=Msamplevariance(dataobctsamplechannel,line,2);
                        CountobctTwosamplevareMeanView(channel,line)=mean(CountobctTwosamplevar(:,channel,line));
                        % using DSV
                        CountdsvTwosamplevar(:,channel,line)=Msamplevariance(datadsvsamplechannel,line,2);
                        CountdsvTwosamplevareMeanView(channel,line)=mean(CountdsvTwosamplevar(:,channel,line));
                    
                        
                    end
                    
                    
                    
                    %averaging over each window
                    
                
                    
                    for window =1:NumberMultiples
                         startline=1+(window-1)*sellinesspacing;
                         endline=startline+sellinesspacing-1;
                
                            % on count level using Msamplevariance
                            totalCountobctTwosamplevar(window,channel)=mean(CountobctTwosamplevareMeanView(channel,startline:(endline-2)));
                            obctcountallandev(window,channel)=sqrt(totalCountobctTwosamplevar(window,channel));
                            
                            totalCountdsvTwosamplevar(window,channel)=mean(CountdsvTwosamplevareMeanView(channel,startline:(endline-2)));
                            dsvcountallandev(window,channel)=sqrt(totalCountdsvTwosamplevar(window,channel));
                     
                  
                            dsvcountallandev_scnlin(startline:endline,channel)=dsvcountallandev(window,channel)*ones(length(startline:endline),1);
                            iwctcountallandev_scnlin(startline:endline,channel)=obctcountallandev(window,channel)*ones(length(startline:endline),1);
                    
                    end
                    % fill the last scanlines (from end of last window to end of orbit) with the last window's values
                         dsvcountallandev_scnlin(endline:length(scanlinenumbers),channel)=dsvcountallandev_scnlin(endline,channel); 
                         iwctcountallandev_scnlin(endline:length(scanlinenumbers),channel)=iwctcountallandev_scnlin(endline,channel);
                    
                end

% median for the orbit (of windows)
iwctcountallandev_med=median(obctcountallandev,1);
dsvcountallandev_med=median(dsvcountallandev,1);