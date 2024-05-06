%  Kap_08_Resonanz.m
function Resonanz
%  Masse-Feder-Daempfer mit externer Kraft
global A omega alpha
  m = 100.0; k = 100.0; d = 1; 
  A = [0 1;-k/m -d/m]; 
  lam = eig(A); omega = imag(lam(1));
  y0 = [1;0];
  tspan =[0,60]; alpha = 0;
  [t,y] = ode45(@dgl,tspan,y0);
  subplot(2,2,1); plot(t,y(:,1),'linewidth',1.5);  
  xlabel('Zeit'); ylabel('Auslenkung'); title('Keine Anregung');
  tspan =[0,600]; alpha = 1;
  [t,y] = ode45(@dgl,tspan,y0);
  subplot(2,2,2); plot(t,y(:,1),'linewidth',1.5);
  xlabel('Zeit'); ylabel('Auslenkung');
  title('Anregung sin(\omega_0 t)');
  omega = 0.5*imag(lam(1));
  tspan =[0,60]; alpha = 1;
  [t,y] = ode45(@dgl,tspan,y0);
  subplot(2,2,3); plot(t,y(:,1),'linewidth',1.5); 
  xlabel('Zeit'); ylabel('Auslenkung');
  title('Anregung sin(1/2 \omega_0 t)');
end

function dy = dgl(t,y)
global A omega alpha
  dy = A*y;
  dy(2) = dy(2) + alpha*sin(omega*t);
end
