# Kap_11_Recover.jl
function recover_weno(y)
# Zellenmittelwerte auf Zellgrenzen interpolieren
# L = upwind, R = downwind, WENO 3. Ordnung
   n = length(y); yL = zeros(n+1); yR = zeros(n+1)
   yL[1] = 11/6*y[1]-7/6*y[2]+y[3]/3; yR[1] = yL[1]; # Randwerte
   yL[2] = y[1]/3+5/6*y[2]-y[3]/6; 
   yL[n+1] = 11/6*y[n]-7/6*y[n-1]+y[n-2]/3; yR[n+1] = yL[n+1]; 
   yR[n] = y[n]/3+5/6*y[n-1]-y[n-2]/6; 
   for i=2:n-1
      yR[i], yL[i+1] = weno3(y[i-1:i+1]);
   end
   return yL, yR
end
  
function weno3(y) # y = [y1,y2,y3]
   ep = 1.0e-6; p = 0.6;
   uL = y[2]-y[1]; uC = y[3]-2*y[2]+y[1]; uR = y[3]-y[2]; uCC = y[3]-y[1];
   ISL = uL^2; ISC = 13/3*uC^2 +0.25*uCC^2; ISR = uR^2;
   aL = 0.25*(1/(ep+ISL))^p; aC = 0.5*(1/(ep+ISC))^p; 
   aR = 0.25*(1/(ep+ISR))^p;
   suma = max(aL+aC+aR,eps(1.0)); wL = aL/suma; wC = aC/suma; wR = aR/suma;
   y12 = (0.5*wL+5/12*wC)*y[1] + (0.5*wL+2/3*wC+1.5*wR)*y[2] + 
         (-wC/12-0.5*wR)*y[3];
   y23 = (-0.5*wL-wC/12)*y[1] + (1.5*wL+2/3*wC+0.5*wR)*y[2]  + 
         (5/12*wC+0.5*wR)*y[3];
   return y12, y23
end
    