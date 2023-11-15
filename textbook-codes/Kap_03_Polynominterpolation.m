%-- Kap_03_Ploynominterpolation.m
function Test_Polyint
%-- Testprogramm zur Polynominterpolation
 x = [-2, -1, 0, 1];
 y = [-2, 2, 4, 10];
 c_coeff = poly_interpol(x,y)
 xx = linspace(-2,1,1000); 
 yy = poly_evaluate(xx,x,c_coeff);
 plot(xx,yy,x,y,'o')
%--
end

function c = poly_interpol(x,y)
%-- Berechnung der Polynomkoeffizienten
 n = length(x);
 for i=1:n 
   d(i) = y(i);      %-- neue Stuetzstelle hinzunehmen
   for k = i-1:-1:1  %-- Diagonalschema vervollstaendigen
      d(k) = (d(k+1)-d(k))/(x(i)-x(k));
   end
   c(i) = d(1);
 end
%--
end

function y = poly_evaluate(x,xi,c)
%-- Auswertung des Interpolationspolynoms mit den Stuetzstellen
%-- xi und Koeffizienten c an allen Punkten x
 n = length(xi);
 y = c(n);
 for i = n-1:-1:1 
   y = y.*(x-xi(i)) + c(i);  %-- Hornerschema
 end
%--
end
