#-- Kap_07_FederMasse.jl
using DifferentialEquations, Plots

function dgl!(dy,y,p,t)
  m = 10.0; k = 1.0;
  dy[1] = y[2];
  dy[2] = -k/m*y[1]-p/m*y[2];
  nothing
end

#-- Masse-Feder-Dämpfer-System
 f = ODEFunction(dgl!); y0 = [1.0;0.0]; 
 d = 1.0; tspan = [0.0,100.0];
 prob = ODEProblem(f,y0,tspan,d)
 sol = solve(prob,Tsit5())
 println(sol.destats); 
 p1 = plot(sol,idxs=[1],xlabel="t",ylabel = "y(t)",label="",title = "Tsit5, d = 1")
 sol = solve(prob,Rodas5P())
 println(sol.destats); 
 p2 = plot(sol,idxs=[1],xlabel="t",ylabel = "y(t)",label="",title = "Rodas5P, d = 1")
#-- d=1000
 d = 1000.0; tspan = [0.0,10000.0];
 prob = ODEProblem(f,y0,tspan,d)
 sol = solve(prob,Tsit5())
 println(sol.destats); 
 p3 = plot(sol,idxs=[1],xlabel="t",ylabel = "y(t)",label="",title = "Tsit5, d = 1000")
 sol = solve(prob,Rodas5P())
 println(sol.destats); 
 p4 = plot(sol,idxs=[1],xlabel="t",ylabel = "y(t)",label="",title = "Rodas5P, d = 1000")
 p=plot(p1,p2,p3,p4)
 