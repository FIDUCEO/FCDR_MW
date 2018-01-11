%
%
% mooncheck
%  
%
%



%%%%% read the information on the moon angle from data files created by
%%%%% mhs_cl program and process further (create flags and calculate DSV
%%%%% mean with reduced number of scanlines)
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

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this script uses the Run_Length.m function created by Jan
% Simon,Heidelberg, (C) 2013-2017 matlab.2010(a)n(MINUS)simon.de,
% available at https://www.mathworks.com/matlabcentral/fileexchange/41813-runlength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% info
%
% ONLY USE this script via calling function via generate_FCDR (which calls 
% setup_fullFCDR_uncertproc_MHS, which calls mooncheck).
% DO NOT use this script alone. It needs the output from preceeding
% functions in setup_fullFCDR_uncertproc_MHS.

% Script for setting moonflags and their coding their effect on the
% calibration procedure:
% The script reads the logfile generated by the program mhs_cl for the
% current orbitfile. In the logfile, the minmum angle to the moon is stored
% as well as all contaminated scnalinenumbers along with their contaminated
% views. The script reads out the min-angle and all contaminated
% scanlinenumbers and sets the moon flags according to the scheme explained
% below ("There are 4 cases"). These flags are taken over from the
% envelope-script "setup_fullFCDR..." to compile the final flags.

% The mooncheck script further collects the contaminated views and calculates
% the mean of the DSV counts for the scanline with reduced number of good
% views. This mean (per channel and contaminated scnaline) is taken over by
% the envelope-script "setup_fullFCDR...")


% output: 3 moonflags, DSV-mean values for scanlines with reduced number of
% good views.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 


% % build filename
% arraychar=char(that_file(selectorbit));
% %ADJUST for AMSUB or MHS on
% if strcmp(arraychar(end-3:end),'.bz2')
%       nameoffile=arraychar(cut:end-4);
% else
%       nameoffile=arraychar(cut:end-3);
% end
% %nameoffile=arraychar(cut:end-3); %FOR AMSUB use cut=25! since two characters more; end-3 to cut .gz
% %logfilename = fullfile(['/scratch/uni/u237/users/ihans/moondata/',sat,'/',num2str(year),'/','mhscl_',nameoffile,'.log']);
% logfilename = fullfile(['/scratch/uni/u237/user_data/mprange/',sat,'/',num2str(year),'/',selectinstrument,'cl_',nameoffile,'.log']);
% %logfilename = fullfile('/scratch/uni/u237/users/ihans/codes/amsubcl_3361112.log');
moon_global_donotuse=zeros(length(data.scan_line_year),1);
flag_moonintrusionfound=0;
indices=[];
if length(hdrinfo.dataset_name)==2
    
    for numfil=1:2
%          arraychar=char(that_file(selectorbit+i-1)); %+i-1 to generate +1
%         % for the 2nd file and 0 for the first file
%         % %ADJUST for AMSUB or MHS on
%          if strcmp(arraychar(end-3:end),'.bz2')
%                nameoffile{i}=arraychar(cut:end-4);
%                ending='.bz2';
%          else
%                nameoffile{i}=arraychar(cut:end-3);
%                ending='.gz';
%          end
%     %nameoffile=hdrinfo.dataset_name(i);
%     hdrinfo.dataset_name{i}={strcat(nameoffile,ending)};
    logfilename = char(strcat('/scratch/uni/u237/user_data/mprange/',sat,'/',num2str(year),'/',selectinstrument,'cl_',nameoffile{numfil},'.log'));


    moonfile=fileread(logfilename);
    positionofMin=strfind(moonfile, 'Min'); %search for 'Min' inidcating minimum moon angle.
    numberofnewlines=strfind(moonfile(1:positionofMin), sprintf('\n')); %count lines until this position of 'Min'
    numberoflinestoskip=length(numberofnewlines); 

    %open logfile created by mhs_cl-program
    fileID = fopen(logfilename);
    %read out Line of file containing minimum angle 
    LineForMinAngle= textscan(fileID,'%s %s %s %s %s %f %f ',1,'HeaderLines',numberoflinestoskip);
    minangle=LineForMinAngle{6}; % read out min angle
    %read out Lines of file containing info for all contaminated scanlines
    %LinesForScanlines=textscan(fileID,'%s %d %s %d %s %s %f ','HeaderLines',5);

    C = textscan(fileID, '%s','Delimiter','');
    C = C{:};
    Lia = ~cellfun(@isempty, strfind(C,'Moon'));
    output = [C{find(Lia)}];
    
        if isempty(output)
            
            %indices(:,i)=[];
            fclose(fileID);
            
        else
            LinesForScanlines=textscan(output,'%s %d %s %d %s %s %f ');
            fclose(fileID);
            
            intermed_scannumbers=LinesForScanlines{2}; % read out all contaminated scannumbers
            scannumbers_vec{numfil}=intermed_scannumbers; %not true anymore: %(1:end-1); % leave out the last one since it is zero (last line is read wrongly by textscan)

            intermed_contviews=LinesForScanlines{4};
            contviews_vec{numfil}=intermed_contviews;
        end

    
    end
    
     if isempty(output)
         scannumbers=[];
     else
    % relate scannumbers to the new scan-line-numbers that have been created
    % due to Eq2Eq fitting
    
    [scanlinenumbers_newnumbering,scanlinenumbers_intermed]=fill_missing_scanlines(double(data.scan_line_UTC_time),data.orig_scnlinnum,double(data.orig_scnlinnum));
    endof1stfile_missscanlinfilled=find(abs(diff(double(scanlinenumbers_intermed)))>100);
    
    [liA,locB1]=ismember(double(scannumbers_vec{1}),double(scanlinenumbers_intermed(1:endof1stfile_missscanlinfilled)));
    [liA,locB2]=ismember(double(scannumbers_vec{2}),double(scanlinenumbers_intermed(endof1stfile_missscanlinfilled+1:end)));
    ind1=find(locB1);
    indices{1}=locB1(ind1);
    ind2=find(locB2);
    indices{2}=locB2(ind2)+endof1stfile_missscanlinfilled; %add offset "endof1stfile" to get correct positions in full data.orig_scnlinnum vector
    flag_moonintrusionfound=1;
    
    
            if isempty(indices)
                scannumbers=[];
            else
                scannumbers=[scanlinenumbers(indices{1}),scanlinenumbers(indices{2})];
                contviews=[contviews_vec{1}(ind1); contviews_vec{2}(ind2)];

            end
     end
     
