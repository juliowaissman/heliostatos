function [beta, gamma, n_hat] = orientacion_ideal(s_hat, r_hat)
% ORIENTACION_IDEAL orientacion de un heliostato
%
%   [beta, gamma] = orientacion_ideal()
% Calcula la orientacion de un rayo conociendo la posicion del sol, a
% partir de s_hat = [s_x, s_y, s_z] y r_hat = [r_x, r_y, r_z]
% n_hat es el vector normal del plano del heliostato


    n = -s_hat + repmat(r_hat, size(s_hat,1), 1);
    n_hat = n ./ repmat(sqrt(sum(n.^2, 2)), 1, 3);
    
    beta = acos(n_hat(:,3));
    gamma = atan2(-n_hat(:,2), n_hat(:,1));
    
end




