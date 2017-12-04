
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
                    %  Define the start/end of averaging window on
                    % basis of quality flags: define each window as
                    % consisting of 300 good scanlines.
                    % The averaged values for each of these windows are
                    % then filled into the corresponding scanlines. Bad
                    % scanlines get NAN as AllanDev.
                  
                    % collect good scanlines for DSV and IWCT
                    onlygoodDSVscnlin{1}=onlygoodDSVscnlin_ch1;
                    onlygoodDSVscnlin{2}=onlygoodDSVscnlin_ch2;
                    onlygoodDSVscnlin{3}=onlygoodDSVscnlin_ch3;
                    onlygoodDSVscnlin{4}=onlygoodDSVscnlin_ch4;
                    onlygoodDSVscnlin{5}=onlygoodDSVscnlin_ch5;
                    
                    onlygoodIWCTscnlin{1}=onlygoodIWCTscnlin_ch1;
                    onlygoodIWCTscnlin{2}=onlygoodIWCTscnlin_ch2;
                    onlygoodIWCTscnlin{3}=onlygoodIWCTscnlin_ch3;
                    onlygoodIWCTscnlin{4}=onlygoodIWCTscnlin_ch4;
                    onlygoodIWCTscnlin{5}=onlygoodIWCTscnlin_ch5;

% initialize the counts from the 4 views for IWCT
countsobct=[iwct1ch1; iwct2ch1; iwct3ch1; iwct4ch1;];
countsobct(:,:,2)=[iwct1ch2; iwct2ch2; iwct3ch2; iwct4ch2;];               
countsobct(:,:,3)=[iwct1ch3; iwct2ch3; iwct3ch3; iwct4ch3;];         
countsobct(:,:,4)=[iwct1ch4; iwct2ch4; iwct3ch4; iwct4ch4;];                  
countsobct(:,:,5)=[iwct1ch5; iwct2ch5; iwct3ch5; iwct4ch5;];

countsobct=double(permute(countsobct,[1 3 2]));

% initialize the counts from the 4 views for DSV
countsdsv=[dsv1ch1; dsv2ch1; dsv3ch1; dsv4ch1;];
countsdsv(:,:,2)=[dsv1ch2; dsv2ch2; dsv3ch2; dsv4ch2;];               
countsdsv(:,:,3)=[dsv1ch3; dsv2ch3; dsv3ch3; dsv4ch3;];         
countsdsv(:,:,4)=[dsv1ch4; dsv2ch4; dsv3ch4; dsv4ch4;];                  
countsdsv(:,:,5)=[dsv1ch5; dsv2ch5; dsv3ch5; dsv4ch5;];

countsdsv=double(permute(countsdsv,[1 3 2]));

%initializing final allan-dev variables with NAN (all bad scanlines keep
%NAN)
iwctcountallandev_scnlin=nan*(ones(length(scanlinenumbers),5));
dsvcountallandev_scnlin=nan*(ones(length(scanlinenumbers),5));                
                    
                   
                    
                    
    %%%%%                
for    index=1:length(channelset)
    channel = channelset(index);
    
    if onlygoodDSVscnlin{channel}(end)==scanlinenumbers(end)
        onlygoodDSVscnlin{channel}(end)=[];
    end
    
    if onlygoodIWCTscnlin{channel}(end)==scanlinenumbers(end)
        onlygoodIWCTscnlin{channel}(end)=[];
    end
           % for DSV counts      
          counterskiporbit=0;
                %(needed for noise characterization: window definition etc)
                %allows for preallocating space
                Nviews=4;
                startsellines=1;
                sellinesspacing=300;
                if floor(length(onlygoodDSVscnlin{channel})   < sellinesspacing)
                    counterskiporbit=counterskiporbit+1;
                    skippedorbits(counterskiporbit)=orbit;
                    disp('This orbit is skipped: too few scanlines! FIXME: WHAT SHALL WE DO? errorcode 2')                    
                    % will set all fields to NAN                   
                    errorbit=1;
                    
                    NumberMultiplesDSV=1;
                else
                    NumberMultiplesDSV=floor(length(onlygoodDSVscnlin{channel})/sellinesspacing);                % compute largest multiple sellinesspacing that fits into length(scanlinenumberss)
                    errorbit=0;
                end
                endsellinesDSV=onlygoodDSVscnlin{channel}(end);%sellinesspacing*floor(length(scanlinenumbers)/sellinesspacing);    % the total number of lines in that orbit
                
      

             % for IWCT counts   
                counterskiporbit=0;
                %(needed for noise characterization: window definition etc)
                %allows for preallocating space
                Nviews=4;
                startsellines=1;
                sellinesspacing=300;
                if floor(length(onlygoodIWCTscnlin{channel})   < sellinesspacing)
                    counterskiporbit=counterskiporbit+1;
                    skippedorbits(counterskiporbit)=orbit;
                    disp('This orbit is skipped: too few scanlines! FIXME: WHAT SHALL WE DO? errorcode 2')                    
                    % will set all fields to NAN                   
                    errorbit=1;
                    
                    NumberMultiplesIWCT=1;
                else
                    NumberMultiplesIWCT=floor(length(onlygoodIWCTscnlin{channel})/sellinesspacing);                % compute largest multiple sellinesspacing that fits into length(scanlinenumberss)
                    errorbit=0;
                end
                endsellinesIWCT=onlygoodIWCTscnlin{channel}(end);%sellinesspacing*floor(length(scanlinenumbers)/sellinesspacing);    % the total number of lines in that orbit
                
                
                
                