else
    
%         arraychar=char(that_file(selectorbit)); 
%         % %ADJUST for AMSUB or MHS on
%          if strcmp(arraychar(end-3:end),'.bz2')
%                nameoffile=arraychar(cut:end-4);
%                ending='.bz2';
%          else
%                nameoffile=arraychar(cut:end-3);
%                ending='.gz';
%          end
%     
%     hdrinfo.dataset_name{1}={strcat(nameoffile,ending)};
    logfilename = char(strcat('/scratch/uni/u237/user_data/mprange/',sat,'/',num2str(year),'/',selectinstrument,'cl_',nameoffile,'.log'));


    moonfile=fileread(logfilename);
    positionofMin=strfind(moonfile, 'Min'); %search for 'Min' indicating minimum moon angle.
    numberofnewlines=strfind(moonfile(1:positionofMin), sprintf('\n')); %count lines until this position of 'Min'
    numberoflinestoskip=length(numberofnewlines); 

    %open logfile created by mhs_cl-program
    fileID = fopen(logfilename);
    %read out Line of file containing minimum angle 
    LineForMinAngle= textscan(fileID,'%s %s %s %s %s %f %f ',1,'HeaderLines',numberoflinestoskip);
    minangle=LineForMinAngle{6}; % read out min angle
    %read out Lines of file containing info for all contaminated scanlines
    %LinesForScanlines=textscan(fileID,'%s %d %s %d %s %s %f ','HeaderLines',5);

    C = textscan(fileID, '%s','Delimiter','');
    C = C{:};
    Lia = ~cellfun(@isempty, strfind(C,'Moon'));
    output = [C{find(Lia)}];
    
    if isempty(output)
            
            %indices(:,i)=[];
            fclose(fileID);
            scannumbers=[];
            
    else
            LinesForScanlines=textscan(output,'%s %d %s %d %s %s %f ');
            fclose(fileID);
            
            intermed_scannumbers=LinesForScanlines{2}; % read out all contaminated scannumbers
            scannumbers_vec=intermed_scannumbers; %not true anymore: %(1:end-1); % leave out the last one since it is zero (last line is read wrongly by textscan)

            intermed_contviews=LinesForScanlines{4};
            contviews_vec=intermed_contviews;
            
             % relate scannumbers to the new scan-line-numbers that have been created
            % due to Eq2Eq fitting
            [scanlinenumbers_newnumbering,scanlinenumbers_intermed]=fill_missing_scanlines(double(data.scan_line_UTC_time),data.orig_scnlinnum,double(data.orig_scnlinnum));
            endof1stfile_missscanlinfilled=find(abs(diff(double(scanlinenumbers_intermed)))>100);

            [liA,locB]=ismember(double(scannumbers_vec),double(scanlinenumbers_intermed(1:endof1stfile_missscanlinfilled)));
            ind=find(locB);
            indices=locB(ind);
            flag_moonintrusionfound=1;


            if isempty(indices)
                scannumbers=[];
            else
                scannumbers=scanlinenumbers(indices);
                contviews=contviews_vec(ind);

            end
            
    end
    
    

   
    
end





% The variables minangle and scannumbers contain all information for the
% easyFCDR flags.



%%%% set the moon flags

