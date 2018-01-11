


% check for data gap larger than one orbit

%%%%%%%%%% Convert time to seconds since 1970

% 1st Eqcrossing-time of 1st file
vecdate=datevec(doy2date(double(data1.scan_line_day_of_year(eq_scnlin_vcp1+3)),double(data1.scan_line_year(eq_scnlin_vcp1+3))));
[vecdate(:,4),vecdate(:,5),vecdate(:,6)]=mills2hmsmill(double(data1.scan_line_UTC_time(eq_scnlin_vcp1+3)));

InputDate_eq_scnlin_vcp1=datenum(vecdate);
UnixOrigin_eq_scnlin_vcp1=datenum('19700101 000000','yyyymmdd HHMMSS');

time_EpochSecond_eq_scnlin_vcp1=round((InputDate_eq_scnlin_vcp1-UnixOrigin_eq_scnlin_vcp1)*86400);

%  starttime of 2nd file
vecdate=datevec(doy2date(double(data2.scan_line_day_of_year(1)),double(data2.scan_line_year(1))));
[vecdate(:,4),vecdate(:,5),vecdate(:,6)]=mills2hmsmill(double(data2.scan_line_UTC_time(1)));

InputDate_start2ndfile=datenum(vecdate);
UnixOrigin_start2ndfile=datenum('19700101 000000','yyyymmdd HHMMSS');

time_EpochSecond_start2ndfile=round((InputDate_start2ndfile-UnixOrigin_start2ndfile)*86400);


% compare 1st Eqcrossing-time of 1st file to starttime of 2nd file
deltasec_oneorbit=6.0693e+03;  %100*60: one orbit has about 2276 scans, and one scan is 8/3 sec, hence 6.0693e+03 sec

if time_EpochSecond_start2ndfile > (deltasec_oneorbit+time_EpochSecond_eq_scnlin_vcp1)
% if starttime of 2nd file is > (1st Eqcrossing-time of 1st file)+100min
    % use only first file and go then to selectorbit+1 (i.e. use the 2nd
    % one as the next first one)
    datagap_detected=1;% use only the first file. Brings us to correct Eq2Eq-case.
    
else
    % Do nothing. Then, normal Eq2Eq fitting.
end