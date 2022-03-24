clearvars
close all

aufgabe = 7;
[f,fdot,ti,u_m,dt] = findaufgabe(aufgabe);
quiver_on = 1;
dx = dt/2; % for vectorfield
h  = dt;
dx_euler = h;
dx_RK    = h;

%% prepare gif-export
filename = 'vectorfield_animated.gif';
h = figure(1);
h.Position = [50 50 1000 1000];
ax = axes(h);

%% intervals for x and y
xmin = 0;
xmax = 2*pi;
x = xmin:dx:xmax;
y_min = -1.4;
y_max = 1.4;
if aufgabe == 7
    y_min = -0.9;
    y_max = 0.9;
end
dy = dx;
y = y_min:dy:y_max;
[x_mesh,y_mesh] = meshgrid(x,y);

%% vector-fields
if quiver_on == 1
    u = ones(size(x_mesh))*dx/2;
    v = fdot(x_mesh,y_mesh)*dx/2;
    quiver(x_mesh,y_mesh,u,v,0,'linewidth',0.05,'DisplayName','dy/dx(y_i,x_i) = ODE');
    axis equal
end
hold on
xfine = linspace(xmin,xmax,1000);
if aufgabe == 7
    [t_ode45,y_ode45] = ode45(@dgl,xfine,u_m);
    f = @(t,u_m) interp1(t_ode45,y_ode45,t);
    plot(t_ode45,y_ode45,'DisplayName','near-ideal solution with ode45');
else
    plot(xfine,f(xfine),'DisplayName','ideal function');
end
legend

[x_RK,y_RK,dt_RK,df_RK,K_i] = findvectors(ti,u_m,dt,fdot,f);

%% plotting RK solution
timestep = 1;
x = xmin:dx_RK:xmax;
y_RK3 = zeros(length(x),1);
y_RK3(1) = f(xmin);
for t = x(2:end-1)
    timestep = timestep + 1;
    [u_m_new,err] = RK(x(timestep-1),dx_RK,y_RK3(timestep-1),fdot);
    %t_euler(timestep) = t;
    y_RK3(timestep) = u_m_new;
end
%plot(x,y_RK3,'linewidth',1,'color','m','DisplayName','RK solution');

%% plotting euler solution
timestep = 1;
x = xmin:dx_euler:xmax;
y_euler = zeros(length(x),1);
y_euler(1) = f(xmin);
for t = x(1:end-1)
    timestep = timestep + 1;
    %t_euler(timestep) = t;
    y_euler(timestep) = y_euler(timestep-1) + dx_euler*fdot(x(timestep-1),y_euler(timestep-1));
end
plot(x,y_euler,'linewidth',1,'color','b','DisplayName','Euler solution');
% ylim([-1,8])
% xlim([-2,2])
% axis equal
if aufgabe == 5
    xlim([0.15 0.65])
    ylim([0.55 0.95])
elseif aufgabe == 1
    ylim([0.85,1.025])
    xlim([0,0.25])
%     axis equal
elseif aufgabe == 7
    ylim([0.5,1])
    xlim([0,0.3])
%     axis equal
end

% legend('dy/dx(y_i,x_i) = ODE','ideal function','RK solution','Euler solution');
printfirstgif(h,filename)

quiver(x_RK(1),                     y_RK(1),                    dt_RK(1),     df_RK(1),'off','linewidth',1,'color','r','DisplayName','K_1 = Euler step 1');
% legend('dy/dx(y_i,x_i)','ideal function','RK solution','Euler solution','K_1 = Euler');
printgif(h,filename)
quiver(x_RK(2),                     y_RK(2),                    dt_RK(2),   df_RK(2),'off','linewidth',1,'color','g','DisplayName','K_2 @u_m + dt*K_1/2');
% legend('dy/dx(y_i,x_i)','ideal function','RK solution','Euler solution','K_1 = Euler','K_2');
printgif(h,filename)

