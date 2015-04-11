function figura_compensacion_pantalla(hs, desviaciones)
% Grafica para un heliostato y en una desviacion particular
% la pantalla del día de equinoccio

des_str = sprintf('_%1.1f', desviaciones * 1e3);

%% Grafica los heliostatos
for h = hs
    load(['../data_gen/campo_grande/compensado_heliostato', int2str(h), des_str, '.mat']);

    ind = find(DT(:,1) == 80);
    posiciones = [-desplaz(ind, 2), desplaz(ind, 3)];
    pos_comp = [-desplazC(ind, 2), desplazC(ind, 3)];

    plot(posiciones(:, 1), posiciones(:, 2), 'r');
    hold on
    plot(pos_comp(:, 1), pos_comp(:, 2), 'b');
    
    compensacion
errores
    

end

