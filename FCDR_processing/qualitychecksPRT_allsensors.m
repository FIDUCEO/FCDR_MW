

% quality checks PRT for all channels

%%%%% Quality check for PRT counts %%%%
totalnumberofscanlines=length(data.scan_line_year);


onlybadPRTmeasurements=0; 
qualflag_PRT_badline_5closest=zeros(1,length(data.scan_line_year));
qualflag_PRT_badline_furtherthan5lines=zeros(1,length(data.scan_line_year));
scnlin_PRT_badline_5closest=cell(1,1);
scnlin_PRT_badline_furtherthan5lines=cell(1,1);

num_closestlines=5; % set the number of closest good scanline that shall be taken to replace a badscanline

prt_mean=mean(PRTtemps,1);
prt_meanOLD=prt_mean;
prt_mean_intermed=prt_mean;
prtmean_per_line=prt_mean;

% PRT temperatures
if strcmp(sen,'mhs')
    prt_temperature(:,1)=PRT1temp;
    prt_temperature(:,2)=PRT2temp;     
    prt_temperature(:,3)=PRT3temp;
    prt_temperature(:,4)=PRT4temp;
    prt_temperature(:,5)=PRT5temp;
elseif strcmp(sen,'amsub') 
    prt_temperature(:,1)=PRT1temp;
    prt_temperature(:,2)=PRT2temp;     
    prt_temperature(:,3)=PRT3temp;
    prt_temperature(:,4)=PRT4temp;
    prt_temperature(:,5)=PRT5temp;
    prt_temperature(:,6)=PRT6temp;
    prt_temperature(:,7)=PRT7temp;
elseif strcmp(sen,'ssmt2')
    prt_temperature(:,1)=PRT1temp;
    prt_temperature(:,2)=PRT2temp;
end                           

 
temp_thr=[250 310]; % for AMSUB?: temp_thr=[270 310]; %[270 310]
allowed_dev_from_median=0.3; %0.2K %0.3 suggestion by martin
jump_thr_prt=0.1; %Removed: "allow 0.3K jumps Warning: first guess for testing purposes"

 
% median of the 5 or 7 sensors per scanline
temp_medianPRT_orig=median(prt_temperature,2);
                            
                            
                                                    

% expand all variables to the scanline dimensions x view
num_of_prt_sensors_orig=size(prt_temperature,2);
temp_thrprt_min=repmat(temp_thr(1),[ totalnumberofscanlines num_of_prt_sensors_orig]); % size(prt_temperature,1)=number of PRT sensors views
temp_thrprt_max=repmat(temp_thr(2),[ totalnumberofscanlines num_of_prt_sensors_orig]);
temp_medianPRT=repmat(temp_medianPRT_orig,[ 1 num_of_prt_sensors_orig]);
temp_medianthrPRT=repmat(allowed_dev_from_median,[ totalnumberofscanlines num_of_prt_sensors_orig]);


%%%%%%%%%%%%%   TESTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Threshold test (valid per sensor per scanline)
thresholdtest=temp_thrprt_min<prt_temperature & prt_temperature < temp_thrprt_max;  %good sensors get 1

%% Median test (valid per view per scanline)
mediantest=abs(temp_medianPRT-prt_temperature)<=temp_medianthrPRT; %good views get 1



%% test for jumps and plateaus
[goodline_before_jump{1},badlinesjump{1}]=filter_plateausANDpeaks(prt_meanOLD(:,1),jump_thr_prt);


% make qualityflag for good lines before jump
    qualflag_PRTline_good_bef_jump=zeros(totalnumberofscanlines,1);
    qualflag_PRTline_good_bef_jump(goodline_before_jump{1})=1;
    qualflag_PRTline_good_bef_jump=qualflag_PRTline_good_bef_jump.';


%% 
%%%%%%%%%%%%%%%%%   QUALITY FLAGS           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% quality flags and lists of scanlines

%qualityflag per view
qualflag_PRTsen_good_checks= logical(thresholdtest) & logical(mediantest); % good sensors pass both tests
qualflag_PRTsen_bad_checks= ~qualflag_PRTsen_good_checks;

%qualityflag per scanline

