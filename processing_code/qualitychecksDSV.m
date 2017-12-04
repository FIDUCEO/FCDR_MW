




%%%%% Quality check for DSV counts %%%%

excludechannel=zeros(5,1); %initialize "excludechannel" with zeros everywhere: "all channels usable"
qualflag_DSV_ch1_5closest=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch1_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch2_5closest=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch2_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch3_5closest=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch3_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch4_5closest=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch4_nocaliballbad=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch5_5closest=zeros(length(data.scan_line_year),1);
qualflag_DSV_ch5_nocaliballbad=zeros(length(data.scan_line_year),1);

num_closestlines=5; % set the number of closest good scanline that shall be taken to replace a badscanline

                            dsv_meanOLD=dsv_mean;

                            dsvch1median=median(dsvch1,2);
                            dsvch2median=median(dsvch2,2);
                            dsvch3median=median(dsvch3,2);
                            dsvch4median=median(dsvch4,2);
                            dsvch5median=median(dsvch5,2);
                            
                            
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
                            % the course of all 4 DSV. Let's take as new
                            % threshold 3*sigma, with
                            % sigma=u_C_S=countNoise (from AllanDev, 1 value per orbit, same value for all scanlines).
                            % maybe 3*sigma is still too small.
                            count_medianthr_ch1=3*dsvcountallandev_med(1,1);
                            count_medianthr_ch2=3*dsvcountallandev_med(1,2);
                            count_medianthr_ch3=3*dsvcountallandev_med(1,3);
                            count_medianthr_ch4=3*dsvcountallandev_med(1,4);
                            count_medianthr_ch5=3*dsvcountallandev_med(1,5);
                            
                            
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
                            
