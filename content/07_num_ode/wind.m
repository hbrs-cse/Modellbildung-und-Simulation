classdef wind < handle
    % wind is an object to create the excitation caused by
    % wind on a highline.
    properties
        amplitude = 0.1;         % amplitude of the nodal forces due to wind [N]
        frequency = 5.39506;    % frequency of the nodal forces due to wind [1/s]
        weights;                % nodal weights for the force evaluation
    end
    methods
        %% constructor (creates the object)
        function w = wind(N)
            w.weights = (1-linspace(-1,1,2*N).^2)';
        end % constructor
        %% excitation function
        function F = excitation(obj,t)
            
            F=obj.amplitude*obj.weights*sin(obj.frequency*t);
            
        end %excitation function
    end% methods
end