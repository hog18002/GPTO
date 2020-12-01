function [T1, grad_T1, K_m,grad_K_m, V] = compute_T1()
% This function compute T1, the time for preparation, assembly and tacking and its sensitivity.

% theta_d - the diffculty factor
% rho - material density
% V - volume of the frame
% kappa - the number of structural elements to be assembled

%% T1, the time of preparation, assembly and tacking and its sensitivity
    global FE OPT 
    
    theta_d = 1; % $\in \{1,2,3,4\}$ difficulty factor
      
    alpha_b = OPT.dv(OPT.size_dv); % the coordinate of size variable
    kappa = sum(alpha_b); % number of bars in design (sum of size variables)??
    
    total_volume = sum(FE.elem_vol); % total volume of the whole mesh??
    
    compute_volume_fraction();
    V = OPT.volume_fraction * total_volume; % volume of frame 
    
    % T1, the time for preparation, assembly and tacking and its sensitivity.
    T1 = theta_d * sqrt(kappa * FE.material.physical_density * V); % Time for preparation, assembly and tacking

    Dkappa_Ddv = zeros(size(OPT.dv)); 
    Dkappa_Ddv(OPT.size_dv) = 1; 
    DV_Ddv = OPT.grad_volume_fraction .* total_volume;
    
    % Sensitivity of T1
    grad_T1 = theta_d * sqrt(FE.material.physical_density)/...
        (2 * sqrt(kappa * V)) *(kappa * DV_Ddv + V * Dkappa_Ddv);
    % dv means design variables
    
%% Mass of the frame
    K_m = FE.material.physical_density * V; % Material cost
    grad_K_m = FE.material.physical_density * DV_Ddv; % sensitiviy of the mass of the frame

end

