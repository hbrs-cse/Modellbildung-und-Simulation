#-- Kap_11_Deichbruch.jl
using DifferentialEquations, Plots
include("Kap_11_Recover.jl")

function ode!(dy, y, p, t)
    dx, n, g, b, S0, ks, f_bc = p
    A = y[1:2:end]; Q = y[2:2:end]; z = S0 + A/b; E = 0.5*(Q./A).^2 + g*z; 
    QL,QR = recover_weno(Q); EL,ER = recover_weno(E); zL,zR = recover_weno(z); 
    QL_bc, EL_bc, QR_bc, ER_bc = f_bc(QL[1],EL[1],QR[n+1],ER[n+1]) #---- RB
    Q_R = QL_bc; E_R = EL_bc; LF1_R = 0.0; LF2_R = 0.0
    for i = 1:n
       Q_L = Q_R; E_L = E_R; LF1_L = LF1_R; LF2_L = LF2_R;
       u_i = Q[i]/A[i]; h_i = A[i]/b; 
       if i==n
         Q_R = QR_bc; E_R = ER_bc; LF1_R = 0.0; LF2_R = 0.0
      else
         lam_i = max(u_i+sqrt(g*h_i), Q[i+1]/A[i+1]+sqrt(g*A[i+1]/b)); 
         Q_R = 0.5*(QR[i+1] + QL[i+1]);  E_R = 0.5*(ER[i+1] + EL[i+1]); 
         LF1_R = - 0.5*lam_i*b*(zR[i+1]-zL[i+1]); 
         LF2_R = - 0.5*lam_i*(QR[i+1]-QL[i+1]);
       end
       dy[2*i-1] = -(Q_R - Q_L)/dx - (LF1_R - LF1_L)/dx;
       Sf = 0.0;
       if (ks > 0)  Sf = g*A[i]*u_i*abs(u_i)/(ks^2 * cbrt(h_i)^4);  end
       dy[2*i] = -u_i*(Q_R - Q_L)/dx - A[i]*(E_R - E_L)/dx -
                                   (LF2_R - LF2_L)/dx - Sf;
    end
    nothing
end

function bc1(QL,EL,QR,ER) #-- Randbedingungen Deichbruch
   return 0.0, EL, QR, 0.5*(QR/1.0)^2 + 9.81*1.0
end

#-- Loesung der Flachwassergleichungen mit der Linienmethode
  n = 200; L = 1000.0; dx = L/n; x = range(dx/2,L-dx/2,n); #- Zellenmittelpunkte
  S0 = zeros(n); h = 10.0 .- S0; h[x .> 500] .= 1.0; #-- Deichbruch
  Q = zeros(n); ks = 0.0; tend = 30.0; f_bc = bc1 
  p1 = plot(x,h + S0,linewidth = 2,xlabel="x / m", ylabel="w(x,t)",
            title="Wasserspiegelhöhe",label="t=0")
  p2 = plot(x,Q,linewidth = 2,xlabel="x / m", ylabel="Q(x,t)",
            title="Volumenfluss",label="t=0")
  g = 9.81;  b = 1.0; param = dx, n, g, b, S0, ks, f_bc
  neq = 2*n; tspan = [0.0,tend]; y0 = zeros(neq)
  for i = 1:n y0[2*i-1] = h[i]*b; y0[2*i] = Q[i]; end 
  f = ODEFunction(ode!); prob = ODEProblem(f, y0, tspan, param); tol = 1.0e-4
  sol = solve(prob, Tsit5(),reltol=tol,abstol=tol)
  w = sol(tspan[2])[1:2:end]/b+S0; Q = sol(tspan[2])[2:2:end]
  p1 = plot!(p1,x,w,linewidth = 2,label="t=$(tspan[2])")
  p2 = plot!(p2,x,Q,linewidth = 2,label="t=$(tspan[2])")
  p1 = plot!(p1,x,S0,linewidth = 2,label="Sohlhöhe")
  p = plot(p1,p2,layout=(2,1)); display(p)
