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

%% Información sobre el histograma a generar

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 1;
if campo == 0
    archivo_posiciones = '../campos_info/posiciones_chico.txt';
    archivos_datos = '../data_gen/campo_chico/heliostato';    
    archivos_imagen = '../figuras/campo_chico/histograma_anual';
elseif campo == 1
    archivo_posiciones = '../campos_info/posiciones_grande.txt';
    archivos_datos = '../data_gen/campo_grande/heliostato';    
archivos_imagen = '../figuras/campo_grande/histograma_anual';
end
heliostatos = load(archivo_posiciones, '-ascii');    % Campo chico

% desviaciones (solo un vector) asumiendo que se simuló previamente el
% campo utilizando la función simulacion_anual.m
desviaciones = [3e-3, 3e-3, 3e-3, 3e-3];
des_str = sprintf('_%1.0f', desviaciones * 1e3);

% Numero de bins del histograma
bins = 100;

%% Ahora vamos a obtener los errores de todos los helióstatos 
% A poartir de aqui se puede modificar para corrección, pero no es
% necesario tocarlo para hacer diferentes simulaciones.

E = [];
for h = 1:size(heliostatos, 1)
    load([archivos_datos, int2str(h), des_str]);
    temp = TNE(:,3:end);
    E = [E; temp]; %Todos en un solo histograma
    clear TNE TNX TNY
end

%% Graficacion de histogramas
% Teniendo E, se realiza un histograma por columna

for r = 1:5
    figure();
    hist(E(:,r), bins);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');

    %cintilla = sprintf('\\sigma_\\beta = %2.1e, \\sigma_\\gamma = %2.1e, \\sigma_\\etta = %2.1e, \\sigma_\\kappa = %2.1e',desviaciones)
    %title({'Anual error histogram'; cintilla}, 'FontSize', 22);
    title('Anual error histogram', 'FontSize', 22);

    ylabel('Frequency', 'FontSize', 22, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 22, 'FontName', 'Times New Roman')

    saveas(gcf, [archivos_imagen, int2str(r), des_str,'.fig']);
    saveas(gcf, [archivos_imagen, int2str(r), des_str,'.png']);
end

%% Prueba de hipótesis
% Prueba que 2 muestras provienen de la misma distribución
% Se utiliza la versión existente en la tlbx de statistical del test de
% Wilcoxson para n conjuntos, aunque solo lo utilizamos con 2.

% Si p-value es muy pequeño, esto sugiere que la mediana de ambas
% muestras son significativamente diferentes

tamano_muestra = 1000;
muestra1 = randsample(E(:,1), tamano_muestra);
muestra2 = randsample(E(:,2), tamano_muestra);
p = kruskalwallis([muestra1, muestra2]);

    
