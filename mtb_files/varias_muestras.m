function [h0s, p_media] = varias_muestras(x, muestras, veces, nbins, x_min)

if nargin < 4, nbins = 10; end;
if nargin < 5, x_min = 0; end;


p_vec = zeros(veces, 1);
h_vec = zeros(veces, 1);
for i = 1:veces
    [h_vec(i), p_vec(i), ~] = prueba_wbl(x, muestras, nbins, x_min);
end

h0s = length(h_vec(h_vec == 0));
p_media = mean(p_vec);