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
    
function test_quadraticSpline_0
% test if quadraticSpline(0)==1
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertVectorsAlmostEqual(quadraticSpline(x,z,0,0),0)

function test_quadraticSpline_2
% test if quadraticSpline(2)==0.2
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertVectorsAlmostEqual(quadraticSpline(x,z,2,0),0.2)

function test_quadraticSpline_0_35
% test if quadraticSpline(0.35)==0.0061
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertVectorsAlmostEqual(quadraticSpline(x,z,0.35,0),0.006125)
    
function test_quadraticSpline_1_112
% test if quadraticSpline(0.35)==0.0061
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertVectorsAlmostEqual(quadraticSpline(x,z,1.112,0),0.0618272)
    
%%%%%%%%%%%%%%%%%%%%%%%
% More advanced tests %
%%%%%%%%%%%%%%%%%%%%%%%

function test_quadraticSpline_exception_outofbounds
% test if exceptions are thrown for xfine outside x
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertExceptionThrown(@()quadraticSpline(x,z,-1,0));
    
function test_quadraticSpline_exception_xzSizeDifference
% test if exceptions are thrown for xfine outside x
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertExceptionThrown(@()quadraticSpline(x,z(1:3),-1,0));
    
function test_quadraticSpline_array
% test if quadraticSpline works on array inputs
    z = [0, 0.0125, 0.05, 0.1125, 0.2];
    x = 0:0.5:2;
    assertVectorsAlmostEqual(quadraticSpline(x,z,[0.37, 1.1778, 0.45, 1.12],0),[0.006845,   0.069360642,   0.010125,   0.06272])
