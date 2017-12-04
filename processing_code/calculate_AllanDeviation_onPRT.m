
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

% This script calculates the Allan Deviation for PRT temperatures


 %% settings for considered lines 
                    %  Define the start/end of averaging window on
                    % basis of quality flags: define each window as
                    % consisting of 300 good scanlines.
                    % The averaged values for each of these windows are
                    % then filled into the corresponding scanlines. Bad
                    % scanlines get NAN as AllanDev.
                  
                    % collect only good scanlines for PRT (all PRT good):
                    %onlygoodPRTscnlin
                    
                    
if onlygoodPRTscnlin(end)==scanlinenumbers(end)
        onlygoodPRTscnlin(end)=[];
    end


% initializing the PRT temperatures per sensor already in setup-script


%initializing final allan-dev variables with NAN (all bad scanlines keep
%NAN). The "5" is already for the 5 channels. We need artificial extension
%to 5 channels for the processing (for now). All columns will have same values.

PRTallandev_scnlin=nan*(ones(length(scanlinenumbers),5));                
                    
%too force the output of the true fillvalues in NetCDF use:
% PRTallandev_scnlin=-32768*invscfac_u_T_IWCT_noise*(ones(length(scanlinenumbers),5)); %with invscfac_u_T_IWCT_noise=1000;                    
% BUT: this does not work for the Tb then! since the fillvalue will enter the processing chain and will be modified. What I really need is 
% to generate persitent data gaps....but a(12)=[]; deletes the 12th element
% and leaves a with one less...Therefore I initialize the
% PRTallandev_scnlin with ZERO, so that the uncertainty is missing in the
% total budget.
                    
    %%%%%             
   
           % for PRT      
          counterskiporbit=0;
                %(needed for noise characterization: window definition etc)
                %allows for preallocating space
                Nviews=4;
                startsellines=1;
                sellinesspacing=300;
                if floor(length(onlygoodPRTscnlin)   < sellinesspacing)
                    counterskiporbit=counterskiporbit+1;
                    skippedorbits(counterskiporbit)=orbit;
                    disp('This orbit is skipped: too few scanlines! FIXME: WHAT SHALL WE DO? errorcode 2')                    
                    % will set all fields to NAN                   
                    errorbit=1;
                    
                    NumberMultiplesPRT=1;
                else
                    NumberMultiplesPRT=floor(length(onlygoodPRTscnlin)/sellinesspacing);                % compute largest multiple sellinesspacing that fits into length(scanlinenumberss)
                    errorbit=0;
                end
                endsellinesPRT=onlygoodPRTscnlin(end);%sellinesspacing*floor(length(scanlinenumbers)/sellinesspacing);    % the total number of lines in that orbit
                
      


                    
                    for line= startsellines:1:length(scanlinenumbers)%(endsellines-1) % this loop is needed to create matrix datasamplechannel
                                                                                      % for each line (for current channel), in order to be able 
                                                                                      % to apply sum and mean functions afterwards. There might be
                                                                                      % a more elegant way though....
           
                    dataPRTsample(:,line)=double(PRTtemps(:,line));
                    
                    
                    end
                    
                    % use Msamplevariance with M=2 to calculate the allan
                    % variance
                    for line= startsellines:1:length(scanlinenumbers)-1%(endsellines-1)
                       
                        % PRT noise using Msamplevariance
                        
                        % 
                        PRTTwosamplevar(:,line)=Msamplevariance_goodlines(dataPRTsample,line,2,onlygoodPRTscnlin);
                        PRTTwosamplevareMeanSensor(line)=mean(PRTTwosamplevar(:,line));
                    
                        
                    end
                    
                    %averaging over each window 
                    
                      % for PRT 
                    for window =1:NumberMultiplesPRT
                        startline=1+(window-1)*sellinesspacing;
                        endline=startline+sellinesspacing-1;
                        
                        totalPRTTwosamplevar(onlygoodPRTscnlin(startline:endline))=mean(PRTTwosamplevareMeanSensor([onlygoodPRTscnlin(startline:endline)]));
                        PRTallandev(onlygoodPRTscnlin(startline:endline))=sqrt(totalPRTTwosamplevar(onlygoodPRTscnlin(startline:endline)));
                    
                        
                       PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),1)=PRTallandev(onlygoodPRTscnlin(startline:endline));
                       PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),2)=PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),1);
                       PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),3)=PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),1);
                       PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),4)=PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),1);
                       PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),5)=PRTallandev_scnlin(onlygoodPRTscnlin(startline:endline),1);
                    end
                    
                    % fill the remaining scan lines until end of orbit with
                    % last AllanDev value
                    PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),1)=PRTallandev(onlygoodPRTscnlin(endline)); 
                    PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),2)=PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),1);
                    PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),3)=PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),1);
                    PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),4)=PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),1);
                    PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),5)=PRTallandev_scnlin(onlygoodPRTscnlin(endline:end),1);
                    
                    
                    


