#-- Kap_03_Polyfit.jl
using Polynomials
using Plots
#--
x = range(-4.0,stop=4.0,length=1000); y = exp.(-x.^2);
p=plot(layout=(3,3), legend = false)
for i = 1:9
  if i==1
    x1 = [4.0];
  else
    x1 = range(-4.0,stop=4.0,length=i); 
  end
  y1 = exp.(-x1.^2);
  pp = fit(x1,y1,i-1);  y2 = pp.(x);
  plot!(p,x1,y1, marker=:o, line = :scatter, subplot = i); 
  plot!(x,y, subplot = i); plot!(x,y2, subplot = i)
end
display(p)
