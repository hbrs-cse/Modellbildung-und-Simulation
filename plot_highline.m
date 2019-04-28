function handle = plot_highline(z, L)
% plots the highline according to the (x,y)-coordinates stored in the flat
% vector z = [x1,y1, x2, y2, x3, y3, ...] and the length L of the highline.

N = length(z)/2;

if N - floor(N) > 1e-15
    error("The length of the input vector z must be divisble by 2!");
end


positions_x = z(1:2:end)' + L*linspace(1/(N+1), 1 - 1/(N+1), N);
positions_y = z(2:2:end)';

positions_x = [0 positions_x L];
positions_y = [0 positions_y 0];

handle = plot(positions_x, positions_y);

xlabel('x [m]')
ylabel('y [m]')
title('highline displacement')

end