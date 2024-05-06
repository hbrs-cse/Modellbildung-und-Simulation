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

function [T,Y] = rk3_simple(fcn,tspan,y0,atol,rtol)
% fcn: ode-function; tspan: Zeitinterval
% y0: Anfangswerte; atol, rtol: Toleranzen
% ---- Initialisierungen ----
 nfevals = 0; nsteps = 0; nrejected = 0; % Statistik
 uround=eps; fac1=0.2; fac2=6.0;   % anpassbar
% Koeffizienten
 stage = 3; b = [1/6;1/6;2/3];  bd = [1/2;1/2;0];
 a = [0;1;1/2]; alpha = [0,0,0;1,0,0;1/4,1/4,0];
% --- Ausgabeparameter [T,Y] ---
 neq = length(y0); t0=tspan(1); tend=tspan(end); 
 y(:,1) = y0; t=t0; T=t0; Y=y'; 
% ---- Schrittgroessen ----
 if (tend <= t0) error('tend<= t0 !!'); end
 hmax=abs(tend-t0)/10; hinit=1.0e-6*abs(tend-t0);  h=min(hinit,hmax);  
% ---- Hauptschleife ----
 done = false;  reject = false; K=zeros(neq,stage);
 while ~done
    if (t+0.1*h == t) || (abs(h) <= uround)
        fprintf(['Error exit of rk3_simple at time t=%15g: ' ...
            'step size to small h=%15g \n'],t,h);
        break
    end
    if (t+h) >= tend
       h=tend-t;
    else
       h=min(h,0.5*(tend-t));
    end
% ---- Integrationsschritt ----
    if reject==false      
        K(:,1) = fcn(t,y); nfevals = nfevals+1;
    end
    for i=2:stage
       sum_K = K*alpha(i,:)';
       K(:,i) = fcn(t+h*a(i),y+h*sum_K); nfevals=nfevals+1; 
    end
    sum_1 = h*K*b; sum_2 = h*K*bd; ynew = y + sum_1;
% ---- Fehlertestung ----
    SK = atol + rtol.*max(abs(y),abs(ynew));
    err = sum( ((sum_1-sum_2)./SK).^2 ); err = max(realmin,sqrt(err/neq));
    fac = 0.9 * err^(-1/3);  fac=min(fac2,max(fac1,fac)); hnew=h*fac;
    if (err <= 1.0)  % Schritt akzeptiert
      reject = false; nsteps = nsteps+1; told = t; t=t+h; 
      if (abs(tend-t) < uround) done=true; end
      y = ynew; T=[T;t]; Y=[Y;ynew']; 
    else  % Schritt abgelehnt
      reject = true; nrejected = nrejected+1;  
    end
    h = min(hnew,hmax);
 end

 fprintf('%g successful steps\n', nsteps);
 fprintf('%g failed attempts\n', nrejected);
 fprintf('%g function evaluations\n', nfevals);
end