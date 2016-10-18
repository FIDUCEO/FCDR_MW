
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

% script that reads in data from a certain orbit and puts it into the shape
% required by the uncertainty script


% output: variable structure for each orbit
% dataperorbit{orbit}.XXX..........with XXX being the different variables
% counts(PRT,DSV,EARTH), counts(7 PRTs), coefficients(7 PRTs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% read in

% use parts of amsub_multifiles.m script for reading in several orbits
% use read_amsub_for_uncert.m to read data record

%%%%%%%%%%%%% START:   READ IN VARIABLES FROM L1B-DATA FILE %%%%%%%%%%%%%%
%% initialising of atmlab
atmlab_init 

%% data path. 
% Here you need to specify the full path to the data and the filename of the file
% Main functions to read hdf5 files are hinfo and hdf5read.
mainpath='./';

filenames = importdata(['/scratch/uni/u237/data/mhs/',satsenyear,'.index']);

%satsenyear='noaa16_amsub_2000';


%% Orbits
% which orbits should be processed?

orbitstart=selectorbit;
orbitend=selectorbit;%length(filenames);%600;
orbitspacing=1;

numberoforbits=(orbitend-orbitstart+1)/orbitspacing;

counterskiporbit=0;


%% Reading  file structure
that_file = filenames;
ierr = zeros(1, numel(that_file));

% prellocating space for dataperorbit
dataperorbit=cell(1,numel(that_file));

skippedorbits=zeros(numel(that_file),1);
badorbit=zeros(numel(that_file),1);
errorcode=zeros(numel(that_file),1); % errorcode vector: 
                                     % 1= file could not be read or unzipped
                                     % 2= orbit is too short to be used for
                                     %    analysis

i=0;
for orbit = orbitstart:orbitspacing:orbitend%%numel(that_file)
    this_file = char(strcat('/scratch/uni/u237/data/mhs/', that_file(orbit)));
    i=i+1;
    disp(['...reading orbit ', num2str(i), ' /  ', num2str(numberoforbits)])
    
    [hdrinfo,data,err] = read_MHS_for_uncert(this_file);
            
            
            
            % checking successful reading an unzipping
            if (err == 0)
            %% settings for considered lines 
               
                Nviews=4;
                errorbit=0;
                
               
    
                
            % If the reading of a single orbit is successful the data will be
            % written on a new array
            
                
                bbto = zeros(numel(data.year),3);
                bbto(:,1) = data.year;
                bbto(:,2) = data.day;
                bbto(:,3) = data.time;
                
                %create time vector
                for line=1:length(data.time)-1
                if double(data.time(line+1))-double(data.time(line))<0
                    data.day(line+1:end)=data.day(line)+1;
                  
                end
                end
                timevector1=double(data.day)+double(data.time)/(1440*60);
                timevector=timevector1.';
                
                
         
         %% preallocating matrices       
               
                
                dsvcounts=zeros(length(data.time),Nviews,5);
                obctcounts=zeros(length(data.time),Nviews,5);
                earthcounts=zeros(length(data.time),90,5);
                
                udsvcounts=zeros(length(data.time),Nviews,5);
                uobctcounts=zeros(length(data.time),Nviews,5);
                uearthcounts=zeros(length(data.time),90,5);
                
               
          
                       if errorbit==0     
                       %% READ AND CALCULATE

                       % iterations over 5 channels
                            for channel=1:5

                                 % iterations over the 4 views of the dsv and obct
                                for view=1:4
                                dsvcounts(:,view,channel) = data.countsdsv(view,channel,:); %first dimension in bbtodsv is scanline
                                obctcounts(:,view,channel) = data.countsobct(view,channel,:);
                                
                                % uncertainties dummy-values
                                udsvcounts(:,view,channel)=0.00001*ones(length(data.time),1);
                                uobctcounts(:,view,channel)=0.00002*ones(length(data.time),1);
                                end
                                
                                for view=1:90
                                    earthcounts(:,view,channel)= data.countsEarth(view,channel,:);
                                    
                                    % uncertainties dummy-values
                                    uearthcounts(:,view,channel)=0.000005*ones(length(data.time),1);
                                end

                            end
                           
                           % FIX: PRT counts not yet read out of l1b file, since PRT-Temp provided directly for MHS. FIX 
                            PRT1counts=zeros(length(data.year));% data.caltargettempcounts(:,1);
                            PRT2counts=zeros(length(data.year));% data.caltargettempcounts(:,2);
                            PRT3counts=zeros(length(data.year));% data.caltargettempcounts(:,3);
                            PRT4counts=zeros(length(data.year));% data.caltargettempcounts(:,4);
                            PRT5counts=zeros(length(data.year));% data.caltargettempcounts(:,5);
                            PRT6counts=zeros(length(data.year));% %for MHS leave this zero! data.caltargettempcounts(:,6);
                            PRT7counts=zeros(length(data.year));% %for MHS leave this zero! data.caltargettempcounts(:,7);
                            
                            %for AMSU-B the coefficients for "count-to-temp conv." are valid for whole
                            %orbit; % structure (scanline,coeffnumber)
                           % PRT1coeff=[hdrinfo.caltargettempcoeff(1) hdrinfo.caltargettempcoeff(2) hdrinfo.caltargettempcoeff(3) hdrinfo.caltargettempcoeff(4)];
                           % PRT2coeff=[hdrinfo.caltargettempcoeff(5) hdrinfo.caltargettempcoeff(6) hdrinfo.caltargettempcoeff(7) hdrinfo.caltargettempcoeff(8)];
                           % PRT3coeff=[hdrinfo.caltargettempcoeff(9) hdrinfo.caltargettempcoeff(10) hdrinfo.caltargettempcoeff(11) hdrinfo.caltargettempcoeff(12)];
                           % PRT4coeff=[hdrinfo.caltargettempcoeff(13) hdrinfo.caltargettempcoeff(14) hdrinfo.caltargettempcoeff(15) hdrinfo.caltargettempcoeff(16)];
                           % PRT5coeff=[hdrinfo.caltargettempcoeff(17) hdrinfo.caltargettempcoeff(18) hdrinfo.caltargettempcoeff(19) hdrinfo.caltargettempcoeff(20)];
                           % PRT6coeff=[hdrinfo.caltargettempcoeff(21) hdrinfo.caltargettempcoeff(22) hdrinfo.caltargettempcoeff(23) hdrinfo.caltargettempcoeff(24)];
                           % PRT7coeff=[hdrinfo.caltargettempcoeff(25) hdrinfo.caltargettempcoeff(26) hdrinfo.caltargettempcoeff(27) hdrinfo.caltargettempcoeff(28)];
                           
                            % for MHS: coefficients for resistance to
                            % temperature conversion (i.e. second
                            % conversion step. Count to Resistance and 
                            % Resistance to Temp. Conv. NOT YET USED IN PROGRAM)
                            PRT1coeff=[hdrinfo.caltargettempcoeff(1) hdrinfo.caltargettempcoeff(2) hdrinfo.caltargettempcoeff(3) hdrinfo.caltargettempcoeff(4)];
                            PRT2coeff=[hdrinfo.caltargettempcoeff(5) hdrinfo.caltargettempcoeff(6) hdrinfo.caltargettempcoeff(7) hdrinfo.caltargettempcoeff(8)];
                            PRT3coeff=[hdrinfo.caltargettempcoeff(9) hdrinfo.caltargettempcoeff(10) hdrinfo.caltargettempcoeff(11) hdrinfo.caltargettempcoeff(12)];
                            PRT4coeff=[hdrinfo.caltargettempcoeff(13) hdrinfo.caltargettempcoeff(14) hdrinfo.caltargettempcoeff(15) hdrinfo.caltargettempcoeff(16)];
                            PRT5coeff=[hdrinfo.caltargettempcoeff(17) hdrinfo.caltargettempcoeff(18) hdrinfo.caltargettempcoeff(19) hdrinfo.caltargettempcoeff(20)];
                            PRT6coeff=0*PRT5coeff;%[hdrinfo.caltargettempcoeff(21) hdrinfo.caltargettempcoeff(22) hdrinfo.caltargettempcoeff(23) hdrinfo.caltargettempcoeff(24)];
                            PRT7coeff=0*PRT5coeff;%[hdrinfo.caltargettempcoeff(25) hdrinfo.caltargettempcoeff(26) hdrinfo.caltargettempcoeff(27) hdrinfo.caltargettempcoeff(28)];
                           
                            % PRT temperatures (only for MHS there are these calculated Temp in the record)                         
                            PRT1temp=data.caltargettemp(:,1);
                            PRT2temp=data.caltargettemp(:,2);
                            PRT3temp=data.caltargettemp(:,3);
                            PRT4temp=data.caltargettemp(:,4);
                            PRT5temp=data.caltargettemp(:,5);
                            
                            % weighted mean of temperatures = temp of ICT at
                            % certain scanline
                            % NEED TO IMPLEMENT: taking only good PRTs for
                            % averaging
                            ICTtempmean=1/6 *(2*data.caltargettemp(:,1)+data.caltargettemp(:,2)+data.caltargettemp(:,3)+data.caltargettemp(:,4)+data.caltargettemp(:,5));
                            
                           
                            dataperorbit{orbit}.timevector = timevector;
                            dataperorbit{orbit}.time = bbto(:,3)/60;
                            dataperorbit{orbit}.day = bbto(:,2);
                            dataperorbit{orbit}.year = bbto(:,1);
                            dataperorbit{orbit}.dsvcounts = dsvcounts;
                            dataperorbit{orbit}.obctcounts = obctcounts;
                            dataperorbit{orbit}.earthcounts = earthcounts;
                            
                            dataperorbit{orbit}.udsvcounts = udsvcounts;
                            dataperorbit{orbit}.uobctcounts = uobctcounts;
                            dataperorbit{orbit}.uearthcounts = uearthcounts;
                            
                            dataperorbit{orbit}.countsobctViewmean=data.countsobctViewmean; %per (scanline,channel)
                            dataperorbit{orbit}.countsdsvViewmean=data.countsdsvViewmean;
                            
                            dataperorbit{orbit}.ICTtempmean=ICTtempmean; %per (scanline)
                            
                        
                            dataperorbit{orbit}.PRT1counts = PRT1counts;
                            dataperorbit{orbit}.PRT2counts = PRT2counts;
                            dataperorbit{orbit}.PRT3counts = PRT3counts;
                            dataperorbit{orbit}.PRT4counts = PRT4counts;
                            dataperorbit{orbit}.PRT5counts = PRT5counts;
                            dataperorbit{orbit}.PRT6counts = PRT6counts;
                            dataperorbit{orbit}.PRT7counts = PRT7counts;
                            dataperorbit{orbit}.PRT1coeff = PRT1coeff;
                            dataperorbit{orbit}.PRT2coeff = PRT2coeff;
                            dataperorbit{orbit}.PRT3coeff = PRT3coeff;
                            dataperorbit{orbit}.PRT4coeff = PRT4coeff;
                            dataperorbit{orbit}.PRT5coeff = PRT5coeff;
                            dataperorbit{orbit}.PRT6coeff = PRT6coeff;
                            dataperorbit{orbit}.PRT7coeff = PRT7coeff;
                            dataperorbit{selectorbit}.LO5temp=data.LO5temp;
                            
                          
                            


                       else
                            %orbit too short; orbit will be skipped by marking orbit as badorbit 
                            badorbit(counterskiporbit)=orbit; 
                            errorcode(counterskiporbit)=2; %errorcoding orbit as too short  


                       end   
           
           
           
                 % if the data of a single orbit couldn't be read an error flag will be
                 % set
                else
                        ierr(1,orbit) = 1;
                        counterskiporbit=counterskiporbit+1;
                        badorbit(counterskiporbit)= orbit;    % mark orbit as bad orbit                
                        skippedorbits(counterskiporbit)=orbit;
                        errorcode(counterskiporbit)=1; %errorcoding orbit as "not read correctly"

            
            
            
            end
          
            
end
%%%%%%%%%%%%% END:   READ IN VARIABLES FROM L1B-DATA FILE %%%%%%%%%%%%%%










