#-- Kap_08_Pendel.jl
using DifferentialEquations, Plots, LinearAlgebra

function dae!(dy, y, p, t)
    m = 1.0; g = 9.81;
    dy[1] = y[2]
    dy[2] = 2*y[5]*y[1]/m
    dy[3] = y[4]
    dy[4] = 2*y[5]*y[3]/m -g
    dy[5] = y[2]^2 + y[4]^2 + 2*y[5]/m*(y[1]^2 + y[3]^2) - g*y[3] #-- Index-1
#    dy[5] = y[1]*y[2] + y[3]*y[4] #-- Index-2
nothing
end

#-- Pendel als DAE
M = Matrix{Float64}(I,5,5); M[5, 5] = 0.0;
f = ODEFunction(dae!, mass_matrix = M);
L = 2.0; y0 = [L; 0.0; 0.0; 0.0; 0.0]; tspan = [0.0, 40.0];
prob = ODEProblem(f, y0, tspan)
sol = solve(prob, Rodas4P2())
println(sol.destats);
p1=plot(sol, vars=[1,3], linewidth = 2, xlabel = "t", label = ["x(t)" "z(t)"], title="RelTol=1.0e-3")
sol = solve(prob, Rodas4P2(),reltol = 1e-4)
println(sol.destats);
p2=plot(sol, vars=[1,3], linewidth = 2, xlabel = "t", label = ["x(t)" "z(t)"], title="RelTol=1.0e-4")
plot(p1,p2,layout=(2,1))
