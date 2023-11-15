#-- Kap_08_Masseteilchen_2.jl
using DifferentialEquations, Plots

function dgl!(dy,y,p,t)
  dy[1] = y[2];
  dy[2] = 0.0;
  dy[3] = y[4];
  dy[4] = -9.81;
end

function condition(u,t,integrator) 
    u[3]
end

function affect!(integrator)
    integrator.u[4] = -0.9*integrator.u[4]
end

#-- Bewegung eines Masseteilchens
x0 = 0; z0 = 0; u0 = 10.0; v0 = 20.0; y0 = [x0;u0;z0;v0]; 
tend = 20.0; tspan = [0.0,tend];
cb = ContinuousCallback(condition,affect!)
f = ODEFunction(dgl!)
prob = ODEProblem(f,y0,tspan)
sol = solve(prob,Tsit5(),callback=cb)
println(sol.destats); 
tt = 0.0:0.01:tend;
nt = length(tt); x = zeros(nt); z = zeros(nt);
for i = 1:nt
    x[i] = sol(tt[i])[1];  z[i] = sol(tt[i])[3]
end
plot(x,z,xlabel = "x",ylabel = "z",label = "z(x)")