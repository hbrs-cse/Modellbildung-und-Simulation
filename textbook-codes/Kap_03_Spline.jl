#-- Kap_03_Spline.jl
using Plots
using DataInterpolations
#--
x = [0.0, 1, 2, 5, 10, 11]; y = [2, 2.2, 1, 0, 0, 3];
scatter(x, y, label="Wertepaare")
A = CubicSpline(y,x)  #-- Achtung x,y vertauscht
plot!(A, label="Spline")
A = BSplineInterpolation(y,x,2,:ArcLen,:Average)
p=plot!(A, label="quadratischer B-Spline",xlabel = "x",ylabel="y",linewidth=2,
        dpi=300,show=true)
