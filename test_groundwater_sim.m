function test_suite=test_groundwater_sim
% initialize unit tets
    try
        test_functions=localfunctions();
    catch
    end
    initTestSuite;
end


    
function test_for_logical
% test if result contains only zeros and ones
    ground = groundwater_sim(100,100,0.1);
    assertElementsAlmostEqual(double(ground), double(logical(ground)));
end
    
function test_for_correct_size
% test if result contains only zeros and ones
    depth = randi(500);
    width = randi(500);
    ground = groundwater_sim(depth,width,0.1);
    assertEqual(size(ground),[depth width]);
end

function test_for_existing_parent
% test if each wetted cell has a origin in the layer above
    depth = randi(500);
    width = randi(500);
    ground = groundwater_sim(depth,width,rand);
    for i=2:depth
        js = find(ground(i,:));
        for j=js
            s=max(1,j-1);
            e=min(width,j+1);
            assert(any(ground(i-1,s:e)));
        end
    end
end
    
function test_num_wetted_cells_per_layer_rand
% test if the number of wetted cells in each layer is plausible
    ground = groundwater_sim(80,80,rand());
    for i=2:80
       nwetted_above = sum(ground(i-1,:));
       num_puddles = sum(abs(diff(ground(i-1,:))))/2;
       nwetted = sum(ground(i,:));
       assertTrue(nwetted <= nwetted_above+num_puddles*2);
    end
end

function test_num_wetted_cells_per_layer_deterministic
% test if the number of wetted cells in each layer is plausible
    % use probability = 2, so that definitely all three cells below a 
    % wetted cells will be wetted. This makes the simulation
    % deterministic;
    
    ground = groundwater_sim(80,80,2);
    
    expected = zeros(80,80);
    for i=1:80
        first = max([ 1,20-i]);
        last   = min([80,60+i]);
        expected(i,first:last)=1;
    end
    assertEqual(expected,ground);
end
        
    