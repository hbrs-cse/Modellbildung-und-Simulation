% Kap_07_Masseteilchen_2.m
function Masseteilchen_2
%
 x0 = 0; z0 = 0; u0 = 10.0; v0 = 20.0; 
 y0 = [x0,u0,z0,v0]'; 
 tend = 5.0; tspan = [0.0,tend];
 options = odeset('Events',@events)
 [t,y] = ode45(@dgl,tspan,y0,options);
 plot(y(:,1),y(:,3),'o'); hold on
end

function dy = dgl(t,y)
 dy = [y(2);0;y(4);-9.81];
end

function [value,isterminal,direction] = events(t,y)
 value = y(3);
 isterminal = 1;
 direction = -1;
end
