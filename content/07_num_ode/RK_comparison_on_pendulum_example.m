clearvars
close all

y0=[1,1]; % Anfangsbedingung
global omega
omega = 1;
h = 0.01;
tmax = 10*pi;
tspan = 0:h:tmax;
h_euler = h;
tspan_euler = 0:h_euler:tmax;

%% ideal solution
solution = cos(tspan);

%% ode45 solution
tic
[t_ode45,y_ode45] = ode45(@dgl,tspan,y0);
time_ode45 = toc

%% explicit euler solution
tic
timestep = 1;
y_euler = zeros(2,length(tspan_euler));
y_euler(:,1) = y0;
for t = tspan_euler(1:end-1)
    timestep = timestep + 1;
    ti = tspan_euler(timestep);
    yi = y_euler(:,timestep-1);
    y_euler(:,timestep) = y_euler(:,timestep-1) + h_euler*dgl(ti,yi);
end
time_euler = toc

%% RK3 solution
tic
timestep = 1;
y_RK3 = zeros(2,length(tspan));
y_RK3(:,1) = y0;
for t = tspan(1:end-1)
    timestep = timestep + 1;
    ti = tspan(timestep);
    yi = y_RK3(:,timestep-1);
    
    K_1  = dgl(ti,     yi);
    K_2  = dgl(ti+h/2, yi+h/2*K_1);
    %K_3h = dgl(ti+h/2, yi+h/2*K_2);
    %K_4h = dgl(ti+h,   yi+h*K_3h);
    %y_RK4(:,timestep) = y_RK4(:,timestep-1) + h*(K_1/6 + K_2*2/6 + K_3h*2/6 + K_4h/6);
    
    K_3l = dgl(ti+h,   yi+h*(-K_1+2*K_2));
    y_RK3(:,timestep) = y_RK3(:,timestep-1) + h*(K_1/6 + K_2*4/6 + K_3l/6);
end
time_RK3 = toc

hold on
plot(t_ode45,y_ode45(:,1))
plot(tspan_euler,y_euler(1,:));
plot(tspan,y_RK3(1,:));

legend('Lösung mit ode45','Lösung mit Euler','Lösung mit RK3')

error_euler = sum((y_euler(1,:) - y_ode45(:,1)).^2);
error_RK3 = sum((y_RK3(1,:) - y_ode45(:,1)).^2);

function dy = dgl(t,y)
    global omega
    dy = zeros(2,1);
    dy(1) = y(2);
    dy(2) = -omega*sin(y(1));
end