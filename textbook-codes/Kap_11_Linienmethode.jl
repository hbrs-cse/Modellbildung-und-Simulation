# Kap_11_Linienmethode.jl
using DifferentialEquations, Plots

function ode!(dy, y, p, t)
    u,D,dx,N = p
    dy[1] = -u*(y[2]-0)/(2*dx) + D*(y[2]-2*y[1]+0)/dx^2;
    for i=2:N-1
      dy[i] = -u*(y[i+1]-y[i-1])/(2*dx) + D*(y[i+1]-2*y[i]+y[i-1])/dx^2;
    end
    dy[N] = -u*(y[N]-y[N-1])/dx;
    nothing
end

# Linienmethode zur Loesung des Konvektions-Diffusionsproblems
  N = 1000; L = 60000.0; dx = L/(N+1); 
  x = range(dx,L,length=N)#step=dx); # Ortsgitter
  u = 1; D = 1000;  param = u,D,dx,N   # Parameter
  y0 = exp.(-1.0e-7*(x.-15000).^2);  # Anfangswerte
  p = plot(x,y0,linewidth = 2,xlabel="Fließstrecke x",
      ylabel="Konzentration c(x,t)",label="")
  f = ODEFunction(ode!); tspan = [0.0,12*3600.0]; 
  prob = ODEProblem(f, y0, tspan, param)
  sol = solve(prob, Rodas5P())
  println(sol.destats);
  ts = range(3600.0,12*3600.0,step=3600.0)
  for tt in ts
    global p
    p = plot!(p,x,sol(tt),linewidth = 2,label="")
  end
  display(p)
