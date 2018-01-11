% FIXME: comparing starttimes does not work if change of day!


% check 2 files for same start/end time 
function [skip_this_file, skip_this_file_next]=check_which_files_to_use(filename1,filename2,filename3,selectinstrument)
skip_this_file=0;
skip_this_file_next=0;
% 
%  filename1=this_file;
%  filename2=this_file_2;
%  filename3=this_file_3;

filename_which{1}=filename1;
filename_which{2}=filename2;
filename_which{3}=filename3;

% check on files 1 and 2


if strcmp(selectinstrument,'amsub')
% starttime
pos_ofS{1}=strfind(filename1,'S');
pos_starttime{1}=pos_ofS{1}(end);
starttime_full{1}=filename1(pos_starttime{1}+1:pos_starttime{1}+4);

pos_ofS{2}=strfind(filename2,'S');
pos_starttime{2}=pos_ofS{2}(end);
starttime_full{2}=filename2(pos_starttime{2}+1:pos_starttime{2}+4);

pos_ofS{3}=strfind(filename3,'S');
pos_starttime{3}=pos_ofS{3}(end);
starttime_full{3}=filename3(pos_starttime{3}+1:pos_starttime{3}+4);

% endtime
pos_ofE{1}=strfind(filename1,'E');
pos_endtime{1}=pos_ofE{1}(end);
endtime_full{1}=filename1(pos_endtime{1}+1:pos_endtime{1}+4);

pos_ofE{2}=strfind(filename2,'E');
pos_endtime{2}=pos_ofE{2}(end);
endtime_full{2}=filename2(pos_endtime{2}+1:pos_endtime{2}+4);

pos_ofE{3}=strfind(filename3,'E');
pos_endtime{3}=pos_ofE{3}(end);
endtime_full{3}=filename3(pos_endtime{3}+1:pos_endtime{3}+4);

elseif strcmp(selectinstrument,'mhs')
% starttime
pos_ofS{1}=strfind(filename1,'S');
pos_starttime{1}=pos_ofS{1}(4);
starttime_full{1}=filename1(pos_starttime{1}+1:pos_starttime{1}+4);

pos_ofS{2}=strfind(filename2,'S');
pos_starttime{2}=pos_ofS{2}(4);
starttime_full{2}=filename2(pos_starttime{2}+1:pos_starttime{2}+4);

pos_ofS{3}=strfind(filename3,'S');
pos_starttime{3}=pos_ofS{3}(4);
starttime_full{3}=filename3(pos_starttime{3}+1:pos_starttime{3}+4);

% endtime
pos_ofE{1}=strfind(filename1,'E');
pos_endtime{1}=pos_ofE{1}(end);
endtime_full{1}=filename1(pos_endtime{1}+1:pos_endtime{1}+4);

pos_ofE{2}=strfind(filename2,'E');
pos_endtime{2}=pos_ofE{2}(end);
endtime_full{2}=filename2(pos_endtime{2}+1:pos_endtime{2}+4);

pos_ofE{3}=strfind(filename3,'E');
pos_endtime{3}=pos_ofE{3}(end);
endtime_full{3}=filename3(pos_endtime{3}+1:pos_endtime{3}+4);
end

% check for same starttime

if strcmp(starttime_full{1},starttime_full{2})
    %the start times ARE EQUAL
    % ask whether also endtimes are equal
    
    if strcmp(endtime_full{1},endtime_full{2})
        %the end times ARE EQUAL
        %--> it is the same time range. 
        % We only need the second file. I.e. simply go one iteration
        % further.
        
        %this output parameter forces the generate_FCDR_routine to continue
        %with the next iteration step.
        skip_this_file=1; 
        
    else
        % the end time ARE DIFFERENT
        % --> take the longer file for processing.
        
        % since the filenames are sorted by time, the longer one is always
        % the later one (since startime equal and earlier endtime is
        % liested before later endtime). Thereofre, in this case we need
        % the second one (since it is the longer on). To achieve this, we
        % simply go to next iteration.
        
        %this output parameter forces the generate_FCDR_routine to continue
        %with the next iteration step.
        skip_this_file=1;
        
        %starttimes ae the same. Check which one is the larger enddtime:
%         [~,maxloc]=max([str2num(endtime_full{1}) str2num(endtime_full{2})]);
%         
%         filename_to_use{1}=filename_which{maxloc};
        
    end
    
    
    
