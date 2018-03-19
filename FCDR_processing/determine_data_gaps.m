


%determine_data_gaps

function [scnlin_before_datagap,equator_crossings_cleaned]=determine_data_gaps(sat,sen,monthly_data_record,equator_crossings)

%scnaline_smalljump=[];
scnlin_before_datagap =[];
scnlin_before_datagap_intermed1 =[];
scnlin_before_datagap_intermed2 =[];

% find data gaps as time jumps greater or equal 2*scantime(=2*8/3 s for AMSUB MHS,= 2*8s for SSMT2)
if strcmp(sen,'ssmt2')
    scantime=8;
    usual_scnlinnum_half=350;
else
    scantime=8/3;
    usual_scnlinnum_half=1000;
end
orbittime=6128;

% compute time differences
timedifferences=diff(monthly_data_record.time_EpochSecond);

% find time jumps (these lines are candidates for data gaps across an equator crossing)
candidates_scnlin_before_datagap=find(timedifferences>=2*scantime);


% check whether found candidates are already listed as "equator crossing"
% (because the jump is exactly over the equator...)
[liEQcr,locCand]=ismember(equator_crossings,candidates_scnlin_before_datagap);

% remove the lines identified as lines before gap from the set of Equator
% crossings and store them in output value
equator_crossings_cleaned=equator_crossings(~liEQcr);

% keep the candidates stored as scanline before gap
scnlin_before_datagap_intermed1=candidates_scnlin_before_datagap(locCand(locCand~=0)); 

% collect those candidates that ARE NOT in eqcrossings
candidates_remaining=setdiff(candidates_scnlin_before_datagap,candidates_scnlin_before_datagap(locCand(locCand~=0)));


% loop over found data gaps
eqcrossing_times=monthly_data_record.time_EpochSecond(equator_crossings_cleaned);
for igap=1:length(candidates_remaining)
    time_since_eqcr=eqcrossing_times-monthly_data_record.time_EpochSecond(candidates_remaining(igap)+1); %difference of each Eqcrossing to the end-line of the gap igap
    time_since_last_eqcr=abs(time_since_eqcr(find(time_since_eqcr<0,1,'last'))); % take the last negative difference (i.e. EQcrossing before gap) and use its absolute value then as time diff since last EQcross
    
    if time_since_last_eqcr > orbittime 
       % true large data gap that calls for the beginning of a new file
       % store scnlin_before_gap(igap)
       
       if igap>=2 && candidates_remaining(igap)>candidates_remaining(igap-1)+usual_scnlinnum_half %assure that the found scan line before data gap does not follow immediately after a jump-line. This would be an error. Hence, with this condition, keep only first found line in a cluster of found lines.
           scnlin_before_datagap_intermed2=[scnlin_before_datagap_intermed2 candidates_remaining(igap)];
       elseif igap==1
       
           scnlin_before_datagap_intermed2=[scnlin_before_datagap_intermed2 candidates_remaining(igap)];
       else
           %do not include this line.
       
       end
       
    else
        % no true large data gap. The gap ends still in EQ frame do not
        % store the scanline.
        %scnaline_smalljump=[scnaline_smalljump candidates_remaining(igap)];
    end
end


% combine those lines that had been wronlgy classified as EQcrossings AND
% those lines that were not classified as such, but that are followed by a
% gap that goes beyond the next EQ crossing

scnlin_before_datagap=[scnlin_before_datagap_intermed1 scnlin_before_datagap_intermed2];
