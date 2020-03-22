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
    assertVectorsAlmostEqual(numInt(f,a,b,tol),0.5)
    
function test_numInt_negativeStartOfInterval
% test function of negative start of interval
    a = -1;
    b = 1;
    f = @(x) x;
    tol = 10^-6;
    assertVectorsAlmostEqual(numInt(f,a,b,tol),0)
    
function test_numInt_moreComplexFunction
% test function of x^3 + x
    a = -1;
    b = 1;
    f = @(x) x^3+x;
    tol = 10^-6;
    assertVectorsAlmostEqual(numInt(f,a,b,tol),0) 
    
%%%%%%%%%%%%%%%%%%%%%%%
% More advanced tests %
%%%%%%%%%%%%%%%%%%%%%%%

function test_numInt_invertedInterval
% test function of basic function
    a = 1;
    b = 0;
    f = @(x) x;
    tol = 10^-6;
    assertVectorsAlmostEqual(numInt(f,a,b,tol),-0.5)
    
function test_numInt_poleInIntervall
% test function of 
    a = -1;
    b = 1;
    f = @(x) 1/x;
    tol = 10^-6;
    numInt(f,a,b,tol)
    assertExceptionThrown(numInt(f,a,b,tol))  