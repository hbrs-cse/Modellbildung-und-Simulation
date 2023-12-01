#-- Kap_03_SmoothingSpline.jl
using Dierckx                   # spline1D
using Plots
#--
x = 0:0.15:2*pi; y = 3*sin.(4*x)+rand(length(x));
scatter(x, y, label="Wertepaare",linewidth=2)
spl = Spline1D(x,y, k=3, s=2)   # smoothing Spline
xx = 0:0.01:2*pi; yy = spl(xx)
p=plot!(xx,yy, label="Smoothing Spline",linewidth=2,dpi=200,xlabel="x",ylabel="y")
