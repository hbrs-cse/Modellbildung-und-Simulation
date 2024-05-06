% Kap_11_Waerme2D.m
function Waerme_2d
% Wärmeleitung auf einer quadratischen Platte
global N dx tau c rho T0 P ix1 ix2 iy dicke
 lam = 237; c = 900; rho = 2700; tau = lam/(c*rho); 
 T0 = 20; P = 10; L = 0.1; dicke = 0.005;
 N = 200; dx = L/(N-1); 
 x_mesh = 0:dx:L; y_mesh = x_mesh;
 [x_min,ix1] = min(abs(x_mesh -0.025)); [x_min,ix2] = min(abs(x_mesh -0.075));
 [y_min,iy] = min(abs(y_mesh - 0.05));
 y0 = zeros(N*N,1)+T0; J = jacstru(N); 
 options=odeset('JPattern',J,'stats','on','RelTol',1.0e-6, ...
     'AbsTol',1.0e-6);
 tspan = [0,10,30,60,61,200,1000];
 tic
 [t,y] = ode15s(@dgl,tspan,y0,options);
 toc
 for i =2:length(t)
   T = reshape(y(i,:),N,N);
   subplot(2,3,i-1); contour(x_mesh,y_mesh,T,'ShowText','on'); 
   title(strcat('t = ',num2str(t(i))))
 end

function dy = dgl(t,y)
global N dx tau c rho T0 P ix1 ix2 iy dicke
crd = c*rho*dicke; dx2 = dx^2;
dy = zeros(N*N,1); T = reshape(y,N,N); k = 0;
for j = 1:N
    for i=1:N
        k = k+1;
        if (i==1) 
            dy(k) = dy(k) + T(i+1,j)-T(i,j);
        elseif (i==N)
            dy(k) = dy(k) - T(i,j)+T(i-1,j);
        else
            dy(k)= dy(k)+T(i+1,j)-2*T(i,j)+T(i-1,j);
        end
        if (j==1) 
            dy(k) = dy(k) + T(i,j+1)-T(i,j);
        elseif (j==N)
            dy(k) = dy(k) - T(i,j)+T(i,j-1);
        else
            dy(k)= dy(k)+T(i,j+1)-2*T(i,j)+T(i,j-1);
        end
        dy(k) = dy(k)*tau/dx2 - 50*(T(i,j)-T0)/crd;
        if (t<60)&&((j==ix1)||(j==ix2))&&(i==iy)
          dy(k) = dy(k) + P/(crd*dx2);  
        end
    end
end

function J = jacstru(N)
J = speye(N*N); k = 0;
for j = 1:N
    for i=1:N
        k = k+1;
        if (i>1) J(k,k-1)=1; end
        if (i<N) J(k,k+1)=1; end
        if (j>1) J(k,k-N)=1; end
        if (j<N) J(k,k+N)=1; end
    end
end
