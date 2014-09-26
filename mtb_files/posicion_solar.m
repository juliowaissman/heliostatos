function [thetaZ, gammaS] = posicion_solar(latitud, num_dia, T)
% POSICION_SOLAR Calcula la posicion solar
%   [thetaZ, gammaS] = posicion_solar(latitud, num_dia, hora)
%
% Calcula la posicion solar
%       latitud: Ubicacion geografica
%       num_dia: [0,1,..., 365] dia del a?o
%       min: Hora del dia, en minutos
%
% Devuelve
%       thetaZ: Angulo cenital (de -pi a pi rad)
%       gammaS: Angulo azimutal
%
% Esta ecuacion es correcta unicamente si se utilizan minutos como hora solar.

g2r = pi/180;
phi = latitud * g2r;

% Declinacion solar
delta = (23.45*g2r) .* sin( (2*pi/365) * (284 + num_dia));

% Angulo horario (omega > 0 despues de mediodia)
omega = (0.25*g2r) * (T - 720);

thetaZ = acos( (cos(phi) .* cos(delta) .* cos(omega)) + ...
               (sin(phi) .* sin(delta)));
           
S = sin(omega) .* cos(delta) ./ sin(thetaZ);
C = ( sin(phi) .* cos(delta) .* cos(omega) - cos(phi) .* sin(delta)) ./ sin(thetaZ);

gammaS = atan2(S,C); % atan2 calcula el arcotangente en cuatro cuadrantes


