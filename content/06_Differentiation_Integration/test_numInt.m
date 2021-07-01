function test_suite=test_numInt
% initialize unit tets
    try
        test_functions=localfunctions();
    catch
    end
    initTestSuite;

%%%%%%%%%%%%%%%%%%%%%%%
%     Basic tests     %
%%%%%%%%%%%%%%%%%%%%%%%

function test_numInt_basic
% test function of basic function
    a = 0;
    b = 1;
    f = @(x) x;
    tol = 10^-6;
    [I, df] = numInt(f,a,b,tol);
    assertVectorsAlmostEqual(I,0.5)
    
function test_numInt_negativeStartOfInterval
% test function of negative start of interval
    a = -1;
    b = 1;
    f = @(x) x;
    tol = 10^-6;
    [I, df] = numInt(f,a,b,tol);
    assertVectorsAlmostEqual([I, df],[0, 2])
    
function test_numInt_moreComplexFunction
% test function of x^5 + x
    a = 0;
    b = 1;
    f = @(x) x^5+x;
    tol = 10^-6;
    [I, df] = numInt(f,a,b,tol);
    assertVectorsAlmostEqual([I, df],[2/3, 2^-10]) 
    
function test_numInt_stepsWidth
% test function of exp(x) to see if step width is correct
    a = -1;
    b = 1;
    f = @(x) exp(x);
    tol = 10^-6;
    [I, df] = numInt(f,a,b,tol);
    % !!! width (2^-9) determined via testing !!! 0.001953125000000
    assertVectorsAlmostEqual([I, df],[exp(1) - 1/exp(1), 2^-9]) 
    
function test_numInt_stepsWidth_2
% test function of 1-cos(-0.33*x.^2-0.1*x +1) where step width control is necessary
    a = 0;
    b = 10;
    f = @(x) 1-cos(-0.33*x.^2-0.1*x +1);
    tol = 10^-6;
    [I, df] = numInt(f,a,b,tol);
    assertVectorsAlmostEqual(I,integral(f, a, b)) 
    
%%%%%%%%%%%%%%%%%%%%%%%
% More advanced tests %
%%%%%%%%%%%%%%%%%%%%%%%

function test_numInt_invertedInterval
% test function of inverted interval (start after end)
    a = 1;
    b = 0;
    f = @(x) x;
    tol = 10^-6;
    [I, df] = numInt(f,a,b,tol);
    assertVectorsAlmostEqual(I,-0.5)
    
function test_numInt_poleInIntervall
% test function of 1/x
    a = -0.5;
    b = 1;
    f = @(x) 1/x;
    tol = 10^-6;
    assertExceptionThrown(@() numInt(f,a,b,tol))