
% calculate_roll_average

% this script computes the 7-scanline-average for the DSV, IWCT and PRT
% It uses the information on usable/ nonusable scanlines (bad lines or
% missing lines) and excluded these from the rolling average. To compensate
% the missing weight of excluded lines, the weights are adapted dynamically
% by recalculating the weights depending on the excluded lines.

% The aim is to have a matrix multiplication
% average= weights*usablelines
% to calculate the weighted rolling mean.

% Description:
% At first we prepare a matrix Aprime with dimensions
% totalnumberofscanlines x totalnumberofscanlines. It contains ones for
% each scanline that is used in the 7-scanline average of another scanline.
% This results in a banded matrix with ones on the three upper and lower
% diagonals and the main diagonal. Aprime is hence stored as sparse matrix.

% Secondly, we prepare a matrix W having the same structure as Aprime, but
% containing the nominal weight for the 7-scanlines.

% Third we prepare (per channel) a matrix indicating which lines can be
% used (based on bad-lines or missinglines). This matrix
% usable_mat_DSV{chn} is of dimension totalnumberofscanlines x
% totalnumberofscanlines. 

% As a next step, we calculate a matrix D, that is the same as W, but for
% bad or missing lines D has zero:
%D=W.*usable_mat

% The weights of the unused lines need to be distributed evenly among the
% remaining lines that are used for the average for a specific line. To
% achieve this, we calculate per scanline, the weights of the UNusable
% lines. This is stored in matrix K
%K= W-D.

% To EVENLY distribute the weight of the unused lines, we need to calculate
% the SUM of these weights per line (vector S) and we need to COUNT the
% unuseable lines per scanlines (vecotr M):
%S= sum of elements of K's rows
%M= number of NON-zero elements od D's rows.
%NOTE: here, we have to atrificially set M=1 for the cases where M would be
%zero. This is needed since we later divide by M. The contribution that we
%add by this is lateron removed by the multiplication with matrix of
%used-lines that destroys any non needed values.

% We now calculate the share that needs to be added to verey used line
% addshare= S/M

% As intermediate step create a matrix containing all usedlines, i.e. all
% lines that are NOT excluded due to badline/missing line, and containing
% all lines that are required for the rolling average. Do this by using
% logical operators:
% usedlinesDSV=usable_mat_DSV{chn} & Aprime.';

% Now we are ready to add the additional weight to the old weights (for the
% scanlines for which the average contains less thann 7 lines), to obtain
% the new weights:
% G=D+addshare.*usablelines

% Finally the rolling avergae is computed. It is zero for unused lines.
% dsv_count_roll_av{chn}=G .'*dsv_mean(:,chn);
   
% At the end, we replace zeros with nan (unused lines are at zero still)
% dsv_count_roll_av{chn}(dsv_count_roll_av{chn}==0)=nan;

% Finally store the result in
% countDSV_av etc.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% preparation of needed matrices

%prepare matrix A:
%      1     1     1     1     0     0     0     0     0     0
%      1     1     1     1     1     0     0     0     0     0
%      1     1     1     1     1     1     0     0     0     0
%      1     1     1     1     1     1     1     0     0     0
%      0     1     1     1     1     1     1     1     0     0
%      0     0     1     1     1     1     1     1     1     0
%      0     0     0     1     1     1     1     1     1     1
%      0     0     0     0     1     1     1     1     1     1
%      0     0     0     0     0     1     1     1     1     1
%      0     0     0     0     0     0     1     1     1     1


totalnumberofscanlines=length(scanlinenumbers);
B=zeros(totalnumberofscanlines,7);
B(:,[1 7])=1;B(:,[2 6])=1;B(:,[3 5])=1;B(:,4)=1;
Aprime=spdiags(logical(B),[-3 -2 -1 0 1 2 3],totalnumberofscanlines,totalnumberofscanlines);



