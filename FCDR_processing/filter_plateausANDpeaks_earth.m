
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

% This function serves as filter for bad events in the earth counts. It
% filters sudden increases and plateau-like increased count values that
% deviate from the normal (surrounding) behaviour. This function is not
% perfect. It may miss or over-correct events. This is difficult to improve
% due to the variable natrue of the earth counts (especially due to
% clouds).



function  [goodline_before_jump,badscanlines]=filter_plateausANDpeaks_earth(timeseries,threshold)
%    timeseries=earthcounts_ch3(1,:);
%    threshold=threshold_earth(3);

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
%useful.

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
           
            if jumpindicator(nonzeros_jumpindicator(ind))==-jumpindicator(nonzeros_jumpindicator(ind+1)) && flag_peakbefore==0  && abs(median(timeseries,'omitnan')-median(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1)),'omitnan'))>threshold%abs(timeseries(nonzeros_jumpindicator(ind))-timeseries(nonzeros_jumpindicator(ind+1)))>2*threshold%abs(mean(timeseries)-mean(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1))))>threshold %This last constraint is not good. Is does not capture a peak, if there are more bad data afterwards (since these bad data ruin the mean(timeseries)).This last constraint is NOT asked for in the filter for IWCT/DSV since the "mean-criterium" will not be valid, due to changing mean and lower threshold
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
               %disp('case 1')
                            
            elseif jumpindicator(nonzeros_jumpindicator(ind))==-jumpindicator(nonzeros_jumpindicator(ind+1)) && flag_peakbefore==1 || abs(median(timeseries,'omitnan')-median(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1)),'omitnan'))>threshold%abs(mean(timeseries)-mean(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1))))>threshold
               % Here we cover the case that we already had a peak, but we
               % still have a new jump here after a period (from ind to
               % ind+1) where the median
               % of this period is far away (more than the threshold) from
               % the median of the whole time series. That means we have a
               % case of a plateau, then a jump into the other extreme,
               % then a jump back to normal behaviour. Hence, we also flag
               % the lines of this period as bad.
               
                badlines=[badlines nonzeros_jumpindicator(ind)+1:nonzeros_jumpindicator(ind+1)];
                flag_peakbefore=1; % we a peak here.
               %disp('case 2')
               
            elseif jumpindicator(nonzeros_jumpindicator(ind))==-jumpindicator(nonzeros_jumpindicator(ind+1)) && flag_peakbefore==1
               % we already had a peak with an "ending jump" at ind! The
               % jump we see from ind to ind+1 is no peak. But rather at
               % ind+1 we have a new jump. Therefore, we do nothing but flag
               % ind+1 as goodline before a jump.
               
                goodlinbfjump=[goodlinbfjump nonzeros_jumpindicator(ind+1)];
                flag_peakbefore=0; % we have no peak here.
                
                %disp('case 3')
                
            elseif  jumpindicator(nonzeros_jumpindicator(ind))==jumpindicator(nonzeros_jumpindicator(ind+1))  && abs(median(timeseries,'omitnan')-median(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1)),'omitnan'))>threshold%abs(mean(timeseries)-mean(timeseries(nonzeros_jumpindicator(ind):nonzeros_jumpindicator(ind+1))))>threshold
                % the subsequent jumps have the same direction.
                % But the mean of timeseries between the jumps is far away
                % from the overall mean of the timeseries. Therefore, we
                % have a jump to/from a plateau "in two steps". Therefore,
                % flag the badlines in between.
                badlines=[badlines nonzeros_jumpindicator(ind)+1:nonzeros_jumpindicator(ind+1)];
                flag_peakbefore=1;
                disp('case 4')
            else
                
                % the subsequent jumps have the same direction. Therefore,
                % we have no peak but a change of niveau. We mark ind+1 as
                % the goodline before a jump.
                goodlinbfjump=[goodlinbfjump nonzeros_jumpindicator(ind+1)];
                % the jump at ind+1 will be taken care of in next iteration
                % of for-loop.
                flag_peakbefore=0; % we have no peak here.
                %disp('case 5')
            end
            
                                
        end
        
    else
        %There is only one element in nonzeros_jumpindicator.Hence, there
        %is only one jump. Flag the good line before that jump.
        goodlinbfjump=[goodlinbfjump nonzeros_jumpindicator];
       
        %disp('case 6')
    end


else
    % there are no jumps. Do nothing.
     %disp('case 7')
end



    badscanlines=badlines;
    goodline_before_jump=goodlinbfjump;


    
    
