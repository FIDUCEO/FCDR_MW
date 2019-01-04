%% WRITE PORTION OF THIS EXAMPLE
% Generate cellstr (a cell array of strings)
% First element is '0123456789'
% Second element is 'abcdefghijklmnopqrstuvwxyz'
str = {'0':'9';'a':'z'};

% Generate a file
fid = H5F.create('/scratch/uni/u237/users/ihans/xchange/vlen_string_test.h5','H5F_ACC_TRUNC',...
    'H5P_DEFAULT','H5P_DEFAULT');

% Set variable length string type
VLstr_type = H5T.copy('H5T_C_S1');
H5T.set_size(VLstr_type,'H5T_VARIABLE');

% Create a dataspace for cellstr
H5S_UNLIMITED = H5ML.get_constant_value('H5S_UNLIMITED');
dspace = H5S.create_simple(1,numel(str),H5S_UNLIMITED);

% Create a dataset plist for chunking
plist = H5P.create('H5P_DATASET_CREATE');
H5P.set_chunk(plist,2); % 2 strings per chunk

% Create dataset
dset = H5D.create(fid,'VLstr',VLstr_type,dspace,plist);

% Write data
H5D.write(dset,VLstr_type,'H5S_ALL','H5S_ALL','H5P_DEFAULT',str);

% Close file & resources
H5P.close(plist);
H5T.close(VLstr_type);
H5S.close(dspace);
H5D.close(dset);
H5F.close(fid);