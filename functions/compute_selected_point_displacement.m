function [selected_disp, grad_selected_disp] = compute_selected_point_displacement()
% Compute the displacement of a selected point and its sensitivity of the 
% structure(cantilever beam 2D)
    
    global FE OPT 

% compute the displacement in the whole structure
    position = FE.BC.force_node * FE.BC.force_dof; % the dof where the load set
    c = zeros(FE.n_global_dof,1); % choose a dof
    c(position) = -1; 
    selected_disp = c .* FE.U; % selected_disp = sum(c .* FE.U)???
    selected_disp = selected_disp(position); 
    
% save these values in the OPT structure
    OPT.selected_disp = selected_disp;

if nargout > 1   
% compute the design sensitivity
    Ke = FE.Ke;
    Ue = permute(repmat(...
            FE.U(FE.edofMat).',...
            [1,1,FE.n_edof]), [1,3,2]);    
% solve adjoint vector       
    if strcmpi(FE.analysis.solver.type, 'direct')
        % Direct compute the adjoint vector  
        adjoint_vector = zeros(FE.n_global_dof,1); 
        adjoint_vector(FE.freedofs_ind) = - FE.Kff\(c(FE.freedofs_ind)); 

    elseif strcmpi(FE.analysis.solver.type, 'iterative')    
        % iterative: pcg
        adjoint_vector = zeros(FE.n_global_dof,1);
        adjoint_vector(FE.freedofs_ind) = pcg(FE.Kff, -c(FE.freedofs_ind), FE.analysis.solver.tol, 10000);
        
    elseif strcmpi(FE.analysis.solver.type, 'cholesky')
        % Cholesky factorization to solve the adjoint vector
        adjoint_vector = zeros(FE.n_global_dof,1);
        y = - FE.L'\(c(FE.freedofs_ind));
        adjoint_vector(FE.freedofs_ind) = FE.L\y;
        

    end

% solve the adjoint problem
    Lambda_e = permute(repmat(...
        adjoint_vector(FE.edofMat).',...
            [1,1,FE.n_edof]), [1,3,2]);
        
    Lambda_e_trans = permute(Lambda_e, [2,1,3]);
    
    Dselected_disp_Dpenalized_elem_dens = reshape(sum(sum( ...
        Lambda_e_trans.*Ke.*Ue, ...
            1),2),[1,FE.n_elem]);
                                           
    Dselected_disp_Ddv = (Dselected_disp_Dpenalized_elem_dens * OPT.Dpenalized_elem_dens_Ddv);
    
    grad_selected_disp = Dselected_disp_Ddv.'; 
    
% save these values in the OPT structure
    OPT.grad_selected_disp = grad_selected_disp;
end

end