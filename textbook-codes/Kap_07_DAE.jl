#-- Kap_07_DAE.jl
using OrdinaryDiffEq, Plots

function dae!(dy, y, p, t)
    dy[1] = y[2]
    dy[2] = y[1]^2 + y[2]^2 - 1.0
    nothing
end

#-- Einfaches DAE-System
M = zeros(2, 2); M[1, 1] = 1.0;
f = ODEFunction(dae!, mass_matrix = M);
y0 = [0.0; 1.0]; tspan = [0.0, 3.0];
prob = ODEProblem(f, y0, tspan)
sol = solve(prob, Rodas4())
display(sol.stats) 
p1 = plot(sol, xlabel = "t", ylabel = "y(t)", label = ["y_1(t)" "y_2(t)"], legend = :bottom, title = "Rodas4")
sol = solve(prob, Rodas4P())
p2 = plot(sol, xlabel = "t", ylabel = "y(t)", label = ["y_1(t)" "y_2(t)"], legend = :right, title = "Rodas4P")
sol = solve(prob, Rodas4P2())
p3 = plot(sol, xlabel = "t", ylabel = "y(t)", label = ["y_1(t)" "y_2(t)"], legend = :bottom, title = "Rodas4P2")
p = plot(p1, p2, p3)
