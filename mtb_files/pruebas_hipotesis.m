function [pd_w, pd_r, pd_g, p, h] = pruebas_hipotesis(data, ...
                                                      muestra,...
                                                      repeticiones )
%PRUEBAS_HIPOTESIS Las pruebas de hipótesis
%   Detailed explanation goes here

    pd_w = fitdist(data,'Weibull');
    pd_r = fitdist(data,'rayleigh');
    pd_g = fitdist(data,'gamma');

    pws = zeros(repeticiones, 1);
    hws = zeros(repeticiones, 1);
    prs = zeros(repeticiones, 1);
    hrs = zeros(repeticiones, 1);
    pgs = zeros(repeticiones, 1);
    hgs = zeros(repeticiones, 1);
    
for i = 1:repeticiones
    datos_muestra = randsample(data, muestra); 
    [hws(i), pws(i)] = chi2gof(datos_muestra, 'CDF', pd_w); 
    [hrs(i), prs(i)] = chi2gof(datos_muestra, 'CDF', pd_r); 
    [hgs(i), pgs(i)] = chi2gof(datos_muestra, 'CDF', pd_g); 
end
h = [sum(1 - hws), sum(1 - hrs), sum(1 - hgs)];
p = [mean(pws), mean(prs), mean(pgs)];

end

