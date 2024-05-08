#-- Kap_11_Autobahn.jl
using DifferentialEquations, Plots

function ode!(dy, y, p, t)
    dx,N = p
    lam = uvonrho(0.0); #-- = u_max 
    flux = y.*uvonrho.(y); 
    yL, yR = recover(y); fluxL, fluxR = recover(flux); #-- Werte auf Zellgrenzen
    fR = 1.0/6.0*uvonrho(1.0/6.0); #-- linke Randbedingung
    for i = 1:n
       fL = fR;
       fR = 0.5*(fluxL[i+1] + fluxR[i+1] - lam*(yR[i+1]-yL[i+1]));
       dy[i] = -(fR - fL)/dx;
    end
    nothing
end

function recover(y)
  yL = [2*y[1]-y[2]; y]; yR = [y; 2*y[end]-y[end-1]]
  return yL, yR
end

function uvonrho(rho)
  u_max = 50; rho_max = 1/6; rho_krit = 1/100; 
  c = u_max/log(rho_krit/rho_max);
  if (rho > rho_max)
    u = 0.0
  elseif (rho > rho_krit)
    u = c*log(rho/rho_max)
  else
    u = u_max
  end
  return u
end
   
#-- Linienmethode mit FD-Ortsdiskretisierung fuer Erhaltungsgleichungen 
#-- zur Loesung des Autobahnmodells
  n = 1000; L = 100000.0; dx = L/n; 
  x = range(dx/2, L-dx/2, n); #-- Zellenmittelpunkte
  param = dx, n
  y0 = zeros(n); #-- Anfangswerte
  for i=1:n 
    if (x[i] < 50000) y0[i] = 1/6; end
  end
  p1 = plot(x/1000,y0,linewidth = 2,xlabel="x / km",
                              ylabel="rho(x,t)",title="Fahrzeugdichte",label="t=0")
  p2 = plot(x/1000,uvonrho.(y0),linewidth = 2,xlabel="x / km",
                              ylabel="u(x,t)",title="Geschwindigkeit",label="t=0")
  f = ODEFunction(ode!);   tspan = [0.0,900]; 
  prob = ODEProblem(f, y0, tspan, param); tol = 1.0e-5
  sol = solve(prob, Tsit5(),reltol=tol,abstol=tol)
  display(sol.stats) 
  ts = range(300,tspan[2],step=300.0)
  for tt in ts
    global p1, p2
    p1 = plot!(p1,x/1000,sol(tt),linewidth = 2,label="t=$tt")
    p2 = plot!(p2,x/1000,uvonrho.(sol(tt)),linewidth = 2,label="t=$tt")
  end
  p = plot(p1,p2,layout=(2,1)); display(p)
