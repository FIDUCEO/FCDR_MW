



function [hours,minutes,seconds,mi]=mills2hmsmill(input)
timeinmilliseconds=input;
timeinseconds=timeinmilliseconds/1000;
y = 60*60;
   hours = floor(timeinseconds/y);
   minutes = floor((timeinseconds-(hours*y))/60);
   seconds = floor((timeinseconds-(hours*y)-(minutes*60)));
   mi = timeinseconds*1000-(hours*y*1000)-(minutes*60*1000)-(seconds*1000);
end