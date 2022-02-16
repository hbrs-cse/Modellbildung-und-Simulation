% your code here

clearvars

d     = 1;
y0    = 0.999*d;
xmax  = 10;
i     = 1;
h0    = 0.5;
x     = 0;
rtol  = 1e-5;
hmin  = 1e-5;

y(1)  = y0;
while x < xmax
    i        = i+1;
    h        = h0;
    y_alt    = y(i-1) + h*dgl(y(i-1),d);
    err      = 1;
    while err > rtol% && h > hmin
        h     = h/2;
        y_neu = y(i-1) + h*dgl(y(i-1),d);
        err   = abs(y_neu - y_alt)/abs(y_alt);
        y_alt = y_neu;
    end
    errspan(i)   = err;
    x        = x + h;
    xspan(i) = x;
    y(i)     = y_neu;
end

plot(xspan,y)

function ydot = dgl(y,d)
    ydot = -y/sqrt(d^2-y^2);
end