#-- Kap_08_Energienetzwerk.jl
using DifferentialEquations, Plots, NLsolve

c1 = -3.1037; c2 = 1.0015; c3 = 0.0032; c4 = 1.3984e-09; c5 = 0.4303; c6 = 1.5*0.9562;
R0 = 0.2; R1 = 0.5; C = 4000.0; q_max = 36000.0; 

function dae!(dy, y, p, t)
    U0 = y[1]; U1 = y[2]; iV = y[3]; iPV = y[4]; iB = y[5]; uB = y[6]; qB = y[7];
    dy[1] = U0;
    dy[2] = iB + iPV - iV;
    dy[3] = verbraucher(t) - iV*(U1-U0);
    dy[4] = c1 + c2*iPV + c3*(U1-U0) + c4*(exp(c5*iPV+c6*(U1-U0))-1);
    dy[5] = U1-U0 - (ruhespannung(qB/q_max) - uB - R0*iB);
    dy[6] = iB/C - uB/(R1*C);
    dy[7] = -iB;
    nothing
end

function alg!(dy_alg, y_alg)
    y = [y_alg; 0; 0.25*q_max]; dy = similar(y)
    dae!(dy,y,[],0.0)
    dy_alg[1:5] = dy[1:5]
 end
   

function verbraucher(t)
  ts = range(3600.0,36000.0,step = 3600.0)
  return 50.0*einaus(t,ts,10.0)
end

function ruhespannung(soc)
  pp = [6.8072,-10.5555,6.2199,10.2668]; #-- Polynomkoeffizienten
  return ((pp[1]*soc+pp[2])*soc+pp[3])*soc+pp[4]; #-- Polynomauswertung 
end

function fstep(t,t0,dauer)
#-- atanh(0.999) = 3.8002
  s = 3.8002/dauer;
  return (tanh(s*(t-t0))+1.0)/2.0
end
    
function einaus(t,ts,schaltzeit)
   y = 0.0;
   for i=1:2:length(ts)
       y = y + fstep(t,ts[i],schaltzeit);
   end
   for i=2:2:length(ts)
       y = y - fstep(t,ts[i],schaltzeit);
   end
   return y
end

#-- Energienetzwerk --
 y0 = zeros(7,1); dy = similar(y0)
 y_alg = copy(y0[1:5]); dy_alg = similar(y_alg);
 res = nlsolve(alg!,y_alg); y0 = [res.zero; 0.0; 0.25*q_max]
 M = zeros(7,7); M[6,6] = 1.0; M[7,7] = 1.0;
 f = ODEFunction(dae!, mass_matrix = M);
 tspan = [0.0, 36000.0]; prob = ODEProblem(f, y0, tspan, [])
 sol = solve(prob, Rodas5P(),tstops=range(3600.0,36000.0,step = 3600.0)); println(sol.destats);
 p1 = plot(sol.t/3600,sol'[:,[1,2,6]], linewidth = 2, xlabel = "Zeit /h", ylabel = "V", title = "Spannungen", label = ["U0" "U1" "uB"],legend=:inside)
 p2 = plot(sol.t/3600,sol'[:,[3,4,5]], linewidth = 2, xlabel = "Zeit /h", ylabel = "A", title = "Ströme", label = ["iV" "iPV" "iB"],legend=:bottom)
 p3 = plot(sol.t/3600,sol'[:,7]/q_max, linewidth = 2, xlabel = "Zeit /h", ylabel = "soc", title = "Ladezustand", label = "soc",legend=:topleft)
 p = plot(p1,p2,p3)
 