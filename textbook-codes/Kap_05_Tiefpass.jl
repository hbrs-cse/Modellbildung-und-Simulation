#-- Kap_05_Tiefpass.jl
using FFTW, Plots

rechteck(t) = t < pi ?  -1 : 1

fs = 4000;  delta_t = 1/fs
T = 2*pi; t = 0:delta_t:T-0.5*delta_t
y = rechteck.(t)

c = fft(y)
N = length(y); f_k = (0:N-1)*fs/N   #-- zugehörige Frequenzen

P1 = plot(f_k[1:10],2*abs.(c[1:10])/N, line=:stem, marker=:circle, label = false,  linewidth = 2)
xlabel!("Frequenz"); ylabel!("Normierter Spektralkoeffizient")

for k = 2:round(Int,N/2)
    if f_k[k] > 9.0/(2*pi)  #-- Tiefpass
        c[k] = 0; c[N+2-k] = 0; #-- Symmetrie erhalten
    end
end
y1 = ifft(c);
P2 = plot(t,y, label = "Rechtecksignal", linewidth = 2); 
plot!(t,real(y1), label = "Tiefpass",  linewidth = 2); 
xlabel!("t"); ylabel!("y(t)")
P = plot(P1,P2)

