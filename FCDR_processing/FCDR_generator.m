


% FCDR generator

function FCDR_generator(sat,sen,year,chosen_month)

% Choose satellite, sensor, year and month
% sat='noaa18';
% sen='mhs';
% year=2014;
% chosen_month=11;



selectinstrument=sen;
selectsatellite=sat;
selectyear=year;
satsenyear=strcat(selectsatellite,'_',selectinstrument,'_',num2str(selectyear));

%% Read all level 1b data for this month
disp(['Read all data for month ',num2str(chosen_month),'...'])
[monthly_data_record,monthly_data_header,file_list] = MW_l1b_read_monthly(sat,sen,year,chosen_month);


%% Remove duplicate date (according to time)
disp('Remove duplicate data...')
remove_duplicated_l1bdata

%% Prepare start and end lines for each file
% Determine Equator crossings
disp('Determine equator crossings...')
equator_crossings=determine_EQcrossings(sat,sen,monthly_data_record);

% Determine data gaps larger than 1/2 orbit (to get start/ end of file correct in this case)
scnlin_before_datagap=determine_data_gaps(sat,sen,monthly_data_record);

% Combine equator crossings and "scanlines before found gaps" 
crossings_and_gap_withoffsets=[equator_crossings scnlin_before_datagap; 3*ones(1,length(equator_crossings)) -1*ones(1,length(scnlin_before_datagap)) ; 3*ones(1,length(equator_crossings)) zeros(1,length(scnlin_before_datagap)) ];

% Combine equator crossings and scanlines before found gaps
crossings_and_gap=sortrows(crossings_and_gap_withoffsets.').';

%% Process every Eq2Eq file
disp('Produce EQ-to-EQ files and start processing:')
process_FCDR

disp(['Month ', num2str(chosen_month), ' has been processed sucessfully.'] )

