%% Define right hand side of Rocket ODE
function dq = rocket_ode(t,q)

% q = [z;v;m], z = [x;y], v = [vx;vy]
%
% dq1 = dz  = v
% dq2 = dv = - G*M*z/|z|^3 + F_thrust/m
% dq3 = dm/dt

dq = zeros(5,1);

% why is the code missing here???
    
end