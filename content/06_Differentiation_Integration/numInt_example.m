%function [I, dt]= numInt(f,a,b,tol)
% Compute numeric integral of f on [a, b] to tolerance tol via Simpson's rule. Step width is regulated via comparison to result of Trapezoidal rule.
% Inputs: function, lower boundary, upper boundary, tolerance
% Output: integration result, step size

function [I, dt] = numInt(f,a,b,tol)
h = b-a; n = 1;
trap = h/2*(f(a) + f(b));
sim = h/6*(f(a)+4*f(a+h/2)+f(b));
while abs(trap-sim) > tol
    h = h/2;
    if h < 10^(-7)
        msgID = 'numInt:convergence';
        msg = 'does not converge';
        %exception = MException(msgID,msg);
        error(msgID,msg);
        %throw(exception);
        break;
    end
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
end
I = sim;
if I == Inf
    msgID = 'numInt:inf';
    msg = 'infinite integral - check with analytical solution';
    %exception = MException(msgID,msg);
    error(msgID,msg);
    %throw(exception);
end
dt = h;
end