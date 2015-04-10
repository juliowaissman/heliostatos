%% simulacion_anual.m
% Realiza la simulación de un campo de helióstatos por un año, asumiendo
% unos errores de deriva modelados por las desviaciones estandard de los
% diferentes posibles errores (en pedestal y canteo)

% Julio Waissman, Luis Díaz y Camilo Arancibia, 2014

clear all
clc
close all

%% Información para realizar la simulación

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 1;
if campo == 0
    archivo_posiciones = '../campos_info/posiciones_chico.txt';
    archivos_salida = '../data_gen/campo_chico/heliostato';    
elseif campo == 1
    archivo_posiciones = '../campos_info/posiciones_grande.txt';
    archivos_salida = '../data_gen/campo_grande/heliostato';    
end
heliostatos = load(archivo_posiciones, '-ascii');    % Campo chico

% Numero de repeticiones a realizar en la simulación (por si vamos a hacer
% montecarlo a la fuerza bruta).
repeticiones = 1;

latitud = 29.03;              % Latitud para la ciudad de Hermosillo.
muestreo = 5;                 % Muestreo en minutos
T = (8*60:muestreo:16*60)';   % Vector de los tiempos en un d'ia.

% Las desviaciones_nominales son los valores nominales de la std de 
% los diferentes errores de deriva. Así, 
% desviaciones_nominales = [std_beta, std_gamma, std_epsilon, std_xi]
% todas medidas en radianes.
%
% Si desviaciones_nominales es una matriz de (k, 4), entonces cada linea es 
% una desviacion para una simulación diferente.
% desviaciones_nominales = [3e-3 3e-3 3e-3 3e-3];

% Las desviciones para el artículo
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

%% Calculo propiamente dicho
% Se comenta para ver y modificar mas adelante pero para realizar
% simulaciones anuales no hay necesidad de tocar para nada este código


for desviaciones = 1:size(desviaciones_nominales,1)
    
    % Genera el vector de tiempos de todo el año
    [dias, tiempo] = meshgrid(1:365, T);
    
    % Carga el valor de las desviaciones estandar de los errores de deriva
    std_beta = desviaciones_nominales(desviaciones, 1);
    std_gamma = desviaciones_nominales(desviaciones, 2);
    std_epsilon = desviaciones_nominales(desviaciones, 3);
    std_xi = desviaciones_nominales(desviaciones, 4);
    
    % Por cada heliostato del campo
    for h = 1:size(heliostatos, 1)
        % posicion del heliostato
        r = heliostatos(h,:);
            
        % Crea una matrices de valores para guardar los errores 
        % donde TNE es el error angular, TNX respecto al eje x, 
        % y TNY respecto al eje Y (de acuerdo al modelo)
        % TN* tiene una primer columna con el dia del año,
        % una segunda columna con la hora, y las siguientes columnas
        % son los errores respecto a la operación sin error de deriva
        % tantas repeticiones como se han determinado.
        TNE = [dias(:), tiempo(:), zeros(length(dias(:)), repeticiones)];
        TNX = [dias(:), tiempo(:), zeros(length(dias(:)), repeticiones)];
        TNY = [dias(:), tiempo(:), zeros(length(dias(:)), repeticiones)];
            
            
        % Primero calcula la trayectoria sin utilizar el error aleatorio 
        [thetaZ, gammaS] = posicion_solar(latitud, dias(:), tiempo(:));
        s_hat = vec_unit_pos_solar( thetaZ, gammaS );
        [beta, gamma, n] = orientacion_ideal(s_hat, r/norm(r));
            
            
        % Agrega los errores aleatorios por repeticion
            
        % Calcula los valores de error 
        % en forma matricial, para todas las repeticiones de un jalon
        f_beta = std_beta * randn(repeticiones,1);  
        f_gamma = std_gamma * randn(repeticiones,1); 
        f_xi = std_xi * randn(repeticiones,1); 
            
        % Calcula tantos errores como repeticiones para los errores
        % kappa y epsilon
        if std_epsilon == 0
            kapa = zeros(repeticiones, 1);
            epsilon = zeros(repeticiones,1);
        else
            Sigma = [std_epsilon^2 0; 0 std_epsilon^2];
            R = chol(Sigma);
            z = randn(repeticiones,2)*R;
            [kapa, epsilon]=cart2pol(z(:,1), z(:,2));
        end
        errores = [f_beta, f_gamma, epsilon, kapa];
            
        % Obtiene los angulos con error a partir de los errores angulares
            
        gammaEH = bsxfun(@plus, gamma, f_gamma');
        betaEH = bsxfun(@plus, beta, f_beta');
        xiE = bsxfun(@plus, zeros(size(beta)), f_xi');
            
        nEH1 = cos(gammaEH) .* sin(betaEH) .* cos(xiE) - sin(gammaEH) .* sin(xiE);
        nEH2 = -sin(gammaEH) .* sin(betaEH) .* cos(xiE) - cos(gammaEH) .* sin(xiE);
        nEH3 = cos(betaEH) .* cos(xiE);

        % Los errores de kappa y epsion se aplican utilizando una matriz
        % rotacional, por lo que hay que hacerlo repeticion por repeticion,
        % en lugar de calcularlo en forma matricial.
        for i = 1:repeticiones
            se = sin(epsilon(i));
            ce = cos(epsilon(i));
            sk = sin(kapa(i));
            ck = cos(kapa(i));
                
            rotx = [  ce * ck^2 + sk^2,   (-ce + 1) * ck * sk,  se * ck;...
                    (1 - ce) * ck * sk,      ce * sk^2 + ck^2, -se * sk;...
                                -se*ck,               se * sk,       ce];
            
            % Se calcula el vector normal de error
            nEH = [nEH1(:,i), nEH2(:,i), nEH3(:,i)] * rotx';
            
            % Se calcula el error (primero el vector unitario y despues en
            % magnitud).
            error_hat = s_hat - 2 * repmat(dot(s_hat, nEH, 2), 1, 3) .* nEH;
            r_error = repmat(r(1) ./ error_hat(:,1), 1, 3) .* error_hat - repmat(r, size(error_hat,1), 1);
            
            % Se guarda la proyección del error en E, X y Y
            TNE(:,i+2) = acos(dot(repmat(r/norm(r),size(error_hat,1),1), error_hat, 2)); % <-------- Cuidado
            TNX(:,i+2) = -r_error(:,2);
            TNY(:,i+2) = r_error(:,3);
        end
        % Se guarda el archivo de simulación de este helióstato
        des_str = sprintf('_%1.1f', desviaciones_nominales(desviaciones, :) * 1e3);
        save([archivos_salida, int2str(h), des_str, '.mat'], 'TNE', 'TNX', 'TNY');
    end
end