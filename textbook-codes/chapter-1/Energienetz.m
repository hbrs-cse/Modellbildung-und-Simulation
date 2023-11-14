function Energienetz
%-- Batterie/Verbraucher Modell
global q_max
 q_max = 36000;
 soc = 0.9; q_B = soc*q_max;
 U_0=0; U_1=ruhespannung(soc); i_V=0; i_B=0; u_B=0;
 y0 = [U_0;U_1;i_V;i_B;u_B;q_B];
 M = eye(6); M(1,1)=0; M(2,2)=0; M(3,3)=0; M(4,4)=0;
 options = odeset( 'Mass' ,M, 'RelTol' ,1.0e-6);
 tspan = [0 24*3600];
 [t,y] = ode15s(@dgl,tspan,y0,options);
 y(:,6)=y(:,6)/q_max; t = t/3600;
 subplot(2,2,1); plot(t,y(:,2),'linewidth',1.5); xlabel('Zeit /h'); ylabel('V'); title('Spannung U_1');
 subplot(2,2,2); plot(t,y(:,4),'linewidth',1.5); xlabel('Zeit /h'); ylabel('A'); title('Strom i_B');
 subplot(2,2,3); plot(t,y(:,6),'linewidth',1.5); xlabel('Zeit /h'); ylabel('soc'); title('Ladezustand');
 exportgraphics(gcf,'Energienetz_Resultate.pdf','resolution',200)
end

function dy = dgl(t,y)
global q_max
 R0=0.2; R1=0.5; C=4000;
 U_0=y(1); U_1=y(2); i_V=y(3); i_B=y(4); u_B=y(5); q_B=y(6); soc=q_B/q_max;
 dy = [U_0; i_B-i_V; i_V*(U_1-U_0)-leistung(t); ...
 U_1-U_0-(ruhespannung(soc)-u_B-R0*i_B); 1/C*i_B - 1/(R1*C)*u_B; -i_B];
end

function u = ruhespannung(soc)
 pp = [6.8072,-10.5555,6.2199,10.2668]; %-- Polynomkoeffizienten
 u = ((pp(1)*soc+pp(2)).*soc+pp(3)).*soc+pp(4); %-- Polynomauswertung 
end

function P=leistung(t)
 ts = 3600:3600:24*3600; P = 8*einaus(t,ts,10);
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
%-- atanh(0.999) = 3.8002
 s = 3.8002/dauer; f = (tanh(s*(t-t0))+1)/2;
end
