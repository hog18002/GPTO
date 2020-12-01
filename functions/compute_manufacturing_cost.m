function [f,grad_f] = compute_manufacturing_cost()
    
    global OPT 
    
    [T1, grad_T1, K_m, grad_K_m] = compute_T1(); % K_m is the mass of frame.
    [T23, grad_T23] = compute_T23();
    [T45, grad_T45] = compute_T45();
    [T6, grad_T6] = compute_T6();
    
    % Compute manufacturing cost 

    f = log(K_m + T1 + T23 + T45 + T6 + 1); % Manufacturing cost
    
    grad_f = (grad_K_m + grad_T1 + grad_T23 + grad_T45 + grad_T6)/...
             (K_m + T1 + T23 + T45 + T6 +1);

    % Save these values in the OPT structure
    OPT.manufacturing_cost = f;
    OPT.grad_manufacturing_cost = grad_f;
    
end