% There are 4 cases:
% 1. Moon is far away from DSV (all moon flags zero)
% 2. Moon close to DSV but not significant (Moonflag1 =1)
% 3. Significant Moon Intrusion in DSV 
%    a) at least one DSV is not contaminated. Calibration carried out with
%    decrease number of DSV. (Moonflag2=1)
%    b) all DSVs are contaminated. Need to take last uncontaminated scan.
%    (Moonflag3=1)
%    


% the moonflagXXX-variables are initialized as zero vectors in the script
% setup_fullFCDR_uncertproc_MHS.m


if ~isempty(scannumbers) %only if the intermed_scannumbers is NOT empty,
    %we have to look at the individual scanlines to set moonflags
    %If intermed_scannumbers is NOT empty, then minangle<=2.0 (threshold from
    %mhs_cl program).
    % if minangle is smaller than 2.0 degrees, there is high probability that
    % the moon contaminates the signal (increased uncertainty)
    
    
    
    % set the flag for the contaminated scanlines (use variable
    % "scannumbers")
    moonflagSignificantMoonIntrusion(scannumbers)=1; % not used in final set of flags
    
    % How many views are contaminated in each contaminated scanline?
    % count repetitions of scannumber appeareance --> count number of
    % contaminated DSV per scanline
    [contscanlines,numberofviews,indicesInScannumbers]=RunLength_M(scannumbers);
    
    flagperscannumber=int8(floor(numberofviews/4)).'; %generate zeros for 1 to 3 repetitions of scanline (i.e. 1-3 views are contaminated)
    % and generate ones for 4 repetitions, i.e. 4 views are contaminated.
     scnlinallviewsbad=contscanlines(find(flagperscannumber));% takes scanlines for which
    % flagperscannumber is nonzero (here: one)
     scnlinoneviewok=contscanlines(find(~flagperscannumber));% takes scanlines for which
    % flagperscannumber is zero 
    moonflagAllViewsBad(scnlinallviewsbad)=1; %set flag for scanlines for which 4 DSV are contaminated
    moonflagOneViewOk(scnlinoneviewok)=1; % set flag for scanlines for which at least 1 view is ok

    
    % read out contaminated views per scanline
    %intermed_contviews=LinesForScanlines{4};
    %contviews=intermed_contviews;%not true anymore:(1:end-1);
    %contviews
    moonflagwhichviewbad=zeros(length(data.scan_line_year),4);
    allviews=[1 2 3 4];
    for numcontline=1:length(contscanlines)
        contaminatedviews{numcontline}=contviews(indicesInScannumbers(numcontline):indicesInScannumbers(numcontline)+(numberofviews(numcontline)-1));
        intermed_okviews{numcontline}=setdiff(allviews,contaminatedviews{numcontline});
        okviews = intermed_okviews(~cellfun(@isempty, intermed_okviews));
        % construct flag indicating for every scanline and every view, whether
        % it is good=0 or bad=1
        moonflagwhichviewbad(contscanlines(numcontline),contaminatedviews{numcontline})=1;     
    end
    
    
    
    for numokline=1:length(scnlinoneviewok)
        meandsvch1okviews(numokline)=        mean(dsvch1(scnlinoneviewok(numokline),okviews{numokline}),2);
        meandsvch2okviews(numokline)=        mean(dsvch2(scnlinoneviewok(numokline),okviews{numokline}),2);
        meandsvch3okviews(numokline)=        mean(dsvch3(scnlinoneviewok(numokline),okviews{numokline}),2);
        meandsvch4okviews(numokline)=        mean(dsvch4(scnlinoneviewok(numokline),okviews{numokline}),2);
        meandsvch5okviews(numokline)=        mean(dsvch5(scnlinoneviewok(numokline),okviews{numokline}),2);
    end
    
else

    scnlinallviewsbad=[];
    scnlinoneviewok=[];
    
    
    if minangle<=2.0 && flag_moonintrusionfound==0
    disp('Error. Moon intrusion somewhere in the orbit probable, but not documented for scanlines in logfile. Do not use any scanline.')
    moon_global_donotuse=ones(length(data.scan_line_year),1);
    elseif minangle<=2.0 && flag_moonintrusionfound==1
    disp('Moon intrusion happens outside the Equator-to-Equator frame. No influence on calibration of this file.')
    
    elseif 2.0< minangle && minangle<2.5
    % if minangle is larger than 2.0 degrees but smaller than 2.5, we say that
    % there is little chance that the moon contaminates the signal (slightly
    % increased uncertainty) somewhere in the orbit
    
    moonflagMoonCloserButNotSignificant=ones(length(data.scan_line_year),1); %set flag to 1 for all scanlines
    
    % if minangle is larger than 2.5 degrees, we say we are on the safe side
    % that the moon is NOT in the DSV (NO increased uncertainty): NO FLAG!!
    end
    
    
end




