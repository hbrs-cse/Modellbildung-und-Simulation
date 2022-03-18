clearvars

phipi0   = 0;
phipi6 = pi/6; % 30 degrees
phipi4 = pi/4; % 45 degrees
phipi3 = pi/3; % 60 degrees
phipi2 = pi/2; % 90 degrees

sin0 = 0;           
sinpi6 = 1/2;       
sinpi4 = 1/sqrt(2); 
sinpi3 = sqrt(3)/2; 
sinpi2 = 1;         

cos0 = 1;
cospi6 = sqrt(3)/2; % 30 degrees
cospi4 = 1/sqrt(2); % 45 degrees
cospi3 = 1/2;       % 60 degrees
cospi2 = 0;         % 90 degrees

%% parameters for approximation
atol = 1e-10;
N = 1000; % Number of Points
nmax = 50; % Maximum degree of Taylor polynomial

%% approximation around phi = 0
phi0 = phipi0;  sinphi0 = 0;    cosphi0 = 1;
phimin = 0;   phimax = (phipi6+phipi0)/2;
[error0, T_sin0] = taylorapprox(phi0,phimin,phimax,sinphi0,cosphi0,atol,N,nmax);

%% approximation around phi = pi/6
phi0 = phipi6;  sinphi0 = sinpi6;   cosphi0 = cospi6;
phimin = phimax;   phimax = (phipi4+phipi6)/2;
[error1, T_sin1] = taylorapprox(phi0,phimin,phimax,sinphi0,cosphi0,atol,N,nmax);

%% approximation around phi = pi/4
phi0 = phipi4;  sinphi0 = sinpi4;   cosphi0 = cospi4;
phimin = phimax;   phimax = (phipi4+phipi3)/2;
[error2, T_sin2] = taylorapprox(phi0,phimin,phimax,sinphi0,cosphi0,atol,N,nmax);

%% approximation around phi = pi/3
phi0 = phipi3;  sinphi0 = sinpi3;   cosphi0 = cospi3;
phimin = phimax;   phimax = (phipi2+phipi3)/2;
[error3, T_sin3] = taylorapprox(phi0,phimin,phimax,sinphi0,cosphi0,atol,N,nmax);

%% approximation around phi = pi/2
phi0 = phipi2;  sinphi0 = sinpi2;   cosphi0 = cospi2;
phimin = phimax;   phimax = (phipi2+phipi2)/2;
[error4, T_sin4] = taylorapprox(phi0,phimin,phimax,sinphi0,cosphi0,atol,N,nmax);

%% approximation for whole interval
phi0 = 0;  sinphi0 = 0;   cosphi0 = 1;
phimin = 0;   phimax = phipi2;
[error_whole, T_sin_whole] = taylorapprox(phi0,phimin,phimax,sinphi0,cosphi0,atol,N,nmax);

legend('T_{phi=[0,\pi/12]}','T_{phi=[\pi/12,5\pi/24]}','T_{phi=[5\pi/24,7\pi/24]}','T_{phi=[7\pi/24,5\pi/12]}','T_{phi=[5\pi/12,\pi/2]}','location','southeast')

function [error, T_sin] = taylorapprox(phi0,phimin,phimax,sinphi0,cosphi0,atol,N,nmax)
    phi = linspace(phimin, phimax, N);
    n = 0;
    T_sin = sinphi0*ones(1,N);
    error = abs(sin(phi) - T_sin);
    maxerror = max(error);
    
    while maxerror > atol && n < nmax
        n = n+1;
        if mod(n,2) == 0
            T_next = -sinphi0/factorial(n)*(phi - phi0).^n;
            if mod(n,4) == 0
                T_next = -T_next;
            end
        else
            T_next = -cosphi0/factorial(n)*(phi - phi0).^n;
            if mod(n-1,4) == 0
                T_next = -T_next;
            end
        end
        T_sin = T_sin + T_next;
        error = abs(sin(phi) - T_sin);
        maxerror = max(error);
    end
    print(string(phimin))
    display(['interval: [',num2str(phimin),',',num2str(phimax),'], necessary degree: ',num2str(n),', maximum error: ',num2str(maxerror)]);
    plot(phi,T_sin)%plot(phi,sin(phi),phi,error,phi,T_sin)
    %legend('sin','error','T_{sin}')
    hold on
end

