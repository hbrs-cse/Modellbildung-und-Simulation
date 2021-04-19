function test_suite=test_quadraticSpline
% initialize unit tets
    try
        test_functions=localfunctions();
    catch
    end
    initTestSuite;

%%%%%%%%%%%%%%%%%%%%%%%
%     Basic tests     %
%%%%%%%%%%%%%%%%%%%%%%%
 
%% WIP: check more values on know parabola?

function test_quadraticSpline_Std05
% test function of quadraticSpline on Standardparabola
    z = [0, 1];
    x = [0, 1];
    assertVectorsAlmostEqual(quadraticSpline(x,z,0,0),0)
    
function test_quadraticSpline_Std0
% test function of quadraticSpline on Standardparabola
    z = [0, 1];
    x = [0, 1];
    assertVectorsAlmostEqual(quadraticSpline(x,z,0.5,0),0.25)
    
function test_quadraticSpline_Std1
% test function of quadraticSpline on Standardparabola
    z = [0, 1];
    x = [0, 1];
    assertVectorsAlmostEqual(quadraticSpline(x,z,1,0),1)

function test_quadraticSpline_Task
% test function of quadraticSpline on more complex Parabola from given task
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertVectorsAlmostEqual(quadraticSpline(x,z,0.35,0),0.006125)

function test_quadraticSpline_Derivate
% test if Derivates on edge of intervals are equal
    x = [0, 0.25, 1];
    z = [0, 0.0625, 1];
    zDer1 = 10^10*(quadraticSpline(x,z,0.25+10^-10,0)-quadraticSpline(x,z,0.25,0));
    zDer2 = 10^10*(quadraticSpline(x,z,0.25,0)-quadraticSpline(x,z,0.25-10^-10,0));
    assertVectorsAlmostEqual(zDer1,zDer2)    
    
%%%%%%%%%%%%%%%%%%%%%%%
% More advanced tests %
%%%%%%%%%%%%%%%%%%%%%%%

function test_quadraticSpline_exception_outofbounds
% test if exceptions are thrown for xfine outside x
    x = [0, 1];
    z = [0, 1];
    assertExceptionThrown(@()quadraticSpline(x,z,-1,0));
    
function test_quadraticSpline_exception_xzSizeDifference
% test if exceptions are thrown if x and z are of different size // not
% proper value pairs
    x = [0, 1];
    z = [0, 0.5, 1];
    assertExceptionThrown(@()quadraticSpline(x,z,0.3,0));
    
function test_quadraticSpline_exception_xNotSorted
% test if exceptions are thrown if x is not ordered
    x = [0 , 0.8, 0.3, 1];
    z = [0, 0.64, 0.09, 1];
    assertExceptionThrown(@()quadraticSpline(x,z,0.5,0));
    
function test_quadraticSpline_array
% test if quadraticSpline works on array inputs
    x = [0, 1];
    z = [0, 1];
    assertVectorsAlmostEqual(quadraticSpline(x,z,[0.2, 0.02, 0.45, 0.78],0),[0.04,   0.0004,   0.2025,   0.6084])
