% Kap_07_Energienetzwerk.m
function Netzwerk
global c1 c2 c3 c4 c5 c6 R0 R1 C q_max
 c1 = -3.1037; c2 = 1.0015; c3 = 0.0032; c4 = 1.3984e-09; c5 = 0.4303; c6 = 1.5*0.9562;
 R0 = 0.2; R1 = 0.5; C = 4000; q_max = 36000; 
% --- konsistente AW --- 
 qB = 0.25*q_max; U0 = 0; U1 = ruhespannung(qB/q_max); iV = 0; iPV = 0; iB = 0; uB = 0;
 y0 = [U0; U1; iV; iPV; iB; uB; qB];
 y_alg = fsolve(@alg,y0(1:5)); y0 = [y_alg; 0; 0.25*q_max];
% Solver 
 M = zeros(7,7); M(6,6)=1; M(7,7)=1;
 options = odeset('Mass',M,'stats','on','RelTol',1.0e-6);
 tspan = [0, 36000]; [t,y] = ode15s(@dae,tspan,y0,options);
% Plot 
 y(:,7) = y(:,7)/q_max; t = t/3600;
 subplot(2,2,1); plot(t,y(:,1),t,y(:,2),t,y(:,6),'linewidth',1)
 legend('U_0(t)','U_1(t)','u_B(t)','location','east');
 title('Spannungen')
 xlabel('Zeit / h'); ylabel('V');
 subplot(2,2,2); plot(t,y(:,3),t,y(:,4),t,y(:,5),'linewidth',1)
 legend('i_V(t)','i_{PV}(t)','i_B(t)','location','south');
 title('Stroeme')
 xlabel('Zeit / h'); ylabel('A');
 subplot(2,2,3); plot(t,y(:,7),'linewidth',1)
 legend('soc(t)','location','northwest');
 title('Ladezustand')
 xlabel('Zeit / h'); 
end

function dy = alg(y)
global q_max
  y1 = [y; 0; 0.25*q_max]; dy1 = dae(0.0,y1); dy = dy1(1:5);
end

function dy = dae(t,y)
global c1 c2 c3 c4 c5 c6 R0 R1 C q_max
 U0 = y(1); U1 = y(2); iV = y(3); iPV = y(4); iB = y(5); uB = y(6); qB = y(7);
 dy = [U0; iB + iPV - iV; verbraucher(t) - iV*(U1-U0);...
       c1 + c2*iPV + c3*(U1-U0) + c4*(exp(c5*iPV+c6*(U1-U0))-1);...
       U1-U0 - (ruhespannung(qB/q_max) - uB - R0*iB);...
       iB/C - uB/(R1*C); -iB];
end

function P = verbraucher(t)
 ts = 3600:3600:36000; P = 50*einaus(t,ts,10);
end

function U = ruhespannung(soc)
 pp = [6.8072,-10.5555,6.2199,10.2668]; % Polynomkoeffizienten
 U = ((pp(1)*soc+pp(2)).*soc+pp(3)).*soc+pp(4); % Auswertung 
end

function y = einaus(t,ts,schaltzeit)
  y = 0.*t;
  for i=1:2:length(ts)
      y = y + fstep(t,ts(i),schaltzeit);
  end
  for i=2:2:length(ts)
      y = y - fstep(t,ts(i),schaltzeit);
  end
end

function f = fstep(t,t0,dauer)
 s = 3.8002/dauer; f = (tanh(s*(t-t0))+1)/2; % atanh(0.999) = 3.8002
end