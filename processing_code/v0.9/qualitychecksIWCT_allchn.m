

% quality checks IWCT for all channels

%%%%% Quality check for IWCT counts %%%%
totalnumberofscanlines=length(data.scan_line_year);


excludechannel=zeros(5,1); %initialize "excludechannel" with zeros everywhere: "all channels usable"
qualflag_IWCT_badline_5closest=zeros(5,length(data.scan_line_year));
qualflag_IWCT_badline_furtherthan5lines=zeros(5,length(data.scan_line_year));
scnlin_IWCT_badline_5closest=cell(5,1);
scnlin_IWCT_badline_furtherthan5lines=cell(5,1);

num_closestlines=5; % set the number of closest good scanline that shall be taken to replace a badscanline

iwct_meanOLD=iwct_mean;
iwct_mean_intermed=iwct_mean;
iwctmean_per_line=iwct_mean;
% IWCT counts
iwct_counts_raw(1,:,:)=iwctch1;
iwct_counts_raw(2,:,:)=iwctch2;     
iwct_counts_raw(3,:,:)=iwctch3;
iwct_counts_raw(4,:,:)=iwctch4;
iwct_counts_raw(5,:,:)=iwctch5;
                            
                            
                            % thresholds for the counts
%                             count_thriwct_ch1=count_thriwct(1,:);
%                             count_thriwct_ch2=count_thriwct(2,:);
%                             count_thriwct_ch3=count_thriwct(3,:);
%                             count_thriwct_ch4=count_thriwct(4,:);
%                             count_thriwct_ch5=count_thriwct(5,:);
 
% thresholds for the counts per channel
count_thriwct_min_orig=count_thriwct(:,1);
count_thriwct_max_orig=count_thriwct(:,2);

%                             count_thriwct_ch1=count_thriwct(1,:);
%                             count_thriwct_ch2=count_thriwct(2,:);
%                             count_thriwct_ch3=count_thriwct(3,:);
%                             count_thriwct_ch4=count_thriwct(4,:);
%                             count_thriwct_ch5=count_thriwct(5,:);
 
% median of the 4 views per channela dn scanline
count_medianIWCT_orig(1,:)=median(iwctch1,2);
count_medianIWCT_orig(2,:)=median(iwctch2,2);
count_medianIWCT_orig(3,:)=median(iwctch3,2);
count_medianIWCT_orig(4,:)=median(iwctch4,2);
count_medianIWCT_orig(5,:)=median(iwctch5,2);                            
                            
                                                    
% Additionally, I consider the deviation from
% the median. At first, I will use the AMSU
% values. Note: they seem to be too small.
% There are too many views regarded as outlier,
% that are no true outliers, when looking at
% the course of all 4 IWCT. Let's take as new
% threshold 3*sigma, with
% sigma=u_C_S=countNoise (from AllanDev, 1 value per orbit, same value for all scanlines).
% maybe 3*sigma is still too small.
count_medianthrIWCT_orig(1)=3*iwctcountallandev_med(1,1); %8.07
count_medianthrIWCT_orig(2)=3*iwctcountallandev_med(1,2);% 9.64
count_medianthrIWCT_orig(3)=3*iwctcountallandev_med(1,3);% 18.06
count_medianthrIWCT_orig(4)=3*iwctcountallandev_med(1,4);% 11.47
count_medianthrIWCT_orig(5)=3*iwctcountallandev_med(1,5);% 8.35
                            
 
% limit for difference of max and min-value for
% 4 views in one scan line (5*sigma according to EUMETSAT MHS prod gen spec)
limitIWCT_orig(1)=5*iwctcountallandev_med(1,1);
limitIWCT_orig(2)=5*iwctcountallandev_med(1,2);
limitIWCT_orig(3)=5*iwctcountallandev_med(1,3);
limitIWCT_orig(4)=5*iwctcountallandev_med(1,4);
limitIWCT_orig(5)=5*iwctcountallandev_med(1,5);

