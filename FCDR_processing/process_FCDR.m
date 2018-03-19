

% process_FCDR



f = fieldnames(monthly_data_record);
nEQfile=1;

if strcmp(sen,'mhs')
    cut=50;
    % load limits for counts, "antenna correction coeffs" and coefficient "alpha" from file
    filenamestring=['coeffs_',sat,sen,'_antcorr_alpha.mat'];
    load(filenamestring)
    
    while nEQfile<=length(crossings_and_gap)-1
        disp('-------------------------    next file   --------------------------------')
        
        clearvars -except  tic cut satsenyear sat sen year selectinstrument selectsatellite selectyear chosen_month... 
        gE gS gSAT alpha count_thriwct...
        count_thrdsv jump_thr threshold_earth jump_thrICTtempmean ...
        srf_weight_a srf_weight_b srf_frequency_a srf_frequency_b u_RFI_counts ...
        crossings_and_gap nEQfile monthly_data_header monthly_data_record f file_list
    
        %% produce EQ2EQ files with header info and traceability info on
        % original files
        disp(['Files for Equator crossing ',num2str(nEQfile)])
        [data,hdrinfo]=chop_data_EQ2EQ(crossings_and_gap,nEQfile,monthly_data_header,monthly_data_record,f,file_list);
        
        %% set up and processing
        disp('...setup and processing...')
        
        try
        setup_MHS_processing2l1c
        disp(hdrinfo.dataset_name)
        %setup_Eq2Eq_fullFCDR_uncertproc_MHS_v2_sensitivitystudy
        catch ME
            switch ME.identifier
                case {'fill_missing_scanlines:timejump_bw','fill_missing_scanlines:timejump_toolarge'}
                    disp(['Warning: file ', num2str(nEQfile), ' Error.' ])

                    nEQfile=nEQfile+1; %normal increase of nEQfile by one
                    continue
                otherwise
                    ME.rethrow();
            end
         end



        if onlybadPRTmeasurements==1 

            if length(data.scan_line_number)>1000
                disp('Only bad PRT measurements. Processing impossible.')
                prepare_empty_file
                write_easyFCDR_orbitfile_MHS
            else
                disp('Go to next file. This one is too short to be written.')
            end
            
            nEQfile=nEQfile+1; %normal increase of nEQfile by one
            continue
        end

        %% evaluate measurement equation
        disp('Evaluation of measurement equation... ')
        measurement_equation
      


        %% calculate uncertainties
        disp('... and propagation of uncertainty ...')
        uncertainty_propagation_optimized

        %% quality flags
        disp('...setting quality flags...')
      
        %try
            quality_flags_fromlevel1b
            quality_flags_setting_easyFCDR
%         catch ME
%             disp('%%%%% ERROR MESSAGE FROM QUALITY FLAGS SETTING %%%%%')
%             ME.message
%             disp('Error in ')
%             ME.stack.name
%             disp('in lines')
%             ME.stack.line
%             disp('generate_FCDR: Error in quality_flag_setting-script. No further processing possible. Continue with next orbit.')
%             disp('%%%%% END: error message from setup script %%%%%')
% 
%             nEQfile=nEQfile+1; %normal increase of nEQfile by one
%             continue
% 
% 
%         end

        % add uncertinay due to RFI to u_common (depends on qualityflags setting)
        add_RFI_uncertainty


        %

        % write easyFCDR
        write_easyFCDR_orbitfile_MHS %_debugging

        nEQfile=nEQfile+1; %normal increase of nEQfile by one
    end
    
elseif strcmp(sen,'amsub')
    cut=54;
    % load limits for counts, "antenna correction coeffs" and coefficient "alpha" from file
    filenamestring=['coeffs_',sat,sen,'_antcorr_alpha.mat'];
    load(filenamestring)
    
    while nEQfile<=length(crossings_and_gap)-1
        disp('-------------------------    next file   --------------------------------')
        
        clearvars -except  cut tic satsenyear sat sen year selectinstrument selectsatellite selectyear chosen_month... 
        gE gS gSAT alpha count_thriwct...
        count_thrdsv jump_thr threshold_earth jump_thrICTtempmean ...
        srf_weight_a srf_weight_b srf_frequency_a srf_frequency_b u_RFI_counts ...
        crossings_and_gap nEQfile monthly_data_header monthly_data_record f file_list
    
        %% produce EQ2EQ files with header info and traceability info on
        % original files
        disp(['Files for Equator crossing ',num2str(nEQfile)])
        [data,hdrinfo]=chop_data_EQ2EQ(crossings_and_gap,nEQfile,monthly_data_header,monthly_data_record,f,file_list);
        
        %% set up and processing
        disp('...setup and processing...')
        
        try
        setup_AMSUB_processing2l1c
        disp(hdrinfo.dataset_name)
        
        catch ME
            switch ME.identifier
                case {'fill_missing_scanlines:timejump_bw','fill_missing_scanlines:timejump_toolarge'}
                    disp(['Warning: file ', num2str(nEQfile), ' Error.' ])

                    nEQfile=nEQfile+1; %normal increase of nEQfile by one
                    continue
                otherwise
                    ME.rethrow();
            end
         end



        if onlybadPRTmeasurements==1 

            if length(data.scan_line_number)>1000
                disp('Only bad PRT measurements. Processing impossible.')
                prepare_empty_file
                write_easyFCDR_orbitfile_AMSUB
            else
                disp('Go to next file. This one is too short to be written.')
            end
            
            nEQfile=nEQfile+1; %normal increase of nEQfile by one
            continue
        end

        %% evaluate measurement equation
        disp('Evaluation of measurement equation... ')
        measurement_equation
      


        %% calculate uncertainties
        disp('... and propagation of uncertainty ...')
        uncertainty_propagation_optimized

        %% quality flags
        disp('...setting quality flags...')
      
        %try
            quality_flags_fromlevel1b
            quality_flags_setting_easyFCDR
