%-- Kap_03_Curvefit.m
x = 0.0:0.15:2*pi; y = 3*sin(4*x)+0.5*rand(1,length(x));
f = fittype('a*sin(b*x)'); 
pp = fit(x',y',f,'StartPoint',[2 3.5])
xx = 0:0.01:2*pi;
yy = pp.a*sin(pp.b*xx);
plot(x,y,'o',xx,yy,'linewidth',2)
title('Curfe Fit MATLAB'); xlabel('x'); ylabel('y');
