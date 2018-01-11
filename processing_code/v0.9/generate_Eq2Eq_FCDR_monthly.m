
% generate_FCDR

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

% function for generating FCDRs

% NOTE: this is planned to be used as function. However, for the
% developing process it is easier to use it as script.

% INPUT satellite e.g. 'noaa18'
%       instrument e.g. 'mhs'
%       year e.g. 2006
%       orbit e.g. 202;

% OUTPUT none. The function calls scripts to write the easy and full FCDR
% netcdf-files to the path specified in the writing functions.

% % STRUCTURE
% generate_Eq2Eq_FCDR(satellite, instrument, year, orbit)
% 
% calls scripts (S) and functions (F):

% atmlab_init (S)
%   read_MHS_allvar_noh5write (F)
%   read_MHS_header(F)
%   read_MHS_record(F)
%   get_equator_crossing(F)

% setup_Eq2Eq_fullFCDR_uncertproc_MHS (S)  
%   mills2hmsmill(F)
%   fill_missing_scanlines(S)
%   mooncheck(S)
%   calculate_AllanDeviation_onCounts_withoutQualflags (S)
%       Msamplevariance(F)
% 	qualitychecksDSV (S)
%   qualitychecksIWCT (S)
%   scanlineavCounts (F)
%   calculate_AllanDeviation_onCounts (S)
%       Msamplevariance(F)
%   qualitychecksPRT (S)
%   scanlineavCounts (F)
%   calculate_AllanDeviation_onPRT (S)
%   Msamplevariance(F)
%   qualitychecksEarthLocation (S)
%   qualitychecksSpaceViewLocation (S)
%   qualitychecksIWCTViewLocation (S)

% 
% measurement_equation (S)
%   planck (F)
%   invplanck (F)
% 
% uncertainty_propagation_optimized (S)
%   DplanckDT (F)
%   DplanckDf (F)
%   DinvplanckDrad (F)

% 
% quality_flags_setting(S) 

