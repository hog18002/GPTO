 function [T23, grad_T23,T_L] = compute_T23 ()

%% This function compute T23, the time of welding plus the time of  
%% additional fabrication actions and grad_T23, their sensitivities.

%% T23, the time of welding plus the time of additional fabrication actions

    global FE OPT GEOM
    
    C2 = 0.8e-3;  % (min/mm^2.5) Constant depend on different welding technologies
    tmin = 10;   % (mm) the thickness of plate() we use
    a_w = 0.7 * tmin;  % the weld size
    
    alpha_b = OPT.dv(OPT.size_dv); % Size variables of each bar
        
    alpha_ij =  reshape(alpha_b,[GEOM.n_bar,1]).* ... % i
                reshape(alpha_b,[1,GEOM.n_bar]); % j
    alpha_ij(eye(GEOM.n_bar)==1) = 0;
        
    I_ij  = sum(...
            reshape(OPT.norm_grad_rho_be,[GEOM.n_bar,1,FE.n_elem]).* ... % i.e
            reshape(OPT.rho_be,[1,GEOM.n_bar,FE.n_elem]).* ... % .je
            reshape(FE.elem_vol(:), [1,1,FE.n_elem]),... 
            3); % ij % do sum by the third parameter
    I_ij(eye(GEOM.n_bar)==1) = 0; % zero the diagonal % we have to have this line, 
    
    T_L = sum(alpha_ij .* I_ij,[1,2]);% The length of welding

    tmp0 = 1.3 * C2 * a_w;
    
    T23 = tmp0 * T_L; % T2 + T3, the time of welding plus the time of additional fabrication actions
    
%% The sensitivity of T23  
    
    if nargout > 1
        
        DI_ij_Dbar_k_ends = sum (...
            (...
                reshape(OPT.Dnorm_grad_rho_be_D_bar_ends, [GEOM.n_bar,1,FE.n_elem, 2*FE.dim]) .* ... %i.eI (I means the degree of freedom of bar ends)
                reshape(OPT.rho_be,[1,GEOM.n_bar,FE.n_elem]) ... % .je 
            ) .*...
            reshape(FE.elem_vol(:), [1,1,FE.n_elem]), ... % ..e
            3).* permute(eye(GEOM.n_bar),[1,3,2]) ... % D1i_D3k
            + ...
            sum (...
            (...
                reshape(OPT.norm_grad_rho_be, [GEOM.n_bar,1,FE.n_elem]) .* ... %i.e 
                reshape(OPT.Drho_be_Dbar_ends,[1,GEOM.n_bar,FE.n_elem,2*FE.dim]) ... % .jeI
            ) .* ...
            reshape(FE.elem_vol(:), [1,1,FE.n_elem]), ...% ..e
            3) .* permute(eye(GEOM.n_bar), [3,1,2]);  % D2j_D3k
        
        
        DI_ij_Dbar_k_radii = sum (...
            (...
                reshape(OPT.Dnorm_grad_rho_be_D_bar_radii, [GEOM.n_bar,1,FE.n_elem]) .* ... %i.e
                reshape(OPT.rho_be,[1,GEOM.n_bar,FE.n_elem]) ... % .je 
            ) .*...
            reshape(FE.elem_vol(:) , [1,1,FE.n_elem]), ... % ..e
            3).* permute(eye(GEOM.n_bar),[1,3,2]) ...
            + ...
            sum (...
            (...
                reshape(OPT.norm_grad_rho_be, [GEOM.n_bar,1,FE.n_elem]) .* ... %i.e 
                reshape(OPT.Drho_be_Dbar_radii,[1,GEOM.n_bar,FE.n_elem,1]) ... % .je
            ) .*...
            reshape(FE.elem_vol(:) , [1,1,FE.n_elem]), ...% ..e
            3).* permute(eye(GEOM.n_bar),[3,1,2]);


        % zero diagonal (sum when bars are different)
        DI_ij_Dbar_k_ends(repmat(eye(GEOM.n_bar)==1,[1,1,GEOM.n_bar, 2*FE.dim])) = 0;   
        DI_ij_Dbar_k_radii(repmat(eye(GEOM.n_bar)==1,[1,1,GEOM.n_bar,1])) = 0;


        DT23_Dbar_ends = tmp0 * reshape(sum( alpha_ij .* DI_ij_Dbar_k_ends,[1,2]),[GEOM.n_bar, 2*FE.dim]);
        DT23_Dbar_radii = reshape(sum(tmp0 * alpha_ij .* DI_ij_Dbar_k_radii,[1,2]),[GEOM.n_bar, 1]);
        DT23_Dbar_size = tmp0 * ( (I_ij + I_ij.') * alpha_b );


        DT23_Ddv = zeros(OPT.n_dv,1);
        for b = 1:GEOM.n_bar
            DT23_Ddv(OPT.bar_dv(:,b),1) = DT23_Ddv(OPT.bar_dv(:,b),1) + ...
                [ DT23_Dbar_ends(b,:), ...
                  DT23_Dbar_size(b), ...
                  DT23_Dbar_radii(b)].';   
        end

        grad_T23 = DT23_Ddv;
        
    end

end