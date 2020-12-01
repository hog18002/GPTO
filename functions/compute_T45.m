function [T45, grad_T45, As] = compute_T45 ()
    
%% This function compute T45, the time of surface preparation plus 
%% painting time, and grad_T45 their sensitivities. 
    
    global OPT GEOM
    
    Theta_ds = 1;
    Theta_dp = 1;
    
    alpha_b = OPT.dv(OPT.size_dv); % size variable of each bar
    r_b = OPT.dv(OPT.radius_dv); % radius of each bar
    l_b = sqrt((OPT.dv(OPT.bar_dv(1,1:GEOM.n_bar)) - OPT.dv(OPT.bar_dv(3,1:GEOM.n_bar))).^2 + ...
               (OPT.dv(OPT.bar_dv(2,1:GEOM.n_bar)) - OPT.dv(OPT.bar_dv(4,1:GEOM.n_bar))).^2 ...
               );  % length of each bar
    
    % mm^2 The area of surface of the bar
    As = 2 * pi * sum( alpha_b .* r_b .* l_b);
    
    a_sp = 3e-6; % min/mm^2
    
    % T4 + T5 the time of surface preparation and painting time
    T45_over_As = (a_sp* Theta_ds + 7.15e-6 * Theta_dp);
    T45 = T45_over_As * As ;
    
%% sensitivity of T45

    if nargout > 1
        
        l_unitvector_b = [OPT.dv(OPT.bar_dv(1,1:GEOM.n_bar)) - OPT.dv(OPT.bar_dv(3,1:GEOM.n_bar)), ...
                          OPT.dv(OPT.bar_dv(2,1:GEOM.n_bar)) - OPT.dv(OPT.bar_dv(4,1:GEOM.n_bar))]./l_b;

        DT45_Dx_1b = T45_over_As  * 2 * pi * alpha_b .* r_b .* l_unitvector_b; 
        DT45_Dx_2b = -T45_over_As  * 2 * pi * alpha_b .* r_b .* l_unitvector_b;
        DT45_Dalpha_b = T45_over_As  * 2 * pi * l_b .* r_b;
        DT45_Dr_b = T45_over_As  * 2 * pi * alpha_b .* l_b;


        DT45_Ddv = zeros(size(OPT.dv));

        for b = 1:GEOM.n_bar
            DT45_Ddv(OPT.bar_dv(:,b),1) = DT45_Ddv(OPT.bar_dv(:,b),1) + ...
                [ DT45_Dx_1b(b,:), ...
                  DT45_Dx_2b(b,:), ...
                  DT45_Dalpha_b(b), ...
                  DT45_Dr_b(b)]';
        end

        grad_T45 = DT45_Ddv;
    end

end