%% simulacion_con_correccion.m
% Realiza la simulaci�n de un campo de heli�statos un equinoccio,
% 11 d�as antes y hasta el solsticio de verano, y lo mismo para
% el solsticio de invierno, con la diferencia que, en el equinoccio
% se calculan las correcciones del valor central del seguimiento
% respecto al centro (correccion de $\hat{r}$ ).

% Julio Waissman y Camilo Arancibia, 2015

clear all
clc
close all

%% Informaci�n para realizar la simulaci�n

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
num_heliostatos = size(heliostatos, 1);

latitud = 29.03;              % Latitud para la ciudad de Hermosillo.
muestreo = 5;                 % Muestreo en minutos
T = (8*60:muestreo:16*60)';   % Vector de los tiempos en un d'ia.

% Las desviaciones_nominales son los valores nominales de la std de 
% los diferentes errores de deriva. As�, 
% desviaciones_nominales = [std_beta, std_gamma, std_epsilon, std_xi, k_beta]
% todas medidas en radianes.
%
% Si desviaciones_nominales es una matriz de (k, 5), entonces cada linea es 
% una desviacion para una simulaci�n diferente.
% desviaciones_nominales = [3e-3 3e-3 3e-3 3e-3 0];

% Las desviciones para el art�culo
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

% desviaciones_nominales = [5e-3,     5e-3,   5e-3,   5e-3, 0];
% desviaciones_nominales = [0,     10e-3,   0,   0, 0];
% desviaciones_nominales = [1.5e-3,     1.5e-3,   1.5e-3,   1.5e-3, 0];


%% Calculo propiamente dicho
% Se comenta para ver y modificar mas adelante pero para realizar
% simulaciones anuales no hay necesidad de tocar para nada este c�digo


for des_index = 1:size(desviaciones_nominales, 1)
    
    desviaciones = desviaciones_nominales(des_index, :);
    des_str = sprintf('_%1.2f', desviaciones * 1e3);
    
    % Genera el vector de tiempos de todo el a�o
    [dias, tiempo] = meshgrid(1:365, T);
    DT = [dias(:), tiempo(:)];

    % Primero calcula la trayectoria sin utilizar el error aleatorio 
    [thetaZ, gammaS] = posicion_solar(latitud, DT(:,1), DT(:,2));
    s_hat = vec_unit_pos_solar( thetaZ, gammaS );
    
    % Por cada heliostato del campo
    for h = 1:num_heliostatos

        % posicion del heliostato
        rh = heliostatos(h,:);
        
        % Orientacion del heliostato en condiciones sin deriva
        [beta, gamma, n] = orientacion_ideal(s_hat, rh/norm(rh));
            
        % Agrega los errores aleatorios por repeticion
        % errores = [f_beta, f_gamma, f_xi, epsilon, kapa]
        [errores, rotx] = calcula_errores_sim(desviaciones(1:4));
        
        
        %Agrega errores debidos al viento
        vientobeta = desviaciones(5) * (2 * rand(size(beta)) - 1);
        vientogamma = desviaciones(5) * (2 * rand(size(gamma)) - 1);
            
        % Obtiene los angulos con error a partir de los errores angulares
        betaEH = beta + vientobeta + errores(1);
        gammaEH = gamma + vientogamma + errores(2);
        xiE = zeros(size(beta)) + errores(3);

        % --- Se calcula el vector normal de error     
        nEH1 = cos(gammaEH) .* sin(betaEH) .* cos(xiE) - sin(gammaEH) .* sin(xiE);
        nEH2 = -sin(gammaEH) .* sin(betaEH) .* cos(xiE) - cos(gammaEH) .* sin(xiE);
        nEH3 = cos(betaEH) .* cos(xiE);
        nEH = [nEH1, nEH2, nEH3] * rotx';
            
        % Se calcula el error (primero el vector unitario y despues en magnitud).
        error_hat = s_hat - 2 * repmat(dot(s_hat, nEH, 2), 1, 3) .* nEH;
        desplaz = repmat(rh(1) ./ error_hat(:,1), 1, 3) .* error_hat - repmat(rh, size(error_hat,1), 1);

        % Se guarda la proyecci�n del error en E, X y Y
        % error_ang = acos(error_hat * (rh/norm(rh))');
        error_ang = acos(dot(nEH,n,2));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Ahora vamos a compensar para este heliostato
        compensacion = mean(desplaz(DT(:,1) == 80, :));

        % Modificamos nuestro objetivo, para compensar los errores
        rc = rh - compensacion;

        % Se recalcula una orientaci�n "ideal" del heli�stato compensado
        [beta, gamma, n_corr] = orientacion_ideal(s_hat, rc/norm(rc));

        % Obtiene los angulos con error a partir de los errores angulares
        % --- Esto se rehace con compensacion    
        betaEH = beta + vientobeta + errores(1);
        gammaEH = gamma + vientogamma + errores(2);
        xiE = zeros(size(beta)) + errores(3);
            
        % --- Se calcula el vector normal de error     
        nEH1 = cos(gammaEH) .* sin(betaEH) .* cos(xiE) - sin(gammaEH) .* sin(xiE);
        nEH2 = -sin(gammaEH) .* sin(betaEH) .* cos(xiE) - cos(gammaEH) .* sin(xiE);
        nEH3 = cos(betaEH) .* cos(xiE);
        nEH = [nEH1, nEH2, nEH3] * rotx';
            
        % Se calcula el error (primero el vector unitario y despues en magnitud).
        %
        % En este caso es el error respecto al objetivo real y no respecto
        % al compensado.
        error_hat = s_hat - 2 * repmat(dot(s_hat, nEH, 2), 1, 3) .* nEH;
        desplazC = repmat(rh(1) ./ error_hat(:,1), 1, 3) .* error_hat - repmat(rh, size(error_hat,1), 1);

        % Se guarda la proyecci�n del error en E, X y Y
        % error_angC = acos(error_hat * (rh/norm(rh))');
        error_angC = acos(dot(nEH, n,2));
        
        save([archivos_salida, int2str(h), des_str, '.mat'], ...
            'DT', 'error_ang', 'error_angC', ...
            'desplaz', 'desplazC', 'errores', 'compensacion',...
            'vientobeta', 'vientogamma');
    end
end