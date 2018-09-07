


% chop monthly data into  EQ2EQ file

function [data,hdrinfo]=chop_data_EQ2EQ(crossings_and_gap,nEQfile,monthly_data_header,monthly_data_record,f,file_list)
% chop monthly data into EQ2EQ file
% But keeping the 3 lines before and after! Therfore: offset_1=3=offset_2
% for eqcrossings. And offset_1=0  and offset_2=1 for datagaps, so that
% dataset ends at start of gap and the new one will start just after end of
% gap

offset_1=crossings_and_gap(2,nEQfile);
offset_2=crossings_and_gap(3,nEQfile+1);

for ifield=1:numel(f)
    tmp=monthly_data_record.(f{ifield});
    data.(f{ifield})=tmp(:,crossings_and_gap(1,nEQfile)-offset_1:crossings_and_gap(1,nEQfile+1)-1+offset_2); %-1
end
% save header info (taken from 1st used file)
filesunique=unique(monthly_data_record.fileID);%list of unique fileIDs
hdrinfo=monthly_data_header(find(filesunique==monthly_data_record.fileID(crossings_and_gap(1,nEQfile))));



% create vector containing the fileID (position in file_list) per line
fileID_used=monthly_data_record.fileID(crossings_and_gap(1,nEQfile)-offset_1:crossings_and_gap(1,nEQfile+1)-1+offset_2);

% Put filenames of used files into header-info
hdrinfo.dataset_name=file_list(unique(fileID_used));


% Save original scanline-numbering
data.orig_scnlinnum=double(data.scan_line_number); %save original scanline numbers (start is not 1 but at equator-crossing-scanline)
% Create new scanline-number-vector starting at 1
data.scan_line_number=[1:length(data.orig_scnlinnum)];

% create vector containing an identifier for the used file
data.map_line2l1bfile=fileID_used-fileID_used(1); %identifier is zero for first file in outputfile attribute "source"

%%%%%%%%%%%%%%%%%%%%%%