


% partly implement the recipes given by Chris Merchant in FIDUCEO doc. for
% the computation of the correlation matrices

% Cross Channel Correlation matrices for
% a) independent
% b) structured
% c) common 
% effects.
fillvalint16=-32768;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear S_all S U R u_diag
% (a) INDEPENDENT EFFECTS

%start loop over chosen pixel range
lines_vec=4:100:length(btemps)-3; %cut of the first 3 lines and last 3 lines (since they are only part of 7-line-av. and did not get correct uncertainties)
num_fov=number_of_fovs; % value taken from previously called scripts
S_all=zeros(5,5,num_fov,length(lines_vec));

for fov=1:num_fov
    
    for line_ind=1:length(lines_vec)
        line=lines_vec(line_ind);
        % Cross- channel parameter error correlation matrix for one effect: R_c^(p,k)
        %-----------------------------------------------------------------------------
        % c...... indicating the "cross-channel", i.e. this R has the dimension n_ch x
        %           n_ch, in our case 5x5.
        % p...... indicating that there is one R matrix for each pixel (element, line);
        %           
        % k...... is the index for the effect (for 3 effects k runs from 1 to 3)


        % Per independent effect:
        % 1. earth count noise
        % no correlation between channels
        R{1}=diag([1 1 1 1 1]);

        % 2. Antenna position earth view, random variations
        % assume full correlation between channels. The pointing deviation
        % (systematic) is different for the channels, but we assume here that the
        % random variations are due to misspositioning by the motor and hence valid for
        % all channels equally, hence "1 everywhere"
        R{2}= ones(5,5); 


        % Cross- channel parameter uncertainty matrix for one effect: U_c^(p,k)
        %-----------------------------------------------------------------------------
        % c...... indicating the "cross-channel", i.e. this R has the dimension n_ch x
        %           n_ch, in our case 5x5.
        % p...... indicating that there is one R matrix for each pixel (element, line);
        %           
        % k...... is the index for the effect (for 3 effects k runs from 1 to 3)


        % Per independent effect :

        % 1. earth count noise
        u_vector_channels_eff1= sqrt(u_btemps_C_E(:,fov,line).^2); %take all channels
        U{1}=diag(u_vector_channels_eff1);

        % 2. Antenna position earth view, random variations
        u_vector_channels_eff2= sqrt(u_btemps_Antenna_position_earthview(:,fov,line).^2); %take all channels
        U{2}=diag(u_vector_channels_eff2);


        % Covariance matrix S
        % S=mean(mean(sum(U*R*U^T,effects),fov),lines)

        % loop over effects:
        S=zeros(size(R{1}));
        for k_effect=1:length(R)

            S=S+U{k_effect}*R{k_effect}*U{k_effect}.';

        end

        S_all(:,:,fov,line)=S;

    end
end % end loop over chosen pixel range


% average over chosen pixel (fov, line) range
S_all(S_all==0)=nan;
S_c_i=mean(mean(S_all,4,'omitnan'),3,'omitnan');
S_c_i(isnan(S_c_i))=0;

% Uncertainty matrix U_c_i
u_diag=sqrt([S_c_i(1,1) S_c_i(2,2) S_c_i(3,3) S_c_i(4,4) S_c_i(5,5)]);
index=find(u_diag==0); %pick channels that have zero uncertainty (those were not calibrated)
u_diag(index)=inf;
U_c_i=diag(u_diag);


% Correlation matrix R_c,i
R_c_i=U_c_i\S_c_i/U_c_i.'; %matlab suggestion for inv(U)*S*inv(U).'
% set uncalibrated channels to fillvalint16
R_c_i(index,:)=fillvalint16;
R_c_i(:,index)=fillvalint16;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear S_all S U R u_diag

% (b) STRUCTURED EFFECTS

%start loop over chosen pixel range
lines_vec=4:100:length(btemps)-3; %cut of the first 3 lines and last 3 lines (since they are only part of 7-line-av. and did not get correct uncertainties)
num_fov=number_of_fovs; % value taken from previously called scripts
S_all=zeros(5,5,num_fov,length(lines_vec));

