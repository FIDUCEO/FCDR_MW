


function  [goodline_before_jump,badscanlines]=filter_plateausANDpeaks(timeseries,threshold)


%initialize badlines as empty. Needed for the case that no jumps exist.
badlines=[];
goodlinbfjump=[];
flag_peakbefore=0; % initialize: we have no peak here.


%calculate the differences of adjacent elements.
differences_timeseries=diff(timeseries);
%find differences greater than the threshold (and smaller than negative
%thr.)
greaterThr_ind=find(differences_timeseries>threshold);
smallerThr_ind=find(differences_timeseries<-threshold);

%depending on which kinds of jumps we see, we proceed differently. True
%peaks and pleateaus (i.e. jump up and jump down) are flagged as
%badscanlines. Simple jumps (without corresponding jump back) are flagged
%by markeing the last line before the jump as "last good line before a
%jump". But the subsequent data is not flagged as bad as it might be still
%usefull.

% if there are either jumps up or down, start the peak/plateau flagging:
if ~isempty(greaterThr_ind) || ~isempty(smallerThr_ind)
    %generate an array of the same length as the difference_timeseries-array, having
    %+1 or -1 indicating direction of jump.
    jumpindicator=zeros(length(differences_timeseries),1);
    jumpindicator(greaterThr_ind)=1;
    jumpindicator(smallerThr_ind)=-1;
    %find the indices of the jumps (i.e. non-zero values of the
    %jump-direction-array.
    nonzeros_jumpindicator=find(jumpindicator);
    
    if length(nonzeros_jumpindicator)~=1 %there is more than one jump
       
        for ind=1:length(nonzeros_jumpindicator)-1 % loop over all jumps
           
            if jumpindicator(nonzeros_jumpindicator(ind))==-jumpindicator(nonzeros_jumpindicator(ind+1)) && flag_peakbefore==0  
                % the jump goes once up and down and we did NOT correct a
                % peak right before this
                % jump(nonzeros_jumpindicator(ind)).Therefore we have a true
                % peak/plateau here and mark all lines in between nonzero(ind)+1 and
                % nonzero(ind+1) as bad. Append to existing badlines.
                % start badlines at nonzero(ind)+1: since the nonzeros are
                % set at the positions from which the jump starts, i.e.
                % nonzero(ind) is the last goodline, and nonzero(ind)+1
                % already has the offset from the jump.
                badlines=[badlines nonzeros_jumpindicator(ind)+1:nonzeros_jumpindicator(ind+1)];
                flag_peakbefore=1; % set flag that we have a peak
                
                            
            elseif jumpindicator(nonzeros_jumpindicator(ind))==-jumpindicator(nonzeros_jumpindicator(ind+1)) && flag_peakbefore==1 || abs(mean(timeseries)-mean(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1))))>threshold
               % Here we cover the case that we already had a peak, but we
               % still have a new jump here after a period (from ind to ind+1) where the mean
               % of this period is far away (more than the threshold) form
               % the mean of the whole time series. That means we have a
               % case of a plateau, then a jump into the other extreme,
               % then a jump back to normal behaviour. Hence, we also flag
               % the lines of this period as bad.
               
                badlines=[badlines nonzeros_jumpindicator(ind)+1:nonzeros_jumpindicator(ind+1)];
                flag_peakbefore=1; % we a peak here.
               
            elseif jumpindicator(nonzeros_jumpindicator(ind))==-jumpindicator(nonzeros_jumpindicator(ind+1)) && flag_peakbefore==1
               % we already had a peak with an "ending jump" at ind! The
               % jump we see from ind to ind+1 is no peak. But rather at
               % ind+1 we have a new jump. Therefore, we do nothing but flag
               % ind+1 as goodline before a jump.
               
                goodlinbfjump=[goodlinbfjump nonzeros_jumpindicator(ind+1)];
                flag_peakbefore=0; % we have no peak here.
                
                
            elseif  jumpindicator(nonzeros_jumpindicator(ind))==jumpindicator(nonzeros_jumpindicator(ind+1))  || abs(mean(timeseries)-mean(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1))))>threshold
                % the subsequent jumps have the same direction.
                % But the mean of timeseries between the jumps is far away
                % from the overall mean of the timeseries. Therefore, we
                % have a jump to/from a plateau "in two steps". Therfore,
                % flag the badlines in between.
                badlines=[badlines nonzeros_jumpindicator(ind)+1:nonzeros_jumpindicator(ind+1)];
                flag_peakbefore=1;
                
            else
                % the subsequent jumps have the same direction. Therefore,
                % we have no peak but a change of niveau. We mark ind+1 as
                % the goodline before a jump.
                goodlinbfjump=[goodlinbfjump nonzeros_jumpindicator(ind+1)];
                % the jump at in+1 will be taken care of in next iteration
                % of for-loop.
                flag_peakbefore=0; % we have no peak here.
                
            end
            
                                
        end
        
    else
        %There is only one element in nonzeros_jumpindicator.Hence, there
        %is only one jump. Flag the good line before that jump.
        goodlinbfjump=[goodlinbfjump nonzeros_jumpindicator];
       
        
    end


else
    % there are no jumps. Do nothing.
    
end



    badscanlines=badlines;
    goodline_before_jump=goodlinbfjump;


    
    
   