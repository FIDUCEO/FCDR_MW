

% setup_roll_average

% setup for rolling scanline avergange over 7 scanlines:

% The average is executed over all lines but those that are bad and further
% away than 5 lines from a good one. Furthermore, for DSV, on marginally
% contaminated lines (i.e. at least on view usable), the average is
% calculated too.

%% DSV

% define the lines which are used for the rolling average
truebadlines=zeros(5,length(data.scan_line_year));

%remove lines of marginalDSV Moon-contamination (i.e."at least one view
%ok") from the badlines (Only those bad ones that are further away than 5
%lines from a good one) from quality_check_dsv (moon might not be captured
%there), since these lines with one good DSV in case of Moon intrusion will
%enter the normal rolling average.Then add the lines where ALL DSV are
%contaminated by the moon.

% 1. remove lines where at least one view is ok
%expand moonflagOneViewOk to dimensions 5x scanline
expanded_moonflagOneViewOk=repmat(moonflagOneViewOk,[1 5]).';%bsxfun(@times,permute(moonflagOneViewOk,[2 1]),ones(size(qualflag_allbadDSV)));
% calculate difference
%cleaned_allbadDSV=uint32(qualflag_allbadDSV-expanded_moonflagOneViewOk);
cleaned_allbadDSV=uint32(qualflag_DSV_badline_furtherthan5lines-expanded_moonflagOneViewOk);

% 2. add the lines where truly all 4 DSV are contaminated
%unify this difference with the bad-Moon-lines
flags_badDSV{1}=cleaned_allbadDSV;
flags_badDSV{2}=uint32(bsxfun(@times,permute(moonflagAllViewsBad,[2 1]),ones(size(qualflag_allbadDSV)))); %expand moonflagAllViewsBad, and transform to uint32
truebadDSVlines=unify_qualflags(flags_badDSV);

% list of truebadDSVlines
scnlin_DSV_truebadline{1}=find(truebadDSVlines(1,:)==1).';
scnlin_DSV_truebadline{2}=find(truebadDSVlines(2,:)==1).';
scnlin_DSV_truebadline{3}=find(truebadDSVlines(3,:)==1).';
scnlin_DSV_truebadline{4}=find(truebadDSVlines(4,:)==1).';
scnlin_DSV_truebadline{5}=find(truebadDSVlines(5,:)==1).';

% write mean of good-dsv in case of moon-intrusion into dsv_mean variable
% used later for the averaging.
% Some of these lines might have been treated by qualitychecks_dsv as
% badlines (if only 1 view is ok) and hence might have get the
% "5-closest"-scanline treatment. This is corrected here, by assigning the
% count value for the ok-views to the dsv_mean.

    if ~isempty(scnlinoneviewok)
       % At least one view ok: only use views that
       % are ok for calculating mean. "meandsvch1okviews" has been calculated already in mooncheck.                            
       dsvmean_per_line(1,scnlinoneviewok)=meandsvch1okviews;
       dsvmean_per_line(2,scnlinoneviewok)=meandsvch2okviews;
       dsvmean_per_line(3,scnlinoneviewok)=meandsvch3okviews;
       dsvmean_per_line(4,scnlinoneviewok)=meandsvch4okviews;
       dsvmean_per_line(5,scnlinoneviewok)=meandsvch5okviews;
    end
  
    
% write NAN incase of "all views bad" in moon intrusion    
    if ~isempty(moonflagAllViewsBad)
    dsvmean_per_line(1,scnlinallviewsbad)=nan;
    dsvmean_per_line(2,scnlinallviewsbad)=nan;
    dsvmean_per_line(3,scnlinallviewsbad)=nan;
    dsvmean_per_line(4,scnlinallviewsbad)=nan;
    dsvmean_per_line(5,scnlinallviewsbad)=nan;
    end
    
       
       
% define lines on which the 7-scanline-average shall be executed
flags_DSV{1}=truebadDSVlines;
flags_DSV{2}=uint32(bsxfun(@times,permute(qualflag_missing_scanline,[2 1]),ones(size(truebadDSVlines)))); %expand qualflag_missingscanlines, and transform to uint32
usablelines_DSV=~unify_qualflags(flags_DSV);%take the negation ~ to get the good lines and lines with marginal DSV views (zero becomes one an vice versa)
    


 % now everything is prepared to proceed with the scanline averaging on the
 % usablelines_DSV and the dsvmean_per_line
    
    
%% IWCT
% define lines on which the 7-scanline-average shall be executed
flags_IWCT{1}=qualflag_IWCT_badline_furtherthan5lines;%qualflag_allbadIWCT;
flags_IWCT{2}=uint32(bsxfun(@times,permute(qualflag_missing_scanline,[2 1]),ones(size(qualflag_allbadIWCT)))); %expand qualflag_missingscanlines, and transform to uint32
usablelines_IWCT=~unify_qualflags(flags_IWCT);%take the negation ~ to get the good lines and lines with marginal IWCT views (zero becomes one an vice versa)
  

 % now everything is prepared to proceed with the scanline averaging on the
 % usablelines_IWCT and the iwct_mean


%% PRT
% define lines on which the 7-scanline-average shall be executed
flags_PRT{1}=qualflag_PRT_badline_furtherthan5lines;%qualflag_allbadPRT;
flags_PRT{2}=qualflag_missing_scanline.';%uint32(bsxfun(@times,permute(qualflag_missing_scanline,[2 1]),ones(size(qualflag_allbadPRT)))); %expand qualflag_missingscanlines, and transform to uint32
usablelines_PRT=~unify_qualflags(flags_PRT);%take the negation ~ to get the good lines and lines with marginal PRT(zero becomes one an vice versa)
 

