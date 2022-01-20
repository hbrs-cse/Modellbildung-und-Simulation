%% boundary condition, tspan, 'suggestions' for dt
u0 = 0;
tmin = 0;
tmax = 8*pi;
dt_init = 0.2;
dt_min = 1e-08;
rtol = 0.001; %how much may the higher order deviate from lower order?

%% initiate values
u = zeros(ceil((tmax-tmin)/dt_init),1);
u(1) = u0;
t = zeros(ceil((tmax-tmin)/dt_init),1);
timestep = 1;
ti = tmin;

while ti < tmax
    err = 2*rtol;
    dt = dt_init;
    
    u_m = u(timestep);
    ti = t(timestep);
    
    [u_m_new,err] = RK(ti,dt,u_m);
    while err > rtol && dt > dt_min
        err;
        dt = dt/2;
        [u_m_new,err] = RK(ti,dt,u_m);
    end
    
    timestep = timestep + 1;
    u(timestep) = u_m_new;
    t(timestep) = ti + dt;
    
end

%% graphics
scatter(t,u)

%% calculating RK 3rd and 4th order
function [u_m_new,err] = RK(ti,dt,u_m)
    
    K_1 = ode(ti,u_m);
    K_2 = ode(ti+dt/2,u_m+dt/2*K_1);
    K_3h = ode(ti+dt/2,u_m+dt/2*K_2);
    K_3l = ode(ti+dt,u_m+dt*(-K_1+2*K_2));
    K_4h = ode(ti+dt,u_m+dt/2*K_3h);
    
    u_m4 = u_m + dt*(K_1/6 + K_2*2/6 + K_3h*2/6 + K_4h/6);
    
    u_m_euler = u_m + dt*K_1;
    
    % calculating error
    err = abs((u_m4-u_m_euler)/(u_m4+u_m_euler));
    
    u_m_new = u_m_euler;
end

%% finally, the ode...
function udot = ode(t,u)
    if t < pi
        udot = 0;
    else
        udot = -sin(t);
    end
end