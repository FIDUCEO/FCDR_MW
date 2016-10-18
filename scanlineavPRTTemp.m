
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



%averaging PRT-temperatures 


function average= scanlineavPRTTemp(avPRT,scanline,ns)
midscanline=ceil(length(-ns:ns)/2); %round to next higher integer
average=0;
for i=-ns:1:ns

average=average+1/(ns+1)*((1-abs(i)/(ns+1))*avPRT(midscanline+i));
end
