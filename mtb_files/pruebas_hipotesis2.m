function [pd_w, pd_r, pd_g, p, h] = pruebas_hipotesis2(data, ...
                                                      muestra,...
                                                      repeticiones )
%PRUEBAS_HIPOTESIS Las pruebas de hipótesis
%   Detailed explanation goes here

    pd_n = fitdist(data,'Nakagami');
    pd_r = fitdist(data,'Rician');
    pd_k = fitdist(data,'Kernel');

    pns = zeros(repeticiones, 1);
    hns = zeros(repeticiones, 1);
    prs = zeros(repeticiones, 1);
    hrs = zeros(repeticiones, 1);
    pks = zeros(repeticiones, 1);
    hks = zeros(repeticiones, 1);

    i = 1;
    while i <= repeticiones
        datos_muestra = randsample(data, muestra); 
        [hns(i), pns(i)] = chi2gof(datos_muestra, 'CDF', pd_w);
        if isnan(pns(i)), continue, end;
        
        [hrs(i), prs(i)] = chi2gof(datos_muestra, 'CDF', pd_r); 
        if isnan(prs(i)), continue, end;
        
        [hks(i), pks(i)] = chi2gof(datos_muestra, 'CDF', pd_g); 
        if isnan(pks(i)), continue, end;

        i = i+1;
    end
    h = [sum(1 - hns), sum(1 - hrs), sum(1 - hks)];
    p = [mean(pns), mean(prs), mean(pks)];

end

