

% script to run batch jobs
startmissionyear=2014;
endmissionyear=2014;

for chosen_year=startmissionyear:1:endmissionyear

for month_num=11:11
%cmd='sbatch_simple -x "ctc[136-139]" F11Y@@YEAR@@M@@MONTH@@ 16 matlab -nodisplay -r "generate_Eq2Eq_FCDR_monthly\(\''@@SAT@@\'',\''@@SEN@@\'',@@YEAR@@,@@MONTH@@\),exit"';

%using new FCDR generator
cmd='sbatch_simple -x "ctc[136-139]" F11Y@@YEAR@@M@@MONTH@@ 16 matlab -nodisplay -r "FCDR_generator\(\''@@SAT@@\'',\''@@SEN@@\'',@@YEAR@@,@@MONTH@@\),exit"';


satellite='noaa18'; %watch out! adapt the job name in the line above to NXX, XX=sat. number
sensor='mhs';
year_num=chosen_year;%2011;
%month_num=2;


fullcmd=strrep(strrep(strrep(strrep(cmd, '@@SAT@@',satellite),'@@SEN@@',sensor), '@@YEAR@@',num2str(year_num)),'@@MONTH@@',num2str(month_num));



system(fullcmd)
end

end
exit