% prepare Matrix W that contains for every entry in A the corresponding
% nominal weight for the 7-scanline convolution 

numlines=3; %i.e. three lines before and three after the one in question
% set up value_mat as matrix B above: containing the actual numbers for the
% respective diagonals; to finally get W=
%
%     0.2500    0.1875    0.1250    0.0625         0         0         0         0         0         0
%     0.1875    0.2500    0.1875    0.1250    0.0625         0         0         0         0         0
%     0.1250    0.1875    0.2500    0.1875    0.1250    0.0625         0         0         0         0
%     0.0625    0.1250    0.1875    0.2500    0.1875    0.1250    0.0625         0         0         0
%          0    0.0625    0.1250    0.1875    0.2500    0.1875    0.1250    0.0625         0         0
%          0         0    0.0625    0.1250    0.1875    0.2500    0.1875    0.1250    0.0625         0
%          0         0         0    0.0625    0.1250    0.1875    0.2500    0.1875    0.1250    0.0625
%          0         0         0         0    0.0625    0.1250    0.1875    0.2500    0.1875    0.1250
%          0         0         0         0         0    0.0625    0.1250    0.1875    0.2500    0.1875
%          0         0         0         0         0         0    0.0625    0.1250    0.1875    0.2500

value_mat=zeros(totalnumberofscanlines,7);
value_mat(:,[1 7])=1/(numlines+1)*(1-3/(numlines+1)); %3 for the two outermost lines;see Eq 30, p.73 in EUMETSAT_MHS_product_Generation-Spec
value_mat(:,[2 6])=1/(numlines+1)*(1-2/(numlines+1)); 
value_mat(:,[3 5])=1/(numlines+1)*(1-1/(numlines+1));
value_mat(:,4)=1/(numlines+1)*1; %1 for the inner line


W=spdiags(value_mat,[-3 -2 -1 0 1 2 3],totalnumberofscanlines,totalnumberofscanlines);

%% IWCT and DSV

% prepare Matrix D that is like W, but the scanlines that are UNunsable are
% removed (they get zero)

% sofar I find no way of using the 3rd dimension (channel!) in an
% intelligent way on sparse matrix W. Therefore I have to calculate it in a
% loop for the 5 channels...


usablelines_DSV_logical=logical(usablelines_DSV);
expanded_usablelines_DSV_chns{1}=repmat(usablelines_DSV_logical(1,:),totalnumberofscanlines,1);
expanded_usablelines_DSV_chns{2}=repmat(usablelines_DSV_logical(2,:),totalnumberofscanlines,1);
expanded_usablelines_DSV_chns{3}=repmat(usablelines_DSV_logical(3,:),totalnumberofscanlines,1);
expanded_usablelines_DSV_chns{4}=repmat(usablelines_DSV_logical(4,:),totalnumberofscanlines,1);
expanded_usablelines_DSV_chns{5}=repmat(usablelines_DSV_logical(5,:),totalnumberofscanlines,1);

usablelines_IWCT_logical=logical(usablelines_IWCT);
expanded_usablelines_IWCT_chns{1}=repmat(usablelines_IWCT_logical(1,:),totalnumberofscanlines,1);
expanded_usablelines_IWCT_chns{2}=repmat(usablelines_IWCT_logical(2,:),totalnumberofscanlines,1);
expanded_usablelines_IWCT_chns{3}=repmat(usablelines_IWCT_logical(3,:),totalnumberofscanlines,1);
expanded_usablelines_IWCT_chns{4}=repmat(usablelines_IWCT_logical(4,:),totalnumberofscanlines,1);
expanded_usablelines_IWCT_chns{5}=repmat(usablelines_IWCT_logical(5,:),totalnumberofscanlines,1);

