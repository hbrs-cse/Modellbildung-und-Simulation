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