%% final step
quiver(x_RK(3),y_RK(3),dt_RK(3),df_RK(3),'off','linewidth',1.25,'color','g','DisplayName','RK step 1');
% legend('dy/dx(y_i,x_i)','RK solution','Euler solution','ideal function','K_1 = Euler','K_2','K_3','','','step');
printgif(h,filename)
%quiver(x_RK(5),y_RK(5),dt_RK(5),df_RK(5),'off','linewidth',1.25,'color','m');
plot(x,y_RK3,'linewidth',1,'color','m','DisplayName','RK solution');
printgif(h,filename)

% if quiver_on == 1
%     legend('dy/dx(y_i,x_i)','RK solution','Euler solution','ideal function','K_1 = Euler','K_2','K_3','step');
% else
%     legend('ideal function','K_1 = Euler','K_2','K_3','step','RK solution','Euler solution');
% end

% if aufgabe == 5
%     xlim([0.15 0.65])
%     ylim([0.55 0.95])
% elseif aufgabe == 1
%     ylim([0.8,1.025])
%     xlim([0,0.25])
% %     axis equal
% end

%% printing gifs
function printfirstgif(h,filename)
    drawnow
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,filename,'gif','DelayTime',2,'Loopcount',inf)
end
function printgif(h,filename)
    drawnow
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,filename,'gif','DelayTime',2,'WriteMode','append');
end

%% calculating RK 3rd and 4th order
function [u_m_new,err] = RK(ti,dt,u_m,fdot)
    
    K_1 = fdot(ti,u_m);
    K_2 = fdot(ti+dt/2,u_m+dt/2*K_1);
    %K_3h = fdot(ti+dt/2,u_m+dt/2*K_2);
    %K_3l = fdot(ti+dt,u_m+dt*(-K_1+2*K_2));
    %K_4h = fdot(ti+dt,u_m+dt/2*K_3h);
    
    %u_m4 = u_m + dt*(K_1/6 + K_2*2/6 + K_3h*2/6 + K_4h/6);
    
    u_m3 = u_m + dt*(K_2);
    u_m_euler = u_m + dt*K_1;
    
    % calculating error
    err = abs((u_m3-u_m_euler)/(u_m3+u_m_euler));
    
    u_m_new = u_m3;
end

function [x_RK,y_RK,dt_RK,df_RK,K_i] = findvectors(ti,u_m,dt,fdot,f)
    %% RK vectors
    %initializing vectors
    %...for coordinates
    x_RK = [];
    y_RK = [];
    %...for values
    dt_RK = [];
    df_RK = [];
    K_i   = [];

    %% K_1 = ode(ti,u_m);
    x_RK(1) = ti;
    y_RK(1) = u_m;
    dt_RK(1) = dt; % = dt;
    K_1 = fdot(ti,u_m);
    K_i(1)=K_1;
    df_RK(1) = K_1; % = K_1;
    %% K_2 = ode(ti+dt/2,u_m+dt/2*K_1);
    x_RK(2) = ti+dt/2;
    y_RK(2) = u_m+dt/2*K_1; % = u_m+dt/2*K_1;
    dt_RK(2) = dt; % = dt;
    K_2 = fdot(x_RK(2),y_RK(2));
    K_i(2)=K_2;
    df_RK(2) = K_2; %= K_2;
