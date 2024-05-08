#-- Kap_07_Taschenuhr.jl
using DifferentialEquations, Plots

include("Kap_07_RK3simple.jl")

function dgl_uhr!(dy,y,p,t)
#-- dy wird inplace geändert
  dy[1] = -y[1]/sqrt(1.0-y[1]^2)
end

#-- Taschenuhrproblem
tspan = [0.0,1.5]; y0 = [0.999]
f = ODEFunction(dgl_uhr!)
prob = ODEProblem(f,y0,tspan)
@time sol = solve(prob,Tsit5(),abstol = 1e-4, reltol = 1e-4)
display(sol.stats) 
P = plot(sol, label="Tsit5")
y_tsit5 = sol(1.5)
#--
@time t,y = rk3_simple(dgl_uhr!,tspan,y0,1.0e-4,1.0e-4,[])
plot!(t,y, marker=:o, line = :scatter, label="rk3_simple")
y_rk3_simple = y[end]
#--
@time sol = solve(prob,Tsit5(),abstol = 1e-14, reltol = 1e-14)
display(sol.stats) 
y_exact = sol(1.5)
println("err_tsit5: ",abs.(y_exact-y_tsit5))
println("err_rk3_simple: ",abs.(y_exact[1]-y_rk3_simple))
display(P)
