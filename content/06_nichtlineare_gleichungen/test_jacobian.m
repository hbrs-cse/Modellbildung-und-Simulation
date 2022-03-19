function test_suite=test_jacobian
% initialize unit tets
    try
        test_functions=localfunctions();
    catch
    end
    initTestSuite;
end
    
function test_for_correctsize
% test if Jacobian has correct size
    n = randi(10);
    m = randi(10);
    J = jacobian(@(x) ones(m,1),zeros(n,1));
    assertEqual(size(J), [m,n]);
end

function test_jacobian_of_const
% test if Jacobian of contant function is zero
    n = randi(10);
    m = randi(10);
    c = rand(m,1)*1e3;
    f = @(x) c;
    x = rand(n,1)*1e3;
    assertElementsAlmostEqual(jacobian(f,x), zeros(m,n));
end

function test_linear
% test if jacobian(Ax+b) = A
    n = randi(50);
    A = rand(n,n)*2e2 - 1e2;
    b = rand(n,1)*2e2 - 1e2;
    
    f = @(x) A*x+b;
    x = rand(n,1)*1e3;
    
    assertElementsAlmostEqual(jacobian(f,x), A,'relative', 1e-3);
end

function test_exp
% test if jacobian(exp(x)) = exp(x)
    f = @exp;
    x = rand()*2-1;
    assertElementsAlmostEqual(jacobian(f,x),f(x),'relative',1e-3);
end

function test_log
% test if jacobian(log(x)) = 1/x;
    f = @log;
    x = rand()*2-1;
    if abs(x) < 1e-3
        x = 1e-3*sign(x);
    end
    assertElementsAlmostEqual(jacobian(f,x),1/x,'relative',1e-3);
end

function test_sin
% test if jacobian(sin(x)) = cos(x);
    x = rand()*2*pi;
    assertElementsAlmostEqual(jacobian(@sin,x),cos(x),'relative',1e-3);
end


function test_cos
% test if jacobian(cos(x)) = -sin(x);
    x = rand()*2*pi;
    assertElementsAlmostEqual(jacobian(@cos,x),-sin(x),'relative',1e-3);
end

function test_monomial
% test if jacobian(x^m) = m*x^(m-1)
    x = rand()*2-1;
    for m = -5:5
        f = @(x) x^m;
        fp = @(x) m*x^(m-1);
        assertElementsAlmostEqual(jacobian(f,x),fp(x),'relative',1e-3);
    end
end