%% mass and mass flow rate [kg/s]

% assume constant (throttle-dependent) mass flow rate 
% until propellant is depleted

function dotm = mass_flow_rate(m, throttle)

global params;
if m<= params.rocket.m0
    dotm = 0;
else
    dotm = -throttle*params.rocket.mfr;
end

end