for fov=1:num_fov
    
    for line_ind=1:length(lines_vec)
        line=lines_vec(line_ind);
        % Cross- channel parameter error correlation matrix for one effect: R_c^(p,k)
        %-----------------------------------------------------------------------------
        % c...... indicating the "cross-channel", i.e. this R has the dimension n_ch x
        %           n_ch, in our case 5x5.
        % p...... indicating that there is one R matrix for each pixel (element, line);
        %           
        % k...... is the index for the effect (for 3 effects k runs from 1 to 3)


        % Per structured effect:
        % 1. DSV count noise
        % no correlation between channels
        R{1}=diag([1 1 1 1 1]);
        
                
        % 2. IWCT count noise
        % no correlation between channels
        R{2}=diag([1 1 1 1 1]);

        % 3. Antenna position space view, random variations
        % assume full correlation between channels. The pointing deviation
        % (systematic) is different for the channels, but we assume here that the
        % random variations are due to misspositioning by the motor and hence valid for
        % all channels equally, hence "1 everywhere"
        R{3}= ones(5,5); 
        
        % 4. T_IWCT  noise
        % full correlation between channels
        R{4}=ones(5,5);


        % Cross- channel parameter uncertainty matrix for one effect: U_c^(p,k)
        %-----------------------------------------------------------------------------
        % c...... indicating the "cross-channel", i.e. this R has the dimension n_ch x
        %           n_ch, in our case 5x5.
        % p...... indicating that there is one R matrix for each pixel (element, line);
        %           
        % k...... is the index for the effect (for 3 effects k runs from 1 to 3)


        % Per structured effect :

        % 1. DSV count noise
        u_vector_channels_eff1= sqrt(u_btemps_C_S(:,fov,line).^2); %take all channels
        U{1}=diag(u_vector_channels_eff1);
        
        % 2. IWCT count noise
        u_vector_channels_eff2= sqrt(u_btemps_C_IWCT(:,fov,line).^2); %take all channels
        U{2}=diag(u_vector_channels_eff2);

        % 3. Antenna position earth view, random variations
        u_vector_channels_eff3= sqrt(u_btemps_Antenna_position_spaceview(:,fov,line).^2); %take all channels
        U{3}=diag(u_vector_channels_eff3);

        % 4. T_IWCT  noise
        u_vector_channels_eff4= sqrt(u_btemps_T_IWCT_noise(:,fov,line).^2); %take all channels
        U{4}=diag(u_vector_channels_eff4);

        % Covariance matrix S
        % S=mean(mean(sum(U*R*U^T,effects),fov),lines)

        % loop over effects:
        S=zeros(size(R{1}));
        for k_effect=1:length(R)

            S=S+U{k_effect}*R{k_effect}*U{k_effect}.';

        end

        S_all(:,:,fov,line)=S;

    end
end % end loop over chosen pixel range


% average over chosen pixel (fov, line) range
S_all(S_all==0)=nan;
S_c_s=mean(mean(S_all,4,'omitnan'),3,'omitnan');
S_c_s(isnan(S_c_s))=0;

% Uncertainty matrix U_c_i
u_diag=sqrt([S_c_s(1,1) S_c_s(2,2) S_c_s(3,3) S_c_s(4,4) S_c_s(5,5)]);
index=find(u_diag==0); %pick channels that have zero uncertainty (those were not calibrated)
u_diag(index)=inf;
U_c_s=diag(u_diag);


% Correlation matrix R_c,i
R_c_s=U_c_s\S_c_s/U_c_s.'; %matlab suggestion for inv(U)*S*inv(U).'
% set uncalibrated channels to fillvalint16
R_c_s(index,:)=fillvalint16;
R_c_s(:,index)=fillvalint16;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear S_all S U R u_diag

% (c) COMMON EFFECTS

