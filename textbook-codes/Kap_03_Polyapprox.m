%-- Kap_03_Polyapprox.m
x = linspace(0,5,1000); y = exp(-x);
x1 = linspace(0,5,11); y1 = exp(-x1);
for i=1:4
  p = polyfit(x1,y1,i-1);
  y2 = polyval(p,x);
  subplot(2,2,i); plot(x,y,x1,y1,'o',x,y2);
end
