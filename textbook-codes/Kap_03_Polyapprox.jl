#-- Kap_03_Polyapprox.jl
using Polynomials
using Plots
#--
x = range(0.0,stop=5.0,length=1000); y = exp.(-x);
x1 = range(0.0,stop=5.0,length=11); y1 = exp.(-x1);
p = plot(layout=(2,2), legend = false)
for i = 1:4
  pp = fit(x1,y1,i-1);  y2 = pp.(x);
  plot!(p,x1,y1, marker=:o, line = :scatter, subplot = i);
  plot!(x,y, subplot = i); plot!(x,y2, subplot = i)
end
display(p)
