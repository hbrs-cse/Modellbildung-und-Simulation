%% event function for the rocket_ode
function [value,isterminal,direction] = rocket_status(t,q)
% this function controls the transitions of flight phases. It checks for
% the following events:
%
%  1: transition 'lift off' to 'pitch over' maneuver
%  2: transition 'pitch over' to 'ascend' maneuver
%  3: transition 'ascend' to '2nd stage' maneuver
%  4: transition '2nd stage' to 'orbit' maneuver
%  5: crash

global params;

x = q(1:2);
v = q(3:4);
m = q(5);

value      = -ones(5,1);
isterminal = zeros(5,1);
direction  = -ones(5,1);

% terminate if height falls below zero
height = norm(x) - params.earth.r;
value(5) = height;
isterminal(5) = 1;

if strcmp(params.rocket.status,'lift off')
    value(1) = 1;
    % switch to pitch over maneuver at a given velocity
    if v'*v > 400^2
        value(1) = -1;
        params.rocket.status = 'pitch over';
    end
end

if strcmp(params.rocket.status,'pitch over')
    value(2)=1;
    % switch to ascend at a certain height
    if height > 0.0575*params.rocket.target_orbit
        value(2) = -1;
        params.rocket.status = 'ascend';
        % to do: drop boosters and core stage
        % booster: 2*33000 kg, core stage: 14700 kg
    end
end

if strcmp(params.rocket.status,'ascend')
    value(3)=1;
    % ignite second stage if radial velocity falls below threshold
    n = x/norm(x);
    if n'*v < 50
        value(3)=-1;
        params.rocket.status = '2nd stage';
    end
end

if strcmp(params.rocket.status,'2nd stage')
   value(4)=1;
   % label status as 'orbit' as soon as propellant is gone
   if abs(mass_flow_rate(m,1)) < 1e-3
       value(4)=-1;
       params.rocket.status = 'orbit';
   end       
end

end