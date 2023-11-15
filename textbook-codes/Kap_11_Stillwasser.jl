#-- Kap_11_Stillwasser.jl
using DifferentialEquations, Plots, SparseArrays
include("Kap_11_Recover.jl")

function ode!(dy, y, p, t)
 ...
end

function bc2(QL,EL,QR,ER) #-- Randbedingungen Stillwasser
   return 0.0, EL, QR, 0.5*(QR/3.0)^2 + 9.81*3.0
end

function jacstru(n)
   J = spzeros(n,n); 
   for i = 1:n
       i0 = max(1,i-5); i1 = min(n,i+5); J[i,i0:i1] .= 1; 
   end
   J
end

#-- Loesung der Flachwassergleichungen mit der Linienmethode
  n = 200; L = 1000.0; dx = L/n; x = range(dx/2,L-dx/2,n); #- Zellenmittelpunkte
  S0 = sin.(2*pi*x/100); h = 3.0 .+ 0.1*sin.(pi*x/30) .- S0; #-- Stillwasser
  Q = zeros(n); ks = 10.0; tend = 24*3600.0; f_bc = bc2 
  ...
  f = ODEFunction(ode!; jac_prototype=jacstru(neq));   
  prob = ODEProblem(f, y0, tspan, param); tol = 1.0e-4
  sol = solve(prob, Rodas5P(),reltol=tol,abstol=tol)
  ...
  p2 = plot!(p2,x,Q,linewidth = 2,label="t=$(tspan[2])",ylims=(-0.01,0.01))
  ...