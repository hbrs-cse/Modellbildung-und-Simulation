function test_suite=test_newton
% initialize unit tets
    try
        test_functions=localfunctions();
    catch
    end
    initTestSuite;
end

function test_for_correctsize
% test if result has correct size
    n = randi(10); % num inputs
    m = randi(10); % num outputs
    z = newton(@(x) zeros(m,1),zeros(n,1),1e-6,100);
    assertEqual(size(z), [n 1]);
end

function test_linear
% test convergence within one iteration for linear function
    n = randi(50);
    A = rand(n,n)*200 - 50;
    %if abs(a) < 1e-3
    %    a = 1e-3*sign(a);
    %end
    b = rand(n,1)*200 - 50;
    f = @(x) A*x + b;
    assertElementsAlmostEqual(newton(f,zeros(n,1),1,1), -A\b);
end

function test_2d_quadratic
    f = @(x) x(1).^2 + x(2).^2;
    assertElementsAlmostEqual(newton(f,[0.5;0.5],eps,100),[0;0],...
        'absolute',sqrt(eps))
end

function test_sin
% test convergence against different zeros of the sine
    f = @(x) sin(x);
    assertElementsAlmostEqual(newton(f,pi/4.1,1e-6,100), 0);
    assertElementsAlmostEqual(newton(f,3*pi/4.1,1e-8,100), pi);
end
