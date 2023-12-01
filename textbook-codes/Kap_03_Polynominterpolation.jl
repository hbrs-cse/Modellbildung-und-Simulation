#-- Kap_03_Polynominterpolation.jl
using Plots
#-- Testprogramm zur Polynominterpolation

function poly_interpol(x,y)
#-- Berechnung der Polynomkoeffizienten des Interpolationspolynoms
 n = length(x); d = zeros(n); c = zeros(n);
 for i=1:n
   d[i] = y[i];      #-- neue Stuetzstelle hinzunehmen
   for k = i-1:-1:1  #-- Diagonalschema vervollstaendigen
       d[k] = (d[k+1]-d[k])/(x[i]-x[k]);
   end
   c[i] = d[1];
 end
 return c
end

function poly_evaluate(x,xi,c)
#-- Auswertung des Interpolationspolynoms mit den Stuetzstellen
#-- xi und Koeffizienten c an allen Punkten x
 n = length(xi); y = zeros(length(x));
 y = y .+ c[n];
 for i = n-1:-1:1
   y = y.*(x .- xi[i]) .+ c[i];  #-- Hornerschema
 end
 return y
end

#-- Hauptprogramm
 x = [-2, -1, 0, 1]; y = [-2, 2, 4, 10];
 c_coeff = poly_interpol(x,y)
 xx = range(-2.0,stop = 1.0, length = 1000);
 yy = poly_evaluate(xx,x,c_coeff);
 p = plot(x,y, marker=:o, line = :scatter); plot!(xx,yy)
 display(p)