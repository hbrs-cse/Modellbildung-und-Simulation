% Kap_11_Linienmethode.m
function linienmethode
  global N dx u D
  % Linienmethode zur Loesung des Konvektions-Diffusionsproblems
  % Ortsgitter, dx, Geschwindigkeit und Diffusionskoeffizient
  N = 1000; x = linspace(0,60000,N+1); x = x(2:N+1);
  dx = x(2)-x(1); u = 1; D = 1000;
  y0 = exp(-1.0e-7*(x-15000).^2); % Anfangswerte
  hold on
  tspan = 0:3600:12*3600; % Ausgabe jede Stunde
  options = odeset('Stats','on');
  [t,y] = ode15s(@dgl,tspan,y0,options);
  for i=1:length(t)
      plot(x,y(i,:),'linewidth',2);
  end
  xlabel('Fließstrecke x'); ylabel('Konzentration c(x,t)');
end

function dy = dgl(t,y) % Differentialgleichungen
  global N dx u D
  dy = zeros(N,1);
  dy(1) = -u*(y(2)-0)/(2*dx) + D*(y(2)-2*y(1)+0)/dx^2;
  for i=2:N-1
    dy(i) = -u*(y(i+1)-y(i-1))/(2*dx) + D*(y(i+1)-2*y(i)+y(i-1))/dx^2;
  end
  dy(N) = -u*(y(N)-y(N-1))/dx;
end

