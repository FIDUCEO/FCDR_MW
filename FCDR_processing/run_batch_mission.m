

% script to run batch jobs
startmissionyear=2013;
endmissionyear=2017;

% for processing certain months of two subsequent years
%  monthstart_for_year=[9 1]; %start in Sept resp. Jan 9 1 
%  monthend_for_year=[12 2]; % end in Dec. resp. Feb 12 2
year_number=0;

for chosen_year=startmissionyear:1:endmissionyear
year_number=year_number+1;

for month_num=1:12%monthstart_for_year(year_number):monthend_for_year(year_number)%9:12 1:12%
%cmd='sbatch_simple -x "ctc[136-139]" F11Y@@YEAR@@M@@MONTH@@ 16 matlab -nodisplay -r "generate_Eq2Eq_FCDR_monthly\(\''@@SAT@@\'',\''@@SEN@@\'',@@YEAR@@,@@MONTH@@\),exit"';

%using new FCDR generator
cmd='sbatch_simple -x "ctc[138-139]" MBY@@YEAR@@M@@MONTH@@ 16 matlab -nodisplay -r "FCDR_generator\(\''@@SAT@@\'',\''@@SEN@@\'',@@YEAR@@,@@MONTH@@\),exit"';


satellite='metopb'; %watch out! adapt the job name in the line above to NXX, XX=sat. number
sensor='mhs';
year_num=chosen_year;%2011;
%month_num=2;


fullcmd=strrep(strrep(strrep(strrep(cmd, '@@SAT@@',satellite),'@@SEN@@',sensor), '@@YEAR@@',num2str(year_num)),'@@MONTH@@',num2str(month_num));



system(fullcmd)
end

end
exit

