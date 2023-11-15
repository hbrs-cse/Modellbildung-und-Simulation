%-- Kap_08_RK3simple.m
function [T,Y] = rk3_simple(fcn,tspan,y0,atol,rtol)
% fcn: ode-function; tspan: time interval
% y0: initial values; atol, rtol: tolerances
%-- Initialization ----
 nfevals = 0; nsteps = 0; nrejected = 0; %-- statistics
 uround=eps; fac1=0.2; fac2=6.0;   %-- could be altered
%-- Method's coefficients
 stage = 3; b = [1/6;1/6;2/3];  bd = [1/2;1/2;0];
 a = [0;1;1/2]; alpha = [0,0,0;1,0,0;1/4,1/4,0];
% --Preparations for output-parameter [T,Y] ---
 neq = length(y0); t0=tspan(1); tend=tspan(end); y(:,1) = y0; t=t0; T=t0; Y=y'; 
%-- INITIAL PREPARATIONS for stepsize ----
 if (tend <= t0) error('tend<= t0 !!'); end
 hmax=abs(tend-t0)/10; hinit=1.0e-6*abs(tend-t0);  h=min(hinit,hmax);  
%-- The main integration loop ----
 done = false;  reject = false; K=zeros(neq,stage);
 while ~done
    if (t+0.1*h == t) || (abs(h) <= uround)    %-- stepsize to small
        fprintf('Error exit of rk3_simple at time t=%15g: step size to small h=%15g \n',t,h);
        break
    end
    if (t+h) >= tend
       h=tend-t;
    else
       h=min(h,0.5*(tend-t));
    end
%---- integration step ----
    if reject==false      
        K(:,1) = fcn(t,y); nfevals = nfevals+1;
    end
    for i=2:stage
       sum_K = K*alpha(i,:)';
       K(:,i) = fcn(t+h*a(i),y+h*sum_K); nfevals=nfevals+1; 
    end
    sum_1 = h*K*b; sum_2 = h*K*bd; ynew = y + sum_1;
%---- error test ----
    SK = atol + rtol.*max(abs(y),abs(ynew));
    err = sum( ((sum_1-sum_2)./SK).^2 ); err = max(realmin,sqrt(err/neq));
    fac = 0.9 * err^(-1/3);  fac=min(fac2,max(fac1,fac)); hnew=h*fac;
    if (err <= 1.0)  % --- STEP IS ACCEPTED  -------
      reject = false; nsteps = nsteps+1; told = t; t=t+h; 
      if (abs(tend-t) < uround) done=true; end  %-- succesfull
      y = ynew; T=[T;t]; Y=[Y;ynew']; 
    else  % --- STEP IS REJECTED ----
      reject = true; nrejected = nrejected+1;  
    end
    h = min(hnew,hmax);
 end
%----
 fprintf('%g successful steps\n', nsteps);
 fprintf('%g failed attempts\n', nrejected);
 fprintf('%g function evaluations\n', nfevals);
end


