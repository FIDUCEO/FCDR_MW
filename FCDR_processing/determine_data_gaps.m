


%test_determine_data_gaps

function scnlin_before_datagap=determine_data_gaps(sat,sen,monthly_data_record)


% find data gaps as time jumps larger than 1/2 orbit (=6128/2 s)
halforbittime=6128/2;
timedifferences=diff(monthly_data_record.time_EpochSecond);
scnlin_before_datagap=find(timedifferences>halforbittime);