%-- Kap_08_FederMasse.m
function Feder_Masse_Daempfer
%-- Feder-Masse-Daempfer
 tspan = [0 100]; d = 1;
 y0 = [1;0]; options=odeset('Stats','on');
 [t,y] = ode45(@(t,y) dgl_feder(t,y,d),tspan,y0,options);
 subplot(2,2,1); plot(t,y(:,1),'Linewidth',2); 
 title('ode45, d=1'); xlabel('t'); ylabel('y(t)');
 [t,y] = ode15s(@(t,y) dgl_feder(t,y,d),tspan,y0,options);
 subplot(2,2,2); plot(t,y(:,1),'Linewidth',2); 
 title('ode15s, d=1'); xlabel('t'); ylabel('y(t)');
%-- d=1000
 tspan = [0 10000]; d = 1000;
 [t,y] = ode45(@(t,y) dgl_feder(t,y,d),tspan,y0,options);
 subplot(2,2,3); plot(t,y(:,1),'Linewidth',2); 
 title('ode45, d=1000'); xlabel('t'); ylabel('y(t)');
 [t,y] = ode15s(@(t,y) dgl_feder(t,y,d),tspan,y0,options);
 subplot(2,2,4); plot(t,y(:,1),'Linewidth',2); 
 title('ode15s, d=1000'); xlabel('t'); ylabel('y(t)');
end

function dy = dgl_feder(t,y,d)
 m = 10; k = 1;
 dy = [y(2); -k/m*y(1)-d/m*y(2)];
end
