function [errores, rotx] = calcula_errores_sim(desviaciones)
%CALCULA_ERRORES_SIM calcula los errores para la simulacion de heliostatos
%   desviaciones(1) = std de $\beta$
%   desviaciones(2) = std de $\gamma$
%   desviaciones(3) = std de $\epsilon$
%   desviaciones(4) = std de $\xi$

    errores = [0,0,0,0,0];

    % Calcula los valores de error 
    % en forma matricial, para todas las repeticiones de un jalon
    errores(1) = desviaciones(1) * randn();  
    errores(2) = desviaciones(2) * randn(); 
    errores(3) = desviaciones(4) * randn(); 

    % Calcula tantos errores como repeticiones para los errores
    % kappa y epsilon
    if desviaciones(3) == 0
        errores(4) = 0;
        errores(5) = 0;
    else
        errores(4) = sqrt(-2*desviaciones(3)^2 * log(1-rand()));
        errores(5) = 2*pi*rand();
    end
    
    % Los errores de kappa y epsion se aplican utilizando una matriz
    % rotacional, 
    se = sin(errores(4));
    ce = cos(errores(4));
sk = sin(errores(5));
    ck = cos(errores(5));
    rotx = [  ce * ck^2 + sk^2,   (-ce + 1) * ck * sk,  se * ck;...
            (1 - ce) * ck * sk,      ce * sk^2 + ck^2, -se * sk;...
                        -se*ck,               se * sk,       ce];

end

