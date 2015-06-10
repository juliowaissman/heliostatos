%% calcula_compensacion.m
% Calcula los valores de compensación para un campo de 
% Helióstatos basado en el error promedio un día de equinoccio.
%
% Guarda el archivo de vectores de comensación en el archivo
%             ../data_gen/compensacion/grande_[desviaciones].mat
%

clear all
close all
clc

%% Carga los datos necesarios para realizar y guardar los histogramas

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 1;
if campo == 0
    archivo_posiciones = '../campos_info/posiciones_chico.txt';
    archivos_datos = '../data_gen/campo_chico/heliostato';    
    archivos_comp = '../data_gen/compensacion/chico_';
elseif campo == 1
    archivo_posiciones = '../campos_info/posiciones_grande.txt';
    archivos_datos = '../data_gen/campo_grande/heliostato';    
    archivos_comp = '../data_gen/compensacion/grande_';
end
heliostatos = load(archivo_posiciones, '-ascii');    

% desviaciones asumiendo que se simuló previamente el
% campo utilizando la función simulacion_anual.m
desviaciones_nominales = [0.5e-3, 0.5e-3, 0.5e-3, 0.5e-3; ...
                          1.5e-3, 1.5e-3, 1.5e-3, 1.5e-3; ...
                          2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3; ...
                          5e-3,     5e-3,   5e-3,   5e-3; ...
                          1e-3,        0,      0,      0; ...
                          3e-3,        0,      0,      0; ...
                          5e-3,        0,      0,      0; ...
                         10e-3,        0,      0,      0; ...
                             0,     1e-3,      0,      0; ...
                             0,     3e-3,      0,      0; ...
                             0,     5e-3,      0,      0; ...
                             0,    10e-3,      0,      0; ...
                             0,        0,   1e-3,      0; ...
                             0,        0,   3e-3,      0; ...
                             0,        0,   5e-3,      0; ...
                             0,        0,  10e-3,      0; ...
                             0,        0,      0,   1e-3; ...
                             0,        0,      0,   3e-3; ...
                             0,        0,      0,   5e-3; ...
                             0,        0,      0,  10e-3];
                 
%% Calcula el vector de compensación por cada desviación

for des_index = 1:size(desviaciones_nominales, 1)
    
    compensaciones = zeros(size(heliostatos));
    
    desviaciones = desviaciones_nominales(des_index, :);
    des_str = sprintf('_%1.1f', desviaciones * 1e3);

    for h = 1:size(heliostatos, 1)
        load([archivos_datos, int2str(h), des_str, '.mat']);
        
        compensaciones(h, 2) = mean(TNX(TNX(:,1) == 80, 3));
        compensaciones(h, 3) = -mean(TNY(TNY(:,1) == 80, 3));
    end
    save([archivos_comp, des_str,'.mat'], 'compensaciones');
end
