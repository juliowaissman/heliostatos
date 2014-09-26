clear all
close all
clc
% dfittool <--- Comando para ajustar distribuciones
% heliostatos = load('posiciones.txt', '-ascii');
heliostatos = xlsread('posiciones.xls');
d = 50;
caso = 1;
nombre = 'heliostato=todos';
%texto = {'0,0,0,3', '0,0,3,0', '0,3,0,0','3,0,0,0'};
%texto = {'3,3,3,3', '05,05,05,3', '05,05,3,05', '05,3,05,05','3,05,05,05'};
texto = {'3,3,3,3', '3,3,3,3', '3,3,3,3', '3,3,3,3','3,3,3,3'};

desviaciones_nominales = [3e-3 3e-3 3e-3 3e-3];

% desviaciones_nominales = [0    0    0    3e-3];


% desviaciones_nominales = [0    0    0    3e-3;...
%                           0    0    3e-3 0   ;...
%                           0    3e-3 0    0   ;...
%                           3e-3 0    0    0];

casos = {'primavera','verano','invierno'};
E1 = [];
E2 = [];
E3 = [];
E4 = [];
repeticiones = 4;
for desviaciones = 1:size(desviaciones_nominales,1)
    for h = 1:size(heliostatos, 1)
        %load(['Anual_rep_', int2str(repeticiones), '_heliostato_', int2str(h), '_chico']);
        load([nombre,',_caso=',casos{caso},',_desviacion=',texto{desviaciones}, ',_heliostato=', int2str(h)]);
        temp = TNE(:,3:end);
        E1 = [E1; temp(:, 1)];
        E2 = [E2; temp(:, 2)];
        E3 = [E3; temp(:, 3)];
        E4 = [E4; temp(:, 4)];
        clear TNE TNX TNY
        
    end
end

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
