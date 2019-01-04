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




% function to set NaN values to FillValue of target datatype and transform
% values to target data type


function variable_changed=change_type(datatype,variable)

if strcmp(datatype,'uint8')
    fillvalue=255;
    
    variable(isnan(variable))=fillvalue;
    variable_changed=uint8(variable);
    
elseif strcmp(datatype,'uint16')
    fillvalue=65535;
    variable(isnan(variable))=fillvalue;
    variable_changed=uint16(variable);
    
elseif strcmp(datatype,'uint32')
    fillvalue=4294967295;       
    variable(isnan(variable))=fillvalue;
    variable_changed=uint32(variable);
    
elseif strcmp(datatype,'int8')
    fillvalue=-128;
    variable(isnan(variable))=fillvalue;
    variable_changed=int8(variable);
    
elseif strcmp(datatype,'int16')
    fillvalue=-32768;    
    variable(isnan(variable))=fillvalue;
    variable_changed=int16(variable);
    
elseif strcmp(datatype,'int32')
    fillvalue=-2147483648;    
    variable(isnan(variable))=fillvalue;
    variable_changed=int32(variable);
    
    
end


end