%                             % limits for DSV counts
%                             if strcmp(selectinstrument,'mhs')
%                             count_thrdsv_ch1=[1500 28000];
%                             count_thrdsv_ch2=[1500 28000];
%                             count_thrdsv_ch3=[1500 28000];
%                             count_thrdsv_ch4=[1500 28000];
%                             count_thrdsv_ch5=[1500 28000];
%                             elseif strcmp(selectinstrument,'amsub') %per flightmodel, i.e. N15,16,17 are different!!
%                             count_thrdsv_ch1=[15000 23000];%[15000 28000];
%                             count_thrdsv_ch2=[15000 23000];%[15000 28000];
%                             count_thrdsv_ch3=[23000 35000];%[2000 28000];
%                             count_thrdsv_ch4=[15000 23000];%[2000 28000];
%                             count_thrdsv_ch5=[15000 23000];%[2000 28000];
%                             end

                            % limit for difference of max and min-value for
                            % 4 views in one scan line (5*sigma according to EUMETSAT MHS prod gen spec)
                            limitDSV_ch1=5*dsvcountallandev_med(1,1);
                            limitDSV_ch2=5*dsvcountallandev_med(1,2);
                            limitDSV_ch3=5*dsvcountallandev_med(1,3);
                            limitDSV_ch4=5*dsvcountallandev_med(1,4);
                            limitDSV_ch5=5*dsvcountallandev_med(1,5);
                            
                            %%%%%%%% channel 1
                            % median test
                            weightDSVview_mediantest_ch1(1,:)=(abs(dsvch1median-dsvch1(:,1))<=count_medianthr_ch1); %if the difference of the 
                            %current DSVview1 measurement and the median of the DSV measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightDSVview_mediantest_ch1(2,:)=(abs(dsvch1median-dsvch1(:,2))<=count_medianthr_ch1);
                            weightDSVview_mediantest_ch1(3,:)=(abs(dsvch1median-dsvch1(:,3))<=count_medianthr_ch1);
                            weightDSVview_mediantest_ch1(4,:)=(abs(dsvch1median-dsvch1(:,4))<=count_medianthr_ch1);
                          
                            % threshold test
                            weightDSVview_thresholdtest_ch1=(count_thrdsv_ch1(1)<dsvch1 & dsvch1<count_thrdsv_ch1(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightDSVview_ch1(1,:)=min(weightDSVview_thresholdtest_ch1(:,1).',weightDSVview_mediantest_ch1(1,:)); 
                            weightDSVview_ch1(2,:)=min(weightDSVview_thresholdtest_ch1(:,2).',weightDSVview_mediantest_ch1(2,:));
                            weightDSVview_ch1(3,:)=min(weightDSVview_thresholdtest_ch1(:,3).',weightDSVview_mediantest_ch1(3,:));
                            weightDSVview_ch1(4,:)=min(weightDSVview_thresholdtest_ch1(:,4).',weightDSVview_mediantest_ch1(4,:));
                            
                            %find scan lines for which at least some of the DSVs are bad
                            marginalDSVscnlin_ch1=sort([find(~weightDSVview_ch1(1,:)),find(~weightDSVview_ch1(2,:)),find(~weightDSVview_ch1(3,:)),find(~weightDSVview_ch1(4,:))]);
                            % SET FLAG for marginalbadDSV_ch1-flag.
                            qualflag_marginalDSV(1,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalDSV(1,marginalDSVscnlin_ch1)=1;
                                                       
                            %%%%%%%% channel 2
                            % median test
                            weightDSVview_mediantest_ch2(1,:)=(abs(dsvch2median-dsvch2(:,1))<=count_medianthr_ch2); %if the difference of the 
                            %current DSVview1 measurement and the median of the DSV measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightDSVview_mediantest_ch2(2,:)=(abs(dsvch2median-dsvch2(:,2))<=count_medianthr_ch2);
                            weightDSVview_mediantest_ch2(3,:)=(abs(dsvch2median-dsvch2(:,3))<=count_medianthr_ch2);
                            weightDSVview_mediantest_ch2(4,:)=(abs(dsvch2median-dsvch2(:,4))<=count_medianthr_ch2);
                          
                            % threshold test
                            weightDSVview_thresholdtest_ch2=(count_thrdsv_ch2(1)<dsvch2 & dsvch2<count_thrdsv_ch2(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightDSVview_ch2(1,:)=min(weightDSVview_thresholdtest_ch2(:,1).',weightDSVview_mediantest_ch2(1,:)); 
                            weightDSVview_ch2(2,:)=min(weightDSVview_thresholdtest_ch2(:,2).',weightDSVview_mediantest_ch2(2,:));
                            weightDSVview_ch2(3,:)=min(weightDSVview_thresholdtest_ch2(:,3).',weightDSVview_mediantest_ch2(3,:));
                            weightDSVview_ch2(4,:)=min(weightDSVview_thresholdtest_ch2(:,4).',weightDSVview_mediantest_ch2(4,:));
                            
                            %find scan lines for which at least some of the DSVs are bad
                            marginalDSVscnlin_ch2=sort([find(~weightDSVview_ch2(1,:)),find(~weightDSVview_ch2(2,:)),find(~weightDSVview_ch2(3,:)),find(~weightDSVview_ch2(4,:))]);
                            % SET FLAG for marginalbadDSV_ch2-flag.
                            qualflag_marginalDSV(2,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalDSV(2,marginalDSVscnlin_ch2)=1;
                            
                            
                            %%%%%%%% channel 3
                            % median test
                            weightDSVview_mediantest_ch3(1,:)=(abs(dsvch3median-dsvch3(:,1))<=count_medianthr_ch3); %if the difference of the 
                            %current DSVview1 measurement and the median of the DSV measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightDSVview_mediantest_ch3(2,:)=(abs(dsvch3median-dsvch3(:,2))<=count_medianthr_ch3);
                            weightDSVview_mediantest_ch3(3,:)=(abs(dsvch3median-dsvch3(:,3))<=count_medianthr_ch3);
                            weightDSVview_mediantest_ch3(4,:)=(abs(dsvch3median-dsvch3(:,4))<=count_medianthr_ch3);
                          
                            % threshold test
                            weightDSVview_thresholdtest_ch3=(count_thrdsv_ch3(1)<dsvch3 & dsvch3<count_thrdsv_ch3(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightDSVview_ch3(1,:)=min(weightDSVview_thresholdtest_ch3(:,1).',weightDSVview_mediantest_ch3(1,:)); 
                            weightDSVview_ch3(2,:)=min(weightDSVview_thresholdtest_ch3(:,2).',weightDSVview_mediantest_ch3(2,:));
                            weightDSVview_ch3(3,:)=min(weightDSVview_thresholdtest_ch3(:,3).',weightDSVview_mediantest_ch3(3,:));
                            weightDSVview_ch3(4,:)=min(weightDSVview_thresholdtest_ch3(:,4).',weightDSVview_mediantest_ch3(4,:));
                            
                            %find scan lines for which at least some of the DSVs are bad
                            marginalDSVscnlin_ch3=sort([find(~weightDSVview_ch3(1,:)),find(~weightDSVview_ch3(2,:)),find(~weightDSVview_ch3(3,:)),find(~weightDSVview_ch3(4,:))]);
                            % SET FLAG for marginalbadDSV_ch3-flag.
                            qualflag_marginalDSV(3,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalDSV(3,marginalDSVscnlin_ch1)=1;
                            
                            %%%%%%%% channel 4
                            % median test
                            weightDSVview_mediantest_ch4(1,:)=(abs(dsvch4median-dsvch4(:,1))<=count_medianthr_ch4); %if the difference of the 
                            %current DSVview1 measurement and the median of the DSV measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightDSVview_mediantest_ch4(2,:)=(abs(dsvch4median-dsvch4(:,2))<=count_medianthr_ch4);
                            weightDSVview_mediantest_ch4(3,:)=(abs(dsvch4median-dsvch4(:,3))<=count_medianthr_ch4);
                            weightDSVview_mediantest_ch4(4,:)=(abs(dsvch4median-dsvch4(:,4))<=count_medianthr_ch4);
                          
                            % threshold test
                            weightDSVview_thresholdtest_ch4=(count_thrdsv_ch4(1)<dsvch4 & dsvch4<count_thrdsv_ch4(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightDSVview_ch4(1,:)=min(weightDSVview_thresholdtest_ch4(:,1).',weightDSVview_mediantest_ch4(1,:)); 
                            weightDSVview_ch4(2,:)=min(weightDSVview_thresholdtest_ch4(:,2).',weightDSVview_mediantest_ch4(2,:));
                            weightDSVview_ch4(3,:)=min(weightDSVview_thresholdtest_ch4(:,3).',weightDSVview_mediantest_ch4(3,:));
                            weightDSVview_ch4(4,:)=min(weightDSVview_thresholdtest_ch4(:,4).',weightDSVview_mediantest_ch4(4,:));
                            
                            %find scan lines for which at least some of the DSVs are bad
                            marginalDSVscnlin_ch4=sort([find(~weightDSVview_ch4(1,:)),find(~weightDSVview_ch4(2,:)),find(~weightDSVview_ch4(3,:)),find(~weightDSVview_ch4(4,:))]);
                            % SET FLAG for marginalbadDSV_ch4-flag.
                            qualflag_marginalDSV(4,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalDSV(4,marginalDSVscnlin_ch4)=1;
                            
                            %%%%%%% channel 5
                            % median test
                            weightDSVview_mediantest_ch5(1,:)=(abs(dsvch5median-dsvch5(:,1))<=count_medianthr_ch5); %if the difference of the 
                            %current DSVview1 measurement and the median of the DSV measurements of the scan line 
                            %is larger than 50 Counts, then the weight is set to zero. Otherwise it is 1.
                            weightDSVview_mediantest_ch5(2,:)=(abs(dsvch5median-dsvch5(:,2))<=count_medianthr_ch5);
                            weightDSVview_mediantest_ch5(3,:)=(abs(dsvch5median-dsvch5(:,3))<=count_medianthr_ch5);
                            weightDSVview_mediantest_ch5(4,:)=(abs(dsvch5median-dsvch5(:,4))<=count_medianthr_ch5);
                          
                            % threshold test
                            weightDSVview_thresholdtest_ch5=(count_thrdsv_ch5(1)<dsvch5 & dsvch5<count_thrdsv_ch5(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weightDSVview_ch5(1,:)=min(weightDSVview_thresholdtest_ch5(:,1).',weightDSVview_mediantest_ch5(1,:)); 
                            weightDSVview_ch5(2,:)=min(weightDSVview_thresholdtest_ch5(:,2).',weightDSVview_mediantest_ch5(2,:));
                            weightDSVview_ch5(3,:)=min(weightDSVview_thresholdtest_ch5(:,3).',weightDSVview_mediantest_ch5(3,:));
                            weightDSVview_ch5(4,:)=min(weightDSVview_thresholdtest_ch5(:,4).',weightDSVview_mediantest_ch5(4,:));
                            
                            %find scan lines for which at least some of the DSVs are bad
                            marginalDSVscnlin_ch5=sort([find(~weightDSVview_ch5(1,:)),find(~weightDSVview_ch5(2,:)),find(~weightDSVview_ch5(3,:)),find(~weightDSVview_ch5(4,:))]);
                            % SET FLAG for marginalbadDSV_ch5-flag.
                            qualflag_marginalDSV(5,:)=zeros(length(data.scan_line_year),1);
                            qualflag_marginalDSV(5,marginalDSVscnlin_ch5)=1;
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            % COMPUTE mean of good DSV sensors:
                            
                            % weighted mean of DSV counts = DSVcounts at
                            % certain scanline
                            % use weights obtained from
                            % quality check.
                            
                            %%%%% channel 1
                            sumofweightsDSV_ch1=sum(weightDSVview_ch1(:,:),1);
                            sumtoosmall_1=find(sumofweightsDSV_ch1<2);
                            dsv_mean(sumtoosmall_1,1)=nan;
                            dsv_mean(:,1)=1./sumofweightsDSV_ch1 .*(weightDSVview_ch1(1,:).*double(dsv1ch1)+weightDSVview_ch1(2,:).*double(dsv2ch1)+weightDSVview_ch1(3,:).*double(dsv3ch1)+weightDSVview_ch1(4,:).*double(dsv4ch1));
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch1,badlinesjump_ch1]=filter_plateausANDpeaks(dsv_mean(:,1),jump_thr(1));
                            
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limit_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch1=find((abs(min(dsvch1.')-max(dsvch1.'))>=limitDSV_ch1));
                            allbadDSVscnlin_ch1=union(union(double(find(sumofweightsDSV_ch1<2)),badlines_ch1),badlinesjump_ch1);
                            goodDSVscnlin_ch1=double(setdiff(scanlinenumbers,allbadDSVscnlin_ch1));
                            if ~isempty(goodDSVscnlin_ch1) %check whter there are any good lines
                                onlygoodDSVscnlin_ch1=double(setdiff(goodDSVscnlin_ch1,marginalDSVscnlin_ch1)); %look for lines with "all DSV views good"
                                if length(onlygoodDSVscnlin_ch1)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadDSVscnlin_ch1) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodDSVscnlin_ch1-allbadDSVscnlin_ch1(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            dsv_mean(allbadDSVscnlin_ch1(indexbad),1)=median(dsv_mean(goodDSVscnlin_ch1(sortedloc(1:num_closestlines)),1)); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTlines,channel);
                                            %this is also done for missing scanlines! i.e. the DSV and DSV counts are estimated.
                                            %But since there are no C_E, the calibration is not possible and there are NaNs in btemps which are converted to fillvalue with change-type.
                            
                                            qualflag_DSV_ch1_5closest(allbadDSVscnlin_ch1(indexbad))=1;
                                        else
                                            qualflag_DSV_ch1_nocaliballbad(allbadDSVscnlin_ch1(indexbad))=1;
                                            dsv_mean(allbadDSVscnlin_ch1(indexbad),1)=nan;
                                        end

                                    end
                                else
                                    excludechannel(1)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(1)=1; % proceed without using this channel
                                onlygoodDSVscnlin_ch1=nan;
                            end
                            
                            
                            
%                             onlygoodDSVscnlin_ch1=double(setdiff(goodDSVscnlin_ch1,marginalDSVscnlin_ch1));
%                             for indexbad=1:length(allbadDSVscnlin_ch1)
%                                 
%                                 [minval,loc]=min(abs(goodDSVscnlin_ch1-allbadDSVscnlin_ch1(indexbad)));
%                                 dsv_mean(allbadDSVscnlin_ch1(indexbad),1)=dsv_mean(goodDSVscnlin_ch1(loc),1); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel); 
%                                 %this is also done for missing scanlines! i.e. the DSV and DSV counts are estimated.
%                                 %But since there are no C_E, the calibration is not possible and there are NaNs in btemps which are converted to fillvalue with change-type.
%                             end
                            
                            
                            % SET FLAGS for allbadDSV
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadDSV(1,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadDSV(1,allbadDSVscnlin_ch1)=1;
     
                            
                             %%%%% channel 2
                            sumofweightsDSV_ch2=sum(weightDSVview_ch2(:,:),1);
                            sumtoosmall_2=find(sumofweightsDSV_ch2<2);
                            dsv_mean(sumtoosmall_2,2)=nan;
                            dsv_mean(:,2)=1./sumofweightsDSV_ch2 .*(weightDSVview_ch2(1,:).*double(dsv1ch2)+weightDSVview_ch2(2,:).*double(dsv2ch2)+weightDSVview_ch2(3,:).*double(dsv3ch2)+weightDSVview_ch2(4,:).*double(dsv4ch2));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch2,badlinesjump_ch2]=filter_plateausANDpeaks(dsv_mean(:,2),jump_thr(2));
                            
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limit_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch2=find((abs(min(dsvch2.')-max(dsvch2.'))>=limitDSV_ch2));
                            allbadDSVscnlin_ch2=union(union(double(find(sumofweightsDSV_ch2<2)),badlines_ch2),badlinesjump_ch2);
                            goodDSVscnlin_ch2=double(setdiff(scanlinenumbers,allbadDSVscnlin_ch2));
                            
                            if ~isempty(goodDSVscnlin_ch2) %check whter there are any good lines
                                onlygoodDSVscnlin_ch2=double(setdiff(goodDSVscnlin_ch2,marginalDSVscnlin_ch2)); %look for lines with "all DSV views good"
                                if length(onlygoodDSVscnlin_ch2)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadDSVscnlin_ch2) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodDSVscnlin_ch2-allbadDSVscnlin_ch2(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            dsv_mean(allbadDSVscnlin_ch2(indexbad),2)=median(dsv_mean(goodDSVscnlin_ch2(sortedloc(1:num_closestlines)),2)); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
                                            qualflag_DSV_ch2_5closest(allbadDSVscnlin_ch2(indexbad))=1;
                                        else
                                            qualflag_DSV_ch2_nocaliballbad(allbadDSVscnlin_ch2(indexbad))=1;
                                            dsv_mean(allbadDSVscnlin_ch2(indexbad),2)=nan;
                                        end

                                    end
                                else
                                    excludechannel(2)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(2)=1; % proceed without using this channel
                                onlygoodDSVscnlin_ch2=nan;
                            end
                            
                            
%                             onlygoodDSVscnlin_ch2=double(setdiff(goodDSVscnlin_ch2,marginalDSVscnlin_ch2));
%                             for indexbad=1:length(allbadDSVscnlin_ch2)
%                                 
%                                 [minval,loc]=min(abs(goodDSVscnlin_ch2-allbadDSVscnlin_ch2(indexbad)));
%                                 dsv_mean(allbadDSVscnlin_ch2(indexbad),2)=dsv_mean(goodDSVscnlin_ch2(loc),2); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
%                             end
                            
                            
                            % SET FLAGS for allbadDSV
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadDSV(2,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadDSV(2,allbadDSVscnlin_ch2)=1;
                            
                           
                             %%%%% channel 3
                            sumofweightsDSV_ch3=sum(weightDSVview_ch3(:,:),1);
                            sumtoosmall_3=find(sumofweightsDSV_ch3<2);
                            dsv_mean(sumtoosmall_3,3)=nan;
                            dsv_mean(:,3)=1./sumofweightsDSV_ch3 .*(weightDSVview_ch3(1,:).*double(dsv1ch3)+weightDSVview_ch3(2,:).*double(dsv2ch3)+weightDSVview_ch3(3,:).*double(dsv3ch3)+weightDSVview_ch3(4,:).*double(dsv4ch3));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch3,badlinesjump_ch3]=filter_plateausANDpeaks(dsv_mean(:,3),jump_thr(3));
                            
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limit_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch3=find((abs(min(dsvch3.')-max(dsvch3.'))>=limitDSV_ch3));
                            allbadDSVscnlin_ch3=union(union(double(find(sumofweightsDSV_ch3<2)),badlines_ch3),badlinesjump_ch3);
                            goodDSVscnlin_ch3=double(setdiff(scanlinenumbers,allbadDSVscnlin_ch3));
                            
                            if ~isempty(goodDSVscnlin_ch3) %check whter there are any good lines
                                onlygoodDSVscnlin_ch3=double(setdiff(goodDSVscnlin_ch3,marginalDSVscnlin_ch3)); %look for lines with "all DSV views good"
                                if length(onlygoodDSVscnlin_ch3)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadDSVscnlin_ch3) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodDSVscnlin_ch3-allbadDSVscnlin_ch3(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            dsv_mean(allbadDSVscnlin_ch3(indexbad),3)=median(dsv_mean(goodDSVscnlin_ch3(sortedloc(1:num_closestlines)),3)); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
                                            qualflag_DSV_ch3_5closest(allbadDSVscnlin_ch3(indexbad))=1;
                                        else
                                            qualflag_DSV_ch3_nocaliballbad(allbadDSVscnlin_ch3(indexbad))=1;
                                            dsv_mean(allbadDSVscnlin_ch3(indexbad),3)=nan;
                                        end

                                    end
                                else
                                    excludechannel(3)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(3)=1; % proceed without using this channel
                                onlygoodDSVscnlin_ch3=nan;
                            end
                            
%                             onlygoodDSVscnlin_ch3=double(setdiff(goodDSVscnlin_ch3,marginalDSVscnlin_ch3));
%                             for indexbad=1:length(allbadDSVscnlin_ch3)
%                                 
%                                 [minval,loc]=min(abs(goodDSVscnlin_ch3-allbadDSVscnlin_ch3(indexbad)));
%                                 dsv_mean(allbadDSVscnlin_ch3(indexbad),3)=dsv_mean(goodDSVscnlin_ch3(loc),3); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
%                             end
                            
                            
                            % SET FLAGS for allbadDSV
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadDSV(3,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadDSV(3,allbadDSVscnlin_ch3)=1;
                            
                            
                            %%%%% channel 4
                            sumofweightsDSV_ch4=sum(weightDSVview_ch4(:,:),1);
                            sumtoosmall_4=find(sumofweightsDSV_ch4<2);
                            dsv_mean(sumtoosmall_4,4)=nan;
                            dsv_mean(:,4)=1./sumofweightsDSV_ch4 .*(weightDSVview_ch4(1,:).*double(dsv1ch4)+weightDSVview_ch4(2,:).*double(dsv2ch4)+weightDSVview_ch4(3,:).*double(dsv3ch4)+weightDSVview_ch4(4,:).*double(dsv4ch4));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch4,badlinesjump_ch4]=filter_plateausANDpeaks(dsv_mean(:,4),jump_thr(4));
                            
                            
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limit_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch4=find((abs(min(dsvch4.')-max(dsvch4.'))>=limitDSV_ch4));
                            allbadDSVscnlin_ch4=union(union(double(find(sumofweightsDSV_ch4<2)),badlines_ch4),badlinesjump_ch4);
                            goodDSVscnlin_ch4=double(setdiff(scanlinenumbers,allbadDSVscnlin_ch4));
                            
                            if ~isempty(goodDSVscnlin_ch4) %check whter there are any good lines
                                onlygoodDSVscnlin_ch4=double(setdiff(goodDSVscnlin_ch4,marginalDSVscnlin_ch4)); %look for lines with "all DSV views good"
                                if length(onlygoodDSVscnlin_ch4)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadDSVscnlin_ch4) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodDSVscnlin_ch4-allbadDSVscnlin_ch4(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            dsv_mean(allbadDSVscnlin_ch4(indexbad),4)=median(dsv_mean(goodDSVscnlin_ch4(sortedloc(1:num_closestlines)),4)); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
                                            qualflag_DSV_ch4_5closest(allbadDSVscnlin_ch4(indexbad))=1;
                                        else
                                            qualflag_DSV_ch4_nocaliballbad(allbadDSVscnlin_ch4(indexbad))=1;
                                            dsv_mean(allbadDSVscnlin_ch4(indexbad),4)=nan;
                                        end

                                    end
                                else
                                    excludechannel(4)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(4)=1; % proceed without using this channel
                                onlygoodDSVscnlin_ch4=nan;
                            end
                            
%                             onlygoodDSVscnlin_ch4=double(setdiff(goodDSVscnlin_ch4,marginalDSVscnlin_ch4));
%                             for indexbad=1:length(allbadDSVscnlin_ch4)
%                                 
%                                 [minval,loc]=min(abs(goodDSVscnlin_ch4-allbadDSVscnlin_ch4(indexbad)));
%                                 dsv_mean(allbadDSVscnlin_ch4(indexbad),4)=dsv_mean(goodDSVscnlin_ch4(loc),4); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
%                             end
                            
                            
                            % SET FLAGS for allbadDSV
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadDSV(4,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadDSV(4,allbadDSVscnlin_ch4)=1;
                            
                            
                            %%%%% channel 5
                            sumofweightsDSV_ch5=sum(weightDSVview_ch5(:,:),1);
                            sumtoosmall_5=find(sumofweightsDSV_ch5<2);
                            dsv_mean(sumtoosmall_5,5)=nan;
                            dsv_mean(:,5)=1./sumofweightsDSV_ch5 .*(weightDSVview_ch5(1,:).*double(dsv1ch5)+weightDSVview_ch5(2,:).*double(dsv2ch5)+weightDSVview_ch5(3,:).*double(dsv3ch5)+weightDSVview_ch5(4,:).*double(dsv4ch5));                            
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ch5,badlinesjump_ch5]=filter_plateausANDpeaks(dsv_mean(:,5),jump_thr(5));
                            
                            
                            % If sumofweights< 2, i.e.  less than 2 views
                            % give good values, then flag this line as
                            % "allviews bad". Also flags the line as "all
                            % views bad" if min and max valuefor one scan
                            % line differ by more than limit_chX. For all
                            % scan lines flagged as "all views bad" use the
                            % closest good scan line for calibration.
                          
                            badlines_ch5=find((abs(min(dsvch5.')-max(dsvch5.'))>=limitDSV_ch5));
                            allbadDSVscnlin_ch5=union(union(double(find(sumofweightsDSV_ch5<2)),badlines_ch5),badlinesjump_ch5);
                            goodDSVscnlin_ch5=double(setdiff(scanlinenumbers,allbadDSVscnlin_ch5));
                            
                            if ~isempty(goodDSVscnlin_ch5) %check whter there are any good lines
                                onlygoodDSVscnlin_ch5=double(setdiff(goodDSVscnlin_ch5,marginalDSVscnlin_ch5)); %look for lines with "all DSV views good"
                                if length(onlygoodDSVscnlin_ch5)>300 %check whether there are more than 300 such lines (only then we can perform the AllanDev.)
                                    for indexbad=1:length(allbadDSVscnlin_ch5) % go through all bad scanlines

                                        [sorted,sortedloc]=sort(abs(goodDSVscnlin_ch5-allbadDSVscnlin_ch5(indexbad)));%check for the next good scanlines adjacent to the bad one, i.e sort the differences; then take the num_closestlines (e.g.=5) closest goodlines
                                        if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            dsv_mean(allbadDSVscnlin_ch5(indexbad),5)=median(dsv_mean(goodDSVscnlin_ch5(sortedloc(1:num_closestlines)),5)); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
                                            qualflag_DSV_ch5_5closest(allbadDSVscnlin_ch5(indexbad))=1;
                                        else
                                            qualflag_DSV_ch5_nocaliballbad(allbadDSVscnlin_ch5(indexbad))=1;
                                            dsv_mean(allbadDSVscnlin_ch5(indexbad),5)=nan;
                                        end

                                    end
                                else
                                    excludechannel(5)=1; % proceed without using this channel
                                end
                                
                            else
                                excludechannel(5)=1; % proceed without using this channel
                                onlygoodDSVscnlin_ch5=nan;
                            end
                            
%                             onlygoodDSVscnlin_ch5=double(setdiff(goodDSVscnlin_ch5,marginalDSVscnlin_ch5));
%                             for indexbad=1:length(allbadDSVscnlin_ch5)
%                                 
%                                 [minval,loc]=min(abs(goodDSVscnlin_ch5-allbadDSVscnlin_ch5(indexbad)));
%                                 dsv_mean(allbadDSVscnlin_ch5(indexbad),5)=dsv_mean(goodDSVscnlin_ch5(loc),5); %dsv_mean(badPRTline,channel)=dsv_mean(closestgoodPRTline,channel);
%                             end
                            
                            
                            % SET FLAGS for allbadDSV
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadDSV(5,:)=zeros(length(data.scan_line_year),1);
                            qualflag_allbadDSV(5,allbadDSVscnlin_ch5)=1;
                            
                            
                            % SET FLAGS for goodscanlinesBEFOREajump
                            % this will go into
                            % qualflag_lineAdjacentToJump, which is
                            % included in the detailed channels-wise calibration flag
                            qualflag_DSVgoodlinbfjump=zeros(5,length(data.scan_line_year));
                            qualflag_DSVgoodlinbfjump(1,goodline_before_jump_ch1)=1;
                            qualflag_DSVgoodlinbfjump(2,goodline_before_jump_ch2)=1;
                            qualflag_DSVgoodlinbfjump(3,goodline_before_jump_ch3)=1;
                            qualflag_DSVgoodlinbfjump(4,goodline_before_jump_ch4)=1;
                            qualflag_DSVgoodlinbfjump(5,goodline_before_jump_ch5)=1;
                            
                            % set the set of usable channels
                            channelset_dsv=find(~excludechannel);
                            
                            excludechannel=0*excludechannel; %reset the values
                            