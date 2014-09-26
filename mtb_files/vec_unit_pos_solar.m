function s_hat = vec_unit_pos_solar( thetaZ, gammaS )
%VEC_UNIT_POS_SOLAR Obtiene el vector unitario de posicion solar
%   s_hat = vec_unit_pos_solar( thetaZ, gammaS )
% A partir de thetaZ y gammaS se obtiene s_hat, el vector unitario de
% posicion solar (un vector de 3 elementos [s_x, s_y, s_z])
%
% s_hat es el vector que va del sol hacia el heliostato
    
    s = [-cos(gammaS) .* sin(thetaZ), sin(gammaS) .* sin(thetaZ), -cos(thetaZ)];
    
    s_hat = s ./ repmat(sqrt(sum(s.^2, 2)), 1, 3);
    
end

