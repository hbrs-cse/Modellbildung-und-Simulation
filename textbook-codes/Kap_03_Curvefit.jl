#-- Kap_03_Curvefit.jl
using LsqFit, Plots
#--
x = 0.0:0.15:2*pi; y = 3*sin.(4*x)+0.5*rand(length(x));
scatter(x, y, label="Wertepaare")
model(t, p) = p[1]*sin.(p[2]*t)
p0 = [2.0, 3.5]
fit = curve_fit(model, x, y, p0)
pp = fit.param
xx = 0:0.01:2*pi; yy = model(xx,pp)
p=plot!(xx,yy, label="Curve Fit Julia",xlabel = "x",ylabel="y",
               linewidth=2,dpi=300,show=true)
