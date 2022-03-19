function [T,Y,te,ye,ie] = rodasp2(fcn,tspan,y0,options,dfdt_row,dfdt_fcn,jaclin_row,jaclin_col,jaclin_mat)
%-------------------------------------------------------------------------
% This is RODASP2, a fourth order ROW-method for solving
% ODEs y'=f(t,y) and Index-1 DAE problems M y' = f(t,y)
%
% Usage is the same as ode23s or other MATLAB ode-solver:
%    [T,Y] = rodasp2(fcn,tspan,y0)  or
%    [T,Y] = rodasp2(fcn,tspan,y0,options)  or
%    [T,Y,te,ye,ie] = rodasp2(fcn,tspan,y0,options) or
%  only rodasp2:
%    [T,Y] = rodasp2(fcn,tspan,y0,options,...
%                    dfdt_row,dfdt_fcn,jaclin_row,jaclin_col,jaclin_mat)
%
% These options are implemented (see help odeset):
%       RelTol, AbsTol, Stats, InitialStep, MaxStep, Mass, 
%       Jpattern, Jacobian, OutputFcn, Vectorized
%
% This option is partly implemented:
%       Events (direction not implemented, only one event at a time)
%
% OPTIONAL Parameters: 
% ===================
% dfdt_row: indicates dependence of fcn on t: 
%                  0: autonomous system
%           -1 or []: all rows of fcn may depend in t
%            [1,2,4]: only rows 1,2,4 depend on t
%
% dfdt_fcn: function of type df=dfdt_fcn(t,y) computing the derivative of
%           f(t,y) with respect to time t
%
%     either dfdt_fcn or dfdt_row should be used
%
% jaclin_row, jaclin_col: constant rows or columns of the Jacobian can be
%        indicated, thus the evaluation of the Jacobian may be much cheaper
%        Example: rodasp2(fcn,tspan,y0,optins,[],[],[2,3],[1,2]) 
%          indicates that equations 2,3 in fcn are linear and
%          fcn depends linear on y_1, y_2.
%          jaclin_row=[] and/or jaclin_col=[] is allowed
%          rows specified in jaclin_row must not depend on time t as well
%          jaclin_col=[neq+1] indicates, that dependence of fcn on time t 
%          is linear
%
% jaclin_mat: Matrix containing all constant entries of the Jacobian.
%             Additionally entries NaN are possible, indicating
%             all non-constant (nonlinear parts of fcn) of the Jacobian.
%             When NaN entries are applied, option JPattern should not be used
%
%     either jaclin_mat or jaclin_row/jaclin_col should be used
%
% All linear algebra is done "sparse".
% For large problems the usage of the option "Jpattern" is recommended.
%
% BIBLIOGRAPHY:
%  [1] Hairer, Wanner:  Solving Ordinary Differential Equations II, second ed., 
%       Springer, Berlin, 1996.
%  [2] Steinebach, G., Rentrop, P.: An adaptive method of lines approach for modelling flow 
%       and transport in rivers. Adaptive method of lines , Wouver, A. Vande, Sauces, Ph., 
%       Schiesser, W.E. (ed.),S. 181-205, Chapman & Hall/CRC (2001).
%  [3] Steinebach, G.: Order-reduction of ROW-methods for DAEs and method of lines applications.
%        Preprint-Nr. 1741, FB Mathematik, TH Darmstadt (1995).
%  [4] Steinebach, G.: Improvement of Rosenbrock-Wanner Method RODASP 
%        - Enhanced coefficient set and MATLAB implementation -, to appear
%        in Springer DAE Forum (2020)                     
%
% comments are welcome to
% Gerd Steinebach (Gerd.Steinebach@h-brs.de)
% Version 02.2020 (new coefficient set for rodasp = rodasp2, new options)
%-------------------------------------------------------------------------
persistent tlastevent

pord = 4.0; row_method = 1; %-- 1=rodasp2, 2=rodasp, 3=rodas
%-- Initialization --------------------------------
if nargin < 4
    options = []; 
    if (nargin < 3) error('Error exit: not enough input arguments');  end
