# Kap_10_Wasserspiegellage.jl
g = 9.81; B = 2.0; Ks = 30.0; uL = 0.2; hR = 1.0;

function dgl!(du,u,p,x) # Differentialgleichungen
    h = u[1]; v = u[2]; A = B*h; R = A/(B+2*h);
    S_f = v*abs(v)/(Ks^2 * (R^4)^(1/3));
    M = [v h;g*h v*h];
    du[:] = inv(M)*[0.0; -g*h*(dS_0(x)+S_f)];
end
   
function bc!(res, u, p, t) # Randbedingungen
    res[1] = u[1][2] - uL 
    res[2] = u[end][1] - hR 
end

function S_0(x)
    return -0.0001*x .+ 0.2*sin.(x/500.0)
end
function dS_0(x)
    return -0.0001 + 0.2*cos(x/500.0)/500.0 
end
  

using LinearAlgebra, Plots, DifferentialEquations 
 L = 10000.0; xspan = (0.0,L);  # Ortsintervall
 bvp = BVProblem(dgl!, bc!, [hR,uL], xspan)
 sol = solve(bvp, MIRK4(),dt=50)
 p=plot(layout=(2,1))
 plot!(p,sol.t,S_0(sol.t),label="S_0(x)",linewidth = 2,
                          xlabel="Fließstrecke",ylabel="Höhe",subplot=1)
 plot!(p,sol.t,sol'[:,1].+S_0(sol.t),label="z(x)",linewidth = 2,subplot=1)
 plot!(p,sol.t,sol'[:,2],label="u(x)",linewidth = 2,
                         xlabel="Fließstrecke" ,ylabel="Geschwindigkeit",subplot=2)
 
 
