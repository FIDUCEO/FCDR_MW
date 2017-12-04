


% insert NaN for missing scanlines (where scanline number jumps)



function [scanlines_new,quantity_new]=fill_missing_scanlines(timevec,scanlines,quantity,value2fill)
% procedure:
% "a" represents the vector of scan line numbers
% "quantity" represents all variables that will get NaN in the newly
% created scan line entries
a=scanlines;
a_old=a;
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
number_of_scnlinwithjumptime=find(diffscnlintime>2680);%2666 ms is the usual time step between 2 calibr. cycles

for i=length(number_of_scnlinwithjumptime):-1:1
%num=number_of_scnlinwithjump(i);
numtime=number_of_scnlinwithjumptime(i);

%scanline_jump=num+1;
%jumplines=diffscnlin(num); %how many lines are skipped
scanline_jumptime=numtime+1;
jumptime=diffscnlintime(numtime); %by how much does the time jump?

number_skipped_scnlin=round(jumptime*0.001*3/8); %how many scancycles. i.e. scanlines are skipped according to time-jump?
jump=number_skipped_scnlin;

quantity(scanline_jumptime+(jump):length(a_old)+(jump))=quantity(scanline_jumptime:end);

%a(scanline_jump+(jump):length(a_old)+(jump))=a(scanline_jump:end);

%a(scanline_jump:scanline_jump+jump-1)=[a(scanline_jump-1)+1:1:length(a)]; % insert new scanline numbers

%if jumplines~=jump %if the scanline number jumped by a different amount than the time, the new scanlinenumbering needs adjustment
     % watch out! what if scnanumbers jump less than time? is the length adapted accordingly already in the lines above?
%end

quantity(scanline_jumptime:scanline_jumptime+jump-1)=value2fill;
a=[a(1):1:length(quantity)];
a_old=a;
end
%disp('new')
scanlines_new=a;
quantity_new=quantity;