end
%---- implemented options -----------------
rtol = odeget(options,'RelTol',1e-3);
atol = odeget(options,'AbsTol',1e-6);
statson = odeget(options,'Stats','off');
hinit = odeget(options,'InitialStep',[]);
hmax = odeget(options,'MaxStep',[]);
M = odeget(options,'Mass',[]);
Jacstru = odeget(options,'Jpattern',[]);
solout=odeget(options,'OutputFcn',[]);
events=odeget(options,'Events',[]);
fjac=odeget(options,'Jacobian',[]);
vecon = odeget(options,'Vectorized','off');
if strcmp(vecon,'on'), vecon=1; else vecon=0; end
stats = struct('nfevals',0,'nsteps',0,'nrejected',0,'npds',0,'ndecomps',0,'nsolves',0);
%--- Parameter -------------
 neq = length(y0); 
 true = 1; false = ~true; 
 uround=eps; fac1=0.2; fac2=6.0; f_savety=0.9;  hmin = eps/2; % could be altered
 Jacspace=[]; Jacspace_nonlin=[]; thresh=ones(neq,1)*1.e-5; % for numjac
%-- Method's coefficients
if row_method==1 [stage,gamma,b,bd,a,alpha,gammatilde,g,ccont,dcont]=coeff_rodasp2; end
if row_method==2 [stage,gamma,b,bd,a,alpha,gammatilde,g,ccont,dcont]=coeff_rodasp; end
if row_method==3 [stage,gamma,b,bd,a,alpha,gammatilde,g,ccont,dcont]=coeff_rodas; end
%----- Mass Matrix
if isempty(M)   
    M=speye(neq);
else
    M=sparse(M); 
    if condest(M)>1.0e16  pord=pord-1; end %-- DAE
end
%-- Linear Part of Jacobian given
if (nargin>=9)&&(~isempty(jaclin_mat))
  jaclin_mat = sparse(jaclin_mat); Jacstru = speye(neq)*0;
  ff = isnan(jaclin_mat); %-- find nonlinear entries in Jac given as NaN
  if nnz(ff)>0 
      Jacstru(ff)=1; jaclin_mat(ff)=0;
  end
else
  jaclin_mat = speye(neq)*0;
end
%-- Jacstru given
if isempty(Jacstru)
   Jacstru = sparse(ones(neq));
else
   Jacstru=sparse(Jacstru); Jacstru(Jacstru~=0)=1;
end
%-- dependence of fcn on time t
if (nargin>=5) && ~isempty(dfdt_row) 
  if dfdt_row==0
    dfdt_row=[];
  elseif dfdt_row==-1
    dfdt_row=1:neq;
  end
else
  dfdt_row=1:neq;
end
%-- analytical function dfdt_fcn given
fdfdt = 0;
if (nargin>=6) && ~isempty(dfdt_fcn) 
  fdfdt = 1; dfdt_row=[];
end
Jacstru(dfdt_row,neq+1)=1;
%-- Linear Parts of Jac are given as whole rows or columns
jaclin=0;
if ((nargin>=7)&&(~isempty(jaclin_row)) || ((nargin>=8)&&~isempty(jaclin_col)))
    jaclin=1; Jacstru_nonlin = Jacstru;
    if ~isempty(jaclin_row) Jacstru_nonlin(jaclin_row,:)=0;  end
    if (nargin>=8) && ~isempty(jaclin_col) Jacstru_nonlin(:,jaclin_col)=0;  end
    n_jacnonlin=nnz(Jacstru_nonlin);
    [icol_nonlin,jcol_nonlin]=find(Jacstru_nonlin);
end
% --Preparations for output-parameter [T,Y], solout, events ------------
 t0=tspan(1); tend=tspan(end); t=t0; y(:,1) = y0; ; 
 T = zeros(10000,1); Y = zeros(10000,neq);
 nt=1; T(nt)=t0; Y(nt,:) = y';
 dense_output=false; n_tspan=length(tspan); told=t0;
 if n_tspan > 2 
     dense_output=true; inext=2; tnext=tspan(inext);
 end
 if isempty(solout)==0
     if solout([t0,tend],y0,'init')==1 return; end
 end
 if isempty(events)==0
     [value,isterminal,direction]=events(t,y,[]);
     if isempty(tlastevent) | (tlastevent > t)  tlastevent=t-1.0;  end
 end
 te=[];ye=[];ie=[];
