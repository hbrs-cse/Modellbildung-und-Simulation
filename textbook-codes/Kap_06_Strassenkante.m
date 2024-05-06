% Kap_06_Strassenkante.m
function strassenkante
% nichtlinearen Fit berechnen mit dem Newtonverfahren
 load strasse.txt % einlesen der (x,y)-Wertepaare
 global xi yi % (x,y)-Werte global halten
 xi = strasse(:,1); yi = strasse(:,2); nx = length(xi)
 plot(xi,yi); hold on  % Rohdaten plotten
% Startwerte fuer a,b,c schaetzen
 a = min(yi); b = max(yi)-a; 
 diff = abs(yi(2:nx)-yi(1:nx-1)); [diffmax,ii] = max(diff); 
 c = xi(ii); % Position der max. Aenderung in y
 params = [a;b;c];
% Newtonverfahren aufrufen und Ergebnis plotten
 tol = 1.0e-6; x0 = [a;b;c];
 xres = newton(@fcn,x0,tol);
 y_fit = fit_fcn(xi,xres);
 plot(xi,y_fit,'Linewidth',2)
 legend('Originaldaten','gefittete Funktion');

function y = fit_fcn(x,params)
 p = 0.025; % bleibt unveraendert
 a = params(1); b = params(2); c = params(3);
 y = a + b./(exp((x-c)/p)+1);

function x = newton(fcn,x0,tol)
% berechnet Nullstelle von fcn mit Genauigkeit tol 
% und Startwert x0
 h = 2*tol; x = x0; nit = 0;
 while (norm(h) > tol) && (nit < 20) % max. 20 Iterationen
   nit = nit + 1;
   J = jac(x,fcn);  b = fcn(x); 
   h = -J\b; x = x + h;
 end 

function f = fcn(x)
 global xi yi 
 f0 = fit_fcn(xi,x);
 a = x(1); b = x(2); c = x(3); p = 0.025;
 expp = exp( (xi-c)/p );
 f(1,1) = sum(f0-yi);
 f(2,1) = sum( (f0-yi)./(expp + 1) );
 f(3,1) = sum( (f0-yi)*b/p.* expp./(expp+1).^2 );

function J = jac(x,f)
% numerische Jacobimatrix der Fkt f an der Stelle x
 f0 = f(x);
 for i = 1:length(x)
    h = sqrt(eps)*max(1.0e-8,abs(x(i)));
    x1 = x; x1(i) = x1(i) + h;
    J(:,i) = (f(x1)-f0)/h;  % komplette Spalte von J 
 end


