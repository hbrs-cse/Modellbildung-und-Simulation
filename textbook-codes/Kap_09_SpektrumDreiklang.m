% Kap_09_SpektrumDreiklang.m
fs = 2000;  delta_t = 1/fs;
T = 1.0; t = 0:delta_t:T-delta_t;  
y = 1/3*(sin(2*pi*440*t)+sin(2*pi*550*t)+sin(2*pi*660*t));
N = length(y) 
c = 2*abs(fft(y))/N; % Spektralkoeffizienten
f_k = (0:N-1)*fs/N;  % zugehörige Frequenzen
N2 = round(N/2);
stem(f_k(1:N2),c(1:N2));
xlabel('Frequenz'); 
ylabel('Normierter Spektralkoeffizient'); 