%-- INITIAL PREPARATIONS for stepsize --------
 if (tend <= t0) error('tend<= t0 !!'); end
 if isempty(hmax) hmax=abs(tend-t0); end
 if isempty(hinit) hinit=1.0e-6*abs(tend-t0); end
 h=min(hinit,hmax);  
%-- The main integration loop ---------------------------------------------
 done = false;  reject = 0; facmax = fac2; 
 while ~done
    if (t+0.01*h == t) || (abs(h) < uround)    %-- stepsize to small
        fprintf('Error exit of RODASP at time t=%15g: step size to small h=%15g \n',t,h);
        break
    end
    if (t+h) >= tend
       h=tend-t;
    else
       h=min(h,0.5*(tend-t));
    end
%---- integration step --------
    if reject==0
      nf = 0; nf0 = 0;
      if ~isempty(fjac) %-- analytical jacobian
        f0 = fcn(t,y); DFDY = fjac(t,y);  
        nf0 = 1; stats.npds=stats.npds+1; 
        if ~issparse(DFDY) DFDY=sparse(DFDY); end
        if fdfdt %-- analytical
           dfdt1 = dfdt_fcn(t,y);
        else
          if ~isempty(dfdt_row) %-- non autonomous
            nf = 1;
            tdel = sqrt(uround)*max(1.0e-5,abs(t));
            dfdt1 = (fcn(t+tdel,y) - f0)/tdel;
          else %-- autonomous system
            dfdt1 = zeros(neq,1);
          end
        end
        DFDY=[DFDY,dfdt1]; 
      else  %-- numerical jacobian
        f0=[]; 
        if ~vecon
           f0 = fcn(t,y); nf0=1;
        end
        if (stats.nfevals==0)||(jaclin==0)  %-- first jacobian or all nonlinear
          [f0,DFDY,nf,Jacspace] = numjac_stei(fcn,t,y,f0,thresh,Jacstru,Jacspace,vecon);
          stats.npds=stats.npds+1; 
          if jaclin %-- save linear part if present
            DFDY_save = DFDY; DFDY_save(icol_nonlin,jcol_nonlin)=0;
          end
        else 
          if n_jacnonlin>0  %-- nonlinear parts
           [f0,DFDY_nonlin,nf,Jacspace_nonlin] = numjac_stei(fcn,t,y,f0,thresh,Jacstru_nonlin,Jacspace_nonlin,vecon);
           DFDY = DFDY_save+DFDY_nonlin;
           stats.npds=stats.npds+1; 
          end
        end
        if fdfdt %-- analytical
            dfdt1 = dfdt_fcn(t,y); DFDY(:,neq+1) = dfdt1;
        end
        stats.nfevals=stats.nfevals+nf+nf0;  
      end
    end
%--
    dfdt = h*full(DFDY(:,neq+1));
    E = M-(h*gamma)*(DFDY(:,1:neq)+jaclin_mat);
    upivot=0.5; [L,U,P] = lu(E,upivot); 
    stats.ndecomps=stats.ndecomps+1;
    nsing=0; 
    ad = abs(diag(U)); condition = min(ad)/max(ad);
    while condition < 1.0e-16   %-- detect singular matrix
        nsing=nsing+1
        if nsing==1
           upivot=1.0;         
        elseif (nsing==6) || (t+0.1*h == t) || (abs(h) <= uround)  
           fprintf('Error exit of RODASP at time t=%15g: singular matrix M-h*gama*DFDY \n',t);
           done=true;break
        else
           h=0.5*h; E = M-(h*gamma)*(DFDY(:,1:neq)+jaclin_mat);
        end
        [L,U,P] = lu(E,upivot); 
        stats.ndecomps=stats.ndecomps+1;
        ad = abs(diag(U)); condition = min(ad)/max(ad);
    end
    if done break; end
    K=zeros(neq,stage);
    rhs = f0+g(1)*dfdt;
    K(:,1) = (U \ (L\ (P*rhs) ));
    for i=2:stage
       sum_1 = K*alpha(:,i); sum_2 = K*gammatilde(:,i);
       y1 = y+h*sum_1;
