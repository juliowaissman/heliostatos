function [h, p, stats, params_wbl] = prueba_wbl(x, muestra, nbins, x_min)
% PRUEBA_WBL .- prueba de hypótesis sobre una distribucion Weibull
%
% [h, p, stats] = prueba(x, muestra)
%
% Realiza la prueba de chi cuadrada de bondad de ajuste al 95%
% de una muestra de datos, donde x es un vector de todos los datos y
% muestra es un entero con el tamaño de la muestra. Para realizar la prueba
% por default se utiliza un histograma experiental de 10 bins
%
% [h, p, stats] = prueba(x, muestra, nbins)
%
% Permite modificar el numero de bins del histograma
%
% [h, p, stats] = prueba(x, muestra, nbins, x_min)
% 
% Permite eliminar bins del histograma con menos de xmin datos. Esto
% permite reducir la importancia de las colas en la prueba de hipótesis.
%
% Debido a que la prueba de chi cuadrada es extremadamente sensible al
% número de valores de una muestra, es necesario probar utilizando
% diferentes tamanos de la muestra y repitiendo continuamente.
%
% Para utilizar esta función es necesario contar con la toolbox de
% Statistics.

% Julio Waissman, Luiz Díaz y Camilo Arancibia, 2014

datos_muestra = randsample(x, muestra);

params_wbl = wblfit(datos_muestra);

if nargin < 3, nbins = 10; end;
if nargin < 4, x_min = 0; end;

[h, p, stats] = chi2gof(datos_muestra,...
                        'cdf', {@wblcdf, params_wbl(1), params_wbl(2)},...
                        'nbins', nbins, ...
                        'emin', x_min);

end