% define what is a badline:
% 1. badline, if less than 2 PRTsensors are ok (i.e. sum over view-dimension of qualflag_PRTview_good < 2)
    sumusedPRTsen=sum(qualflag_PRTsen_good_checks,2);
    qualflag_PRTline_bad_checksviews=(sumusedPRTsen<2); 
    %for these lines, all views are (considered) bad. These lines will get NAN
    %or get an estimate of the 5 closest lines, if closer than 5 lines to good
    %one.
% 2. badline, line that has a jump
    qualflag_PRTline_jumpbad=zeros(totalnumberofscanlines,1);
    qualflag_PRTline_jumpbad(badlinesjump{1})=1;
    
    
 % combine both
qualflag_PRTline_bad_checks= logical(qualflag_PRTline_bad_checksviews) | logical(qualflag_PRTline_jumpbad);
qualflag_PRTline_good_checks=~qualflag_PRTline_bad_checks; 
    
% list of bad lines acc. to the checks, per channel
scnlin_bad_checks_prt{1}=double(find(qualflag_PRTline_bad_checks==1).');%union(find(qualflag_PRTline_bad_checksviews(1,:)==1),badlinesjump{1});

% define lines that are bad, but that are close to one that is good according to the above checks.
    %need goodlines at first
    scnlin_good_checks_prt{1}=double(setdiff(scanlinenumbers,scnlin_bad_checks_prt{1}));
    

% finding the badlines close to good ones:

% and calculate prt-mean as intermediate step, on the fly
% (over used views, or estimate for the 5-closest scanline case or NAN for
% badlines further away)

%initialize matrix to store the closest 5 goodlines for a badline
good_linesPRT_closeTobad=zeros(totalnumberofscanlines,num_closestlines);

% note: the prt_mean_intermed variable is set here to receive the estimates
% for the 5-closest-scanline case and NAN for bad lines further away than 5 lines.
if length(scnlin_good_checks_prt{1})>=300
    for indexbad=1:length(scnlin_bad_checks_prt{1}) % go through all bad scanlines

        [sorted,sortedloc]=sort(abs(scnlin_good_checks_prt{1}-scnlin_bad_checks_prt{1}(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
            %prt_mean_intermed(scnlin_bad_checks_prt{1}(indexbad))=median(prt_meanOLD(scnlin_good_checks_prt{1}(sortedloc(1:num_closestlines)))); %prt_mean(badPRTline,channel)=prt_mean(closestgoodPRTlines,channel);
            %prtmean_per_line(scnlin_bad_checks_prt{1}(indexbad))=median(prt_meanOLD(scnlin_good_checks_prt{1}(sortedloc(1:num_closestlines)))); %prt_mean(badPRTline,channel)=prt_mean(closestgoodPRTlines,channel);
            
            %this is also done for missing scanlines! i.e. the PRT and PRT counts are estimated.
            %But since there are no C_E, the calibration is not possible and there are NaNs in btemps which are converted to fillvalue with change-type.

            qualflag_PRT_badline_5closest(scnlin_bad_checks_prt{1}(indexbad))=1;
            
            %store the five-closest lines for every badline of this
            %5-closest case:
            good_linesPRT_closeTobad(scnlin_bad_checks_prt{1}(indexbad),:)=scnlin_good_checks_prt{1}(sortedloc(1:num_closestlines));
            
        else
            qualflag_PRT_badline_furtherthan5lines(scnlin_bad_checks_prt{1}(indexbad))=1;
            
            
            %prt_mean_intermed(scnlin_bad_checks_prt{1}(indexbad))=nan;
            prtmean_per_line(scnlin_bad_checks_prt{1}(indexbad))=nan;
       end

    end
else
        onlybadPRTmeasurements=1;
end


% list of badlines close to good ones (5-closest- case...
scnlin_PRT_badline_5closest{1}=find(qualflag_PRT_badline_5closest==1).';

% ...and further-away-case)
scnlin_PRT_badline_furtherthan5lines{1}=find(qualflag_PRT_badline_furtherthan5lines==1).';


            
            
%% compute the count mean over the views:
%construct matrix having 1 at views that should enter the mean over the
%views. 
% set zero to NAN , to generate NAN values
%  for bad views:
expand_qualflag_PRT_badline_5closest=repmat(qualflag_PRT_badline_5closest.',[1 num_of_prt_sensors_orig]);
usedPRTsensors=double(logical(qualflag_PRTsen_good_checks));% |logical(expand_qualflag_PRT_badline_5closest));
usedPRTsensors(usedPRTsensors==0)=nan;%usedPRTsensors(qualflag_PRTsen_good_checks==0)=nan;


prt_temp_use=usedPRTsensors.* prt_temperature; % calculate the temperature to be used by elementwise mulitplication with usable-views-matrix
prt_mean_appliedflags= mean(prt_temp_use,2,'omitnan'); %calculate mean over all usable sensors, omitting the NANs, i.e. the mean is calculated correeclty over reduced number of sensors (in case it is necessary)
% this prt_mean_appliedflags goes
% into the rolling average. Note: 1. that the 5-closest-case-TRUE-lines ARE
% included in the rolling average, therefore the median of the 5 closest
% has been written into prtmean_perline which enters the rolling average
% (the average is ONLY NOT performed on "further-away cases only"). 2. that
% the badline further away than 5 lines from a good one, got NAN as
% prtmean_perline.
% 1. prt_mean_appliedflags combined with prtmean_per_line (containing the 5closest-medians) to new prtmean_per_line
% 2. rollingaverage(prtmean_per_line)= averaged_prt_mean_intermed
% 3. averaged_prt_mean_intermed = final_prt_mean

% %step 1.
% prtmean_per_line_transp=prtmean_per_line.';
% prt_mean_appliedflags(qualflag_PRT_badline_5closest==1)=prtmean_per_line_transp(qualflag_PRT_badline_5closest==1);

% don't do step 1; since we DO NOT include the 5-closest case in the
% 7-scanlin av! (we want to fill them up only AFTER the roll av.)

% for step 2.
% put the mean into new variables that will enter the rolling average
prtmean_per_line=prt_mean_appliedflags;

% quality flag to indicate that less than full number of sensors have been used to
% calculate the mean over the sensors
qualflag_PRTline_lessfullNumSen=(sum(qualflag_PRTsen_good_checks,2)>=2 & sum(qualflag_PRTsen_good_checks,2)<num_of_prt_sensors_orig).'; 
%"equal or larger than 2"  and "smaller than num_of_prt_sensors_orig means"
%that 2,3 or 4 (MHS) or 2,3,4,5 or 6 PRT sensors
%have been used, i.e. that calibration WAS done (more than 1 sensor), but NOT
%with ALL (which would be num_of_prt_sensors_orig=5 for MHS, 7 for AMSUB)



%%  summary of flags
% per scanline
% qualflag_PRTline_jump : indicates line with jump
% qualflag_PRTline_bad_checksviews: indicates line where no view is available
%                               according to median and threshold test
% qualflag_PRTline_bad_checks: combines the above

qualflag_allbadPRT=qualflag_PRTline_bad_checks.';
% 
% qualflag_PRT_badline_5closest: indicating badline (acc. to above test)
%                               that is closer than 5 lines from a good
%                               one. 
scnlin_PRT_badline_5closest_TRUE{1}=scnlin_PRT_badline_5closest{1};

% make the corresponding qualityflag
qualflag_PRT_badline_5closest_TRUE=zeros(totalnumberofscanlines,1);
qualflag_PRT_badline_5closest_TRUE(scnlin_PRT_badline_5closest_TRUE{1},1)=1;


% qualflag_PRT_badline_furtherthan5lines: indicating badline (acc. to above test)
%                               that is further away than 5 lines from a good one



% qualflag_PRTline_lessfullNumSen: indicating that less than all PRT sensors have been
%                                 used to calculate the mean over the views
% 

% qualflag_PRTline_good_bef_jump: indicating a line before a jump

% check whether there are any good PRT measurements
    if isempty(scnlin_good_checks_prt)
        onlybadPRTmeasurements=1;
    end


% final summary:
% qualflag_allbadPRT
% qualflag_PRT_badline_5closest_TRUE
% qualflag_PRT_badline_furtherthan5lines
% qualflag_PRTline_lessfullNumSen
% qualflag_PRTline_good_bef_jump
                            


