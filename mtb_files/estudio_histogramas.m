%% Estudio sobre la función de distribución gamma inversa
%
% Para esto solo vamos a cargar los datos de un solo día (primavera) y los
% vamos a utilizar para ver como se ve una weibull, una gamma y una gamma
% inversa, a ver si resulta en algo que sea interesante.

archivo = '../data_gen/errores/errores_';
desviaciones_nominales = [0.5e-3, 0.5e-3, 0.5e-3, 0.5e-3, 0];
des_str = sprintf('_%1.2f', desviaciones_nominales * 1e3);

E = [];
EC = [];

E_primavera = [];
E_verano = [];
E_invierno = [];

E_primaveraC = [];
E_veranoC = [];
E_inviernoC = [];

load([archivo, des_str, '.mat']);

%% Primero vamos a checar como sale la weibull y otras distribuciones

nbins = 25;

figure();
histfit(E, nbins, 'weibull');

figure();
histfit(E, nbins, 'gamma');

figure();
histfit(E, nbins, 'rayleigh');

%% Ahora vamos a probar directamente Raleigth

figure();
histfit(E, nbins, 'rayleigh');

figure();
histfit(EC, nbins, 'rayleigh');

%% Y ahora vamos a probar con la gamma

figure();
histfit(E, nbins, 'gamma');

figure();
histfit(EC, nbins, 'gamma');

% %% Y por último con la inversa de la gamma
% 
% figure();
% histfit(1 / (E_primavera * 1e3), nbins, 'gamma');
% 
% figure();
% histfit(1 / (E_primaveraC * 1e3), nbins, 'gamma');
% 


%% Pruebas estadísticas
pdw = fitdist(E,'Weibull');
pdr = fitdist(E,'rayleigh');
pdg = fitdist(E,'gamma');


muestra = 1000;
repeticiones = 100;
pws = zeros(repeticiones, 1);
hws = zeros(repeticiones, 1);
pgs = zeros(repeticiones, 1);
hgs = zeros(repeticiones, 1);
for i = 1:repeticiones
    datos_muestra = randsample(E, muestra); 
    [hws(i), pws(i)] = chi2gof(datos_muestra, 'CDF', pdw); 
    [hgs(i), pgs(i)] = chi2gof(datos_muestra, 'CDF', pdg); 
    hw = sum(1 - hws);
    hg = sum(1 - hgs);
    pw = mean(pws);
    pg = mean(pgs);
end