%start loop over chosen pixel range
lines_vec=4:100:length(btemps)-3; %cut of the first 3 lines and last 3 lines (since they are only part of 7-line-av. and did not get correct uncertainties)
num_fov=number_of_fovs; % value taken from previously called scripts
S_all=zeros(5,5,num_fov,length(lines_vec));

for fov=1:num_fov
    
    for line_ind=1:length(lines_vec)
        line=lines_vec(line_ind);
        % Cross- channel parameter error correlation matrix for one effect: R_c^(p,k)
        %-----------------------------------------------------------------------------
        % c...... indicating the "cross-channel", i.e. this R has the dimension n_ch x
        %           n_ch, in our case 5x5.
        % p...... indicating that there is one R matrix for each pixel (element, line);
        %           
        % k...... is the index for the effect (for 3 effects k runs from 1 to 3)


        % Per common effect:
        % 1. T_IWCT syst
        % full correlation between channels
        R{1}=ones(5,5); 
        
                
        % 2. dT_w
        % full correlation between channels?
        R{2}=ones(5,5); 

        % 3. dT_c
       % correlation between channels 3-4? (3,4 get same values for MHS, 18-20 get same values for AMSUB)
        R{3}=  [1 0 0 0 0;
                0 1 0 0 0;
                0 0 1 1 0 ;
                0 0 1 1 0;
                0 0 0 0 1];
        
        % 4. nonlinearity
        % some correlation between 3-4 and 2, small corr to chn1? estimated
        % from Atkinson1998 Fig 6; MatraMarconi tests?
        R{4}=  [1.0 0.0 0.0 0.0 0.0;
                0.0 1.0 0.3 0.3 0.3;
                0.0 0.3 1.0 0.8 0.8;
                0.0 0.3 0.8 1.0 0.8;
                0.0 0.3 0.8 0.8 1.0];
        
        % 5. alpha
        % correlation between channels 3-4? (3,4 get same values for MHS; AMSUB gets none...)
        R{5}=  [1 0 0 0 0;
                0 1 0 0 0;
                0 0 1 1 0;
                0 0 1 1 0;
                0 0 0 0 1];
        
        % 6. Antenna correction Earth contribution
        % correlation between channels 3-4-5?
        R{6}=  [1 0 0 0 0;
                0 1 0 0 0;
                0 0 1 1 0.9;
                0 0 1 1 0.9;
                0 0 0.9 0.9 1];
        
        % 7. Antenna correction Space contribution
        % correlation between channels 3-4?
        R{7}=  [1 0 0 0 0;
                0 1 0 0 0;
                0 0 1 1 0.9;
                0 0 1 1 0.9;
                0 0 0.9 0.9 1];
        
        % 8. Antenna correction Platform contribution
        % correlation between channels 3-4?
        R{8}=   [1 0 0 0 0;
                0 1 0 0 0;
                0 0 1 1 0.9;
                0 0 1 1 0.9;
                0 0 0.9 0.9 1];
        
        % 9. Radiance of Platform
        % fully correlated between channels 
        R{9}=ones(5,5);
        
        % 10. Antenna position Earth view (systematic)
        % correlation between channels 3-4-5?
        R{10}=[1 0 0 0 0;
                0 1 0 0 0;
                0 0 1 1 0.9;
                0 0 1 1 0.9;
                0 0 0.9 0.9 1];
        
        % 11. Antenna position Space view (systematic)
        % correlation between channels 3-4-5?
        R{11}=[1 0 0 0 0;
                0 1 0 0 0;
                0 0 1 1 0.9;
                0 0 1 1 0.9;
                0 0 0.9 0.9 1];
        
        % 12. RFI
        % uncorrelated between channels
        R{11}=diag([1 1 1 1 1]);
        
        

        % Cross- channel parameter uncertainty matrix for one effect: U_c^(p,k)
        %-----------------------------------------------------------------------------
        % c...... indicating the "cross-channel", i.e. this R has the dimension n_ch x
        %           n_ch, in our case 5x5.
        % p...... indicating that there is one R matrix for each pixel (element, line);
        %           
        % k...... is the index for the effect (for 3 effects k runs from 1 to 3)


        % Per structured effect :

        % 1.  T_IWCT syst
        u_vector_channels_eff1= sqrt(u_btemps_T_IWCT(:,fov,line).^2); %take all channels
        U{1}=diag(u_vector_channels_eff1);
        
        % 2. dT_w
        u_vector_channels_eff2= sqrt(u_btemps_dT_w(:,fov,line).^2); %take all channels
        U{2}=diag(u_vector_channels_eff2);

        % 3. dT_c
        u_vector_channels_eff3= sqrt(u_btemps_dT_c(:,fov,line).^2); %take all channels
        U{3}=diag(u_vector_channels_eff3);

        % 4. nonlinearity
        u_vector_channels_eff4= sqrt(u_btemps_nonlincoeff(:,fov,line).^2); %take all channels
        U{4}=diag(u_vector_channels_eff4);
        
        % 5. alpha
        u_vector_channels_eff5= sqrt(u_btemps_alpha(:,fov,line).^2); %take all channels
        U{5}=diag(u_vector_channels_eff5);   
        
        % 6. Antenna correction Earth contribution
        u_vector_channels_eff6= sqrt(u_btemps_Antenna_corrcoeff_earthcontribution(:,fov,line).^2); %take all channels
        U{6}=diag(u_vector_channels_eff6); 
        
        % 7. Antenna correction Space contribution
        u_vector_channels_eff7= sqrt(u_btemps_Antenna_corrcoeff_spacecontribution(:,fov,line).^2); %take all channels
        U{7}=diag(u_vector_channels_eff7); 
        
        % 8. Antenna correction Platform contribution
        u_vector_channels_eff8= sqrt(u_btemps_Antenna_corrcoeff_platformcontribution(:,fov,line).^2); %take all channels
        U{8}=diag(u_vector_channels_eff8); 
        
        % 9. Radiance of Platform
        u_vector_channels_eff9= sqrt(u_btemps_radiance_of_platform(:,fov,line).^2); %take all channels
        U{9}=diag(u_vector_channels_eff9); 
        
        % 10. Antenna position Earth view (systematic)
        u_vector_channels_eff10= sqrt(u_btemps_Antenna_position_earthview_syst(:,fov,line).^2); %take all channels
        U{10}=diag(u_vector_channels_eff10); 
        
        % 11. Antenna position Space view (systematic)
        u_vector_channels_eff11= sqrt(u_btemps_Antenna_position_spaceview_syst(:,fov,line).^2); %take all channels
        U{11}=diag(u_vector_channels_eff11); 
        
        % 12. RFI
        u_vector_channels_eff12= sqrt(u_RFI_btemps(:,fov,line).^2); %take all channels
        U{12}=diag(u_vector_channels_eff12); 
        
        

        % Covariance matrix S
        % S=mean(mean(sum(U*R*U^T,effects),fov),lines)

        % loop over effects:
        S=zeros(size(R{1}));
        for k_effect=1:4%length(R)

            S=S+U{k_effect}*R{k_effect}*U{k_effect}.';

        end

        S_all(:,:,fov,line)=S;

    end
end % end loop over chosen pixel range


% average over chosen pixel (fov, line) range
S_all(S_all==0)=nan;
S_c_co=mean(mean(S_all,4,'omitnan'),3,'omitnan');
S_c_co(isnan(S_c_co))=0;

% Uncertainty matrix U_c_i
u_diag=sqrt([S_c_co(1,1) S_c_co(2,2) S_c_co(3,3) S_c_co(4,4) S_c_co(5,5)]);
index=find(u_diag==0); %pick channels that have zero uncertainty (those were not calibrated)
u_diag(index)=inf;
U_c_co=diag(u_diag);


% Correlation matrix R_c,i
R_c_co=U_c_co\S_c_co/U_c_co.'; %matlab suggestion for inv(U)*S*inv(U).'
% set uncalibrated channels to fillvalint16
R_c_co(index,:)=fillvalint16;
R_c_co(:,index)=fillvalint16;
