function animate_highline(L,t,q,person_on_highline)

dt = 0.2;                % time step size for animation
Ta = min(t);           % start time
Te = max(t);           % end time

N = floor(size(q,2)/4);  % get number of mass points from q
n = 2*N;

%% animating
timestep=0;
for ti=Ta:dt:Te
    timestep = timestep + 1;
    
    %get current displacement (interp1 is too slow)
    [~,i]=min(abs(t-ti));
    qi = q(i,:);
    
    %position of mass points = initial position + displacement
    positions_x = qi(1:2:n)+L*linspace(1/(N+1),1-1/(N+1),N);
    positions_y = qi(2:2:n);
    
    % x and y values of the highline nodes
    Xvalues=[0 positions_x L];
    Yvalues=[0 positions_y 0];
    
    if nargin>3
        % positions of the pedestrians
        posx = person_on_highline.positions(ti);
        posy = interp1(Xvalues,Yvalues,posx);
        if posx < L
            posxs(timestep) = posx;
            posys(timestep) = posy;
        else
            posxs(timestep) = L;
            posys(timestep) = 0;
        end
    end
    
    %% plot the animation of the highline with pedestrians
    cla;
    hold on
    plot(Xvalues,Yvalues,'-b', 'linewidth',1.5);
    if nargin>3
        scatter(posx,posy,50,'fill');
        plot(posxs,posys,'-r', 'linewidth', 1.5);
    end
    %axis equal
    box on
    ylim([-2,0.1]);
    xlim([0,L]);
    title(['t = ',num2str(ti,'%1.2f'),' s'])
    xlabel('horizontal direction [m]')
    ylabel('vertical direction [m]')
    
    drawnow
end