---
redirect_from:
  - "/07-num-ode/exercises-00-rocket-launch"
interact_link: content/07_num_ode/exercises_00_rocket_launch.ipynb
kernel_name: octave
has_widgets: false
title: 'Simulation eines Raketenstarts'
prev_page:
  url: /07_num_ode/intro
  title: 'Numerik gewöhnlicher Differentialgleichungen'
next_page:
  url: https://github.com/joergbrech/Modellbildung-und-Simulation
  title: 'GitHub repository'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Simulation eines Raketenstarts

Sie sind Wissenschaftler im Head-Bureau for Rocket Simulation *(H-BRS)* und wurden beauftragt einen geplanten Raketenstart zu simulieren. Von der Raketenplattform in Sankt Augustin sollen zwei Satelliten mit einem Gesamtgewicht von 2952 kg in MEO *(Medium Earth Orbit)* auf eine leicht elliptische Laufbahn in 22922 km Höhe gebracht werden, also etwas unterhalb einer geostationären Umlaufbahn.

<img src="../images/gravity_turn.gif" alt="Rocket launch Animation" width="800"/>

Zu Beginn der Planungsphase sollen eine Reihe Simulationen durchgeführt werden, um den Flugplan zu optimieren. Für sie eigentliche eine Routineuntersuchung, aber da ihre Mitarbeiter noch nie etwas von [Versionskontrolle](https://git-scm.com/book/de/v1/Los-geht%E2%80%99s-Wozu-Versionskontrolle%3F) gehört haben, sind leider Teile ihres Simulationsprogrammes abhanden gekommen.

## Ihre Simulationssoftware

Als Matlab-Experte haben Sie eine einfache Simulationssoftware für die frühe Planungsphase entworfen. Ihr Programm simuliert ein *"gravity turn maneuver"* in 2D und besteht aus den folgenden sechs Dateien. *Durch Klicken auf das Plus-Symbol können Sie sich den Inhalt der Dateien anschauen.*

### `rocket_launch.m`

Hauptskript Ihrer Simulation. Hier werden die Simulationsparameter festgelegt, die zugrunde liedenge gewöhnliche Differentialgleichung gelöst und, je nach Bedarf, eine Animation der Simulation gestartet. 

**Hinweis:** *Die Simulation beinhaltet eine Animation und kann deswegen nicht interaktiv auf dieser Seite laufen. Laden Sie sich die Dateien herunter und rechnen Sie lokal auf Ihrem Computer.*

<div markdown="1" class="cell code_cell">
<div class="input_area hidecode" markdown="1">
```matlab
%%file rocket_launch.m
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

% inspired by Ariane flight VA244
params.rocket.m0  = 84852;          % rocket dry mass (inc. payload, without fuel) [kg]
params.rocket.mf  = 660000;         % rocket fuel mass [kg]
params.rocket.mfr = 968;            % rocket ideal mass flow rate [kg/s]
params.rocket.ve  = 8135;           % exit velocity at nozzle [m/s]
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

% inital flight phase is called 'lift off'
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
```
</div>

</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
run rocket_launch.m
```
</div>

</div>

### `rocket_ode.m`

Das Herzstück ihrer Simulation ist das Lösen eines Systems gewöhnlicher Differentialgleichungen erster Ordnung $\dot{\mathbf{q}} = $ `rocket_ode`$(t,\mathbf{q})$ mit dem Löser `ode45`. Die rechte Seite `rocket_ode` ist in dieser Datei implementiert. Dabei ist $\mathbf{q} = [x,y, v_x, v_z, m]^T$ ein Spaltenvektor, der die aktuelle Position $(x,y)$, die aktuelle Geschwindigkeit $(v_x,v_y)$ sowie die aktuelle Masse $m$ der Rakete beschreibt. Leider fehlt ausgerechnet diese Datei.

<div markdown="1" class="cell code_cell">
<div class="input_area hidecode" markdown="1">
```matlab
%%file rocket_ode.m
%% Define right hand side of Rocket ODE
function dq = rocket_ode(t,q)

% q = [z;v;m], z = [x;y], v = [vx;vy]
%
% dq1 = dz  = v
% dq2 = dv = - G*M*z/|z|^3 + F_thrust/m
% dq3 = g(m,tau)

dq = zeros(5,1);

% why is the code missing here???
    
end
```
</div>

</div>

### `mass_flow_rate.m`

Teil der Raketen-ODE `rocket_ode.m` ist die gewöhnliche Differentialgleichung für die Masse $m$ der Rakete $\dot{m}=g(m, \tau)$, wobei $\tau$ die Antriebsdrossel modelliert ($\tau=0$ bedeutet kein Antrieb, $\tau=1$ bedeutet maximaler Antrieb). Die Funktion $g$ ist in `mass_flow_rate.m` implementiert. Ein Raketenantrieb funktioniert nach dem dritten Newton'schen Prinzip über den schnellen Ausstoß von Treibstoff. Je schneller der Teribstoff ausgestoßen wird, desto höher ist der momentane Impuls sowie die Gewichtsabnahme der Rakete. 

<div markdown="1" class="cell code_cell">
<div class="input_area hidecode" markdown="1">
```matlab
%%file mass_flow_rate.m
%% mass flow rate [kg/s]

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

```
</div>

</div>

### `F_thrust.m`

In dieser Datei ist die Funktion $F_{\text{thrust}}(t,\mathbf{q})$ hinterlegt, die abhängig des aktuellen Zustandes den Antrieb der Rakete in $x$- und $y$-Richtung berechnet. Diese Datei haben sie bereits von ihren Kollegen von der Flugplanung erhalten. Der Raketenstart ist aufgeteilt in die Phasen *lift off, pitch over, ascend, 2nd stage,* und *orbit*. Je nach Phase wird in `F_thrust` der Antrieb gedrosselt oder der Angriffswinkel der Rakete geändert. Diese Funktion, zusammen mit `rocket_status.m` bestimmen den Flugplan der Rakete. Optional kann die berechnete Drosselung `throttle` als zweiter Parameter mit ausgegeben werden. Sie wird unteranderem gebraucht um den Massefluss $g$ (bzw. `mass_flow_rate`) zu berechnen.

<div markdown="1" class="cell code_cell">
<div class="input_area hidecode" markdown="1">
```matlab
%%file F_thrust.m
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
    params.rocket.dir = rotate(n, 10);
    
elseif strcmp(params.rocket.status,'ascend')
    
    throttle = 0.;
    
elseif strcmp(params.rocket.status,'2nd stage')
    
    throttle = 0.0625;
    
    % level the rocket horizontally and reduce thrust (i.e. smaller
    % engines)
     n = x/norm(x);
    params.rocket.dir = rotate(n, 90);
    
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
```
</div>

</div>

### `rocket_status.m`

Diese Datei wird von `F_thrust.m` verwendet. Hier wird je nach Zustand der Rakete nach Bestimmten Kriterien die Phase *(lift off, pitch over, ascend, 2nd stage, orbit)* des Raketenstarts gewechselt. In jeder Phase verhält sich die Funktion `F_thrust` etwas anders. Die Syntax ist so gewählt, dass die Funktion vom *event handler* des ODE-Lösers von Matlab aufgerufen wird.

<div markdown="1" class="cell code_cell">
<div class="input_area hidecode" markdown="1">
```matlab
%%file rocket_status.m
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
if height < 0
   params.rocket.status = 'crash'; 
end
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
    if n'*v < 250
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
```
</div>

</div>

### `rocket_visualization.m`

Diese Datei implementiert die Animation sowie Plots des Raketenstarts. Die Syntax der Funktion ist so gewählt, dass die Funktion während der numerischen Integration in Matlab's ODE Löser in jedem Zeitschritt einen visuellen Output liefern kann.

<div markdown="1" class="cell code_cell">
<div class="input_area hidecode" markdown="1">
```matlab
%%file rocket_visualization.m
%% callback function to visualize the rocket launch
%  during numerical integration
function status = rocket_visualization(t,q,flag,simple, event_times)
% This is an OutputFcn for Matlab's ODE solvers. The additional parameter
% simple can be set to true to only print some info to the command window.
% event_times can be passed to determine the transition of flight maneuvers
% from the ode45 output structure


% params contains some simulation as well as physical and rocket parameters 
% and handles is a struct containing handles to the plots
global handles params;

if nargin<4
    if ~params.sim.plot_during_solve
        simple=true;
    else
        simple=false;
    end
end

if params.sim.plot_during_solve && params.sim.saveScreenShots
    warning('You are writing screenshots during an online visualization. This is likely to be slow and create a butt-load of images.')
end

% This happens sometimes. Don't know why
if numel(t)<=0
    status = 0;
    return;
end

if simple
    disp(['t = ' num2str(t(1))])
    status = 0;
    return
end

if ~params.sim.plot_during_solve
    if nargin<5
        rocketstatus = 'unknown';
    else
        % determine rocket status
        status = {'lift off', 'pitch over', 'ascend', '2nd stage', 'orbit'};
        i=1;
        while i <= length(event_times) && t(1) > event_times(i)
            i=i+1;
        end
        rocketstatus = status{i};
    end
else
    rocketstatus = params.rocket.status;
end

if strcmp(flag, 'init')
    
    % initialize plots using initial conditions
    figure('units','normalized','outerposition',[0 0.1 1 1], 'color', 'w')
    
    %% animation
    subplot(2,2,1);
    if t > 0
        s = '+';
    else
        s = '-';
    end
    h = fix(t(1)/3600);
    min = fix(t(1)/60 - h*60);
    sec = abs(t(1) - h*3600 - min*60);
    title(['t = ',s, num2str(h,'%02i'), ':',...
                     num2str(min,'%02i'), ':',...
                     num2str(sec,'%02.3f')])
    
    % plot earth
    plot_earth(t(1),flag);
    set(gca, 'Xtick',[], 'YTick', [], 'ZTick', [], 'box', 'off');
    hold on
    
    % plot target orbit
    r = params.rocket.target_orbit + params.earth.r;
    handles.orbit = rectangle('position',[-r, -r, 2*r, 2*r],...
                              'curvature',[1,1],...
                              'LineStyle','-.',...
                              'EdgeColor',[0 0.4470 0.7410],...
                              'LineWidth',1);

    % current rocket orientation (this does not work well with postprocessed animation)
    handles.currentori = plot([q(1), q(1) + 5e5],...
                              [q(2), q(2)],...
                              'LineWidth',4,...
                              'Color','k');

    % trajectory of rocket
    handles.trajectory = plot(q(1), q(2),'LineWidth',2);
    set(gca,'Fontsize',16)
    xlabel(['status: ',rocketstatus]);
    daspect([1 1 1])
    
    %% mass of fueL
    subplot(2,2,2);
    fuel = (q(5) - params.rocket.m0);
    handles.fuel = plot(t(1),fuel/1000,'LineWidth',2);
    title('mass of propellant')
    xlabel('t [sec]');
    ylabel('propellant mass [t]');
    set(gca,'Fontsize',16)
    
    %% height above sea level
    subplot(2,2,3)
    height = norm(q(1:2)) - params.earth.r;
    handles.orbit  = plot(t(1),params.rocket.target_orbit/1000,...
                          '-.',...
                          'DisplayName','target orbit',...
                          'LineWidth',2);
    hold on
    handles.height = plot(t(1),height/1000,...
                          'DisplayName','trajectory',...
                          'LineWidth',2);
    xlabel('t [sec]');
    ylabel('height [km]');
    title('height above sea level')
    set(gca,'Fontsize',16)
    legend('location','southeast')
    
    %% lateral velocity
    subplot(2,2,4)
    R = params.rocket.target_orbit + params.earth.r;
    veltarget = sqrt(params.G*params.earth.m/R)*3.6;
    %vel = q(3:4)'*[-q(2);q(1)]/norm(q(1:2))*3.6;
    vel = norm(q(3:4));
    handles.targetvel  = plot(t(1),veltarget,...
                              '-.',...
                              'DisplayName','target velocity',...
                              'LineWidth',2);
    hold on
    handles.vel = plot(t(1),vel,...
                       'DisplayName','flight velocity',...
                       'LineWidth',2);
    xlabel('t [sec]');
    ylabel('velocity [km/h]');
    title('lateral velocity')
    set(gca,'Fontsize',16)
    legend('location','southeast')
    
    for i=2:4
        subplot(2,2,i);
        ax = gca;
        outerpos = ax.OuterPosition;
        ti = ax.TightInset; 
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3);
        ax_height = outerpos(4) - ti(2) - ti(4);
        ax.Position = [left bottom ax_width ax_height]; 
    end
    
    
