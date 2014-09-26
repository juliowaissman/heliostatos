%% hitogramas_anuales.m
% Genera las gráficas de histogramas anuales y realiza la prueba de
% hipótesis para afirmar o rechazar si la distribución de los datos de las
% primeras dos repeticiones provienen de la misma distribución.
%
% Se asume que el campo ya se encuentra simulado

% Julio Waissman, Luis Díaz y Camilo Arancibia, 2014

clear all
close all
clc

%% Información sobre el archivo a abrir

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 0;
if campo == 0
    archivos_datos = '../data_gen/campo_chico/heliostato';    
    archivos_imagen = '../figuras/campo_chico/histograma_anual';
elseif campo == 1
    archivos_datos = '../data_gen/campo_grande/heliostato';    
    archivos_imagen = '../figuras/campo_grande/histograma_anual';
end
heliostatos = load(archivo_posiciones, '-ascii');    % Campo chico

% desviaciones (solo un vector) asumiendo que se simuló previamente el
% campo utilizando la función simulacion_anual.m
desviaciones = [3e-3, 3e-3, 3e-3, 3e-3];
des_str = sprintf('_%1.0f', desviaciones_nominales * 1e3);
        

%% Ahora vamos a obtener los errores de todos los helióstatos 

E = [];
for h = 1:size(heliostatos, 1)
    load([archivos_datos, int2str(h), des_str]);
    temp = TNE(:,3:end);
    E = [E; temp]; %Todos en un solo histograma
    clear TNE TNX TNY
end

%% Graficacion de histogramas
% Teniendo E, se realiza un histograma por columna

for r = 1:size(E, 2)
    figure();
    hist(E(:,r), d);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');

    title(['\fontsize{22}', ' Temporada: ',casos{caso},'\newline Desviaciones: ',texto{desviaciones}]);

    ylabel('Frequency', 'FontSize', 22, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 22, 'FontName', 'Times New Roman')

    saveas(gcf, [archivos_imagen, int2str(r), des_str,'.fig']);
    saveas(gcf, [archivos_imagen, int2str(r), des_str,'.png']);
end

%% Prueba de hipótesis
% Prueba que 2 muestras provienen de la misma distribución
[h,p,stats] = ansaribradley(E(:,1), E(:,2))

    
