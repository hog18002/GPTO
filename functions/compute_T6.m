function [T6, grad_T6] = compute_T6()

%% This function compute T6, the time of cutting and edge grinding, and 
%% grad_T6, its sensitivity. 

    global OPT GEOM
    
    alpha_b = OPT.dv(OPT.size_dv);
    r_b = OPT.dv(OPT.radius_dv);
    t = 7; % the thickness of wall of tube, need to make sure
    C6 = 1; 
    n = 1;
    
    L_b = 2 * pi * sum(r_b .* alpha_b); % cutting length 
    
    % The time of cutting and edge grinding 
    T6 = C6 * (t)^(n) * L_b;
    
%% Sensitivity of T6
    if nargout >1
        
        DT6_Dr_b = C6 * (t)^(n) * 2 * pi * alpha_b;
        DT6_Dalpha_b = C6 * (t)^(n) * 2 * pi * r_b;
        
        DT6_Ddv = zeros(size(OPT.dv));

        for b = 1:GEOM.n_bar
            DT6_Ddv(OPT.bar_dv(:,b),1) = DT6_Ddv(OPT.bar_dv(:,b),1) + ...
               [zeros(1,4), DT6_Dalpha_b(b), DT6_Dr_b(b)]';
        end

        grad_T6 = DT6_Ddv;
        
    end  
end