% expand all variables to the channel x scanline dimensions x view
count_thriwct_min=repmat(count_thriwct_min_orig,[1 totalnumberofscanlines 4]); % 4 views
count_thriwct_max=repmat(count_thriwct_max_orig,[1 totalnumberofscanlines 4]);
count_medianIWCT=repmat(count_medianIWCT_orig,[1 1 4]);
count_medianthrIWCT=repmat(count_medianthrIWCT_orig.',[1 totalnumberofscanlines 4]);
limitIWCT=repmat(limitIWCT_orig.',[1 totalnumberofscanlines 4]);


%%%%%%%%%%%%%   TESTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Threshold test (valid per view per scanline)
thresholdtest=count_thriwct_min<iwct_counts_raw & iwct_counts_raw < count_thriwct_max;  %good views get 1

%% Median test (valid per view per scanline)
mediantest=abs(count_medianIWCT-iwct_counts_raw)<=count_medianthrIWCT; %good views get 1


%% MaxView-MinView test (result valid for all 4 views of scanline)
minmaxtest=max(iwct_counts_raw,[],3)-min(iwct_counts_raw,[],3)<=limitIWCT(:,:,1); %good lines get 1


%% test for jumps and plateaus
[goodline_before_jump{1},badlinesjump{1}]=filter_plateausANDpeaks(iwct_meanOLD(:,1),jump_thr(1));
[goodline_before_jump{2},badlinesjump{2}]=filter_plateausANDpeaks(iwct_meanOLD(:,2),jump_thr(2));
[goodline_before_jump{3},badlinesjump{3}]=filter_plateausANDpeaks(iwct_meanOLD(:,3),jump_thr(3));
[goodline_before_jump{4},badlinesjump{4}]=filter_plateausANDpeaks(iwct_meanOLD(:,4),jump_thr(4));
[goodline_before_jump{5},badlinesjump{5}]=filter_plateausANDpeaks(iwct_meanOLD(:,5),jump_thr(5));

% make qualityflag for good lines before jump
    qualflag_IWCTline_good_bef_jump=zeros(5,totalnumberofscanlines);
    qualflag_IWCTline_good_bef_jump(1,goodline_before_jump{1})=1;
    qualflag_IWCTline_good_bef_jump(2,goodline_before_jump{2})=1;
    qualflag_IWCTline_good_bef_jump(3,goodline_before_jump{3})=1;
    qualflag_IWCTline_good_bef_jump(4,goodline_before_jump{4})=1;
    qualflag_IWCTline_good_bef_jump(5,goodline_before_jump{5})=1;


%% 
%%%%%%%%%%%%%%%%%   QUALITY FLAGS           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% quality flags and lists of scanlines

%qualityflag per view
% include the min max test, i.e. flag whole scanline (for all views) as bad
% if minmax test failed.
expand_minmaxtest=repmat(minmaxtest,[1 1 4]);

qualflag_IWCTview_good_checks= logical(thresholdtest) & logical(mediantest) & logical(expand_minmaxtest); % good views pass all tests
qualflag_IWCTview_bad_checks= ~qualflag_IWCTview_good_checks;





%qualityflag per scanline

% define what is a badline:
% 1. badline, if less than 2 views are ok (i.e. sum over view-dimension of qualflag_IWCTview_good < 2)
    sumusedIWCTviews=sum(qualflag_IWCTview_good_checks,3);
    qualflag_IWCTline_bad_checksviews=(sumusedIWCTviews<2); 
    %for these lines, all views are (considered) bad. These lines will get NAN
    %or get an estimate of the 5 closest lines, if closer than 5 lines to good
    %one.
% 2. badline, line that has a jump
    qualflag_IWCTline_jumpbad=zeros(5,totalnumberofscanlines);
    qualflag_IWCTline_jumpbad(1,badlinesjump{1})=1;
    qualflag_IWCTline_jumpbad(2,badlinesjump{2})=1;
    qualflag_IWCTline_jumpbad(3,badlinesjump{3})=1;
    qualflag_IWCTline_jumpbad(4,badlinesjump{4})=1;
    qualflag_IWCTline_jumpbad(5,badlinesjump{5})=1;
% 3. badline, if min and max - views are too far apart
    qualflag_IWCTline_bad_minmaxtest=logical(~minmaxtest);    
    
 % combine all three
qualflag_IWCTline_bad_checks= logical(qualflag_IWCTline_bad_checksviews) | logical(qualflag_IWCTline_jumpbad) | logical (qualflag_IWCTline_bad_minmaxtest);
qualflag_IWCTline_good_checks=~qualflag_IWCTline_bad_checks; 
    
% list of bad lines acc. to the checks, per channel
scnlin_bad_checksiwct{1}=double(find(qualflag_IWCTline_bad_checks(1,:)==1).');%union(find(qualflag_IWCTline_bad_checksviews(1,:)==1),badlinesjump{1});
scnlin_bad_checksiwct{2}=double(find(qualflag_IWCTline_bad_checks(2,:)==1).');%union(find(qualflag_IWCTline_bad_checksviews(2,:)==1),badlinesjump{2});
scnlin_bad_checksiwct{3}=double(find(qualflag_IWCTline_bad_checks(3,:)==1).');%union(find(qualflag_IWCTline_bad_checksviews(3,:)==1),badlinesjump{3});
scnlin_bad_checksiwct{4}=double(find(qualflag_IWCTline_bad_checks(4,:)==1).');%union(find(qualflag_IWCTline_bad_checksviews(4,:)==1),badlinesjump{4});
scnlin_bad_checksiwct{5}=double(find(qualflag_IWCTline_bad_checks(5,:)==1).');%union(find(qualflag_IWCTline_bad_checksviews(5,:)==1),badlinesjump{5});

% define lines that are bad, but that are close to one that is good according to the above checks.
    %need goodlines at first
    scnlin_good_checksiwct{1}=double(setdiff(scanlinenumbers,scnlin_bad_checksiwct{1}));
    scnlin_good_checksiwct{2}=double(setdiff(scanlinenumbers,scnlin_bad_checksiwct{2}));
    scnlin_good_checksiwct{3}=double(setdiff(scanlinenumbers,scnlin_bad_checksiwct{3}));
    scnlin_good_checksiwct{4}=double(setdiff(scanlinenumbers,scnlin_bad_checksiwct{4}));
    scnlin_good_checksiwct{5}=double(setdiff(scanlinenumbers,scnlin_bad_checksiwct{5}));

% finding the badlines close to good ones:

% and calculate iwct-mean as intermediate step, on the fly
% (over used views, or estimate for the 5-closest scanline case or NAN for
% badlines further away)

%initialize matrix to store the closest 5 goodlines for a badline
good_linesIWCT_closeTobad=zeros(5,totalnumberofscanlines,num_closestlines);

% note: the iwct_mean_intermed variable is set here to receive the estimates
% for the 5-closest-scanline case and NAN for bad lines further away than 5 lines.
for chn=1:5
    
    if length(scnlin_good_checksiwct{chn})>=300
    
    for indexbad=1:length(scnlin_bad_checksiwct{chn}) % go through all bad scanlines

        [sorted,sortedloc]=sort(abs(scnlin_good_checksiwct{chn}-scnlin_bad_checksiwct{chn}(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
            %iwct_mean_intermed(scnlin_bad_checksiwct{chn}(indexbad),chn)=median(iwct_meanOLD(scnlin_good_checksiwct{chn}(sortedloc(1:num_closestlines)),chn)); %iwct_mean(badPRTline,channel)=iwct_mean(closestgoodPRTlines,channel);
            iwctmean_per_line(scnlin_bad_checksiwct{chn}(indexbad),chn)=median(iwct_meanOLD(scnlin_good_checksiwct{chn}(sortedloc(1:num_closestlines)),chn)); %iwct_mean(badPRTline,channel)=iwct_mean(closestgoodPRTlines,channel);
            %?! the iwct mean has a wrong value at 1655 . some where it gets back its wrong values.
            %this is also done for missing scanlines! i.e. the IWCT and IWCT counts are estimated.
            %But since there are no C_E, the calibration is not possible and there are NaNs in btemps which are converted to fillvalue with change-type.

            qualflag_IWCT_badline_5closest(chn,scnlin_bad_checksiwct{chn}(indexbad))=1;
            
            %store the five-closest lines for every badline of this
            %5-closest case:
            good_linesIWCT_closeTobad(chn,scnlin_bad_checksiwct{chn}(indexbad),:)=scnlin_good_checksiwct{chn}(sortedloc(1:num_closestlines));
            
            
        else
            qualflag_IWCT_badline_furtherthan5lines(chn,scnlin_bad_checksiwct{chn}(indexbad))=1;
            
            
            %iwct_mean_intermed(scnlin_bad_checksiwct{chn}(indexbad),chn)=nan;
            iwctmean_per_line(scnlin_bad_checksiwct{chn}(indexbad),chn)=nan;
        end

    end
    
    else
        excludechannel(chn)=1;
    end
    
    
clear sorted sortedloc
end


% list of badlines close to good ones (5-closest- case...
scnlin_IWCT_badline_5closest{1}=find(qualflag_IWCT_badline_5closest(1,:)==1).';
scnlin_IWCT_badline_5closest{2}=find(qualflag_IWCT_badline_5closest(2,:)==1).';
scnlin_IWCT_badline_5closest{3}=find(qualflag_IWCT_badline_5closest(3,:)==1).';
scnlin_IWCT_badline_5closest{4}=find(qualflag_IWCT_badline_5closest(4,:)==1).';
scnlin_IWCT_badline_5closest{5}=find(qualflag_IWCT_badline_5closest(5,:)==1).';
% ...and further-away-case)
scnlin_IWCT_badline_furtherthan5lines{1}=find(qualflag_IWCT_badline_furtherthan5lines(1,:)==1).';
scnlin_IWCT_badline_furtherthan5lines{2}=find(qualflag_IWCT_badline_furtherthan5lines(2,:)==1).';
scnlin_IWCT_badline_furtherthan5lines{3}=find(qualflag_IWCT_badline_furtherthan5lines(3,:)==1).';
scnlin_IWCT_badline_furtherthan5lines{4}=find(qualflag_IWCT_badline_furtherthan5lines(4,:)==1).';
scnlin_IWCT_badline_furtherthan5lines{5}=find(qualflag_IWCT_badline_furtherthan5lines(5,:)==1).';

            
            
%% compute the count mean over the views:
%construct matrix having 1 at views that should enter the mean over the
%views. Note that we also put in the lines for the 5-closest case since
%they got filled with data and should enter the final 7-scnlin rolling
%average (therefore they need to be view-averaged, too; which they are
%already since they got filled with the median of the 5closest lines'
%view-mean values. But they must appear here as usable views otherwise they
%get overwritten by NAN).
% set zero to NAN , to generate NAN values
%  for bad views:
expand_qualflag_IWCT_badline_5closest=repmat(qualflag_IWCT_badline_5closest,[1 1 4]);
usedIWCTviews=double(logical(qualflag_IWCTview_good_checks));% |logical(expand_qualflag_IWCT_badline_5closest));
usedIWCTviews(usedIWCTviews==0)=nan;%(qualflag_IWCTview_good_checks==0)=nan;
%?! I think you must replace in iwct_mean_appliedflags the 5closest with the iwctmean_perline values!!! procedure as for allandevcalc! no, i think just use the 5closest flag and replace the corresponding eelements
iwct_counts_use=usedIWCTviews.* iwct_counts_raw; % calculate the counts to be used by elementwise mulitplication with usable-views-matrix
iwct_mean_appliedflags= mean(iwct_counts_use,3,'omitnan'); %calculate mean over all usable views, omitting the NANs, i.e. the mean is calculated correeclty over reduced number of views (in case it is necessary)

% this iwct_mean_appliedflags goes
% into the rolling average. Note: 1. that the 5-closest-case-TRUE-lines ARE
% included in the rolling average, therefore the median of the 5 closest
% has been written into iwctmean_perline which enters the rolling average
% (the average is ONLY NOT performed on "further-away cases only"). 2. that
% the badline further away than 5 lines from a good one, got NAN as
% iwct_mean_perline.
% 1. iwct_mean_appliedflags combined with iwctmean_per_line (containting the 5closest-medians) to new iwctmean_per_line
% 2. rollingaverage(iwctmean_per_line)= averaged_iwct_mean_intermed
% 3. averaged_iwct_mean_intermed = final_iwct_mean

% step 1.
iwctmean_per_line_transp=iwctmean_per_line.';
iwct_mean_appliedflags(qualflag_IWCT_badline_5closest==1)=iwctmean_per_line_transp(qualflag_IWCT_badline_5closest==1);

% for step 2.
% put the mean into new variables that will enter the rolling average
iwctmean_per_line=iwct_mean_appliedflags;

% quality flag to indicate that less than 4 views have been used to
% calculate the mean over the views
qualflag_IWCTline_less4views=(sum(qualflag_IWCTview_good_checks,3)>=2 & sum(qualflag_IWCTview_good_checks,3)<4); 
%"equal or larger than 2"  and "smaller than 4 means" that 2 or 3 views
%have been used, i.e. that calibration WAS done (more than 1 view), but NOT
%with ALL (which would be 4)



%%  summary of flags
% per scanline
% qualflag_IWCTline_jump : indicates line with jump
% qualflag_IWCTline_bad_checksviews: indicates line where no view is available
%                               according to median and threshold test
% qualflag_IWCTline_bad_checks: combines the above

qualflag_allbadIWCT=qualflag_IWCTline_bad_checks;
% 
% qualflag_IWCT_badline_5closest: indicating badline (acc. to above test)
%                               that is closer than 5 lines from a good
%                               one. 
scnlin_IWCT_badline_5closest_TRUE{1}=scnlin_IWCT_badline_5closest{1};
scnlin_IWCT_badline_5closest_TRUE{2}=scnlin_IWCT_badline_5closest{2};
scnlin_IWCT_badline_5closest_TRUE{3}=scnlin_IWCT_badline_5closest{3};
scnlin_IWCT_badline_5closest_TRUE{4}=scnlin_IWCT_badline_5closest{4};
scnlin_IWCT_badline_5closest_TRUE{5}=scnlin_IWCT_badline_5closest{5};

% make the corresponding qualityflag
qualflag_IWCT_badline_5closest_TRUE=zeros(5,totalnumberofscanlines);
qualflag_IWCT_badline_5closest_TRUE(1,scnlin_IWCT_badline_5closest_TRUE{1})=1;
qualflag_IWCT_badline_5closest_TRUE(2,scnlin_IWCT_badline_5closest_TRUE{2})=1;
qualflag_IWCT_badline_5closest_TRUE(3,scnlin_IWCT_badline_5closest_TRUE{3})=1;
qualflag_IWCT_badline_5closest_TRUE(4,scnlin_IWCT_badline_5closest_TRUE{4})=1;
qualflag_IWCT_badline_5closest_TRUE(5,scnlin_IWCT_badline_5closest_TRUE{5})=1;

% qualflag_IWCT_badline_furtherthan5lines: indicating badline (acc. to above test)
%                               that is further away than 5 lines from a good one



% qualflag_IWCTline_less4views: indicating that less than 4 views have been
%                                 used to calculate the mean over the views
% 

% qualflag_IWCTline_good_bef_jump: indicating a line before a jump


% Exclude channels that do not have any good lines.
for chn=1:5
    if isempty(scnlin_good_checksiwct{chn})
        excludechannel(chn)=1;
    end
end
% compile the set of usable channels for dsv
channelset_iwct=find(~excludechannel);
excludechannel=0*excludechannel; %reset the values


% final summary:
% qualflag_allbadIWCT
% qualflag_IWCT_badline_5closest_TRUE
% qualflag_IWCT_badline_furtherthan5lines
% qualflag_IWCTline_less4views
% qualflag_IWCTline_good_bef_jump



% FIXME: implement excluding of whole channels from further processing
                            