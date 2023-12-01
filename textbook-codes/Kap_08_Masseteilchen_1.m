%-- Kap_08_Masseteilchen_1.m
function Masseteilchen_1
%--
 x0 = 0; z0 = 0; u0 = 10.0; v0 = 20.0; 
 y0 = [x0,u0,z0,v0]'; 
 tend = 5.0; tspan = [0.0,tend];
% tspan = linspace(0.0,tend,100)
 options = odeset('stats','on');
 [t,y] = ode45(@dgl,tspan,y0,options);
% [t,y] = rk3_simple(@dgl,tspan,y0,1.0e-6,1.0e-6);
 plot(y(:,1),y(:,3),'o')
 xlabel('x'); ylabel('z'); ax = gca; ax.FontSize = 14;
 exportgraphics(gca,'Masseteilchen1_Matlab.pdf','resolution',200)
 err_x = abs(x0+u0*tend-y(end,1))
 err_z = abs(z0+v0*tend-0.5*9.81*tend^2-y(end,3))
end

function dy = dgl(t,y)
 dy = [y(2);0;y(4);-9.81];
end
