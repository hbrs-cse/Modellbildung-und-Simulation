clearvars
close all

y0          = 0.99; %[1,0]; % Anfangsbedingung
tmax        = 2;
h           = 0.1;
tspan       = 0:h:tmax;
h_euler     = h/4;
tspan_euler = 0:h_euler:tmax;
h_ode45     = 0.0001;
tspan_ode45 = 0:h_ode45:tmax;

%% ode45 solution
tic
[t_ode45,y_ode45] = ode45(@dgl,tspan_ode45,y0);
time_ode45 = toc

%% explicit euler solution
tic
timestep = 1;
y_euler = zeros(length(tspan_euler),1);
y_euler(1) = y0;
for t = tspan_euler(1:end-1)
    timestep = timestep + 1;
    ti = tspan_euler(timestep-1);
    yi = y_euler(timestep-1);
    K_1 = dgl(ti,yi);
    y_euler(timestep) = y_euler(timestep-1) + h_euler*K_1;
end
time_euler = toc

%% RK3 solution
tic
timestep = 1;
y_RK3 = zeros(length(tspan),1);
y_RK3(1) = y0;
for t = tspan(1:end-1)
    timestep = timestep + 1;
    ti = tspan(timestep-1);
    yi = y_RK3(timestep-1);
    
    K_1  = dgl(ti,     yi);
    K_2  = dgl(ti+h/2, yi+h/2*K_1);
    %K_3h = dgl(ti+h/2, yi+h/2*K_2);
    %K_4h = dgl(ti+h,   yi+h*K_3h);
    %K_ges= (K_1/6 + K_2/3 + K_3h/3 + K_4h/6);
    K_3l = dgl(ti+h,   yi+h*(-K_1+2*K_2));
    K_ges= (K_1/6 + K_2*4/6 + K_3l/6);
    
    y_RK3(timestep) = y_RK3(timestep-1) + h*K_ges;
end
time_RK3 = toc

%plot(tspan,cos(tspan))
plot(t_ode45,     y_ode45)
hold on
plot(tspan_euler, y_euler)
plot(tspan,       y_RK3)

%legend('Ideale Lösung: cos(x)','Lösung mit ode45','Lösung mit Euler','Lösung mit RK4')
legend('Lösung mit ode45','Lösung mit Euler','Lösung mit RK3')

%error_ode45 = sum((y_ode45 - solution).^2);
error_euler = sum((y_euler - interp1(t_ode45,y_ode45,tspan_euler).').^2);
error_RK3 = sum((y_RK3 - interp1(t_ode45,y_ode45,tspan).').^2);

function dy = dgl(t,y)
    dy = -y / sqrt(abs(1 - y^2));
end