else
    %the start times ARE DIFFERENT
    
    % ask whether endtimes are equal
    
    if strcmp(endtime_full{1},endtime_full{2})
        % end times are EQUAL . startimes were not equal, i.e. the second
        % file is fully contained in the first one. Hence, we only use the
        % first one, skip the second one and check for usability of the
        % third one.
        
        %this output parameter forces the generate_FCDR_routine to do the
        %check_which_files_to_use again, this time on file 1 and file3
        %(i.e. selectorbit+2). Nothe that in this case, we set
        %selectorbit=selectorbit+2; to get the correct next iteration (for
        %file 3 and 4), if file3 could be used normally.
        skip_this_file_next=1;
        disp('case1')
    else
        % the end time ARE DIFFERENT
        
        % check whether the 2nd endtime is SMALLER than its corresponding starttime. In
        % this case there is a change of day, e.g. 2345 to 0115. In this case add
        % 2400 to the endtime: 2345 2515
        
            if str2num(endtime_full{2}) < str2num(starttime_full{2})
                endtime_full{2}=num2str(str2num(endtime_full{2})+2400);
            end
        
        
        
        % check whether startime1<starttime2<=endtime1<endtime2 OR
        % startime1<endtime1<=starttime2<endtime2, both cases ask for normal
        % processing
        %put times into vector of numbers, to make comparison possible
        starttimes=str2num([starttime_full{1}; starttime_full{2}; starttime_full{3}]);
        endtimes=str2num([endtime_full{1}; endtime_full{2}; endtime_full{3}]);
        % if this is not the case, then  the second file is  short
        % and contained in the first file. In this case: skip the second
        % file and check, whether third file is usable.
        
        

        
        if starttimes(2)<=endtimes(1)&& endtimes(1)<endtimes(2) || endtimes(1)<=starttimes(2) && starttimes(2)<endtimes(2) || endtimes(1)<starttimes(2)+2400 && starttimes(2)<endtimes(2)
             % the third statement refers to the case that there is a change
            % of day from one file to the next. Probably this will coincide
            % with a data gap (if one file fully belongs to one day and the
            % nest file belongs to the next) 
            
            % check the third file: is longer than the 2nd one?
            % only possibility: same starttime as 2nd but later endtime
            % (earlier starttime and same endttime not possible! in this
            % case the 3rd file would be listed before the 2nd!)
            
            % check whether the 3rd endtime is SMALLER than its corresponding starttime. In
            % this case there is a change of day within the file, e.g. 2345 to 0115. In this case add
            % 2400 to the endtime: 2345 2515
        
            if str2num(endtime_full{3}) < str2num(starttime_full{3})
                endtime_full{3}=num2str(str2num(endtime_full{3})+2400);
                endtimes(3)=str2num(endtime_full{3}); %put new endtime into endtimes variable again
            end
            
            %check whether the second file is from the next day: If so,
            %there is a data gap. But try normal processing.
            if endtimes(1)<starttimes(2)+2400
                endtime_full{2}=num2str(str2num(endtime_full{2})+2400);
                endtimes(2)=str2num(endtime_full{2}); %put new endtime into endtimes variable again
                starttime_full{2}=num2str(str2num(starttime_full{2})+2400);
                starttimes(2)=str2num(starttime_full{2}); %put new endtime into endtimes variable again
            
            end
            
            
            if starttimes(2)==starttimes(3) && endtimes(2)<endtimes(3)
                % 3rd file has same starttime as 2nd but is longer! use 3rd
                % file instead of second. I.e. the second file is  short
                % and fully contained in the third file
                % Hence, we only use the third one, skip the second one.
                
                
                %this output parameter forces the generate_FCDR_routine to do the
                %check_which_files_to_use again, this time on file 1 and file3
                %(i.e. selectorbit+2). Note that in this case, we set
                %selectorbit=selectorbit+2; to get the correct next iteration (for
                %file 3 and 4), if file3 could be used normally. 
               
            skip_this_file_next=1;
            disp('case2')
            
            elseif  starttimes(3)< endtimes(1) && endtimes(2)<endtimes(3)
                % in this case, the second file is not needed since the
                % third file covers the whole range.
                % Use third file instead of second.
                skip_this_file_next=1;
                disp('case2A')
            else
                
                
                
                % the third file is NOT a longer version of the 2nd.
                % Therefore, execute normal processing on file 1 and 2.
                % File 3 is then checked as next file2 in next iteration.
                
                % normal processing! Covers the cases with and without
                % overlap.
                % Use file 1 and file 2. output values of this function are
                % zero
                
            end
            
        
             
        
         
        else
            %the second file is  short and fully contained in the first file
            % Hence, we only use the first one, skip the second one and
            % check for usability of the third one.
            
            %this output parameter forces the generate_FCDR_routine to do the
            %check_which_files_to_use again, this time on file 1 and file3
            %(i.e. selectorbit+2). Note that in this case, we set
            %selectorbit=selectorbit+2; to get the correct next iteration (for
            %file 3 and 4), if file3 could be used normally.
            skip_this_file_next=1;
            disp('case3')
            
        end
        
        
        
        
        
    end
    
    
    
end