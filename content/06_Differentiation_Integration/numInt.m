%function [I, dt]= numInt(f,a,b,tol)
% Inputs: function, lower boundary, upper boundary, tolerance
% Output: integration result, step size

function [I, dt] = numInt(f,a,b,tol)
h = b-a; n = 1;
trap = h/2*(f(a) + f(b));
sim = h/6*(f(a)+4*f(a+h/2)+f(b));
while abs(trap-sim) > tol
    h = h/2;
    n=n*2;
    sum_sim = 0; sum_trap = 0;
    x = a;
    for i=1:n
        f0_plus_f1 = f(x) + f(x+h);
        sum_trap = sum_trap + f0_plus_f1;
        sum_sim = sum_sim + f0_plus_f1 + 4*f(x+h/2);
        x = x + h;
    end
    trap = h/2*sum_trap;
    sim = h/6*sum_sim;
    if h < tol
        msgID = 'numInt:convergence';
        msg = 'does not cenverge';
        exception = MException(msgID,msg);
        throw(exception);
    end
end
I = sim;
dt = h;
end