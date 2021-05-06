function animate_bridge(L,t,q,pedestrians)

dt = 0.2;                % time step size for animation
Ta = min(t);             % start time
Te = max(t);             % end time

N = floor(size(q,2)/4);  % get number of mass points from q
n = 2*N;

timestep=0;
for ti=Ta:dt:Te
    timestep = timestep + 1;
    
    %get current displacement (interp1 is too slow)
    [~,i]=min(abs(t-ti));
    qi = q(i,:);
    
    %position of mass points = initial position + displacement
    positions_x = qi(1:2:n)+L*linspace(1/(N+1),1-1/(N+1),N);
    positions_y = qi(2:2:n);
    
    % x and y values of the bridge nodes
    Xvalues=[0 positions_x L];
    Yvalues=[0 positions_y 0];
    
    if nargin>3
        % positions of the pedestrians
        posx = pedestrians.positions(ti);
        posy = interp1(Xvalues,Yvalues,posx);
    end
    
    %% plot the animation of the bridge with pedestrians
    cla;
    hold on
    plot(Xvalues,Yvalues,'kx');
    if nargin>3
        scatter(posx,posy,50,'fill');
    end
    axis equal
    box on
    ylim([-10,2]);
    xlim([0,L]);
    title(['t = ',num2str(ti,'%1.2f'),' s'])
    xlabel('horizontal direction [m]')
    ylabel('vertical direction [m]')
    
    drawnow
end