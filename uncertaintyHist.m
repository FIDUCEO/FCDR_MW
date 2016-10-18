
%
 % Copyright (C) 2016-10-17 Imke Hans
 % This code was developed for the EC project ÒFidelity and Uncertainty in   
 %  Climate Data Records from Earth Observations (FIDUCEO)Ó. 
 % Grant Agreement: 638822
 %  <Version> Reviewed and approved by <name, instituton>, <date>
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
%




%display histograms of uncertainty

% before using this script you have to run process_uncertainty.m script.

function uncertaintyHist(selectchannel,selecteffect,uTbValue,satsenyear,selectorbit)
%select channel
%selectchannel=5;

%select effect
%selecteffect=2;



if selecteffect==1
    effectname='receiver noise';
elseif selecteffect==2
    effectname='scan angle correction';
elseif selecteffect==3
    effectname='PRT accuracy';
end









data=uTbValue{selecteffect}.Value(selectchannel,:,:);
datavec=data(:);

incr=(max(datavec)-min(datavec))/50
binranges=[min(datavec):incr : max(datavec)];
[bincounts,ind] = histc(datavec,binranges);

freqdensity=bincounts/incr;

fig1=figure
fig1.OuterPosition=[200 200 1500 600];
fig1.Position=[500 400 1300 400];
bar(binranges,freqdensity,1,'histc','b') %TAKE log(bincounts) for scan angle correction
xlabel({'$\Delta$ $T_b$ in  $K$ '}, 'interpreter','latex')
ylabel({'frequency density in 1/K'}, 'interpreter','latex')
title(['Histogram of uncertainty of effect ', num2str(selecteffect),' (', effectname,') for channel ',num2str(selectchannel), ', bin width ', num2str(incr),'K'], 'interpreter','latex')
fig1title=strcat('HistogrammOfUncertainty_effect',num2str(selecteffect),'_chn',num2str(selectchannel));

savepathfig1=strcat('/scratch/uni/u237/users/ihans/FIDUCEO_testdata/',satsenyear,'_',num2str(selectorbit),fig1title);
%fig1.PaperPositionMode = 'auto';
print(fig1,savepathfig1,'-dpng','-r0')