%       rhs=fcn(t+a(i)*h,y1)+jaclin_mat*y1 + M*sum_2 + g(i)*dfdt;
       rhs=fcn(t+a(i)*h,y1) + M*sum_2 + g(i)*dfdt;
       sol = (U \ (L\ (P*rhs) ));
       K(:,i) = sol - sum_2; 
    end
    stats.nfevals=stats.nfevals+stage-1; stats.nsolves=stats.nsolves+stage;
    sum_1 = K*(h*b); ynew = y + sum_1;  sum_2 = K*(h*bd); 
%---- error test -----------
    SK = atol + rtol.*abs(ynew);
%    err = sqrt(sum( ((sum_1-sum_2)./SK).^2 )/neq);  %-- L_2 Norm
%    err = sum(abs((sum_1-sum_2)./SK))/neq;  %-- L-1 Norm
    err = max(abs((sum_1-sum_2)./SK));  %-- L-infinity Norm
    if ~isempty(find(~isfinite(ynew))) 
        err=100; 
        disp('Warning Rodasp2: NaN or Inf occurs');
    end
    err = max(err,1.0e-50);
    fac = f_savety/err^(1/(pord+1));
    fac=min(facmax,max(fac1,fac));  
    hnew=h*fac;
%--       
    if (hnew < hmin)& (stats.nsteps==0)  %-- the first step, one more try
       err=1; hnew=max(hmin,uround);
    end
    if (err <= 1.0)   % --- STEP IS ACCEPTED  -------
        reject = 0; stats.nsteps=stats.nsteps+1;
        told = t; t=t+h;
        if isempty(events)==0 %-- events
          valueold=value;
          [value,isterminal,direction]=events(t,ynew,[]);
          value_save = value;
          ff=find(value.*valueold <=0);
          if ~isempty(ff)
             for i=ff(1):ff(length(ff))
              v0=valueold(i); v1=value(i); detect=1;
              if (direction(i)<0)&&(v0<=v1) detect=0; end
              if (direction(i)>0)&&(v0>=v1) detect=0; end
              if detect
               iterate=1; t0=told; t1=t; 
               if abs(value(i)-valueold(i)) > uround
                   tevent=told-valueold(i)*h/(value(i)-valueold(i));
               else
                   iterate=0; tevent = t; ynext=ynew;
               end
               while iterate>0
                   iterate = iterate +1;
                   tau = (tevent-told)/h;
                   ynext = y + tau*h*K* ( b + (tau-1)*(ccont + tau*dcont) ); % non linear
                   [value,isterminal,direction]=events(tevent,ynext,[]);
                   if v1*value(i)<0 
                       t0 = tevent; tevent=0.5*(tevent+t1); v0=value(i);
                   elseif v0*value(i)<0 
                       t1 = tevent; tevent=0.5*(t0+tevent); v1=value(i);
                   else
                       iterate = 0;
                   end
                   if (t1-t0) < rtol iterate=0; end
                   if iterate > 100 iterate=0; end
               end  
               tlastevent=tevent;