%     %% K_3 = ode(ti+dt/2,u_m+dt*(-K_1+K_2));
%     x_RK(3) = ti+dt;
%     y_RK(3) = u_m+dt*(-K_1+2*K_2); %u_m+dt*(-K_1+2*K_2);
%     dt_RK(3) = dt/6; % = dt;
%     K_3 = fdot(x_RK(3),y_RK(3));
%     K_i(3)=K_3;
%     df_RK(3) = K_3/6; % = K_3;
    %% u_m3 = u_m + dt*(K_1/6 + K_2*4/6 + K_3*1/6);
    x_RK(3) = ti;
    y_RK(3) = u_m;
    dt_RK(3) = dt;
    df_RK(3) = K_2;
    %             % K_4 = ode(ti+dt,u_m+dt/2*K_3);
    %             x_RK(4) = ti+dt;
    %             y_RK(4) = u_m+dt/2*K_3;
    %             dt_RK(4) = dt;
    %             K_4 = fdot(ti+dt,u_m+dt/2*K_3);
    %             df_RK(4) = K_4;
    %             % u_m4 = u_m + dt*(K_1/6 + K_2*2/6 + K_3*2/6 + K_4/6);
    %             x_RK(5) = ti;
    %             y_RK(5) = u_m;
    %             dt_RK(5) = dt;
    %             df_RK(5) = K_1/6 + K_2*2/6 + K_3*2/6 + K_4/6;

    % scaling fdot arrows to dt
    df_RK = df_RK*dt;
end

%% Aufgaben aus http://www.math-grain.de/download/m2/dgl/homogen-2/2-ordnung-5.pdf
function [f,fdot,ti,u_m,dt] = findaufgabe(aufgabe)
    if aufgabe == 1
    %% y' = sin (t)
        f = @(t,u_m) cos(4*t);
        fdot = @(t,u_m) -4*sin(4*t);

        % applying RK-vectors at...
        ti = 0;
        u_m = f(ti);
        % using timestep of...
        dt = 0.1;

    elseif aufgabe == 2
    %% y' = -4 e^(-4t)
        f = @(t,u_m) exp(-4*t);
        fdot = @(t,u_m) -4*exp(-4*t);

        % applying RK-vectors at...
        ti = 0.1;
        u_m = f(ti);
        % using timestep of...
        dt = 0.2;

    elseif aufgabe == 3
    %% y is step-function (for stronger gradient)
        a = -1; % Höhe der Straße
        b = 1; % Höhe der Kante
        c = 2; % Lage der Kante
        p = 0.05; % Steuert die Steilheit
        f = @(t,u_m) a + b./(exp((t-c)/p)+1);
        fdot = @(t,u_m) - b*exp((t-c)/p) ./ (p*(exp((t-c)/p)+1).^2);

        % applying RK-vectors at...
        ti = 1.9;
        u_m = f(ti);
        % using timestep of...
        dt = 0.2;

    elseif aufgabe == 4
    %% y'=1.1*x*y --> y = c_1 * e^(x^1.1)
        c_1 = 0.05;
        f = @(t,u_m) c_1 * exp(t.^1.1);
        fdot = @(t,u_m) 2*t.*u_m;

        % applying RK-vectors at...
        ti = 1.5;
        u_m = f(ti);
        % using timestep of...
        dt = 0.2;

    elseif aufgabe == 5
    %% für Steigung: y = e^(-x^2)
        f = @(t,u_m) exp(-2*t.^2);
        fdot = @(t,u_m) -2*2*t.*u_m;

        % applying RK-vectors at...
        ti = 0.2;
        u_m = f(ti);
        % using timestep of...
        dt = 0.2;
    elseif aufgabe == 6
    %% y' = 2 cos (2t)
        f = @(t,u_m) sin(2*t);
        fdot = @(t,u_m) 2*cos(2*t);

        % applying RK-vectors at...
        ti = 0.5;
        u_m = f(ti);
        % using timestep of...
        dt = 0.2;
    elseif aufgabe == 7
    %% y' = 1/
        fdot = @(t,u_m) -u_m ./ sqrt(abs(1 - u_m.^2));
        xmin = 0;
        xmax = 2*pi;
        xfine = linspace(xmin,xmax,1000);
        % applying RK-vectors at...
        ti = 0;
        u_m = 0.95;
        %
        [t_ode45,y_ode45] = ode45(@dgl,xfine,u_m);
        f = @(t,u_m) interp1(t_ode45,y_ode45,t);

        % using timestep of...
        dt = 0.1;
    end
end

function dy = dgl(t,y)
    dy = -y ./ sqrt(abs(1 - y^2));
end