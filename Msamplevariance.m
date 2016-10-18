
% function for computing M-sample variance 


function Mvar= Msamplevariance(y,startline,M)

startindex=startline;
endindex=startindex+M-1;

Mvar=1/(M-1) * (sum(double(y(:,startindex:endindex).^2),2)-1/M* (double(sum(y(:,startindex:endindex),2).^2)));





end














