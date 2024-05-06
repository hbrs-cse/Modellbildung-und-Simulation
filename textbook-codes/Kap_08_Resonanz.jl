#-- Kap_08_Resonanz.jl
using DifferentialEquations, Plots, LaTeXStrings, LinearAlgebra
gr()

m = 100.0; k = 100.0; d = 1; A = [0.0 1.0; -k/m -d/m]; 

function dgl!(dy, y, p, t)
    A, alpha, omega = p
    dy[:] = A*y
    dy[2] = dy[2] + alpha*sin(omega*t)
    nothing
end

#-- Masse-Feder-Daempfer-System --
 omega = imag(eigvals(A)[1]); y0 = [1.0; 0.0]; f = ODEFunction(dgl!); 
 tspan = [0.0, 60.0]; alpha = 0.0;  param = A, alpha, omega
 prob = ODEProblem(f, y0, tspan, param); sol = solve(prob, Tsit5()); 
 p1 = plot(sol, vars = (1), linewidth = 2, 
           xlabel = "Zeit", ylabel = "Auslenkung", 
           title = "Keine Anregung", legend=false)
 tspan = [0.0, 600.0]; alpha = 1.0;  param = A, alpha, omega
 prob = ODEProblem(f, y0, tspan, param); sol = solve(prob, Tsit5()); 
 p2 = plot(sol, vars = (1), linewidth = 2, 
           xlabel = "Zeit", ylabel = "Auslenkung", 
           title = L"Anregung $\sin(\omega_0 t)$", legend=false)
 tspan = [0.0, 60.0]; alpha = 1.0;  param = A, alpha, 0.5*omega
 prob = ODEProblem(f, y0, tspan, param); sol = solve(prob, Tsit5()); 
 p3 = plot(sol, vars = (1), linewidth = 2, 
                xlabel = "Zeit",  ylabel = "Auslenkung", 
                title = L"Anregung $\frac{1}{2} \sin(\omega_0 t)$", legend=false)
 p = plot(p1,p2,p3)
