#-- Kap_07_Masseteilchen_1.jl
using DifferentialEquations, Plots

function dgl!(dy,y,p,t)
#-- dy wird inplace geändert
  dy[1] = y[2];
  dy[2] = 0.0;
  dy[3] = y[4];
  dy[4] = -9.81;
end

#-- Bewegung eines Masseteilchens
x0 = 0; z0 = 0; u0 = 10.0; v0 = 20.0; y0 = [x0;u0;z0;v0]; 
tend = 5.0; tspan = [0.0,tend];
f = ODEFunction(dgl!)
prob = ODEProblem(f,y0,tspan)
sol = solve(prob,Tsit5())
println(sol.destats); 
tt = 0.0:0.1:tend;
nt = length(tt); x = zeros(nt); z = zeros(nt);
for i = 1:nt
    x[i] = sol(tt[i])[1];  z[i] = sol(tt[i])[3]
end
println("err_x:",abs(x0+u0*tend-x[nt]))
println("err_z:",abs(z0+v0*tend-0.5*9.81*tend^2-z[nt]))
p=plot(x,z,seriestype=:scatter,xlabel = "x",ylabel = "z",dpi=300)
