%% MW-Level1b-read for given target and time period, function for different MW sounder instruments and satellites
% the function gives as output the concatenated contents of the level1b
% files for the chosen month, sensor and satellite.


function [monthly_data_record,monthly_data_header,file_list] = MW_l1b_read_monthly(sat,sen,year,month)
persistent D
if isempty(D)
    disp('Defining datasets...')
    define_datasets;
    datasets_config;
end
D = datasets;

% check which sensor has been chosen and find corresponding data
if strcmp(sen,'mhs')
    [~, mw_paths] = D.mhs.find_granules_for_period( [year month 1], [year month eomday(year,month)], sat);
    if isempty(mw_paths)
        monthly_data_record = []; %Empty Output for no available data
        monthly_data_header = []; %Empty Output for no available data
        disp(['No files for satellite in month:',char(10),sat,'/',num2str(year),'/',num2str(month)])
        return
    end
    
elseif strcmp(sen,'amsub')
        [~, mw_paths] = D.amsub.find_granules_for_period( [year month 1], [year month eomday(year,month)], sat);
    if isempty(mw_paths)
        monthly_data_record = []; %Empty Output for no available data
        monthly_data_header = []; %Empty Output for no available data
        disp(['No files for satellite in month:',char(10),sat,'/',num2str(year),'/',num2str(month)])
        return
    end
    
elseif strcmp(sen,'ssmt2')
        [~, mw_paths] = D.ssmt2_noaaclass.find_granules_for_period( [year month 1], [year month eomday(year,month)], sat);
    if isempty(mw_paths)
        monthly_data_record = []; %Empty Output for no available data
        monthly_data_header = []; %Empty Output for no available data
        disp(['No files for satellite in month:',char(10),sat,'/',num2str(year),'/',num2str(month)])
        return
    end
    
else
    disp(['MW_l1b_read_monthly: No valid choice of sensor. This routine does not work for your chosen sensor ',sen])
    return
end

%Check for duplicated files by comparing gran_start_time
%in filename with last file in loop

dupl_ind = dupl_file_ind(mw_paths);
%List of not duplicated files
file_list = mw_paths(dupl_ind == 0);
%Preallocation for structure with different files of day
orbitdata_record= cell(1,length(file_list));
orbitdata_header= cell(1,length(file_list));


for ifile = 1:length(file_list)%length(file_list)
    
    %Loop over all files during one day and save filedata to
    %daily_data_struc
    %Exceptions, files to leave out, which cause problems
    if strcmp(file_list{ifile},...
            '/scratch/uni/u237/data/mhs/metopb_mhs_2015/11/10/15446153.NSS.MHSX.M1.D15314.S0448.E0449.B1631717.GC.gz') == 1
        continue
    end
    
    % read only every 10th orbit
    %Display for progress view
    if mod(ifile,1) == 0
        disp(file_list{ifile})
    %end
   
    try
        [mw_file_data_header, mw_file_data_record] = satreaders.poes_radiometer_level1b( file_list{ifile} );
    catch ME
        switch ME.identifier
            case {'MATLAB:load:couldNotReadFile', 'atmlab:invalid_data',...
                    'atmlab:SatDataset:cannotread', 'atmlab:atovs_get_l1c:zamsu2l1c'}
                disp(['Warning: file ', num2str(ifile), ' could not be read.' ])
                continue
            otherwise
                ME.rethrow();
        end
    end
%     %Compare new file data with previous file data and look for
%     %duplicates, which will be eliminated
%     prev_file_ind = ifile-1;
%     if prev_file_ind > 0 %Not for first file in list
%         %Removal of duplicates between two appending files
%         mw_file_data = remove_dupl(sen,mw_file_data_prev,mw_file_data);
%     end

        
        orbitdata_record{ifile}=mw_file_data_record;
        orbitdata_header{ifile}=mw_file_data_header;
        % add auxiliary info needed for removing of duplicates
        orbitdata_record{ifile}.fileID=double(ifile).*ones(1,mw_file_data_header.nlines);
        orbitdata_record{ifile}.filelength=double(mw_file_data_header.nlines).*ones(1,mw_file_data_header.nlines);
        

    end
end

%Catenate all the daily data
monthly_data_record_sep=cat(1,orbitdata_record{:});
monthly_data_header=cat(1,orbitdata_header{:});

% reshape the structure with all monthly data to a vector, per
% field
f = fieldnames(monthly_data_record_sep);
for k=1:numel(f) %loop over all fieldnames
    monthly_data_record.(f{k})=[monthly_data_record_sep.(f{k})];  % produce comma separated list
end

%%%%%%%%%% Convert time to seconds since 1970
vectordate=datevec(doy2date(double(monthly_data_record.scan_line_day_of_year),double(monthly_data_record.scan_line_year)));
[vectordate(:,4),vectordate(:,5),vectordate(:,6)]=mills2hmsmill(double(monthly_data_record.scan_line_UTC_time));

InputDate=datenum(vectordate);
UnixOrigin=datenum('19700101 000000','yyyymmdd HHMMSS');

monthly_data_record.time_EpochSecond=(round((InputDate-UnixOrigin)*86400)).';


% now, monthly_data_record has the same fields as the original data-record.
% Each field's contents are concatenated for the whole month.



end


function dupl_ind = dupl_file_ind(mw_paths)
dupl_ind = zeros(length(mw_paths),1);
time_expr = 'S(?<time>\d{4})';
    for ipath = 1:length(mw_paths)

        new_filepath = mw_paths{ipath};
        time_expr_new = regexp(new_filepath,time_expr,'names');
        if ipath > 1 && strcmp(time_expr_prev.time,time_expr_new.time) == 1
            dupl_ind(ipath) = 1;
        end
        time_expr_prev = time_expr_new;
    end
end