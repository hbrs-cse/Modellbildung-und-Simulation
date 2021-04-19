function test_suite=test_simple_newton
% initialize unit tets
    try
        test_functions=localfunctions();
    catch
    end
    initTestSuite;
end

function test_linear
% test convergence within one iteration for linear function
    m = rand(1,1)*200 - 50;
    b = rand(1,1)*200 - 50;
    f = @(x) m*x + b;
    df = @(x) m;
    assertElementsAlmostEqual(simple_newton(f,df,0,1,1), -m\b);
end

function test_2d_quadratic
    f = @(x) x^2 + x^2;
    df = @(x) 4*x;
    assertElementsAlmostEqual(simple_newton(f,df,1,eps,100),0,...
        'absolute',sqrt(eps))
end

function test_sin
% test convergence against different zeros of the sine
    f = @(x) sin(x);
    df = @(x) cos(x);
    assertElementsAlmostEqual(simple_newton(f,df,pi/4.1,1e-6,100), 0);
    assertElementsAlmostEqual(simple_newton(f,df,3*pi/4.1,1e-8,100), pi);
end
