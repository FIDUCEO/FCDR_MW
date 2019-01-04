
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



% script to run batch jobs
startmissionyear=2000;%2014;
endmissionyear=2005;%2015; %process N16 until 2014!

% comment if not needed
% for processing certain months of two subsequent years
%monthstart_for_year=[9 1]; %start in Sept resp. Jan 9 1 
%monthend_for_year=[12 2]; % end in Dec. resp. Feb 12 2
 
year_number=0;

for chosen_year=startmissionyear:1:endmissionyear
year_number=year_number+1;

for month_num=1:12%monthstart_for_year(year_number):monthend_for_year(year_number)%9:12 1:12%

    
    %using FCDR generator
    cmd='sbatch_simple -x "ctc[139]" F15Y@@YEAR@@M@@MONTH@@ 16 matlab -nodisplay -r "FCDR_generator\(\''@@SAT@@\'',\''@@SEN@@\'',@@YEAR@@,@@MONTH@@\),exit"';


    satellite='f15'; %watch out! adapt the job name in the line above to NXX, XX=sat. number
    sensor='ssmt2';
    year_num=chosen_year;



    fullcmd=strrep(strrep(strrep(strrep(cmd, '@@SAT@@',satellite),'@@SEN@@',sensor), '@@YEAR@@',num2str(year_num)),'@@MONTH@@',num2str(month_num));



    system(fullcmd)
end

end
exit

