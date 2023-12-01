%-- Kap_03_FitUI.m
U0 = 1.2; R = 0.3; s = 2; t = 50;
x = logspace(-1,1,20); y = U0 + R*x + s*log(t*x+1);
y = y.*(1+0.3*rand(1,length(y)));
f = fittype('1.2+a*x+b*log(c*x)'); 
pp = fit(x',y',f,'StartPoint',[1 1 1])
xx = 0.1:0.01:10
yy = U0 + pp.a*xx+pp.b*log(pp.c*xx);
plot(x,y,'o',xx,yy,'linewidth',2)
xlabel('Strom i'); ylabel('Spannung U');
legend('Messwerte','Curve Fit MATLAB','Location','Northwest'); 
