%% 2D rocket gravity turn simulation

% this script simulates a gravity turn rocket launch in 2D cartesian
% coordinates (3D earth is just for visualization)

% The rocket is modelled as a single stage point mass, with constant nozzle
% exit velocity and constant mass flow rate. The launch consists of a
% launch, tiltover, ascend and orbit maneuver that only differ in the angle
% of attack of the rocket. No aerodynamics are considered. Both the rocket
% and the earth are point masses. The physical parameters of the rocket are
% very unlikely to be realistic...

% dependencies:
%   rocket_ode.m
%   mass_flow_rate.m
%   F_thrust.m
%   rocket_status.m
%   rocket_visualization.m

clear;
close all;

%% define parameters inside global struct

global params;

params.G = 6.67408e-11;        % gravitational constant [m3 kg-1 s-2]

params.earth.r  = 6378137;     % radius of earth at the equator [m]
params.earth.m  = 5.972e24;    % mass of the earth [kg]
params.earth.p0 = 101325;      % atmospheric pressure at sea level [Pa]

% inspired by Ariane flight VA244
params.rocket.m0  = 84852;          % rocket dry mass (inc. payload, without fuel) [kg]
params.rocket.mf  = 660000;         % rocket fuel mass [kg]
params.rocket.mfr = 998;            % rocket ideal mass flow rate [kg/s]
params.rocket.ve  = 8180;           % exit velocity at nozzle [m/s]
params.rocket.target_orbit =  22.922e6; % target orbit [m]

% some parameters for the simulation
params.sim.tspan             = [0 24*3600];   % simulation time [s]
params.sim.plot_during_solve = false;        % set to true to update graphics during 
                                             % numerical integration
params.sim.saveScreenShots   = false;        % set to true to save screenshots
                                             % in subdir "img"

%% initial conditions (position, velocity and mass)
% save rocket status (position, velocity and mass) in new variable q
% q = [x0;x1;v0;v1,m] = [x,v], x = [x0;x1], v=[v0;v1]

params.rocket.status = 'lift off';

% initial position and velocity
xinit = [params.earth.r; 0];
vinit = [0;0];

% initial mass is dry mass + mass of propellant
minit = params.rocket.m0 + params.rocket.mf;

qinit = [xinit; vinit; minit];

%% solve the ODE

opts = odeset('AbsTol',1e-8,'RelTol',1e-8,...
              'OutputFcn',@rocket_visualization,...
              'Events',@rocket_status);
sol = ode45(@rocket_ode, params.sim.tspan, qinit, opts);

%% plot the animation

if ~params.sim.plot_during_solve
    t = linspace(sol.x(1), sol.x(end), 120);
    q = deval(t,sol);
    
    rocket_visualization(params.sim.tspan(1),qinit, 'init', false, sol.xe);
    for i = 1:length(t)
       ti = t(i);
       qi = q(:,i)';
       rocket_visualization(ti,qi,[],false, sol.xe);
    end
end