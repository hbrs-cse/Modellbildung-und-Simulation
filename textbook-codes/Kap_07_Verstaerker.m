% Kap_07_Verstaerker.m
function Verstaerker
% --- zweistufiger Verstaerker ---
 for i=1:5 C(i) = i*1.0e-6; end 
 Ub = 6.0; alpha = 0.99; R0 = 1000.;
 for i=1:9 R(i) = 9000.0; end 
 param = [Ub, alpha, R0, R];
 M = zeros(8); 
 M(1,1) = C(1); M(1,2) =  -C(1); M(2,1) =  -C(1); M(2,2) = C(1); M(3,3) = C(2);
 M(4,4) = C(3); M(4,5) =  -C(3); M(5,4) =  -C(3); M(5,5) = C(3); M(6,6) = C(4);
 M(7,7) = C(5); M(7,8) =  -C(5); M(8,7) =  -C(5); M(8,8) = C(5);
 y0(1) = Ue(0); y0(2) = Ub*R(1)/(R(1)+R(2)); y0(3) = y0(2); y0(4) = Ub;
 y0(5) = Ub*R(5)/(R(5)+R(6)); y0(6) = y0(5); y0(7) = Ub; y0(8) = 0; 
 options = odeset('Mass',M,'stats','on','RelTol',1.0e-6);
 tspan = [0,0.2];  
 [t,y] = ode15s(@(t,y) verstaerker_dae(t,y,param),tspan,y0,options);
 plot(t,Ue(t),t,y(:,8),'linewidth',1);
 xlabel('t'); ylabel('U');
 legend('U_e(t)','U_8(t)','location','southeast');
end

function u = Ue(t)
% Eingangsspannung
  u = 0.1*sin(2*pi*200*t);
end

function i = f_trans(U)
% Transistor-Kennlinie
 UF = 0.026; beta = 1.0e-6;
 i = beta*(exp(U/UF)-1.0);
end

function dy = verstaerker_dae(t,y,param)
 Ub = param(1); alpha = param(2); R0 = param(3); R = param(4:12);
 f_trans_1 = f_trans(y(2)-y(3)); f_trans_2 = f_trans(y(5)-y(6));
 dy(1,1) = (Ue(t)-y(1))/R0;
 dy(2,1) = (Ub-y(2))/R(2) - y(2)/R(1) - (1-alpha)*f_trans_1;
 dy(3,1) = -y(3)/R(3) + f_trans_1;
 dy(4,1) = (Ub-y(4))/R(4) - alpha*f_trans_1;
 dy(5,1) = (Ub-y(5))/R(6) - y(5)/R(5) - (1.0-alpha)*f_trans_2;
 dy(6,1) = -y(6)/R(7) + f_trans_2;
 dy(7,1) = (Ub-y(7))/R(8) - alpha*f_trans_2;
 dy(8,1) = -y(8)/R(9);
end

