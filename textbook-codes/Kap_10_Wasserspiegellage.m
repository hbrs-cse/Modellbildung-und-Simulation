%-- Kap_10_Wasserspiegellage.m
function wasserspiegellage
%-- Wasserspiegellagenberechnung als Randwertproblem
 global g B Ks uL hR
  g = 9.81; B = 2; Ks = 30; uL = 0.2; hR = 1.0;
  L = 10000; N = 10; x = linspace(0,L,N); %-- grobes Ortsgitter
  solinit = bvpinit(x,@winit);
  sol = bvp4c(@dgl,@bc,solinit);
  z = sol.y(1,:) + S_0(sol.x);  %-- Wasserspiegelhoehe
  xx = linspace(0,L,1000);  zz = deval(sol,xx); %-- Interpolation auf feines Ortsgitter
  subplot(2,1,1); plot(xx,S_0(xx),sol.x,z,'o',xx,zz(1,:)+S_0(xx),'linewidth',2); 
  legend('S_0(x)','z(x)'); xlabel('Fliessstrecke'); ylabel('Sohl- u. Wasserspiegelhoehe');
  ax = gca; ax.FontSize = 11;
  subplot(2,1,2); plot(xx,zz(2,:),'linewidth',2); 
  legend('u(x)');  xlabel('Fliessstrecke'); ylabel('Fliessgeschwindigkeit');
end

function y = winit(x)
 global uL hR
  y = [hR;uL];
end

function z = S_0(x)
  z = -0.0001*x + 0.2*sin(x/500);
end
function dz = dS_0(x)
  dz = 0.2*cos(x/500)/500 - 0.0001;
end

function dy = dgl(x,y) %-- Differentialgleichungen
 global g B Ks
  h = y(1); u = y(2); A = B*h; R = A/(B+2*h);
  S_f = u*abs(u)/(Ks^2 * R^(4/3));
  M = [u, h; g*h, u*h];
  dy = inv(M)*[0; -g*h*(dS_0(x)+S_f)];
end

function res = bc(ya,yb) %-- Randbedingungen
 global uL hR
  res = [ya(2)-uL; yb(1)-hR];
end

