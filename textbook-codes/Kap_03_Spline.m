%-- Kap_03_Spline.m
x = [0, 1, 2, 5, 10, 11]; y = [2, 2.2, 1, 0, 0, 3];
xdense = 0:0.01:11; 
y1  = interp1(x,y,xdense,'spline');
y2  = interp1(x,y,xdense,'pchip');
plot(x,y,'o',xdense,y1,xdense,y2,'Linewidth',2)
legend('Wertepaare','Spline','Pchip','Location','North');
xlabel('x'); ylabel('y'); 
