function [pd_w, pd_r, pd_g, p, h] = pruebas_hipotesis(data, ...
                                                      muestra,...
                                                      repeticiones )
%PRUEBAS_HIPOTESIS Las pruebas de hip�tesis
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

    i = 1;
    while i <= repeticiones
        datos_muestra = randsample(data, muestra); 
        [hws(i), pws(i)] = chi2gof(datos_muestra, 'CDF', pd_w);
        if isnan(pws(i)), continue, end;
        
        [hrs(i), prs(i)] = chi2gof(datos_muestra, 'CDF', pd_r); 
        if isnan(prs(i)), continue, end;
        
        [hgs(i), pgs(i)] = chi2gof(datos_muestra, 'CDF', pd_g); 
        if isnan(pgs(i)), continue, end;

        i = i+1;
    end
    h = [sum(1 - hws), sum(1 - hrs), sum(1 - hgs)];
    p = [mean(pws), mean(prs), mean(pgs)];

end

