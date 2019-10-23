function [v_ave,q_ave] = trafficflow(density,max_speed,p_SF)

len         = 1000;   % the length of the road [cells]
T           = 3600;   % the simulation time [seconds]

    %<<<<<< ADD YOUR CODE HERE >>>>>>%

%% initial configuration

    %<<<<<< ADD YOUR CODE HERE >>>>>>%

%% main time loop
for i=1:T
    %1.) increase speed of all cars by one if speed is not max yet
    
        %<<<<<< ADD YOUR CODE HERE >>>>>>%
    
    %2.) decrease speed if it would cause a collision otherwise
    
        %<<<<<< ADD YOUR CODE HERE >>>>>>%
    
    %3.) decrease velocity of a random selection 
    %    of p_SF*num_cars by 1
    
        %<<<<<< ADD YOUR CODE HERE >>>>>>%
    
    %4.) move cars according to their speed
        
        %<<<<<< ADD YOUR CODE HERE >>>>>>%
        
    %5.) animate
    
        %<<<<<< ADD YOUR CODE HERE >>>>>>%


%calculate average velocity of all cars and time steps
    
    %<<<<<< ADD YOUR CODE HERE >>>>>>%

end;