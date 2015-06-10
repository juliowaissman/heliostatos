%% histogramas_anuales_weibull.m
% Realiza un histograma (de la primer repetición del archivo
% con los datos por cada temporada (verano, invierno, primavera)
% sin contemplar la otra temporada de quinoxio al ser muy similares.
clear all
close all
clc

%% Carga los datos necesarios para realizar y guardar los histogramas

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 1;
if campo == 0
    archivo_posiciones = '../campos_info/posiciones_chico.txt';
    archivos_datos = '../data_gen/campo_chico/compensado_heliostato';    
    archivos_imagen = '../figuras/campo_chico/histograma_';
elseif campo == 1
    archivo_posiciones = '../campos_info/posiciones_grande.txt';
    archivos_datos = '../data_gen/campo_grande/compensado_heliostato';    
    archivos_imagen = '../figuras/campo_grande/histograma_';
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
                         
% desviaciones_nominales = [5e-3,     5e-3,   5e-3,   5e-3; ...
%                          10e-3,        0,      0,      0; ...
%                              0,    10e-3,      0,      0; ...
%                              0,        0,  10e-3,      0; ...
%                              0,        0,      0,  10e-3];
                         
%desviaciones_nominales = [5e-3,     5e-3,   5e-3,   5e-3];
% desviaciones_nominales = [0,     10e-3,   0,   0];

% Numero de bins del histograma
bins = 50;

%% Realiza los histogramas por periodo de tiempo y calcula el ajuste para una weibull

resumen = [];

for des_index = 1:size(desviaciones_nominales, 1)
    
    desviaciones = desviaciones_nominales(des_index, :);
    des_str = sprintf('_%1.1f', desviaciones * 1e3);

    % Obtiene el vector de error
    E = [];
    Ecomp = [];

    for h = 1:size(heliostatos, 1)
        load([archivos_datos, int2str(h), des_str, '.mat']);        
        E = [E; error_ang];      
        Ecomp = [Ecomp; error_angC];
    end

    err_str = sprintf('\\beta = %1.2g, \\gamma = %1.2g, \\epsilon = %1.2g, \\xi = %1.2g, ', ...
                      desviaciones(1), desviaciones(2), desviaciones(3), desviaciones(4)) ;

    [h0s, p_media] = varias_muestras(E(1:12:end), 500, 10, bins);
    weibull_str = sprintf('p = %0.3f, h0s = %d', p_media, h0s); 
    params_wbl = wblfit(E);
    resumen = [resumen; [0, desviaciones, params_wbl, p_media, h0s]];
    
    figure();
    histfit(E, bins,'Weibull');
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
    title(['\fontsize{12}', 'Anual ', err_str, weibull_str]);
    ylabel('Frequency', 'FontSize', 18, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 18, 'FontName', 'Times New Roman')
    saveas(gcf, [archivos_imagen, 'anual_por_hora_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'anual_por_hora_', des_str,'.png']);

    
    [h0s, p_media] = varias_muestras(Ecomp(1:12:end), 500, 10, bins);
    weibull_str = sprintf('p = %0.3f, h0s = %d', p_media, h0s); 
    params_wbl = wblfit(Ecomp(Ecomp > 0));
    resumen = [resumen; [0, desviaciones, params_wbl, p_media, h0s]];
    
    figure();
    histfit(Ecomp(Ecomp > 0), bins,'Weibull');
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
    title(['\fontsize{12}', 'Spring', err_str, weibull_str]);
    ylabel('Frequency', 'FontSize', 18, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 18, 'FontName', 'Times New Roman')
    saveas(gcf, [archivos_imagen, 'anual_por_hora_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'anual_por_horaC_', des_str,'.png']);
    
end
