function test_suite=test_my_eig
% initialize unit tets
    try
        test_functions=localfunctions();
    catch
    end
    initTestSuite;

function test_trace
% test if the trace remains unchanged
    dim=randi(10);
    A = rand(dim);
    trIn = sum(diag(A));
    trOut =  sum(my_eig(A, 2, -1));
    assertElementsAlmostEqual(trOut, trIn, 1e-8);

function test_diag
% test if diagonal matrices remain unchanged
    dim=randi(10);
    D = rand(dim,1);
    assertElementsAlmostEqual(my_eig(diag(D), 2, -1),D, 1e-8);

function test_2x2
% test the matrix on some 2x2 matrices, where the expected 
%result was precalculated by hand

    A=[-1 2; 4, 6];
    assertElementsAlmostEqual(my_eig(A, 200, 1e-10), [7;-2], 1e-8);
    
    A=[0.7, 0.4; 0.3 0.6];
    assertElementsAlmostEqual(my_eig(A, 200, 1e-10), [1;0.3], 1e-8);