#-- Kap_07_Strassenkante.jl
using LinearAlgebra, Plots, DelimitedFiles #-- für readdlm()

function fit_fcn(x,params)
    p = 0.025; #-- bleibt unveraendert
    a = params[1];   b = params[2];   c = params[3]
    y = a .+ b./(exp.((x.-c)/p) .+1)
    return y
 end

 function fcn(x)
    a = x[1];   b = x[2];   c = x[3];   p = 0.025; 
    f0 = fit_fcn(xi,x)
    expp = exp.( (xi.-c)/p )
    f = zeros(3)
    f[1] = sum(f0-yi)
    f[2] = sum( (f0-yi)./(expp .+ 1) )
    f[3] = sum( (f0-yi)*b/p.* expp./(expp.+1).^2 )
    return f
end

function newton(fcn,x0,tol)
    h = [2*tol];  x = x0; nit = 0
    while (norm(h) > tol) && (nit < 20) #-- max. 20 Iterationen
        nit = nit + 1
        J = jac(x,fcn);  b = fcn(x)
        h = -J\b; x = x + h
    end
    return x
end

function jac(x,f)
    n = length(x); J = zeros(n,n)
    f0 = f(x); x1 = copy(x)
    for i = 1:n
        h = sqrt(eps())*max(1.0e-8,abs(x[i]))
        x1[:] = x;   x1[i] = x1[i] + h
        J[:,i] = (f(x1)-f0)/h  #-- komplette Spalte von J
    end
    return J
end

#-- Hauptprogramm
 strasse = readdlm("strasse.txt")
 xi = strasse[:,1];   yi = strasse[:,2]
 nx = length(xi)
 plot(xi,yi,linecolor = :blue, label = "Originaldaten")
 #-- Startwerte 
 a = minimum(yi);  b = maximum(yi) - a
 diff = abs.(yi[2:nx]-yi[1:nx-1]);  
 diffmax, ii = findmax(diff)
 c = xi[ii]; x0 = [a;b;c]
#-- Newtonverfahren
 tol = 1.0e-6; x0 = [a;b;c]
 xres = newton(fcn,x0,tol);   println("xres = ",xres)
 y_fit = fit_fcn(xi,xres)
 plot!(xi,y_fit, linewidth=2,linecolor = :red, label = "gefittete Funktion")

