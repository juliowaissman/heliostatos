%% tabla_weibull.m
% Genera la tabla de parámetros de weibul y de pruebas de hipótesis para
% analizar si una distribución es weibull o no, y en que grado.

% Se supone que ya se simularon todos los casos con 
%      `simulacion_con_correccion.m`
%

clc
close all
clear all
disp('Empieza el script tabla_weibull.m');

%% Especificación de datos para leer los archivos

archivo_posiciones = '../campos_info/posiciones_grande.txt';
archivos_datos = '../data_gen/campo_grande/heliostato';    
heliostatos = load(archivo_posiciones, '-ascii');    

% desviaciones_nominales = [0.5e-3, 0.5e-3, 0.5e-3, 0.5e-3, 0; ...
%                           1.5e-3, 1.5e-3, 1.5e-3, 1.5e-3, 0; ...
%                           2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 0; ...
%                           5e-3,     5e-3,   5e-3,   5e-3, 0; ...
%                           1e-3,        0,      0,      0, 0; ...
%                           3e-3,        0,      0,      0, 0; ...
%                           5e-3,        0,      0,      0, 0; ...
%                          10e-3,        0,      0,      0, 0; ...
%                              0,     1e-3,      0,      0, 0; ...
%                              0,     3e-3,      0,      0, 0; ...
%                              0,     5e-3,      0,      0, 0; ...
%                              0,    10e-3,      0,      0, 0; ...
%                              0,        0,   1e-3,      0, 0; ...
%                              0,        0,   3e-3,      0, 0; ...
%                              0,        0,   5e-3,      0, 0; ...
%                              0,        0,  10e-3,      0, 0; ...
%                              0,        0,      0,   1e-3, 0; ...
%                              0,        0,      0,   3e-3, 0; ...
%                              0,        0,      0,   5e-3, 0; ...
%                              0,        0,      0,  10e-3, 0];
                         
desviaciones_nominales = [2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 0.5e-3; ...
                          5e-3,        0,      0,      0, 0.5e-3; ...
                             0,     5e-3,      0,      0, 0.5e-3; ...
                             0,        0,   5e-3,      0, 0.5e-3; ...
                             0,        0,      0,   5e-3, 0.5e-3; ...
                          2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3; ...
                          5e-3,        0,      0,      0, 2.5e-3; ...
                             0,     5e-3,      0,      0, 2.5e-3; ...
                             0,        0,   5e-3,      0, 2.5e-3; ...
                             0,        0,      0,   5e-3, 2.5e-3; ...
                          2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 5e-3; ...
                          5e-3,        0,      0,      0, 5e-3; ...
                             0,     5e-3,      0,      0, 5e-3; ...
                             0,        0,   5e-3,      0, 5e-3; ...
                             0,        0,      0,   5e-3, 5e-3];

bins = 50;                         
tabla = zeros(size(heliostatos, 1), 36);
%% Ejecuta el script

for des_index = 1:size(desviaciones_nominales, 1)    

    desviaciones = desviaciones_nominales(des_index, :);
    des_str = sprintf('_%1.2f', desviaciones * 1e3);

    % Inicializa los vectores de error
    E_total = [];
    E_primavera = [];
    E_verano = [];
    E_invierno = [];

    E_totalC = [];
    E_primaveraC = [];
    E_veranoC = [];
    E_inviernoC = [];
    
    for h = 1:size(heliostatos, 1)
        load([archivos_datos, int2str(h), des_str, '.mat']);
        
        E_total = [E_total; error_ang];
        E_totalC = [E_totalC; error_angC];        
        
        ind = find(DT(:,1) == 80);
        E_primavera = [E_primavera; error_ang(ind)];
        E_primaveraC = [E_primaveraC; error_angC(ind)];
        
        ind = find(DT(:,1) >= 172 - 11 & DT(:,1) <= 172);
        E_verano = [E_verano; error_ang(ind)];
        E_veranoC = [E_veranoC; error_angC(ind)];
         
        ind = find(DT(:,1) >= 355 - 11 & DT(:,1) <= 355);
        E_invierno = [E_invierno; error_ang(ind)];
        E_inviernoC = [E_inviernoC; error_angC(ind)];
        
    end
    E_total = E_total(E_total > 0);
    E_totalC = E_totalC(E_totalC > 0);

    E_primavera = E_primavera(E_primavera > 0);
    E_primaveraC = E_primaveraC(E_primaveraC > 0);

    E_verano = E_verano(E_verano > 0);
    E_veranoC = E_veranoC(E_veranoC > 0);

    E_invierno = E_invierno(E_invierno > 0);
    E_inviernoC = E_inviernoC(E_inviernoC > 0);

    
    [ht, pt] = varias_muestras(E_total(1:12:end), 500, 10, bins);
    [htC, ptC] = varias_muestras(E_totalC(1:12:end), 500, 10, bins);
    par_t = wblfit(E_total(E_total > 0));
    par_tC = wblfit(E_totalC(E_totalC > 0));
    
    [hp, pp] = varias_muestras(E_primavera(1:12:end), 500, 10, bins);
    [hpC, ppC] = varias_muestras(E_primaveraC(1:12:end), 500, 10, bins);
    par_p = wblfit(E_primavera(E_primavera > 0));
    par_pC = wblfit(E_primaveraC(E_primaveraC > 0));
    
    [hv, pv] = varias_muestras(E_verano(1:12:end), 500, 10, bins);
    [hvC, pvC] = varias_muestras(E_veranoC(1:12:end), 500, 10, bins);
    par_v = wblfit(E_verano(E_verano > 0));
    par_vC = wblfit(E_veranoC(E_veranoC > 0));
    
    [hi, pi] = varias_muestras(E_invierno(1:12:end), 500, 10, bins);
    [hiC, piC] = varias_muestras(E_inviernoC(1:12:end), 500, 10, bins);
    par_i = wblfit(E_invierno(E_invierno > 0));
    par_iC = wblfit(E_inviernoC(E_inviernoC > 0));
    
    tabla(des_index, :) = [desviaciones_nominales(des_index, 1:4), ...
                           ht, pt, par_t, hp, pp, par_p, ...
                           hv, pv, par_v, hi, pi, par_i, ...
                           htC, ptC, par_tC, hpC, ppC, par_pC, ...
                           hvC, pvC, par_vC, hiC, piC, par_iC, ...
                          ];
end

%% Escribe la tabla en una hoja de excell
% Todavía no se usar bien esto, así que no le puse los encabezados
% los cuales en realidad son:
% 
% std_beta, std_gamma, std_epsilon, std_xi, h_total, p_total, lambda_total,
% k_total, h_primavera, p_primavera, lambda_primavera, k_primavera, 
% h_verano, p_verano, lambda_verano, k_verano, h_invierno, p_invierno, 
% lambda_invierno, k_invierno, 
% 

%xlswrite('tabla_parametros.xlsx', tabla);


    
