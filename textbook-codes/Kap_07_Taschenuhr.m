% Kap_07_Taschenuhr.m
function taschenuhr
  y0 = 0.999;  tspan = [0,1.5]; rtol = 1.0e-4; atol = 1.0e-4;
  options = odeset('RelTol',rtol,'AbsTol',atol,'Stats','on');
  tic
  [t,y] = ode45(@dgl,tspan,y0,options);
  toc
  y_ode45 = y(end);
  plot(t,y,'color','blue','Linewidth',2)
  hold on
  tic
  [t,y] = rk3_simple(@dgl,tspan,y0,atol,rtol);
  toc
  y_rk3_simple = y(end);
  plot(t,y,'o','Linewidth',2,'color','red')
  xlabel('x'); ylabel('y');
  ax = gca; ax.FontSize = 14;
  legend('ode45','rk3\_simple')
% Genauigkeit in tend
  rtol = 1.0e-14; atol = 1.0e-14;
  options = odeset('RelTol',rtol,'AbsTol',atol,'Stats','on');
  tic
  [t,y] = ode45(@dgl,tspan,y0,options);
  toc
  y_exakt = y(end);
  err_ode45 = abs(y_exakt-y_ode45)
  err_rk3_simple = abs(y_exakt-y_rk3_simple)
end

function dy = dgl(t,y)
 dy = -y./sqrt(1-y.^2);
end