elseif strcmp(flag, 'done')
    % pass
else
    % do this in every time step of tspan
    % first subplot is animation of trajectory. Title is Simulation time.
    
    % rotate earth and update time
    subplot(2,2,1);
    if t > 0
        s = '+';
    else
        s = '-';
    end
    h = fix(t(1)/3600);
    min = fix(t(1)/60 - h*60);
    sec = abs(t(1) - h*3600 - min*60);
    title(['t = ',s, num2str(h,'%02i'), ':',...
                     num2str(min,'%02i'), ':',...
                     num2str(sec,'%02.3f')])
    xlabel(['status: ',rocketstatus]);
    plot_earth(t(1),flag);

    % update current rocket orientation
    set(handles.currentori, 'Xdata', [q(1), q(1) + params.rocket.dir(1)*5e5]);
    set(handles.currentori, 'Ydata', [q(2), q(2) + params.rocket.dir(2)*5e5]);
    
    % update trajectory of rocket
    X= get(handles.trajectory,'Xdata');
    Y= get(handles.trajectory,'Ydata');
    set(handles.trajectory,'Xdata',[X q(1)]);
    set(handles.trajectory,'Ydata',[Y q(2)]);
    
    % update fuel plot
    fuel = (q(5) - params.rocket.m0);
    if ~strcmp(rocketstatus,'orbit')
        T = get(handles.fuel,'Xdata');
        f = get(handles.fuel,'Ydata');
        set(handles.fuel,'Xdata',[T t(1)]);
        set(handles.fuel,'Ydata',[f fuel/1000]);
    end
    
    % update height above sea level plot
    height = norm(q(1:2)) - params.earth.r;
    T = get(handles.height,'Xdata');
    H = get(handles.height,'Ydata');
    set(handles.height,'Xdata',[T t(1)]);
    set(handles.height,'Ydata',[H height/1000]);
    H = get(handles.orbit,'Ydata');
    set(handles.orbit,'Xdata',[T t(1)]);
    set(handles.orbit,'Ydata',[H params.rocket.target_orbit/1000]);
    
    % update velocity plot
    R = params.rocket.target_orbit + params.earth.r;
    veltarget = sqrt(params.G*params.earth.m/R);
    %vel = q(3:4)*[-q(2);q(1)]/norm(q(1:2));
    vel = norm(q(3:4));
    T = get(handles.targetvel,'Xdata');
    H = get(handles.targetvel,'Ydata');
    set(handles.targetvel,'Xdata',[T t(1)]);
    set(handles.targetvel,'Ydata',[H veltarget*3.6]);
    H = get(handles.vel,'Ydata');
    set(handles.vel,'Xdata',[T t(1)]);
    set(handles.vel,'Ydata',[H vel*3.6]);
    
    drawnow;
    
    if params.sim.saveScreenShots
        step=size(dir(['img/*.png']),1);
        filename = ['img/rocket_launch_',num2str(step, '%03i'),'.png'];
        saveas(gcf, filename);
    end
