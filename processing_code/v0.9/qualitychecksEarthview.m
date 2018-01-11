


% qualitychecks on Earthcounts
%threshold_earth is set in the set_coeff.m script, i.e. it is read in from
%the .mat file. Like antenna pattern corr. coeffs. etc.
qualflag_badscanlinesEarth_pix=zeros(size(earthcounts));

for channel=1:5


for pixel=1:90
    earthcount_pixel=squeeze(earthcounts(channel,pixel,:));
    
    [goodline_before_jump_pix,badscanlines_pix]=filter_plateausANDpeaks_earth(earthcount_pixel,threshold_earth(channel));
    qualflag_badscanlinesEarth_pix(channel,pixel,badscanlines_pix)=1;
    
end



end

earthcounts_filtered=earthcounts;
% set earthcounts to NAN wherever the counts are zero
earthcounts_filtered(earthcounts==0)=nan;
% set earthcounts to NAN wherever the counts are negative
earthcounts_filtered(earthcounts<0)=nan;
% set earthcounts to NAN wherever there is a badline/pixel due to some
% jump/lpeak/plateau
earthcounts_filtered(qualflag_badscanlinesEarth_pix==1)=nan;

earthcounts_unfiltered=earthcounts; %store the unfilteres earthcounts
earthcounts=earthcounts_filtered; %replace the old earthcounts with the filtered ones
