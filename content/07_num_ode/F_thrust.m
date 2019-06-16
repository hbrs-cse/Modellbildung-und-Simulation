%% Thrust of rocket engine
function [F, throttle] = F_thrust(t,q)
% This function takes the arguments of the rocket_ode function and
% calculates angine thrust for a specific state of the rocket. Depending on
% the stage, throttle and angle of attack can be varied. The status is
% determined in the event function rocket_status.m

global params;

x = q(1:2);
m = q(5);

if t(1) == params.sim.tspan(1)
    params.rocket.status = 'lift off';
    params.rocket.dir = [1;0];
    params.rocket.dir= params.rocket.dir/norm(params.rocket.dir);
end


% change throttle and angle of attack, depending on current launch status
if strcmp(params.rocket.status,'lift off')
    % initiate pitch over maneuver as soon as velocity reaches a threshold
    % velocity
    throttle = 1.;
    
elseif strcmp(params.rocket.status,'pitch over')
    
    throttle = 1.;
    
    % tilt the rocket
    n = x/norm(x);
    params.rocket.dir = rotate(n, 6);
    
elseif strcmp(params.rocket.status,'ascend')
    
    throttle = 0.;
    
elseif strcmp(params.rocket.status,'2nd stage')
    
    throttle = 0.0625;
    
    % level the rocket horizontally and reduce thrust (i.e. smaller
    % engines)
     n = x/norm(x);
    params.rocket.dir = rotate(n, 83);
    
else
    throttle = 0;
end

%calculate current thrust based on rocket equation
mfr = mass_flow_rate(m,throttle);
F = -params.rocket.dir*mfr* params.rocket.ve;

end

function vec = rotate(vec,degree)
  vec = [cosd(degree), -sind(degree); sind(degree), cosd(degree)]*vec;
end