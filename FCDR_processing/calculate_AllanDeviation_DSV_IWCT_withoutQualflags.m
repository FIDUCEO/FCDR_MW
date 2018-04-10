

% compute the Allan Deviation for DSV, IWCT, PRT



% Note: the rolling 7-scanlin average is applied in the
% calculate_rolling_average routine to get the final valid Noise estimate
% per scanline.


% initialize the counts from the 4 views for DSV, to have
% dimension: channel x  scanlin X view
countsdsv=[dsv1ch1; dsv2ch1; dsv3ch1; dsv4ch1;];
countsdsv(:,:,2)=[dsv1ch2; dsv2ch2; dsv3ch2; dsv4ch2;];               
countsdsv(:,:,3)=[dsv1ch3; dsv2ch3; dsv3ch3; dsv4ch3;];         
countsdsv(:,:,4)=[dsv1ch4; dsv2ch4; dsv3ch4; dsv4ch4;];                  
countsdsv(:,:,5)=[dsv1ch5; dsv2ch5; dsv3ch5; dsv4ch5;];

countsdsv=double(permute(countsdsv,[3 2 1]));


% initialize the counts from the 4 views for DSV, to have
% dimension: channel x  scanlin X view
countsiwct=[iwct1ch1; iwct2ch1; iwct3ch1; iwct4ch1;];
countsiwct(:,:,2)=[iwct1ch2; iwct2ch2; iwct3ch2; iwct4ch2;];               
countsiwct(:,:,3)=[iwct1ch3; iwct2ch3; iwct3ch3; iwct4ch3;];         
countsiwct(:,:,4)=[iwct1ch4; iwct2ch4; iwct3ch4; iwct4ch4;];                  
countsiwct(:,:,5)=[iwct1ch5; iwct2ch5; iwct3ch5; iwct4ch5;];

countsiwct=double(permute(countsiwct,[3 2 1]));



% calculate Allan Dev on ALL views and lines without taking into account
% quality issues

% calculate Allan Variance from scanline to scanline per view/sensor and channel
AllanVar_DSV_indivLines_indivViews_withoutflags=1/2*diff(countsdsv,1,2).^2;
AllanVar_IWCT_indivLines_indivViews_withoutflags=1/2*diff(countsiwct,1,2).^2;

% calculate the mean per scanline (mean over the views/sensors) and omit NANs to
% get the correct inrease in AllanVar due to less usable views/sensors
AllanVar_DSV_indivLines_withoutflags=mean(AllanVar_DSV_indivLines_indivViews_withoutflags,3,'omitnan');
AllanVar_IWCT_indivLines_withoutflags=mean(AllanVar_IWCT_indivLines_indivViews_withoutflags,3,'omitnan');


%calculate a rolling mean over 300 scanlines
AllanVar_DSV_300window_withoutflags=movmean(AllanVar_DSV_indivLines_withoutflags,300,2,'omitnan');
AllanVar_IWCT_300window_withoutflags=movmean(AllanVar_IWCT_indivLines_withoutflags,300,2,'omitnan');


% calculate the Allan Deviation
AllanDev_DSV_300window_withoutflags=sqrt(AllanVar_DSV_300window_withoutflags);
AllanDev_IWCT_300window_withoutflags=sqrt(AllanVar_IWCT_300window_withoutflags);


% expand the Allan Deviation for the last scanline (repeat last value)
AllanDev_DSV_perline_withoutflags=AllanDev_DSV_300window_withoutflags;
AllanDev_DSV_perline_withoutflags(:,length(AllanDev_DSV_300window_withoutflags)+1)=AllanDev_DSV_300window_withoutflags(:,end);
AllanDev_IWCT_perline_withoutflags=AllanDev_IWCT_300window_withoutflags;
AllanDev_IWCT_perline_withoutflags(:,length(AllanDev_IWCT_300window_withoutflags)+1)=AllanDev_IWCT_300window_withoutflags(:,end);





% this AllanDev_X_perline now enters 
% the quality checks to have a threshold-deviation
dsvcountallandev_med=AllanDev_DSV_perline_withoutflags;
iwctcountallandev_med=AllanDev_IWCT_perline_withoutflags;
