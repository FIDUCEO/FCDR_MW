


% partly implement the recipes given by Chris Merchant in FIDUCEO doc. for
% the computation of the correlation matrices

% Cross Channel Correlation matrices for
% a) independent
% b) structured
% c) common 
% effects.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        u_vector_channels_eff1= u_btemps_C_E(:,fov,line); %take all channels
        U{1}=diag(u_vector_channels_eff1);

        % 2. Antenna position earth view, random variations
        u_vector_channels_eff2= u_btemps_Antenna_position_earthview(:,fov,line); %take all channels
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
S_c_i=mean(mean(S_all,4),3);

% Uncertainty matrix U_c_i
u_diag=sqrt([S_c_i(1,1) S_c_i(2,2) S_c_i(3,3) S_c_i(4,4) S_c_i(5,5)]);
U_c_i=diag(u_diag);


% Correlation matrix R_c,i
R_c_i=U_c_i\S_c_i/U_c_i.'; %matlab suggestion for inv(U)*S*inv(U).'



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
        u_vector_channels_eff1= u_btemps_C_S(:,fov,line); %take all channels
        U{1}=diag(u_vector_channels_eff1);
        
        % 2. IWCT count noise
        u_vector_channels_eff2= u_btemps_C_IWCT(:,fov,line); %take all channels
        U{2}=diag(u_vector_channels_eff2);

        % 3. Antenna position earth view, random variations
        u_vector_channels_eff3= u_btemps_Antenna_position_spaceview(:,fov,line); %take all channels
        U{3}=diag(u_vector_channels_eff3);

        % 4. T_IWCT  noise
        u_vector_channels_eff4= u_btemps_T_IWCT_noise(:,fov,line); %take all channels
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
S_c_s=mean(mean(S_all,4),3);

% Uncertainty matrix U_c_i
u_diag=sqrt([S_c_s(1,1) S_c_s(2,2) S_c_s(3,3) S_c_s(4,4) S_c_s(5,5)]);
U_c_s=diag(u_diag);


% Correlation matrix R_c,i
R_c_s=U_c_s\S_c_s/U_c_s.'; %matlab suggestion for inv(U)*S*inv(U).'