%         catch ME
%             disp('%%%%% ERROR MESSAGE FROM QUALITY FLAGS SETTING %%%%%')
%             ME.message
%             disp('Error in ')
%             ME.stack.name
%             disp('in lines')
%             ME.stack.line
%             disp('generate_FCDR: Error in quality_flag_setting-script. No further processing possible. Continue with next orbit.')
%             disp('%%%%% END: error message from setup script %%%%%')
% 
%             nEQfile=nEQfile+1; %normal increase of nEQfile by one
%             continue
% 
% 
%         end

        % add uncertinay due to RFI to u_common (depends on qualityflags setting)
        add_RFI_uncertainty


        %

        % write easyFCDR
        write_easyFCDR_orbitfile_AMSUB %_debugging

        nEQfile=nEQfile+1; %normal increase of nEQfile by one
     end

elseif strcmp(sen,'ssmt2')
    cut=50;
    % load limits for counts, "antenna correction coeffs" and coefficient "alpha" from file
    filenamestring=['coeffs_',sat,sen,'_alpha.mat'];
    load(filenamestring)
    
    while nEQfile<=length(crossings_and_gap)-1
        disp('-------------------------    next file   --------------------------------')
        
        clearvars -except  cut  tic satsenyear sat sen year selectinstrument selectsatellite selectyear chosen_month... 
        gE gS gSAT alpha count_thriwct...
        count_thrdsv jump_thr threshold_earth jump_thrICTtempmean ...
        srf_weight_a srf_weight_b srf_frequency_a srf_frequency_b u_RFI_counts ...
        crossings_and_gap nEQfile monthly_data_header monthly_data_record f file_list
    
        %% produce EQ2EQ files with header info and traceability info on
        % original files
        disp(['Files for Equator crossing ',num2str(nEQfile)])
        [data,hdrinfo]=chop_data_EQ2EQ(crossings_and_gap,nEQfile,monthly_data_header,monthly_data_record,f,file_list);
        
        %% set up and processing
        disp('...setup and processing...')
        
        try
        setup_SSMT2_processing2l1c
        disp(hdrinfo.dataset_name)
        
        catch ME
            switch ME.identifier
                case {'fill_missing_scanlines_SSMT2:timejump_bw','fill_missing_scanlines_SSMT2:timejump_toolarge'}
                    disp(['Warning: file ', num2str(nEQfile), ' Error.' ])

                    nEQfile=nEQfile+1; %normal increase of nEQfile by one
                    continue
                otherwise
                    disp('here')
                    ME.rethrow();
            end
         end



        if onlybadPRTmeasurements==1 

            if length(data.scan_line_number)>350
                disp('Only bad PRT measurements. Processing impossible.')
                prepare_empty_file
                write_easyFCDR_orbitfile_SSMT2 %_debugging
            else
                disp('Go to next file. This one is too short to be written.')
            end
            
            nEQfile=nEQfile+1; %normal increase of nEQfile by one
            continue
        end

        %% evaluate measurement equation
        disp('Evaluation of measurement equation... ')
        measurement_equation
      


        %% calculate uncertainties
        disp('... and propagation of uncertainty ...')
        uncertainty_propagation_optimized

        %% quality flags
        disp('...setting quality flags...')
      
        %try
            quality_flags_fromlevel1b
            quality_flags_setting_easyFCDR
%         catch ME
%             disp('%%%%% ERROR MESSAGE FROM QUALITY FLAGS SETTING %%%%%')
%             ME.message
%             disp('Error in ')
%             ME.stack.name
%             disp('in lines')
%             ME.stack.line
%             disp('generate_FCDR: Error in quality_flag_setting-script. No further processing possible. Continue with next orbit.')
%             disp('%%%%% END: error message from setup script %%%%%')
% 
%             nEQfile=nEQfile+1; %normal increase of nEQfile by one
%             continue
% 
% 
%         end

        % add uncertinay due to RFI to u_common (depends on qualityflags setting)
        add_RFI_uncertainty


        %

        % write easyFCDR
        write_easyFCDR_orbitfile_SSMT2 %_debugging

        nEQfile=nEQfile+1; %normal increase of nEQfile by one
    end
else
    disp('No FIDUCEO FCDR processing for this sensor.')
    return
end