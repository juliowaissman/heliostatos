%% Genera datos para calcular histogramas y pruebas de hipotesis 
% Con el fin de usarlo en el estudio de las diferentes posibles
% distribuciones y la manera en que podemos ajustarlas.

clear all
close all
clc
disp('Extrayendo un conjunto de datos chido para el analisis');

%% Informacion de los archivos a utilizar

archivo_posiciones = '../campos_info/posiciones_grande.txt';
archivos_datos = '../data_gen/campo_grande/heliostato';    
archivo_salida = '../data_gen/errores/errores_';

heliostatos = load(archivo_posiciones, '-ascii');    

desviaciones_nominales = [0.5e-3, 0.5e-3, 0.5e-3, 0.5e-3, 0; ...
                          1.5e-3, 1.5e-3, 1.5e-3, 1.5e-3, 0; ...
                          2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 0; ...
                          5e-3,     5e-3,   5e-3,   5e-3, 0; ...
                          1e-3,        0,      0,      0, 0; ...
                          3e-3,        0,      0,      0, 0; ...
                          5e-3,        0,      0,      0, 0; ...
                         10e-3,        0,      0,      0, 0; ...
                             0,     1e-3,      0,      0, 0; ...
                             0,     3e-3,      0,      0, 0; ...
                             0,     5e-3,      0,      0, 0; ...
                             0,    10e-3,      0,      0, 0; ...
                             0,        0,   1e-3,      0, 0; ...
                             0,        0,   3e-3,      0, 0; ...
                             0,        0,   5e-3,      0, 0; ...
                             0,        0,  10e-3,      0, 0; ...
                             0,        0,      0,   1e-3, 0; ...
                             0,        0,      0,   3e-3, 0; ...
                             0,        0,      0,   5e-3, 0; ...
                             0,        0,      0,  10e-3, 0];

%% Genera los vectores de datos de error de posicion con y sin compensación

for d = 1:size(desviaciones_nominales, 1)
    
    des_str = sprintf('_%1.2f', desviaciones_nominales(d, :) * 1e3);

    E = [];
    EC = [];

    E_primavera = [];
    E_verano = [];
    E_invierno = [];

    E_primaveraC = [];
    E_veranoC = [];
    E_inviernoC = [];

    for h = 1:size(heliostatos, 1)
        load([archivos_datos, int2str(h), des_str, '.mat']);

        E = [E, error_ang(1:6:end)];
        EC = [EC, error_angC(1:6:end)];

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
    E = E(E > 0);
    EC = EC(EC > 0);
    E_primavera = E_primavera(E_primavera > 0);
    E_primaveraC = E_primaveraC(E_primaveraC > 0);
    E_verano = E_verano(E_verano > 0);
    E_veranoC = E_veranoC(E_veranoC > 0);
    E_invierno = E_invierno(E_invierno > 0);
    E_inviernoC = E_inviernoC(E_inviernoC > 0);

    
    save([archivo_salida, des_str, '.mat'],...
        'E', 'EC', ...
        'E_primavera', 'E_primaveraC', ...
        'E_verano', 'E_veranoC', ...
        'E_invierno', 'E_inviernoC');
end

                 