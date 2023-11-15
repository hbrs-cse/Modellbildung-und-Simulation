#-- Kap_04_Integral.jl
rohr(x) = sqrt(4-x^2)

function mein_trapez(f,a,b)
#-- zusammengesetzte Trapezregel mit 100 Teilintervallen
 n = 100;   h = (b-a)/n
 summe = f(a) + f(b);  x = a
 for i=1:n-1
    x = x+h
    summe = summe + 2.0*f(x)
 end
 summe = h*summe/2
 return summe
end

#---
using QuadGK 	#-- für quadgk
a = 1.0; b = 2.0;
q_1 = quadgk(rohr,a,b) 
q_2 = mein_trapez(rohr,a,b)
println("q_1 = ",q_1," q_2 = ",q_2," diff = ",abs(q_1[1]-q_2))
#--
