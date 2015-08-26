%% Genera la figura de desplazamientos con compensación y sin compensación
% Para el caso general con todos los errores en 2.5 mrad

archivo_posiciones = '../campos_info/posiciones_grande.txt';
archivos_datos = '../data_gen/campo_grande/heliostato';    
des_str = sprintf('_%1.2f', [2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 0] * 1e3);

heliostatos = load(archivo_posiciones, '-ascii');  

for i = randsample(1:100, 15)
    load([archivos_datos, int2str(i), des_str, '.mat']);
    
    figure(1)
    plot(-desplaz(DT(:,1) == 80, 2), -desplaz(DT(:,1) == 80, 3), 'k');
    hold on;
    
    figure(2)
    plot(-desplazC(DT(:,1) == 80, 2), -desplazC(DT(:,1) == 80, 3), 'k');
    hold on;
    
    disp(heliostatos(1,:));
    desplaz(DT(:,1) == 80, 2:3)
end