%               nt=nt+1; T(nt)=tevent; Y(nt,:)=ynext'; 
               t = tevent; ynew = ynext;
               te=[te;tevent];ie=[ie;i]; ye=[ye;ynext']; 
               [value,isterminal,direction]=events(tevent,ynext,i); %-- aufgetretenes Event mitteilen
               value = value_save;
               if isterminal(i) 
                   T = T(1:nt); Y = Y(1:nt,:);
                   if isempty(solout)==0 solout(T(nt),Y(nt,:)',''); end
                   return; 
               end %-- terminates when first event occurs
              end
             end
          end
        end
%--
        if (dense_output==0) 
           nt=nt+1; T(nt)=t; Y(nt,:)=ynew'; 
           if isempty(solout)==0
             if solout(t,ynew,'')==1 return; end
           end
        else
            while (t >= tnext) && (told < tnext) %-- Interpolation to tnext
              tau = (tnext-told)/h;
              ynext = y + tau*h*K* ( b + (tau-1)*(ccont + tau*dcont) ); % non linear
              nt=nt+1; T(nt)=tnext; Y(nt,:)=ynext'; 
              if isempty(solout)==0
                if solout(tnext,ynext,'')==1 return; end
              end
              inext=inext+1; 
              if (inext <= n_tspan) 
                  tnext=tspan(inext); 
              else
                  tnext=tend+h;
              end
            end
        end
        if (abs(tend-t) < uround) done=true; end  %-- succesfull integration --
        y = ynew; facmax = fac2;
    else   % --- STEP IS REJECTED ------- 
      reject = reject+1; stats.nrejected=stats.nrejected+1; 
      facmax = 1;
    end
    h = min(hnew,hmax); 
%---------
 end
%---------
 T = T(1:nt); Y = Y(1:nt,:);
 if isempty(solout)==0
     status=solout(t,y,'done');
 end
%------------------
 if strcmp(statson,'on')
   fprintf('%g successful steps\n', stats.nsteps);
   fprintf('%g failed attempts\n', stats.nrejected);
   fprintf('%g function evaluations\n', stats.nfevals);
   fprintf('%g partial derivatives\n', stats.npds)
   fprintf('%g LU decompositions\n', stats.ndecomps);
   fprintf('%g solutions of linear systems\n', stats.nsolves);
 end

function [s,gamma,b,bd,a,alpha,gammatilde,g,c,d]=coeff_rodasp
%-- Coefficients for RODASP with order 4 for linear parabolic problems
s=6; alpha=zeros(s,s); beta=alpha; a=zeros(s,1); g=zeros(s,1);
gamma=0.25;
alpha(2,1)=0.75;
alpha(3,1)= 8.6120400814152190E-2; alpha(3,2)=0.1238795991858478;
alpha(4,1)= 0.7749345355073236;    alpha(4,2) = 0.1492651549508680; alpha(4,3) = -0.2941996904581916;
alpha(5,1)= 5.308746682646142;     alpha(5,2) = 1.330892140037269;  alpha(5,3) = -5.374137811655562; 
alpha(5,4)= -0.2655010110278497;
alpha(6,1)= -1.764437648774483;    alpha(6,2) =-0.4747565572063027; alpha(6,3) = 2.369691846915802;
alpha(6,4)= 0.6195023590649829;    alpha(6,5) = 0.25;
beta(2,1)= 0.0; 
beta(3,1)= -0.049392;            beta(3,2)= -0.014112;
beta(4,1)= -0.4820494693877561;  beta(4,2)= -0.1008795555555556;    beta(4,3)=  0.9267290249433117;
beta(5,1)= -1.764437648774483;   beta(5,2)= -0.4747565572063027;    beta(5,3) =  2.369691846915802;
beta(5,4)=  0.6195023590649829; 
beta(6,1)= -8.0368370789113464E-2;beta(6,2)=-5.6490613592447572E-2; beta(6,3)=  0.4882856300427991;
beta(6,4)=  0.5057162114816189;   beta(6,5)= -0.1071428571428569;
b=[beta(6,1);beta(6,2);beta(6,3);beta(6,4);beta(6,5);gamma];
bd=[beta(5,1);beta(5,2);beta(5,3);beta(5,4);gamma;0];
c=[-40.98639964388325;-10.36668980524365;44.66751816647147;4.13001572709988;2.55555555555556;0];
d=[73.75018659483291;18.54063799119389;-81.66902074619779;-6.84402606205123;-3.77777777777778;0];
gammatilde=beta-alpha;
for i=1:s
 a(i)=sum(alpha(i,:));
 g(i)=sum(gammatilde(i,:))+gamma;
end
gammatilde=gammatilde/gamma;
alpha=alpha'; gammatilde=gammatilde';  % order by column

function [s,gamma,b,bd,a,alpha,gammatilde,g,c,d]=coeff_rodas
%-- Coefficients for RODAS
s=6; alpha=zeros(s,s); beta=alpha; a=zeros(s,1); g=zeros(s,1);
gamma=0.25;
alpha =[...
                         0                         0                         0                         0                         0                         0;...
     3.860000000000000e-01                         0                         0                         0                         0                         0;...
     1.460747075254185e-01     6.392529247458190e-02                         0                         0                         0                         0;...
    -3.308115036677222e-01     7.111510251682822e-01     2.496604784994390e-01                         0                         0                         0;...
    -4.552557186318003e+00     1.710181363241323e+00     4.014347332103149e+00    -1.719715090264703e-01                         0                         0;...
     2.428633765466977e+00    -3.827487337647808e-01    -1.855720330929572e+00     5.598352992273752e-01     2.499999999999995e-01                         0];
beta =[...
               0                         0                         0                         0                         0                         0;...
     3.170000000000250e-02  0 0 0 0 0;...
     1.247220225724355e-02     5.102779774275723e-02 0 0 0 0;...
     1.196037669338736e+00     1.774947364178279e-01    -1.029732405756564e+00 0 0 0;...
     2.428633765466977e+00    -3.827487337647810e-01    -1.855720330929572e+00     5.598352992273752e-01 0 0;...
     3.484442712860512e-01     2.130136219118989e-01    -1.541025326623184e-01     4.713207793914960e-01    -1.286761399271284e-01 0];
b=[beta(6,1);beta(6,2);beta(6,3);beta(6,4);beta(6,5);gamma];
bd=[beta(5,1);beta(5,2);beta(5,3);beta(5,4);gamma;0];
c=[-4.786970949443344e+00; -6.966969867338157e-01;4.491962205414260e+00; 1.247990161586704e+00;-2.562844308238056e-01;0];
d=[1.274202171603216e+01;-1.894421984691950e+00;-1.113020959269748e+01;-1.365987420071593e+00;1.648597281428871e+00;0];
gammatilde=beta-alpha;
for i=1:s
 a(i)=sum(alpha(i,:));
 g(i)=sum(gammatilde(i,:))+gamma;
end
gammatilde=gammatilde/gamma;
alpha=alpha'; gammatilde=gammatilde';  % order by column


function [s,gamma,b,bd,a,alpha,gammatilde,g,c,d]=coeff_rodasp2
%-- Coefficients for RODASP2
x=[ 2.500000000000000e-01;...
     1.464968119068510e-01;...
     8.896159691002868e-02;...
     1.648843942975145e-01;...
     4.568000540284631e-01;...
    -1.071428571428573e-01;...
     2.500000000000000e-01;...
     7.500000000000000e-01;...
     3.688749816109670e-01;...
     4.596170083041160e-01;...
     2.719770298548111e+00;...
    -6.315720511779362e-01;...
    -4.742684759792117e-02;...
     2.724432453018110e-01;...
     1.358873794835473e+00;...
    -3.326966988718489e-01;...
    -2.123145213282008e-01;...
    -2.838824065018641e+00;...
     1.154688683864918e+00;...
    -2.398200283649438e-01;...
     5.595800661848674e-01;...
     2.500000000000001e-01;...
    -7.500000000000000e-01;...
    -4.607187027720548e-01;...
    -5.177940359868256e-01;...
    -3.351342349726047e+00;...
     7.780688630847872e-01;...
     2.118578440903894e-02;...
    -4.106562083532062e-01;...
    -1.691570493707322e+00;...
     4.216582957818776e-01;...
     7.640623531328012e-01;...
     3.993512748883558e+00;...
    -9.898042895674033e-01;...
     7.994000945498112e-01;...
    -1.027800121564043e-01;...
    -3.571428571428574e-01;...
    -6.315720511779362e-01;...
    -3.326966988718489e-01;...
     1.154688683864918e+00;...
     5.595800661848674e-01;...
     2.500000000000000e-01];
x=x'; s=6; gamma = x(1); b = x(2:s+1); alpha = zeros(s); %gij = eye(s)*gamma;
gij=zeros(s);
k=s+2;
for j=1:s-1
    alpha(j+1:end,j)=x(k:k+s-j-1);
    k = k+s-j;
end
for j=1:s-1
    gij(j+1:end,j)=x(k:k+s-j-1);
    k = k+s-j;
end
a = sum(alpha')';
bd = x(end-s+2:end)'; bd = [bd;0]; bd=bd; b=b'; 
gammatilde=gij/gamma;
for i=1:s
 g(i)=sum(gij(i,:))+gamma;
end
alpha=alpha'; gammatilde=gammatilde';  % order by column
c=[-9.723524422179552e-01; 3.317467091636907e-02;-3.477906028947136e-01;1.282921876269772e+00;4.046497926528075e-03;0];
d=[6.359956694702077e-01;-2.250269389785516e-01;4.244326499874402e-01;-1.714642133368855e+00;8.792407528897581e-01;0];

function [Fty,dFdyt,nfevals,g] = numjac_stei(F,t,y,Fty,thresh,S,g,vecon)
%-- NUMJAC NUMerically compute the JACobian dF/dY of function F(T,Y).
%-- adopted from original numjac
y = [y;t]; thresh=[thresh;1.0e-8]; %-- dfdt is computed too, as last column of dFdy
facmax = 0.1; ny = length(y);
fac = sqrt(eps) + zeros(ny,1); yscale = max(0.1*abs(y),thresh);
del = (y + fac .* yscale) - y; jj = find(del == 0); 
for k = 1:length(jj)
  j=jj(k);
  while 1
    if fac(j) < facmax
      fac(j) = min(100*fac(j),facmax);
      del(j) = (y(j) + fac(j)*yscale(j)) - y(j);
      if del(j) break; end
    else
      del(j) = thresh(j);  break;
    end
  end
end
%-- keep del pointing into region
%if ~isempty(Fty)
%  s = (sign([Fty;t]) >= 0); del = (s - (~s)) .* abs(del);
%end
%-- Group columns for differentiation
if isempty(g)
    ng=1; jvec = zeros(ny,1); j_todo = 1:ny; n_todo=ny;
    while n_todo > 0
      j=j_todo(1); jvec(j)=ng; Sj0 = full(S(:,j));
      for k=2:n_todo
         j = j_todo(k); Sj1 = full(S(:,j));
         if max(Sj0.*Sj1)==0 %-- no common rows
             Sj0=Sj0+Sj1; jvec(j)=ng;
         end
      end
      ng = ng+1; j_todo = find(jvec==0); n_todo=length(j_todo);
    end
    g = jvec;
end
%-- Form a difference approximation to all columns of dFdy.
del(full(~any(S)))=0; %-- del=0 for columns not in S, would have influence on other columns
if ~vecon
   ng = max(g); nfevals = ng; 
   for k=1:ng
     jj=find(g==k);
     ydel = y; ydel(jj)=ydel(jj)+del(jj);
     t = ydel(ny); ydel(ny)=[];
     df(:,k) = F(t,ydel)-Fty;
   end
else  %-- vectorized function F
   nfevals = 1; g(ny)=0; ng=max(g); ng1=ng+1; 
   ydel=repmat(y,1,ng1); ydel(ny,:)=[];
   for k=1:ng
     jj=find(g==k); ydel(jj,k)=ydel(jj,k)+del(jj);
   end
   df = F(t,ydel); 
   Fty = df(:,ng+1); df(:,ng1)=zeros(ny-1,1);
   if ~isempty(find(S(:,ny)~=0, 1)) 
       y(ny)=[];
       df(:,ng1)=F(t+del(ny),y); nfevals = 2;
   end
   df = df-repmat(Fty,1,ng1);
   g(ny)=ng1;
end
[i,j]=find(S);
if ny==2 df=df'; i=i'; end
ipos = (g(j)-1)*(ny-1)+i;
dFdyt = sparse(i,j,df(ipos)./del(j),ny-1,ny);
%--

