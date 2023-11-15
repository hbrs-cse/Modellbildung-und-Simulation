%-- Kap_10_RWP.m
function rwp_1
 global N x dx
%-- Differenzenverfahren zur Loesung eines Randwertproblems
  N = 50; x = linspace(1,2,N); dx = x(2)-x(1); %-- Ortsgitter
  y = zeros(2*N,1)+1; %-- Startwerte fuer Newton
  y = newton(@fcn,y,1.0e-8); y1 = y(1:2:end)';
  plot(x,y1,'o',x,x.^6,'linewidth',1.5); xlabel('x'); ylabel('y(x)'); 
  legend('numerische Loesung','analytische Loesung');
  max_err = max(abs(y1-x.^6))
end

function dy = dgl(x,y) %-- Differentialgleichungen
 dy = [y(2); 180*x^3*y(1)/y(2)];
end

function res = rb(ya,yb) %-- Randbedingungen
  res = [ya(2)-6; yb(1)-64];
end

function f = fcn(y)
%-- vom Newtonverfahren zu loesende Gleichungen
 global N x dx
  f = zeros(2*N,1); 
  for i=1:N-1
     y_i = y(2*i-1:2*i); y_ip1 = y(2*i+1:2*i+2);
     f_i = dgl(x(i),y_i); f_ip1 = dgl(x(i+1),y_ip1);
     f(2*i-1:2*i) = y_ip1 - y_i -dx/2*(f_i + f_ip1);
  end
  f(2*N-1:2*N) = rb(y(1:2),y(2*N-1:2*N)); %-- RB
end

function x = newton(fcn,x0,tol)
%-- berechnet Nullstelle von fcn mit Genauigkeit tol und Startwert x0
 h = 2*tol; x = x0; nit = 0;
 while (norm(h) > tol) && (nit < 20) %-- max. 20 Iterationen
   nit = nit + 1;
   J = jac(x,fcn);  b = fcn(x); h = -J\b; x = x + h;
 end 
end

function J = jac(x,f)
%-- numerische Jacobimatrix der Fkt f an der Stelle x
 f0 = f(x);
 for i = 1:length(x)
    h = sqrt(eps)*max(1.0e-8,abs(x(i)));
    x1 = x; x1(i) = x1(i) + h;
    J(:,i) = (f(x1)-f0)/h;  %-- komplette Spalte von J 
 end
end




