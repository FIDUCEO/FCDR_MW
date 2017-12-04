




%%%%% Quality check for PRT temperatures %%%%
                            temp_thr=[250 310];
                            allowed_dev_from_median=0.3; %0.2K %0.3 suggestion by martin
                            
                            onlybadPRTmeasurements=0;

                            % median test
                            
                            PRTmedian=median(PRTtemps,1);
                            
                            weight_median(1,:)=2*(abs(PRTmedian-PRTtemps(1,:))<=allowed_dev_from_median); %if the difference of the 
                            %current PRT1 measurement and the median of the PRT measurements of the scan line 
                            %is larger than 0.2K, then the weight is set to zero. Otherwise it is 1 (2 for PRT1).
                            weight_median(2,:)=(abs(PRTmedian-PRTtemps(2,:))<=allowed_dev_from_median);
                            weight_median(3,:)=(abs(PRTmedian-PRTtemps(3,:))<=allowed_dev_from_median);
                            weight_median(4,:)=(abs(PRTmedian-PRTtemps(4,:))<=allowed_dev_from_median);
                            weight_median(5,:)=(abs(PRTmedian-PRTtemps(5,:))<=allowed_dev_from_median);
                            
                             % threshold test
                            weight_thresholdtest=(temp_thr(1)<PRTtemps & PRTtemps<temp_thr(2));
                            
                            %set weights: if any of the test gave zero
                            %weight, then assign zero weight to the view
                            %(-->"take min(...)")
                            weight(1,:)=min(weight_thresholdtest(1,:),weight_median(1,:));
                            weight(2,:)=min(weight_thresholdtest(1,:),weight_median(2,:)); 
                            weight(3,:)=min(weight_thresholdtest(1,:),weight_median(3,:)); 
                            weight(4,:)=min(weight_thresholdtest(1,:),weight_median(4,:)); 
                            weight(5,:)=min(weight_thresholdtest(1,:),weight_median(5,:)); 
                            
                            
                            %find scan lines for which at least some of the the PRTs are bad
                            marginalPRTscnlin=sort([find(~weight(1,:)),find(~weight(2,:)),find(~weight(3,:)),find(~weight(4,:)),find(~weight(5,:))]);
                            % SET FLAG for marginalbadPRT-flag.
                            qualflag_marginalPRT=zeros(length(data.scan_line_year),1);
                            qualflag_marginalPRT(marginalPRTscnlin)=1;
                            qualflag_marginalPRT=qualflag_marginalPRT.';
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            % COMPUTE mean of good PRT sensors:
                            
                            % weighted mean of temperatures = temp of ICT at
                            % certain scanline
                            % prelaunch weigths: 2,1,1,1,1 are from clparams.dat-file
                            % for MHS. BUT: use weights obtained from
                            % quality check.
                            sumofweights=sum(weight(:,:),1);
                            ICTtempmean=1./sumofweights .*(weight(1,:).*PRT1temp+weight(2,:).*PRT2temp+weight(3,:).*PRT3temp+weight(4,:).*PRT4temp+weight(5,:).*PRT5temp);
                            %ICTtempmean=1/6 *(2*PRT1temp+PRT2temp+PRT3temp+PRT4temp+PRT5temp);
                            
                            % check for any sudden changes/ peaks/
                            % plateaus and flag the scanlines
                            % (badlinesjump will be unified with other
                            % badscanlines to give one set of bad lines)
                            [goodline_before_jump_ICTtempmean,badlinesjump_ICTtempmean]=filter_plateausANDpeaks(ICTtempmean,jump_thrICTtempmean);
                            
                            
                            % If sumofweights<= 2, i.e. 2 or less sensors
                            % give good values, then take the closest good
                            % scan line. 
                            allbadPRTscnlin=double(find(sumofweights<=2));
                            goodPRTscnlin=double(setdiff(scanlinenumbers,allbadPRTscnlin));
                            onlygoodPRTscnlin=double(setdiff(goodPRTscnlin,marginalPRTscnlin));
                            
                            % SET FLAGS for allbadPRT
                            % this will go into bit3 of Ch-CalibrQualFlags
                            qualflag_allbadPRT=zeros(length(data.scan_line_year),1);
                            qualflag_PRT_5closest=zeros(length(data.scan_line_year),1);
                            qualflag_PRT_nocaliballbad=zeros(length(data.scan_line_year),1);
                            qualflag_allbadPRT(allbadPRTscnlin)=1;
                            qualflag_allbadPRT=qualflag_allbadPRT.';
                            
                            if isempty(goodPRTscnlin) || length(onlygoodPRTscnlin)<300
                                disp('This orbit has not enough usable PRT data. No further processing.')
                                onlybadPRTmeasurements=1;
                                return
                            else
                                for indexbad=1:length(allbadPRTscnlin)

                                    [sorted,sortedloc]=sort(abs(goodPRTscnlin-allbadPRTscnlin(indexbad)));
                                    if sorted(1)<5 % if the good one is closer than 5 scanlines apart, then:
                                            ICTtempmean(allbadPRTscnlin(indexbad))=median(ICTtempmean(goodPRTscnlin(sortedloc(1:num_closestlines)))); %ICTtempmean(badPRTline)=median(ICTtempmean("close goodlines"));
                                            qualflag_PRT_5closest(allbadPRTscnlin(indexbad))=1;
                                    else
                                            ICTtempmean(allbadPRTscnlin(indexbad))=nan;
                                            qualflag_PRT_nocaliballbad(allbadPRTscnlin(indexbad))=1;
                                    end
                                    
                                end
                            end
                            
                            %reset values for missing scanlines (i.e.
                            %refilled scanlines) to NAN
                           
                            ICTtempmean(missing_scanlines)=nan;