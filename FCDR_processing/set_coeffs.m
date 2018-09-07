



% coefficients for
%  -count limits DSV and IWCT
%  -alpha
%  -antenna correction
%  - spectral response function values

% load SRF files from O. Bobryshev:
load '/scratch/uni/u237/users/ihans/FIDUCEO_testdata/SRF_MHS/b_qrr_all.mat'
load '/scratch/uni/u237/users/ihans/FIDUCEO_testdata/SRF_MHS/b102_all.mat'
%  

%% F11 SSMT2
%%%%%% Count limits %%%%% 1st comment are limits suggested by me
count_thriwct_ch1=[3100 3600];
count_thriwct_ch2=[3100 3700];
count_thriwct_ch3=[2900 3700];%[22000 33000];%[9000 28000];
count_thriwct_ch4=[2900 3700];%[18000 30000];%[7000 23000];
count_thriwct_ch5=[3000 3700];%[15000 28000];%[5000 22000];

count_thrdsv_ch1=[400 900];
count_thrdsv_ch2=[600 1800];
count_thrdsv_ch3=[400 1200];%[17000 28000];%[8000 24000]; 
count_thrdsv_ch4=[10 700];%[15000 25000];%[6000 20000]; 
count_thrdsv_ch5=[400 1200];%[12500 23000];%[4000 18000]; 

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[200 200 200 200 200]; % allowed jump in meancounts between two subsequent scanlines
threshold_earth=[700 700 700 700 700];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0]; % there are no alpha values given for AMSUB ??? FIXME check this
% All SSMT2 channels are horizontally polarized (as MHS ch3,4) (Burns1998). Hence, the
% alpha should be negative.

%%%%% ANTENNA CORRECTION %%%%%%%%%
% read from header

%%%%% SPECTRAL RESPONSE FUNCTION %%%%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI. Set all to zero.
u_RFI_counts=zeros(3,5);


                            
           save('coeffs_f11ssmt2_alpha.mat', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

%% F12 SSMT2
%%%%%% Count limits %%%%% 1st comment are limits suggested by me
count_thriwct_ch1=[3100 3600];
count_thriwct_ch2=[3100 3700];
count_thriwct_ch3=[2900 3700];%[22000 33000];%[9000 28000];
count_thriwct_ch4=[2900 3700];%[18000 30000];%[7000 23000];
count_thriwct_ch5=[3000 3700];%[15000 28000];%[5000 22000];

count_thrdsv_ch1=[400 900];
count_thrdsv_ch2=[600 1800];
count_thrdsv_ch3=[400 1200];%[17000 28000];%[8000 24000]; 
count_thrdsv_ch4=[400 1200];%[15000 25000];%[6000 20000]; 
count_thrdsv_ch5=[100 1200];%[12500 23000];%[4000 18000]; 

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[200 200 200 200 200]; % allowed jump in meancounts between two subsequent scanlines
threshold_earth=[700 700 700 700 700];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0]; % there are no alpha values given for AMSUB ??? FIXME check this
% All SSMT2 channels are horizontally polarized (as MHS ch3,4) (Burns1998). Hence, the
% alpha should be negative.

%%%%% ANTENNA CORRECTION %%%%%%%%%
% read from header

%%%%% SPECTRAL RESPONSE FUNCTION %%%%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI. Set all to zero.
u_RFI_counts=zeros(3,5);


                            
           save('coeffs_f12ssmt2_alpha.mat', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

%% F14 SSMT2
%%%%%% Count limits %%%%% 1st comment are limits suggested by me
count_thriwct_ch1=[3100 3600];
count_thriwct_ch2=[3100 3700];
count_thriwct_ch3=[2900 4000];%[22000 33000];%[9000 28000];
count_thriwct_ch4=[2900 3800];%[18000 30000];%[7000 23000];
count_thriwct_ch5=[3000 4000];%[15000 28000];%[5000 22000];

count_thrdsv_ch1=[200 1200];
count_thrdsv_ch2=[600 1500];
count_thrdsv_ch3=[400 1500];%[17000 28000];%[8000 24000]; 
count_thrdsv_ch4=[400 1200];%[15000 25000];%[6000 20000]; 
count_thrdsv_ch5=[400 2000];%[12500 23000];%[4000 18000]; 

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[200 200 200 200 200]; % allowed jump in meancounts between two subsequent scanlines
threshold_earth=[700 700 700 700 700];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0]; % there are no alpha values given for AMSUB ??? FIXME check this
% All SSMT2 channels are horizontally polarized (as MHS ch3,4) (Burns1998). Hence, the
% alpha should be negative.

%%%%% ANTENNA CORRECTION %%%%%%%%%
% read from header

%%%%% SPECTRAL RESPONSE FUNCTION %%%%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI. Set all to zero.
u_RFI_counts=zeros(3,5);


                            
           save('coeffs_f14ssmt2_alpha.mat', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

           
%% F15 SSMT2
%%%%%% Count limits %%%%% 1st comment are limits suggested by me
count_thriwct_ch1=[3000 3800];
count_thriwct_ch2=[3100 3700];
count_thriwct_ch3=[3000 3900];%[22000 33000];%[9000 28000];
count_thriwct_ch4=[3000 3900];%[18000 30000];%[7000 23000];
count_thriwct_ch5=[3000 3900];%[15000 28000];%[5000 22000];

count_thrdsv_ch1=[400 1400];
count_thrdsv_ch2=[600 1800];
count_thrdsv_ch3=[100 1400];%[17000 28000];%[8000 24000]; 
count_thrdsv_ch4=[500 1800];%[15000 25000];%[6000 20000]; 
count_thrdsv_ch5=[900 1900];%[12500 23000];%[4000 18000]; 

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[200 200 200 200 200]; % allowed jump in meancounts between two subsequent scanlines
threshold_earth=[700 700 700 700 700];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0]; % there are no alpha values given for AMSUB ??? FIXME check this
% All SSMT2 channels are horizontally polarized (as MHS ch3,4) (Burns1998). Hence, the
% alpha should be negative.

%%%%% ANTENNA CORRECTION %%%%%%%%%
% read from header

%%%%% SPECTRAL RESPONSE FUNCTION %%%%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI. Set all to zero.
u_RFI_counts=zeros(3,5);


                            
           save('coeffs_f15ssmt2_alpha.mat', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

%% NOAA 15 AMSUB
%%%%%% Count limits %%%%% 1st comment are limits suggested by me
count_thriwct_ch1=[23000 28000];
count_thriwct_ch2=[23000 28000];
count_thriwct_ch3=[22000 33000];%[22000 33000];%[9000 28000];
count_thriwct_ch4=[18000 30000];%[18000 30000];%[7000 23000];
count_thriwct_ch5=[15000 28000];%[15000 28000];%[5000 22000];

count_thrdsv_ch1=[16000 22000];
count_thrdsv_ch2=[17000 23000];
count_thrdsv_ch3=[17000 28000];%[17000 28000];%[8000 24000]; 
count_thrdsv_ch4=[15000 25000];%[15000 25000];%[6000 20000]; 
count_thrdsv_ch5=[12500 23000];%[12500 23000];%[4000 18000]; 

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[50 80 100 70 60]; % allowed jump in meancounts between two subsequent scanlines
threshold_earth=[2000 2000 500 600 900];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0]; % there are no alpha values given for AMSUB ??? FIXME check this
                        %alpha=[0.0002 0.0015 0.0022 0.0022 0.0021]; %n18 values

%%%%% ANTENNA CORRECTION %%%%%%%%%