% write_easyFCDR_orbitfile (S)
%   change_type_zero_nan(F)
% 
% write_fullFCDR_orbitfile (S)
%   change_type_zero_nan(F)
%   change_type(F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% function definition

% FIXME: make index file for each satellite: i.e. containing its whole
% mission. Thus, we do not run into end-start-of-year-problems.

% FIXME:make this a function(satellite) again.

%function generate_Eq2Eq_FCDR(satellite,instrument,year,startorbit)
function generate_Eq2Eq_FCDR_monthly(satellite,instrument,year,month)
tic
%  satellite='noaa18';%'metopb';%'noaa16';%'metopb';
%  instrument='mhs';%'mhs';
%  year=2009;%2001;%2014; %2006 
%  month=3;
% %orbit=202;
% startorbit=2360;%3536;%104;%1877;%186;%633;%366;%943;%senstudyn18:503;%230;%623;%orbit with bad PRT4290;%mhsmetopb orbits2643;%3328;%2643;%2591;%2543 start for full april;%2643;%2643; %1643 %2567 in 2014 metopb has missing scanlines
% endorbit=2361;%3537;%105;%1878;%187;%634;%367;%944;%504;%233;%626;%4295; %mhsmetopb orbits2643;%3328;%2643;%3382;%2643;%2643;
% %endorbit=startorbit+1;


% collecting setup data
selectsatellite=satellite;
selectinstrument=instrument;
selectyear=year;
%selectorbit=orbit;

% reshaping satellite, instrument and year to string that is used in the
% building of several file- or foldernames in the subsequent scripts
sat=selectsatellite;
sen=selectinstrument;
satsenyear=strcat(selectsatellite,'_',selectinstrument,'_',num2str(selectyear));

% The following if-statement checks whether AMSUB or MHS has been chosen.
% There is a seperate processing chain for either of the instruments, since
% there are some differences between the instruments. 

if strcmp(selectinstrument,'mhs')
  %% MHS
% set variable "cut" for cutting pathinfo from filenames (the length of the path varies due to different satellite/ instrument names)
   
    cut=23;
   
  %% initialising of atmlab
atmlab_init %atmlab needs to be initialized in startup file of matlab!!!

%%%%%%%%%%%%% SET UP READING L1B- and AAPP output DATA FILE %%%%%%%%%%%%%%

%% data path to index files 

% read in list of index-files.
% The indexfiles contain the path to every orbit file. They are per
% satellite and year so far.

% Watch out! you are processing the real time data! (index file from mhs_obsolete)
% I am doing this now (15.12.2017) since the AAPP-moon-file made by Marc only exist for the realtime files and the data names are different from the new ones!
filenames = importdata(['/scratch/uni/u237/users/ihans/indexfiles_sorted/mhs_obsolete/',satsenyear,'.index-sorted']); % ".index-sorted" to use the sorted ones! You have to update the sorted ones
% from time to time (to get the most recent version, since the download on
% updating of the original indexfiles is continuously ongoing)
%filenames = importdata(['/scratch/uni/u237/data/amsu/',satsenyear,'.index']);%path to original index files




%% Reading  l1b files and Equator-to-Equator fitting


onlysinglefile_before=0; %marker to indicate that previous new file was generated of a single one (for cases where one original file has 2 ascending equator crossings). Initialize this marker with zero.

% load limits for counts, "antenna correction coeffs" and coefficient "alpha" from file
filenamestring=['coeffs_',sat,sen,'_antcorr_alpha.mat'];
load(filenamestring)

% renaming
that_file = filenames;
% initialization of vector that will contain info on failed reading of
% individual l1b files
ierr = zeros(1, numel(that_file));


% searching for first and last orbit-file of month 
monthstring=num2str(month,'%02d');

for i=1:length(that_file)
    filenamestruct{i}=cell2mat(that_file(i));
    comp(i)=strcmp(filenamestruct{i}(17:18),monthstring);
end;

startorbit=find(comp,1,'first');
endorbit=find(comp,1,'last')+1; %take also 1st file from next month to do Eq2Eq fitting
numberoforbits=endorbit-startorbit;


% read data for the very first orbit. For every other orbit, the data1 will
% be taken from the previous data2

err1_start=1; 
 counter_err_files=0;
while err1_start==1
    this_file_first = char(strcat('/scratch/uni/u237/data/mhs_obsolete/', that_file(startorbit+counter_err_files)));  
    [hdrinfo1,data1,quality_indicator_lines1,quality_flags_0_lines1,quality_flags_1_lines1,quality_flags_2_lines1,quality_flags_3_lines1,quality_flags_lines1,err1] = read_MHS_allvar_noh5write(this_file_first,1);
    counter_err_files=counter_err_files+1;
    err1_start=err1; %put now the true error value into err1_start to finish the loop, as soon as no further error occurred, i.e. err1=0.
end      
startorbit=startorbit+counter_err_files-1; %subtract one since the counter is also increased in the last iteration where the file is good finally

% loop over all chosen orbits
selectorbit=startorbit;
while selectorbit<=endorbit-1    
    if toc<8000
    % clear variables EXCEPT the listed ones. These are needed for the processing of the next
    % files still.
    clearvars -except  startorbit that_file ierr cut satsenyear sat sen year selectsatellite selectinstrument ... 
        selectyear selectorbit gE gS gSAT alpha endorbit eq_scnlin_vcp2 onlysinglefile_before count_thriwct...
        count_thrdsv jump_thr threshold_earth jump_thrICTtempmean ...
        hdrinfo1 data1 quality_indicator_lines1 quality_flags_0_lines1 quality_flags_1_lines1 quality_flags_2_lines1 ...
        quality_flags_3_lines1 quality_flags_lines1 err1 ...
        hdrinfo2 data2 quality_indicator_lines2 quality_flags_0_lines2 quality_flags_1_lines2 quality_flags_2_lines2 ...
        quality_flags_3_lines2 quality_flags_lines2 err2 numberoforbits
    
    % store the previous data in_prev-variables and delete the old ones (to
    % free their names for this iteration)
        hdrinfo1_prev=hdrinfo1;
        data1_prev=data1;
        quality_indicator_lines1_prev=quality_indicator_lines1;
        quality_flags_0_lines1_prev=quality_flags_0_lines1;
        quality_flags_1_lines1_prev=quality_flags_1_lines1;
        quality_flags_2_lines1_prev=quality_flags_2_lines1;
        quality_flags_3_lines1_prev=quality_flags_3_lines1;
        quality_flags_lines1_prev=quality_flags_lines1;
        err1_prev=err1;
        
        % normal case (NOT startorbit): store the data2. 
       if selectorbit~=startorbit 
        hdrinfo2_prev=hdrinfo2;
        data2_prev=data2;
        quality_indicator_lines2_prev=quality_indicator_lines2;
        quality_flags_0_lines2_prev=quality_flags_0_lines2;
        quality_flags_1_lines2_prev=quality_flags_1_lines2;
        quality_flags_2_lines2_prev=quality_flags_2_lines2;
        quality_flags_3_lines2_prev=quality_flags_3_lines2;
        quality_flags_lines2_prev=quality_flags_lines2;
        err2_prev=err2;
       end
       
        % free the variable names 
        clear hdrinfo1 data1 quality_indicator_lines1 quality_flags_0_lines1 quality_flags_1_lines1 quality_flags_2_lines1 ...
        quality_flags_3_lines1 quality_flags_lines1 err1 ...
        hdrinfo2 data2 quality_indicator_lines2 quality_flags_0_lines2 quality_flags_1_lines2 quality_flags_2_lines2 ...
        quality_flags_3_lines2 quality_flags_lines2 err2
        
    startline=1;
    
    
    
    % If the previously produced FCDR file was constructed from a single
    % one (i.e. onlysinglefile_before=1), then we still need to use the data of
    % the file after the second ascending (or descending resp.) equator
    % crossing. Therfore, we have to redo the iteration step on this orbit
    % (the correct reading is taken care of below): reset the orbit counter
    % to its last value.
    % 
    if onlysinglefile_before==1
        selectorbit=selectorbit-1;
        
        % in this case, put the data1 from previous iteration again into
        % data1 of this iteration.
        hdrinfo1=hdrinfo1_prev;
        data1=data1_prev;
        quality_indicator_lines1=quality_indicator_lines1_prev;
        quality_flags_0_lines1=quality_flags_0_lines1_prev;
        quality_flags_1_lines1=quality_flags_1_lines1_prev;
        quality_flags_2_lines1=quality_flags_2_lines1_prev;
        quality_flags_3_lines1=quality_flags_3_lines1_prev;
        quality_flags_lines1=quality_flags_lines1_prev;
        err1=err1_prev;
       
    elseif onlysinglefile_before==0 && selectorbit==startorbit
        % in this case, put the data1 that you read in before the
        % while-loop back into the data1 again
        hdrinfo1=hdrinfo1_prev;
        data1=data1_prev;
        quality_indicator_lines1=quality_indicator_lines1_prev;
        quality_flags_0_lines1=quality_flags_0_lines1_prev;
        quality_flags_1_lines1=quality_flags_1_lines1_prev;
        quality_flags_2_lines1=quality_flags_2_lines1_prev;
        quality_flags_3_lines1=quality_flags_3_lines1_prev;
        quality_flags_lines1=quality_flags_lines1_prev;
        err1=err1_prev;
    else
        % normal case, two files have been used, i.e. use the 2nd one now
        % as the first one.
        hdrinfo1=hdrinfo2_prev;
        data1=data2_prev;
        quality_indicator_lines1=quality_indicator_lines2_prev;
        quality_flags_0_lines1=quality_flags_0_lines2_prev;
        quality_flags_1_lines1=quality_flags_1_lines2_prev;
        quality_flags_2_lines1=quality_flags_2_lines2_prev;
        quality_flags_3_lines1=quality_flags_3_lines2_prev;
        quality_flags_lines1=quality_flags_lines2_prev;
        err1=err2_prev;
        
    end
    
    
    %selectorbit
    disp(['orbit ',num2str(selectorbit-startorbit+1),'/',num2str(numberoforbits)])
    disp(['orbit of year: ', num2str(selectorbit)])
    
    
    % get the path to the current orbit file from the list of index files
    this_file = char(strcat('/scratch/uni/u237/data/mhs_obsolete/', that_file(selectorbit)));
    
    % The following if-statement makes the distinction between the normal
    % case and the very last orbit of the chosen list of orbits (the last
    % orbit cannot be handled in the Equator-to-Eqator fitting like the other
    % ones)
    if selectorbit~=endorbit
        
        decided_which_files_to_use=0;
        go_to_next_iteration=0;
        counter_files=0;
        add_to_selectorbit=0;
        
        while decided_which_files_to_use==0
            counter_files=counter_files+1;
            % get the path to the file subsequent to the current orbit file
            % from the list of filenames (indexfiles)
            this_file_2 = char(strcat('/scratch/uni/u237/data/mhs_obsolete/', that_file(selectorbit+counter_files)));
            this_file_3 = char(strcat('/scratch/uni/u237/data/mhs_obsolete/', that_file(selectorbit+counter_files+1)));
            
            %list_of_filenames=[this_file; this_file_2; this_file_3];
             list_of_filenames{1}=this_file;
             list_of_filenames{2}=this_file_2;
             list_of_filenames{3}=this_file_3;
            
            [skip_this_file_1, skip_this_file_2]=check_which_files_to_use(list_of_filenames{1},list_of_filenames{2},list_of_filenames{3},selectinstrument);

            %[skip_this_file_1, skip_this_file_2]=check_which_files_to_use(list_of_filenames(1,:),list_of_filenames(2,:),list_of_filenames(3,:));

                if skip_this_file_1==1
                    %first file should be skipped
                    % go to next iteration step
                    go_to_next_iteration=1;
                    break% exit this while loop to jump back to "orbit"-loop

                elseif skip_this_file_2==1
                    % the 2nd file should be skipped. Now look at file1, file 3
                    % file 4, by setting counter to next value, thus generating the
                    % filename3 now as filename2.
                    decided_which_files_to_use=0;
                    
                    add_to_selectorbit=add_to_selectorbit+1; 
                    %increase the selected orbit
                    %by the accumulated number of skipped files to get the
                    %correct orbit in the next iteration (for every skipped
                    %file need to increase orbit by one, in order to jump
                    %to the appropriate orbit in the next iteration of the
                    %while loop over the orbits: note that at the very end
                    %there is again the normal selectorbit+1)
                else
                    % both file 1 and 2 can be used normally.
                    
                    decided_which_files_to_use=1;
                end

            
        end
        
        
        % in case that the 1st file should be skipped, continue with next
        % iteration
        if go_to_next_iteration==1
            
            % read in second file since it is needed for next iteration as
            % file1
            [hdrinfo2,data2,quality_indicator_lines2,quality_flags_0_lines2,quality_flags_1_lines2,quality_flags_2_lines2,quality_flags_3_lines2,quality_flags_lines2,err2] = read_MHS_allvar_noh5write(this_file_2,startline);
            
            selectorbit=selectorbit+1;
            %set onlysinglefile_before to zero, since this file1 is skipped
            %and we do not need the prev. file to this file1 anymore
            onlysinglefile_before=0;
            disp('1st file skipped. Go to next iteration')
            continue
        end
        
        
        
        % FIXME as for MHS: how to handle inconsitent orbit sequences
        % (half, full, both, missing,...)?
        % It would be better to totally reimplement the Eq2Eq-fitting,
        % based on an external preparation of an equator-crossings database
        % or so.
        
        disp('read l1b files...')
        
        % read all variables of l1b files (current orbit plus next file)
        %
        % the current orbit got its data from the 2nd file of the
        % previous orbit.
        
        
        % read in 2nd file only
%         tic
%         [hdrinfo1,data1,quality_indicator_lines1,quality_flags_0_lines1,quality_flags_1_lines1,quality_flags_2_lines1,quality_flags_3_lines1,quality_flags_lines1,err1] = read_MHS_allvar_noh5write(this_file,startline);
%         toc
        [hdrinfo2,data2,quality_indicator_lines2,quality_flags_0_lines2,quality_flags_1_lines2,quality_flags_2_lines2,quality_flags_3_lines2,quality_flags_lines2,err2] = read_MHS_allvar_noh5write(this_file_2,startline);
    
%        check for reading errors
        if err1==1 
            disp('Error while reading L1b file1.')
            % set flag that this orbit file could not be read.
            ierr(selectorbit)=1;
            % go to next iteration step
            selectorbit=selectorbit+1;
            continue
        elseif  err2==1
            disp('Error while reading L1b file2.')
            % set flag that this orbit file could not be read.
            ierr(selectorbit+1)=1;
            % go to next iteration step (this next step will re-read the corrupt file and again cause this error. But this time then for err1.)
            selectorbit=selectorbit+1;
            continue
        end
        err=max([err1, err2]);
                
        
        %  We now do the Equator to Equator fitting. All
        % following code until the "set up and processing" is dedicated to
        % this Eq2Eq fitting. It captures the various cases of where in the
        % file the equator crossing happens or whether only a single file
        % is needed to get the correct format and how to proceed after this
        % case.            
                    
     
                    
        disp('Determine equator crossings...')
        % get Equator crossings
        [eq_scnlin_vcp1,eq_scnlin_vcp2,onlysinglefile,no_crossing_found]=get_equator_crossing_l1b(data1,data2,onlysinglefile_before,sat);
        
        % WATCH OUT! this is only an intermediate step to force the code to
        % preceede. This case should be handled gracefully in the final
        % version!
        if no_crossing_found==1
            selectorbit=selectorbit+1;
            continue
        end
        
        % change the start of the to-be-processed file to 3 lines before,
        % and the end 3 lines after the actual crossing. This is needed to
        % get the correct averaging also at the very first stored line
        % (which is the actual eq_crossing).
       eq_scnlin_vcp1=eq_scnlin_vcp1-3;
       eq_scnlin_vcp2=eq_scnlin_vcp2+3;
       
       % for cases where the first Eq crossing happens at the very first
       % scanline, we have to start there, we cannot use the 3 lines
       % before. The same for 2nd Eq-crossing at the very last line:
       
       if eq_scnlin_vcp1<=0
            eq_scnlin_vcp1=1;
            
       elseif onlysinglefile==1 && eq_scnlin_vcp2>= length(data1.scan_line_number)
            eq_scnlin_vcp2=length(data1.scan_line_number);
            
       elseif onlysinglefile==0 && eq_scnlin_vcp2>= length(data2.scan_line_number)
           eq_scnlin_vcp2=length(data2.scan_line_number);
           
       end
       
        
        % Assure cutting of overlap of subsequent files:
        % "Cut ending of file"
        % Get last scanline of first file that is NOT contained in second
        % file, i.e.
        %find the scanlines (times!) that are also contained in the next
        %file. Then take the line before the first found one. If none is
        %found, there is no overlap (isempty(newlines)).
        newlines=find(ismembertol(double(data1.scan_line_UTC_time), double(data2.scan_line_UTC_time),1,'DataScale',1));
        if isempty(newlines) %i.e. no overlap of subsequent files!
            
            endrecline=length(data1.scan_line_UTC_time);
        else
            endrecline=newlines(1)-1;
        end
        
        
        % Reshaping to Eq to Eq files:
        % 1. if-statement: is there a datagap larger than 1 orbit?
        %   YES: only use the first file from 1st Eqcrossing to end
        %   NO: continue with else-if statement
        %  else-if-statement: 1st file ends AFTER 1st Equator crossing?
        %   YES: go ahead with Eq2Eq fitting:
        %       2. if-statement: Is only one file needed for Eq2Eq fitting?
        %                 YES: Reshape file1 to Eq2Eq. Then go on with
        %                 next iteration step.
        %                 NO: Concatenate file1 and file2 to get Eq2Eq
        %                 file.
        %   NO: this current file is not needed. Go to next orbit.
        % 
        % This is repeated in every iteration step of the while-loop on
        % "selectorbit". The Last Orbit gets different treatment. See
        % else-statement of "if selectorbit~=endorbit".

               
        if endrecline>eq_scnlin_vcp1  %check whether eq.crossing of 1st file comes before next file starts. If so, then do the reshaping. If not: go to next orbit, i.e. skip this 1st file and 2nd file becomes first.
        
                disp('Reshape file to equator to equator file...')
                % concatenate L1b files to get Equator To Equator files

                onlysinglefile
                
                % check for data gaps larger than one orbit. In this case
                % only one file is needed.
                datagap_detected=0;
                check_for_datagap 

                
                
                if datagap_detected==1 && onlysinglefile==0
                    
                    if onlysinglefile_before==1
                        % the first file has been used already.
                        % Set back onlysinglefile_before=0  and go to next iteration. 
                        disp('Data Gap. But first file has been used already. Go to next iteration.')
                        selectorbit=selectorbit+1;
                        onlysinglefile_before=0 ;
                        continue
                    end
                    
                    
                    %if a large data gap has been detected, we only use the
                    %first file. The second one is kept as first one in
                    %the next iteration.
                    end_of_1stfile=double(data1.scan_line_number(end));
                    
                    f = fieldnames(data1);
                    for k=1:numel(f) %loop over all fieldnames
                        tmp1=data1.(f{k});
                        tmp1part=tmp1(:,eq_scnlin_vcp1:end_of_1stfile); %extract the part from 1rst equator crossing to 2nd one


                        data.(f{k}) =tmp1part; % write part of orbit into new data variable
                    end

                    % the other variables
                        quality_indicator_lines=quality_indicator_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_0_lines=quality_flags_0_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_1_lines=quality_flags_1_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_2_lines=quality_flags_2_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_3_lines=quality_flags_3_lines1(eq_scnlin_vcp1:end_of_1stfile,:);

                        for i=1:5
                        quality_flags_lines1_struct{i}=squeeze(quality_flags_lines1(i,:,:));
                        quality_flags_lines{i}=quality_flags_lines1_struct{i}(eq_scnlin_vcp1:end_of_1stfile,:);
                        end

                        %for header (which has no scanline-dimension): keep first header
                        hdrinfo=hdrinfo1;
                        
                        % build new scanline vector starting from 1,
                        % preserving jumps of scanlines that need to be
                        % treated by fill_missing_scanlines
                        data.orig_scnlinnum=data.scan_line_number; %save original scanline numbers (start is not 1 but at equator-crossing-scanline)
                        data.scan_line_number=data.orig_scnlinnum(1:end)-data.orig_scnlinnum(1)+1; %create vector starting at 1

                        
                        
                        

                elseif onlysinglefile==1

                        f = fieldnames(data1);
                    for k=1:numel(f) %loop over all fieldnames
                        tmp1=data1.(f{k});
                        tmp1part=tmp1(:,eq_scnlin_vcp1:eq_scnlin_vcp2-1); %extract the part from 1rst equator crossing to 2nd one


                        data.(f{k}) =tmp1part; % write part of orbit into new data variable
                    end

                    % the other variables
                        quality_indicator_lines=quality_indicator_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_0_lines=quality_flags_0_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_1_lines=quality_flags_1_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_2_lines=quality_flags_2_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_3_lines=quality_flags_3_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);

                        for i=1:5
                        quality_flags_lines1_struct{i}=squeeze(quality_flags_lines1(i,:,:));
                        quality_flags_lines{i}=quality_flags_lines1_struct{i}(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        end

                        %for header (which has no scanline-dimension): keep first header
                        hdrinfo=hdrinfo1;
                        
                        % build new scanline vector starting from 1,
                        % preserving jumps of scanlines that need to be
                        % treated by fill_missing_scanlines
                        data.orig_scnlinnum=data.scan_line_number; %save original scanline numbers (start is not 1 but at equator-crossing-scanline)
                        data.scan_line_number=data.orig_scnlinnum(1:end)-data.orig_scnlinnum(1)+1; %create vector starting at 1

                        
                       
                        
                        
                        % Here, only one file was used to create the
                        % equator2equator file (since it already had 2 ascending
                        % crossings). This means, that for the next iteration, we
                        % have to reopen the current original file again to use its
                        % rest, i.e. only the data after the second crossing! Doing
                        % it normally would yield to an endless loop since the
                        % get_equator would always find the first and second
                        % crossing again...
                        % Therefore we set a marker that indicates that only one
                        % file has been used in the new file:

                        onlysinglefile_before=1;


                else
                        % NORMAL CASE: 2 files needed to get one Eq2Eq file
                    
                        f = fieldnames(data1);
                    for k=1:numel(f) %loop over all fieldnames
                        tmp1=data1.(f{k});
                        tmp1part=tmp1(:,eq_scnlin_vcp1:endrecline); %extract the part from Equator to end of first datafile, per fieldname; endrecline denotes the last scan line that is NOT contained in the next file.

                        tmp2=data2.(f{k});
                        tmp2part=tmp2(:,1:eq_scnlin_vcp2-1); %extract the part from start to Equator of second datafile, per fieldname

                        data.(f{k}) = horzcat(tmp1part, tmp2part); % concatenate both parts to get new data variable.
                    end



                % the other variables
                quality_indicator_lines=vertcat(quality_indicator_lines1(eq_scnlin_vcp1:endrecline,:), quality_indicator_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_0_lines=vertcat(quality_flags_0_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_0_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_1_lines=vertcat(quality_flags_1_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_1_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_2_lines=vertcat(quality_flags_2_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_2_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_3_lines=vertcat(quality_flags_3_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_3_lines2(1:eq_scnlin_vcp2-1,:));

                for i=1:5
                    quality_flags_lines1_struct{i}=squeeze(quality_flags_lines1(i,:,:));
                    quality_flags_lines2_struct{i}=squeeze(quality_flags_lines2(i,:,:));
                    quality_flags_lines{i}=vertcat(quality_flags_lines1_struct{i}(eq_scnlin_vcp1:endrecline,:), quality_flags_lines2_struct{i}(1:eq_scnlin_vcp2-1,:));
                end
                
                
                % HEADER
                %for header (which has no scanline-dimension): keep first header
                hdrinfo=hdrinfo1;
                %but add second filename to hdrinfo.
                hdrinfo.dataset_name={hdrinfo1.dataset_name, hdrinfo2.dataset_name};

                
                % SCANLINE vector
                
                % save original scanline numbers including discontinuities
                % due to concatenation of 2 files: e.g. starting at 534
                % going up to 2101, then from 2nd file scanline 1 to 1440
                data.orig_scnlinnum=data.scan_line_number; 
                
                % Build new scanline vector from both files, but preserving
                % any initial jumps in the individual files.
                %element at which 1st file ends
                endof1stfile=length([eq_scnlin_vcp1:endrecline]);
                %part1 of new scanlines going from 1 until end of 1st file
                newscnlinpart1=data.orig_scnlinnum(1:endof1stfile)-data.orig_scnlinnum(1)+1;
                % part2 of new scanlines starting from 2nd file on: take
                % original scanlinenumbers for the file and subtract the
                % scanlinenumber of the 1st line of the 2nd file and add 1
                % to start at 1. Then add the "endof1stfile" to make the
                % link to the 1st part.
                newscnlinpart2=data.orig_scnlinnum(endof1stfile+1:end)-data.orig_scnlinnum(endof1stfile+1)+1+endof1stfile; 
                newscnlinall=[newscnlinpart1,newscnlinpart2];
                data.scan_line_number=newscnlinall;
                
               
                                           
                
                onlysinglefile_before=0; %two files were used to tget the eq2eq one.

                end
        
        else
            % case: 1st file ends BEFORE 1st Equator crossing happens.
            % Therefore, this file is not needed.
            onlysinglefile_before=0;
            disp('File not needed. Jump to next.')
            selectorbit=selectorbit+1;
            continue %jump to next iteration: skip current 1st file and use current 2nd file as 1st one in next iteration
                
        end
        
        %return
    
       
        
    end
%%    




%% set up and processing
disp('...setup and processing...')
% setup all variables needed for the processing
setup_Eq2Eq_fullFCDR_uncertproc_MHS_v2

if onlybadPRTmeasurements==1
    
    prepare_empty_file
    write_easyFCDR_orbitfile_MHS
    %return
    %write_fullFCDR_orbitfile_MHS the writing of FULL FCDR does not yet
    %work in this case! I need to put the "return" at the very end of the
    %setup script. Moreover it might be that there are still variables that
    %need to be filled with nan then.
    selectorbit=selectorbit+1; %normal increase of select orbit by one
    selectorbit=selectorbit+add_to_selectorbit; % add further increase for skipped files
    continue
end

%% evaluate measurement equation
disp('Evaluation of measurement equation... ')

measurement_equation



%% calculate uncertainties
disp('... and propagation of uncertainty ...')

uncertainty_propagation_optimized

%% quality flags
disp('...setting quality flags...')

quality_flags_setting_new


%% write EASY and FULL FCDR in netcdf files

% 
%only for sensitivity study 
% btemps7=btemps;
% value='value7'; 
% effect='radiance_of_platform';
% save(['/scratch/uni/u237/users/ihans/FIDUCEO_testdata/sensitivity_study/',effect,'/',sat,'/btemps_',value,'.mat'],'btemps7')
% 
 write_easyFCDR_orbitfile_MHS
 %write_fullFCDR_orbitfile


%return %only for sensitivity study


selectorbit=selectorbit+1; %normal increase of select orbit by one
selectorbit=selectorbit+add_to_selectorbit; % add further increase for skipped files

%return
 else
    disp('Process took more than the allowed time. Stop here.')
    toc
    return
   end 
end
    
    
    
    
    
    
    
elseif strcmp(selectinstrument,'amsub')
  %% AMSUB
% set variable "cut" for cutting pathinfo from filenames (the length of the path varies due to different satellite/ instrument names)    
    cut=25;
    
   
    %% initialising of atmlab
atmlab_init %atmlab needs to be initialized in startup file of matlab!!!

%%%%%%%%%%%%% SET UP READING L1B- and AAPP output DATA FILE %%%%%%%%%%%%%%

%% data path to index files 

% read in list of index-files.
% The indexfiles contain the path to every orbit file. They are per
% satellite and year so far.


filenames = importdata(['/scratch/uni/u237/users/ihans/indexfiles_sorted/',satsenyear,'.index-sorted']);% ".index-sorted" to use the sorted ones! You have to update the sorted ones
% from time to time (to get the most recent version, since the download on
% updating of the original indexfiles is continuously ongoing)
%filenames = importdata(['/scratch/uni/u237/data/amsu/',satsenyear,'.index']);%path to original index files





%% Reading  l1b files and Equator-to-Equator fitting


onlysinglefile_before=0; %marker to indicate that previous new file was generated of a single one (for cases where one original file has 2 ascending equator crossings). Initialize this marker with zero.

% load limits for counts, "antenna correction coeffs" and coefficient "alpha" from file
filenamestring=['coeffs_',sat,sen,'_antcorr_alpha.mat'];
load(filenamestring)

% renaming
that_file = filenames;
% initialization of vector that will contain info on failed reading of
% individual l1b files
ierr = zeros(1, numel(that_file));


% searching for first and last orbit-file of month 
monthstring=num2str(month,'%02d');

for i=1:length(that_file)
    filenamestruct{i}=cell2mat(that_file(i));
    comp(i)=strcmp(filenamestruct{i}(19:20),monthstring);
end;

startorbit=find(comp,1,'first');
endorbit=find(comp,1,'last')+1; %take also 1st file from next month to do Eq2Eq fitting
numberoforbits=endorbit-startorbit;

%startorbit=1;
% read data for the very first orbit. For every other orbit, the data1 will
% be taken from the previous data2
 err1_start=1; 
 counter_err_files=0;
while err1_start==1
    this_file_first = char(strcat('/scratch/uni/u237/data/amsu/', that_file(startorbit+counter_err_files)));  
    [hdrinfo1,data1,quality_indicator_lines1,quality_flags_0_lines1,quality_flags_1_lines1,quality_flags_2_lines1,quality_flags_3_lines1,quality_flags_lines1,err1] = read_AMSUB_allvar_noh5write(this_file_first,1);
    counter_err_files=counter_err_files+1;
    err1_start=err1; %put now the true error value into err1_start to finish the loop, as soon as no further error occurred, i.e. err1=0.
end            
startorbit=startorbit+counter_err_files-1; %subtract one since the counter is also increased in the last iteration where the file is good finally






% loop over all chosen orbits
selectorbit=startorbit;
while selectorbit<=endorbit-1   
    if toc<4000
    % clear variables EXCEPT the listed ones. These are needed for the processing of the next
    % files still.
    clearvars -except  startorbit that_file ierr cut satsenyear sat sen year selectsatellite selectinstrument ... 
        selectyear selectorbit gE gS gSAT alpha endorbit eq_scnlin_vcp2 onlysinglefile_before count_thriwct...
        count_thrdsv jump_thr threshold_earth jump_thrICTtempmean ...
        hdrinfo1 data1 quality_indicator_lines1 quality_flags_0_lines1 quality_flags_1_lines1 quality_flags_2_lines1 ...
        quality_flags_3_lines1 quality_flags_lines1 err1 ...
        hdrinfo2 data2 quality_indicator_lines2 quality_flags_0_lines2 quality_flags_1_lines2 quality_flags_2_lines2 ...
        quality_flags_3_lines2 quality_flags_lines2 err2 numberoforbits
    
    % store the previous data in_prev-variables and delete the old ones (to
    % free their names for this iteration)
        hdrinfo1_prev=hdrinfo1;
        data1_prev=data1;
        quality_indicator_lines1_prev=quality_indicator_lines1;
        quality_flags_0_lines1_prev=quality_flags_0_lines1;
        quality_flags_1_lines1_prev=quality_flags_1_lines1;
        quality_flags_2_lines1_prev=quality_flags_2_lines1;
        quality_flags_3_lines1_prev=quality_flags_3_lines1;
        quality_flags_lines1_prev=quality_flags_lines1;
        err1_prev=err1;
        
        % normal case (NOT startorbit): store the data2. 
       if selectorbit~=startorbit 
        hdrinfo2_prev=hdrinfo2;
        data2_prev=data2;
        quality_indicator_lines2_prev=quality_indicator_lines2;
        quality_flags_0_lines2_prev=quality_flags_0_lines2;
        quality_flags_1_lines2_prev=quality_flags_1_lines2;
        quality_flags_2_lines2_prev=quality_flags_2_lines2;
        quality_flags_3_lines2_prev=quality_flags_3_lines2;
        quality_flags_lines2_prev=quality_flags_lines2;
        err2_prev=err2;
       end
       
        % free the variable names 
        clear hdrinfo1 data1 quality_indicator_lines1 quality_flags_0_lines1 quality_flags_1_lines1 quality_flags_2_lines1 ...
        quality_flags_3_lines1 quality_flags_lines1 err1 ...
        hdrinfo2 data2 quality_indicator_lines2 quality_flags_0_lines2 quality_flags_1_lines2 quality_flags_2_lines2 ...
        quality_flags_3_lines2 quality_flags_lines2 err2 
        
    startline=1;
    
    
    
    % If the previously produced FCDR file was constructed from a single
    % one (i.e. onlysinglefile_before=1), then we still need to use the data of
    % the file after the second ascending (or descending resp.) equator
    % crossing. Therfore, we have to redo the iteration step on this orbit
    % (the correct reading is taken care of below): reset the orbit counter
    % to its last value.
    % 
    if onlysinglefile_before==1
        selectorbit=selectorbit-1;
        
        % in this case, put the data1 from previous iteration again into
        % data1 of this iteration.
        hdrinfo1=hdrinfo1_prev;
        data1=data1_prev;
        quality_indicator_lines1=quality_indicator_lines1_prev;
        quality_flags_0_lines1=quality_flags_0_lines1_prev;
        quality_flags_1_lines1=quality_flags_1_lines1_prev;
        quality_flags_2_lines1=quality_flags_2_lines1_prev;
        quality_flags_3_lines1=quality_flags_3_lines1_prev;
        quality_flags_lines1=quality_flags_lines1_prev;
        err1=err1_prev;
       
    elseif onlysinglefile_before==0 && selectorbit==startorbit
        % in this case, put the data1 that you read in before the
        % while-loop back into the data1 again
        hdrinfo1=hdrinfo1_prev;
        data1=data1_prev;
        quality_indicator_lines1=quality_indicator_lines1_prev;
        quality_flags_0_lines1=quality_flags_0_lines1_prev;
        quality_flags_1_lines1=quality_flags_1_lines1_prev;
        quality_flags_2_lines1=quality_flags_2_lines1_prev;
        quality_flags_3_lines1=quality_flags_3_lines1_prev;
        quality_flags_lines1=quality_flags_lines1_prev;
        err1=err1_prev;
    else
        % normal case, two files have been used, i.e. use the 2nd one now
        % as the first one.
        hdrinfo1=hdrinfo2_prev;
        data1=data2_prev;
        quality_indicator_lines1=quality_indicator_lines2_prev;
        quality_flags_0_lines1=quality_flags_0_lines2_prev;
        quality_flags_1_lines1=quality_flags_1_lines2_prev;
        quality_flags_2_lines1=quality_flags_2_lines2_prev;
        quality_flags_3_lines1=quality_flags_3_lines2_prev;
        quality_flags_lines1=quality_flags_lines2_prev;
        err1=err2_prev;
        
    end
    
    %selectorbit
    disp(['orbit ',num2str(selectorbit-startorbit+1),'/',num2str(numberoforbits)])
    disp(['orbit of year: ', num2str(selectorbit)])
    
    % get the path to the current orbit file from the list of index files
    this_file = char(strcat('/scratch/uni/u237/data/amsu/', that_file(selectorbit)));
    
    % The following if-statement makes the distinction between the normal
    % case and the very last orbit of the chosen list of orbits (the last
    % orbit cannot be handled in the Equator-to-Eqator fitting like the other
    % ones)
    if selectorbit~=endorbit
        
        decided_which_files_to_use=0;
        go_to_next_iteration=0;
        counter_files=0;
        add_to_selectorbit=0;
        
        while decided_which_files_to_use==0
            counter_files=counter_files+1;
            % get the path to the file subsequent to the current orbit file
            % from the list of filenames (indexfiles)
            this_file_2 = char(strcat('/scratch/uni/u237/data/amsu/', that_file(selectorbit+counter_files)));
            this_file_3 = char(strcat('/scratch/uni/u237/data/amsu/', that_file(selectorbit+counter_files+1)));
            
            %list_of_filenames=[this_file; this_file_2; this_file_3];
             list_of_filenames{1}=this_file;
             list_of_filenames{2}=this_file_2;
             list_of_filenames{3}=this_file_3;
            
            [skip_this_file_1, skip_this_file_2]=check_which_files_to_use(list_of_filenames{1},list_of_filenames{2},list_of_filenames{3},selectinstrument);

            %[skip_this_file_1, skip_this_file_2]=check_which_files_to_use(list_of_filenames(1,:),list_of_filenames(2,:),list_of_filenames(3,:));

                if skip_this_file_1==1
                    %first file should be skipped
                    % go to next iteration step
                    go_to_next_iteration=1;
                    break% exit this while loop to jump back to "orbit"-loop

                elseif skip_this_file_2==1
                    % the 2nd file should be skipped. Now look at file1, file 3
                    % file 4, by setting counter to next value, thus generating the
                    % filename3 now as filename2.
                    decided_which_files_to_use=0;
                    
                    add_to_selectorbit=add_to_selectorbit+1; 
                    %increase the selected orbit
                    %by the accumulated number of skipped files to get the
                    %correct orbit in the next iteration (for every skipped
                    %file need to increase orbit by one, in order to jump
                    %to the appropriate orbit in the next iteration of the
                    %while loop over the orbits: note that at the very end
                    %there is again the normal selectorbit+1)
                else
                    % both file 1 and 2 can be used normally.
                    
                    decided_which_files_to_use=1;
                end

            
        end
        
        
        % in case that the 1st file should be skipped, continue with next
        % iteration
        if go_to_next_iteration==1
            
            % read in second file since it is needed for next iteration as
            % file1
            [hdrinfo2,data2,quality_indicator_lines2,quality_flags_0_lines2,quality_flags_1_lines2,quality_flags_2_lines2,quality_flags_3_lines2,quality_flags_lines2,err2] = read_AMSUB_allvar_noh5write(this_file_2,startline);
            selectorbit=selectorbit+1;
            %set onlysinglefile_before to zero, since this file1 is skipped
            %and we do not need the prev. file to this file1 anymore
            onlysinglefile_before=0;
            disp('1st file skipped. Go to next iteration')
            continue
        end
        
        
        
        % FIXME as for MHS: how to handle inconsitent orbit sequences
        % (half, full, both, missing,...)?
        % It would be better to totally reimplement the Eq2Eq-fitting,
        % based on an external preparation of an equator-crossings database
        % or so.
        
        disp('read l1b files...')
        
        % read all variables of l1b files (current orbit plus next file)
        %
        % the current orbit got its data from the 2nd file of the
        % previous orbit.
        
        
        % read in 2nd file only
%         tic
%         [hdrinfo1,data1,quality_indicator_lines1,quality_flags_0_lines1,quality_flags_1_lines1,quality_flags_2_lines1,quality_flags_3_lines1,quality_flags_lines1,err1] = read_AMSUB_allvar_noh5write(this_file,startline);
%         toc
        [hdrinfo2,data2,quality_indicator_lines2,quality_flags_0_lines2,quality_flags_1_lines2,quality_flags_2_lines2,quality_flags_3_lines2,quality_flags_lines2,err2] = read_AMSUB_allvar_noh5write(this_file_2,startline);
    
%        check for reading errors
        if err1==1 
            disp('Error while reading L1b file.')
            % set flag that this orbit file could not be read.
            ierr(selectorbit)=1;
            % go to next iteration step
            selectorbit=selectorbit+1;
            continue
        elseif  err2==1
            disp('Error while reading L1b file.')
            % set flag that this orbit file could not be read.
            ierr(selectorbit+1)=1;
            % go to next iteration step (this next step will re-read the corrupt file and again cause this error. But this time then for err1.)
            selectorbit=selectorbit+1;
            continue
        end
        err=max([err1, err2]);
                
        
        %  We now do the Equator to Equator fitting. All
        % following code until the "set up and processing" is dedicated to
        % this Eq2Eq fitting. It captures the various cases of where in the
        % file the equator crossing happens or whether only a single file
        % is needed to get the correct format and how to proceed after this
        % case.            
                    
     
                    
        disp('Determine equator crossings...')
         % get Equator crossings
        [eq_scnlin_vcp1,eq_scnlin_vcp2,onlysinglefile,no_crossing_found]=get_equator_crossing_l1b(data1,data2,onlysinglefile_before,sat);
        
        % WATCH OUT! this is only an intermediate step to force the code to
        % preceede. This case should be handled gracefully in the final
        % version!
        if no_crossing_found==1
            selectorbit=selectorbit+1;
            continue
        end
        
        % change the start of the to-be-processed file to 3 lines before,
        % and the end 3 lines after the actual crossing. This is needed to
        % get the correct averaging also at the very first stored line
        % (which is the actual eq_crossing).
       eq_scnlin_vcp1=eq_scnlin_vcp1-3;
       eq_scnlin_vcp2=eq_scnlin_vcp2+3;
       
       % for cases where the first Eq crossing happens at the very first
       % scanline, we have to start there, we cannot use the 3 lines
       % before. The same for 2nd Eq-crossing at the very last line:
       
       if eq_scnlin_vcp1<=0
            eq_scnlin_vcp1=1;
            
       elseif onlysinglefile==1 && eq_scnlin_vcp2>= length(data1.scan_line_number)
            eq_scnlin_vcp2=length(data1.scan_line_number);
            
       elseif onlysinglefile==0 && eq_scnlin_vcp2>= length(data2.scan_line_number)
           eq_scnlin_vcp2=length(data2.scan_line_number);
           
       end
       
        % Assure cutting of overlap of subsequent files:
        % "Cut ending of file"
        % Get last scanline of first file that is NOT contained in second
        % file, i.e.
        %find the scanlines (times!) that are also contained in the next
        %file. Then take the line before the first found one. If none is
        %found, there is no overlap (isempty(newlines)).
        newlines=find(ismembertol(double(data1.scan_line_UTC_time), double(data2.scan_line_UTC_time),1,'DataScale',1));
        if isempty(newlines) %i.e. no overlap of subsequent files!
            
            endrecline=length(data1.scan_line_UTC_time);
        else
            endrecline=newlines(1)-1;
        end
        
        
        % Reshaping to Eq to Eq files:
        % 1. if-statement: is there a datagap larger than 1 orbit?
        %   YES: only use the first file from 1st Eqcrossing to end
        %   NO: continue with else-if statement
        %  else-if-statement: 1st file ends AFTER 1st Equator crossing?
        %   YES: go ahead with Eq2Eq fitting:
        %       2. if-statement: Is only one file needed for Eq2Eq fitting?
        %                 YES: Reshape file1 to Eq2Eq. Then go on with
        %                 next iteration step.
        %                 NO: Concatenate file1 and file2 to get Eq2Eq
        %                 file.
        %   NO: this current file is not needed. Go to next orbit.
        % 
        % This is repeated in every iteration step of the while-loop on
        % "selectorbit". The Last Orbit gets different treatment. See
        % else-statement of "if selectorbit~=endorbit".

               
        if endrecline>eq_scnlin_vcp1  %check whether eq.crossing of 1st file comes before next file starts. If so, then do the reshaping. If not: go to next orbit, i.e. skip this 1st file and 2nd file becomes first.
        
                disp('Reshape file to equator to equator file...')
                % concatenate L1b files to get Equator To Equator files

                onlysinglefile
                
                % check for data gaps larger than one orbit. In this case
                % only one file is needed.
                datagap_detected=0;
                check_for_datagap 

                
                
                if datagap_detected==1 && onlysinglefile==0
                    
                    if onlysinglefile_before==1
                        % the first file has been used already.
                        % Set back onlysinglefile_before=0  and go to next iteration. 
                        disp('Data Gap. But first file has been used already. Go to next iteration.')
                        selectorbit=selectorbit+1;
                        onlysinglefile_before=0 ;
                        continue
                    end
                    
                    
                    %if a large data gap has been detected, we only use the
                    %first file. The second one is kept as first one in
                    %the next iteration.
                    end_of_1stfile=double(data1.scan_line_number(end));
                    
                    f = fieldnames(data1);
                    for k=1:numel(f) %loop over all fieldnames
                        tmp1=data1.(f{k});
                        tmp1part=tmp1(:,eq_scnlin_vcp1:end_of_1stfile); %extract the part from 1rst equator crossing to 2nd one


                        data.(f{k}) =tmp1part; % write part of orbit into new data variable
                    end

                    % the other variables
                        quality_indicator_lines=quality_indicator_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_0_lines=quality_flags_0_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_1_lines=quality_flags_1_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_2_lines=quality_flags_2_lines1(eq_scnlin_vcp1:end_of_1stfile,:);
                        quality_flags_3_lines=quality_flags_3_lines1(eq_scnlin_vcp1:end_of_1stfile,:);

                        for i=1:5
                        quality_flags_lines1_struct{i}=squeeze(quality_flags_lines1(i,:,:));
                        quality_flags_lines{i}=quality_flags_lines1_struct{i}(eq_scnlin_vcp1:end_of_1stfile,:);
                        end

                        %for header (which has no scanline-dimension): keep first header
                        hdrinfo=hdrinfo1;
                        
                        % build new scanline vector starting from 1,
                        % preserving jumps of scanlines that need to be
                        % treated by fill_missing_scanlines
                        data.orig_scnlinnum=data.scan_line_number; %save original scanline numbers (start is not 1 but at equator-crossing-scanline)
                        data.scan_line_number=data.orig_scnlinnum(1:end)-data.orig_scnlinnum(1)+1; %create vector starting at 1

                        
                        
                        

                elseif onlysinglefile==1

                        f = fieldnames(data1);
                    for k=1:numel(f) %loop over all fieldnames
                        tmp1=data1.(f{k});
                        tmp1part=tmp1(:,eq_scnlin_vcp1:eq_scnlin_vcp2-1); %extract the part from 1rst equator crossing to 2nd one


                        data.(f{k}) =tmp1part; % write part of orbit into new data variable
                    end

                    % the other variables
                        quality_indicator_lines=quality_indicator_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_0_lines=quality_flags_0_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_1_lines=quality_flags_1_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_2_lines=quality_flags_2_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        quality_flags_3_lines=quality_flags_3_lines1(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);

                        for i=1:5
                        quality_flags_lines1_struct{i}=squeeze(quality_flags_lines1(i,:,:));
                        quality_flags_lines{i}=quality_flags_lines1_struct{i}(eq_scnlin_vcp1:eq_scnlin_vcp2-1,:);
                        end

                        %for header (which has no scanline-dimension): keep first header
                        hdrinfo=hdrinfo1;
                        
                        % build new scanline vector starting from 1,
                        % preserving jumps of scanlines that need to be
                        % treated by fill_missing_scanlines
                        data.orig_scnlinnum=data.scan_line_number; %save original scanline numbers (start is not 1 but at equator-crossing-scanline)
                        data.scan_line_number=data.orig_scnlinnum(1:end)-data.orig_scnlinnum(1)+1; %create vector starting at 1

                        
                       
                        
                        
                        % Here, only one file was used to create the
                        % equator2equator file (since it already had 2 ascending
                        % crossings). This means, that for the next iteration, we
                        % have to reopen the current original file again to use its
                        % rest, i.e. only the data after the second crossing! Doing
                        % it normally would yield to an endless loop since the
                        % get_equator would always find the first and second
                        % crossing again...
                        % Therefore we set a marker that indicates that only one
                        % file has been used in the new file:

                        onlysinglefile_before=1;


                else
                        % NORMAL CASE: 2 files needed to get one Eq2Eq file
                    
                        f = fieldnames(data1);
                    for k=1:numel(f) %loop over all fieldnames
                        tmp1=data1.(f{k});
                        tmp1part=tmp1(:,eq_scnlin_vcp1:endrecline); %extract the part from Equator to end of first datafile, per fieldname; endrecline denotes the last scan line that is NOT contained in the next file.

                        tmp2=data2.(f{k});
                        tmp2part=tmp2(:,1:eq_scnlin_vcp2-1); %extract the part from start to Equator of second datafile, per fieldname

                        data.(f{k}) = horzcat(tmp1part, tmp2part); % concatenate both parts to get new data variable.
                    end



                % the other variables
                quality_indicator_lines=vertcat(quality_indicator_lines1(eq_scnlin_vcp1:endrecline,:), quality_indicator_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_0_lines=vertcat(quality_flags_0_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_0_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_1_lines=vertcat(quality_flags_1_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_1_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_2_lines=vertcat(quality_flags_2_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_2_lines2(1:eq_scnlin_vcp2-1,:));
                quality_flags_3_lines=vertcat(quality_flags_3_lines1(eq_scnlin_vcp1:endrecline,:), quality_flags_3_lines2(1:eq_scnlin_vcp2-1,:));

                for i=1:5
                    quality_flags_lines1_struct{i}=squeeze(quality_flags_lines1(i,:,:));
                    quality_flags_lines2_struct{i}=squeeze(quality_flags_lines2(i,:,:));
                    quality_flags_lines{i}=vertcat(quality_flags_lines1_struct{i}(eq_scnlin_vcp1:endrecline,:), quality_flags_lines2_struct{i}(1:eq_scnlin_vcp2-1,:));
                end
                
                
                % HEADER
                %for header (which has no scanline-dimension): keep first header
                hdrinfo=hdrinfo1;
                %but add second filename to hdrinfo.
                hdrinfo.dataset_name={hdrinfo1.dataset_name, hdrinfo2.dataset_name};

                
                % SCANLINE vector
                
                % save original scanline numbers including discontinuities
                % due to concatenation of 2 files: e.g. starting at 534
                % going up to 2101, then from 2nd file scanline 1 to 1440
                data.orig_scnlinnum=data.scan_line_number; 
                
                % Build new scanline vector from both files, but preserving
                % any initial jumps in the individual files.
                %element at which 1st file ends
                endof1stfile=length([eq_scnlin_vcp1:endrecline]);
                %part1 of new scanlines going from 1 until end of 1st file
                newscnlinpart1=data.orig_scnlinnum(1:endof1stfile)-data.orig_scnlinnum(1)+1;
                % part2 of new scanlines starting from 2nd file on: take
                % original scanlinenumbers for the file and subtract the
                % scanlinenumber of the 1st line of the 2nd file and add 1
                % to start at 1. Then add the "endof1stfile" to make the
                % link to the 1st part.
                newscnlinpart2=data.orig_scnlinnum(endof1stfile+1:end)-data.orig_scnlinnum(endof1stfile+1)+1+endof1stfile; 
                newscnlinall=[newscnlinpart1,newscnlinpart2];
                data.scan_line_number=newscnlinall;
                
               
                                           
                
                onlysinglefile_before=0; %two files were used to tget the eq2eq one.

                end
        
        else
            % case: 1st file ends BEFORE 1st Equator crossing happens.
            % Therefore, this file is not needed.
            onlysinglefile_before=0;
            disp('File not needed. Jump to next.')
            selectorbit=selectorbit+1;
            continue %jump to next iteration: skip current 1st file and use current 2nd file as 1st one in next iteration
                
        end
        
        %return
    
        
    end
%%    




%% set up and processing
disp('...setup and processing...')
% setup all variables needed for the processing
setup_Eq2Eq_fullFCDR_uncertproc_AMSUB_v2

if onlybadPRTmeasurements==1
    
    prepare_empty_file
    write_easyFCDR_orbitfile_AMSUB
    %return
    %write_fullFCDR_orbitfile_AMSUB the writing of FULL FCDR does not yet
    %work in this case! I need to put the "return" at the very end of the
    %setup script. Moreover it might be that there are still variables that
    %need to be filled with nan then.
    selectorbit=selectorbit+1; %normal increase of select orbit by one
    selectorbit=selectorbit+add_to_selectorbit; % add further increase for skipped files
    continue
end

%% evaluate measurement equation
disp('Evaluation of measurement equation... ')

measurement_equation



%% calculate uncertainties
disp('... and propagation of uncertainty ...')

uncertainty_propagation_optimized

%% quality flags
disp('...setting quality flags...')

quality_flags_setting_new
 

%% write EASY and FULL FCDR in netcdf files

% 
%only for sensitivity study 
% btemps7=btemps;
% value='value7'; 
% effect='radiance_of_platform';
% save(['/scratch/uni/u237/users/ihans/FIDUCEO_testdata/sensitivity_study/',effect,'/',sat,'/btemps_',value,'.mat'],'btemps7')
% 
 write_easyFCDR_orbitfile_AMSUB
 %write_fullFCDR_orbitfile_AMSUB


%return %only for sensitivity study


selectorbit=selectorbit+1; %normal increase of select orbit by one
selectorbit=selectorbit+add_to_selectorbit; % add further increase for skipped files

%return
    else
    disp('Process took more than the allowed time. Stop here.')
    toc
    return
   end 

end
    
    
    
 toc  
end