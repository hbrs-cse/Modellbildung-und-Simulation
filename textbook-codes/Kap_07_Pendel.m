% Kap_07_Pendel.m
function Pendel
% Pendel als DAE ---
 L = 2; y0 = [L;0;0;0;0]; tspan = [0, 40];
 M = eye(5); M(5,5)=0; 
 options = odeset('Mass',M,'stats','on');%,'RelTol',1.0e-3);
 [t,y] = ode15s(@pendel_dae,tspan,y0,options);
 subplot(2,1,1); plot(t,y(:,1),t,y(:,3),'linewidth',2);
 legend('x(t)','y(t)'); xlabel('t'); title('RelTol = 1.0e-3');
% ax = gca; ax.FontSize = 14;
 options = odeset('Mass',M,'stats','on','RelTol',1.0e-5);
 [t,y] = ode15s(@pendel_dae,tspan,y0,options);
 subplot(2,1,2); plot(t,y(:,1),t,y(:,3),'linewidth',2);
 legend('x(t)','y(t)'); xlabel('t'); title('RelTol = 1.0e-5');
end

function dy = pendel_dae(t,y)
 g = 9.81; m = 1;
 dy = [y(2); 2*y(5)*y(1)/m; y(4); 2*y(5)*y(3)/m - g; ...
      y(2)^2 + y(4)^2 + 2*y(5)/m*(y(1)^2 + y(3)^2)-g*y(3)];
end