usable_mat_DSV=cell(5,1);
usable_mat_IWCT=cell(5,1);
dsv_count_roll_av=cell(5,1);
iwct_count_roll_av=cell(5,1);
countDSV_av_intermed=zeros(5,totalnumberofscanlines);
countIWCT_av_intermed=zeros(5,totalnumberofscanlines);
AllanVar_dsv_count_roll_av=cell(5,1);
AllanVar_iwct_count_roll_av=cell(5,1);
AllanDev_dsv_count_roll_av=cell(5,1);
AllanDev_iwct_count_roll_av=cell(5,1);
AllanDev_countDSV_av_intermed=zeros(5,totalnumberofscanlines);
AllanDev_countIWCT_av_intermed=zeros(5,totalnumberofscanlines);
num_usedlinesDSV=zeros(5,totalnumberofscanlines);
num_usedlinesIWCT=zeros(5,totalnumberofscanlines);

for chn=1:5
    % build matrix usable_mat{chn} that contains zeros for all unsuable
    % lines. I.e. the matrix contains the product off all combinations of
    % the row and column vector of usable lines
    
    usable_mat_DSV{chn}=expanded_usablelines_DSV_chns{chn}& expanded_usablelines_DSV_chns{chn}.';
    usable_mat_IWCT{chn}=expanded_usablelines_IWCT_chns{chn}& expanded_usablelines_IWCT_chns{chn}.';
  
    
       
    % This ensures that any line that is not usable at all (no views good) will NOT ENTER any
    % rolling average and moreover, it will NOT GET any gap filling
    % estimate by the rolling average of adjacent lines. I.e. in this
    % rolling average procedure, only lines that actually HAVE own
    % measurement data will be smoothed by the rolling average. Any badline
    % will stay a badline and (sometimes) be estimated  by the median of the
    % five closest.
    
    % matrix D contains weights for usable lines
    D_DSV=W.*usable_mat_DSV{chn};
    D_IWCT=W.*usable_mat_IWCT{chn};
    
    % matrix K contains the weights of the UNusable lines
    K_DSV=W-D_DSV;
    K_IWCT=W-D_IWCT;
    
    % Vector S contains the sum of the weights of UNusable lines, per
    % scanline
    S_DSV=sum(K_DSV,1);
    S_IWCT=sum(K_IWCT,1);
    % NOTE: the start and end of the file are NOT handled correctly: they
    % DO NOT get the added share due to lacking scanline! I.e. the values
    % are too low at the start and end. BUT: for the overall processing, we
    % process the 3 lines before and after the scnaline-range we are
    % interested in. Then the main range is handlesd correctly. For the
    % writing-process the 3 lines before and after are deleted.
    
    % Vector M contains the number of non-zero elements of D's rows. Count
    % the non-zero elements per row of D (i.e. sum-over-rows("matrix with 1 where D not equal zero")), i.e.
    % the number of usable scanlines per scanline:
    M_DSV=ones(1,totalnumberofscanlines); %initialize M with ones 
    M_DSV=sum(D_DSV~=0,1);
        % store M_DSV for later use to generate flag
        num_usedlinesDSV(chn,:)=M_DSV;
    %M_DSV(M_DSV==0)=1;%replace zeros by one to evade division by zero!
    M_IWCT=ones(1,totalnumberofscanlines);
    M_IWCT=sum(D_IWCT~=0,1);
        % store M_IWCT for later use to generate flag
        num_usedlinesIWCT(chn,:)=M_IWCT;
    %M_IWCT(M_IWCT==0)=1;
    
    % compute new weights for each usable scanline, i.e. for each scanline
    % spread S evenly among the usable lines.
    
        % first compute the share of S that each used scanline will get:
            addshare_DSV=S_DSV./M_DSV; 
            expand_addshare_DSV=repmat(addshare_DSV,totalnumberofscanlines,1);
            %note: addshare gets Inf for UNusable lines (since M_DSV
            %gets zero at UNusable lines due to storage as sparse matrix). later
            %it is multiplied elementwise by matrix usable lines. There,
            %it yields NAN with the UNUSABLE lines (having zero entries). This NAN gets added to
            %the weights G_X, that will in turn generate NAN for UNusable
            %lines in the average.
            % in the other dimension M_DSV is not Inf but has a nonzero
            % finite values. This extra-share that should not be added, is
            % actually destoyed by multiplying ith usable lines (having
            % zero at unusable lines).
            
            
            addshare_IWCT=S_IWCT./M_IWCT; 
            expand_addshare_IWCT=repmat(addshare_IWCT,totalnumberofscanlines,1);
            
    % now the new weights: i.e. old weights plus the Mth share of the unusedlines' weight   
    usedlinesDSV=usable_mat_DSV{chn}&Aprime.';
    G_DSV=D_DSV+expand_addshare_DSV.*usedlinesDSV; 
    usedlinesIWCT=usable_mat_IWCT{chn}&Aprime.';
    G_IWCT=D_IWCT+expand_addshare_IWCT.*usedlinesIWCT;
    
    % Now calculate the rolling average over dsvmean_per_line using the new
    % weights. Note: dsvmean_per_line has already the mean over the good-dsv for
    % Moonintrusions and has nan where all views are bad due to Moon
    % intrusion.
    dsv_count_roll_av{chn}=G_DSV.'*dsvmean_per_line(chn,:).'; %any NANs in G now yield NAN in the average
    iwct_count_roll_av{chn}=G_IWCT.'*iwctmean_per_line(chn,:).';
    % for the uncertainty on Counts (--> AllanVariance) to be propagated through the 7-scnlin av, need
    % the derivative of the weighting average, i.e.   av.-uncert^2=av.-AllanVar=G_X^2*AllanVariance
     AllanVar_dsv_count_roll_av{chn}=(G_DSV.^2).'*AllanVar_DSV_perline(chn,:).';
     AllanVar_iwct_count_roll_av{chn}=(G_IWCT.^2).'*AllanVar_IWCT_perline(chn,:).';
    % take sqrt to get the AllanDev. for every scanline
     AllanDev_dsv_count_roll_av{chn}=sqrt(AllanVar_dsv_count_roll_av{chn});
     AllanDev_iwct_count_roll_av{chn}=sqrt(AllanVar_iwct_count_roll_av{chn});
     
    %replace zeros with nan (unused lines are at zero still)
    dsv_count_roll_av{chn}(dsv_count_roll_av{chn}==0)=nan;
    iwct_count_roll_av{chn}(iwct_count_roll_av{chn}==0)=nan;
    AllanDev_dsv_count_roll_av{chn}(AllanDev_dsv_count_roll_av{chn}==0)=nan;
    AllanDev_iwct_count_roll_av{chn}(AllanDev_iwct_count_roll_av{chn}==0)=nan;
    
    %now put all into variable dsv_mean and iwct_mean
    countDSV_av_intermed(chn,:)=dsv_count_roll_av{chn};
    countIWCT_av_intermed(chn,:)=iwct_count_roll_av{chn};
    AllanDev_countDSV_av_intermed(chn,:)=AllanDev_dsv_count_roll_av{chn};
    AllanDev_countIWCT_av_intermed(chn,:)=AllanDev_iwct_count_roll_av{chn};
    
