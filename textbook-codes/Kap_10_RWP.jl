# Kap_10_RWP.jl
function fcn(y,param)
    N, x, dx = param
    f = zeros(2*N); 
    for i=1:N-1
       y_i = y[2*i-1:2*i]; 
       y_ip1 = y[2*i+1:2*i+2];
       f_i = dgl(x[i],y_i); f_ip1 = dgl(x[i+1],y_ip1);
       f[2*i-1:2*i] = y_ip1 - y_i -dx/2*(f_i + f_ip1);
    end
    f[2*N-1:2*N] = rb(y[1:2],y[2*N-1:2*N]); # RB
    return f
end

function  dgl(x,y) # Differentialgleichungen
  return [y[2], 180.0*x^3*y[1]/y[2]]
end
   
function rb(ya,yb) # Randbedingungen
    return [ya[2]-6, yb[1]-64]
end   

function newton(fcn,x0,tol,param)
    n = length(x0); h = zeros(n).+2*tol;  x = x0; 
    global nit = 0;
    while (norm(h,Inf) > tol) && (nit < 20) # 20 Iterationen
        global nit = nit + 1
        J = jac(x,fcn,param);  b = fcn(x,param)
        h = -J\b; x = x + h
    end
    return x
end

function jac(x,f,param)
    n = length(x); J = zeros(n,n)
    f0 = f(x,param); x1 = copy(x)
    for i = 1:n
        h = sqrt(eps())*max(1.0e-8,abs(x[i]))
        x1[:] = x;   x1[i] = x1[i] + h
        J[:,i] = (f(x1,param)-f0)/h  # komplette Spalte von J
    end
    return J
end

using LinearAlgebra, Plots
# Ortsgitter und Startwerte
 N = 50; x = LinRange(1.0, 2.0, N); dx = x[2]-x[1]; param = N, x, dx
 y = zeros(2*N).+1.0;
# Newtonverfahren
 tol = 1.0e-8; y = newton(fcn,y,tol,param);  
 y1 = y[1:2:2*N]; 
 max_err = maximum(abs.(y1-x.^6)); println(max_err)
 scatter(x,y1,label="numerische Lösung")
 plot!(x,x.^6, linewidth=2, label = "analytische Lösung",xlabel = "x",ylabel = "y(x)")
 
