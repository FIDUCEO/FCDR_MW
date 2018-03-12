




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
