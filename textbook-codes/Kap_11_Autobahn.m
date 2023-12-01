%-- Kap_11_Autobahn.m
function autobahn
%-- mit FV Ortsdiskretisierung
 n = 1000; dx = 100000/n;
 x = linspace(dx/2, 100000-dx/2, n); %-- Zellenmittelpunkte
%-- Anfangswerte, tspan
 y0 = 0*x; y0(x < 50000) = 1/6; tspan = 0:300:900; 
%-- Integrator
 tol = 1.0e-5; options=odeset('Stats','on','RelTol',tol,'AbsTol',tol);
 [t,y] = ode45(@(t,y) dgl(t,y,dx),tspan,y0,options);
%-- Ergebnisse plotten
 subplot(2,1,1); hold on
 title('Fahrzeugdichte'); xlabel('x / km'); ylabel('\rho(x)');
 subplot(2,1,2); hold on
 title('Geschwindigkeit'); xlabel('x / km'); ylabel('u(x)');
 for i=1:length(t) 
    subplot(2,1,1); plot(x/1000,y(i,:),'linewidth',2); 
    subplot(2,1,2); plot(x/1000,uvonrho(y(i,:)),'linewidth',2); hold on
 end
 subplot(2,1,1); legend({'t=0','t=300','t=600','t=900'})
 subplot(2,1,2); legend({'t=0','t=300','t=600','t=900'},'location','southeast')

function dy = dgl(t,y,dx)
 n = length(y); dy = zeros(n,1);
 lam = uvonrho(0.0); %-- = u_max 
 [yL,yR] = recover(y); %-- Werte auf Zellgrenzen
 yL(1) = 1/6; yR(1) = 1/6; %-- linke RB
 fluxL = yL.*uvonrho(yL); fluxR = yR.*uvonrho(yR); %-- Flüsse auf Zellgrenzen
 fR = fluxL(1);
 for i = 1:n
    fL = fR;
    fR = 0.5*(fluxL(i+1) + fluxR(i+1) - lam*(yR(i+1)-yL(i+1)));
    dy(i) = -(fR - fL)/dx;
 end
 
function [yL,yR] = recover(y)
 yL = [2*y(1)-y(2); y];
 yR = [y; 2*y(end)-y(end-1)];

function u = uvonrho(rho)
 u_max = 50; rho_max = 1/6; rho_krit = 1/100; 
 c = u_max/log(rho_krit/rho_max);
 u = 0*rho + u_max;
 ff = find(rho > rho_krit); u(ff) = c*log(rho(ff)/rho_max);
 ff = find(rho > rho_max);  u(ff)=0;