%for channel =1:5
                    
                    for line= startsellines:1:length(scanlinenumbers)%(endsellines-1) % this loop is needed to create matrix datasamplechannel
                                                                                      % for each line (for current channel), in order to be able 
                                                                                      % to apply sum and mean functions afterwards. There might be
                                                                                      % a more elegant way though....
                    
                    dataobctsamplechannel(:,line)=double(countsobct(:,channel,line));
                    datadsvsamplechannel(:,line)=double(countsdsv(:,channel,line));
                    
                    
                    end
                    
                    % use Msamplevariance with M=2 to calculate the allan
                    % variance
                    for line= startsellines:1:length(scanlinenumbers)-1%(endsellines-1)
                        
                        
                        % on count level using Msamplevariance
                         %using OBCT
                        CountobctTwosamplevar(:,channel,line)=Msamplevariance_goodlines(dataobctsamplechannel,line,2,onlygoodIWCTscnlin{channel});
                        CountobctTwosamplevareMeanView(channel,line)=mean(CountobctTwosamplevar(:,channel,line));
                        % using DSV
                        CountdsvTwosamplevar(:,channel,line)=Msamplevariance_goodlines(datadsvsamplechannel,line,2,onlygoodDSVscnlin{channel});
                        CountdsvTwosamplevareMeanView(channel,line)=mean(CountdsvTwosamplevar(:,channel,line));
                    
                        
                    end
                    
                    
                    
                    %averaging over each window 
                    %(DSV and IWCT may have
                    %different good/bad scanlines and therefore different
                    %windows to average over)
                   
                    
                    
                      % for DSV counts 
                    for window =1:NumberMultiplesDSV
                        startline=1+(window-1)*sellinesspacing;
                        endline=startline+sellinesspacing-1;
                        
                        totalCountdsvTwosamplevar(onlygoodDSVscnlin{channel}(startline:endline),channel)=mean(CountdsvTwosamplevareMeanView(channel,[onlygoodDSVscnlin{channel}(startline:endline)]));
                        dsvcountallandev(onlygoodDSVscnlin{channel}(startline:endline),channel)=sqrt(totalCountdsvTwosamplevar(onlygoodDSVscnlin{channel}(startline:endline),channel));
                    
                        
                       dsvcountallandev_scnlin(onlygoodDSVscnlin{channel}(startline:endline),channel)=dsvcountallandev(onlygoodDSVscnlin{channel}(startline:endline),channel);
                    
                    end
                    
                    % fill the remaining scan lines until end of orbit with
                    % last AllanDev value
                    dsvcountallandev_scnlin(onlygoodDSVscnlin{channel}(endline:end),channel)=dsvcountallandev(onlygoodDSVscnlin{channel}(endline),channel); 
                    
                    
                     % for IWCT counts 
                    for window =1:NumberMultiplesIWCT
                        startline=1+(window-1)*sellinesspacing;
                        endline=startline+sellinesspacing-1;
                        totalCountobctTwosamplevar(onlygoodIWCTscnlin{channel}(startline:endline),channel)=mean(CountobctTwosamplevareMeanView(channel,[onlygoodIWCTscnlin{channel}(startline:endline)]));
                        obctcountallandev(onlygoodIWCTscnlin{channel}(startline:endline),channel)=sqrt(totalCountobctTwosamplevar(onlygoodIWCTscnlin{channel}(startline:endline),channel));
                    
                        
                        
                        iwctcountallandev_scnlin(onlygoodIWCTscnlin{channel}(startline:endline),channel)=obctcountallandev(onlygoodIWCTscnlin{channel}(startline:endline),channel);
                    end
                    
                    % fill the remaining scan lines until end of orbit with
                    % last AllanDev value  
                    iwctcountallandev_scnlin(onlygoodIWCTscnlin{channel}(endline:end),channel)=obctcountallandev(onlygoodIWCTscnlin{channel}(endline),channel);

                    
  end

