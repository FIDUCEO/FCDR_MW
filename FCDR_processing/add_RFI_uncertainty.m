





% add u_RFI to u_common_btemps

  %set u_RFI to zero for all times where NO transponder is on.
  quality_scanline_bitmask_exp=permute(repmat(quality_scanline_bitmask,[5 1 number_of_fovs]),[1 3 2]);
  u_RFI_btemps_active=logical(quality_scanline_bitmask_exp).*u_RFI_btemps;
  
  
  u_common_btemps_intermed_sq=(u_common_btemps).^2;
  u_common_btemps=sqrt(u_common_btemps_intermed_sq+u_RFI_btemps_active.^2);