%type in manually the values from fdf.dat file
                           %for individual instrument
                           
                           
                           
                           % for each channel there are 90 values
                                % indicating the fraction of the earth signal/ space/ platform of the total signal 
                                % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                                % instrument per satellite

                                %gE fraction of signal that comes from earth
                                gE(1,:)=reshape([
                                0.997074 0.997264 0.997422 0.997581 0.997737 0.998033 0.998167 0.998285 0.998391 0.998501 
                                0.998597 0.998700 0.998823 0.998946 0.999081 0.999322 0.999399 0.999474 0.999532 0.999595
                                0.999658 0.999715 0.999764 0.999835 0.999873 0.999945 0.999962 0.999975 0.999983 0.999988
                                0.999991 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 0.999997 0.999995 0.999992 0.999979 0.999969 0.999956 0.999940 0.999922
                                0.999887 0.999848 0.999802 0.999754 0.999706 0.999604 0.999533 0.999449 0.999376 0.999296
                                0.999209 0.999115 0.999022 0.998927 0.998797 0.998488 0.998299 0.998000 0.997614 0.997189 ].',[1], [90]);

                                gE(2,:)=reshape([
                                0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
                                0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
                                0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
                                0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
                                0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
                                0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);


                                gE(3,:)=reshape([
                                0.998616	0.998643	0.998665	0.998686	0.998706	0.998742	0.998758	0.998773	0.998786	0.998798
                                0.998807	0.998864	0.998920	0.998980	0.999039	0.999151	0.999203	0.999254	0.999304	0.999354
                                0.999402	0.999451	0.999611	0.999692	0.999716	0.999853	0.999852	0.999879	0.999938	0.999938
                                0.999979	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	0.999996	0.999992	0.999985
                                0.999980	0.999972	0.999965	0.999956	0.999941	0.999893	0.999860	0.999829	0.999778	0.999734 ].',[1], [90]);

                            
                                gE(4,:)=gE(3,:);
                                gE(5,:)=gE(3,:);
%                                 gE(4,:)=reshape([
%                                 0.997074	0.997264	0.997422	0.997581	0.997737	0.998033	0.998167	0.998285	0.998391	0.998501
%                                 0.998597	0.998700	0.998823	0.998946	0.999081	0.999322	0.999399	0.999474	0.999532	0.999595
%                                 0.999658	0.999715	0.999764	0.999835	0.999873	0.999945	0.999962	0.999975	0.999983	0.999988
%                                 0.999991	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	0.999997	0.999995	0.999992	0.999979	0.999969	0.999956	0.999940	0.999922
%                                 0.999887	0.999848	0.999802	0.999754	0.999706	0.999604	0.999533	0.999449	0.999376	0.999296
%                                 0.999209	0.999115	0.999022	0.998927	0.998797	0.998488	0.998299	0.998000	0.997614	0.997189 ].',[1], [90]);
% 
%                                 gE(5,:)=reshape([
%                                 0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
%                                 0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
%                                 0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
%                                 0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
%                                 0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
%                                 0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);

                                %gS fraction of signal that comes from space
                                gS(1,:)=reshape([
                                0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
                                0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
                                0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
                                0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
                                0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
                                0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);

                                gS(2,:)=reshape([
                                0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
                                0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
                                0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
                                0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
                                0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                gS(3,:)=reshape([
                                0.000226	0.000296	0.000287	0.000278	0.000317	0.000400	0.000444	0.000489	0.000534	0.000580
                                0.000627	0.000624	0.000620	0.000614	0.000606	0.000657	0.000606	0.000556	0.000506	0.000457
                                0.000409	0.000361	0.000201	0.000120	0.000121	0.000020	0.000020	0.000020	0.000021	0.000021
                                0.000021	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000004	0.000008	0.000015
                                0.000020	0.000028	0.000035	0.000044	0.000059	0.000107	0.000140	0.000171	0.000222	0.000266 ].',[1], [90]);

                                gS(4,:)=gS(3,:);
                                gS(5,:)=gS(3,:);
%                                 gS(4,:)=reshape([
%                                 0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
%                                 0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
%                                 0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
%                                 0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
%                                 0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
%                                 0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);
% 
%                                 gS(5,:)=reshape([
%                                 0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
%                                 0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
%                                 0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
%                                 0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
%                                 0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                %gSAT fraction of signal that comes from platform
                                gSAT(1,:)=reshape([
                                0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
                                0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
                                0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
                                0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(2,:)=reshape([
                                0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
                                0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
                                0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
                                0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(3,:)=reshape([
                                0.001158	0.001061	0.001048	0.001036	0.000977	0.000858	0.000798	0.000738	0.000680	0.000622
                                0.000566	0.000512	0.000460	0.000406	0.000355	0.000192	0.000191	0.000190	0.000190	0.000189
                                0.000189	0.000188	0.000188	0.000188	0.000163	0.000127	0.000128	0.000101	0.000041	0.000041
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(4,:)=gSAT(3,:);
                                gSAT(5,:)=gSAT(3,:);
%                                 gSAT(4,:)=reshape([
%                                 0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
%                                 0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
%                                 0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
%                                 0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(5,:)=reshape([
%                                 0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
%                                 0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
%                                 0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
%                                 0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                            
% read out frequencies and weights for SRF
% from O. Bobryshev's .mat-file

%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI
u_RFI_counts=zeros(3,5);
%earthviews
u_RFI_counts(1,1)=26;
u_RFI_counts(1,2)=300;
u_RFI_counts(1,3)=40;
u_RFI_counts(1,4)=665;
u_RFI_counts(1,5)=144;
%DSv and IWCT are zero for N15 since all is put into earthviews.

                            
           save('coeffs_noaa15amsub_antcorr_alpha.mat', 'gE','gS','gSAT', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

           
%% NOAA 16 AMSUB

%%%%%% Count limits %%%%% 1st comment are limits sugested by me
count_thriwct_ch1=[21000 27000];
count_thriwct_ch2=[23000 27500];
count_thriwct_ch3=[19000 27500];%[19000 27500];%[7200 27500]; 
count_thriwct_ch4=[17000 24000];%[17000 24000];%[2200 24000];
count_thriwct_ch5=[21000 26000];%[21000 26000];%[8700 26000];

count_thrdsv_ch1=[15000 20000];
count_thrdsv_ch2=[19000 23000];
count_thrdsv_ch3=[16000 23000];%[16000 23000];%[7000 23000];
count_thrdsv_ch4=[14000 21000];%[14000 21000];%[2000 21000];
count_thrdsv_ch5=[18000 23000];%[18000 23000];%[8500 23000];

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[50 60 80 65 45]; % allowed jump in meancounts between two subsequent scanlines
threshold_earth=[2000 2000 500 600 900];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0];
                        %alpha=[0.0002 0.0015 0.0022 0.0022 0.0021];


%%%%% ANTENNA CORRECTION %%%%%%%%%

%type in manually the values from fdf.dat file
                           %for individual instrument
                           
                           
                           
                           % for each channel there are 90 values
                                % indicating the fraction of the earth signal/ space/ platform of the total signal 
                                % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                                % instrument per satellite

                                %gE fraction of signal that comes from earth
                                gE(1,:)=reshape([
                                0.997074 0.997264 0.997422 0.997581 0.997737 0.998033 0.998167 0.998285 0.998391 0.998501 
                                0.998597 0.998700 0.998823 0.998946 0.999081 0.999322 0.999399 0.999474 0.999532 0.999595
                                0.999658 0.999715 0.999764 0.999835 0.999873 0.999945 0.999962 0.999975 0.999983 0.999988
                                0.999991 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 0.999997 0.999995 0.999992 0.999979 0.999969 0.999956 0.999940 0.999922
                                0.999887 0.999848 0.999802 0.999754 0.999706 0.999604 0.999533 0.999449 0.999376 0.999296
                                0.999209 0.999115 0.999022 0.998927 0.998797 0.998488 0.998299 0.998000 0.997614 0.997189 ].',[1], [90]);

                                gE(2,:)=reshape([
                                0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
                                0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
                                0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
                                0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
                                0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
                                0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);


                                gE(3,:)=reshape([
                                0.998616	0.998643	0.998665	0.998686	0.998706	0.998742	0.998758	0.998773	0.998786	0.998798
                                0.998807	0.998864	0.998920	0.998980	0.999039	0.999151	0.999203	0.999254	0.999304	0.999354
                                0.999402	0.999451	0.999611	0.999692	0.999716	0.999853	0.999852	0.999879	0.999938	0.999938
                                0.999979	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	0.999996	0.999992	0.999985
                                0.999980	0.999972	0.999965	0.999956	0.999941	0.999893	0.999860	0.999829	0.999778	0.999734 ].',[1], [90]);

                            
                                gE(4,:)=gE(3,:);
                                gE(5,:)=gE(3,:);
%                                 gE(4,:)=reshape([
%                                 0.997074	0.997264	0.997422	0.997581	0.997737	0.998033	0.998167	0.998285	0.998391	0.998501
%                                 0.998597	0.998700	0.998823	0.998946	0.999081	0.999322	0.999399	0.999474	0.999532	0.999595
%                                 0.999658	0.999715	0.999764	0.999835	0.999873	0.999945	0.999962	0.999975	0.999983	0.999988
%                                 0.999991	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	0.999997	0.999995	0.999992	0.999979	0.999969	0.999956	0.999940	0.999922
%                                 0.999887	0.999848	0.999802	0.999754	0.999706	0.999604	0.999533	0.999449	0.999376	0.999296
%                                 0.999209	0.999115	0.999022	0.998927	0.998797	0.998488	0.998299	0.998000	0.997614	0.997189 ].',[1], [90]);
% 
%                                 gE(5,:)=reshape([
%                                 0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
%                                 0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
%                                 0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
%                                 0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
%                                 0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
%                                 0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);

                                %gS fraction of signal that comes from space
                                gS(1,:)=reshape([
                                0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
                                0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
                                0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
                                0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
                                0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
                                0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);

                                gS(2,:)=reshape([
                                0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
                                0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
                                0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
                                0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
                                0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                gS(3,:)=reshape([
                                0.000226	0.000296	0.000287	0.000278	0.000317	0.000400	0.000444	0.000489	0.000534	0.000580
                                0.000627	0.000624	0.000620	0.000614	0.000606	0.000657	0.000606	0.000556	0.000506	0.000457
                                0.000409	0.000361	0.000201	0.000120	0.000121	0.000020	0.000020	0.000020	0.000021	0.000021
                                0.000021	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000004	0.000008	0.000015
                                0.000020	0.000028	0.000035	0.000044	0.000059	0.000107	0.000140	0.000171	0.000222	0.000266 ].',[1], [90]);

                                gS(4,:)=gS(3,:);
                                gS(5,:)=gS(3,:);
%                                 gS(4,:)=reshape([
%                                 0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
%                                 0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
%                                 0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
%                                 0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
%                                 0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
%                                 0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);
% 
%                                 gS(5,:)=reshape([
%                                 0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
%                                 0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
%                                 0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
%                                 0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
%                                 0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                %gSAT fraction of signal that comes from platform
                                gSAT(1,:)=reshape([
                                0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
                                0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
                                0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
                                0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(2,:)=reshape([
                                0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
                                0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
                                0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
                                0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(3,:)=reshape([
                                0.001158	0.001061	0.001048	0.001036	0.000977	0.000858	0.000798	0.000738	0.000680	0.000622
                                0.000566	0.000512	0.000460	0.000406	0.000355	0.000192	0.000191	0.000190	0.000190	0.000189
                                0.000189	0.000188	0.000188	0.000188	0.000163	0.000127	0.000128	0.000101	0.000041	0.000041
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(4,:)=gSAT(3,:);
                                gSAT(5,:)=gSAT(3,:);
%                                 gSAT(4,:)=reshape([
%                                 0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
%                                 0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
%                                 0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
%                                 0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(5,:)=reshape([
%                                 0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
%                                 0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
%                                 0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
%                                 0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

% read out frequencies and weights for SRF
% from O. Bobryshev's .mat-file

%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI
u_RFI_counts=zeros(3,5);
%earthviews
u_RFI_counts(1,1)=11;
u_RFI_counts(1,2)=8;
u_RFI_counts(1,3)=11;
u_RFI_counts(1,4)=9;
u_RFI_counts(1,5)=8;
%DSV
u_RFI_counts(2,1)=26;
u_RFI_counts(2,2)=19;
u_RFI_counts(2,3)=26;
u_RFI_counts(2,4)=22;
u_RFI_counts(2,5)=19;
%IWCT
u_RFI_counts(3,1)=9;
u_RFI_counts(3,2)=6;
u_RFI_counts(3,3)=9;
u_RFI_counts(3,4)=7;
u_RFI_counts(3,5)=6;    

           save('coeffs_noaa16amsub_antcorr_alpha.mat', 'gE','gS','gSAT', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

                            
%% NOAA 17 AMSUB

%%%%%% Count limits %%%%% 
count_thriwct_ch1=[22000 28000];
count_thriwct_ch2=[19000 25000];
count_thriwct_ch3=[30000 36000];
count_thriwct_ch4=[22000 28000];
count_thriwct_ch5=[18000 24000];

count_thrdsv_ch1=[15000 21000];
count_thrdsv_ch2=[13000 19000];
count_thrdsv_ch3=[25000 31000];
count_thrdsv_ch4=[17000 23000];
count_thrdsv_ch5=[15000 21000];

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[60 70 110 90 60]; % allowed jump in meancounts between two subsequent scanlines
threshold_earth=[2000 2000 500 600 900];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.


%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0];
                        %alpha=[0.0002 0.0015 0.0022 0.0022 0.0021];


%%%%% ANTENNA CORRECTION %%%%%%%%%

%type in manually the values from fdf.dat file
                           %for individual instrument
                           
                           
                           
                           % for each channel there are 90 values
                                % indicating the fraction of the earth signal/ space/ platform of the total signal 
                                % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                                % instrument per satellite

                               %gE fraction of signal that comes from earth
                                gE(1,:)=reshape([
                                0.997074 0.997264 0.997422 0.997581 0.997737 0.998033 0.998167 0.998285 0.998391 0.998501 
                                0.998597 0.998700 0.998823 0.998946 0.999081 0.999322 0.999399 0.999474 0.999532 0.999595
                                0.999658 0.999715 0.999764 0.999835 0.999873 0.999945 0.999962 0.999975 0.999983 0.999988
                                0.999991 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 0.999997 0.999995 0.999992 0.999979 0.999969 0.999956 0.999940 0.999922
                                0.999887 0.999848 0.999802 0.999754 0.999706 0.999604 0.999533 0.999449 0.999376 0.999296
                                0.999209 0.999115 0.999022 0.998927 0.998797 0.998488 0.998299 0.998000 0.997614 0.997189 ].',[1], [90]);

                                gE(2,:)=reshape([
                                0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
                                0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
                                0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
                                0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
                                0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
                                0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);


                                gE(3,:)=reshape([
                                0.998616	0.998643	0.998665	0.998686	0.998706	0.998742	0.998758	0.998773	0.998786	0.998798
                                0.998807	0.998864	0.998920	0.998980	0.999039	0.999151	0.999203	0.999254	0.999304	0.999354
                                0.999402	0.999451	0.999611	0.999692	0.999716	0.999853	0.999852	0.999879	0.999938	0.999938
                                0.999979	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	0.999996	0.999992	0.999985
                                0.999980	0.999972	0.999965	0.999956	0.999941	0.999893	0.999860	0.999829	0.999778	0.999734 ].',[1], [90]);

                            
                                gE(4,:)=gE(3,:);
                                gE(5,:)=gE(3,:);
%                                 gE(4,:)=reshape([
%                                 0.997074	0.997264	0.997422	0.997581	0.997737	0.998033	0.998167	0.998285	0.998391	0.998501
%                                 0.998597	0.998700	0.998823	0.998946	0.999081	0.999322	0.999399	0.999474	0.999532	0.999595
%                                 0.999658	0.999715	0.999764	0.999835	0.999873	0.999945	0.999962	0.999975	0.999983	0.999988
%                                 0.999991	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	0.999997	0.999995	0.999992	0.999979	0.999969	0.999956	0.999940	0.999922
%                                 0.999887	0.999848	0.999802	0.999754	0.999706	0.999604	0.999533	0.999449	0.999376	0.999296
%                                 0.999209	0.999115	0.999022	0.998927	0.998797	0.998488	0.998299	0.998000	0.997614	0.997189 ].',[1], [90]);
% 
%                                 gE(5,:)=reshape([
%                                 0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
%                                 0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
%                                 0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
%                                 0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
%                                 0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
%                                 0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);

                                %gS fraction of signal that comes from space
                                gS(1,:)=reshape([
                                0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
                                0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
                                0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
                                0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
                                0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
                                0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);

                                gS(2,:)=reshape([
                                0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
                                0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
                                0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
                                0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
                                0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                gS(3,:)=reshape([
                                0.000226	0.000296	0.000287	0.000278	0.000317	0.000400	0.000444	0.000489	0.000534	0.000580
                                0.000627	0.000624	0.000620	0.000614	0.000606	0.000657	0.000606	0.000556	0.000506	0.000457
                                0.000409	0.000361	0.000201	0.000120	0.000121	0.000020	0.000020	0.000020	0.000021	0.000021
                                0.000021	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000004	0.000008	0.000015
                                0.000020	0.000028	0.000035	0.000044	0.000059	0.000107	0.000140	0.000171	0.000222	0.000266 ].',[1], [90]);

                                gS(4,:)=gS(3,:);
                                gS(5,:)=gS(3,:);
%                                 gS(4,:)=reshape([
%                                 0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
%                                 0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
%                                 0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
%                                 0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
%                                 0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
%                                 0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);
% 
%                                 gS(5,:)=reshape([
%                                 0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
%                                 0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
%                                 0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
%                                 0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
%                                 0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                %gSAT fraction of signal that comes from platform
                                gSAT(1,:)=reshape([
                                0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
                                0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
                                0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
                                0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(2,:)=reshape([
                                0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
                                0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
                                0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
                                0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(3,:)=reshape([
                                0.001158	0.001061	0.001048	0.001036	0.000977	0.000858	0.000798	0.000738	0.000680	0.000622
                                0.000566	0.000512	0.000460	0.000406	0.000355	0.000192	0.000191	0.000190	0.000190	0.000189
                                0.000189	0.000188	0.000188	0.000188	0.000163	0.000127	0.000128	0.000101	0.000041	0.000041
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(4,:)=gSAT(3,:);
                                gSAT(5,:)=gSAT(3,:);
%                                 gSAT(4,:)=reshape([
%                                 0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
%                                 0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
%                                 0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
%                                 0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(5,:)=reshape([
%                                 0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
%                                 0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
%                                 0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
%                                 0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

% read out frequencies and weights for SRF
% from O. Bobryshev's .mat-file

%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI
u_RFI_counts=zeros(3,5);
%earthviews
u_RFI_counts(1,1)=120;
u_RFI_counts(1,2)=105;
u_RFI_counts(1,3)=95;
u_RFI_counts(1,4)=90;
u_RFI_counts(1,5)=50;
%DSV
u_RFI_counts(2,1)=118;
u_RFI_counts(2,2)=103;
u_RFI_counts(2,3)=93;
u_RFI_counts(2,4)=87;
u_RFI_counts(2,5)=49;
%IWCT
u_RFI_counts(3,1)=96;
u_RFI_counts(3,2)=84;
u_RFI_counts(3,3)=76;
u_RFI_counts(3,4)=71;
u_RFI_counts(3,5)=40;  
                            
           save('coeffs_noaa17amsub_antcorr_alpha.mat', 'gE','gS','gSAT', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')



%% NOAA 18 MHS

%%%%%% Count limits %%%%%
count_thriwct_ch1=[20000 64881];
count_thriwct_ch2=[20000 64881];
count_thriwct_ch3=[20000 64881];
count_thriwct_ch4=[20000 64881];
count_thriwct_ch5=[20000 64881];

count_thrdsv_ch1=[1500 28000];
count_thrdsv_ch2=[1500 28000];
count_thrdsv_ch3=[1500 28000];
count_thrdsv_ch4=[1500 28000];
count_thrdsv_ch5=[1500 28000];

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[250 250 700 500 330]; % allowed jump in meancounts between two subsequent scanlines
% threshold_earth is adapted to N18
threshold_earth=[12000 12000 8000 8000 10000];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0002 0.0015 -0.0022 -0.0022 0.0021]; % acc. to version 1 in fdf.dat file, acc. to version 2 alpha=0


%%%%% ANTENNA CORRECTION %%%%%%%%%

%type in manually the values from fdf.dat file
                           %for individual instrument
                           
                           
                           
                           % for each channel there are 90 values
                                % indicating the fraction of the earth signal/ space/ platform of the total signal 
                                % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                                % instrument per satellite

                                %gE fraction of signal that comes from earth
                                gE(1,:)=reshape([
                                0.997074 0.997264 0.997422 0.997581 0.997737 0.998033 0.998167 0.998285 0.998391 0.998501 
                                0.998597 0.998700 0.998823 0.998946 0.999081 0.999322 0.999399 0.999474 0.999532 0.999595
                                0.999658 0.999715 0.999764 0.999835 0.999873 0.999945 0.999962 0.999975 0.999983 0.999988
                                0.999991 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
                                1.000000 1.000000 0.999997 0.999995 0.999992 0.999979 0.999969 0.999956 0.999940 0.999922
                                0.999887 0.999848 0.999802 0.999754 0.999706 0.999604 0.999533 0.999449 0.999376 0.999296
                                0.999209 0.999115 0.999022 0.998927 0.998797 0.998488 0.998299 0.998000 0.997614 0.997189 ].',[1], [90]);

                                gE(2,:)=reshape([
                                0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
                                0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
                                0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
                                0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
                                0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
                                0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);


                                gE(3,:)=reshape([
                                0.998616	0.998643	0.998665	0.998686	0.998706	0.998742	0.998758	0.998773	0.998786	0.998798
                                0.998807	0.998864	0.998920	0.998980	0.999039	0.999151	0.999203	0.999254	0.999304	0.999354
                                0.999402	0.999451	0.999611	0.999692	0.999716	0.999853	0.999852	0.999879	0.999938	0.999938
                                0.999979	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
                                1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	0.999996	0.999992	0.999985
                                0.999980	0.999972	0.999965	0.999956	0.999941	0.999893	0.999860	0.999829	0.999778	0.999734 ].',[1], [90]);

                            
                                gE(4,:)=gE(3,:);
                                gE(5,:)=gE(3,:);
%                                 gE(4,:)=reshape([
%                                 0.997074	0.997264	0.997422	0.997581	0.997737	0.998033	0.998167	0.998285	0.998391	0.998501
%                                 0.998597	0.998700	0.998823	0.998946	0.999081	0.999322	0.999399	0.999474	0.999532	0.999595
%                                 0.999658	0.999715	0.999764	0.999835	0.999873	0.999945	0.999962	0.999975	0.999983	0.999988
%                                 0.999991	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	0.999997	0.999995	0.999992	0.999979	0.999969	0.999956	0.999940	0.999922
%                                 0.999887	0.999848	0.999802	0.999754	0.999706	0.999604	0.999533	0.999449	0.999376	0.999296
%                                 0.999209	0.999115	0.999022	0.998927	0.998797	0.998488	0.998299	0.998000	0.997614	0.997189 ].',[1], [90]);
% 
%                                 gE(5,:)=reshape([
%                                 0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
%                                 0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
%                                 0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
%                                 0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
%                                 0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
%                                 0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);

                                %gS fraction of signal that comes from space
                                gS(1,:)=reshape([
                                0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
                                0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
                                0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
                                0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
                                0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
                                0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);

                                gS(2,:)=reshape([
                                0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
                                0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
                                0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
                                0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
                                0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                gS(3,:)=reshape([
                                0.000226	0.000296	0.000287	0.000278	0.000317	0.000400	0.000444	0.000489	0.000534	0.000580
                                0.000627	0.000624	0.000620	0.000614	0.000606	0.000657	0.000606	0.000556	0.000506	0.000457
                                0.000409	0.000361	0.000201	0.000120	0.000121	0.000020	0.000020	0.000020	0.000021	0.000021
                                0.000021	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000004	0.000008	0.000015
                                0.000020	0.000028	0.000035	0.000044	0.000059	0.000107	0.000140	0.000171	0.000222	0.000266 ].',[1], [90]);

                                gS(4,:)=gS(3,:);
                                gS(5,:)=gS(3,:);
%                                 gS(4,:)=reshape([
%                                 0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
%                                 0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
%                                 0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
%                                 0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
%                                 0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
%                                 0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);
% 
%                                 gS(5,:)=reshape([
%                                 0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
%                                 0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
%                                 0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
%                                 0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
%                                 0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);

                                %gSAT fraction of signal that comes from platform
                                gSAT(1,:)=reshape([
                                0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
                                0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
                                0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
                                0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(2,:)=reshape([
                                0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
                                0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
                                0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
                                0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(3,:)=reshape([
                                0.001158	0.001061	0.001048	0.001036	0.000977	0.000858	0.000798	0.000738	0.000680	0.000622
                                0.000566	0.000512	0.000460	0.000406	0.000355	0.000192	0.000191	0.000190	0.000190	0.000189
                                0.000189	0.000188	0.000188	0.000188	0.000163	0.000127	0.000128	0.000101	0.000041	0.000041
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
                                0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

                                gSAT(4,:)=gSAT(3,:);
                                gSAT(5,:)=gSAT(3,:);
%                                 gSAT(4,:)=reshape([
%                                 0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
%                                 0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
%                                 0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
%                                 0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(5,:)=reshape([
%                                 0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
%                                 0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
%                                 0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
%                                 0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);

% read out frequencies and weights for SRF
% from O. Bobryshev's .mat-file

%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;

srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);

srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI
u_RFI_counts=zeros(3,5);
%earthviews
% u_RFI_counts(1,1)=120;
% u_RFI_counts(1,2)=105;
% u_RFI_counts(1,3)=95;
% u_RFI_counts(1,4)=90;
% u_RFI_counts(1,5)=50;
% %DSV
% u_RFI_counts(2,1)=118;
% u_RFI_counts(2,2)=103;
% u_RFI_counts(2,3)=93;
% u_RFI_counts(2,4)=87;
% u_RFI_counts(2,5)=49;
% %IWCT
% u_RFI_counts(3,1)=96;
% u_RFI_counts(3,2)=84;
% u_RFI_counts(3,3)=76;
% u_RFI_counts(3,4)=71;
% u_RFI_counts(3,5)=40;  
                            
           save('coeffs_noaa18mhs_antcorr_alpha.mat', 'gE','gS','gSAT', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

%% NOAA 19 MHS

%%%%%% Count limits %%%%%
count_thriwct_ch1=[20000 64881];
count_thriwct_ch2=[20000 64881];
count_thriwct_ch3=[20000 64881];
count_thriwct_ch4=[20000 64881];
count_thriwct_ch5=[20000 64881];

count_thrdsv_ch1=[1500 28000];
count_thrdsv_ch2=[1500 28000];
count_thrdsv_ch3=[1500 28000];
count_thrdsv_ch4=[1500 28000];
count_thrdsv_ch5=[1500 28000];

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[1000 1000 1000 1000 1000]; % allowed jump in meancounts between two subsequent scanlines
% threshold_earth is adapted to N18
threshold_earth=[12000 12000 8000 8000 10000];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0];
                        %alpha=[0.0002 0.0015 -0.0022 -0.0022 0.0021];


%%%%% ANTENNA CORRECTION %%%%%%%%%

%type in manually the values from fdf.dat file
                           %for individual instrument
                           
                           
                           
                           % for each channel there are 90 values
                                % indicating the fraction of the earth signal/ space/ platform of the total signal 
                                % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                                % instrument per satellite

%gE fraction of signal that comes from earth
gE(1,:)=reshape([
0.996049	0.996348	0.996651	0.996985	0.997270	0.997463	0.997685	0.997954	0.998228	0.998477
0.998724	0.998817	0.999009	0.999118	0.999156	0.999173	0.999224	0.999266	0.999308	0.999357
0.999397	0.999429	0.999463	0.999492	0.999524	0.999550	0.999575	0.999597	0.999620	0.999639
0.999661	0.999680	0.999699	0.999716	0.999732	0.999747	0.999760	0.999774	0.999784	0.999796
0.999808	0.999816	0.999825	0.999830	0.999835	0.999720	0.999720	0.999718	0.999710	0.999705
0.999697	0.999691	0.999683	0.999676	0.999666	0.999660	0.999651	0.999626	0.999609	0.999593
0.999581	0.999566	0.999553	0.999540	0.999526	0.999489	0.999447	0.999412	0.999378	0.999337
0.999293	0.999252	0.999220	0.999192	0.999156	0.999041	0.998789	0.998475	0.998064	0.997684
0.997206	0.996831	0.996508	0.996068	0.995649	0.995255	0.994865	0.994369	0.993894	0.993260].',[1], [90]);

gE(2,:)=reshape([
0.998780	0.998805	0.998824	0.998841	0.998859	0.998880	0.998899	0.998921	0.998931	0.998939
0.998953	0.998962	0.998972	0.998984	0.998991	0.998998	0.999007	0.999011	0.999025	0.999054
0.999085	0.999111	0.999141	0.999166	0.999191	0.999233	0.999251	0.999275	0.999294	0.999321
0.999341	0.999365	0.999384	0.999404	0.999430	0.999450	0.999475	0.999491	0.999512	0.999527
0.999548	0.999563	0.999587	0.999602	0.999608	0.999611	0.999609	0.999599	0.999588	0.999579
0.999568	0.999559	0.999549	0.999536	0.999525	0.999514	0.999499	0.999478	0.999460	0.999437
0.999420	0.999395	0.999376	0.999356	0.999331	0.999310	0.999282	0.999259	0.999231	0.999202
0.999172	0.999145	0.999123	0.999114	0.999097	0.999087	0.999070	0.999056	0.999043	0.999032
0.999012	0.998996	0.998976	0.998951	0.998931	0.998905	0.998878	0.998850	0.998826	0.998789 ].',[1], [90]);


gE(3,:)=reshape([
0.999269	0.999308	0.999333	0.999359	0.999376	0.999403	0.999416	0.999429	0.999433	0.999439
0.999451	0.999462	0.999503	0.999510	0.999508	0.999511	0.999504	0.999470	0.999456	0.999467
0.999473	0.999480	0.999489	0.999494	0.999503	0.999507	0.999513	0.999508	0.999518	0.999519
0.999522	0.999521	0.999518	0.999529	0.999529	0.999532	0.999528	0.999527	0.999525	0.999525
0.999522	0.999556	0.999636	0.999709	0.999712	0.999790	0.999795	0.999795	0.999796	0.999798
0.999799	0.999800	0.999802	0.999807	0.999804	0.999800	0.999791	0.999784	0.999777	0.999771
0.999762	0.999756	0.999749	0.999741	0.999733	0.999723	0.999713	0.999700	0.999691	0.999680
0.999665	0.999652	0.999642	0.999635	0.999624	0.999616	0.999602	0.999584	0.999568	0.999551
0.999531	0.999511	0.999486	0.999447	0.999409	0.999344	0.999294	0.999212	0.999102	0.998978 ].',[1], [90]);

gE(4,:)=reshape([
0.999269	0.999308	0.999333	0.999359	0.999376	0.999403	0.999416	0.999429	0.999433	0.999439
0.999451	0.999462	0.999503	0.999510	0.999508	0.999511	0.999504	0.999470	0.999456	0.999467
0.999473	0.999480	0.999489	0.999494	0.999503	0.999507	0.999513	0.999508	0.999518	0.999519
0.999522	0.999521	0.999518	0.999529	0.999529	0.999532	0.999528	0.999527	0.999525	0.999525
0.999522	0.999556	0.999636	0.999709	0.999712	0.999790	0.999795	0.999795	0.999796	0.999798
0.999799	0.999800	0.999802	0.999807	0.999804	0.999800	0.999791	0.999784	0.999777	0.999771
0.999762	0.999756	0.999749	0.999741	0.999733	0.999723	0.999713	0.999700	0.999691	0.999680
0.999665	0.999652	0.999642	0.999635	0.999624	0.999616	0.999602	0.999584	0.999568	0.999551
0.999531	0.999511	0.999486	0.999447	0.999409	0.999344	0.999294	0.999212	0.999102	0.998978 ].',[1], [90]);

gE(5,:)=reshape([
0.999228	0.999252	0.999270	0.999295	0.999315	0.999330	0.999341	0.999357	0.999372	0.999385
0.999398	0.999410	0.999430	0.999446	0.999458	0.999474	0.999491	0.999492	0.999503	0.999519
0.999539	0.999561	0.999575	0.999592	0.999609	0.999636	0.999649	0.999663	0.999674	0.999683
0.999695	0.999705	0.999716	0.999724	0.999736	0.999744	0.999756	0.999761	0.999768	0.999774
0.999781	0.999794	0.999811	0.999828	0.999830	0.999831	0.999830	0.999826	0.999821	0.999816
0.999812	0.999807	0.999802	0.999798	0.999793	0.999786	0.999778	0.999770	0.999759	0.999749
0.999738	0.999728	0.999713	0.999703	0.999691	0.999672	0.999658	0.999641	0.999623	0.999605
0.999587	0.999566	0.999549	0.999536	0.999521	0.999511	0.999491	0.999478	0.999459	0.999438
0.999413	0.999390	0.999366	0.999338	0.999314	0.999277	0.999243	0.999204	0.999168	0.999118 ].',[1], [90]);

%gS fraction of signal that comes from space
gS(1,:)=reshape([
0.002236	0.002146	0.002082	0.001986	0.001824	0.001697	0.001538	0.001333	0.001143	0.000950
0.000754	0.000657	0.000505	0.000425	0.000390	0.000373	0.000355	0.000339	0.000326	0.000310
0.000295	0.000286	0.000272	0.000263	0.000249	0.000239	0.000226	0.000216	0.000204	0.000196
0.000185	0.000175	0.000167	0.000159	0.000152	0.000144	0.000136	0.000127	0.000120	0.000113
0.000106	0.000100	0.000095	0.000092	0.000090	0.000157	0.000160	0.000166	0.000178	0.000186
0.000196	0.000204	0.000216	0.000226	0.000238	0.000247	0.000256	0.000279	0.000293	0.000306
0.000317	0.000330	0.000341	0.000351	0.000363	0.000396	0.000436	0.000467	0.000495	0.000528
0.000561	0.000592	0.000616	0.000638	0.000667	0.000772	0.001013	0.001316	0.001713	0.002078
0.002534	0.002888	0.003192	0.003603	0.003988	0.004397	0.004729	0.005083	0.005457	0.005963 ].',[1], [90]);

gS(2,:)=reshape([
0.000714	0.000699	0.000687	0.000677	0.000666	0.000657	0.000647	0.000632	0.000624	0.000620
0.000611	0.000603	0.000593	0.000582	0.000575	0.000567	0.000556	0.000552	0.000547	0.000534
0.000520	0.000507	0.000493	0.000478	0.000462	0.000432	0.000422	0.000410	0.000401	0.000386
0.000376	0.000362	0.000352	0.000341	0.000329	0.000321	0.000308	0.000295	0.000280	0.000269
0.000253	0.000241	0.000222	0.000211	0.000209	0.000211	0.000219	0.000231	0.000247	0.000260
0.000276	0.000289	0.000303	0.000321	0.000336	0.000353	0.000367	0.000385	0.000400	0.000419
0.000434	0.000454	0.000471	0.000488	0.000509	0.000527	0.000551	0.000571	0.000594	0.000612
0.000631	0.000648	0.000664	0.000671	0.000684	0.000692	0.000706	0.000718	0.000729	0.000738
0.000754	0.000769	0.000784	0.000806	0.000824	0.000846	0.000869	0.000895	0.000916	0.000948 ].',[1], [90]);

gS(3,:)=reshape([
0.000377	0.000351	0.000341	0.000331	0.000329	0.000349	0.000350	0.000346	0.000345	0.000343
0.000334	0.000322	0.000282	0.000274	0.000275	0.000272	0.000272	0.000284	0.000290	0.000284
0.000282	0.000285	0.000285	0.000281	0.000274	0.000271	0.000271	0.000275	0.000267	0.000264
0.000262	0.000262	0.000263	0.000255	0.000260	0.000283	0.000297	0.000298	0.000301	0.000302
0.000304	0.000271	0.000190	0.000119	0.000116	0.000089	0.000092	0.000099	0.000104	0.000112
0.000118	0.000127	0.000133	0.000139	0.000147	0.000154	0.000162	0.000167	0.000174	0.000179
0.000186	0.000192	0.000198	0.000206	0.000211	0.000221	0.000229	0.000240	0.000247	0.000255
0.000264	0.000273	0.000281	0.000287	0.000295	0.000303	0.000314	0.000329	0.000343	0.000355
0.000373	0.000391	0.000414	0.000448	0.000485	0.000546	0.000592	0.000669	0.000770	0.000888 ].',[1], [90]);

gS(4,:)=reshape([
0.000377	0.000351	0.000341	0.000331	0.000329	0.000349	0.000350	0.000346	0.000345	0.000343
0.000334	0.000322	0.000282	0.000274	0.000275	0.000272	0.000272	0.000284	0.000290	0.000284
0.000282	0.000285	0.000285	0.000281	0.000274	0.000271	0.000271	0.000275	0.000267	0.000264
0.000262	0.000262	0.000263	0.000255	0.000260	0.000283	0.000297	0.000298	0.000301	0.000302
0.000304	0.000271	0.000190	0.000119	0.000116	0.000089	0.000092	0.000099	0.000104	0.000112
0.000118	0.000127	0.000133	0.000139	0.000147	0.000154	0.000162	0.000167	0.000174	0.000179
0.000186	0.000192	0.000198	0.000206	0.000211	0.000221	0.000229	0.000240	0.000247	0.000255
0.000264	0.000273	0.000281	0.000287	0.000295	0.000303	0.000314	0.000329	0.000343	0.000355
0.000373	0.000391	0.000414	0.000448	0.000485	0.000546	0.000592	0.000669	0.000770	0.000888 ].',[1], [90]);

gS(5,:)=reshape([
0.000412	0.000400	0.000392	0.000381	0.000374	0.000375	0.000378	0.000371	0.000364	0.000363
0.000362	0.000354	0.000338	0.000328	0.000323	0.000309	0.000290	0.000285	0.000281	0.000273
0.000264	0.000251	0.000246	0.000235	0.000225	0.000204	0.000195	0.000186	0.000179	0.000174
0.000168	0.000163	0.000157	0.000153	0.000150	0.000151	0.000147	0.000144	0.000140	0.000134
0.000129	0.000118	0.000101	0.000085	0.000085	0.000086	0.000089	0.000094	0.000100	0.000107
0.000112	0.000119	0.000126	0.000133	0.000140	0.000147	0.000154	0.000160	0.000168	0.000175
0.000184	0.000192	0.000202	0.000211	0.000220	0.000234	0.000246	0.000260	0.000271	0.000284
0.000295	0.000309	0.000322	0.000330	0.000341	0.000350	0.000365	0.000375	0.000390	0.000407
0.000427	0.000444	0.000465	0.000488	0.000508	0.000539	0.000567	0.000601	0.000632	0.000675 ].',[1], [90]);

%gSAT fraction of signal that comes from platform
gSAT(1,:)=reshape([
0.001715	0.001506	0.001268	0.001029	0.000907	0.000840	0.000778	0.000714	0.000630	0.000575
0.000524	0.000527	0.000488	0.000458	0.000456	0.000455	0.000421	0.000396	0.000366	0.000332
0.000308	0.000286	0.000266	0.000244	0.000228	0.000212	0.000198	0.000188	0.000175	0.000164
0.000154	0.000145	0.000135	0.000125	0.000118	0.000110	0.000104	0.000099	0.000095	0.000092
0.000088	0.000085	0.000081	0.000079	0.000076	0.000124	0.000121	0.000118	0.000114	0.000111
0.000108	0.000106	0.000102	0.000100	0.000097	0.000094	0.000095	0.000097	0.000099	0.000101
0.000103	0.000106	0.000108	0.000110	0.000113	0.000116	0.000120	0.000122	0.000128	0.000136
0.000147	0.000158	0.000166	0.000172	0.000179	0.000189	0.000199	0.000210	0.000224	0.000240
0.000262	0.000282	0.000302	0.000330	0.000365	0.000350	0.000407	0.000550	0.000650	0.000778 ].',[1], [90]);

gSAT(2,:)=reshape([
0.000506	0.000497	0.000490	0.000482	0.000476	0.000464	0.000454	0.000447	0.000445	0.000441
0.000436	0.000436	0.000436	0.000435	0.000434	0.000435	0.000437	0.000438	0.000427	0.000412
0.000396	0.000382	0.000366	0.000356	0.000347	0.000335	0.000326	0.000315	0.000305	0.000294
0.000284	0.000273	0.000264	0.000255	0.000242	0.000230	0.000218	0.000214	0.000209	0.000205
0.000200	0.000196	0.000191	0.000187	0.000183	0.000178	0.000173	0.000170	0.000165	0.000161
0.000156	0.000152	0.000148	0.000143	0.000139	0.000133	0.000133	0.000137	0.000140	0.000143
0.000146	0.000149	0.000152	0.000155	0.000158	0.000161	0.000165	0.000168	0.000174	0.000184
0.000196	0.000205	0.000212	0.000214	0.000218	0.000219	0.000222	0.000225	0.000228	0.000229
0.000233	0.000236	0.000239	0.000243	0.000245	0.000249	0.000253	0.000255	0.000258	0.000264 ].',[1], [90]);

gSAT(3,:)=reshape([
0.000358	0.000342	0.000328	0.000314	0.000297	0.000248	0.000236	0.000226	0.000223	0.000220
0.000218	0.000218	0.000218	0.000219	0.000218	0.000219	0.000227	0.000248	0.000256	0.000251
0.000247	0.000238	0.000229	0.000228	0.000225	0.000225	0.000220	0.000218	0.000217	0.000218
0.000217	0.000218	0.000221	0.000218	0.000212	0.000186	0.000174	0.000174	0.000174	0.000173
0.000174	0.000174	0.000174	0.000173	0.000172	0.000123	0.000116	0.000108	0.000101	0.000092
0.000085	0.000075	0.000067	0.000056	0.000050	0.000048	0.000048	0.000049	0.000050	0.000051
0.000052	0.000053	0.000054	0.000056	0.000057	0.000058	0.000059	0.000061	0.000063	0.000066
0.000071	0.000074	0.000078	0.000079	0.000082	0.000083	0.000085	0.000088	0.000091	0.000092
0.000095	0.000098	0.000100	0.000105	0.000108	0.000110	0.000115	0.000121	0.000127	0.000134 ].',[1], [90]);

gSAT(4,:)=reshape([
0.000358	0.000342	0.000328	0.000314	0.000297	0.000248	0.000236	0.000226	0.000223	0.000220
0.000218	0.000218	0.000218	0.000219	0.000218	0.000219	0.000227	0.000248	0.000256	0.000251
0.000247	0.000238	0.000229	0.000228	0.000225	0.000225	0.000220	0.000218	0.000217	0.000218
0.000217	0.000218	0.000221	0.000218	0.000212	0.000186	0.000174	0.000174	0.000174	0.000173
0.000174	0.000174	0.000174	0.000173	0.000172	0.000123	0.000116	0.000108	0.000101	0.000092
0.000085	0.000075	0.000067	0.000056	0.000050	0.000048	0.000048	0.000049	0.000050	0.000051
0.000052	0.000053	0.000054	0.000056	0.000057	0.000058	0.000059	0.000061	0.000063	0.000066
0.000071	0.000074	0.000078	0.000079	0.000082	0.000083	0.000085	0.000088	0.000091	0.000092
0.000095	0.000098	0.000100	0.000105	0.000108	0.000110	0.000115	0.000121	0.000127	0.000134 ].',[1], [90]);

gSAT(5,:)=reshape([
0.000363	0.000350	0.000338	0.000324	0.000312	0.000296	0.000281	0.000273	0.000266	0.000254
0.000240	0.000236	0.000232	0.000227	0.000219	0.000217	0.000221	0.000224	0.000216	0.000207
0.000198	0.000187	0.000180	0.000173	0.000167	0.000160	0.000156	0.000151	0.000146	0.000142
0.000137	0.000133	0.000128	0.000123	0.000115	0.000105	0.000098	0.000095	0.000093	0.000091
0.000090	0.000088	0.000087	0.000085	0.000084	0.000083	0.000082	0.000080	0.000079	0.000077
0.000076	0.000073	0.000072	0.000069	0.000067	0.000067	0.000068	0.000070	0.000073	0.000076
0.000079	0.000081	0.000084	0.000087	0.000090	0.000094	0.000097	0.000101	0.000104	0.000111
0.000117	0.000124	0.000130	0.000134	0.000137	0.000140	0.000145	0.000148	0.000152	0.000157
0.000162	0.000166	0.000171	0.000176	0.000180	0.000185	0.000190	0.000196	0.000202	0.000208 ].',[1], [90]);

                            
% read out frequencies and weights for SRF
% from O. Bobryshev's .mat-file

%
% NOAA19 ("102")
maximum_num_freq_a=max([length(frequency_h1a)  length(frequency_h2a)  length(frequency_h3a)  length(frequency_h4a)  length(frequency_h5a) ]);
maximum_num_freq_b=max([length(frequency_h1b)  length(frequency_h2b)  length(frequency_h3b)  length(frequency_h4b)  length(frequency_h5b) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

srf_frequency_a(1:length(frequency_h1a),1)=frequency_h1a;
srf_frequency_a(1:length(frequency_h2a),2)=frequency_h2a;
srf_frequency_a(1:length(frequency_h3a),3)=frequency_h3a;
srf_frequency_a(1:length(frequency_h4a),4)=frequency_h4a;
srf_frequency_a(1:length(frequency_h5a),5)=frequency_h5a;

srf_frequency_b(1:length(frequency_h1b),1)=frequency_h1b;
srf_frequency_b(1:length(frequency_h2b),2)=frequency_h2b;
srf_frequency_b(1:length(frequency_h3b),3)=frequency_h3b;
srf_frequency_b(1:length(frequency_h4b),4)=frequency_h4b;
srf_frequency_b(1:length(frequency_h5b),5)=frequency_h5b;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

srf_weight_a(1:length(frequency_h1a),1)=gain_h1a-max(gain_h1a);
srf_weight_a(1:length(frequency_h2a),2)=gain_h2a-max(gain_h2a);
srf_weight_a(1:length(frequency_h3a),3)=gain_h3a-max(gain_h3a);
srf_weight_a(1:length(frequency_h4a),4)=gain_h4a-max(gain_h4a);
srf_weight_a(1:length(frequency_h5a),5)=gain_h5a-max(gain_h5a);

srf_weight_b(1:length(frequency_h1b),1)=gain_h1b-max(gain_h1b);
srf_weight_b(1:length(frequency_h2b),2)=gain_h2b-max(gain_h2b);
srf_weight_b(1:length(frequency_h3b),3)=gain_h3b-max(gain_h3b);
srf_weight_b(1:length(frequency_h4b),4)=gain_h4b-max(gain_h4b);
srf_weight_b(1:length(frequency_h5b),5)=gain_h5b-max(gain_h5b);

% uncertainty in counts due to RFI
u_RFI_counts=zeros(3,5);
%earthviews
% u_RFI_counts(1,1)=120;
% u_RFI_counts(1,2)=105;
% u_RFI_counts(1,3)=95;
% u_RFI_counts(1,4)=90;
% u_RFI_counts(1,5)=50;
% %DSV
% u_RFI_counts(2,1)=118;
% u_RFI_counts(2,2)=103;
% u_RFI_counts(2,3)=93;
% u_RFI_counts(2,4)=87;
% u_RFI_counts(2,5)=49;
% %IWCT
% u_RFI_counts(3,1)=96;
% u_RFI_counts(3,2)=84;
% u_RFI_counts(3,3)=76;
% u_RFI_counts(3,4)=71;
% u_RFI_counts(3,5)=40;  
                            
           save('coeffs_noaa19mhs_antcorr_alpha.mat', 'gE','gS','gSAT', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

%% METOP A MHS

%%%%%% Count limits %%%%%
count_thriwct_ch1=[20000 64881];
count_thriwct_ch2=[20000 64881];
count_thriwct_ch3=[20000 64881];
count_thriwct_ch4=[20000 64881];
count_thriwct_ch5=[20000 64881];

count_thrdsv_ch1=[1500 28000];
count_thrdsv_ch2=[1500 28000];
count_thrdsv_ch3=[1500 28000];
count_thrdsv_ch4=[1500 28000];
count_thrdsv_ch5=[1500 28000];

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[1000 1000 1000 1000 1000]; % allowed jump in meancounts between two subsequent scanlines
% threshold_earth is adapted to N18
threshold_earth=[12000 12000 8000 8000 10000];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities
                        alpha=[0.0 0.0 0.0 0.0 0.0]; %version 2
                        %alpha=[0.0002 0.0015 -0.0022 -0.0022 0.0021]; %version1; same numbers as for N18


%%%%% ANTENNA CORRECTION %%%%%%%%%

%type in manually the values from fdf.dat file
                           %for individual instrument
                           
                           
                           
                           % for each channel there are 90 values
                                % indicating the fraction of the earth signal/ space/ platform of the total signal 
                                % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                                % instrument per satellite

%gE fraction of signal that comes from earth
gE(1,:)=reshape([
0.993614	0.994210	0.994722	0.995279	0.995664	0.995939	0.996317	0.996760	0.997098	0.997428
0.997771	0.998001	0.998227	0.998360	0.998477	0.998562	0.998628	0.998656	0.998705	0.998784
0.998862	0.998912	0.998966	0.999014	0.999065	0.999112	0.999158	0.999189	0.999219	0.999256
0.999284	0.999321	0.999350	0.999382	0.999404	0.999425	0.999454	0.999476	0.999500	0.999517
0.999538	0.999548	0.999569	0.999587	0.999574	0.999569	0.999568	0.999561	0.999551	0.999542
0.999523	0.999510	0.999498	0.999480	0.999460	0.999434	0.999345	0.998863	0.998434	0.998400
0.998420	0.998474	0.998522	0.998575	0.998615	0.998611	0.998591	0.998547	0.998527	0.998504
0.998466	0.998387	0.998336	0.998274	0.998185	0.998108	0.997915	0.997693	0.997301	0.996981
0.996571	0.996223	0.995906	0.995493	0.995065	0.994531	0.994113	0.993539	0.992961	0.992196].',[1], [90]);

gE(2,:)=reshape([
0.999133	0.999108	0.999135	0.999161	0.999178	0.999198	0.999218	0.999227	0.999244	0.999257
0.999274	0.999285	0.999299	0.999311	0.999320	0.999334	0.999334	0.999345	0.999355	0.999371
0.999394	0.999415	0.999438	0.999461	0.999490	0.999536	0.999570	0.999579	0.999588	0.999607
0.999620	0.999638	0.999651	0.999668	0.999680	0.999695	0.999708	0.999720	0.999736	0.999747
0.999762	0.999778	0.999791	0.999802	0.999810	0.999813	0.999810	0.999803	0.999793	0.999786
0.999775	0.999764	0.999751	0.999739	0.999728	0.999714	0.999703	0.999688	0.999675	0.999661
0.999650	0.999639	0.999623	0.999612	0.999596	0.999581	0.999564	0.999549	0.999531	0.999512
0.999496	0.999473	0.999460	0.999449	0.999435	0.999420	0.999405	0.999388	0.999373	0.999361
0.999341	0.999323	0.999308	0.999278	0.999256	0.999211	0.999142	0.999072	0.999034	0.998991 ].',[1], [90]);


gE(3,:)=reshape([
0.999099	0.999140	0.999176	0.999214	0.999246	0.999282	0.999312	0.999347	0.999367	0.999386
0.999406	0.999424	0.999448	0.999469	0.999484	0.999495	0.999501	0.999504	0.999516	0.999536
0.999552	0.999570	0.999582	0.999593	0.999609	0.999615	0.999629	0.999635	0.999646	0.999655
0.999667	0.999674	0.999687	0.999694	0.999700	0.999713	0.999719	0.999729	0.999737	0.999745
0.999753	0.999776	0.999795	0.999828	0.999841	0.999842	0.999839	0.999831	0.999825	0.999815
0.999807	0.999795	0.999786	0.999777	0.999766	0.999755	0.999743	0.999732	0.999719	0.999708
0.999697	0.999684	0.999672	0.999657	0.999644	0.999628	0.999611	0.999591	0.999575	0.999555
0.999535	0.999513	0.999498	0.999488	0.999477	0.999466	0.999453	0.999433	0.999407	0.999375
0.999349	0.999328	0.999305	0.999241	0.999180	0.999123	0.999074	0.999015	0.998971	0.998914 ].',[1], [90]);

gE(4,:)=reshape([
0.999099	0.999140	0.999176	0.999214	0.999246	0.999282	0.999312	0.999347	0.999367	0.999386
0.999406	0.999424	0.999448	0.999469	0.999484	0.999495	0.999501	0.999504	0.999516	0.999536
0.999552	0.999570	0.999582	0.999593	0.999609	0.999615	0.999629	0.999635	0.999646	0.999655
0.999667	0.999674	0.999687	0.999694	0.999700	0.999713	0.999719	0.999729	0.999737	0.999745
0.999753	0.999776	0.999795	0.999828	0.999841	0.999842	0.999839	0.999831	0.999825	0.999815
0.999807	0.999795	0.999786	0.999777	0.999766	0.999755	0.999743	0.999732	0.999719	0.999708
0.999697	0.999684	0.999672	0.999657	0.999644	0.999628	0.999611	0.999591	0.999575	0.999555
0.999535	0.999513	0.999498	0.999488	0.999477	0.999466	0.999453	0.999433	0.999407	0.999375
0.999349	0.999328	0.999305	0.999241	0.999180	0.999123	0.999074	0.999015	0.998971	0.998914 ].',[1], [90]);

gE(5,:)=reshape([
0.999344	0.999364	0.999384	0.999403	0.999420	0.999440	0.999451	0.999466	0.999477	0.999490
0.999506	0.999519	0.999533	0.999549	0.999556	0.999565	0.999579	0.999587	0.999598	0.999610
0.999622	0.999632	0.999645	0.999654	0.999666	0.999679	0.999686	0.999694	0.999697	0.999707
0.999715	0.999725	0.999731	0.999738	0.999746	0.999752	0.999762	0.999770	0.999779	0.999785
0.999793	0.999810	0.999825	0.999842	0.999844	0.999846	0.999845	0.999839	0.999835	0.999827
0.999819	0.999808	0.999800	0.999791	0.999783	0.999773	0.999763	0.999755	0.999743	0.999735
0.999722	0.999711	0.999697	0.999686	0.999671	0.999659	0.999645	0.999629	0.999617	0.999598
0.999582	0.999561	0.999549	0.999543	0.999536	0.999529	0.999523	0.999517	0.999509	0.999505
0.999499	0.999489	0.999474	0.999461	0.999452	0.999425	0.999406	0.999388	0.999378	0.999360 ].',[1], [90]);

%gS fraction of signal that comes from space
gS(1,:)=reshape([
0.005279	0.004822	0.004408	0.003951	0.003657	0.003462	0.003160	0.002786	0.002485	0.002181
0.001856	0.001642	0.001425	0.001287	0.001166	0.001081	0.001007	0.000970	0.000926	0.000867
0.000818	0.000789	0.000763	0.000747	0.000736	0.000720	0.000708	0.000699	0.000685	0.000655
0.000628	0.000596	0.000572	0.000548	0.000526	0.000504	0.000475	0.000454	0.000432	0.000416
0.000393	0.000380	0.000357	0.000335	0.000342	0.000344	0.000343	0.000350	0.000360	0.000369
0.000388	0.000401	0.000413	0.000430	0.000447	0.000470	0.000556	0.001036	0.001463	0.001497
0.001476	0.001421	0.001374	0.001319	0.001278	0.001283	0.001303	0.001344	0.001366	0.001390
0.001425	0.001494	0.001540	0.001597	0.001680	0.001754	0.001941	0.002158	0.002551	0.002867
0.003271	0.003616	0.003932	0.004344	0.004768	0.005300	0.005714	0.006281	0.006841	0.007588 ].',[1], [90]);

gS(2,:)=reshape([
0.000580	0.000587	0.000574	0.000551	0.000543	0.000529	0.000521	0.000523	0.000522	0.000520
0.000513	0.000513	0.000503	0.000493	0.000487	0.000483	0.000481	0.000470	0.000462	0.000450
0.000441	0.000442	0.000433	0.000424	0.000412	0.000379	0.000361	0.000361	0.000360	0.000348
0.000337	0.000324	0.000313	0.000299	0.000288	0.000274	0.000263	0.000254	0.000240	0.000228
0.000213	0.000198	0.000183	0.000172	0.000165	0.000161	0.000164	0.000171	0.000180	0.000188
0.000199	0.000209	0.000222	0.000233	0.000244	0.000257	0.000268	0.000283	0.000295	0.000310
0.000321	0.000332	0.000347	0.000360	0.000375	0.000390	0.000407	0.000422	0.000440	0.000457
0.000473	0.000494	0.000506	0.000516	0.000529	0.000543	0.000559	0.000574	0.000589	0.000600
0.000618	0.000635	0.000649	0.000677	0.000697	0.000741	0.000809	0.000877	0.000913	0.000955 ].',[1], [90]);

gS(3,:)=reshape([
0.000612	0.000588	0.000584	0.000564	0.000545	0.000517	0.000497	0.000479	0.000469	0.000457
0.000442	0.000430	0.000416	0.000398	0.000385	0.000374	0.000363	0.000354	0.000343	0.000329
0.000319	0.000307	0.000302	0.000302	0.000304	0.000307	0.000309	0.000312	0.000311	0.000305
0.000295	0.000289	0.000281	0.000275	0.000270	0.000259	0.000253	0.000249	0.000244	0.000235
0.000227	0.000203	0.000185	0.000153	0.000138	0.000138	0.000141	0.000148	0.000154	0.000164
0.000172	0.000183	0.000192	0.000201	0.000211	0.000221	0.000234	0.000244	0.000257	0.000267
0.000278	0.000293	0.000304	0.000319	0.000332	0.000349	0.000365	0.000384	0.000400	0.000419
0.000439	0.000460	0.000475	0.000481	0.000492	0.000503	0.000515	0.000534	0.000560	0.000589
0.000614	0.000634	0.000657	0.000718	0.000776	0.000833	0.000880	0.000937	0.000978	0.001033 ].',[1], [90]);

gS(4,:)=reshape([
0.000612	0.000588	0.000584	0.000564	0.000545	0.000517	0.000497	0.000479	0.000469	0.000457
0.000442	0.000430	0.000416	0.000398	0.000385	0.000374	0.000363	0.000354	0.000343	0.000329
0.000319	0.000307	0.000302	0.000302	0.000304	0.000307	0.000309	0.000312	0.000311	0.000305
0.000295	0.000289	0.000281	0.000275	0.000270	0.000259	0.000253	0.000249	0.000244	0.000235
0.000227	0.000203	0.000185	0.000153	0.000138	0.000138	0.000141	0.000148	0.000154	0.000164
0.000172	0.000183	0.000192	0.000201	0.000211	0.000221	0.000234	0.000244	0.000257	0.000267
0.000278	0.000293	0.000304	0.000319	0.000332	0.000349	0.000365	0.000384	0.000400	0.000419
0.000439	0.000460	0.000475	0.000481	0.000492	0.000503	0.000515	0.000534	0.000560	0.000589
0.000614	0.000634	0.000657	0.000718	0.000776	0.000833	0.000880	0.000937	0.000978	0.001033 ].',[1], [90]);

gS(5,:)=reshape([
0.000430	0.000417	0.000421	0.000411	0.000402	0.000389	0.000385	0.000384	0.000381	0.000374
0.000363	0.000357	0.000353	0.000342	0.000334	0.000325	0.000309	0.000297	0.000287	0.000279
0.000273	0.000269	0.000265	0.000264	0.000263	0.000261	0.000261	0.000263	0.000265	0.000258
0.000253	0.000246	0.000242	0.000237	0.000229	0.000222	0.000214	0.000210	0.000204	0.000198
0.000190	0.000173	0.000157	0.000139	0.000137	0.000135	0.000136	0.000142	0.000147	0.000154
0.000161	0.000170	0.000178	0.000188	0.000196	0.000206	0.000215	0.000223	0.000234	0.000244
0.000256	0.000267	0.000281	0.000292	0.000307	0.000320	0.000333	0.000350	0.000363	0.000381
0.000397	0.000416	0.000427	0.000433	0.000439	0.000445	0.000452	0.000457	0.000465	0.000467
0.000473	0.000481	0.000493	0.000505	0.000513	0.000539	0.000556	0.000572	0.000583	0.000599 ].',[1], [90]);

%gSAT fraction of signal that comes from platform
gSAT(1,:)=reshape([
0.001107	0.000968	0.000870	0.000769	0.000680	0.000598	0.000523	0.000454	0.000418	0.000391
0.000374	0.000358	0.000349	0.000352	0.000357	0.000357	0.000365	0.000373	0.000369	0.000349
0.000320	0.000300	0.000272	0.000239	0.000198	0.000167	0.000134	0.000113	0.000096	0.000089
0.000089	0.000082	0.000078	0.000071	0.000071	0.000072	0.000071	0.000071	0.000067	0.000067
0.000070	0.000072	0.000075	0.000078	0.000083	0.000088	0.000089	0.000089	0.000088	0.000088
0.000089	0.000089	0.000089	0.000090	0.000092	0.000095	0.000098	0.000100	0.000102	0.000103
0.000104	0.000104	0.000104	0.000105	0.000107	0.000106	0.000106	0.000107	0.000107	0.000106
0.000109	0.000118	0.000124	0.000128	0.000134	0.000137	0.000145	0.000148	0.000148	0.000151
0.000157	0.000160	0.000162	0.000163	0.000166	0.000170	0.000174	0.000181	0.000200	0.000216 ].',[1], [90]);

gSAT(2,:)=reshape([
0.000286	0.000304	0.000291	0.000287	0.000279	0.000274	0.000260	0.000249	0.000234	0.000223
0.000213	0.000201	0.000198	0.000196	0.000193	0.000183	0.000184	0.000184	0.000184	0.000178
0.000164	0.000143	0.000129	0.000116	0.000098	0.000084	0.000069	0.000059	0.000051	0.000045
0.000043	0.000039	0.000036	0.000033	0.000032	0.000030	0.000029	0.000026	0.000025	0.000024
0.000025	0.000025	0.000026	0.000026	0.000026	0.000026	0.000026	0.000026	0.000026	0.000027
0.000027	0.000027	0.000028	0.000028	0.000028	0.000029	0.000029	0.000030	0.000030	0.000030
0.000030	0.000030	0.000029	0.000029	0.000029	0.000030	0.000030	0.000030	0.000030	0.000030
0.000031	0.000033	0.000034	0.000035	0.000036	0.000037	0.000037	0.000037	0.000038	0.000039
0.000041	0.000042	0.000044	0.000045	0.000047	0.000048	0.000049	0.000051	0.000053	0.000055 ].',[1], [90]);

gSAT(3,:)=reshape([
0.000290	0.000273	0.000240	0.000221	0.000210	0.000202	0.000191	0.000175	0.000164	0.000158
0.000154	0.000146	0.000136	0.000133	0.000132	0.000131	0.000137	0.000142	0.000141	0.000137
0.000131	0.000125	0.000116	0.000106	0.000089	0.000078	0.000063	0.000053	0.000044	0.000043
0.000041	0.000038	0.000034	0.000032	0.000031	0.000030	0.000028	0.000024	0.000021	0.000020
0.000020	0.000021	0.000021	0.000021	0.000021	0.000021	0.000021	0.000021	0.000022	0.000022
0.000022	0.000023	0.000023	0.000023	0.000023	0.000024	0.000024	0.000024	0.000024	0.000025
0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000026
0.000027	0.000028	0.000030	0.000030	0.000031	0.000032	0.000032	0.000033	0.000033	0.000035
0.000037	0.000038	0.000040	0.000041	0.000043	0.000045	0.000047	0.000049	0.000051	0.000053 ].',[1], [90]);

gSAT(4,:)=reshape([
0.000290	0.000273	0.000240	0.000221	0.000210	0.000202	0.000191	0.000175	0.000164	0.000158
0.000154	0.000146	0.000136	0.000133	0.000132	0.000131	0.000137	0.000142	0.000141	0.000137
0.000131	0.000125	0.000116	0.000106	0.000089	0.000078	0.000063	0.000053	0.000044	0.000043
0.000041	0.000038	0.000034	0.000032	0.000031	0.000030	0.000028	0.000024	0.000021	0.000020
0.000020	0.000021	0.000021	0.000021	0.000021	0.000021	0.000021	0.000021	0.000022	0.000022
0.000022	0.000023	0.000023	0.000023	0.000023	0.000024	0.000024	0.000024	0.000024	0.000025
0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000025	0.000026
0.000027	0.000028	0.000030	0.000030	0.000031	0.000032	0.000032	0.000033	0.000033	0.000035
0.000037	0.000038	0.000040	0.000041	0.000043	0.000045	0.000047	0.000049	0.000051	0.000053 ].',[1], [90]);

gSAT(5,:)=reshape([
0.000228	0.000220	0.000196	0.000186	0.000178	0.000173	0.000166	0.000151	0.000143	0.000138
0.000132	0.000125	0.000115	0.000110	0.000111	0.000112	0.000113	0.000117	0.000116	0.000112
0.000107	0.000100	0.000092	0.000083	0.000071	0.000062	0.000053	0.000044	0.000039	0.000036
0.000034	0.000031	0.000028	0.000027	0.000026	0.000025	0.000024	0.000021	0.000019	0.000018
0.000019	0.000019	0.000020	0.000020	0.000020	0.000020	0.000020	0.000020	0.000021	0.000021
0.000021	0.000022	0.000022	0.000022	0.000022	0.000023	0.000023	0.000023	0.000023	0.000023
0.000023	0.000023	0.000023	0.000023	0.000023	0.000023	0.000023	0.000023	0.000023	0.000023
0.000023	0.000024	0.000025	0.000026	0.000026	0.000026	0.000026	0.000027	0.000027	0.000028
0.000029	0.000031	0.000032	0.000033	0.000035	0.000036	0.000038	0.000039	0.000041	0.000042 ].',[1], [90]);


% old version same as N18 and all AMSUB acc to clparams
%  %gE fraction of signal that comes from earth
%                                 gE(1,:)=reshape([
%                                 0.997074 0.997264 0.997422 0.997581 0.997737 0.998033 0.998167 0.998285 0.998391 0.998501 
%                                 0.998597 0.998700 0.998823 0.998946 0.999081 0.999322 0.999399 0.999474 0.999532 0.999595
%                                 0.999658 0.999715 0.999764 0.999835 0.999873 0.999945 0.999962 0.999975 0.999983 0.999988
%                                 0.999991 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
%                                 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
%                                 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000
%                                 1.000000 1.000000 0.999997 0.999995 0.999992 0.999979 0.999969 0.999956 0.999940 0.999922
%                                 0.999887 0.999848 0.999802 0.999754 0.999706 0.999604 0.999533 0.999449 0.999376 0.999296
%                                 0.999209 0.999115 0.999022 0.998927 0.998797 0.998488 0.998299 0.998000 0.997614 0.997189 ].',[1], [90]);
% 
%                                 gE(2,:)=reshape([
%                                 0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
%                                 0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
%                                 0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
%                                 0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
%                                 0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
%                                 0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);
% 
% 
%                                 gE(3,:)=reshape([
%                                 0.998616	0.998643	0.998665	0.998686	0.998706	0.998742	0.998758	0.998773	0.998786	0.998798
%                                 0.998807	0.998864	0.998920	0.998980	0.999039	0.999151	0.999203	0.999254	0.999304	0.999354
%                                 0.999402	0.999451	0.999611	0.999692	0.999716	0.999853	0.999852	0.999879	0.999938	0.999938
%                                 0.999979	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	0.999996	0.999992	0.999985
%                                 0.999980	0.999972	0.999965	0.999956	0.999941	0.999893	0.999860	0.999829	0.999778	0.999734 ].',[1], [90]);
% 
%                                 gE(4,:)=reshape([
%                                 0.997074	0.997264	0.997422	0.997581	0.997737	0.998033	0.998167	0.998285	0.998391	0.998501
%                                 0.998597	0.998700	0.998823	0.998946	0.999081	0.999322	0.999399	0.999474	0.999532	0.999595
%                                 0.999658	0.999715	0.999764	0.999835	0.999873	0.999945	0.999962	0.999975	0.999983	0.999988
%                                 0.999991	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	0.999997	0.999995	0.999992	0.999979	0.999969	0.999956	0.999940	0.999922
%                                 0.999887	0.999848	0.999802	0.999754	0.999706	0.999604	0.999533	0.999449	0.999376	0.999296
%                                 0.999209	0.999115	0.999022	0.998927	0.998797	0.998488	0.998299	0.998000	0.997614	0.997189 ].',[1], [90]);
% 
%                                 gE(5,:)=reshape([
%                                 0.999128	0.999153	0.999178	0.999199	0.999219	0.999256	0.999268	0.999282	0.999296	0.999309
%                                 0.999322	0.999332	0.999340	0.999350	0.999360	0.999380	0.999387	0.999393	0.999398	0.999401
%                                 0.999405	0.999408	0.999546	0.999630	0.999677	0.999748	0.999783	0.999814	0.999852	0.999889
%                                 0.999959	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000	1.000000
%                                 1.000000	1.000000	1.000000	0.999999	1.000000	0.999999	0.999998	0.999997	0.999995	0.999993
%                                 0.999989	0.999986	0.999984	0.999982	0.999981	0.999975	0.999970	0.999963	0.999957	0.999949
%                                 0.999937	0.999925	0.999907	0.999883	0.999848	0.999744	0.999683	0.999600	0.999488	0.999382 ].',[1], [90]);
% 
%                                 %gS fraction of signal that comes from space
%                                 gS(1,:)=reshape([
%                                 0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
%                                 0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
%                                 0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
%                                 0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
%                                 0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
%                                 0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);
% 
%                                 gS(2,:)=reshape([
%                                 0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
%                                 0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
%                                 0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
%                                 0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
%                                 0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);
% 
%                                 gS(3,:)=reshape([
%                                 0.000226	0.000296	0.000287	0.000278	0.000317	0.000400	0.000444	0.000489	0.000534	0.000580
%                                 0.000627	0.000624	0.000620	0.000614	0.000606	0.000657	0.000606	0.000556	0.000506	0.000457
%                                 0.000409	0.000361	0.000201	0.000120	0.000121	0.000020	0.000020	0.000020	0.000021	0.000021
%                                 0.000021	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000004	0.000008	0.000015
%                                 0.000020	0.000028	0.000035	0.000044	0.000059	0.000107	0.000140	0.000171	0.000222	0.000266 ].',[1], [90]);
% 
%                                 gS(4,:)=reshape([
%                                 0.001585	0.001523	0.001439	0.001340	0.001260	0.001118	0.001060	0.001015	0.000977	0.000933
%                                 0.000902	0.000849	0.000780	0.000697	0.000608	0.000426	0.000368	0.000317	0.000278	0.000235
%                                 0.000197	0.000158	0.000130	0.000078	0.000055	0.000017	0.000014	0.000012	0.000010	0.000009
%                                 0.000008	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000003	0.000005	0.000008	0.000021	0.000031	0.000044	0.000060	0.000078
%                                 0.000113	0.000152	0.000198	0.000246	0.000294	0.000396	0.000467	0.000551	0.000624	0.000704
%                                 0.000791	0.000885	0.000978	0.001073	0.001203	0.001512	0.001701	0.002000	0.002386	0.002811 ].',[1], [90]);
% 
%                                 gS(5,:)=reshape([
%                                 0.000283	0.000366	0.000355	0.000346	0.000337	0.000322	0.000317	0.000314	0.000310	0.000309
%                                 0.000307	0.000305	0.000302	0.000298	0.000294	0.000404	0.000400	0.000397	0.000394	0.000392
%                                 0.000392	0.000391	0.000255	0.000172	0.000127	0.000085	0.000050	0.000051	0.000051	0.000037
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000001	0.000000	0.000001	0.000002	0.000003	0.000005	0.000007
%                                 0.000011	0.000014	0.000016	0.000018	0.000019	0.000025	0.000030	0.000037	0.000043	0.000051
%                                 0.000063	0.000075	0.000093	0.000117	0.000152	0.000256	0.000317	0.000400	0.000512	0.000618 ].',[1], [90]);
% 
%                                 %gSAT fraction of signal that comes from platform
%                                 gSAT(1,:)=reshape([
%                                 0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
%                                 0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
%                                 0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
%                                 0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(2,:)=reshape([
%                                 0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
%                                 0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
%                                 0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
%                                 0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(3,:)=reshape([
%                                 0.001158	0.001061	0.001048	0.001036	0.000977	0.000858	0.000798	0.000738	0.000680	0.000622
%                                 0.000566	0.000512	0.000460	0.000406	0.000355	0.000192	0.000191	0.000190	0.000190	0.000189
%                                 0.000189	0.000188	0.000188	0.000188	0.000163	0.000127	0.000128	0.000101	0.000041	0.000041
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(4,:)=reshape([
%                                 0.001341	0.001213	0.001139	0.001079	0.001003	0.000849	0.000773	0.000700	0.000632	0.000566
%                                 0.000501	0.000451	0.000397	0.000357	0.000311	0.000252	0.000233	0.000209	0.000190	0.000170
%                                 0.000145	0.000127	0.000106	0.000087	0.000072	0.000038	0.000024	0.000013	0.000007	0.000003
%                                 0.000001	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);
% 
%                                 gSAT(5,:)=reshape([
%                                 0.000589	0.000481	0.000467	0.000455	0.000444	0.000422	0.000415	0.000404	0.000394	0.000382
%                                 0.000371	0.000363	0.000358	0.000352	0.000346	0.000216	0.000213	0.000210	0.000208	0.000207
%                                 0.000203	0.000201	0.000199	0.000198	0.000196	0.000167	0.000167	0.000135	0.000097	0.000074
%                                 0.000041	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000
%                                 0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000	0.000000 ].',[1], [90]);


                            
% read out frequencies and weights for SRF
% from O. Bobryshev's .mat-file

%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;

srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI
u_RFI_counts=zeros(3,5);
%earthviews
% u_RFI_counts(1,1)=120;
% u_RFI_counts(1,2)=105;
% u_RFI_counts(1,3)=95;
% u_RFI_counts(1,4)=90;
% u_RFI_counts(1,5)=50;
% %DSV
% u_RFI_counts(2,1)=118;
% u_RFI_counts(2,2)=103;
% u_RFI_counts(2,3)=93;
% u_RFI_counts(2,4)=87;
% u_RFI_counts(2,5)=49;
% %IWCT
% u_RFI_counts(3,1)=96;
% u_RFI_counts(3,2)=84;
% u_RFI_counts(3,3)=76;
% u_RFI_counts(3,4)=71;
% u_RFI_counts(3,5)=40;  
                            
           save('coeffs_metopamhs_antcorr_alpha.mat', 'gE','gS','gSAT', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

           
%% METOP B MHS

%%%%%% Count limits %%%%%
count_thriwct_ch1=[20000 64881];
count_thriwct_ch2=[20000 64881];
count_thriwct_ch3=[20000 64881];
count_thriwct_ch4=[20000 64881];
count_thriwct_ch5=[20000 64881];


count_thrdsv_ch1=[1500 28000];
count_thrdsv_ch2=[1500 28000];
count_thrdsv_ch3=[1500 28000];
count_thrdsv_ch4=[1500 28000];
count_thrdsv_ch5=[1500 28000];

count_thriwct=[count_thriwct_ch1; count_thriwct_ch2; count_thriwct_ch3; count_thriwct_ch4; count_thriwct_ch5];
count_thrdsv=[count_thrdsv_ch1; count_thrdsv_ch2; count_thrdsv_ch3; count_thrdsv_ch4; count_thrdsv_ch5];

jump_thr=[1000 1000 1000 1000 1000]; % allowed jump in meancounts between two subsequent scanlines
% threshold_earth is adapted to N18
threshold_earth=[12000 12000 8000 8000 10000];% allowed jump in earthcounts between two subsequent scanlines
jump_thrICTtempmean=0.1; %0.1K as threshold for a jump between two scanlines.

%%%%% ALPHA %%%%%%
% quotient of reflectivities per channel
                        % from fdf.dat-file
                        % alpha= 1-quotient of reflectivities =1 - R(nadir)/R(90 deg)
                        alpha=[0.0 0.0 0.0 0.0 0.0];
                        % using the ones for N18
                        %alpha=[0.0002 0.0015 -0.0022 -0.0022 0.0021];

%%%%% ANTENNA CORRECTION %%%%%%%%%

%type in manually the values from fdf.dat file
                           %for individual instrument
                           
                           
                           
                           % for each channel there are 90 values
                                % indicating the fraction of the earth signal/ space/ platform of the total signal 
                                % values in /scratch/uni/u237/sw/AAPP7/AAPP/data/preproc/fdf.dat  for each
                                % instrument per satellite

%gE fraction of signal that comes from earth
gE(1,:)=reshape([
0.996590	0.996813	0.997023	0.997291	0.997508	0.997761	0.997975	0.998248	0.998471	0.998715
0.998912	0.999043	0.999089	0.999093	0.999067	0.999060	0.999107	0.999143	0.999176	0.999219
0.999262	0.999284	0.999307	0.999328	0.999341	0.999359	0.999378	0.999400	0.999419	0.999439
0.999454	0.999473	0.999496	0.999525	0.999533	0.999553	0.999557	0.999574	0.999570	0.999579
0.999568	0.999536	0.999528	0.999496	0.999489	0.999479	0.999455	0.999448	0.999454	0.999454
0.999480	0.999470	0.999499	0.999492	0.999503	0.999512	0.999523	0.999492	0.999464	0.999469
0.999472	0.999481	0.999485	0.999494	0.999499	0.999490	0.999483	0.999478	0.999478	0.999460
0.999448	0.999408	0.999350	0.999281	0.999174	0.999060	0.998771	0.998471	0.998007	0.997665
0.997258	0.996931	0.996617	0.996236	0.995882	0.995467	0.995126	0.994709	0.994357	0.993890].',[1], [90]);

gE(2,:)=reshape([
0.999779	0.999791	0.999802	0.999810	0.999817	0.999823	0.999829	0.999835	0.999840	0.999847
0.999853	0.999860	0.999870	0.999876	0.999882	0.999887	0.999892	0.999894	0.999898	0.999902
0.999906	0.999910	0.999913	0.999917	0.999920	0.999927	0.999930	0.999932	0.999934	0.999936
0.999939	0.999941	0.999942	0.999942	0.999944	0.999945	0.999947	0.999948	0.999951	0.999951
0.999953	0.999959	0.999965	0.999969	0.999969	0.999969	0.999969	0.999968	0.999967	0.999966
0.999965	0.999963	0.999963	0.999961	0.999960	0.999959	0.999957	0.999956	0.999954	0.999953
0.999950	0.999948	0.999945	0.999943	0.999940	0.999937	0.999934	0.999931	0.999927	0.999923
0.999920	0.999916	0.999911	0.999907	0.999902	0.999896	0.999884	0.999870	0.999854	0.999831
0.999808	0.999796	0.999783	0.999764	0.999752	0.999738	0.999727	0.999711	0.999695	0.999669 ].',[1], [90]);


gE(3,:)=reshape([
0.999648	0.999671	0.999691	0.999712	0.999727	0.999742	0.999751	0.999763	0.999775	0.999787
0.999802	0.999814	0.999832	0.999847	0.999857	0.999862	0.999865	0.999861	0.999864	0.999869
0.999876	0.999882	0.999885	0.999888	0.999890	0.999894	0.999895	0.999896	0.999897	0.999898
0.999899	0.999901	0.999902	0.999901	0.999900	0.999899	0.999898	0.999894	0.999891	0.999890
0.999892	0.999910	0.999932	0.999962	0.999964	0.999964	0.999963	0.999962	0.999961	0.999960
0.999960	0.999958	0.999956	0.999955	0.999954	0.999952	0.999948	0.999947	0.999944	0.999942
0.999939	0.999936	0.999933	0.999930	0.999926	0.999922	0.999917	0.999913	0.999908	0.999902
0.999896	0.999888	0.999882	0.999875	0.999867	0.999858	0.999846	0.999830	0.999805	0.999788
0.999764	0.999749	0.999708	0.999595	0.999522	0.999429	0.999325	0.999218	0.999115	0.998949 ].',[1], [90]);

gE(4,:)=reshape([
0.999648	0.999671	0.999691	0.999712	0.999727	0.999742	0.999751	0.999763	0.999775	0.999787
0.999802	0.999814	0.999832	0.999847	0.999857	0.999862	0.999865	0.999861	0.999864	0.999869
0.999876	0.999882	0.999885	0.999888	0.999890	0.999894	0.999895	0.999896	0.999897	0.999898
0.999899	0.999901	0.999902	0.999901	0.999900	0.999899	0.999898	0.999894	0.999891	0.999890
0.999892	0.999910	0.999932	0.999962	0.999964	0.999964	0.999963	0.999962	0.999961	0.999960
0.999960	0.999958	0.999956	0.999955	0.999954	0.999952	0.999948	0.999947	0.999944	0.999942
0.999939	0.999936	0.999933	0.999930	0.999926	0.999922	0.999917	0.999913	0.999908	0.999902
0.999896	0.999888	0.999882	0.999875	0.999867	0.999858	0.999846	0.999830	0.999805	0.999788
0.999764	0.999749	0.999708	0.999595	0.999522	0.999429	0.999325	0.999218	0.999115	0.998949 ].',[1], [90]);

gE(5,:)=reshape([
0.999678	0.999686	0.999690	0.999697	0.999703	0.999707	0.999713	0.999717	0.999723	0.999729
0.999739	0.999746	0.999756	0.999766	0.999775	0.999784	0.999789	0.999789	0.999791	0.999801
0.999810	0.999818	0.999826	0.999833	0.999843	0.999854	0.999864	0.999868	0.999873	0.999880
0.999882	0.999888	0.999890	0.999893	0.999894	0.999898	0.999901	0.999903	0.999906	0.999907
0.999913	0.999925	0.999941	0.999956	0.999957	0.999958	0.999959	0.999957	0.999957	0.999958
0.999957	0.999956	0.999956	0.999954	0.999953	0.999951	0.999951	0.999950	0.999947	0.999945
0.999943	0.999940	0.999940	0.999938	0.999936	0.999932	0.999927	0.999923	0.999920	0.999916
0.999911	0.999907	0.999902	0.999898	0.999894	0.999889	0.999886	0.999882	0.999874	0.999868
0.999859	0.999852	0.999846	0.999839	0.999829	0.999816	0.999809	0.999796	0.999785	0.999772 ].',[1], [90]);

%gS fraction of signal that comes from space
gS(1,:)=reshape([
0.002654	0.002507	0.002387	0.002228	0.002107	0.001953	0.001795	0.001570	0.001367	0.001142
0.000944	0.000809	0.000727	0.000684	0.000652	0.000643	0.000603	0.000573	0.000555	0.000533
0.000518	0.000522	0.000523	0.000525	0.000530	0.000524	0.000516	0.000510	0.000509	0.000496
0.000481	0.000463	0.000439	0.000413	0.000402	0.000382	0.000372	0.000347	0.000343	0.000329
0.000332	0.000353	0.000353	0.000373	0.000373	0.000377	0.000399	0.000409	0.000405	0.000403
0.000378	0.000387	0.000363	0.000369	0.000362	0.000354	0.000345	0.000376	0.000404	0.000400
0.000396	0.000388	0.000385	0.000377	0.000374	0.000383	0.000394	0.000403	0.000410	0.000440
0.000460	0.000498	0.000548	0.000612	0.000709	0.000821	0.001113	0.001414	0.001876	0.002219
0.002626	0.002951	0.003264	0.003646	0.004000	0.004413	0.004754	0.005168	0.005515	0.005973 ].',[1], [90]);

gS(2,:)=reshape([
0.000135	0.000129	0.000125	0.000124	0.000120	0.000116	0.000116	0.000116	0.000114	0.000111
0.000107	0.000104	0.000097	0.000092	0.000088	0.000084	0.000080	0.000077	0.000074	0.000071
0.000068	0.000067	0.000065	0.000064	0.000063	0.000058	0.000057	0.000057	0.000057	0.000056
0.000054	0.000053	0.000052	0.000052	0.000050	0.000049	0.000047	0.000048	0.000047	0.000046
0.000045	0.000039	0.000033	0.000028	0.000027	0.000027	0.000027	0.000028	0.000028	0.000029
0.000030	0.000032	0.000033	0.000034	0.000035	0.000036	0.000038	0.000039	0.000041	0.000043
0.000045	0.000047	0.000050	0.000052	0.000055	0.000058	0.000061	0.000064	0.000067	0.000070
0.000074	0.000077	0.000081	0.000085	0.000090	0.000097	0.000108	0.000121	0.000136	0.000158
0.000180	0.000191	0.000202	0.000219	0.000229	0.000241	0.000251	0.000265	0.000280	0.000304 ].',[1], [90]);

gS(3,:)=reshape([
0.000235	0.000222	0.000213	0.000202	0.000194	0.000184	0.000180	0.000175	0.000170	0.000162
0.000151	0.000142	0.000127	0.000115	0.000108	0.000104	0.000101	0.000100	0.000097	0.000092
0.000086	0.000082	0.000080	0.000081	0.000082	0.000083	0.000085	0.000086	0.000087	0.000085
0.000083	0.000084	0.000085	0.000087	0.000087	0.000088	0.000089	0.000097	0.000103	0.000107
0.000105	0.000088	0.000065	0.000034	0.000033	0.000033	0.000033	0.000034	0.000034	0.000036
0.000037	0.000038	0.000040	0.000042	0.000043	0.000045	0.000047	0.000049	0.000051	0.000053
0.000056	0.000059	0.000063	0.000066	0.000069	0.000073	0.000078	0.000083	0.000088	0.000094
0.000099	0.000105	0.000111	0.000118	0.000126	0.000134	0.000146	0.000162	0.000186	0.000203
0.000225	0.000240	0.000278	0.000390	0.000460	0.000551	0.000653	0.000758	0.000859	0.001022 ].',[1], [90]);

gS(4,:)=reshape([
0.000235	0.000222	0.000213	0.000202	0.000194	0.000184	0.000180	0.000175	0.000170	0.000162
0.000151	0.000142	0.000127	0.000115	0.000108	0.000104	0.000101	0.000100	0.000097	0.000092
0.000086	0.000082	0.000080	0.000081	0.000082	0.000083	0.000085	0.000086	0.000087	0.000085
0.000083	0.000084	0.000085	0.000087	0.000087	0.000088	0.000089	0.000097	0.000103	0.000107
0.000105	0.000088	0.000065	0.000034	0.000033	0.000033	0.000033	0.000034	0.000034	0.000036
0.000037	0.000038	0.000040	0.000042	0.000043	0.000045	0.000047	0.000049	0.000051	0.000053
0.000056	0.000059	0.000063	0.000066	0.000069	0.000073	0.000078	0.000083	0.000088	0.000094
0.000099	0.000105	0.000111	0.000118	0.000126	0.000134	0.000146	0.000162	0.000186	0.000203
0.000225	0.000240	0.000278	0.000390	0.000460	0.000551	0.000653	0.000758	0.000859	0.001022 ].',[1], [90]);

gS(5,:)=reshape([
0.000190	0.000189	0.000191	0.000193	0.000192	0.000190	0.000190	0.000192	0.000191	0.000188
0.000185	0.000183	0.000177	0.000171	0.000165	0.000159	0.000151	0.000148	0.000145	0.000139
0.000134	0.000131	0.000127	0.000126	0.000124	0.000117	0.000115	0.000114	0.000110	0.000105
0.000102	0.000099	0.000098	0.000096	0.000094	0.000091	0.000089	0.000090	0.000089	0.000088
0.000082	0.000068	0.000053	0.000039	0.000038	0.000038	0.000037	0.000037	0.000037	0.000038
0.000038	0.000039	0.000040	0.000041	0.000042	0.000043	0.000044	0.000046	0.000047	0.000049
0.000051	0.000053	0.000056	0.000058	0.000061	0.000064	0.000067	0.000071	0.000075	0.000079
0.000084	0.000088	0.000093	0.000096	0.000100	0.000104	0.000109	0.000114	0.000119	0.000125
0.000132	0.000137	0.000142	0.000147	0.000155	0.000167	0.000174	0.000185	0.000194	0.000205 ].',[1], [90]);

%gSAT fraction of signal that comes from platform
gSAT(1,:)=reshape([
0.000755	0.000680	0.000591	0.000481	0.000385	0.000287	0.000230	0.000182	0.000163	0.000143
0.000143	0.000150	0.000184	0.000223	0.000279	0.000296	0.000289	0.000284	0.000270	0.000248
0.000221	0.000194	0.000171	0.000147	0.000129	0.000116	0.000105	0.000089	0.000072	0.000065
0.000063	0.000063	0.000064	0.000063	0.000065	0.000066	0.000073	0.000078	0.000086	0.000091
0.000099	0.000111	0.000118	0.000131	0.000138	0.000143	0.000144	0.000142	0.000141	0.000143
0.000141	0.000142	0.000138	0.000138	0.000136	0.000134	0.000133	0.000132	0.000133	0.000132
0.000132	0.000132	0.000131	0.000130	0.000129	0.000127	0.000124	0.000119	0.000112	0.000100
0.000092	0.000094	0.000102	0.000109	0.000118	0.000121	0.000117	0.000115	0.000117	0.000117
0.000118	0.000119	0.000119	0.000119	0.000120	0.000121	0.000122	0.000124	0.000129	0.000137 ].',[1], [90]);

gSAT(2,:)=reshape([
0.000086	0.000080	0.000073	0.000067	0.000063	0.000060	0.000055	0.000049	0.000045	0.000043
0.000040	0.000037	0.000034	0.000032	0.000030	0.000028	0.000028	0.000028	0.000028	0.000027
0.000025	0.000023	0.000021	0.000019	0.000017	0.000014	0.000012	0.000010	0.000009	0.000008
0.000008	0.000007	0.000006	0.000006	0.000006	0.000006	0.000005	0.000004	0.000003	0.000003
0.000003	0.000003	0.000003	0.000003	0.000003	0.000003	0.000004	0.000004	0.000004	0.000004
0.000004	0.000004	0.000004	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005
0.000005	0.000005	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006
0.000007	0.000007	0.000008	0.000008	0.000009	0.000009	0.000009	0.000010	0.000010	0.000012
0.000013	0.000015	0.000016	0.000018	0.000019	0.000021	0.000022	0.000024	0.000026	0.000027 ].',[1], [90]);

gSAT(3,:)=reshape([
0.000117	0.000107	0.000097	0.000086	0.000079	0.000073	0.000068	0.000061	0.000054	0.000051
0.000047	0.000044	0.000041	0.000038	0.000035	0.000034	0.000035	0.000039	0.000040	0.000039
0.000038	0.000037	0.000035	0.000032	0.000028	0.000023	0.000020	0.000017	0.000015	0.000016
0.000016	0.000015	0.000013	0.000013	0.000013	0.000014	0.000012	0.000009	0.000005	0.000003
0.000003	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004
0.000004	0.000004	0.000004	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005
0.000005	0.000005	0.000005	0.000005	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006
0.000006	0.000007	0.000007	0.000008	0.000008	0.000008	0.000009	0.000009	0.000009	0.000011
0.000012	0.000014	0.000016	0.000017	0.000019	0.000020	0.000022	0.000024	0.000026	0.000027 ].',[1], [90]);

gSAT(4,:)=reshape([
0.000117	0.000107	0.000097	0.000086	0.000079	0.000073	0.000068	0.000061	0.000054	0.000051
0.000047	0.000044	0.000041	0.000038	0.000035	0.000034	0.000035	0.000039	0.000040	0.000039
0.000038	0.000037	0.000035	0.000032	0.000028	0.000023	0.000020	0.000017	0.000015	0.000016
0.000016	0.000015	0.000013	0.000013	0.000013	0.000014	0.000012	0.000009	0.000005	0.000003
0.000003	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004	0.000004
0.000004	0.000004	0.000004	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005
0.000005	0.000005	0.000005	0.000005	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006
0.000006	0.000007	0.000007	0.000008	0.000008	0.000008	0.000009	0.000009	0.000009	0.000011
0.000012	0.000014	0.000016	0.000017	0.000019	0.000020	0.000022	0.000024	0.000026	0.000027 ].',[1], [90]);

gSAT(5,:)=reshape([
0.000132	0.000126	0.000119	0.000111	0.000107	0.000104	0.000099	0.000092	0.000087	0.000083
0.000078	0.000072	0.000067	0.000063	0.000060	0.000057	0.000060	0.000063	0.000064	0.000060
0.000056	0.000052	0.000047	0.000042	0.000034	0.000029	0.000023	0.000019	0.000017	0.000016
0.000016	0.000014	0.000013	0.000011	0.000012	0.000012	0.000010	0.000008	0.000006	0.000005
0.000005	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005	0.000005
0.000005	0.000005	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006
0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006	0.000006
0.000006	0.000006	0.000007	0.000007	0.000007	0.000007	0.000007	0.000008	0.000008	0.000009
0.000011	0.000012	0.000013	0.000015	0.000016	0.000018	0.000020	0.000021	0.000023	0.000025 ].',[1], [90]);

                            
% read out frequencies and weights for SRF
% from O. Bobryshev's .mat-file

%
% NOAA18 ("qrr")
maximum_num_freq_a=max([length(frequency_h1a_qrr)  length(frequency_h2a_qrr)  length(frequency_h3a_qrr)  length(frequency_h4a_qrr)  length(frequency_h5a_qrr) ]);
maximum_num_freq_b=max([length(frequency_h1b_qrr)  length(frequency_h2b_qrr)  length(frequency_h3b_qrr)  length(frequency_h4b_qrr)  length(frequency_h5b_qrr) ]);

srf_frequency_a=nan(maximum_num_freq_a,5);
srf_frequency_b=nan(maximum_num_freq_b,5);

% srf_frequency_a(1:length(frequency_h1a_qrr),1)=frequency_h1a_qrr;
% srf_frequency_a(1:length(frequency_h2a_qrr),2)=frequency_h2a_qrr;
% srf_frequency_a(1:length(frequency_h3a_qrr),3)=frequency_h3a_qrr;
% srf_frequency_a(1:length(frequency_h4a_qrr),4)=frequency_h4a_qrr;
% srf_frequency_a(1:length(frequency_h5a_qrr),5)=frequency_h5a_qrr;
% 
% srf_frequency_b(1:length(frequency_h1b_qrr),1)=frequency_h1b_qrr;
% srf_frequency_b(1:length(frequency_h2b_qrr),2)=frequency_h2b_qrr;
% srf_frequency_b(1:length(frequency_h3b_qrr),3)=frequency_h3b_qrr;
% srf_frequency_b(1:length(frequency_h4b_qrr),4)=frequency_h4b_qrr;
% srf_frequency_b(1:length(frequency_h5b_qrr),5)=frequency_h5b_qrr;
% 
srf_weight_a=nan(maximum_num_freq_a,5);
srf_weight_b=nan(maximum_num_freq_b,5);

% srf_weight_a(1:length(frequency_h1a_qrr),1)=gain_h1a_qrr-max(gain_h1a_qrr);
% srf_weight_a(1:length(frequency_h2a_qrr),2)=gain_h2a_qrr-max(gain_h2a_qrr);
% srf_weight_a(1:length(frequency_h3a_qrr),3)=gain_h3a_qrr-max(gain_h3a_qrr);
% srf_weight_a(1:length(frequency_h4a_qrr),4)=gain_h4a_qrr-max(gain_h4a_qrr);
% srf_weight_a(1:length(frequency_h5a_qrr),5)=gain_h5a_qrr-max(gain_h5a_qrr);
% 
% srf_weight_b(1:length(frequency_h1b_qrr),1)=gain_h1b_qrr-max(gain_h1b_qrr);
% srf_weight_b(1:length(frequency_h2b_qrr),2)=gain_h2b_qrr-max(gain_h2b_qrr);
% srf_weight_b(1:length(frequency_h3b_qrr),3)=gain_h3b_qrr-max(gain_h3b_qrr);
% srf_weight_b(1:length(frequency_h4b_qrr),4)=gain_h4b_qrr-max(gain_h4b_qrr);
% srf_weight_b(1:length(frequency_h5b_qrr),5)=gain_h5b_qrr-max(gain_h5b_qrr);

% uncertainty in counts due to RFI
u_RFI_counts=zeros(3,5);
%earthviews
% u_RFI_counts(1,1)=120;
% u_RFI_counts(1,2)=105;
% u_RFI_counts(1,3)=95;
% u_RFI_counts(1,4)=90;
% u_RFI_counts(1,5)=50;
% %DSV
% u_RFI_counts(2,1)=118;
% u_RFI_counts(2,2)=103;
% u_RFI_counts(2,3)=93;
% u_RFI_counts(2,4)=87;
% u_RFI_counts(2,5)=49;
% %IWCT
% u_RFI_counts(3,1)=96;
% u_RFI_counts(3,2)=84;
% u_RFI_counts(3,3)=76;
% u_RFI_counts(3,4)=71;
% u_RFI_counts(3,5)=40;  

           save('coeffs_metopbmhs_antcorr_alpha.mat', 'gE','gS','gSAT', 'alpha','count_thriwct','count_thrdsv','jump_thr','threshold_earth','jump_thrICTtempmean', ...
               'srf_frequency_a', 'srf_frequency_b','srf_weight_a','srf_weight_b','u_RFI_counts')

           
           



           