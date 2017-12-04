




%%%%% Quality check for IWCT counts %%%%

excludechannel=zeros(5,1); %initialize "excludechannel" with zeros everywhere: "all channels usable"
qualflag_IWCT_ch1_5closest=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch1_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch2_5closest=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch2_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch3_5closest=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch3_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch4_5closest=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch4_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch5_5closest=zeros(length(data.scan_line_year),1);
qualflag_IWCT_ch5_nocaliballbad=zeros(length(data.scan_line_year),1);

num_closestlines=5; % set the number of closest good scanline that shall be taken to replace a badscanline
                            iwct_meanOLD=iwct_mean;

                            iwctch1median=median(iwctch1,2);
                            iwctch2median=median(iwctch2,2);
                            iwctch3median=median(iwctch3,2);
                            iwctch4median=median(iwctch4,2);
                            iwctch5median=median(iwctch5,2);
                            
                            
                            %thresholds before rejecting a view: the
                            %available threshold change wildly across the
                            %different flightmodels/satellites:
                            % AMSUB- PFM:50, 80, 100, 70, 60 ch1-5, from clparams file ("jump
                            %between 2 scan lines allowed before rejecting")
                            % MHS N18: 250 250 700 500 330
                            % MHS 19,MA,MB: 1000 1000 1000 1000 1000
                            % the MHS values are quite high I think. I do
                            % not know why they were chosen. Since the
                            % orbital variation are on scale of 200 counts
                            % (Amplitude), I think 250 is already far too
                            % high as threshold in channel 1. Moreover, the threshold
                            % should differ between channels.
                            % Additionally, I consider the deviation from
                            % the median. At first, I will use the AMSU
                            % values. Note: they seem to be too small.
                            % There are too many views regarded as outlier,
                            % that are no true outliers, when looking at
                            % the course of all 4 IWCT. Let's take as new
                            % threshold 3*sigma, with
                            % sigma=u_C_S=countNoise (from AllanDev, 1 value per orbit, same value for all scanlines).
                            % maybe 3*sigma is still too small.
                            count_medianthr_ch1=3*iwctcountallandev_med(1,1);
                            count_medianthr_ch2=3*iwctcountallandev_med(1,2);
                            count_medianthr_ch3=3*iwctcountallandev_med(1,3);
                            count_medianthr_ch4=3*iwctcountallandev_med(1,4);
                            count_medianthr_ch5=3*iwctcountallandev_med(1,5);
                            
                            count_thriwct_ch1=count_thriwct(1,:);
                            count_thriwct_ch2=count_thriwct(2,:);
                            count_thriwct_ch3=count_thriwct(3,:);
                            count_thriwct_ch4=count_thriwct(4,:);
                            count_thriwct_ch5=count_thriwct(5,:);
                            
                            count_thrdsv_ch1=count_thrdsv(1,:);
                            count_thrdsv_ch2=count_thrdsv(2,:);
                            count_thrdsv_ch3=count_thrdsv(3,:);
                            count_thrdsv_ch4=count_thrdsv(4,:);
                            count_thrdsv_ch5=count_thrdsv(5,:);
                            
                         
                            % limit for difference of max and min-value for
                            % 4 views in one scan line (5*sigma according to EUMETSAT MHS prod gen spec)
                            limitIWCT_ch1=5*iwctcountallandev_med(1,1);
                            limitIWCT_ch2=5*iwctcountallandev_med(1,2);
                            limitIWCT_ch3=5*iwctcountallandev_med(1,3);
                            limitIWCT_ch4=5*iwctcountallandev_med(1,4);
                            limitIWCT_ch5=5*iwctcountallandev_med(1,5);
                            
                            %%%%%%%% channel 1
                            % median test
                            weightIWCTview_mediantest_ch1(1,:)=(abs(iwctch1median-iwctch1(:,1))<=count_medianthr_ch1); %if the difference of the 
                            %current IWCTview1 measurement and the median of the IWCT measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightIWCTview_mediantest_ch1(2,:)=(abs(iwctch1median-iwctch1(:,2))<=count_medianthr_ch1);
                            weightIWCTview_mediantest_ch1(3,:)=(abs(iwctch1median-iwctch1(:,3))<=count_medianthr_ch1);
                            weightIWCTview_mediantest_ch1(4,:)=(abs(iwctch1median-iwctch1(:,4))<=count_medianthr_ch1);
                          
                            % threshold test
                            weightIWCTview_thresholdtest_ch1=(count_thriwct_ch1(1)<iwctch1 & iwctch1<count_thriwct_ch1(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightIWCTview_ch1(1,:)=min(weightIWCTview_thresholdtest_ch1(:,1).',weightIWCTview_mediantest_ch1(1,:)); 
                            weightIWCTview_ch1(2,:)=min(weightIWCTview_thresholdtest_ch1(:,2).',weightIWCTview_mediantest_ch1(2,:));
                            weightIWCTview_ch1(3,:)=min(weightIWCTview_thresholdtest_ch1(:,3).',weightIWCTview_mediantest_ch1(3,:));
                            weightIWCTview_ch1(4,:)=min(weightIWCTview_thresholdtest_ch1(:,4).',weightIWCTview_mediantest_ch1(4,:));
                            
                            %find scan lines for which at least some of the IWCTs are bad
                            marginalIWCTscnlin_ch1=sort([find(~weightIWCTview_ch1(1,:)),find(~weightIWCTview_ch1(2,:)),find(~weightIWCTview_ch1(3,:)),find(~weightIWCTview_ch1(4,:))]);
                            % SET FLAG for marginalbadIWCT_ch1-flag.
                            qualflag_marginalIWCT(1,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalIWCT(1,marginalIWCTscnlin_ch1)=1;
                                                       
                            %%%%%%%% channel 2
                            % median test
                            weightIWCTview_mediantest_ch2(1,:)=(abs(iwctch2median-iwctch2(:,1))<=count_medianthr_ch2); %if the difference of the 
                            %current IWCTview1 measurement and the median of the IWCT measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightIWCTview_mediantest_ch2(2,:)=(abs(iwctch2median-iwctch2(:,2))<=count_medianthr_ch2);
                            weightIWCTview_mediantest_ch2(3,:)=(abs(iwctch2median-iwctch2(:,3))<=count_medianthr_ch2);
                            weightIWCTview_mediantest_ch2(4,:)=(abs(iwctch2median-iwctch2(:,4))<=count_medianthr_ch2);
                          
                            % threshold test
                            weightIWCTview_thresholdtest_ch2=(count_thriwct_ch2(1)<iwctch2 & iwctch2<count_thriwct_ch2(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightIWCTview_ch2(1,:)=min(weightIWCTview_thresholdtest_ch2(:,1).',weightIWCTview_mediantest_ch2(1,:)); 
                            weightIWCTview_ch2(2,:)=min(weightIWCTview_thresholdtest_ch2(:,2).',weightIWCTview_mediantest_ch2(2,:));
                            weightIWCTview_ch2(3,:)=min(weightIWCTview_thresholdtest_ch2(:,3).',weightIWCTview_mediantest_ch2(3,:));
                            weightIWCTview_ch2(4,:)=min(weightIWCTview_thresholdtest_ch2(:,4).',weightIWCTview_mediantest_ch2(4,:));
                            
                            %find scan lines for which at least some of the IWCTs are bad
                            marginalIWCTscnlin_ch2=sort([find(~weightIWCTview_ch2(1,:)),find(~weightIWCTview_ch2(2,:)),find(~weightIWCTview_ch2(3,:)),find(~weightIWCTview_ch2(4,:))]);
                            % SET FLAG for marginalbadIWCT_ch2-flag.
                            qualflag_marginalIWCT(2,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalIWCT(2,marginalIWCTscnlin_ch2)=1;
                            
                            
                            %%%%%%%% channel 3
                            % median test
                            weightIWCTview_mediantest_ch3(1,:)=(abs(iwctch3median-iwctch3(:,1))<=count_medianthr_ch3); %if the difference of the 
                            %current IWCTview1 measurement and the median of the IWCT measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightIWCTview_mediantest_ch3(2,:)=(abs(iwctch3median-iwctch3(:,2))<=count_medianthr_ch3);
                            weightIWCTview_mediantest_ch3(3,:)=(abs(iwctch3median-iwctch3(:,3))<=count_medianthr_ch3);
                            weightIWCTview_mediantest_ch3(4,:)=(abs(iwctch3median-iwctch3(:,4))<=count_medianthr_ch3);
                          
                            % threshold test
                            weightIWCTview_thresholdtest_ch3=(count_thriwct_ch3(1)<iwctch3 & iwctch3<count_thriwct_ch3(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightIWCTview_ch3(1,:)=min(weightIWCTview_thresholdtest_ch3(:,1).',weightIWCTview_mediantest_ch3(1,:)); 
                            weightIWCTview_ch3(2,:)=min(weightIWCTview_thresholdtest_ch3(:,2).',weightIWCTview_mediantest_ch3(2,:));
                            weightIWCTview_ch3(3,:)=min(weightIWCTview_thresholdtest_ch3(:,3).',weightIWCTview_mediantest_ch3(3,:));
                            weightIWCTview_ch3(4,:)=min(weightIWCTview_thresholdtest_ch3(:,4).',weightIWCTview_mediantest_ch3(4,:));
                            
                            %find scan lines for which at least some of the IWCTs are bad
                            marginalIWCTscnlin_ch3=sort([find(~weightIWCTview_ch3(1,:)),find(~weightIWCTview_ch3(2,:)),find(~weightIWCTview_ch3(3,:)),find(~weightIWCTview_ch3(4,:))]);
                            % SET FLAG for marginalbadIWCT_ch3-flag.
                            qualflag_marginalIWCT(3,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalIWCT(3,marginalIWCTscnlin_ch1)=1;
                            
                            %%%%%%%% channel 4
                            % median test
                            weightIWCTview_mediantest_ch4(1,:)=(abs(iwctch4median-iwctch4(:,1))<=count_medianthr_ch4); %if the difference of the 
                            %current IWCTview1 measurement and the median of the IWCT measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightIWCTview_mediantest_ch4(2,:)=(abs(iwctch4median-iwctch4(:,2))<=count_medianthr_ch4);
                            weightIWCTview_mediantest_ch4(3,:)=(abs(iwctch4median-iwctch4(:,3))<=count_medianthr_ch4);
                            weightIWCTview_mediantest_ch4(4,:)=(abs(iwctch4median-iwctch4(:,4))<=count_medianthr_ch4);
                          
                            % threshold test
                            weightIWCTview_thresholdtest_ch4=(count_thriwct_ch4(1)<iwctch4 & iwctch4<count_thriwct_ch4(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightIWCTview_ch4(1,:)=min(weightIWCTview_thresholdtest_ch4(:,1).',weightIWCTview_mediantest_ch4(1,:)); 
                            weightIWCTview_ch4(2,:)=min(weightIWCTview_thresholdtest_ch4(:,2).',weightIWCTview_mediantest_ch4(2,:));
                            weightIWCTview_ch4(3,:)=min(weightIWCTview_thresholdtest_ch4(:,3).',weightIWCTview_mediantest_ch4(3,:));
                            weightIWCTview_ch4(4,:)=min(weightIWCTview_thresholdtest_ch4(:,4).',weightIWCTview_mediantest_ch4(4,:));
                            
                            %find scan lines for which at least some of the IWCTs are bad
                            marginalIWCTscnlin_ch4=sort([find(~weightIWCTview_ch4(1,:)),find(~weightIWCTview_ch4(2,:)),find(~weightIWCTview_ch4(3,:)),find(~weightIWCTview_ch4(4,:))]);
                            % SET FLAG for marginalbadIWCT_ch4-flag.
                            qualflag_marginalIWCT(4,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalIWCT(4,marginalIWCTscnlin_ch4)=1;
                            
                            %%%%%%% channel 5
                            % median test
                            weightIWCTview_mediantest_ch5(1,:)=(abs(iwctch5median-iwctch5(:,1))<=count_medianthr_ch5); %if the difference of the 
                            %current IWCTview1 measurement and the median of the IWCT measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightIWCTview_mediantest_ch5(2,:)=(abs(iwctch5median-iwctch5(:,2))<=count_medianthr_ch5);
                            weightIWCTview_mediantest_ch5(3,:)=(abs(iwctch5median-iwctch5(:,3))<=count_medianthr_ch5);
                            weightIWCTview_mediantest_ch5(4,:)=(abs(iwctch5median-iwctch5(:,4))<=count_medianthr_ch5);
                          
                            % threshold test
                            weightIWCTview_thresholdtest_ch5=(count_thriwct_ch5(1)<iwctch5 & iwctch5<count_thriwct_ch5(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightIWCTview_ch5(1,:)=min(weightIWCTview_thresholdtest_ch5(:,1).',weightIWCTview_mediantest_ch5(1,:)); 
                            weightIWCTview_ch5(2,:)=min(weightIWCTview_thresholdtest_ch5(:,2).',weightIWCTview_mediantest_ch5(2,:));
                            weightIWCTview_ch5(3,:)=min(weightIWCTview_thresholdtest_ch5(:,3).',weightIWCTview_mediantest_ch5(3,:));
                            weightIWCTview_ch5(4,:)=min(weightIWCTview_thresholdtest_ch5(:,4).',weightIWCTview_mediantest_ch5(4,:));
                            
                            %find scan lines for which at least some of the IWCTs are bad
                            marginalIWCTscnlin_ch5=sort([find(~weightIWCTview_ch5(1,:)),find(~weightIWCTview_ch5(2,:)),find(~weightIWCTview_ch5(3,:)),find(~weightIWCTview_ch5(4,:))]);
                            % SET FLAG for marginalbadIWCT_ch5-flag.
                            qualflag_marginalIWCT(5,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalIWCT(5,marginalIWCTscnlin_ch5)=1;
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            % COMPUTE mean of good IWCT views:
                            
                            % weighted mean of IWCT counts = IWCTcounts at
                            % certain scanline
                            % use weights obtained from
                            % quality check.
                            
                            %%%%% channel 1
                            sumofweightsIWCT_ch1=sum(weightIWCTview_ch1(:,:),1);
                            sumtoosmall_1=find(sumofweightsIWCT_ch1<2);
                            iwct_mean(sumtoosmall_1,1)=nan;
                            iwct_mean(:,1)=1./sumofweightsIWCT_ch1 .*(weightIWCTview_ch1(1,:).*double(iwct1ch1)+weightIWCTview_ch1(2,:).*double(iwct2ch1)+weightIWCTview_ch1(3,:).*double(iwct3ch1)+weightIWCTview_ch1(4,:).*double(iwct4ch1));
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch1,badlinesjump_ch1]=filter_plateausANDpeaks(iwct_mean(:,1),jump_thr(1));
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limitIWCT_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch1=find((abs(min(iwctch1.')-max(iwctch1.'))>=limitIWCT_ch1));
                            allbadIWCTscnlin_ch1=union(union(double(find(sumofweightsIWCT_ch1<2)),badlines_ch1),badlinesjump_ch1);
                            goodIWCTscnlin_ch1=double(setdiff(scanlinenumbers,allbadIWCTscnlin_ch1));
                            
                            if ~isempty(goodIWCTscnlin_ch1) %check whter there are any good lines
                                onlygoodIWCTscnlin_ch1=double(setdiff(goodIWCTscnlin_ch1,marginalIWCTscnlin_ch1)); %look for lines with "all IWCT views good"
                                if length(onlygoodIWCTscnlin_ch1)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadIWCTscnlin_ch1) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodIWCTscnlin_ch1-allbadIWCTscnlin_ch1(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            iwct_mean(allbadIWCTscnlin_ch1(indexbad),1)=median(iwct_mean(goodIWCTscnlin_ch1(sortedloc(1:num_closestlines)),1));%iwct_mean(badline,channel)=median(iwct_mean("close goodlines",channel)); the close goodlines are the closest goodline and the two goodlines before and after
                                            qualflag_IWCT_ch1_5closest(allbadIWCTscnlin_ch1(indexbad))=1;
                                        else
                                            qualflag_IWCT_ch1_nocaliballbad(allbadIWCTscnlin_ch1(indexbad))=1;
                                            iwct_mean(allbadIWCTscnlin_ch1(indexbad),1)=nan;
                                        end

                                    end
                                else
                                    excludechannel(1)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(1)=1; % proceed without using this channel
                                onlygoodIWCTscnlin_ch1=nan;
                            end
                            
                            % SET FLAGS for allbadIWCT
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadIWCT(1,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadIWCT(1,allbadIWCTscnlin_ch1)=1;
     
                            
                             %%%%% channel 2
                            sumofweightsIWCT_ch2=sum(weightIWCTview_ch2(:,:),1);
                            sumtoosmall_1=find(sumofweightsIWCT_ch2<2);
                            iwct_mean(sumtoosmall_2,2)=nan;
                            iwct_mean(:,2)=1./sumofweightsIWCT_ch2 .*(weightIWCTview_ch2(1,:).*double(iwct1ch2)+weightIWCTview_ch2(2,:).*double(iwct2ch2)+weightIWCTview_ch2(3,:).*double(iwct3ch2)+weightIWCTview_ch2(4,:).*double(iwct4ch2));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch2,badlinesjump_ch2]=filter_plateausANDpeaks(iwct_mean(:,2),jump_thr(2));
                                                      
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limitIWCT_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch2=find((abs(min(iwctch2.')-max(iwctch2.'))>=limitIWCT_ch2));
                            allbadIWCTscnlin_ch2=union(union(double(find(sumofweightsIWCT_ch2<2)),badlines_ch2),badlinesjump_ch2);
                            goodIWCTscnlin_ch2=double(setdiff(scanlinenumbers,allbadIWCTscnlin_ch2));
                            if ~isempty(goodIWCTscnlin_ch2) %check whether there are any good lines
                                onlygoodIWCTscnlin_ch2=double(setdiff(goodIWCTscnlin_ch2,marginalIWCTscnlin_ch2)); %look for lines with "all IWCT views good"
                                if length(onlygoodIWCTscnlin_ch2)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadIWCTscnlin_ch2) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodIWCTscnlin_ch2-allbadIWCTscnlin_ch2(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            iwct_mean(allbadIWCTscnlin_ch2(indexbad),2)=median(iwct_mean(goodIWCTscnlin_ch2(sortedloc(1:num_closestlines)),2)); %iwct_mean(badline,channel)=median(iwct_mean("close goodlines",channel)); the close goodlines are the closest goodline and the two goodlines before and after
                                            qualflag_IWCT_ch2_5closest(allbadIWCTscnlin_ch2(indexbad))=1;
                                        else
                                            qualflag_IWCT_ch2_nocaliballbad(allbadIWCTscnlin_ch2(indexbad))=1;
                                            iwct_mean(allbadIWCTscnlin_ch2(indexbad),2)=nan;
                                            
                                        end

                                    end
                                else
                                    excludechannel(2)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(2)=1; % proceed without using this channel
                                onlygoodIWCTscnlin_ch2=nan;
                            end
                            
                            % SET FLAGS for allbadIWCT
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadIWCT(2,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadIWCT(2,allbadIWCTscnlin_ch2)=1;
                            
                           
                             %%%%% channel 3
                            sumofweightsIWCT_ch3=sum(weightIWCTview_ch3(:,:),1);
                            sumtoosmall_3=find(sumofweightsIWCT_ch3<2);
                            iwct_mean(sumtoosmall_3,3)=nan;
                            iwct_mean(:,3)=1./sumofweightsIWCT_ch3 .*(weightIWCTview_ch3(1,:).*double(iwct1ch3)+weightIWCTview_ch3(2,:).*double(iwct2ch3)+weightIWCTview_ch3(3,:).*double(iwct3ch3)+weightIWCTview_ch3(4,:).*double(iwct4ch3));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus, filter these and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch3,badlinesjump_ch3]=filter_plateausANDpeaks(iwct_mean(:,3),jump_thr(3));
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limitIWCT_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch3=find((abs(min(iwctch3.')-max(iwctch3.'))>=limitIWCT_ch3));
                            allbadIWCTscnlin_ch3=union(union(double(find(sumofweightsIWCT_ch3<2)),badlines_ch3),badlinesjump_ch3);
                            goodIWCTscnlin_ch3=double(setdiff(scanlinenumbers,allbadIWCTscnlin_ch3));
                            if ~isempty(goodIWCTscnlin_ch3) %check whter there are any good lines
                                onlygoodIWCTscnlin_ch3=double(setdiff(goodIWCTscnlin_ch3,marginalIWCTscnlin_ch3)); %look for lines with "all IWCT views good"
                                if length(onlygoodIWCTscnlin_ch3)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadIWCTscnlin_ch3) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodIWCTscnlin_ch3-allbadIWCTscnlin_ch3(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            iwct_mean(allbadIWCTscnlin_ch3(indexbad),3)=median(iwct_mean(goodIWCTscnlin_ch3(sortedloc(1:num_closestlines)),3)); %iwct_mean(badline,channel)=median(iwct_mean("close goodlines",channel)); the close goodlines are the closest goodline and the two goodlines before and after
                                            qualflag_IWCT_ch3_5closest(allbadIWCTscnlin_ch3(indexbad))=1;
                                        else
                                            qualflag_IWCT_ch3_nocaliballbad(allbadIWCTscnlin_ch3(indexbad))=1;
                                            iwct_mean(allbadIWCTscnlin_ch3(indexbad),3)=nan;
                                        end

                                    end
                                else
                                    excludechannel(3)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(3)=1; % proceed without using this channel
                                onlygoodIWCTscnlin_ch3=nan;
                            end
                            
                            % SET FLAGS for allbadIWCT
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadIWCT(3,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadIWCT(3,allbadIWCTscnlin_ch3)=1;
                            
                            
                            %%%%% channel 4
                            sumofweightsIWCT_ch4=sum(weightIWCTview_ch4(:,:),1);
                            sumtoosmall_4=find(sumofweightsIWCT_ch4<2);
                            iwct_mean(sumtoosmall_4,4)=nan;
                            iwct_mean(:,4)=1./sumofweightsIWCT_ch4 .*(weightIWCTview_ch4(1,:).*double(iwct1ch4)+weightIWCTview_ch4(2,:).*double(iwct2ch4)+weightIWCTview_ch4(3,:).*double(iwct3ch4)+weightIWCTview_ch4(4,:).*double(iwct4ch4));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch4,badlinesjump_ch4]=filter_plateausANDpeaks(iwct_mean(:,4),jump_thr(4));
                            
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limitIWCT_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch4=find((abs(min(iwctch4.')-max(iwctch4.'))>=limitIWCT_ch4));
                            allbadIWCTscnlin_ch4=union(union(double(find(sumofweightsIWCT_ch4<2)),badlines_ch4),badlinesjump_ch4);
                            goodIWCTscnlin_ch4=double(setdiff(scanlinenumbers,allbadIWCTscnlin_ch4));
                            if ~isempty(goodIWCTscnlin_ch4) %check whter there are any good lines
                                onlygoodIWCTscnlin_ch4=double(setdiff(goodIWCTscnlin_ch4,marginalIWCTscnlin_ch4)); %look for lines with "all IWCT views good"
                                if length(onlygoodIWCTscnlin_ch4)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadIWCTscnlin_ch4) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodIWCTscnlin_ch4-allbadIWCTscnlin_ch4(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            iwct_mean(allbadIWCTscnlin_ch4(indexbad),4)=median(iwct_mean(goodIWCTscnlin_ch4(sortedloc(1:num_closestlines)),4)); %iwct_mean(badline,channel)=median(iwct_mean("close goodlines",channel)); the close goodlines are the closest goodline and the two goodlines before and after
                                            qualflag_IWCT_ch4_5closest(allbadIWCTscnlin_ch4(indexbad))=1;
                                        else
                                            qualflag_IWCT_ch4_nocaliballbad(allbadIWCTscnlin_ch4(indexbad))=1;
                                            iwct_mean(allbadIWCTscnlin_ch4(indexbad),4)=nan;
                                        end

                                    end
                                else
                                    excludechannel(4)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(4)=1; % proceed without using this channel
                                onlygoodIWCTscnlin_ch4=nan;
                            end
                            
                            
                            % SET FLAGS for allbadIWCT
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadIWCT(4,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadIWCT(4,allbadIWCTscnlin_ch4)=1;
                            
                            
                            %%%%% channel 5
                            sumofweightsIWCT_ch5=sum(weightIWCTview_ch5(:,:),1);
                            sumtoosmall_5=find(sumofweightsIWCT_ch5<2);
                            iwct_mean(sumtoosmall_5,5)=nan;
                            iwct_mean(:,5)=1./sumofweightsIWCT_ch5 .*(weightIWCTview_ch5(1,:).*double(iwct1ch5)+weightIWCTview_ch5(2,:).*double(iwct2ch5)+weightIWCTview_ch5(3,:).*double(iwct3ch5)+weightIWCTview_ch5(4,:).*double(iwct4ch5));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch5,badlinesjump_ch5]=filter_plateausANDpeaks(iwct_mean(:,5),jump_thr(5));
                            
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limitIWCT_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch5=find((abs(min(iwctch5.')-max(iwctch5.'))>=limitIWCT_ch5));
                            allbadIWCTscnlin_ch5=union(union(double(find(sumofweightsIWCT_ch5<2)),badlines_ch5),badlinesjump_ch5);
                            goodIWCTscnlin_ch5=double(setdiff(scanlinenumbers,allbadIWCTscnlin_ch5));
                            if ~isempty(goodIWCTscnlin_ch5) %check whter there are any good lines
                                onlygoodIWCTscnlin_ch5=double(setdiff(goodIWCTscnlin_ch5,marginalIWCTscnlin_ch5)); %look for lines with "all IWCT views good"
                                if length(onlygoodIWCTscnlin_ch5)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadIWCTscnlin_ch5) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodIWCTscnlin_ch5-allbadIWCTscnlin_ch5(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            iwct_mean(allbadIWCTscnlin_ch5(indexbad),5)=median(iwct_mean(goodIWCTscnlin_ch5(sortedloc(1:num_closestlines)),5)); %iwct_mean(badline,channel)=median(iwct_mean("close goodlines",channel)); the close goodlines are the closest goodline and the two goodlines before and after
                                            qualflag_IWCT_ch5_5closest(allbadIWCTscnlin_ch5(indexbad))=1;
                                        else
                                            qualflag_IWCT_ch5_nocaliballbad(allbadIWCTscnlin_ch5(indexbad))=1;
                                            iwct_mean(allbadIWCTscnlin_ch5(indexbad),5)=nan;
                                        end

                                    end
                                else
                                    excludechannel(5)=1; % proceed without using this channel
                                    
                                end
                                
                            else
                                excludechannel(5)=1; % proceed without using this channel
                                onlygoodIWCTscnlin_ch5=nan;
                            end
                            
                            
                            % SET FLAGS for allbadIWCT
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadIWCT(5,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadIWCT(5,allbadIWCTscnlin_ch5)=1;
                            
                            
                            qualflag_IWCTgoodlinbfjump=zeros(5,length(data.scan_line_year));
                            qualflag_IWCTgoodlinbfjump(1,goodline_before_jump_ch1)=1;
                            qualflag_IWCTgoodlinbfjump(2,goodline_before_jump_ch2)=1;
                            qualflag_IWCTgoodlinbfjump(3,goodline_before_jump_ch3)=1;
                            qualflag_IWCTgoodlinbfjump(4,goodline_before_jump_ch4)=1;
                            qualflag_IWCTgoodlinbfjump(5,goodline_before_jump_ch5)=1;
                            
                            
                            
                            % set the set of usable channels
                            channelset_iwct=find(~excludechannel);
                            
                            excludechannel=0*excludechannel; %reset the values