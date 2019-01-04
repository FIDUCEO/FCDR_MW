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


% remove duplicated data


% look for reappearances of the endtime of each file:
nfiles=length(file_list);
files_to_remove=[];
scanlines_to_remove=[];

for k=1:nfiles
disp(['File ',num2str(k),' of ',num2str(nfiles)])
    range_kfile=find(monthly_data_record.fileID==k);
    
    if ~isempty(range_kfile)
            index_last_line_of_file=find(monthly_data_record.fileID==k,1,'last');


            % Find reappearances of last line of file

            %try out  only on
            %range:
            %current file-end +10 files further 
            range_start=index_last_line_of_file;
            range_nextfiles=find(ismember(monthly_data_record.fileID,[k:k+10])); %tenth next file
            range_end=range_nextfiles(end);
            offset_index=length(monthly_data_record.time_EpochSecond(1:range_start-1));
            % find reappearances of last line of file (within the next 10 files)
            reappearances_scnlin=find(ismembertol(monthly_data_record.time_EpochSecond(range_start:range_end),monthly_data_record.time_EpochSecond(index_last_line_of_file),1,'DataScale',1));
            % add offset_index to get the correct linenumber wrt the full
            % monthly_data_record (not only within range)
            reappearances_scnlin=reappearances_scnlin+offset_index;
            % remove the original line (it is always also found "as duplicate")
            reappearances_scnlin=reappearances_scnlin(reappearances_scnlin~=index_last_line_of_file);

            if isempty(reappearances_scnlin)

                % Maybe the last line does not reappear because of jumps. Therefore
                % check whether the first line in the next file already appeared:

                % Find reapperances of first line of next file (in the current file)
                index_first_line_of_nextfile=find(monthly_data_record.fileID==(k+1),1,'first');
                index_first_line_of_kfile=find(monthly_data_record.fileID==k,1,'first');
                offset_index_kfile=length(monthly_data_record.time_EpochSecond(1:index_first_line_of_kfile-1));
                reappearances_first_scnlin=find(ismembertol(monthly_data_record.time_EpochSecond(range_kfile),monthly_data_record.time_EpochSecond(index_first_line_of_nextfile),1,'DataScale',1));
                reappearances_first_scnlin=reappearances_first_scnlin+offset_index_kfile;

                if isempty(reappearances_first_scnlin)
                % There are no duplicates. nothing needs to be done. Proceed with
                % next file.
                else
                    % The first scanline of the next file was already in k-file.
                    % Hence, the part from
                    % data(reappearances_first_scnlin:index_first_line_of_nextfile-1)
                    % must be deleted. 
                    % remove all lines between the endline of the file k and next_file_start_line
                    f = fieldnames(monthly_data_record);
                    for ifield=1:numel(f)
                        tmp=monthly_data_record.(f{ifield});
                        tmp(:,reappearances_first_scnlin:index_first_line_of_nextfile-1)=[];
                        monthly_data_record.(f{ifield})=tmp;
                    end
                end


            else
                % check whether found reappearances are (partially) from the same
                % file:
                % get fileID for reappearing times
                fileID_for_reapp_lines=monthly_data_record.fileID(reappearances_scnlin);
                % count how often the same fileID appears: numberofApp
                [fileIDs,numberofApp,indicesIn_fileID_for_reapp_lines]=RunLength_M(fileID_for_reapp_lines);
                % Take the last appearance of the same file (for every reappear time)
                last_reappearance_line_perfile=reappearances_scnlin(numberofApp);

                % Find the file with max. length corresponding to the found duplicate times.
                [maxval,maxind]=max(monthly_data_record.filelength(last_reappearance_line_perfile));
                % need to account for the fact that time might appear twice in same
                % file!!FIXME
                % The found maximumindex indicates the one duplicate belonging to
                % the longest record. Add 1 to the actual line to get the correct
                % start line of the next file.
                next_file_start_line=last_reappearance_line_perfile(maxind)+1;
                file_to_use=monthly_data_record.fileID(last_reappearance_line_perfile(maxind));

                % identify all entries in monthly-record that belong to a fileID that
                % have duplicate time but are not the longest file containing this
                % duplicate time. 
                line_withdupl=last_reappearance_line_perfile(last_reappearance_line_perfile~=last_reappearance_line_perfile(maxind));
                if ~isempty(line_withdupl)
                    files_to_remove(k,:)=monthly_data_record.fileID(line_withdupl);
                end

                % remove all lines between the endline of the file k and next_file_start_line
%                 f = fieldnames(monthly_data_record);
%                 for ifield=1:numel(f)
% %                     tmp=monthly_data_record.(f{ifield});
% %                     tmp(:,index_last_line_of_file+1:next_file_start_line-1)=[];
% %                     monthly_data_record.(f{ifield})=tmp;
% %                     clear tmp
%                     monthly_data_record.(f{ifield})=[monthly_data_record.(f{ifield})(:,1:index_last_line_of_file) monthly_data_record.(f{ifield})(:,next_file_start_line:end)];
%                 end
                
                % different approach to delete scanlines:
                % collect scanlines that should be removed, and always
                % append the ones to be removed from this itertaion to the
                % last. Idea: remove the whole set of collected scan lines
                % outside the loop over the files.
                scanlinestoremove_thisfile=[index_last_line_of_file+1 : next_file_start_line-1];
                scanlines_to_remove=[scanlines_to_remove scanlinestoremove_thisfile];
                
            end
            
    else     
        % this file could not be read and does therefore not appear in
        % monthly_data_record
        % go to next file.
            
    end
end

% remove all scanlines that have been identified for deletion
% This needs to be done BEFORE the removing of complete files (see below)
f = fieldnames(monthly_data_record);
for ifield=1:numel(f)
    tmp=monthly_data_record.(f{ifield});
    tmp(:,scanlines_to_remove)=[];
    monthly_data_record.(f{ifield})=tmp;

end

% remove all files that had duplicate times but were not the longest ones
% (which we will use)
indicator_for_lines_from_files_to_remove=ismember(monthly_data_record.fileID,files_to_remove(:));
f = fieldnames(monthly_data_record);
for ifield=1:numel(f)
    tmp=monthly_data_record.(f{ifield});
    tmp(:,indicator_for_lines_from_files_to_remove)=[];
    monthly_data_record.(f{ifield})=tmp;

end
