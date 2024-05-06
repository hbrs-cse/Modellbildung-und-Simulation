#-- Kap_07_RK3simple.jl
function rk3_simple(fcn,tspan,y0,atol,rtol,param)
#--------
#-- fcn: ODE-Funktion
#-- tspan: Zeitintervall
#-- y0: Anfangswerte
#-- atol,rtol: Toleranzen
#-- param: optionale Parameter zur Weitergabe an fcn
#--
#-- Initialisierung --------
  nfevals = 0; nsteps = 0; nrejected = 0; #-- Statistik
  uround=eps(); fac1=0.2; fac2=6.0;   #-- Zeitschrittsteuerung
#-- Koeffizienten der Methode
  stage = 3; b = [1.0/6.0;1.0/6.0;2.0/3.0];  bd = [1.0/2.0;1.0/2.0;0.0];
  a = [0.0;1.0;1.0/2.0]; alpha = [0.0 0.0 0.0;1.0 0.0 0.0;1.0/4.0 1.0/4.0 0.0];
#-- Ausgabe-Parameter [T,Y] --
  neq = length(y0); t0=tspan[1]; tend=last(tspan); t=t0; y = y0; 
  T = Float64[]; Y = Array{Float64}(undef,0,neq); 
  T = [T;t0];  Y = [Y;transpose(y0)]
#-- Schrittweite --
  if (tend <= t0)  
    println("tend<= t0 !!, exit");  return T,Y;  
   end
   hmax=abs(tend-t0)/5.0; hinit=1.0e-6*abs(tend-t0);  h=min(hinit,hmax);  
#-- Hauptschleife --
   done = false;  reject = false; 
   K = zeros(neq,stage);  speicher = zeros(neq)
   while ~done
      if (t+0.1*h == t) || (abs(h) <= uround)    #-- Schrittweite zu klein
          println("Error exit of rk3_simple at time t=",t,",  step size to small h=",h)
          return T,Y
      end
      if (t+h) >= tend h=tend-t; else h=min(h,0.5*(tend-t));  end
#---- Zeitschritt --------
      if reject==false      
         fcn(speicher,y,param,t); nfevals = nfevals+1; K[:,1] = speicher;
      end
      for i=2:stage
          sum_K = K*alpha[i,:];
          fcn(speicher,y.+h*sum_K,param,t+h*a[i]); nfevals=nfevals+1; 
          K[:,i] = speicher
      end
      sum_1 = h*K*b; sum_2 = h*K*bd; ynew = y .+ sum_1;
#---- Fehlertest --------
      SK = atol .+ rtol.*max.(abs.(y),abs.(ynew));
      err = sum( ((sum_1-sum_2)./SK).^2 ); err = max(floatmin(),sqrt(err/neq));
      fac = 0.9 * err^(-1/3);  fac=min(fac2,max(fac1,fac)); hnew=h*fac;
      if (err <= 1.0)  # --- Schritt akzeptiert
        reject = false; nsteps = nsteps+1; told = t; t=t+h; 
        if (abs(tend-t) < uround) done=true; end  #-- erfolgreiches Ende 
        y = ynew; T=[T;t]; Y=[Y;transpose(ynew)]; 
      else  # --- Schritt wird verworfen
        reject = true; nrejected = nrejected+1;  
      end
      h = min(hnew,hmax);
   end
#--
   println("Erfolgreiche Schritte: ", nsteps);
   println("Verworfene Schritte: ", nrejected);
   println("Funktionsauswertungen: ", nfevals);
   return T,Y
end
    