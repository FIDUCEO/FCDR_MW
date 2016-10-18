
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



% READ_MHS   Read header and data entries of MHS data file.
%
% The function extracts header information and selected data entries of an MHS data file.
%
% FORMAT   [hdrinfo, data, err] = read_MHS( file_name );
%
% IN    file_name   Name of an MHS data file.
%

function [hdrinfo, data, err] = read_MHS_for_uncert( filename )

err = 0;

% we want to read this many bytes (MHS Data Set Header Record size)
rec_len = 3072;

% UNCOMPRESS if needed
tmpdir = create_tmpfolder;
c = onCleanup(@() rmdir(tmpdir,'s'));
try
    filename = uncompress(filename,tmpdir);
catch ME
    disp( ['Error. Can''t unzip input file: ' ME.message] );
    err = 1;
    hdrinfo = [];
    data = [];
    return;
end

if isempty(filename), error(errId,'Uncompressing failed'); end

% open a file
file_id = fopen( filename, 'r' );
fseek( file_id, 0, -1 );
firstbytes=fread( file_id, 3, 'uint8=>char' );
if strcmp(firstbytes', 'NSS')
    fseek( file_id, 0, -1 );
else
    fseek( file_id, 512, -1 );
end

%% read the header

[header, count] = fread( file_id, rec_len, 'uint8' );

if count ~= rec_len
    % close a file
    fclose( file_id );
    disp( 'Error. Input file is not valid.' );
    hdrinfo = [];
    data = [];
    err = 1;
    return
end

% Extracting header fields.
% Index numbers correspond to start/end octet from the KLM User Guide.
% http://www1.ncdc.noaa.gov/pub/data/satellite/publications/podguides/N-15%20thru%20N-19/pdf/0.0%20NOAA%20KLM%20Users%20Guide.pdf

hdrinfo.creationsite  = char(header(1:3)');
hdrinfo.datasetname   = char(header(23:64)');
hdrinfo.noaascid      = extract_uint16(header, 73, 74);
hdrinfo.startyear     = extract_uint16(header, 85, 86);
hdrinfo.startday      = extract_uint16(header, 87, 88);
hdrinfo.startutc      = extract_uint32(header, 89, 92)/60000;
hdrinfo.endutc        = extract_uint32(header, 101, 104)/60000;
hdrinfo.nlines        = extract_uint16(header, 135, 136);
hdrinfo.minreftemp    = extract_int16(header, 199, 200)/100;
hdrinfo.nomreftemp    = extract_int16(header, 201, 202)/100;
hdrinfo.maxreftemp    = extract_int16(header, 203, 204)/100;

%%% this gives nonsense when reading out the indicated positions!! =21 e.g. or 0 for amsub on noaa16 as well as mhs
%%% on noaa 18/19
%hdrinfo.nonlin(1)= extract_int32(header, 249, 252)/10^8;
%hdrinfo.nonlin(2)= extract_int32(header, 285, 288)/10^8;
%hdrinfo.nonlin(3)= extract_int32(header, 301, 304)/10^8;
% values are typed into instrumentalvalues.m script. Needs to be done for every
% individual instrument!


% the following coefficients are for the counts to temp. conversion for the
% housekeeping thermistos
% THEY ARE WRONG!!! signs are missing...read them from appendix and type them by hand
    hdrinfo.thermcoeff(1)=355.9982;%double(extract_int32(header, 589, 592))/10000;
    hdrinfo.thermcoeff(2)=-0.239278;%double(extract_int32(header, 593, 596))/10^7;
    hdrinfo.thermcoeff(3)=-4.85712E-03;%double(extract_int32(header, 597, 600))/10^10;
    hdrinfo.thermcoeff(4)=3.59838E-05;%double(extract_int32(header, 601, 604))/10^12;
    hdrinfo.thermcoeff(5)=-8.02652E-08;%double(extract_int32(header, 605, 608))/10^15;




% the following coefficients are for the resistance-to-temperature conversion, to be used in a later version of the program
for i=1:10
    hdrinfo.caltargettempcoeff((i-1)*4+1) = double(extract_int32(header, 673+(i-1)*16, 673+(i-1)*16+3)) / 10^6;
    hdrinfo.caltargettempcoeff((i-1)*4+2) = double(extract_int32(header, 677+(i-1)*16, 677+(i-1)*16+3)) / 10^6;
    hdrinfo.caltargettempcoeff((i-1)*4+3) = double(extract_int32(header, 681+(i-1)*16, 681+(i-1)*16+3)) / 10^10;
    hdrinfo.caltargettempcoeff((i-1)*4+4) = double(extract_int32(header, 685+(i-1)*16, 685+(i-1)*16+3)) / 10^13;
end


%% read data

% skip the header
fseek( file_id, rec_len, -1 );

% file names not starting with NSS have 512 additional lines

if strcmp(firstbytes', 'NSS')
    fseek( file_id, rec_len, -1 );
else
    fseek( file_id, rec_len+512, -1 );
end


% read all records
[record, count] = fread( file_id, uint32(rec_len) * uint32(hdrinfo.nlines), 'uint8' );
% close a file
fclose( file_id );
% number of scan lines read
nlines_read = count / rec_len;

% if amount of data read is less than asked
if count < rec_len * hdrinfo.nlines
    % if some scan lines are missing, we still can go on
    if iswhole( nlines_read )
        disp( 'Warning. Some scanlines are missing.' );
        % if number of scan lines is not integer, part of a record is missing
    else
        disp( 'Error. Input file is corrupt.' );
        data = [];
        err = 1;
        return
    end
    % if input file is empty
elseif ( count == 0 )
    disp( 'Error. Input file is empty.' )
    data = [];
    err = 1;
    return
end

% Extracting data fields
% read Calibration Quality Flags
% Index numbers correspond to start/end octet from the KLM User Guide, see above.
data.flag17   = extract_uint16(record, 35, 36);
data.flag18   = extract_uint16(record, 37, 38);
data.flag19   = extract_uint16(record, 39, 40);
data.flag20   = extract_uint16(record, 41, 42);
data.h3cold0  = extract_int16(record, 245, 246);

% loop over all lines
for line=1:nlines_read
    
    data.year(line)     = extract_uint16(record, 3, 4);
    data.day(line)      = extract_uint16(record, 5, 6);
    data.time(line)     = extract_uint32(record, rec_len*(line-1)+9, rec_len*(line-1)+12)/1000;
    
    
    data.LO5tempcounts(line)=double(extract_uint8(record, rec_len*(line-1)+2696+4-1, rec_len*(line-1)+2696+4-1));
    data.LO5temp(line)=hdrinfo.thermcoeff(1)+hdrinfo.thermcoeff(2)*data.LO5tempcounts(line)+hdrinfo.thermcoeff(3)*data.LO5tempcounts(line)^2+hdrinfo.thermcoeff(4)*data.LO5tempcounts(line)^3+hdrinfo.thermcoeff(5)*data.LO5tempcounts(line)^4;
    
    % read view position in lat/lon %% for values greater than 180deg, or
    % negative values there is still a bug> lat jumps to 213906
    %for i=1:90
    %data.viewlatlonraw(i,:,line)= [extract_int32(record, rec_len*(line-1)+753+(i-1)*8, rec_len*(line-1)+756+(i-1)*8) extract_int32(record, rec_len*(line-1)+757+(i-1)*8, rec_len*(line-1)+760+(i-1)*8)]; 
    %end
    %data.viewlatlon=double(data.viewlatlonraw./10000);

    
    for channel = 1:5
        
        
        
        
        for view = 1:4
             % read counts for deep space view
             data.countsdsv(view,channel,line) = extract_uint16(record, rec_len*(line-1)+2571+(channel-1)*2+(view-1)*12, rec_len*(line-1)+2571+(channel-1)*2+(view-1)*12+1);
             % read counts for onboard calibration target 
             data.countsobct(view,channel,line) = extract_uint16(record, rec_len*(line-1)+2619+(channel-1)*2+(view-1)*12, rec_len*(line-1)+2619+(channel-1)*2+(view-1)*12+1);
       
        end
        
        data.countsobctViewmean(line,channel)=double(mean(data.countsobct(:,channel,line)));
        data.countsdsvViewmean(line,channel)=double(mean(data.countsdsv(:,channel,line)));
   
        for view = 1:90
        % read counts for earth view    
            data.countsEarth(view,channel,line) = extract_uint16(record, rec_len*(line-1)+1483+(channel-1)*2+(view-1)*12, rec_len*(line-1)+1483+(channel-1)*2+(view-1)*12+1);
                       
        end
    
    
    end   
        % read counts for onboard calibration target 
        % data.countsobct(channel,line) = extract_uint16(record, rec_len*(line-1)+2619+(channel-1)*2, rec_len*(line-1)+2619+(channel-1)*2+1);
        
        % read calibration target temperature for PRT 1-5, reading directly computed OBCT temperatures
        for i=2:6
        	data.caltargettemp(line,i-1) = double(extract_uint32(record, rec_len*(line-1)+2769+(i-2)*4, rec_len*(line-1)+2769+(i-2)*4+3))*10^(-3);
        end
        
        %data.caltargettempmean(line)=mean(data.caltargettemp(line,:));
         data.caltargettempmean(line)=1/6 *(2*data.caltargettemp(line,1)+data.caltargettemp(line,2)+data.caltargettemp(line,3)+data.caltargettemp(line,4)+data.caltargettemp(line,5));
        
        % Calculate gain per channel and line XXXX benutze gemittelte obct und
        % dsv views und gemittelte caltemp --> gemittelter gain
        
        for channel =1:5
        	data.gain(line,channel)=double(double(data.countsobctViewmean(line, channel))-double(data.countsdsvViewmean(line,channel)))/double(data.caltargettempmean(line)-2.725);
        end
        
        %data.caltargettemp(channel,line) = extract_uint32(record, rec_len*(line-1)+2769+(channel-1)*4, rec_len*(line-1)+2769+(channel-1)*4+3);   
          
    
    
end

end


function value = extract_uint16(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'uint16');
end

function value = extract_int16(bytearr, startbyte, endbyte)
value = typecast(int8(bytearr(endbyte:-1:startbyte)), 'int16');
end

function value = extract_int32(bytearr, startbyte, endbyte)
value = typecast(int8(bytearr(endbyte:-1:startbyte)), 'int32');
end

function value = extract_uint32(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'uint32');
end

function value = extract_uint8(bytearr, startbyte, endbyte)
value = typecast(uint8(bytearr(endbyte:-1:startbyte)), 'uint8');
end      
    
