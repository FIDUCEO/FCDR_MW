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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% quality checks DSV for all channels

%%%%% Quality check for DSV counts %%%%
totalnumberofscanlines=length(data.scan_line_year);


excludechannel=zeros(5,1); %initialize "excludechannel" with zeros everywhere: "all channels usable"
qualflag_DSV_badline_5closest=zeros(5,length(data.scan_line_year));
qualflag_DSV_badline_furtherthan5lines=zeros(5,length(data.scan_line_year));
scnlin_DSV_badline_5closest=cell(5,1);
scnlin_DSV_badline_furtherthan5lines=cell(5,1);

num_closestlines=5; % set the number of closest good scanline that shall be taken to replace a badscanline

dsv_meanOLD=dsv_mean;
dsv_mean_intermed=dsv_mean;
dsvmean_per_line=dsv_mean;

% DSV counts
dsv_counts_raw(1,:,:)=dsvch1;
dsv_counts_raw(2,:,:)=dsvch2;     
dsv_counts_raw(3,:,:)=dsvch3;
dsv_counts_raw(4,:,:)=dsvch4;
dsv_counts_raw(5,:,:)=dsvch5;
                            
                            
                            % thresholds for the counts
%                             count_thriwct_ch1=count_thriwct(1,:);
%                             count_thriwct_ch2=count_thriwct(2,:);
%                             count_thriwct_ch3=count_thriwct(3,:);
%                             count_thriwct_ch4=count_thriwct(4,:);
%                             count_thriwct_ch5=count_thriwct(5,:);
 
% thresholds for the counts per channel
count_thrdsv_min_orig=count_thrdsv(:,1);
count_thrdsv_max_orig=count_thrdsv(:,2);

%                             count_thrdsv_ch1=count_thrdsv(1,:);
%                             count_thrdsv_ch2=count_thrdsv(2,:);
%                             count_thrdsv_ch3=count_thrdsv(3,:);
%                             count_thrdsv_ch4=count_thrdsv(4,:);
%                             count_thrdsv_ch5=count_thrdsv(5,:);
 
% median of the 4 views per channela dn scanline
count_medianDSV_orig(1,:)=median(dsvch1,2,'omitnan');
count_medianDSV_orig(2,:)=median(dsvch2,2,'omitnan');
count_medianDSV_orig(3,:)=median(dsvch3,2,'omitnan');
count_medianDSV_orig(4,:)=median(dsvch4,2,'omitnan');
count_medianDSV_orig(5,:)=median(dsvch5,2,'omitnan');                            
                            
                                                    
% Additionally, I consider the deviation from
% the median. At first, I will use the AMSU
% values. Note: they seem to be too small.
% There are too many views regarded as outlier,
% that are no true outliers, when looking at
% the course of all 4 DSV. Let's take as new
% threshold 3*sigma, with
% sigma=u_C_S=countNoise (from AllanDev, 1 value per orbit, same value for all scanlines).
% maybe 3*sigma is still too small.
count_medianthrDSV_orig(1)=3*dsvcountallandev_med(1,1); %8.07 % 21.5127 MHSN18 %maybe use constant value at first, to evade calculating Allan Dev twice
count_medianthrDSV_orig(2)=3*dsvcountallandev_med(2,1);% 9.64 %  42.4404 MHSN18
count_medianthrDSV_orig(3)=3*dsvcountallandev_med(3,1);% 18.06 %59.0145 MHSN18
count_medianthrDSV_orig(4)=3*dsvcountallandev_med(4,1);% 11.47 % 42.4421 MHSN18
count_medianthrDSV_orig(5)=3*dsvcountallandev_med(5,1);% 8.35 %55.5902 MHSN18
                            
 
% limit for difference of max and min-value for
% 4 views in one scan line (5*sigma according to EUMETSAT MHS prod gen spec)
limitDSV_orig(1)=5*dsvcountallandev_med(1,1);
limitDSV_orig(2)=5*dsvcountallandev_med(2,1);
limitDSV_orig(3)=5*dsvcountallandev_med(3,1);
limitDSV_orig(4)=5*dsvcountallandev_med(4,1);
limitDSV_orig(5)=5*dsvcountallandev_med(5,1);

