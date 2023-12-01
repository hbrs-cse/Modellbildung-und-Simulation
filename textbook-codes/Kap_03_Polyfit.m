%-- Kap_03_Polyfit.m
x = linspace(-4,4,1000); y = exp(-x.^2);
for i=1:9
   x1 = linspace(-4,4,i);  y1 = exp(-x1.^2);
   p = polyfit(x1,y1,i-1); %-- Interpolationspolynom 
                           %-- vom Grade i-1
   y2=polyval(p,x);        %-- Auswertung des Polynoms
   subplot(3,3,i); plot(x,y,x1,y1,'o',x,y2);
end
