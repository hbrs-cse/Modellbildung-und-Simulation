# Kap_11_Waerme2D.jl
using DifferentialEquations, Plots, SparseArrays

function dgl!(dy, y, p, t)
    N, dx, tau, c, rho, dicke, T0, ix1, ix2, iy, P = p
    T = reshape(y,N,N); k = 0;
    for j = 1:N
      for i = 1:N
        k = k + 1
        if (i==1) 
            dy[k] = T[i+1,j] - T[i,j];
        elseif (i==N)
            dy[k] = T[i-1,j] - T[i,j];
        else
            dy[k] = T[i+1,j] - 2*T[i,j] + T[i-1,j];
        end
        if (j==1) 
            dy[k] = dy[k] + T[i,j+1] - T[i,j];
        elseif (j==N)
            dy[k] = dy[k] + T[i,j-1] - T[i,j];
        else
            dy[k] = dy[k] + T[i,j+1] - 2*T[i,j] + T[i,j-1];
        end
        dy[k] = dy[k]*tau/dx^2 - 50*(T[i,j]-T0)/(c*rho*dicke);
        if (t < 60) && (i==iy) && ((j==ix1)||(j==ix2))
          dy[k] = dy[k] + P/(c*rho*dx^2*dicke);  
        end
      end
    end
    nothing
end

function jacstru(N)
  J = spzeros(N*N,N*N); k = 0;
  for j = 1:N
    for i = 1:N
      k = k+1; J[k,k] = 1
      if (i>1) J[k,k-1]=1; end
      if (i<N) J[k,k+1]=1; end
      if (j>1) J[k,k-N]=1; end
      if (j<N) J[k,k+N]=1; end
    end
  end
  J
end

# Wärmeleitung 2D --
lam = 237.0; c = 900.0; rho = 2700.0; tau = lam/(c*rho); 
T0 = 20.0; P = 10.0; L = 0.1; dicke = 0.005;
N = 200; dx = L/(N-1); 
x_mesh = range(0,L,length=N); y_mesh = range(0,L,length=N);
ix1 = findmin(abs.(x_mesh .- 0.025))[2]; ix2 = findmin(abs.(x_mesh .- 0.075))[2]
iy = findmin(abs.(y_mesh .- 0.05))[2]; 
param = N, dx, tau, c, rho, dicke, T0, ix1, ix2, iy, P
y0 = zeros(N*N) .+ T0; tspan = [0.0, 1000.0];

J = jacstru(N)
f = ODEFunction(dgl!;jac_prototype=J)
prob = ODEProblem(f, y0, tspan, param)
@time sol = solve(prob, Rodas5P(),reltol=1.0e-6,abstol=1.0e-6)
println(sol.destats);
t = [10,30,60,61,200,1000]
p=plot(layout=(2,3), legend = false)
for i = 1:length(t)
  T_2d = reshape(sol(t[i]),N,N)
  contour!(p,x_mesh,y_mesh,T_2d, levels = 8, contour_labels = true, title = "t = "*string(t[i]), subplot = i)
end
display(p)
