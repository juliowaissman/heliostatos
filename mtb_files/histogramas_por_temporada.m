%% histogramas_por_temporada.m
% Realiza un histograma (de la primer repetición del archivo
% con los datos por cada temporada (verano, invierno, primavera)
% sin contemplar la otra temporada de quinoxio al ser muy similares.
clear all
close all
clc

%% Carga los datos necesarios para realizar y guardar los histogramas

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 0;
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
bins = 50;

% Información de las temporada
nombres = ['spring', 'summer', 'winter'];
dias = [80, 172 355];
lapso_izq = 45;
lapso_der = 45;

%% Obtiene los vectores de error

E_primavera = [];
E_verano = [];
E_invierno[];

for h = 1:size(heliostatos, 1)
    %load(['Anual_rep_', int2str(repeticiones), '_heliostato_', int2str(h), '_chico']);
    load([nombre,',_caso=',casos{caso},',_desviacion=',texto{desviaciones}, ',_heliostato=', int2str(h)]);
    temp = TNE(:,3:end);
    E_primavera = [E_primavera; temp(:, 1)];
    E_verano = [E_verano; temp(:, 2)];
    E_invierno = [E_invierno; temp(:, 3)];
    clear TNE TNX TNY        
end

%% Realiza las gráficas

figure();
histfit(E1, d);
set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
title(['\fontsize{22}', ' Temporada: ',casos{caso},'\newline Desviaciones: ',texto{desviaciones}]);
ylabel('Frequency', 'FontSize', 22, 'FontName', 'Times New Roman');
xlabel('\theta (rad)', 'FontSize', 22, 'FontName', 'Times New Roman')
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_1.fig']);
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_1.png']);

figure();
histfit(E2, d);
set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
title(['\fontsize{22}', ' Temporada: ',casos{caso},'\newline Desviaciones: ',texto{desviaciones}]);
ylabel('Frequency', 'FontSize', 22, 'FontName', 'Times New Roman');
xlabel('\theta (rad)', 'FontSize', 22, 'FontName', 'Times New Roman')
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_2.fig']);
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_2.png']);

figure();
histfit(E3, d);
set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
title(['\fontsize{22}', ' Temporada: ',casos{caso},'\newline Desviaciones: ',texto{desviaciones}]);
ylabel('Frequency', 'FontSize', 22, 'FontName', 'Times New Roman');
xlabel('\theta (rad)', 'FontSize', 22, 'FontName', 'Times New Roman')
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_3.fig']);
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_3.png']);

figure();
histfit(E4, d);
set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
title(['\fontsize{22}', ' Temporada: ',casos{caso},'\newline Desviaciones: ',texto{desviaciones}]);
ylabel('Frequency', 'FontSize', 22, 'FontName', 'Times New Roman');
xlabel('\theta (rad)', 'FontSize', 22, 'FontName', 'Times New Roman')
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_4.fig']);
saveas(gcf, [nombre,'_repeticiones=',int2str(repeticiones),'_bins=',int2str(d),',_caso=',casos{caso},',_desviacion=', texto{desviaciones}, ',_heliostatos=', int2str(h),',_campo_grande_4.png']);
