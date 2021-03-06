% READ_AMSUB   Read ALL header and data entries of AMSUB data file.
%
% The function extracts header information and all data entries of an AMSUB 
% data file.
%
% FORMAT   [hdrinfo, data, err] = read_AMSUB( file_name );
%
% IN    file_name   Name of an AMSUB data file.
% OUT   hdrinfo, data: entries of header and data record

function [hdrinfo, data,quality_indicator_lines,quality_flags_0_lines,quality_flags_1_lines,quality_flags_2_lines,quality_flags_3_lines,quality_flags_lines, err]=read_AMSUB_allvar_noh5write( filename,startline )

% we want to read this many bytes (MHS Data Set Header Record size)
rec_len = 3072;
err=0;
% UNCOMPRESS if needed
tmpdir = create_tmpfolder;
c = onCleanup(@() rmdir(tmpdir,'s'));
try
    filename = uncompress(filename,tmpdir);
catch ME
    disp( ['Error. Can''t unzip input file: ' ME.message] );
    data = [];
    hdrinfo=[];
    quality_indicator_lines= [];
    quality_flags_0_lines= [];
    quality_flags_1_lines= [];
    quality_flags_2_lines= [];
    quality_flags_3_lines= [];
    quality_flags_lines= [];
    err=1;
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
    data = [];
    hdrinfo=[];
    quality_indicator_lines= [];
    quality_flags_0_lines= [];
    quality_flags_1_lines= [];
    quality_flags_2_lines= [];
    quality_flags_3_lines= [];
    quality_flags_lines= [];
    err=1;
    return
end

hdr = read_AMSUB_header( header );
hdrinfo=hdr;
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
[record, count] = fread( file_id, uint32(rec_len) * uint32(hdr.nlines), 'uint8' );
% close a file
fclose( file_id );
% number of scan lines read
nlines_read = count / rec_len;


% if amount of data read is less than asked
if count < rec_len * hdr.nlines
    % if some scan lines are missing, we still can go on
    if iswhole( nlines_read )
        disp( 'Warning. Some scanlines are missing.' );
        % if number of scan lines is not integer, part of a record is missing
    else
        disp( 'Error. Input file is corrupt.' );
        data = [];
    hdrinfo=[];
    quality_indicator_lines= [];
    quality_flags_0_lines= [];
    quality_flags_1_lines= [];
    quality_flags_2_lines= [];
    quality_flags_3_lines= [];
    quality_flags_lines= [];
    err=1;
        return
    end
    % if input file is empty
elseif ( count == 0 )
    disp( 'Error. Input file is empty.' )
    data = [];
    hdrinfo=[];
    quality_indicator_lines= [];
    quality_flags_0_lines= [];
    quality_flags_1_lines= [];
    quality_flags_2_lines= [];
    quality_flags_3_lines= [];
    quality_flags_lines= [];
    err=1;
    return
end

[data, quality_indicator_lines,quality_flags_0_lines,quality_flags_1_lines,quality_flags_2_lines,quality_flags_3_lines,quality_flags_lines] = read_AMSUB_record( record, nlines_read, rec_len,startline ); 



end