classdef pedestrians < handle
    % pedestrians is an object to create the excitation caused by
    % pedestrians on a bridge.
    properties
        N;                      % no. of nodes of the bridge (i.e. mass points)
        L;                      % length of the bridge [m]
        weights;                % weights of the pedestrians
        velocity  = 1.7988;     % velocity of the pedestrians [m/s]
        frequency = 0.2863;     % frequency of pedestrians passing a point on the bridge [1/s]
    end
    methods
        %% constructor (creates the object)
        function p = pedestrians(N,L)
            p.weights=75 + 20*randn(1000,1); % random weights with mean=70kg, std = 20 kg
            p.N = N;
            p.L = L;
        end % constructor
        %% excitation function
        function F = excitation(obj,t)
            
            % allocate output vector
            F=zeros(2*obj.N,1);
            
            %length of a bridge segment between two nodes
            seglen = obj.L/(obj.N+1);
            
            %distance of two pedestrians
            dx = obj.velocity/obj.frequency;
            
            %position of the pedestrians
            x=obj.velocity*t:-dx:0;
            
            %restrict positions and weights to the bridge
            weight=obj.weights(x<=obj.L);
            x=x(x<=obj.L);
            
            for i=1:length(x)
                %find the two nearest nodes to the i-th pedestrians
                N0=floor(x(i)/seglen);
                N1=ceil(x(i)/seglen);
                
                %distribute the weight of the i-th pedestrian to the two
                %nearest nodes
                a=(x(i)-N0*seglen)/seglen;
                if N0>0 && N0<obj.N+1
                    F(2*N0)=-(1-a)*weight(i)*9.81;
                end
                if N1>0 && N1<obj.N+1
                    F(2*N1)=-a*weight(i)*9.81;
                end
            end
        end %excitation function
        %% positions(t) returns the horizontal positions of the pedestrians
        function x = positions(obj,t)
            
            %distance of two pedestrians
            dx = obj.velocity/obj.frequency;
            
            %position of the pedestrians
            x=obj.velocity*t:-dx:0;
            
            %restrict positions to the bridge
            x=x(x<obj.L);
        end %positions
    end% methods
end
