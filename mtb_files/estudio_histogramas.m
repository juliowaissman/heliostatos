%% Estudio sobre la función de distribución gamma inversa
%
% Para esto solo vamos a cargar los datos de un solo día (primavera) y los
% vamos a utilizar para ver como se ve una weibull, una gamma y una gamma
% inversa, a ver si resulta en algo que sea interesante.
clear all
close all
clc
disp('Haciendo grafiquitas');


archivo = '../data_gen/errores/errores_';
archivos_imagen = '../figuras/histo_';

desviaciones_nominales = [...
                             2.5e-3,    2.5e-3,  2.5e-3,  2.5e-3,       0; ...
                             2.5e-3,    2.5e-3,  2.5e-3,  2.5e-3,  0.5e-3; ...
                             2.5e-3,    2.5e-3,  2.5e-3,  2.5e-3,   2.5e-3; ...
                             2.5e-3,    2.5e-3,  2.5e-3,  2.5e-3,    5e-3];

nbins = 25;

for d = 1:size(desviaciones_nominales, 1)    
    % Cargando datos
    des_str = sprintf('_%1.2f', desviaciones_nominales(d, :) * 1e3);
    E = [];
    EC = [];
    load([archivo, des_str, '.mat']);
    
    titulo = sprintf('Todos = %1.2f, K = %1.2f, ', ...
                      desviaciones_nominales(d, 4) * 1e3, ...
                      desviaciones_nominales(d, 5) * 1e3);


    figure();
    histfit(E, nbins, 'weibull');
    title(['Weibull ', titulo]);
    saveas(gcf, [archivos_imagen, 'weibull_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'weibull_', des_str,'.png']);

    
    figure();
    histfit(E, nbins, 'rayleigh');
    title(['Rayleigh ', titulo]);
    saveas(gcf, [archivos_imagen, 'rayleigh_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'rayleigh_', des_str,'.png']);

    figure();
    histfit(EC, nbins, 'weibull');
    title(['Weibull con correccion ', titulo]);
    saveas(gcf, [archivos_imagen, 'compensado_weibull_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'compensado_weibull_', des_str,'.png']);

    
    figure();
    histfit(EC, nbins, 'rayleigh');
    title(['Rayleigh con correccion', titulo]);
    saveas(gcf, [archivos_imagen, 'compensado_rayleigh_', des_str,'.fig']);
    saveas(gcf, [archivos_imagen, 'compensado_rayleigh_', des_str,'.png']);


end