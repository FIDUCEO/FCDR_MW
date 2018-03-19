


% insert NaN for missing scanlines (where scanline number/ time jumps)



function [scanlines_new,quantity_new]=fill_missing_scanlines(timevec,scanlines,quantity,value2fill)

%for MHS and AMSUB: 2666 ms is the usual time step between 2 calibr. cycles
% for SSMT2: 8000 ms is the usual time step between 2 calibr. cycles

% procedure:
% "a" represents the vector of scan line numbers
% "quantity" represents all variables that will get NaN in the newly
% created scan line entries
a=scanlines;
a_old=a;

quantity_old=quantity;
%quantity=[3.4 5.6 2.4 1.8 9.0 2.3 8.7 6.0]

% Argument management:
% value2fill is optional,
% scanlines,quantity are mandatory
  if nargin < 4
     value2fill = nan;
  end

% check for time jumps
% checking fo gaps in scanline numbers does not help. since numbering is
% adapted already in the Eq2Eq-fitting

% check where the scan line number increases by more than 1
% diffscnlin=diff(a);
% number_of_scnlinwithjump=find(diffscnlin>1);

% check the jump in time
diffscnlintime=diff(timevec);

%%%%%% Time jumps backward %%%%%%%%%
sum_jumpbw=0;%initialize sum of jumped scnlin with zero

number_of_scnlinwithjumptime_bw=find(diffscnlintime<-2680 & abs(diffscnlintime)<86300000); %abs(diffscnlintime)<86300000 to exclude the case of jump back in time at change of day (change of day is about 86400000)

assert(isempty(number_of_scnlinwithjumptime_bw),...
	'fill_missing_scanlines:timejump_bw',...
    'Time jump backward detected.')

for i=length(number_of_scnlinwithjumptime_bw):-1:1

numtime_bw=number_of_scnlinwithjumptime_bw(i);

scanline_jumptime_bw=numtime_bw+1;
jumptime_bw=diffscnlintime(numtime_bw); %by how much does the time jump backward?

number_skipped_scnlin_bw=round(jumptime_bw*0.001*3/8); %by how many scancycles. i.e. scanlines does the record jump back according to time-jump?
jump_bw=abs(number_skipped_scnlin_bw);
sum_jumpbw=sum_jumpbw+jump_bw;
%%% check nature of jump
% check whether time value is reset or whether the quantity shows the
% jump backward and only repeat previous lines

if quantity(numtime_bw)==quantity(numtime_bw+jump_bw+1) || sum(diff(quantity(numtime_bw-10:numtime_bw-1)),2)/length(diff(quantity(numtime_bw-10:numtime_bw-1)))
    % the quantity shows the jump as well; hence, the scanlines are only
    % repeated ("quantity(numtime_bw)==quantity(numtime_bw+jump_bw+1)"). 
    % Correct this by cutting out the repeated scanlines
    
    %2nd condition tries to capture the originalscanlinenumber-variable: in
    %the repeating-scanline case, the scanline numbers are not repeated!
    %But the superflous (corresponding repeated) scanlines need to be
    %deleted. Hence, the originalscanlinenumber-variable needs to be
    %treated like every quantity. Therefore, the 2nd condition forces the
    %code, to act on originalscanlinenumber-variable as well (2nd condition
    %checks whether the values only increased by one per scanline. In this
    %case the variable is the scanlinenumber.)
    
    quantity(numtime_bw:numtime_bw+jump_bw)=[];
    timevec(numtime_bw:numtime_bw+jump_bw)=[];
    
    a=[1:1:length(quantity)];
    a_old=a;

    
else
    % The time seems to jump backward while the quantity does not repeat
    % its values. This is an undefined case.
    disp('ERROR: Fill_missing_scanlines: There is a time jump backward without data being repeated.')
    disp('Fill_missing_scanlines: I will stop here.')
    
    return

    
end



end



% make new timediff, restart so to say, on pre-cleaned quantity
diffscnlintime=diff(timevec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of scanline with forward jump in time
number_of_scnlinwithjumptime=find(diffscnlintime>2*2680);%for MHS and AMSUB: 2666 ms is the usual time step between 2 calibr. cycles

for i=length(number_of_scnlinwithjumptime):-1:1
%num=number_of_scnlinwithjump(i);
numtime=number_of_scnlinwithjumptime(i);

%scanline_jump=num+1;
%jumplines=diffscnlin(num); %how many lines are skipped
scanline_jumptime=numtime+1;
jumptime=diffscnlintime(numtime); %by how much does the time jump?

assert(jumptime<6128*1000,...
	'fill_missing_scanlines:timejump_toolarge',...
    'Time jump forward larger than one orbit detected.')

number_skipped_scnlin=round(jumptime*0.001*3/8); %how many scancycles. i.e. scanlines are skipped according to time-jump?
jump=number_skipped_scnlin;

quantity(scanline_jumptime+(jump):length(a_old)+(jump))=quantity(scanline_jumptime:end);

%a(scanline_jump+(jump):length(a_old)+(jump))=a(scanline_jump:end);

%a(scanline_jump:scanline_jump+jump-1)=[a(scanline_jump-1)+1:1:length(a)]; % insert new scanline numbers

%if jumplines~=jump %if the scanline number jumped by a different amount than the time, the new scanlinenumbering needs adjustment
     % watch out! what if scnanumbers jump less than time? is the length adapted accordingly already in the lines above?
%end

quantity(scanline_jumptime:scanline_jumptime+jump-1)=value2fill;
a=[1:1:length(quantity)]; %make intermediate new scanline vector starting at 1
a_old=a;
end
%disp('new')
scanlines_new=a;
quantity_new=quantity;

