#-- Kap_03_FitUI.jl
using LsqFit, Plots
#--
U0 = 1.2; R = 0.3; s = 2; t = 50;
x = 10 .^(range(-1.0,stop=1.0,length=20)); 
y = U0 .+ R*x .+ s*log.(t*x.+1);
y = y.*(1 .+ 0.3*rand(length(x)));
scatter(x, y,label="Messwerte")
model(x, p) = U0 .+ p[1]*x .+ p[2]*log.(p[3]*x .+ 1)
p0 = [1.0, 1.0, 1.0]
cfit = curve_fit(model, x, y, p0)
pp = cfit.param; println(pp)
xx = 0.1:0.01:10; yy = model(xx,pp)
p=plot!(xx,yy,xlabel = "Strom i",ylabel = "Spannung U",
        label="Curve Fit Julia",legend=:topleft,dpi=300)