% expand all variables to the channel x scanline dimensions x view
count_thrdsv_min=repmat(count_thrdsv_min_orig,[1 totalnumberofscanlines 4]); % 4 views
count_thrdsv_max=repmat(count_thrdsv_max_orig,[1 totalnumberofscanlines 4]);
count_medianDSV=repmat(count_medianDSV_orig,[1 1 4]);
count_medianthrDSV=repmat(count_medianthrDSV_orig.',[1 totalnumberofscanlines 4]);
limitDSV=repmat(limitDSV_orig.',[1 totalnumberofscanlines 4]);


%%%%%%%%%%%%%   TESTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Threshold test (valid per view per scanline)
thresholdtest=count_thrdsv_min<dsv_counts_raw & dsv_counts_raw < count_thrdsv_max;  %good views get 1

%% Median test (valid per view per scanline)
mediantest=abs(count_medianDSV-dsv_counts_raw)<=count_medianthrDSV; %good views get 1


%% MaxView-MinView test (result valid for all 4 views of scanline)
minmaxtest=max(dsv_counts_raw,[],3)-min(dsv_counts_raw,[],3)<=limitDSV(:,:,1); %good lines get 1


%% test for jumps and plateaus
[goodline_before_jump{1},badlinesjump{1}]=filter_plateausANDpeaks(dsv_meanOLD(:,1),jump_thr(1));
[goodline_before_jump{2},badlinesjump{2}]=filter_plateausANDpeaks(dsv_meanOLD(:,2),jump_thr(2));
[goodline_before_jump{3},badlinesjump{3}]=filter_plateausANDpeaks(dsv_meanOLD(:,3),jump_thr(3));
[goodline_before_jump{4},badlinesjump{4}]=filter_plateausANDpeaks(dsv_meanOLD(:,4),jump_thr(4));
[goodline_before_jump{5},badlinesjump{5}]=filter_plateausANDpeaks(dsv_meanOLD(:,5),jump_thr(5));

% make qualityflag for good lines before jump
    qualflag_DSVline_good_bef_jump=zeros(5,totalnumberofscanlines);
    qualflag_DSVline_good_bef_jump(1,goodline_before_jump{1})=1;
    qualflag_DSVline_good_bef_jump(2,goodline_before_jump{2})=1;
    qualflag_DSVline_good_bef_jump(3,goodline_before_jump{3})=1;
    qualflag_DSVline_good_bef_jump(4,goodline_before_jump{4})=1;
    qualflag_DSVline_good_bef_jump(5,goodline_before_jump{5})=1;


%% 
%%%%%%%%%%%%%%%%%   QUALITY FLAGS           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% quality flags and lists of scanlines

%qualityflag per view
% include the min max test, i.e. flag whole scanline (for all views) as bad
% if minmax test failed.
expand_minmaxtest=repmat(minmaxtest,[1 1 4]);

qualflag_DSVview_good_checks= logical(thresholdtest) & logical(mediantest)& logical(expand_minmaxtest); % good views pass all tests
qualflag_DSVview_bad_checks= ~qualflag_DSVview_good_checks;

%qualityflag per scanline

% define what is a badline:
% 1. badline, if less than 2 views are ok (i.e. sum over view-dimension of qualflag_DSVview_good < 2)
    sumusedDSVviews=sum(qualflag_DSVview_good_checks,3);
    qualflag_DSVline_bad_checksviews=(sumusedDSVviews<2); 
    %for these lines, all views are (considered) bad. These lines will get NAN
    %or get an estimate of the 5 closest lines, if closer than 5 lines to good
    %one.
% 2. badline, line that has a jump
    qualflag_DSVline_jumpbad=zeros(5,totalnumberofscanlines);
    qualflag_DSVline_jumpbad(1,badlinesjump{1})=1;
    qualflag_DSVline_jumpbad(2,badlinesjump{2})=1;
    qualflag_DSVline_jumpbad(3,badlinesjump{3})=1;
    qualflag_DSVline_jumpbad(4,badlinesjump{4})=1;
    qualflag_DSVline_jumpbad(5,badlinesjump{5})=1;
% 3. badline, if min and max - views are too far apart
    qualflag_DSVline_bad_minmaxtest=logical(~minmaxtest);
    
 % combine all three
qualflag_DSVline_bad_checks= logical(qualflag_DSVline_bad_checksviews) | logical(qualflag_DSVline_jumpbad) |logical (qualflag_DSVline_bad_minmaxtest);
qualflag_DSVline_good_checks=~qualflag_DSVline_bad_checks; 
    
% list of bad lines acc. to the checks, per channel
scnlin_bad_checksdsv{1}=double(find(qualflag_DSVline_bad_checks(1,:)==1).');%union(find(qualflag_DSVline_bad_checksviews(1,:)==1),badlinesjump{1});
scnlin_bad_checksdsv{2}=double(find(qualflag_DSVline_bad_checks(2,:)==1).');%union(find(qualflag_DSVline_bad_checksviews(2,:)==1),badlinesjump{2});
scnlin_bad_checksdsv{3}=double(find(qualflag_DSVline_bad_checks(3,:)==1).');%union(find(qualflag_DSVline_bad_checksviews(3,:)==1),badlinesjump{3});
scnlin_bad_checksdsv{4}=double(find(qualflag_DSVline_bad_checks(4,:)==1).');%union(find(qualflag_DSVline_bad_checksviews(4,:)==1),badlinesjump{4});
scnlin_bad_checksdsv{5}=double(find(qualflag_DSVline_bad_checks(5,:)==1).');%union(find(qualflag_DSVline_bad_checksviews(5,:)==1),badlinesjump{5});

% define lines that are bad, but that are close to one that is good according to the above checks.
    %need goodlines at first
    scnlin_good_checksdsv{1}=double(setdiff(scanlinenumbers,scnlin_bad_checksdsv{1}));
    scnlin_good_checksdsv{2}=double(setdiff(scanlinenumbers,scnlin_bad_checksdsv{2}));
    scnlin_good_checksdsv{3}=double(setdiff(scanlinenumbers,scnlin_bad_checksdsv{3}));
    scnlin_good_checksdsv{4}=double(setdiff(scanlinenumbers,scnlin_bad_checksdsv{4}));
    scnlin_good_checksdsv{5}=double(setdiff(scanlinenumbers,scnlin_bad_checksdsv{5}));

% finding the badlines close to good ones:

% and calculate dsv-mean as intermediate step, on the fly
% (over used views, or estimate for the 5-closest scanline case or NAN for
% badlines further away)

%initialize matrix to store the closest 5 goodlines for a badline
good_linesDSV_closeTobad=zeros(5,totalnumberofscanlines,num_closestlines);

% note: the dsv_mean_intermed variable is set here to receive the estimates
% for the 5-closest-scanline case and NAN for bad lines further away than 5 lines.
for chn=1:5
    
    if length(scnlin_good_checksdsv{chn})>=300
    
    for indexbad=1:length(scnlin_bad_checksdsv{chn}) % go through all bad scanlines

        [sorted,sortedloc]=sort(abs(scnlin_good_checksdsv{chn}-scnlin_bad_checksdsv{chn}(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
            %dsv_mean_intermed(scnlin_bad_checksdsv{chn}(indexbad),chn)=median(dsv_meanOLD(scnlin_good_checksdsv{chn}(sortedloc(1:num_closestlines)),chn)); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTlines,channel);
            %dsvmean_per_line(scnlin_bad_checksdsv{chn}(indexbad),chn)=median(dsv_meanOLD(scnlin_good_checksdsv{chn}(sortedloc(1:num_closestlines)),chn)); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTlines,channel);
            
            %this is also done for missing scanlines! i.e. the DSV and DSV counts are estimated.
            %But since there are no C_E, the calibration is not possible and there are NaNs in btemps which are converted to fillvalue with change-type.

            qualflag_DSV_badline_5closest(chn,scnlin_bad_checksdsv{chn}(indexbad))=1;
            
            %store the five-closest lines for every badline of this
            %5-closest case:
            good_linesDSV_closeTobad(chn,scnlin_bad_checksdsv{chn}(indexbad),:)=scnlin_good_checksdsv{chn}(sortedloc(1:num_closestlines));
            
        else
            qualflag_DSV_badline_furtherthan5lines(chn,scnlin_bad_checksdsv{chn}(indexbad))=1;
            
            
            %dsv_mean_intermed(scnlin_bad_checksdsv{chn}(indexbad),chn)=nan;
            dsvmean_per_line(scnlin_bad_checksdsv{chn}(indexbad),chn)=nan;
            
         end

    end

    else
        excludechannel(chn)=1;
    end
    
    
end

% list of badlines close to good ones (5-closest- case...
scnlin_DSV_badline_5closest{1}=find(qualflag_DSV_badline_5closest(1,:)==1).';
scnlin_DSV_badline_5closest{2}=find(qualflag_DSV_badline_5closest(2,:)==1).';
scnlin_DSV_badline_5closest{3}=find(qualflag_DSV_badline_5closest(3,:)==1).';
scnlin_DSV_badline_5closest{4}=find(qualflag_DSV_badline_5closest(4,:)==1).';
scnlin_DSV_badline_5closest{5}=find(qualflag_DSV_badline_5closest(5,:)==1).';
% ...and further-away-case)
scnlin_DSV_badline_furtherthan5lines{1}=find(qualflag_DSV_badline_furtherthan5lines(1,:)==1).';
scnlin_DSV_badline_furtherthan5lines{2}=find(qualflag_DSV_badline_furtherthan5lines(2,:)==1).';
scnlin_DSV_badline_furtherthan5lines{3}=find(qualflag_DSV_badline_furtherthan5lines(3,:)==1).';
scnlin_DSV_badline_furtherthan5lines{4}=find(qualflag_DSV_badline_furtherthan5lines(4,:)==1).';
scnlin_DSV_badline_furtherthan5lines{5}=find(qualflag_DSV_badline_furtherthan5lines(5,:)==1).';

            
            
%% compute the count mean over the views:
%construct matrix having 1 at views that should enter the mean over the
%views. 
% set zero to NAN , to generate NAN values
%  for bad views:
expand_qualflag_DSV_badline_5closest=repmat(qualflag_DSV_badline_5closest,[1 1 4]);
usedDSVviews=double(logical(qualflag_DSVview_good_checks)) ; % |logical(expand_qualflag_DSV_badline_5closest));
usedDSVviews(usedDSVviews==0)=nan;%(qualflag_IWCTview_good_checks==0)=nan;

dsv_counts_use=usedDSVviews.* dsv_counts_raw; % calculate the counts to be used by elementwise multiplication with usable-views-matrix
dsv_mean_appliedflags_withoutMooncheck= mean(dsv_counts_use,3,'omitnan'); %calculate mean over all usable views, omitting the NANs, i.e. the mean is calculated correeclty over reduced number of views (in case it is necessary)
% this dsv_mean_appliedflags_withoutMooncheck needs to be combined with the
% dsv_mean-on-ok-moon-views, in order to obtain the dsv_mean that shall go
% into the rolling average. 
% TRUE: Note that
% the badline further away than 5 lines from a good one, got NAN as
% dsv_mean_perline.

% % 1. dsv_mean_appliedflags_withoutMooncheck combined with dsvmean_per_line (containting the 5closest-medians) to new dsvmean_per_line
% 2. this dsvmean_per_line + dsvmeanviewok = dsvmean_per_line
% 3. rollingaverage(dsvmean_per_line)= averaged_dsv_mean_intermed
% 4. averaged_dsv_mean_intermed = final_dsv_mean

% % step 1.
% dsvmean_per_line_transp=dsvmean_per_line.';
% dsv_mean_appliedflags_withoutMooncheck(qualflag_DSV_badline_5closest==1)=dsvmean_per_line_transp(qualflag_DSV_badline_5closest==1);
% % now the 5-closest case lines are included with their median estimates

% don't do step 1; since we DO NOT include the 5-closest case in the
% 7-scanlin av! (we want to fill them up only AFTER the roll av.)


% prepare step 2.
% put the mean without mooncheck into new variable. The moon-check-mean for
% the "1-view-is-ok" cases is then written into dsvmean_per_line (in the setup_roll_av routine) that
% enters the rolling average (5-closest cases might be overwritten by moon-check-means since e.g. 1 view was ok there)
dsvmean_per_line=dsv_mean_appliedflags_withoutMooncheck;



% quality flag to indicate that less than 4 views have been used to
% calculate the mean over the views
qualflag_DSVline_less4views=(sum(qualflag_DSVview_good_checks,3)>=2 & sum(qualflag_DSVview_good_checks,3)<4); 
%"equal or larger than 2"  and "smaller than 4 means" that 2 or 3 views
%have been used, i.e. that calibration WAS done (more than 1 view), but NOT
%with ALL (which would be 4)
% watch out! this is only based on the tests above. But also in the
% moonokview-case there are less than 4 views used. I.e. in the
% qualityflags setting, unite this flag with the moonokview-one.



%%  summary of flags
% per scanline
% qualflag_DSVline_jump : indicates line with jump
% qualflag_DSVline_bad_checksviews: indicates line where no view is available
%                               according to median and threshold test and
%                               min max test
% qualflag_DSVline_bad_checks: combines the above

qualflag_allbadDSV=qualflag_DSVline_bad_checks;
% 
% qualflag_DSV_badline_5closest: indicating badline (acc. to above test)
%                               that is closer than 5 lines from a good
%                               one. Remove the lines with at least one
%                               good DSV (acc. to mooncheck), since these
%                               lines are used in the 7-scnlin-av. and MUST
%                               NOT be overwritten.
% take the difference of the sets of 5-closestlines and the
% scnlinoneviewok-lines obtained from moonchecks.
scnlin_DSV_badline_5closest_TRUE{1}=setdiff(scnlin_DSV_badline_5closest{1},scnlinoneviewok.');
scnlin_DSV_badline_5closest_TRUE{2}=setdiff(scnlin_DSV_badline_5closest{2},scnlinoneviewok.');
scnlin_DSV_badline_5closest_TRUE{3}=setdiff(scnlin_DSV_badline_5closest{3},scnlinoneviewok.');
scnlin_DSV_badline_5closest_TRUE{4}=setdiff(scnlin_DSV_badline_5closest{4},scnlinoneviewok.');
scnlin_DSV_badline_5closest_TRUE{5}=setdiff(scnlin_DSV_badline_5closest{5},scnlinoneviewok.');

% make the corresponding qualityflag
qualflag_DSV_badline_5closest_TRUE=zeros(5,totalnumberofscanlines);
qualflag_DSV_badline_5closest_TRUE(1,scnlin_DSV_badline_5closest_TRUE{1})=1;
qualflag_DSV_badline_5closest_TRUE(2,scnlin_DSV_badline_5closest_TRUE{2})=1;
qualflag_DSV_badline_5closest_TRUE(3,scnlin_DSV_badline_5closest_TRUE{3})=1;
qualflag_DSV_badline_5closest_TRUE(4,scnlin_DSV_badline_5closest_TRUE{4})=1;
qualflag_DSV_badline_5closest_TRUE(5,scnlin_DSV_badline_5closest_TRUE{5})=1;

% qualflag_DSV_badline_furtherthan5lines: indicating badline (acc. to above test)
%                               that is further away than 5 lines from a good one



% qualflag_DSVline_less4views: indicating that less than 4 views have been
%                                 used to calculate the mean over the views
% 

% qualflag_DSVline_good_bef_jump: indicating a line before a jump


% Exclude channels that do not have any good lines.
for chn=1:5
    if isempty(scnlin_good_checksdsv{chn})
        excludechannel(chn)=1;
    end
end
% compile the set of usable channels for dsv
channelset_dsv=find(~excludechannel);
excludechannel=0*excludechannel; %reset the values

% final summary:
% qualflag_allbadDSV
% qualflag_DSV_badline_5closest_TRUE
% qualflag_DSV_badline_furtherthan5lines
% qualflag_DSVline_less4views
% qualflag_DSVline_good_bef_jump


% FIXME: implement excluding of whole channels from further processing




                            