end
    status = 0;
end

function plot_earth(t, flag)
% modified from Ryan Gray
% https://de.mathworks.com/matlabcentral/fileexchange/13823-3d-earth-example

global params handles;

if strcmp(flag, 'init')
    % initialize the earth surface plot
    
    npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
    alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible
    [x, y, z] = ellipsoid(0, 0, 0, params.earth.r, params.earth.r, params.earth.r, npanels);
    handles.globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);

    %% Texturemap the globe

    % Load Earth image for texture map
    % https://commons.wikimedia.org/wiki/File:Land_ocean_ice_2048.jpg
    % NASA Goddard Space Flight Center Image by Reto Stöckli (land surface, 
    % shallow water, clouds). Enhancements by Robert Simmon (ocean color, 
    % compositing, 3D globes, animation). Data and technical support: MODIS 
    % Land Group; MODIS Science Data Support Team; MODIS Atmosphere Group; 
    % MODIS Ocean Group Additional data: USGS EROS Data Center (topography); 
    % USGS Terrestrial Remote Sensing Flagstaff Field Center (Antarctica); 
    % Defense Meteorological Satellite Program (city lights). 
    % [CC BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0/)]
    cdata = imread('Land_ocean_ice_2048.jpg');

    % Set image as color data (cdata) property, and set face color to indicate
    % a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.

    set(handles.globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
    
    view([0.5 0.25 0.5])
end

     %rotate earth once around polar axis every 24 hours
    RE = makehgtform('zrotate',(2*pi/(24*3600))*t);

    % rotate earth so that launch position matches H-BRS coordinates
    RZ = makehgtform('zrotate', -7.18*pi/180);
    RY = makehgtform('yrotate', 50.78*pi/180);

    hgx = hgtransform;
    set(hgx,'Matrix', RY*RZ*RE);
    set(handles.globe,'Parent',hgx);

end
```
</div>

</div>

## Aufgabe 1

Damit ihre Simulationssoftware lauffähig ist, füllen Sie die Datei `rocket_ode.m` mit neuem Inhalt. Die Differentialgleichungen die gelöst werden müssen lauten

$$
\begin{align}
\ddot{\mathbf{z}} &= \frac{\mathbf{F}_{\text{G}} + \mathbf{F}_{\text{thrust}}}{m}, \notag \\
\dot{m} &= g(m, \tau). \notag
\end{align}
$$

Die erste der beiden DGLs beschreibt die Beschleunigung der Rakete, wobei $\mathbf{z} = [x, y]^T$ die aktuelle Position in karthesischen Koordinaten ist. Die Beschleunigung setzt sich zusammen aus der Gravitationsbeschleunigung

$$
\frac{\mathbf{F}_{\text{G}}}{m} = -\frac{G\cdot M}{\|\mathbf{z}\|^3} \mathbf{z}
$$

und der Beschleunigung durch den Raketenantrieb $\mathbf{F}_{\text{thrust}}/m$. Hierbei ist $G=6.67408 \cdot 10^{-11} \frac{\textrm{m}^3}{\textrm{kg}\cdot\textrm{s}}$ die Gravitationskonstante und $M=5.972 \cdot 10^{24} \textrm{kg}$ die Erdmasse.

Die zweite Differentialgleichung beschreibt die Masseänderung der Rakete. Der Massefluss hängt von der aktuellen Masse $m$ der Rakete, sowie der Drosselung $\tau$ ab. Die Funktionen $\mathbf{F}_{\text{thrust}}(t,\mathbf{q})$ sowie $g(m,\tau)$ sind bereits in den Matlab-files `F_thrust.m` und `mass_flow_rate.m` implementiert. Die Drosselung (*throttle*) $\tau$ wird von `F_thrust.m` berechnet und als zweiten Ausgabeparameter bereitgestellt:

```matlab
[Ft, throttle] = F_thrust(t,q)
```

**Hinweis:** Bringen Sie zunächst dieses System von Differentialgleichungen auf erste Ordnung

$$
\dot{\mathbf{q}} = \textrm{rocket_ode}(t, \mathbf{q})
$$

mit $\mathbf{q} = [x,y,v_x, v_y,m]^T$. 

## Aufgabe 2

Wie schätzen Sie die Modellierungstiefe des Simulationsprgrammes ein? Nennen Sie die wichtigsten Modellvereinfachungen und diskutieren Sie, welche am kritischsten sind. Welche Modellvereinfachungen würden Sie als erstes angehen, wenn sie das Modell verfeinern würden? Wie schätzen Sie den Aufwand dafür ein?

## Zusatzaufgabe

Bestimmen Sie auf Grundlage ihrer Simulation welchen Beschleunigungen die Satelliten während des Raketenstarts ausgesetzt sind. Laut Satellitenhersteller sind die kritischen Komponenten für Beschleunigungen bis 10 G ausgelegt. Erfüllt der von Ihnen simulierte Raketenstart diese Anforderungen? In welcher Phase des Raketenstarts sind die Beschleunigungen am höchsten? Erstellen Sie ein Plot, der den Betrag der Beschleunigung in G über die Zeit während des Starts darstellt.
