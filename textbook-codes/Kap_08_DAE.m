%-- Kap_08_DAE.m
function dae_problem
%-- einfuehrendes Beispiel ---
 tspan = [0 3]; y0 = [0;1]; M = [1,0;0,0]; 
 options = odeset('Mass',M,'stats','on');
 [t,y] = ode15s(@dae,tspan,y0,options);
 plot(t,y(:,1),t,y(:,2),'linewidth',2); legend('y_1(t)','y_2(t)','location','south'); 
 xlabel('t'); ylabel('y(t)');
end

function dy = dae(t,y)
 dy = [y(2); y(1)^2+y(2)^2-1.0];
end