end

%NOTE: now, I dont do this anymore: Now, I apply the rolling everage to ANY
%line that has a non NAN value, i.e. also the 5-closest case. Therefore, I
%dont need to do anything here, since the rolling average operates on all
%lines but those that are further away than 5 lines from a good one.
countDSV_av=countDSV_av_intermed;
countIWCT_av=countIWCT_av_intermed;
% % now put back in the values for the lines for which NO rolling average
% % should be applied, i.e. the "5-closest" case and the NANs for the
% % "further away case" of badlines. Theses values have been saved to
% % dsv_mean_intermed in the qualitychecksDSV_allchn.m routine
% % countDSV_av=countDSV_av_intermed;
% % dsv_mean_intermed_trans=dsv_mean_intermed.';
% % countDSV_av(dsv_mean_intermed.'~=0)=dsv_mean_intermed_trans(dsv_mean_intermed_trans~=0);
% % countIWCT_av=countIWCT_av_intermed;
% % iwct_mean_intermed_trans=iwct_mean_intermed.';
% % countIWCT_av(iwct_mean_intermed_trans~=0)=iwct_mean_intermed_trans(iwct_mean_intermed_trans~=0);

AllanDev_countDSV_av=AllanDev_countDSV_av_intermed;
AllanDev_countIWCT_av=AllanDev_countIWCT_av_intermed;
% extra variables containting the mean-allandev WITHOUT rolling average
AllanDev_countDSV_NOav=AllanDev_DSV_perline;
AllanDev_countIWCT_NOav=AllanDev_IWCT_perline;

% this DSV/IWCTmean has now a scanline-averaged value at all lines, but at the
% badlines that are furtheraway than 5 lines from a good one (they got
% NAN)



%set to NAN the value for no-calib-case (furtheraway-case and MoonAllViewsbad for DSV)
% and put back in the values of AllanDev for the moon-one-view-ok-case.
AllanDev_countDSV_av(qualflag_DSV_badline_furtherthan5lines==1)=nan;
AllanDev_countDSV_av(repmat(moonflagAllViewsBad,[1 5]).'==1)=nan;
AllanDev_countDSV_av(repmat(moonflagOneViewOk,[1 5]).'==1)=AllanDev_countDSV_av_intermed(repmat(moonflagOneViewOk,[1 5]).'==1);
AllanDev_countIWCT_av(qualflag_IWCT_badline_furtherthan5lines==1)=nan;
%AllanDev_countIWCT_av(repmat(moonflagAllViewsBad,[1 5]).'==1)=nan; not for
%IWCT!

% construct flag to indicate that less than 7 lines have been used for
% calibration.
qualflag_DSV_fewerlines_used=zeros(5,totalnumberofscanlines);
qualflag_DSV_fewerlines_used(logical(num_usedlinesDSV<7)==1 & logical(num_usedlinesDSV>0)==1)=1;
qualflag_IWCT_fewerlines_used=zeros(5,totalnumberofscanlines);
qualflag_IWCT_fewerlines_used(logical(num_usedlinesIWCT<7)==1 & logical(num_usedlinesIWCT>0)==1)=1;


%% PRT

% all this need to be done for PRT as well!!!

% prepare Matrix D that is like W, but the scanlines that are UNunsable are
% removed (they get zero)
%expanded_usablelines_PRT=bsxfun(@times,usablelines_PRT,dummyW);
usablelines_PRT_logical=logical(usablelines_PRT.');
expanded_usablelines_PRT=repmat(usablelines_PRT_logical,1,totalnumberofscanlines);

% build matrix usable_mat{chn} that contains zeros for all unsuable
    % lines. I.e. the matrix contains the product off all cominations of
    % the row and column vector of usable lines
    
    usable_mat_PRT=expanded_usablelines_PRT & expanded_usablelines_PRT.';
   
    
    %fixme:not faster:
%     sparse_expanded_UNusablelines_DSV_chns{chn}=sparse(~expanded_usablelines_DSV_chns{chn});
%     usable_mat{chn}=~(sparse_expanded_UNusablelines_DSV_chns{chn}.*sparse_expanded_UNusablelines_DSV_chns{chn}.');

    
    % This ensures that any line that is not usable will NOT ENTER any
    % rolling average and moreover, it will NOT GET any gap filling
    % estimate by the rolling average of adjacent lines. I.e. in this
    % rolling average procedure, only lines that actually HAVE own
    % measurement data will be smoothed by the rolling average. Any badline
    % will stay a badline and (sometimes) be estimated  by the median of the
    % five closest.
    
    % matrix D contains weights for usable lines
    D_PRT=W.*usable_mat_PRT;
   
    
    % matrix K contains the weights of the UNusable lines
    K_PRT=W-D_PRT;
   
    
    % Vector S contains the sum of the weights of UNusable lines, per
    % scanline
    S_PRT=sum(K_PRT,1);
   
    
    % Vector M contains the number of non-zero elements of D's rows.
    % Count the non-zero elements per row of D, i.e. the number of
    % usable scanlines per scanline:
    M_PRT=sum(D_PRT~=0,1);
       % store M_IWCT for later use to generate flag
        num_usedlinesPRT=M_PRT;
    M_PRT(M_PRT==0)=1;%replace zeros by one to evade division by zero!

    
    % compute new weights for each usable scanline, i.e. for each scanline
    % spread S evenly among the usable lines.
    
        % first compute the share of S that each used scanline will get:
            addshare_PRT=S_PRT./M_PRT; 
            %expand_addshare_PRT=bsxfun(@times,addshare_PRT,dummyW);
            expand_addshare_PRT=repmat(addshare_PRT,totalnumberofscanlines,1);
            
    % now the new weights: i.e. old weights plus the Mth share of the unusedlines' weight  
    usedlinesPRT=usable_mat_PRT&Aprime.';
    G_PRT=D_PRT+expand_addshare_PRT.*usedlinesPRT;
    
    
    % Now calculate the rolling average over dsv_mean using the new
    % weights. 
    prt_count_roll_av=G_PRT.'*prtmean_per_line;
    AllanDev_PRT_temp_roll_av=G_PRT.'*AllanDev_PRT_perline;
    
    %replace zeros with nan (unused lines are at zero still)
    prt_count_roll_av(prt_count_roll_av==0)=nan;
    AllanDev_PRT_temp_roll_av(AllanDev_PRT_temp_roll_av==0)=nan;

    
    %now put all into variable iwcttemp_mean_intermed
    IWCTtemp_av_intermed=prt_count_roll_av.';
    AllanDev_IWCTtemp_av_intermed=AllanDev_PRT_temp_roll_av;
    
    
    
    % now put back in the values for the lines for which NO rolling average
    % should be applied, i.e. the "5-closest" case and the NANs for the
    % "further away case" of badlines. Theses values have been saved to
    % prt_mean_intermed in the qualitychecksPRT_allsensors.m routine
    IWCTtemp_av=IWCTtemp_av_intermed;
    %IWCTtemp_av(prt_mean_intermed~=0)=prt_mean_intermed;
    AllanDev_IWCTtemp_av=AllanDev_IWCTtemp_av_intermed;

    
    
    %set to NAN the value for no-calib-case 
    AllanDev_IWCTtemp_av(qualflag_PRT_badline_furtherthan5lines==1)=nan;
    
    % construct flag to indicate that less than 7 lines have been used for
    % calibration.
    qualflag_PRT_fewerlines_used=zeros(1,totalnumberofscanlines);
    qualflag_PRT_fewerlines_used(logical(num_usedlinesPRT<7)==1 & logical(num_usedlinesPRT>0)==1)=1;

    % this iwctTempmean has now a scanline-averaged value at all lines, but at the
    % badlines that are closer than 5 lines from a good one (they got the
    % median estimate) or furtheraway than 5 lines from a good one (they got
    % NAN)
    
    
   
    %artificially expand IWCTtemp_av to channel dimension. Needed for
    %further processing.
    IWCTtemp_av_preexpanding=IWCTtemp_av.';
    IWCTtemp_av=repmat(IWCTtemp_av_preexpanding,[1 5]).';
    AllanDev_IWCTtemp_av_preexpanding=AllanDev_IWCTtemp_av.';
    AllanDev_IWCTtemp_av=repmat(AllanDev_IWCTtemp_av_preexpanding.',[1 5]).';
    
    
    